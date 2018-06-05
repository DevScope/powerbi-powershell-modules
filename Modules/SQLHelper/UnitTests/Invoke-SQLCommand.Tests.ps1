
Clear-Host
$ScriptDir = (Split-Path -parent $MyInvocation.MyCommand.Path) | Split-Path -parent


Import-Module "$($ScriptDir)\SQLHelper.psd1" -Force


$tableToTest = "[dbo].[foo]"
$connectionString = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=teste;Data Source=."

Describe 'Invoke-SQLCommand' {

    
    

    It 'Given parameter connectionString and executeType is "Query",  its count sould be 3 rows' {

        $commandText = "SELECT * FROM $($tableToTest)"

        $data = Invoke-SQLCommand -connectionString $connectionString -commandText $commandText -executeType "Query"

        $data.Count | Should -Be 3

    }

    It 'Given parameter connection and executeType is "Query", its count sould be 3 rows' {

        
        $connection = Get-SQLConnection -connectionString $connectionString

        $commandText = "SELECT * FROM $($tableToTest)"

        $data = Invoke-SQLCommand -connectionString $connectionString -commandText $commandText -executeType "Query"

        $data.Count | Should -Be 3

        $connection.Close()

    }

    It 'Given parameter connectionString and executeType is "NonQuery" with parameters, its should be 1' {
        
        $parameters = @{ 

            'name'= 'foo'
            
            'id'  = 1
        }

        $commandText = "UPDATE $($tableToTest) SET name = @name WHERE id = @id "

        $data = Invoke-SQLCommand -connectionString $connectionString -commandText $commandText -executeType "NonQuery" -parameters $parameters

        $data.Count | Should -Be 1

    }

    It 'Given parameter connectionString and executeType is "Scalar", its should be 3' {

        $commandText = "SELECT Count(*) FROM $($tableToTest)"

        $data = Invoke-SQLCommand -connectionString $connectionString -commandText $commandText -executeType "Scalar"

        $data | Should -Be 3

    }

    It 'Given parameter connectionString and executeType is "Reader", its list of 3 rows' {

        $commandText = "SELECT * FROM $($tableToTest)"

        $reader = Invoke-SQLCommand -connectionString $connectionString -commandText $commandText -executeType "Reader"

        while ( $reader.Read() ) {

            Write-Host $reader.GetValue(0)

        }
  
    }

    It 'Given parameter connectionString and executeType is "QueryAsDataSet", its list of 3 rows' {

        $commandText = "SELECT * FROM $($tableToTest)"

        $dataset = Invoke-SQLCommand -connectionString $connectionString -commandText $commandText -executeType "QueryAsDataSet"

        $dataset.Tables[0].Rows |% { 

             write-host $_[0]
        }
  
    }
   
}

