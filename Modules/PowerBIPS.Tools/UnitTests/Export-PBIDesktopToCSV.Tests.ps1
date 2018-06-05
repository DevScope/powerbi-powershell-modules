
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent


Import-Module "$($ScriptDir)\..\SQLHelper\SQLHelper.psd1" -Force
Import-Module "$($ScriptDir)\PowerBIPS.Tools.psd1" -Force




Describe 'Export-PBIDesktopToCSV' {

    
    It 'Given parameter pbiDesktopWindowName, it all the tables get exported' {

        $output = "$ScriptDir\UnitTests\CSVOutput"
     
        Export-PBIDesktopToCSV -pbiDesktopWindowName "*VanArsdel*" -outputPath $output

        #arrange
        $csv = $output |  Get-ChildItem -Filter *.csv | Select-Object -First 1
        
        #assert
        $output + "\" + $csv.Name | Should -Exist

    }

    It 'Given parameter pbiDesktopWindowName and especific table, it table get exported' {

        $output = "$ScriptDir\UnitTests\CSVOutput"

        $tables = @("product")
     
        Export-PBIDesktopToCSV -tables $tables -pbiDesktopWindowName "*VanArsdel*" -outputPath $output
        
        #assert
        $output + "\" + "$($tables[0]).csv" | Should -Exist

    }

    

}

