cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

$authToken = Get-PBIAuthToken 

Set-PBIGroup -authToken $authToken -name "Demos - PBIFromTrenches" -Verbose

Set-PBIReportsDataset -authToken $authToken -reportNames "MyMovies", "BestMovies" -datasetName "MoviesDataset" -Verbose