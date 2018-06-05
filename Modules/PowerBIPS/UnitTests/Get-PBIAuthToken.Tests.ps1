
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent

Import-Module "$($ScriptDir)\PowerBIPS.psd1" -Force

$user = "xxxx@devscope.net"

$pass = "*******"

Describe 'Get-PBIAuthToken' {

    
    It 'Given parameter clientId, it come access token' {

       $PbiAuthToken = Get-PBIAuthToken -clientId "053e0da1-7eb4-4b9a-aa07-6f41d0f35cef"
        
        #assert
        $PbiAuthToken | Should -Not -BeNullOrEmpty

    }

    It 'Given parameter Credential, it come access token' {

        #arrange
        $credential = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $user, $(convertto-securestring $pass -asplaintext -force)
        
        $PbiAuthToken = Get-PBIAuthToken -Credential $credential
         
         #assert
         $PbiAuthToken | Should -Not -BeNullOrEmpty
 
     }

}

