
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent


Import-Module "$($ScriptDir)\..\SQLHelper\SQLHelper.psd1" -Force
Import-Module "$($ScriptDir)\PowerBIPS.Tools.psd1" -Force




Describe 'Get-PBIDataSetFromPBIDesktop' {

    
    It 'Given parameter pbiDesktopWindowName and dataset name, it dataset schema returns ' {

        $datasetName = "VanArsdel"
     
       $dataSetSchema = Get-PBIDataSetFromPBIDesktop -datasetName $datasetName -pbiDesktopWindowName "*VanArsdel*"
        
        #assert
        $dataSetSchema | Should -BeOfType [hashtable]

    }

}

