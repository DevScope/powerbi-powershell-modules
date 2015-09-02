cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

$authToken = Get-PBIAuthToken -Verbose

#Get-PBIDataSet -authToken $authToken | Out-GridView

$id = Import-PBIFile -authToken $authToken -filePath "$currentPath\PBIX\MyMovies.pbix"  -verbose

$importResult = Get-PBIImports $authToken -importId $id.id

$importResult | Out-GridView