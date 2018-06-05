
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent

Import-Module "$($ScriptDir)\PowerBIPS.psd1" -Force

$id = "0ac7d145-dc55-4b4d-b683-273b7ea7b8ca"

Describe 'New-PBIGroupUser' {

    
    It 'Given parameter groupId and EmailAddress and GroupUserAccessRight, it create new user to an existing group (app workspace) in PowerBI ' {
      
        #arrange

        $acessRight = "Admin"

        $email = "rui.romano@devscope.net"

        $clientId = "053e0da1-7eb4-4b9a-aa07-6f41d0f35cef"

        $authToken = Get-PBIAuthToken -clientId $clientId

        $user = New-PBIGroupUser -authToken $authToken -emailAddress $email -groupId $id -groupUserAccessRight $acessRight
        
        #assert

        $user | Should -BeNullOrEmpty

    }

}


