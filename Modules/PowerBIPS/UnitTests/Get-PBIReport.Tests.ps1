
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent

Import-Module "$($ScriptDir)\PowerBIPS.psd1" -Force

#arrange

$groupId = "0c2946c5-63c1-4de6-bb1f-f7a39470d9ec"

$reportId = "b2c1cab9-0fa4-49f1-879e-9e09611255ea"

$authToken = Get-PBIAuthToken -clientId "053e0da1-7eb4-4b9a-aa07-6f41d0f35cef"

$reportName = "FilterByList_"

Describe 'Get-PBIReport' {

    
    It 'Given parameter Id, it get report ' {
      
        $report = Get-PBIReport -authToken $authToken -id $reportId -groupId $groupId

        #assert
        $report.Id | Should -BeExactly $reportId

    }

    It 'Given parameter name, it get report ' {
      
       
        $report = Get-PBIReport -authToken $authToken -name $reportName -groupId $groupId

        #assert
        $report.Id | Should -BeExactly $reportId

    }

}


