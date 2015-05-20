cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

$testType = 2

if ($testType -eq 1)
{
	Get-Process | Out-PowerBI -verbose
}
elseif ($testType -eq 2)
{
	1..50 |% {	
		@{
			Id = $_
			; Name = "Record $_"
			; Date = [datetime]::Now.ToString("yyyy-MM-dd")
			; Value = (Get-Random -Minimum 10 -Maximum 1000)
			; Xpto = (Get-Random -Minimum 10 -Maximum 1000)
		}
	} | Out-PowerBI -multipleTables -verbose -types @{"Table1.Date" = "datetime"; "Table2.DateModified"="datetime"} -dataSetName "TestChangeTable2" -forceTableSchemaUpdate
}
elseif ($testType -eq 3)
{
	@{Table1 = (1..50 |% {	
		@{
			Id = $_
			; Name = "Record $_"
			; Date = [datetime]::Now.ToString("yyyy-MM-dd")
			; Value = (Get-Random -Minimum 10 -Maximum 1000)
		}
	})
	;
	Table2 = (1..20 |% {	
		@{
			Id = $_
			; Category = "Category $_"
			; SubCategory = "SubCategory $_"
			; DateModified = [datetime]::Now.ToString("yyyy-MM-dd HH:mm:ss")
			; AveragePrice = (Get-Random -Minimum 10 -Maximum 1000)
		}
	})} | Out-PowerBI -multipleTables -verbose -types @{"{Table1.Date" = "datetime"; "Table2.DateModified"="datetime"} -dataSetName "TestChangeTable" -forceTableSchemaUpdate
}
elseif ($testType -eq 4)
{
	while($true)
	{
		# Iterate each CSV file and add to a hashtable with a key for each table that will later be sent to PowerBI
		
		Get-ChildItem "$currentPath\CSVData" -Filter "*.csv" |% {
			
			$tableName = $_.BaseName.Split('.')[0]

			$data = Import-Csv $_.FullName					
			
			# Send data to PowerBI
			
			$data | Out-PowerBI -dataSetName "CSVSales" -tableName "Sales" -types @{"Sales.OrderDate"="datetime"; "Sales.SalesAmount"="double"; "Sales.Freight"="double"} -batchSize 300 -verbose	
			
			# Archive the file
			
			Move-Item $_.FullName "$currentPath\CSVData\Archive" -Force
		}
		
		Write-Output "Sleeping..."
		
		Sleep -Seconds 5
	}
}
elseif ($testType -eq 5)
{
	Import-Module "C:\Users\Romano\Work\GitHub\sql-powershell-modules\Modules\SQLHelper" -Force
	
	$sqlConnStr = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=AdventureWorksDW2012;Data Source=.\sql2014"
	
	$query = "select top 100 ProductKey, [EnglishProductName], Color from DimProduct
			; select ProductKey, Sum(SalesAmount) SalesAmount from FactInternetSales group by ProductKey"
	
	$ds = Invoke-SQLCommand -executeType QueryAsDataSet -connectionString $sqlConnStr -commandText $query
	
	$ds | Out-PowerBI -dataSetName "SQLDataSet" -verbose
}

