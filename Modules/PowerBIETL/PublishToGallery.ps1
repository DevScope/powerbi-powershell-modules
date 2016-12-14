cls

$ErrorActionPreference = "Stop"

Import-Module PowerShellGet

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

$modulePath = "$currentPath"

$outputPath = "$currentPath\Publish\PowerBIETL"

if (!(Test-Path $outputPath))
{
	New-Item $outputPath -type Directory -Force | Out-Null
}

#Copy-Item -Path "$modulePath\Samples\*" -Destination "$outputPath\Samples" -Verbose -Force -Container -Recurse

Copy-Item -Path "$modulePath\*" -Include @("*.psm1", "*.psd1", "*.dll", "*.json") -Destination "$outputPath\" -Verbose -Force

Publish-Module -path $outputPath -nugetAPIKey "c373728b-a7f1-4a5a-b223-19c5c60e0e02" -Verbose