
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent

Import-Module "$($ScriptDir)\PowerBIPS.psd1" -Force

$id = "ec52ae73-0e32-4abc-b5d6-a84f4ea55a63"

$name = "teste"

Describe 'Set-PBIGroup and Get-PBIGroup' {

    
    It 'Given parameter groupId, it set default groupID in module ' {
      
        Set-PBIGroup -id $id

        $Group = Get-PBIGroup -id $id
        
        #assert
        $Group.id | Should -BeExactly $id

    }

    It 'Given parameter name, it set default groupID in module ' {
      
        Set-PBIGroup -id $name

        $Group = Get-PBIGroup -name $name

        #assert
        $Group.name | Should -BeExactly $name

    }

}


