
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent


Import-Module "$($ScriptDir)\..\SQLHelper\SQLHelper.psd1" -Force
Import-Module "$($ScriptDir)\PowerBIPS.Tools.psd1" -Force




Describe 'Convert-PowerBIDesktopToASTabular' {

    
    It 'Given no parameter pbiDesktopWindowName, it file "model.bim" and "ssasproject.smproj" should exist' {

        $output = ".\SSASProj"
     
         Convert-PowerBIDesktopToASTabular -pbiDesktopWindowName "*VanArsdel*" -outputPath -$output

         ".\SSASProj\model.bim" | Should -Exist 

         ".\SSASProj\ssasproject.smproj" | Should -Exist

    }

    

}

