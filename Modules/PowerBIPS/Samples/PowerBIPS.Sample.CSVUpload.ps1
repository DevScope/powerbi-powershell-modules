cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

#Create Archive Folder 

New-Item -Name "Archive" -Force -ItemType directory -Path "$currentPath\CSVData" | Out-Null

Import-Module "$currentPath\..\PowerBIPS" -Force

while($true)
{
    # Iterate each CSV file and send to PowerBI

    Get-ChildItem "$currentPath\CSVData" -Filter "*.csv" |% { 

        $file = $_               

        #Import csv and add column with filename

        $data = Import-Csv $file.FullName | select @{Label="File";Expression={$file.Name}}, *

        # Send data to PowerBI

        $data |  Out-PowerBI -dataSetName "CSVSales" -tableName "Sales" -types @{"Sales.OrderDate"="datetime"; "Sales.SalesAmount"="double"; "Sales.Freight"="double"} -batchSize 300 -verbose

        # Archive the file

        Move-Item $file.FullName "$currentPath\CSVData\Archive\" -Force
    }
  
    Write-Output "Sleeping..."

    Sleep -Seconds 5
}