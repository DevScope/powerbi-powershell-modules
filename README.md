# PowerBIPS.psm1

A PowerShell module for the new PowerBI developer REST APIs.

More samples of usage here: 

* https://ruiromanoblog.wordpress.com/2015/03/03/create-a-real-time-it-dashboard-with-powerbips/
* https://github.com/DevScope/powerbi-powershell-modules/blob/master/Modules/PowerBIPS/Samples

Cmdlets present in the module:

| Cmdlet   |      Description      |
|----------|:--------------|
| [Out-PowerBI](#OutPowerBI) |  The most easy way for you to send data into PowerBI |
| [Get-PBIAuthToken](#GetPBIAuthToken) |  Gets the authentication token required to communicate with the PowerBI APIs |
| [Get-PBIGroup](#GetPBIGroup) |  Gets the PowerBI groups in the user workspace |
| [New-PBIDataSet](#NewPBIDataSet) |    Create a new DataSet   |
| [Add-PBITableRows](#AddPBITableRows) | Add's a collection of rows into a powerbi dataset table in batches |
| [Get-PBIDataSet](#GetPBIDataSet) | Gets a DataSet collection, includes definition and tables |
| [Test-PBIDataSet](#TestPBIDataSet) |  Test the existence of a DataSet by name |
| [Clear-PBITableRows](#ClearPBITableRows) |  Delete all the rows of a PowerBI dataset table |
| [Update-PBITableSchema](#UpdatePBITableSchema) |  Updates a table schema |
| [Get-PBIDashboard](#GetPBIDashboard) | Gets a Dashboard collection
| [Get-PBIDashboardTile](#GetPBIDashboardTile) | Gets a Tile collection from a dashboard

For a better experience please copy this module on your UserProfile directory:
* %USERPROFILE%\Documents\WindowsPowershell\Modules\PowerBIPS

Or just import it to your PowerShell session by typing:

* Import-Module ".\Modules\PowerBIPS" -Force

![](https://github.com/DevScope/powerbi-powershell-modules/blob/master/Images/PowerBIPS.PNG)

## Sample Script 1 (Send CSV Data To PowerBI)

```powershell

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

```

## Sample Script 2 (Manual DataSet creation)

```powershell

cls

# Get the authentication token using ADAL library (OAuth)

$authToken = Get-PBIAuthToken

# Test the existence of the dataset
if (-not (Test-PBIDataSet -authToken $authToken -dataSetName "TestDataSet"))
{
	# If cannot find the DataSet create a new one with this schema
	$dataSetSchema = @{
		name = "TestDataSet"	
	    ; tables = @(
			@{ 	name = "TestTable"
				; columns = @( 
					@{ name = "Id"; dataType = "Int64"  }
					, @{ name = "Name"; dataType = "String"  }
					, @{ name = "Date"; dataType = "DateTime"  }
					, @{ name = "Value"; dataType = "Double"  }
					) 
			})
	}	
	
	$createdDataSet = New-PBIDataSet -authToken $authToken -dataSet $dataSetSchema -Verbose
}
else
{
	# Clear all the rows of the dataset table	
	Clear-PBITableRows -authToken $authToken -dataSetName "TestDataSet" -tableName "TestTable" -Verbose
}

# Create a array of sample rows with the same schema of the dataset table
$sampleRows = 1..53 |% {	
	@{
		Id = $_
		; Name = "Record $_"
		; Date = [datetime]::Now
		; Value = (Get-Random -Minimum 10 -Maximum 1000)
	}
}

# Insert the sample rows in batches of 10
$sampleRows | Add-PBITableRows -authToken $authToken -dataSetName "TestDataSet" -tableName "TestTable" -batchSize 10 -Verbose

```

## <a name="OutPowerBI"></a>Out-PowerBI - Simply send any data to PowerBI in a single line of code

```powershell

# Upload local computer windows process data to PowerBI

Get-Process | Out-PowerBI -verbose

# Upload CSV data to PowerBI dataset named "CSVSales" and with the types specified

Import-Csv "c:\csvData.csv" | Out-PowerBI -dataSetName "CSVSales" -tableName "Sales" -types @{"Sales.OrderDate"="datetime"; "Sales.SalesAmount"="double"; "Sales.Freight"="double"} -batchSize 300 -verbose	
	
```

## <a name="GetPBIAuthToken"></a>Get-PBIAuthToken - Get's the OAuth PowerBI Authentication Token

```powershell

$authToken = Get-PBIAuthToken

# To use username+password authentication you need to create an Azure AD Application and get it's id

$authTokenWithUsername = Get-PBIAuthToken -ClientId "C0E8435C-614D-49BF-A758-3EF858F8901B" -Credential (Get-Credential -username "<username>"

$authTokenWithUsernameAndPassword = Get-PBIAuthToken -ClientId "C0E8435C-614D-49BF-A758-3EF858F8901B" -Credential (new-object System.Management.Automation.PSCredential("<username>",(ConvertTo-SecureString -String "<password>" -AsPlainText -Force)))

```

## <a name="GetPBIGroup"></a>Get-PBIGroup - Get's the PowerBI groups in the user workspace

```powershell

$authToken = Get-PBIAuthToken

$group = Get-PBIGroup -authToken $authToken -name "SalesGroup"

# Gets the datasets of the group

Set-PBIGroup -id $group.id

$dataSetsOfGroup = Get-PBIDataSet -authToken $authToken

# Clear the group and all the requests now are for the default workspace

Set-PBIGroup -clear

```

## <a name="GetPBIDataSet"></a>Get-PBIDataSet - Get a DataSet or a List of DataSets

```powershell

# All DataSets
$dataSets = Get-PBIDataSet -authToken $authToken

# By Name
$dataSets = Get-PBIDataSet -authToken $authToken -dataSetName "TestDataSet"

# With tables and definition (retentionPolicy,...)
$dataSets = Get-PBIDataSet -authToken $authToken -dataSetName "TestDataSet" -includeTables -includeDefinition

```

## <a name="TestPBIDataSet"></a>Test-PBIDataSet - Test the existence of a DataSet

```powershell

if (Test-PBIDataSet -authToken $authToken -dataSetName "TestDataSet")
{
	Write-Host "true"
}
else
{
	Write-Host "false"
}

```

## <a name="NewPBIDataSet"></a>New-PBIDataSet - Create a DataSet

```powershell

$dataSetSchema = @{
	name = "TestDataSet"	
    ; tables = @(
		@{ 	name = "TestTable"
			; columns = @( 
				@{ name = "Id"; dataType = "Int64"  }
				, @{ name = "Name"; dataType = "String"  }
				, @{ name = "Date"; dataType = "DateTime"  }
				, @{ name = "Value"; dataType = "Double"  }
				) 
		})
}	

$createdDataSet = New-PBIDataSet -authToken $authToken -dataSet $dataSetSchema -Verbose

```

## <a name="AddPBITableRows"></a>Add-PBITableRows - Add Rows to a table

```powershell

$sampleRows = 1..53 |% {	
	@{
		Id = $_
		; Name = "Record $_"
		; Date = [datetime]::Now
		; Value = (Get-Random -Minimum 10 -Maximum 1000)
	}
}

# Push the rows into PowerBI in batches of 10 records

$sampleRows | Add-PBITableRows -authToken $authToken -dataSetName "TestDataSet" -tableName "TestTable" -batchSize 10 -Verbose

```

## <a name="ClearPBITableRows"></a>Clear-PBITableRows - Delete Rows of a table

```powershell

Clear-PBITableRows -authToken $authToken -dataSetName "TestDataSet" -tableName "TestTable" -Verbose

```

## <a name="UpdatePBITableSchema"></a>Update-PBITableSchema - Update a Table Schema

```powershell

$tableSchema =  @{ 
	name = "Sales"
	; columns = @( 
		@{ name = "Col1"; dataType = "Int64"  }
		, @{ name = "Col2"; dataType = "string"  }
		, @{ name = "NewColumn"; dataType = "string"  }
		) 
}

Update-PBITableSchema -authToken $authToken -dataSetId "<dataSetId>" -table $tableSchema -verbose

```

## <a name="GetPBIDashboard"></a>Get-PBIDashboard - Gets a Dashboard collection

```powershell

$dashboards = Get-PBIDashboard 

```

## <a name="GetPBIDashboardTile"></a>Get-PBIDashboardTile - Gets a Tile collection

```powershell

$tiles = Get-PBIDashboardTile -dashboardId "XXX-XXX-XXX" 

```
