cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

$sourceReport = Get-PBIReport -name "VanArsdel - Sales - DVS"

$targetReport = Get-PBIReport -name "Xpto"

$sourceReport | Set-PBIReportContent -targetReportId $targetReport.id

Get-PBIReport -name "VanArsdel - Sales - DVS" | Set-PBIReportContent -targetReportId (Get-PBIReport -name "VanArsdel - Sales - DVS").id