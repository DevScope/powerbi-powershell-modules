cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIETL" -Force

Export-PBIDesktopToCSV -pbiDesktopWindowName "*Foliar*" -outputPath "$currentPath\Output"

