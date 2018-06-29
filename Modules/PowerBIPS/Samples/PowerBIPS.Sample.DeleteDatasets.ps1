cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

# Get the authentication token using ADAL library (OAuth)

$groupId = "94dc590b-5679-4ad3-bb74-ec1c9d34c273"

Get-PBIDataSet -groupId $groupId |? name -Like "Sales Dashboard*" | Remove-PBIDataSet -Verbose
