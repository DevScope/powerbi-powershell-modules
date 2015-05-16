cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

# Get the authentication token using ADAL library (OAuth)

$authToken = Get-PBIAuthToken

# Test the existence of the dataset

$dataSetSchema = Get-PBIDataSet -authToken $authToken -name "TestDataSet"

if (-not $dataSetSchema)
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

$sampleRows = 1..55 |% {	
	@{
		Id = $_
		; Name = "Record $_"
		; Date = [datetime]::Now
		; Value = (Get-Random -Minimum 10 -Maximum 1000)
	}
}

# Insert the sample rows in batches of 10

$sampleRows | Add-PBITableRows -authToken $authToken -dataSetName "TestDataSet" -tableName "TestTable" -batchSize 25 -Verbose