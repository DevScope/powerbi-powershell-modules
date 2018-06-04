
Import-Module "$PsScriptRoot\..\SQLHelper.psm1" -Force




Describe 'Get-SQLConnection' {

    
    It 'Given no parameter open, it connection given closed' {
     
        $conn = Get-SQLConnection -connectionString "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=VanArsdel;Data Source=."

        $conn.State | Should -Be "Closed"

    }

    It 'Given parameter open, it connection given open' {
     
        $conn = Get-SQLConnection -connectionString "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=VanArsdel;Data Source=." -open

        $conn.State | Should -Be "Open"

        $conn.Close()

    }

    It 'Given no parameter open, it connection not given open' {
     
        $conn = Get-SQLConnection -connectionString "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=VanArsdel;Data Source=." 

        $conn.State | Should -Not -Be "Open"

    }

}

