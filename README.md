# PowerBIPS.psm1

A powershell module with cmdlets to interact with the PowerBI developer APIs.

Stay tuned for more samples of usage at: 

* https://ruiromanoblog.wordpress.com/
* https://rquintino.wordpress.com/

Cmdlets present in the module:

| Cmdlet   |      Description      |
|----------|:--------------|
| Get-PBIAuthToken |  Gets the authentication token required to comunicate with the PowerBI API's |
| New-PBIDataSet |    Create a new DataSet   |
| Add-PBITableRows | Add's a collection of rows into a powerbi dataset table in batches |
| Get-PBIDataSets |  Gets all the PowerBI existing datasets and returns them as an array of custom objects |
| Get-PBIDataSet | Gets a DataSet by name |
| Test-PBIDataSet |  Check if a dataset exists by name |
| Clear-PBITableRows |  Delete all the rows of a PowerBI dataset table |

The samples below assume that the module is installed in the user modules directory:
* %USERPROFILE%\Documents\WindowsPowershell\Modules\PowerBIPS

![](https://github.com/DevScope/powerbi-powershell-modules/blob/master/Images/PowerBIPS.PNG)

## Get PowerBI Authentication Token

```powershell

$authToken = Get-PBIAuthToken -clientId "<your clientId>"

$authTokenWithUsername = Get-PBIAuthToken -clientId "4c3c58d6-8c83-48c2-a604-67c1b740d167" -userName "<username>" -password "<password>"

```

## List DataSets

```powershell

$dataSets = Get-PBIDataSets -authToken $authToken -Verbose

```

## Test the existence of a DataSet

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

## Create a DataSet

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

## Add Rows to a table

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

## Delete Rows of a table

```powershell

Clear-PBITableRows -authToken $authToken -dataSetName "TestDataSet" -tableName "TestTable" -Verbose

```

## Script Sample

```powershell

cls
$ErrorActionPreference = "Stop"

Import-Module PowerBIPS -Force

# Get the authentication token using ADAL library (OAuth)
$authToken = Get-PBIAuthToken -clientId "4c3c58d6-8c83-48c2-a604-67c1b740d167"

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
