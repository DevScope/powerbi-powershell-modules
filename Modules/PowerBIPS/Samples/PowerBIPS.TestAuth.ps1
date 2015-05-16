cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS.psm1" -Force

# Get the authentication token using ADAL library (OAuth)
$authToken = Get-PBIAuthToken -clientId "7a7be4f7-c64d-41da-94db-7fb8200f029c"

$ds = Get-PBIDataSet -authToken $authToken