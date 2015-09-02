cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

Set-PBIGroup -name "DemosGroup"

Get-PBIDataSet | Out-GridView

Set-PBIGroup -clear

Get-PBIDataSet | Out-GridView
