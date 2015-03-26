<# 

Checkout more products and samples at:
	- http://devscope.net/
	- https://github.com/DevScope

PowerBI API documentation:

	- https://msdn.microsoft.com/library/dn877544

Copyright (c) 2015 DevScope

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

#>

#region Constants/Variables

$pbiAuthorityUrl = "https://login.windows.net/common/oauth2/authorize"
$pbiResourceUrl = "https://analysis.windows.net/powerbi/api"
$pbiApiUrl = "https://api.powerbi.com/beta/myorg/datasets"
$pbiDefaultAuthRedirectUri = "https://login.live.com/oauth20_desktop.srf"

#endregion

Function Get-PBIAuthToken{  
<#
.SYNOPSIS
    Gets the authentication token required to comunicate with the PowerBI API's

.DESCRIPTION	
	To authenticate with PowerBI uses OAuth 2.0 with the Azure AD Authentication Library (ADAL)
	
	If a username and password is not supplied a popup will appear for the user to authenticate.
	
	It will automatically download and install the required nuget: "Microsoft.IdentityModel.Clients.ActiveDirectory".		

.PARAMETER ClientId
    The Client Id of the native application created in windows azure active directory of the PowerBI tenant

.PARAMETER UserName
    The username used to authenticate with PowerBI
	
.PARAMETER Password
    The password used to authenticate with PowerBI

.PARAMETER RedirectUri
    The redirect URI associated with the native client application

.PARAMETER ForceAskCredentials
    Forces the authentication popup to always ask for the username and password

 .EXAMPLE
        Get-PBIAuthToken -clientId "C0E8435C-614D-49BF-A758-3EF858F8901B"
        Gets the authentication token but only after the user authenticates with PowerBI in the popup 
 .EXAMPLE
        Get-PBIAuthToken -clientId "C0E8435C-614D-49BF-A758-3EF858F8901B" -username "user@pbitenant.onmicrosoft.com" -password "youwish"
        Gets the authentication token after authenticate with PowerShell with the supplied username and password

#>
	[CmdletBinding(DefaultParameterSetName = "S2")]	
	[OutputType([string])]
	param(				
			[Parameter(Mandatory=$true)] [string] $clientId,
			[Parameter(Mandatory=$true, ParameterSetName = "S1")] [string] $userName,
			[Parameter(Mandatory=$true, ParameterSetName = "S1")] [string] $password,	
			[Parameter(Mandatory=$false, ParameterSetName = "S2")] [string] $redirectUri,
			[Parameter(Mandatory=$false, ParameterSetName = "S2")] [switch] $forceAskCredentials = $false
		)

	begin{
		
		# The begin & end are needed to avoid the .net type error when the dll was not loaded
		
		Ensure-ActiveDirectoryDll
	}
	end{
	
		if ($script:authContext -eq $null)
		{
			Write-Verbose "Creating new AuthenticationContext object"
			$tokenCache = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache
			$script:authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext($pbiAuthorityUrl, $tokenCache)
		}				
		
		if ([string]::IsNullOrEmpty($script:authToken))
		{
			Write-Verbose "Getting new Authentication Token"						
				
			if ($PsCmdlet.ParameterSetName -eq "S1")
			{
				$userCredential = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.UserCredential($userName, $password)
				
				$authResult = $authContext.AcquireToken($pbiResourceUrl,$clientId, $userCredential)
			}
			else
			{
				if ([string]::IsNullOrEmpty($redirectUri))
				{
					$redirectUri = $pbiDefaultAuthRedirectUri
				}
				
				$promptBehavior = [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Auto
				
				if ($forceAskCredentials)
				{
					$promptBehavior = [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Always
				}
				
				$authResult = $authContext.AcquireToken($pbiResourceUrl,$clientId, [Uri]$redirectUri, $promptBehavior)			
			}							
		}
		else
		{
			Write-Verbose "Refreshing Authentication Token"
			
			$authResult = $authContext.AcquireTokenSilent($pbiResourceUrl,$clientId)
		}		

		Write-Verbose "Authenticated as $($authResult.UserInfo.DisplayableId)"
		
		$script:authToken = $authResult.CreateAuthorizationHeader()
		
		return $script:authToken;
	
	}
}

Function Get-PBIDataSets{ 
<#
.SYNOPSIS
    Gets all the PowerBI existing datasets and returns them as an array of custom objects.

.DESCRIPTION	
	Gets all the PowerBI existing datasets and returns as an array of custom objects.
	
	Sample of the returned array:
		
	id                                                    name                                                  defaultRetentionPolicy
	--                                                    ----                                                  ----------------------                               
	d6f2df49-dab5-4382-a917-9aa2ddc99993                  SQL - AdventureWorks - Model                          None
	3313cdf3-309c-4cb5-8597-5b7dd8b87d15                  DomusSocial_ParqueHabitacional                        None

.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

 .EXAMPLE
        Get-PBIDataSets -authToken (Get-PBIAuthToken -clientId "4c3c58d6-8c83-48c2-a604-67c1b740d167")         

#>
	[CmdletBinding()]	
	param(									
		[Parameter(Mandatory=$true)] [string] $authToken
	)
		
	$headers = (Get-PowerBIRequestHeader $authToken)
	
	Write-Verbose "Getting DataSets"
	
	$result = Invoke-RestMethod -Uri $pbiApiUrl -Headers $headers -Method Get 
	
	Write-Verbose "Found $($result.datasets.count) datasets."
	
	Write-Output $result.datasets
}

Function Get-PBIDataSet{
<#
.SYNOPSIS
    Gets a DataSet by name

.DESCRIPTION	
	Check if a dataset exists with the specified name and if exists returns it's metadata

.PARAMETER AuthToken
    The authorization token required to communicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER DataSetName
    The dataset name		
	
.EXAMPLE
								
		$dataSet = Get-PBIDataSet -authToken $authToken -dataSetName "DataSetName"
		Returns the dataset metadata

#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$true)] [string] $authToken,
		[Parameter(Mandatory=$true)] $dataSetName		
	)
		
	Write-Verbose "Checking if the dataset '$dataSetName' already exists"
		
	$dataSets = Get-PBIDataSets -authToken $authToken
	
	$result = $dataSets |? name -eq $dataSetName | select -First 1
		
	if ($result)
	{
		Write-Verbose "Dataset '$dataSetName' exists"				
	}
	else
	{
		Write-Verbose "Dataset '$dataSetName' does not exist"				
	}
	
	Write-Output $result
}

Function Test-PBIDataSet{
<#
.SYNOPSIS
    Check if a dataset exists by name

.DESCRIPTION	
	Check if a dataset exists with the specified name

.PARAMETER AuthToken
    The authorization token required to communicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER DataSetName
    The dataset name		
	
.EXAMPLE
								
		Test-PBIDataSet -authToken $authToken -dataSetName "DataSetName"
		Returns $true if the dataset exists

#>
	[CmdletBinding()]	
	[OutputType([bool])]
	param(									
		[Parameter(Mandatory=$true)] [string] $authToken,
		[Parameter(Mandatory=$true)] $dataSetName		
	)
			
	$dataSet = Get-PBIDataSet -authToken $authToken -dataSetName $dataSetName
	
	if ($dataSet)
	{				
		Write-Output $true
	}
	else
	{				
		Write-Output $false
	}
}

Function New-PBIDataSet{
<#
.SYNOPSIS
    Create a new DataSet

.DESCRIPTION	
	Create a new DataSet in PowerBI		

.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER DataSet
    The dataset object, this object must be one of two types: hashtable or System.Data.DataSet
	
	If a hashtable is supplied it must have the following structure:
		
		$dataSet = @{
			name = "DataSetName"	
		    ; tables = @(
				@{ 
					name = "TableName"
					; columns = @( 
						@{ name = "Col1"; dataType = "Int64"  }
						, @{ name = "Col2"; dataType = "string"  }
						) 
				})
		}
		
.PARAMETER DefaultRetentionPolicy
	The retention policy to be applied by PowerBI
	
	Example: "basicFIFO"
	http://blogs.msdn.com/b/powerbidev/archive/2015/03/23/automatic-retention-policy-for-real-time-data.aspx

.EXAMPLE
								
		New-PBIDataSet -authToken $authToken -dataSet $dataSet
		A new dataset will be created and in case of success return the internal dataset id

#>
	[CmdletBinding()]	
	param(									
		[Parameter(Mandatory=$true)] [string] $authToken,
		[Parameter(Mandatory=$true, HelpMessage = "Must be of type [hashtable] or [dataset]")] $dataSet,
		[Parameter(Mandatory=$false)] [string]$defaultRetentionPolicy
	)
		
	$headers = (Get-PowerBIRequestHeader $authToken)
	
	if ($dataSet -is [hashtable])
	{
		Assert-DataSetObjectSchema $dataSet				
	}
	else
	{
		if ($dataSet -is [System.Data.DataSet])
		{
			$dataSet = Convert-DataSetToPBIDataSet $dataSet
		}		
		else
		{
			throw "Invalid 'dataSet' type, must be of type [hashtable] or [dataset]"
		}
	}
	
	$jsonBody = $dataSet | ConvertTo-Json -Depth 4
	
	Write-Verbose "Creating new dataset"	
		
	if (-not [string]::IsNullOrEmpty($defaultRetentionPolicy))
	{
		$pbiApiUrl += "?defaultRetentionPolicy=$defaultRetentionPolicy"
	}
	
	$result = Invoke-RestMethod -Uri $pbiApiUrl -Headers $headers -Method Post -Body $jsonBody  					
	
	Write-Verbose "DataSet created with id: '$($result.id)"
	
	Write-Output $result
}

Function Add-PBITableRows{  	
<#
.SYNOPSIS
    Add's a collection of rows into a powerbi dataset table in batches

.DESCRIPTION	
	Add's a collection of rows into a powerbi dataset table in batches

.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER DataSetId
    The id of the dataset in PowerBI

.PARAMETER TableName
    The name of the table of the dataset

.PARAMETER Rows
    The collection of rows to insert to the table.
	This parameter can have it's value from the pipeline

.PARAMETER BatchSize
    The size of the batch that is sent to PowerBI as HttpPost.
	
	If for example the batch size is 100 and a collection of
	1000 rows are being pushed then this cmdlet will make 10 
	HttpPosts

.EXAMPLE
		
		Add-PBITableRows -authToken $auth -dataSetId $dataSetId -tableName "Product" -rows $data -batchSize 10				
		
.EXAMPLE
		
		1..53 |% {	@{id = $_; name = "Product $_"}} | Add-PBITableRows -authToken $auth -dataSetId $dataSetId -tableName "Product" -batchSize 10		
		53 records are uploaded to PowerBI "Product" table in batches of 10 rows.

#>
	[CmdletBinding()]
	[CmdletBinding(DefaultParameterSetName = "dataSetId")]	
	param(											
		[Parameter(Mandatory=$true)] [string] $authToken,
		[Parameter(Mandatory=$true, ParameterSetName = "dataSetId")] [string] $dataSetId,
		[Parameter(Mandatory=$true, ParameterSetName = "dataSetName")] [string] $dataSetName,
		[Parameter(Mandatory=$true)] [string] $tableName,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $rows,
		[Parameter(Mandatory=$false)] [int] $batchSize = 100
	)
	
	begin{
		
		$headers = (Get-PowerBIRequestHeader $authToken)					
	
		$rowsBatch = @()	
		
		if ($PsCmdlet.ParameterSetName -eq "dataSetName")
		{
			$dataSet = Get-PBIDataSet -authToken $authToken -dataSetName $dataSetName
			
			if (-not $dataSet)
			{
				throw "Cannot find a DataSet named '$dataSetName'"
			}
			
			$dataSetId = $dataSet.Id
		}
		
		$url = "$pbiApiUrl/$dataSetId/tables/$tableName/rows"
	}
	process{
		
		# Build the batch of rows
				
		$rowsBatch += $rows		
		
		# When the batch is complete send to PBI
		
		if ($batchSize -ne -1 -and $rowsBatch.Count -ge $batchSize)
		{
			Add-PBITableRowsInternal -url $url -headers $headers -rows $rowsBatch
			$rowsBatch = @()
		}
	}
	end{
	
		# If its only one batch upload or is any batch left send to PBI
		
		if ($batchSize -eq -1 -or $rowsBatch.Count -gt 0)
		{
			Add-PBITableRowsInternal -url $url -headers $headers -rows $rowsBatch 
		}		
	}					
}

Function Clear-PBITableRows{  	
<#
.SYNOPSIS
    Delete all the rows of a PowerBI dataset table

.DESCRIPTION	
	Delete all the rows of a PowerBI dataset table		

.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER DataSetId
    The id of the dataset in PowerBI

.PARAMETER TableName
    The name of the table of the dataset

.EXAMPLE
        Get-PBIDataSets -authToken (Get-PBIAuthToken -clientId "4c3c58d6-8c83-48c2-a604-67c1b740d167")         

#>
	[CmdletBinding()]
	[CmdletBinding(DefaultParameterSetName = "dataSetId")]	
	param(									
		[Parameter(Mandatory=$true)] [string] $authToken,
		[Parameter(Mandatory=$true, ParameterSetName = "dataSetId")] [string] $dataSetId,
		[Parameter(Mandatory=$true, ParameterSetName = "dataSetName")] [string] $dataSetName,
		[Parameter(Mandatory=$true)] [string] $tableName
	)
	
	$headers = (Get-PowerBIRequestHeader $authToken)
	
	if ($PsCmdlet.ParameterSetName -eq "dataSetName")
	{
		$dataSet = Get-PBIDataSet -authToken $authToken -dataSetName $dataSetName
		
		if (-not $dataSet)
		{
			throw "Cannot find a DataSet named '$dataSetName'"
		}
		
		$dataSetId = $dataSet.Id
	}
		
	$url = "$pbiApiUrl/$dataSetId/tables/$tableName/rows"
			
	Write-Verbose "Deleting all the rows of '$tableName' table of dataset '$dataSetId'"
	
	$result = Invoke-RestMethod -Uri $url -Headers $headers -Method Delete
	
}

#region Private Methods

Function Add-PBITableRowsInternal{  		
	param(									
		[Parameter(Mandatory=$true)] [string] $url,
		[Parameter(Mandatory=$true)] [hashtable] $headers,
		[Parameter(Mandatory=$true)] [array] $rows
	)
	
	$sampleRow = $rows[0]
	
	if ($sampleRow -is [System.Data.DataRow])
	{
		$table = $rows[0].Table
		
		# Convert all the rows from DataRow into a Hashtable with the columns as keys
		
		$rows = $rows |% {
			$row = $_
			
			$hash = @{}
			
			$table.Columns |% {
				$column = $_
				
				$hash.Add($column.ColumnName, $row[$column])
			}						
			
			$hash
		}		
	}
			
	$bodyObj = @{
			rows = $rows
		} | ConvertTo-Json -Depth 2	
				
	Write-Verbose "Adding a batch of '$($rows.Count)' rows into '$tableName' table of dataset '$dataSetId'"
	
	$result = Invoke-RestMethod -Uri $url -Headers $headers -Method Post -Body $bodyObj 
}

Function Convert-DataSetToPBIDataSet($dataSet)
{
	$ds = @{
			name = $dataSet.DataSetName
		    ; tables = $dataSet.Tables |%{
				
				$table = $_
				
				return @{ 
					name = $table.TableName
					; columns = $table.Columns |% {
						$column = $_
						
						$columnTypeName = $column.DataType.Name
						
						$pbiTypeName = switch -regex ($column.DataType.Name) 
					    { 
					        "Int\d{2}" {"Int64"}
							"Double|Decimal" {"Double"}
							"Boolean" {"bool"}
							"Datetime" {"Datetime"}
							"String" {"String"}
					        default {
								throw "Type '$($column.DataType.Name)' not supported in PowerBI"
								}
					    }				
														
						return @{ name = $column.ColumnName; dataType = $pbiTypeName  }
					}												
				}							
			}						
		}
		
	return $ds
}

Function Get-PowerBIRequestHeader($authToken)
{
	$headers = @{
		'Content-Type'='application/json'
		'Authorization'= $authToken
		}
	
	return $headers
}

Function Assert-DataSetObjectSchema($dataSet)
{
	if (-not $dataSet.ContainsKey("name"))
	{
		throw "'dataSet.name' dont exists"
	}
	
	if (-not $dataSet.ContainsKey("tables"))
	{
		throw "'dataSet.tables' dont exists"
	}
	if (-not $dataSet.tables -is [array])
	{
		throw "'dataSet.tables' object must be an array"
	}
	
	$dataSet.tables |% {
		$table = $_
		
		if (-not $table.ContainsKey("name"))
		{
			throw "'table.name' dont exists"
		}
		
		if (-not $table.columns -is [array])
		{
			throw "'table.columns' object must be an array"
		}	
		
		$table.columns |% {
			$column = $_
			
			if (-not $column.ContainsKey("name"))
			{
				throw "'column.name' dont exists"
			}
			
			if (-not $column.ContainsKey("dataType"))
			{
				throw "'column.dataType' dont exists"
			}
		}
	}
}

Function Ensure-ActiveDirectoryDll
{
	if (-not ("Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -as [type]))
	{
		Write-Verbose "Loading Microsoft.IdentityModel.Clients.ActiveDirectory"
		
		$tempDir = "${env:Temp}\PowerBIPS"
		
		$version = "2.14.201151115"
		$dllPath = "$tempDir\Microsoft.IdentityModel.Clients.ActiveDirectory.$version\lib\net45\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
		
		# Check is the dll has already been downloaded
		
		if (!(Test-Path $dllPath))
		{
			New-Item $tempDir -type Directory -Force | Out-Null
		}
		
		if (!(Test-Path "$tempDir\nuget.exe"))
		{
			Invoke-WebRequest -Uri 'https://oneget.org/nuget-anycpu-2.8.3.6.exe' -OutFile "$tempDir\nuget.exe"
		}

		# Get the nuget with the required dll
		
		if (!(Test-Path $dllPath))
		{
			Start-Process -FilePath "$tempDir\nuget.exe" -ArgumentList "install Microsoft.IdentityModel.Clients.ActiveDirectory -version $version" -WorkingDirectory $tempDir -Wait | Out-Null

			if (!(Test-Path $dllPath))
			{
				throw "Could not load Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
			}
		}

		# load the type
		
		Add-Type -Path $dllPath
	}
	else
	{
		Write-Verbose "Microsoft.IdentityModel.Clients.ActiveDirectory already loaded"
	}
}

#endregion

Export-ModuleMember -Function @("Get-PBIAuthToken", "Get-PBIDataSets", "Get-PBIDataSet", "Test-PBIDataSet", "New-PBIDataSet", "Add-PBITableRows", "Clear-PBITableRows")