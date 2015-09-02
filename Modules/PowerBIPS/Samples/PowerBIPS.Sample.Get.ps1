cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

# Get the authentication token using ADAL library (OAuth)

$authToken = Get-PBIAuthToken

Get-PBIGroup $authToken

Get-PBIDataSet -authToken $authToken -groupId "463a428e-0d9b-42b6-8892-ac0a730fb3ab"

Get-PBIDataSet -authToken $authToken -groupName "PowerBI-Demos"

New-PBIDataSet -authToken $authToken -dataSet $dataSetSchema -groupName "PowerBI-Demos"

$group = "PowerBI-Demos"

# Test the existence of the dataset

#Get-PBIGroup -authToken $authToken  

#$group = "PowerBI-Demos"
#$dataSetSchema = @{
#		name = "TestDataSet"	
#	    ; tables = @(
#			@{ 	name = "TestTable"
#				; columns = @( 
#					@{ name = "Id"; dataType = "Int64"  }
#					, @{ name = "Name"; dataType = "String"  }
#					, @{ name = "Date"; dataType = "DateTime"  }
#					, @{ name = "Value"; dataType = "Double"  }
#					) 
#			})
#	}	
#
#$createdDataSet = New-PBIDataSet -authToken $authToken -dataSet $dataSetSchema -groupName $group -Verbose
#
#$createdDataSet

#$sampleRows = 1..55 |% {	
#	@{
#		Id = $_
#		; Name = "Record $_"
#		; Date = [datetime]::Now
#		; Value = (Get-Random -Minimum 10 -Maximum 1000)
#	}
#}
#
## Insert the sample rows in batches of 10
#
#$sampleRows | Add-PBITableRows -authToken $authToken -dataSetId $createdDataSet.id -tableName "TestTable" -batchSize 25 -groupName $group -Verbose
#

#Clear-PBITableRows -authToken $authToken -dataSetId $createdDataSet.id -tableName "TestTable" -groupName $group
	
#Test-PBIDataSet -authToken $authToken -name "Retail Analysis Sample" -groupName "PowerBI-Demos"

#Get-PBIDataSet -authToken $authToken -groupId "463a428e-0d9b-42b6-8892-ac0a730fb3ab"  | Out-GridView

#Get-PBIDataSet -authToken $authToken -groupName "PowerBI-Demos"  | Out-GridView


