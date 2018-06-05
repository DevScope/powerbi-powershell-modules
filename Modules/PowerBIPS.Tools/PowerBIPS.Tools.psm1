<# 

Copyright (c) 2017 DevScope

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

Function Convert-PowerBIDesktopToASTabular{ 
<#
.SYNOPSIS
A quick way to convert a Power BI Desktop file into an Analysis Services Tabular Project
.DESCRIPTION
A quick way to convert a Power BI Desktop file into an Analysis Services Tabular Project
.PARAMETER pbiDesktopWindowName
Power BI Desktop window name, wildcards can be used. Ex: "*name*"
.PARAMETER pbiDesktopPbiTemplatePath
Path to PowerBI Template
.PARAMETER outputPath
Path to the output folder
.PARAMETER removeInternalPBITables
This remove internal tables like "Localdate_XXXXXX"
.EXAMPLE
Convert-PowerBIDesktopToASTabular -pbiDesktopWindowName "*VanArsdel - Sales*" -outputPath ".\SSASProj"
#>
    [CmdletBinding()] 
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName = 'pbiDesktopWindowName')]
        [string]  
        $pbiDesktopWindowName
        ,
        [Parameter(Mandatory = $true, ParameterSetName = 'pbiDesktopPbiTemplatePath')]
        [string]  
        $pbiDesktopPbiTemplatePath
        ,
        [Parameter(Mandatory = $true)]
        [string]
        $outputPath
        ,
        [Parameter(Mandatory = $false)]
        [switch]
        $removeInternalPBITables
	)

    try
    { 
        if ($PSCmdlet.ParameterSetName -eq 'pbiDesktopPbiTemplatePath'){

            if(!(Test-Path  $pbiDesktopPbiTemplatePath)){
                throw "Template PBI Not found"             
            }

            $bytes = [System.IO.File]::ReadAllBytes($pbiDesktopPbiTemplatePath)

            $encoding = [System.Text.Encoding]::Unicode
                
            $modelSchema = Get-ZipSection -bytes $bytes -entryName "DataModelSchema" -encoding $encoding

            $deserializeOptions = new-object Microsoft.AnalysisServices.Tabular.DeserializeOptions                    

            $database = [Microsoft.AnalysisServices.Tabular.JsonSerializer]::DeserializeDatabase($modelSchema,$deserializeOptions)                       
        
        }else{  

            # Get the PBI window port
     
            $port = Get-PBIDesktopTCPPort $pbiDesktopWindowName

            $dataSource = "localhost:$port"
            
            $server = New-Object Microsoft.AnalysisServices.Tabular.Server

            $server.Connect($dataSource)

            $database = $server.Databases[0]

        }

	    #remove internal tables

        if($removeInternalPBITables){

            $relationships = $database.Model.Relationships | where {$_.ToTable.Name -Match "LocalDateTable"}
        
            $relationships |% {
      
                $database.Model.Relationships.Remove($_.Name)
       
            }

            $LocalDate = $database.Model.Tables | where {$_.Name -Match "DateTableTemplate" -or $_.Name -Match "LocalDateTable"}

            $LocalDate |% {

               $database.Model.Tables.Remove($_.Name)  
            }
        }
        
        #each tables

        $database.Model.Tables |% {
            
            $table = $_

            if($removeInternalPBITables)
            {
                $table.Columns |% {$_.Variations.Clear()}
            }

            $table.Partitions |% {

                $partition = $_

                if ($partition.SourceType -eq "Query")
                {                
                    Write-Verbose "Converting partition $($partition.Name)"

                    $mExpression = Get-MCodeFromPBIDataSource $partition
                    
                    if ($mExpression[0].hiddenTable -eq $false )
                    {                    
                        $mExpression = $mExpression.expression
                    }
                    else
                    {                        
                       foreach($obj in $mExpression) 
                       {
                            if ($obj.name.Trim() -eq $table.Name.Trim()) 
                            { 
                                $mExpression = $obj.expression 
                            }                            
                            else 
                            {
                                $exist = $database.Model.Expressions |? { $_.Name.Trim() -eq $obj.name.Trim() }

                                if ($exist.Count -eq 0 -and -not($obj.name.Trim().Contains("QueryBinding")))
                                {
                                    $ex = new-object Microsoft.AnalysisServices.Tabular.NamedExpression

                                    $ex.Name = $obj.name.Trim()

                                    $ex.Kind = new-object Microsoft.AnalysisServices.Tabular.ExpressionKind

                                    $ex.Description = ""

                                    $ex.Expression = $obj.expression

                                    $database.Model.Expressions.Add($ex)
                                } 
                            }                          
                        }
                       
                    }                
                    
                    $mPartitionSource = new-object Microsoft.AnalysisServices.Tabular.MPartitionSource                
                    
                    $mPartitionSource.Expression = $mExpression

                    $partition.Source = $mPartitionSource                
                }
            }

        }        
        
        $database.Model.DataSources.Clear()

        $serializeOptions = new-object Microsoft.AnalysisServices.Tabular.SerializeOptions        
        $serializeOptions.IgnoreTimestamps = $true
        $serializeOptions.IgnoreInferredProperties = $true
        $serializeOptions.IgnoreInferredObjects = $true
        
        $dbJson = [Microsoft.AnalysisServices.Tabular.JsonSerializer]::SerializeDatabase($database, $serializeOptions)

        New-Item -ItemType Directory -Path $outputPath -ErrorAction SilentlyContinue | Out-Null
       
        $dbJson | Out-File $outputPath\model.bim -Force

        if (!(Test-Path "$outputPath\ssasproject.smproj"))
        {
            $projectId = (New-Guid).ToString()

            $projectXml = "<?xml version=""1.0"" encoding=""utf-8""?>
                <Project ToolsVersion=""4.0"" DefaultTargets=""Build"" xmlns=""http://schemas.microsoft.com/developer/msbuild/2003"">
                  <PropertyGroup>
                    <Configuration Condition="" '`$(Configuration)' == '' "">Production</Configuration>
                    <SchemaVersion>2.0</SchemaVersion>
                    <ProjectGuid>{$projectId}</ProjectGuid>              
                    <OutputPath>bin\</OutputPath>
                    <Name>SSASProject</Name>
                  </PropertyGroup> 
                  <PropertyGroup Condition="" '`$(Configuration)' == 'Development' "">
                        <OutputPath>bin\</OutputPath>                        
                    </PropertyGroup> 
                  <ItemGroup>
                    <Compile Include=""Model.bim"">
                      <SubType>Code</SubType>
                    </Compile>
                  </ItemGroup>
                  <Import Project=""`$(MSBuildExtensionsPath)\Business Intelligence Semantic Model\1.0\Microsoft.AnalysisServices.VSHostBuilder.targets"" />
                </Project>"   

             $projectXml | Out-File "$outputPath\ssasproject.smproj" -Force
        }       

        Write-Verbose "Process finished"
    }
    finally
    {
        if ($server) { $server.Dispose() }
    }   
}

Function Export-PBIDesktopToCSV
{
<#
.SYNOPSIS
A way to export all your Power BI Desktop model tables into CSV files
.DESCRIPTION
A way to export all your Power BI Desktop model tables into CSV files
.PARAMETER pbiDesktopWindowName
Power BI Desktop window name, wildcards can be used. Ex: "*name*"
.PARAMETER tables
The tables to be exported - if empty all the tables get exported
.PARAMETER outputPath
Path to the output folder
.EXAMPLE
Export-PBIDesktopToCSV -pbiDesktopWindowName "*Van Arsdel*" -outputPath ".\CSVOutput"
.EXAMPLE
Export-PBIDesktopToCSV -tables @("product") -pbiDesktopWindowName "*Van Arsdel*" -outputPath ".\CSVOutput"
#>
    [CmdletBinding()]
	param(		        
        [Parameter(Mandatory = $true)]        
		[string]
        $pbiDesktopWindowName,
		[Parameter(Mandatory = $false)]        
		[string[]] $tables,
		[Parameter(Mandatory = $true)]    
		[string] $outputPath		
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
		$modelTables = Invoke-SQLCommand -providerName "System.Data.OleDb" -connectionString $ssasConnStr -executeType "Query" -commandText "select [Name] from `$SYSTEM.TMSCHEMA_TABLES"
		
		$tables = $modelTables |% {$_.Name}
	}

    if (-not (Test-Path $outputPath))
    {
        [System.IO.Directory]::CreateDirectory($outputPath) | Out-Null
    }
		
	$tables |% {
    
        try
        {
            
		    $daxTableName = $_							    
		
		    Write-Verbose "Moving data from '$daxTableName' into CSV File"
		
		    $reader = Invoke-SQLCommand -providerName "System.Data.OleDb" -connectionString $ssasConnStr `
			    -executeType "Reader" -commandText "EVALUATE('$daxTableName')" 
		
		    Write-Verbose "Copying data from into '$tableCsvPath'"
  
            $tableCsvPath = "$outputPath\$daxTableName.csv"

            $textWriter = New-Object System.IO.StreamWriter($tableCsvPath, $false, [System.Text.Encoding]::UTF8)

            $csvWriter = New-Object CsvHelper.CsvWriter($textWriter)                   
  
            $csvWriter.Configuration.CultureInfo.NumberFormat.NumberDecimalSeparator # read only

            $rows=0

            $fieldCount=0

            if ($reader.Read())
            {
                $fieldCount=$reader.FieldCount

                for ($fieldOrdinal = 0; $fieldOrdinal -lt $fieldCount; $fieldOrdinal++)
                {
                    $colName=$reader.GetName( $fieldOrdinal ).Replace("[","").Replace("]","")
			        $csvWriter.WriteField( $colName );                 
                }

                $csvWriter.NextRecord();
            
                $rows++

                for ($fieldOrdinal = 0; $fieldOrdinal -lt $fieldCount; $fieldOrdinal++)
                {
                    $fieldValue=$reader[$fieldOrdinal ];             
                    $csvWriter.WriteField($fieldValue);                 
                }

                $csvWriter.NextRecord();

                if($rows % 5000 -eq 0)
                {
                    Write-Verbose "Inserted $rows rows into '$tableCsvPath'... "
                }
                
            }

            Write-Verbose "Fields in dataset '$fieldCount'"

            while($reader.Read())
	        {
                $rows++

                for ($fieldOrdinal = 0; $fieldOrdinal -lt $fieldCount; $fieldOrdinal++)
                {                    
                    $fieldValue=$reader[$fieldOrdinal ];             
                    $csvWriter.WriteField($fieldValue);                 
                }

                $csvWriter.NextRecord();

                if($rows % 5000 -eq 0)
                {
                    Write-Verbose "Inserted $rows rows into '$tableCsvPath'... "
                }

            }             
		
	        Write-Verbose "Inserted $rows rows into '$tableCsvPath' "
        }
        finally
        {                
            if ($reader -ne $null)
            {
                $reader.Dispose()
            }

            if ($textWriter -ne $null)
            {
                $textWriter.Dispose()
            }

        }
		
	}        			
}

Function Get-PBIDataSetFromPBIDesktop 
{
<#
.SYNOPSIS
A quick way to convert a Power BI Desktop file in a REST API enabled dataset
.DESCRIPTION
A quick way to convert a Power BI Desktop file in a REST API enabled dataset
.PARAMETER datasetName
Name to Dataset
.PARAMETER pbiDesktopWindowName
Power BI Desktop window name, wildcards can be used. Ex: "*name*"
.EXAMPLE
Get-PBIDataSetFromPBIDesktop -datasetName $datasetName -pbiDesktopWindowName "*RealTime*"
#>
[CmdletBinding()]
param(		        
    [Parameter(Mandatory = $true)]        
    [string]
    $pbiDesktopWindowName,
    [Parameter(Mandatory = $true)]        
    [string]$datasetName
  ) 
 
    #get port and database model
    
    $port = Get-PBIDesktopTCPPort $pbiDesktopWindowName

    $dataSource = "localhost:$port"
    
    $server = New-Object Microsoft.AnalysisServices.Tabular.Server

    $server.Connect($dataSource)

    $database = $server.Databases[0]

    $dataSetSchema = @{

        name = $datasetName

        ;tables = @()

        ;relationships = @()
    }
    
    #for each Relationships

    $relationships = $database.Model.Relationships | ? {$_.ToTable.Name -NotMatch "LocalDateTable"}

    $relationships |% {

        $relationship = $_

        $props = @{ 

              name = $relationship.Name

            ; fromTable = $relationship.FromTable.Name

            ; fromColumn = $relationship.FromColumn.Name

            ; toTable = $relationship.ToTable.Name

            ; toColumn = $relationship.ToColumn.Name
            
            ; crossFilteringBehavior = $relationship.CrossFilteringBehavior.ToString()
        }
        
        $dataSetSchema.relationships +=  $props
    }

    #for each tables

    $tables = $database.Model.Tables | ? {!$_.Name.StartsWith("DateTableTemplate") -and !$_.Name.StartsWith("LocalDateTable")}

    $tables |% {
            
        $table = $_
        
        $newTable = @{

            name = $table.Name

            ;columns = @()

            ;measures = @()
        }

        #for each columns

        $columns = $table.Columns | ? {!$_.Name.StartsWith("RowNumber")}

        $columns |% {

            $column = $_

            $props = @{ 
                name = $column.Name

              ; dataType = $column.DataType.ToString()

              ; isHidden = $column.isHidden
            }

            $newTable.columns +=  $props
            
        }

        #for each measures

        $table.Measures |% {

            $measure = $_

            $props = @{ 
                name = $measure.Name

              ; expression = $measure.Expression

              ; formatString = $measure.FormatString
            }

            $newTable.measures +=  $props

        }

        $dataSetSchema.tables += $newTable
    }

   $dataSetSchema
}
Function Export-PBIDesktopToSQL
{      
<#
.SYNOPSIS
A way to export all your Power BI Desktop model tables into a SQL Server Database
.DESCRIPTION
A way to export all your Power BI Desktop model tables into a SQL Server Database
.PARAMETER pbiDesktopWindowName
Power BI Desktop window name, wildcards can be used. Ex: "*name*"
.PARAMETER tables
The tables to be exported - if empty all the tables get exported
.PARAMETER sqlConnStr
The SQL Server connection string
.PARAMETER sqlSchema
The target sql server schema where all the tables will be created (if not exists)
.EXAMPLE
Export-PBIDesktopToSQL -pbiDesktopWindowName "*Van Arsdel*" -sqlConnStr "Data Source=.\sql2017; Initial Catalog=Dummy; Integrated Security=true" -sqlSchema "stg" -Verbose
.EXAMPLE
Export-PBIDesktopToSQL -tables @("Product") -pbiDesktopWindowName "*Van Arsdel*" -sqlConnStr "Data Source=.\sql2017; Initial Catalog=Dummy; Integrated Security=true" -sqlSchema "stg" -Verbose
#>
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
		$modelTables = Invoke-SQLCommand -providerName "System.Data.OleDb" -connectionString $ssasConnStr -executeType "Query" -commandText "select [Name] from `$SYSTEM.TMSCHEMA_TABLES"
		
		$tables = $modelTables |% {$_.Name}
	}
		
	$tables |% {
    
        try
        {

		    $daxTableName = $_				
		
		    $sqlTableName = "[$sqlSchema].[$daxTableName]"
		
		    Write-Verbose "Moving data from '$daxTableName' into '$sqlTableName'"
		
		    $reader = Invoke-SQLCommand -providerName "System.Data.OleDb" -connectionString $ssasConnStr `
			    -executeType "Reader" -commandText "EVALUATE('$daxTableName')" 
		
		    $rowCount = Invoke-SQLBulkCopy -connectionString $sqlConnStr -tableName $sqlTableName -data @{reader=$reader} -Verbose
		
		    Write-Verbose "Inserted $rowCount rows"
        
        }
        finally
        {            
            if ($reader -ne $null)
            {
                $reader.Dispose()
            }
        }		
	}

}

Function Get-PBIDesktopTCPPort
{  
<#
.SYNOPSIS
Returns the Power BI Desktop Analysis Services Instance TCP Port
.DESCRIPTION
Returns the Power BI Desktop Analysis Services Instance TCP Port
.PARAMETER pbiDesktopWindowName
Power BI Desktop window name, wildcards can be used. Ex: "*name*"
.EXAMPLE
Get-PBIDesktopTCPPort -pbiDesktopWindowName "*VanArsdel - Sales*"
#>
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
		throw "No PBIDesktop window that match '$pbiDesktopWindowName'"
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

#region Private

Function Get-MCodeFromPBIDataSource
{    
    param
    (
        [Parameter(Mandatory = $true)]        		
        $partition
    )

    $connStr = $partition.Source.DataSource.ConnectionString

    $connStrBuilder = New-Object System.Data.Common.DbConnectionStringBuilder

    $connStrBuilder.set_ConnectionString($connStr)

    $mashupBase64 = [string]$connStrBuilder["mashup"]

    $bytes = [System.Convert]::FromBase64String($mashupBase64)
    
    $mExpression = Get-ZipSection -bytes $bytes -entryName "Section1.m"
 
    $mExpression = Get-CleanMCode -mcode $mExpression

    Write-Output $mExpression
}

Function Get-ZipSection ($bytes, [string] $entryName, [System.Text.Encoding] $encoding = [System.Text.Encoding]::UTF8)
{  
    try {        
        Add-Type -Assembly 'System.IO.Compression' 

        $ms = New-Object System.IO.MemoryStream (,$bytes)

        $zip = New-Object System.IO.Compression.ZipArchive($ms)

        $section = @($zip.Entries |? { $_.Name -eq $entryName })

        if ($section.Count -eq 0)
        {
            throw "Cannot find entry '$entryName'"
        }

        $deflateStream = $section[0].Open()

        $streamReader = New-Object System.IO.StreamReader($deflateStream, $encoding) 
                
        $entryText = $streamReader.ReadToEnd()

        Write-Output $entryText
    }
    finally {
        if ($streamReader) { $streamReader.Dispose() }
        if ($deflateStream) { $deflateStream.Dispose() }
        if ($zip) { $zip.Dispose() }
        if ($ms) { $ms.Dispose() }
    }         
}
Function Get-CleanMCode{    
    param
    (
        [Parameter(Mandatory = $true)]        
		[string]
        $mcode 
    )

    $colletion = @()
    $hiddenTable = $mcode -split "shared"

    if($hiddenTable.Count -eq 2){

        #match
        $match = [System.Text.RegularExpressions.Regex]::Match($mcode,'let(?s:.)*Table.FromValue[^\,]*')
        
        if($match.Success){ $value=$match.Value }

        #fisrt Mcode
        $first = $value.IndexOf('AutoRemovedColumns1 =')

        $first = $value.Substring(0,$first).Trim()

        $first = $first.Substring(0,$first.Length-1)

        #last Mcode
        $last = $value.Split('(')

        $last = $last[$last.Count-1]

        $M = New-Object PSObject -Property @{
             hiddenTable = $false
             expression = "$first in $last"
             name = ""
        }

        $colletion += $M

    }else{ # contains hidden tables;

       # lets create expressions for each shared
      
       $ex = $mcode.Split(';')

        For ($i=1; $i -lt $ex.Count-1; $i++) {

            $ex[$i] = $ex[$i].Trim()

            $ex[$i] = $ex[$i].Remove(0,6)

            $tam = $ex[$i].indexOf('=') + 1

            $M = New-Object PSObject -Property @{
                 hiddenTable = $true
                 expression = $ex[$i].Substring($tam,$ex[$i].Length-$tam)
                 name = $ex[$i].Split('=')[0]
             } 

            $colletion += $M
         }
    }

    $colletion
}

#endregion