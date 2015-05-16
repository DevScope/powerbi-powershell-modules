cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

# Get the authentication token using ADAL library (OAuth)

$authToken = Get-PBIAuthToken -Verbose

# Test the existence of the dataset and if exists retrieve the metadata
$dataSetSchema = Get-PBIDataSet -authToken $authToken -name "IT Server Monitor" -Verbose

if (-not $dataSetSchema)
{
	# If cannot find the DataSet create a new one with this schema	
	
	$dataSetSchema = @{name = "IT Server Monitor"
    ; tables = @(
        @{name = "Counters"
	    ; columns = @( 
		        @{ name = "ComputerName"; dataType = "String"  }
		        , @{ name = "TimeStamp"; dataType = "DateTime"  }	
				, @{ name = "CounterSet"; dataType = "String"  }
		        , @{ name = "CounterName"; dataType = "String"  }
		        , @{ name = "CounterValue"; dataType = "Double"  }
		        )}
		, 
		@{name = "CountersResume"
	    ; columns = @( 
		        @{ name = "ComputerName"; dataType = "String"  }
		        , @{ name = "TimeStamp"; dataType = "DateTime"  }	
				, @{ name = "CPU Time"; dataType = "Double"  }
		        , @{ name = "Free Memory"; dataType = "Double"  }
		        , @{ name = "Disk Time"; dataType = "Double"  }				
		        )}
    )}

	$dataSetSchema = New-PBIDataSet -authToken $authToken -dataSet $dataSetSchema -defaultRetentionPolicy "basicFIFO" -Verbose	
}
else
{
	# If a dataset exists, delete all its data
	
    Clear-PBITableRows -authToken $authToken -dataSetId $dataSetSchema.Id -tableName "Counters" -Verbose
	Clear-PBITableRows -authToken $authToken -dataSetId $dataSetSchema.Id -tableName "CountersResume" -Verbose
}

$computers = @($env:COMPUTERNAME)

# Collect data from continuosly in intervals of 5 seconds

$counters = Get-Counter -ComputerName $computers -ListSet @("processor", "memory", "physicaldisk")

$counters | Get-Counter -Continuous -SampleInterval 5 |%{		
	
	# Parse the Counters into the schema of the PowerBI dataset
	
	$pbiData = $_.CounterSamples | Select  @{Name = "ComputerName"; Expression = {$_.Path.Split('\')[2]}} `
			, @{Name="TimeStamp"; Expression = {$_.TimeStamp.ToString("yyyy-MM-dd HH:mm:ss")}} `
			, @{Name="CounterSet"; Expression = {$_.Path.Split('\')[3]}} `
			, @{Name="CounterName"; Expression = {$_.Path.Split('\')[4]}} `
			, @{Name="CounterValue"; Expression = {$_.CookedValue}}
			
	$pbiData | Add-PBITableRows -authToken $authToken -dataSetId $dataSetSchema.Id -tableName "Counters" -batchSize 100 -Verbose        
	
	# Get the Resume Data by Computer
	
	$pbiResumeData = $pbiData | Group ComputerName |% {
		
		$cpuCounter = $_.Group |? { $_.CounterSet -eq "Processor(_Total)" -and $_.CounterName -eq "% Processor Time" }
		$memoryCounter = $_.Group |? { $_.CounterSet -eq "Memory" -and $_.CounterName -eq "Available MBytes" }
		$diskCounter = $_.Group |? { $_.CounterSet -eq "PhysicalDisk(_Total)" -and $_.CounterName -eq "% Disk Time" }
		
		Write-Output @(
			@{"ComputerName" = $_.Name
				; "TimeStamp" = $cpuCounter.TimeStamp
				; "CPU Time" = $cpuCounter.CounterValue
				; "Free Memory" = $memoryCounter.CounterValue
				; "Disk Time" = $diskCounter.CounterValue}
		)
	}
	
	$pbiResumeData | Add-PBITableRows -authToken $authToken -dataSetId $dataSetSchema.Id -tableName "CountersResume" -batchSize 10 -Verbose	
}
