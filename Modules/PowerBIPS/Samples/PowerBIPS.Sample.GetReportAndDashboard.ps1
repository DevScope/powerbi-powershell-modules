cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

# Get the authentication token using ADAL library (OAuth)

$group = Get-PBIGroup | Select -First 1

$groupId = $group.id

$report = Get-PBIReport -groupId $groupId | Select -First 1

$report

$dashboard = Get-PBIDashboard | Select -First 1

$tiles = $dashboard | Get-PBIDashboardTile

$tiles