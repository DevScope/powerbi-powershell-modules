cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS.psm1" -Force

Import-Module "C:\Users\Romano\Work\GitHub\sql-powershell-modules\Modules\SQLHelper" -Force

# Get the authentication token using ADAL library (OAuth)
$authToken = Get-PBIAuthToken

#$dataSets = Get-PBIDataSet -authToken $authToken -id "546d12c2-abcd-4d36-8527-522aeb063115" -includeDefinition -includeTables -Verbose #-id "546d12c2-abcd-4d36-8527-522aeb063115" #-name "LOBAppExport"

#$tableSchema =  @{ 
#					name = "Sales"
#					; columns = @( 
#						@{ name = "Col1"; dataType = "Int64"  }
#						, @{ name = "Col2"; dataType = "string"  }
#						) 
#				}
#
#Update-PBITableSchema -authToken $authToken -dataSetId "6399804e-701a-41bd-8670-969bd99bc528" -table $tableSchema -verbose

#Get-Process | Out-PowerBI -clientId "7a7be4f7-c64d-41da-94db-7fb8200f029c"  -verbose

#@{Processes = (Get-Process); Processes2 = (Get-Process)} | Out-PowerBI -clientId "7a7be4f7-c64d-41da-94db-7fb8200f029c" -verbose -multipleTables
#
#1..53 |% {	
#	@{
#		Id = $_
#		; Name = "Record $_"
#		; Date = [datetime]::Now
#		; Value = (Get-Random -Minimum 10 -Maximum 1000)
#	}
#} | Out-PowerBI -clientId "7a7be4f7-c64d-41da-94db-7fb8200f029c"  -verbose

#Get-TypeData System.DateTime | Remove-TypeData

#Clear-PBITableRows -authToken $authToken -dataSetName "TesteDates" -tableName "Table"

@{Table1 = (1..53 |% {	
	@{
		Id = $_
		; Name = "Record $_"
		; Date = [datetime]::Now.ToString("yyyy-MM-dd HH:mm:ss")
		; Value = (Get-Random -Minimum 10 -Maximum 1000)
	}
})
;
Table2 = (1..53 |% {	
	@{
		Id = $_
		; Name = "Record $_"
		; Date = [datetime]::Now.ToString("yyyy-MM-dd")
		; Value = (Get-Random -Minimum 10 -Maximum 1000)
	}
})} | Out-PowerBI -dataSetName "TesteDates" -multipletables -verbose -types @{"Table1.Date" = "datetime"; "Table2.Date"="datetime"}

#$ds = Invoke-SQLCommand -executeType QueryAsDataSet -connectionString "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=AdventureWorksDW2012;Data Source=.\sql2014" -commandText "select top 100 ProductKey, [EnglishProductName], Color from DimProduct; select ProductKey, Sum(SalesAmount) SalesAmount from FactInternetSales group by ProductKey"
#$ds | Out-PowerBI -clientId "7a7be4f7-c64d-41da-94db-7fb8200f029c" -verbose

return

$headers = @{
		'Content-Type'='application/json'
		'Authorization'= "Bearer $authToken"
		}
		
Invoke-RestMethod -Uri "https://api.powerbi.com/beta/myorg/datasets/c9687b19-aee8-40a3-b4ae-eb4375ca31d4/Tables" -Headers $headers -Method Get 