# Clear the screen

cls

# On error stop the script

$ErrorActionPreference = "Stop"

# Get the current folder of the running script

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

# Import the PowerBIPS Powershell Module: https://github.com/DevScope/powerbi-powershell-modules

Import-Module "$currentPath\Modules\PowerBIPS" -Force

# Ensure the Archive Folder 

New-Item -Name "Archive" -Force -ItemType directory -Path "$currentPath\CSVData" | Out-Null

$authToken = Get-PBIAuthToken -ForceAskCredentials

# Clear "CSVSales" dataset

Clear-PBITableRows -authToken $authToken -dataSetName "CSVSales" -tableName "Sales" -ErrorAction SilentlyContinue

while($true)
{
    # Iterate each CSV file and send to PowerBI

    Get-ChildItem "$currentPath\Data\CSVData" -Filter "*.csv" |% { 

        $file = $_               

        #Import csv and add column with filename
		
        $data = Import-Csv $file.FullName | select @{Label="File";Expression={$file.Name}}, @{Label="FileDate";Expression={[System.DateTime]::Now.ToString("yyyy-MM-dd HH:mm:ss")}}, *

        # Send data to PowerBI

        $data | Out-PowerBI -authToken $authToken -dataSetName "CSVSales" -tableName "Sales" `
			-types @{"Sales.FileDate"="datetime";"Sales.OrderDate"="datetime"; "Sales.SalesAmount"="double"; "Sales.Freight"="double"} `
			-batchSize 25 -ForceTableSchemaUpdate -verbose

        # Archive the file

        Move-Item $file.FullName "$currentPath\Data\CSVData\Archive\" -Force
    }
  
    Write-Output "Sleeping..."

    Sleep -Seconds 5
}

Write-Output "Script Ended"