cls


$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module platyPS

Import-Module "$currentPath\PowerBIPS.psd1" -Force

$outputPath = "$currentPath\doc"

Remove-Item $outputPath -Force -Recurse

if (!(Test-Path $outputPath))
{
    New-MarkdownHelp -Module PowerBIPS -OutputFolder $outputPath -WithModulePage
}
else
{
    Update-MarkdownHelpModule -Path $outputPath -RefreshModulePage
}