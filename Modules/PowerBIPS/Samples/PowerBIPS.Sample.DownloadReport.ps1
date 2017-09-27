cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

$authToken = Get-PBIAuthToken -ForceAskCredentials -Verbose

Set-PBIGroup -authToken $authToken -name "Sales" -Verbose

Export-PBIReport -authToken $authToken -reportNames "Report1" -destinationFolder "C:\Reports" -Verbose