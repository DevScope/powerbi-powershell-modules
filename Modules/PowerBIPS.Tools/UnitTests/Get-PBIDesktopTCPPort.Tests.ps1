
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent


Import-Module "$($ScriptDir)\..\SQLHelper\SQLHelper.psd1" -Force
Import-Module "$($ScriptDir)\PowerBIPS.Tools.psd1" -Force




Describe 'Get-PBIDesktopTCPPort' {

    
    It 'Given parameter pbiDesktopWindowName, it pbiDesktop tcp port returns ' {


       $tcpPort = Get-PBIDesktopTCPPort -pbiDesktopWindowName "*VanArsdel*"
        
        #assert
        $tcpPort | Should -BeGreaterThan 0

    }

}

