cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

$authToken = Get-PBIAuthToken -Verbose

#Set-PBIGroup -authToken $authToken -id "someID"

$reports= @(
    @{
        originalReportId="2073307d-3bxd-4165-916e-ca0aa2b95ed9"
        targetname="Copy of Report 1"
        targetWorkspaceId="b8cd99e3-d453-49b9-abd5-b34aef41571c"
        targetModelName="Dataset 1"
    }
    @{
        originalReportName="Report 2"
        targetname="Copy of Report 2"
        targetWorkspaceName="Workspace 2"
        targetModelID="38d98386-31cf-4590-9a75-8701fb17ef16"
    }
)

$newReportData = Copy-PBIReports -authToken $authToken -reportsObj $reports -Verbose

$newReportData | Out-GridView