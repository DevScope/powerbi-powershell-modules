
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent


Import-Module "$($ScriptDir)\..\SQLHelper\SQLHelper.psd1" -Force
Import-Module "$($ScriptDir)\PowerBIPS.Tools.psd1" -Force



$connectionString = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=teste;Data Source=."

Describe 'Export-PBIDesktopToSQL' {

    
    It 'Given parameter pbiDesktopWindowName and sqlConnStr, it all the tables get exported to SQL Server Database ' {


       $export = Export-PBIDesktopToSQL -pbiDesktopWindowName "*VanArsdel*"-sqlConnStr $connectionString
        
        #assert
        $export | Should -Be $null

    }

}

