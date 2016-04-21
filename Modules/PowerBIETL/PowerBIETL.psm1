<# 

Checkout more products and samples at:
	- http://devscope.net/
	- https://github.com/DevScope

PowerBI API documentation:

	- https://msdn.microsoft.com/library/dn877544

Copyright (c) 2015 DevScope

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

#>

Function Export-PBIDesktopToSQL
{      
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]        
		[string]
        $pbiDesktopWindowName,
		[Parameter(Mandatory = $false)]        
		[string[]] $tables,
		[Parameter(Mandatory = $true)]        
		[string]
        $sqlConnStr,
		[Parameter(Mandatory = $false)]        
		[string]
        $sqlSchema = "dbo"		
    )

	$port = Get-PBIDesktopTCPPort $pbiDesktopWindowName
	
	$dataSource = "localhost:$port"
	
	Write-Verbose "Connecting into PBIDesktop TCP port: '$dataSource'"
	
	$ssasConnStr = "Provider=MSOLAP;data source=$dataSource;"
	 	
	$ssasDBId = (Invoke-SQLCommand -providerName "System.Data.OleDb" -connectionString $ssasConnStr `
     -executeType "Query" -commandText "select DATABASE_ID from `$SYSTEM.DBSCHEMA_CATALOGS").Database_id

	$ssasConnStr += "Initial Catalog=$ssasDBId"
	
	if ($tables -eq $null -or $tables.Count -eq 0)
	{
		$modelTables = Invoke-SQLCommand -providerName "System.Data.OleDb" -connectionString $ssasConnStr -executeType "Query" -commandText "select [Name] from `$SYSTEM.TMSCHEMA_TABLES where not [IsHidden]"
		
		$tables = $modelTables |% {$_.Name}
	}
		
	$tables |% {
    
		$daxTableName = $_				
		
		$sqlTableName = "[$sqlSchema].[$daxTableName]"
		
		Write-Verbose "Moving data from '$daxTableName' into '$sqlTableName'"
		
		$reader = Invoke-SQLCommand -providerName "System.Data.OleDb" -connectionString $ssasConnStr `
			-executeType "Reader" -commandText "EVALUATE('$daxTableName')" 
		
		$rowCount = Invoke-SQLBulkCopy -connectionString $sqlConnStr -tableName $sqlTableName -data @{reader=$reader} -Verbose
		
		Write-Verbose "Inserted $rowCount rows"
		
	}
}

Function Get-PBIDesktopTCPPort
{  
	[CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]        
		[string]
        $pbiDesktopWindowName	
    )
	
	$pbiProcesses = get-process |? ProcessName -eq "PBIDesktop" | select Id, ProcessName, MainWindowTitle |? MainWindowTitle -ne "" 
		
	$pbiProcessesPorts = Get-NetTCPConnection -OwningProcess @($pbiProcesses | Select -ExpandProperty Id) |? State -eq "Established" | Select OwningProcess, RemotePort
	
	if ($pbiProcesses.Count -eq 0 -or $pbiProcessesPorts.Count -eq 0)
	{
		throw "No PBIDesktop windows opened"
	}
	
	$matchedWindows = $pbiProcesses |? MainWindowTitle -like $pbiDesktopWindowName
	
	if ($matchedWindows.Count -eq 0)
	{
		throw "No PBIDesktop window that match '*$pbiDesktopWindowName*'"
	}
	
	# Select the first match
	
	$matchedProcess = $matchedWindows[0]
	$matchedProcessTitle = $matchedProcess.MainWindowTitle
	
	Write-Verbose "Processing PBIDesktop file: '$matchedProcessTitle'"
	
	$processPorts = $pbiProcessesPorts |? OwningProcess -eq $matchedProcess.Id
	
	if ($processPorts.Count -eq 0)
	{
		throw "No TCP Port for PBIDesktop process '$matchedProcessTitle"
	}
	
	$port = $processPorts[0].RemotePort
	
	$port
}