cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "C:\Users\Romano\Work\GitHub\sql-powershell-modules\Modules\SQLHelper" -Force

$connStr = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=AdventureWorksDW2012;Data Source=.\sql2014"

$productsQuery = "select p.EnglishProductName Product, p.Color, isnull(p.DealerPrice,0) DealerPrice, isnull(p.ListPrice, 0) ListPrice, p.ModelName, ps.EnglishProductSubcategoryName SubCategory, pc.EnglishProductCategoryName Category
from DimProduct p
	join DimProductSubcategory ps on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
	join DimProductCategory pc on pc.ProductCategoryKey =  ps.ProductCategoryKey"
	
$table = Invoke-SQLCommand -executeType QueryAsTable -connectionString $connStr -commandText $productsQuery

$fileName = "$currentPath\Products.csv"

if (Test-Path $fileName)
{
	Remove-Item $fileName -Force
}

$table | Export-Csv -Delimiter "," -NoTypeInformation -NoClobber -Path $fileName

$salesQuery = "select p.EnglishProductName Product, ps.EnglishProductSubcategoryName SubCategory, pc.EnglishProductCategoryName Category
	, dateadd(yy, 7, s.OrderDate) OrderDate
	, isnull(s.SalesAmount,0) SalesAmount, isnull(s.Freight, 0) Freight
	, g.EnglishCountryRegionName Country, g.City, g.PostalCode
from [dbo].[FactInternetSales] s
	join DimProduct p on s.ProductKey = p.ProductKey
	join DimProductSubcategory ps on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
	join DimProductCategory pc on pc.ProductCategoryKey =  ps.ProductCategoryKey
	join DimCustomer c on s.CustomerKey = c.CustomerKey
	join DimGeography g on g.GeographyKey = c.GeographyKey
where Year(s.OrderDate) = 2008	
	and pc.EnglishProductCategoryName = 'Bikes'
order by OrderDate desc"

$table = Invoke-SQLCommand -executeType QueryAsTable -connectionString $connStr -commandText $salesQuery

$table | Group-Object {
	$_.OrderDate.Year * 100 + $_.OrderDate.Month
	} |% {
	
	$fileName = "$currentPath\Sales.$($_.Name).csv"
	
	if (Test-Path $fileName)
	{
		Remove-Item $fileName -Force
	}

	$_.Group | Select Product, SubCategory, Category, @{N="OrderDate";E={$_.OrderDate.ToString("yyyy-MM-dd HH:mm:ss")}}, SalesAmount, Freight, Country, City, PostalCode | Export-Csv -Delimiter "," -NoTypeInformation -NoClobber -Path $fileName
}