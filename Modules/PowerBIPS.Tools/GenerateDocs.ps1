Clear-Host

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module platyPS



Import-Module "$($currentPath)\..\SQLHelper\SQLHelper.psd1" -Force

Import-Module "$currentPath\PowerBIPS.Tools.psd1" -Force

$outputPath = "$currentPath\doc"

Remove-Item $outputPath -Force -Recurse

if (!(Test-Path $outputPath))
{
    New-MarkdownHelp -Module PowerBIPS.Tools -OutputFolder $outputPath -WithModulePage
}
else
{
    Update-MarkdownHelpModule -Path $outputPath -RefreshModulePage
}