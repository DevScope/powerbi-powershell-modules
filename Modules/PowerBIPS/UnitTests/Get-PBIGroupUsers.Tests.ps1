
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent

Import-Module "$($ScriptDir)\PowerBIPS.psd1" -Force

$id = "ec52ae73-0e32-4abc-b5d6-a84f4ea55a63"

Describe 'Get-PBIGroupUsers' {

    
    It 'Given parameter groupId, it gets users that are members of a specific workspace ' {
      
        $users = Get-PBIGroupUsers -groupId $id
        
        #assert
        $users | Should -Not -BeNullOrEmpty

    }

}


