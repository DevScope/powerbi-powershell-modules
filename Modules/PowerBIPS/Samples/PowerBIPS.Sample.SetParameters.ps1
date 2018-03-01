cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

$authToken = Get-PBIAuthToken -Verbose

#Set-PBIGroup -authToken $authToken -id "someWorkspaceID"

$parameters = @(
    @{
        name="SomeParameter"
        newValue="SomeValue"
    }
)

Set-PBIDatasetParameters -authToken $authToken -parameters $parameters -datasetNames "SomeDataset"

$updatedParameters = Get-PBIDatasetParameters -authToken $authToken -datasetNames "SomeDataset"
$updatedParameters | Format-Table