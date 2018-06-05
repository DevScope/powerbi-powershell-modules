
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent

Import-Module "$($ScriptDir)\PowerBIPS.psd1" -Force

$name = "test"

Describe 'New-PBIGroup' {

    
    It 'Given parameter name, it Creates a new group (app workspace) in PowerBI ' {
      
        $newGroup = New-PBIGroup -name $name
        
        #assert
        $newGroup.Name | Should -BeExactly $name

    }

}


