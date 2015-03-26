cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS.psm1" -Force

# Get the authentication token using ADAL library (OAuth)
$authToken = Get-PBIAuthToken -clientId "7a7be4f7-c64d-41da-94db-7fb8200f029c" -Verbose

# Test the existence of the dataset and if exists retrieve the metadata
$dataSetMetadata = Get-PBIDataSet -authToken $authToken -dataSetName "IT Server Monitor" -Verbose

if (-not $dataSetMetadata)
{
	# If cannot find the DataSet create a new one with this schema	
	
	$dataSetSchema = @{
		name = "IT Server Monitor"
	    ; tables = @(
			@{ 	name = "Processes"
				; columns = @( 
					@{ name = "ComputerName"; dataType = "String"  }					
					, @{ name = "Date"; dataType = "DateTime"  }
					, @{ name = "Hour"; dataType = "String"  }
					, @{ name = "Id"; dataType = "String"  }
					, @{ name = "ProcessName"; dataType = "String"  }
					, @{ name = "CPU"; dataType = "Double"  }
					, @{ name = "Memory"; dataType = "Double"  }
					, @{ name = "Threads"; dataType = "Int64"  }					
					) 
			})
	}	

	$dataSetMetadata = New-PBIDataSet -authToken $authToken -dataSet $dataSetSchema -defaultRetentionPolicy "basicFIFO" -Verbose	
}

# Create a array of sample rows with the same schema of the dataset table

Clear-PBITableRows -authToken $authToken -dataSetId $dataSetMetadata.Id -tableName "Processes"

$computers = @(".")

while($true)
{	
	$computers |% {
		
		$computerName = $_
		
		$timeStamp = [datetime]::Now
		
		# Dates sent as string because of an issue with ConvertTo-Json (alternative is to convert each object to a hashtable)
		
		Get-Process -ComputerName $computerName | Select  @{Name = "ComputerName"; Expression = {$computerName}} `
			, @{Name="Date"; Expression = {$timeStamp.Date.ToString("yyyy-MM-dd")}} `
			, @{Name="Hour"; Expression = {$timeStamp.ToString("HH:mm:ss")}} `
			, Id, ProcessName, CPU, @{Name='Memory';Expression={($_.WorkingSet/1MB)}}, @{Name='Threads';Expression={($_.Threads.Count)}} `
		| Add-PBITableRows -authToken $authToken -dataSetId $dataSetMetadata.Id -tableName "Processes" -batchSize -1 -Verbose
		
	}
	
	sleep -Seconds 10
}
