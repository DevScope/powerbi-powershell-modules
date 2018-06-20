---
Module Name: PowerBIPS
Module Guid: 163a1640-a4f2-4b1f-a3af-2796ad56200b
Version: 2.0.1.3
---

# PowerBIPS Module
## Description
A PowerShell module that wrap's the Power BI REST API

More samples of usage here: 

* https://ruiromanoblog.wordpress.com/2015/03/03/create-a-real-time-it-dashboard-with-powerbips/
* https://github.com/DevScope/powerbi-powershell-modules/blob/master/Modules/PowerBIPS/Samples

## Available on PowerShell Gallery: 

https://www.powershellgallery.com/packages/PowerBIPS

### Install from PowerShell Gallery

```powershell
Install-Module -Name PowerBIPS
# Or without admin priviledge:
Install-Module -Name PowerBIPS -Scope CurrentUser
```

## Sample Script - The most easy way to send data to Power BI

```powershell

Get-Process | Out-PowerBI -verbose

```

## Sample Script - Export ALL Pbix from a Workspace

```powershell

Set-PBIWorkspace -id "GUID"

Get-PBIReport | Export-PBIReport -destinationFolder ".\Output" 

```

## Sample Script - Rebind All Reports to a different DataSet

```powershell

Get-PBIReport -groupId "WorkspaceId" | Set-PBIReportsDataset -targetDatasetId "DataSetId"

```

## Sample Script - Monitor a list of computers in Real-Time

```powershell
# Get the authentication token using ADAL library (OAuth)

$authToken = Get-PBIAuthToken -Verbose

$workspaceId = "GUID"
$datasetName = "Computer Monitoring"
$reset = $false
$computers = @($env:COMPUTERNAME)

# Change to the destination workspace

Set-PBIWorkspace -id $workspaceId

# Test the existence of the dataset and if exists retrieve the metadata

$dataSetSchema = Get-PBIDataSet -authToken $authToken -name $datasetName -Verbose

if (-not $dataSetSchema)
{
	# If cannot find the DataSet create a new one with this schema	
	
	$dataSetSchema = @{name = $datasetName
    ; tables = @(
        @{name = "Counters"
	    ; columns = @( 
		        @{ name = "ComputerName"; dataType = "String"; isHidden = "true"  }
		        , @{ name = "TimeStamp"; dataType = "DateTime"  }	
				, @{ name = "CounterSet"; dataType = "String"  }
		        , @{ name = "CounterName"; dataType = "String"  }
		        , @{ name = "CounterValue"; dataType = "Double"  }
		        )        
        }
		, 
		@{name = "Computers"
	    ; columns = @( 
		        @{ name = "ComputerName"; dataType = "String"  }
		        , @{ name = "Domain"; dataType = "string"  }	
				, @{ name = "Manufacturer"; dataType = "string"  }		        		        			
		        )
        ;measures = @(
            @{name="Average CPU"; expression="CALCULATE(AVERAGE('Counters'[CounterValue]) / 100, FILTER('Counters', 'Counters'[CounterSet] = ""Processor(_Total)"" && 'Counters'[CounterName] = ""% Processor Time""))"; formatString="0.00%"}
           )
        }
        )
    ; relationships = @(
        @{
            name = [guid]::NewGuid().ToString()
          ; fromTable = "Computers"
          ; fromColumn = "ComputerName"
          ; toTable = "Counters"
          ; toColumn = "ComputerName"
          ; crossFilteringBehavior = "oneDirection"      

        })
    }

	$dataSetSchema = New-PBIDataSet -authToken $authToken -dataSet $dataSetSchema -Verbose	
}
else
{
	# If a dataset exists, delete all its data
	if ($reset)
    {
        Clear-PBITableRows -authToken $authToken -dataSetId $dataSetSchema.Id -tableName "Counters" -Verbose
	    Clear-PBITableRows -authToken $authToken -dataSetId $dataSetSchema.Id -tableName "Computers" -Verbose
    }
}

# Get Computer Info

$computers |% {
    
    $computerInfo = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $_

    @{
        ComputerName = $_
        ; Domain = $computerInfo.Domain
        ; Manufacturer = $computerInfo.Manufacturer
    } | Add-PBITableRows -authToken $authToken -dataSetId $dataSetSchema.Id -tableName "Computers" -batchSize 100 -Verbose 

}

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
	
	Write-Output "Sleeping..."
}

```

## PowerBIPS Cmdlets
### [Add-PBITableRows](doc/Add-PBITableRows.md)


### [Clear-PBITableRows](doc/Clear-PBITableRows.md)


### [Copy-PBIReports](doc/Copy-PBIReports.md)


### [Export-PBIReport](doc/Export-PBIReport.md)


### [Get-PBIAuthToken](doc/Get-PBIAuthToken.md)


### [Get-PBIDashboard](doc/Get-PBIDashboard.md)


### [Get-PBIDashboardTile](doc/Get-PBIDashboardTile.md)


### [Get-PBIDataSet](doc/Get-PBIDataSet.md)


### [Get-PBIDatasetParameters](doc/Get-PBIDatasetParameters.md)


### [Get-PBIDatasetRefreshHistory](doc/Get-PBIDatasetRefreshHistory.md)


### [Get-PBIDataSetTables](doc/Get-PBIDataSetTables.md)


### [Get-PBIDatasources](doc/Get-PBIDatasources.md)


### [Get-PBIGroup](doc/Get-PBIGroup.md)


### [Get-PBIGroupUsers](doc/Get-PBIGroupUsers.md)


### [Get-PBIImports](doc/Get-PBIImports.md)


### [Get-PBIModuleConfig](doc/Get-PBIModuleConfig.md)


### [Get-PBIReport](doc/Get-PBIReport.md)


### [Import-PBIFile](doc/Import-PBIFile.md)


### [Invoke-PBIRequest](doc/Invoke-PBIRequest.md)


### [New-PBIDataSet](doc/New-PBIDataSet.md)


### [New-PBIGroup](doc/New-PBIGroup.md)


### [New-PBIGroupUser](doc/New-PBIGroupUser.md)


### [Out-PowerBI](doc/Out-PowerBI.md)


### [Request-PBIDatasetRefresh](doc/Request-PBIDatasetRefresh.md)


### [Set-PBIDatasetParameters](doc/Set-PBIDatasetParameters.md)


### [Set-PBIGroup](doc/Set-PBIGroup.md)


### [Set-PBIModuleConfig](doc/Set-PBIModuleConfig.md)


### [Set-PBIReportsDataset](doc/Set-PBIReportsDataset.md)


### [Test-PBIDataSet](doc/Test-PBIDataSet.md)


### [Update-PBIDatasetDatasources](doc/Update-PBIDatasetDatasources.md)


### [Update-PBITableSchema](doc/Update-PBITableSchema.md)

### [Set-PBIReportContent](doc/Set-PBIReportContent.md)

### [New-PBIDashboard](doc/New-PBIDashboard.md)


