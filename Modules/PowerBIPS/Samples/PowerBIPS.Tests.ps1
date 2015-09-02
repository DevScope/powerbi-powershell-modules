cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

$authToken = Get-PBIAuthToken

$result = Get-PBIModels $authToken

$result | Out-GridView

#$result = Invoke-RestMethod -Uri "https://api.powerbi.com/v1.0/myorg/dashboards" -Headers @{
#		'Content-Type'='application/json'
#		'Authorization'= "Bearer $authToken"
#		} -Method Get 
#
#$result

return

# -includeTables will include on each DataSet it's tables

$datasets = Get-PBIDataSet -authToken $authToken -name "DataSet1" -includeTables -includeDefinition 

$newTableSchema = @{ 	
				name = "Table2"
				; columns = @( 
					@{ name = "Id"; dataType = "Int64"  }
					, @{ name = "Category"; dataType = "String"  }
					, @{ name = "SubCategory"; dataType = "String"  }
					, @{ name = "Price"; dataType = "Double"  }
					, @{ name = "NewPrice"; dataType = "Double"  }
					)}

# Update the schema of the table with the new column "NewPrice"

Update-PBITableSchema -authToken $authToken -dataSetId "ab77a751-8cd5-4ecd-8260-0a330552d6f0" -table $newTableSchema

# -forceTableSchemaUpdate will always update the schema of the tables

$data | Out-PowerBI -dataSetName "DataSet1" -forceTableSchemaUpdate

