cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

Set-PBIGroup -id "94dc590b-5679-4ad3-bb74-ec1c9d34c273"

$authToken = Get-PBIAuthToken

#Get-ModuleConfig

#Get-PBIDashboard

#Get-PBIDashboardTile -dashboardId "283633d6-c905-4e43-9976-e294c0782b82"

#Get-PBIWorkspace

#Get-PBIWorkspaceUsers

#Get-PBIDataset -includeTables

#Set-PBIModuleConfig -PBIApiUrl "https://api.powerbi.com/beta/myorg"

#Get-PBIDatasetTables -dataSetId "42624495-02b7-4698-ad6a-7eb838ec0d41" -Verbose

<# $dataSetSchema = @{
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
	
$createdDataSet = New-PBIDataSet -authToken $authToken -dataSet $dataSetSchema -Verbose #>

<#
$table = @{ 	name = "TestTable"
				; columns = @( 
					@{ name = "Id"; dataType = "Int64"  }
					, @{ name = "Name"; dataType = "String"  }
					, @{ name = "Date"; dataType = "DateTime"  }
					, @{ name = "Value"; dataType = "Double"  }
                    , @{ name = "Value2"; dataType = "Double"  }
					) 
			}
$createdDataSet = Update-PBITableSchema -authToken $authToken -dataSetId "42624495-02b7-4698-ad6a-7eb838ec0d41" -table $table -Verbose
#>

<#

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
#>


#Clear-PBITableRows -dataSetName "TestDataSet" -tableName "TestTable"

<#
$data = 1..50 |% {	
		@{
			Id = $_
			; Name = "Record $_"
			; Date = [datetime]::Now.ToString("yyyy-MM-dd")
			; Value = (Get-Random -Minimum 10 -Maximum 1000)
			; Xpto = (Get-Random -Minimum 10 -Maximum 1000)
		}
	}
	
$data | Out-PowerBI -verbose -types @{"Table.Date" = "datetime"; "Table.DateModified"="datetime"} -dataSetName "TestChangeTable2" -forceTableSchemaUpdate
#>


#Get-PBIImports -importId "9a347dc4-e667-42db-9a0a-854cf451faa7"

# Import-PBIFile -filePath "$currentPath\PBIX\MyMovies.pbix"

# Export-PBIReport -destinationFolder "$currentPath\OutputPBIX" -Verbose


<#Copy-PBIReports -reportsObj @(
				@{
					originalReportName = "Quotes"
					targetName = "Quotes"
					targetWorkspaceName = "Demos - Power BI Tips & Tricks (Session)"
					targetModelName = "Manager Data Model"
				}
			) -Verbose #>

#Update-PBIDataset -datasetIds @("e75b4f03-0bd1-45d7-8579-ee5309ca231c") -Verbose

#Get-PBIDatasetRefreshHistory -datasetIds @("e75b4f03-0bd1-45d7-8579-ee5309ca231c") -Verbose

#Get-PBIDatasetParameters -datasetIds @("164af183-2454-4f45-964a-c200f51bcd59") -Verbose

<#
Set-PBIDatasetParameters -datasetIds  @("164af183-2454-4f45-964a-c200f51bcd59") @(
            @{
                name="ParameterName"
                newValue="NewParameterValue"
			}			
        )
#>

#New-PBIWorkspace -name "PowerBIPS-Test"

#New-PBIWorkspaceUser -groupId "98b9cd9d-ab12-419f-9f7e-a3a5397eb3bd" -emailAddress "joana.barbosa@devscope.net"

#Invoke-PBIRequest -resource "reports" -method "Get"

#Invoke-PBIRequest -resource "datasets" -method "Get"



