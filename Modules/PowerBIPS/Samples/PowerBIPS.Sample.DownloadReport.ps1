cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

$authToken = Get-PBIAuthToken 

Set-PBIGroup -authToken $authToken -name "Demos - PBIFromTrenches" -Verbose

Export-PBIReport -authToken $authToken -destinationFolder "C:\Temp\PBIReports" -reportNames "MyMovies", "Sales Dashboard" -Verbose