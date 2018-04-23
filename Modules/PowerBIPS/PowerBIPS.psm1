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

$script:pbiAuthorityUrl = "https://login.microsoftonline.com/common/oauth2/authorize"
$script:pbiResourceUrl = "https://analysis.windows.net/powerbi/api"
$script:pbiDefaultAuthRedirectUri = "https://login.live.com/oauth20_desktop.srf"
$script:pbiDefaultClientId = "053e0da1-7eb4-4b9a-aa07-6f41d0f35cef"
$script:pbiAPIUrl = "https://api.powerbi.com/v1.0/myorg"	#"https://api.powerbi.com/beta/myorg"
$script:pbiGroupId = $null

#endregion

Function Set-PBIModuleConfig
{
    <#
        .SYNOPSIS
        Sets the module config variables like: API Url, App Id,...          
    #>
    
    param
    (
        [string]
        $PBIAPIUrl,
        [string]
        $AzureADAppId,
        [string]
        $AzureADAuthorityUrl,
        [string]
        $AzureADResourceUrl,
        [string]
        $AzureADRedirectUrl       
	)

    if (![string]::IsNullOrEmpty($PBIAPIUrl))
    {
        Write-Host "Changing 'pbiAPIUrl' from '$($script:pbiAPIUrl)' to '$PBIAPIUrl'"

        $script:pbiAPIUrl = $PBIAPIUrl
    }

    if (![string]::IsNullOrEmpty($AzureADAppId))
    {
        Write-Host "Changing 'pbiDefaultClientId' from '$($script:pbiDefaultClientId)' to '$AzureADAppId'"

        $script:pbiDefaultClientId = $AzureADAppId
    }

    if (![string]::IsNullOrEmpty($AzureADAuthorityUrl))
    {
        Write-Host "Changing 'pbiAuthorityUrl' from '$($script:pbiAuthorityUrl)' to '$AzureADAuthorityUrl'"

        $script:pbiAuthorityUrl = $AzureADAuthorityUrl
    }

    if (![string]::IsNullOrEmpty($AzureADResourceUrl))
    {
        Write-Host "Changing 'pbiResourceUrl' from '$($script:pbiResourceUrl)' to '$AzureADResourceUrl'"

        $script:pbiResourceUrl = $AzureADResourceUrl
    }

    if (![string]::IsNullOrEmpty($AzureADRedirectUrl))
    {
        Write-Host "Changing 'pbiDefaultAuthRedirectUri' from '$($script:pbiDefaultAuthRedirectUri)' to '$AzureADRedirectUrl'"

        $script:pbiDefaultAuthRedirectUri = $AzureADRedirectUrl
    }

}

Function Get-PBIModuleConfig
{
    <#
        .SYNOPSIS
        Gets the module config variables like: API Url, App Id,...          
    #>
   

    Write-Output @{
        "pbiDefaultClientId" = $pbiDefaultClientId
        ; "pbiAuthorityUrl" = $pbiAuthorityUrl
        ; "pbiResourceUrl" = $pbiResourceUrl
        ; "pbiDefaultAuthRedirectUri" = $pbiDefaultAuthRedirectUri
        ; "pbiAPIUrl" = $pbiAPIUrl
     }   
       
}

Function Get-PBIAuthToken
{
    <#
            .SYNOPSIS
            Gets the authentication token required to comunicate with the PowerBI API's


            .DESCRIPTION
            To authenticate with PowerBI uses OAuth 2.0 with the Azure AD Authentication Library (ADAL)

            If a credential is not supplied a popup will appear for the user to authenticate.

            It will automatically download and install the required nuget: "Microsoft.IdentityModel.Clients.ActiveDirectory".

            .PARAMETER ClientId
            The Client Id of the Azure AD application

            .PARAMETER Credential
			Specifies a PSCredential object or a string username used to authenticate to PowerBI. If only a username is specified 
			this will prompt for the password. Note that this will not work with federated users.

            .PARAMETER RedirectUri
            The redirect URI associated with the native client application

            .PARAMETER ForceAskCredentials
            Forces the authentication popup to always ask for the username and password

            .EXAMPLE
            Get-PBIAuthToken -clientId "C0E8435C-614D-49BF-A758-3EF858F8901B"
            Returns the access token for the PowerBI REST API using the client ID. You'll be presented with a pop-up window for 
			user authentication.
            .EXAMPLE
			$Credential = Get-Credential
            Get-PBIAuthToken -ClientId "C0E8435C-614D-49BF-A758-3EF858F8901B" -Credential $Credential
            Returns the access token for the PowerBI REST API using the client ID and a PSCredential object.
    #>
    
    [CmdletBinding(DefaultParameterSetName = 'default')]
    [OutputType([string])]
    param
    (        
        [Parameter(Mandatory = $true, ParameterSetName = 'credential')]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter(ParameterSetName = 'default')]
        [switch]
        $ForceAskCredentials = $false
	)


    if ($Script:AuthContext -eq $null)
    {
        Write-Verbose -Message 'Creating new AuthenticationContext object'
        $script:AuthContext = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext -ArgumentList ($script:pbiAuthorityUrl)
    }

    Write-Verbose -Message 'Getting the Authentication Token'
    if ($PSCmdlet.ParameterSetName -eq 'credential')
    {
        Write-Verbose -Message 'Using username+password authentication flow'
		
		$UserCredential = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.UserPasswordCredential($Credential.UserName, $Credential.Password)
		
        $AuthResult = [Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContextIntegratedAuthExtensions]::AcquireTokenAsync($script:AuthContext
        , $script:pbiResourceUrl
		, $ClientId
		, $UserCredential).Result
    }
    else
    {
		Write-Verbose -Message 'Using default authentication flow'
		
        if ($ForceAskCredentials)
        {
            $promptBehavior = [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Always
        }
        else
        {
            $promptBehavior = [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Auto
		}
		
		$pltParams = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters($promptBehavior)
		
		$AuthResult = $script:authContext.AcquireTokenAsync($script:pbiResourceUrl
			, $script:pbiDefaultClientId, [Uri]$script:pbiDefaultAuthRedirectUri
			, $pltParams
		).Result        
    }

	Write-Verbose -Message "Authenticated as $($AuthResult.UserInfo.DisplayableId)"
	
    $AuthResult.AccessToken
}

Function Set-PBIGroup{
<#
.SYNOPSIS
   Set's the scope to the group specified, after execution all the following PowerBIPS cmdlets will execute over the setted group.

.PARAMETER AuthToken
    The authorization token required to communicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER Id
    The id of the group
	
.PARAMETER Name
    The name of the group

.PARAMETER Clear
    If $true then will clear the group and all the requests will be made to the default user workspace

#>
	[CmdletBinding()][Alias("Set-PBIWorkspace")]			
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$false)] [string] $id,
		[Parameter(Mandatory=$false)] [string] $name,
		[Parameter(Mandatory=$false)] [switch] $clear = $false			
	)
		
	if ($clear)
	{
		$script:pbiGroupId = $null
	}
	else
	{
		$script:pbiGroupId = Resolve-GroupId $authToken $id $name
	}
}

Function Get-PBIReport{
	<#
	.SYNOPSIS    
		Gets all the PowerBI existing reports and returns as an array of custom objects.
		
	.EXAMPLE	
		Get-PBIReport -authToken $authToken	
	.EXAMPLE
		Get-PBIReport -authToken $authToken	-id $id
	
	#>
		[CmdletBinding()]		
		param(									
			[Parameter(Mandatory=$false)] [string] $authToken,
			[Parameter(Mandatory=$false)] [string] $name,
			[Parameter(Mandatory=$false)] [string] $id		
		)
					
		Write-Verbose "Getting Reports"

		$resource = "reports"

		if (![string]::IsNullOrEmpty($id))
		{
			$resource += "/$id"
		}

		$reports = @(Invoke-PBIRequest -authToken $authToken -method Get -resource $resource)
						
		Write-Verbose "Found $($reports.count) reports."

		Write-Output (Find-ByIdOrName -items $reports -id $id -name $name)			
}

Function Get-PBIDashboard{
<#
.SYNOPSIS    
	Gets all the PowerBI existing dashboards and returns as an array of custom objects.
		
.EXAMPLE
			
		Get-PBIDashboard -authToken $authToken		

#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$false)] [string] $name,
		[Parameter(Mandatory=$false)] [string] $id		
	)
	
	Write-Verbose "Getting Dashboards"
	
	$dashboards = @(Invoke-PBIRequest -authToken $authToken -method Get -resource "dashboards")		
	
	Write-Verbose "Found $($dashboards.count) dashboard."			

	Write-Output (Find-ByIdOrName -items $dashboards -id $id -name $name)		
}

Function Get-PBIDashboardTile{
<#
.SYNOPSIS    
	Gets all the PowerBI existing dashboards and returns as an array of custom objects.
		
.EXAMPLE
			
		Get-PBIDashboardTile -authToken $authToken -dashboardId "XXXX-XXXX-XXXX"		

#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$false)] [string] $dashboardId,	
		[Parameter(Mandatory=$false)] [string] $tileId
	)

	Write-Verbose "Getting Dashboard '$dashboardId' tiles"
	
	$scope = "dashboards/$dashboardId/tiles"

	if (-not [string]::IsNullOrEmpty($tileId))
	{
		$scope += "/$tileId"
	}

    $tiles = @(Invoke-PBIRequest -authToken $authToken -method Get -resource $scope)
	
	Write-Verbose "Found $($tiles.count) tiles."				

	Write-Output $tiles
}

Function Get-PBIGroup{
<#
.SYNOPSIS 
	Gets all the PowerBI existing groups and returns as an array of custom objects.
		
.EXAMPLE
			
		Get-PBIGroup -authToken $authToken		

#>
	[CmdletBinding()][Alias("Get-PBIWorkspace")]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$false)] [string] $name,
		[Parameter(Mandatory=$false)] [string] $id		
	)

	Write-Verbose "Getting Groups"
	
    $groups = @(Invoke-PBIRequest -authToken $authToken -method Get -resource "groups" -ignoreGroup)		
	
	Write-Output (Find-ByIdOrName -items $groups -id $id -name $name)
}

Function Get-PBIGroupUsers{
<#
.SYNOPSIS    
	Gets users that are members of a specific workspace (group) and returns as an array of custom objects.
	Must use Set-PBIGroup first to set the group.
		
.EXAMPLE
	Get-PBIGroupUsers -authToken $authToken		

#>
	[CmdletBinding()][Alias("Get-PBIWorkspaceUsers")]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken	
	)

	$groupId = $script:pbiGroupId

	if ([string]::IsNullOrEmpty($groupId))
	{
		throw "No group setted. Use Set-PBIGroup first to set the group."
	}
	else
	{	
		Write-Verbose "Getting Users"

        $users = Invoke-PBIRequest -authToken $authToken -method Get -resource "users"			
		
		Write-Verbose "Found $($users.count) users."
		
		Write-Output $users
	}

}

Function New-PBIGroup{
<#
.SYNOPSIS
    Create a new group
.DESCRIPTION
	Creates a new group (app workspace) in PowerBI
.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string
.PARAMETER Name
    The name of the group
.EXAMPLE
		New-PBIGroup -authToken $authToken -name "Name Of The New Group"
#>
	[CmdletBinding()][Alias("New-PBIWorkspace")]
	param(
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true)] $name
	)	

	$body = @{
		name = $name
	} | ConvertTo-Json	

    Write-Output Invoke-PBIRequest -authToken $authToken -method Post -resource "groups" -Body $body -ignoreGroup	
}

Function New-PBIGroupUser{
<#
.SYNOPSIS
    Add a user to a group
.DESCRIPTION
	Adds a new user to an existing group (app workspace) in PowerBI
.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string
.PARAMETER GroupId
    The id of the group in PowerBI
.PARAMETER EmailAddress
    The email address of the user in your organisation that you want to add to the group
.PARAMETER GroupUserAccessRight
    The access right the user gets on the group
.EXAMPLE
		New-PBIGroupUser -authToken $authToken -groupId $groupId -emailAddress "someone@your-organisation.com"
#>
	[CmdletBinding()][Alias("New-PBIWorkspaceUser")]
	param(
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true)] $groupId,
        [Parameter(Mandatory=$true)] $emailAddress,
		[Parameter(Mandatory=$false)]
		[ValidateSet("Admin")]
		[string]$groupUserAccessRight = "Admin"
	)	

	$body = @{
		groupUserAccessRight = $groupUserAccessRight
		emailAddress = $emailAddress
	} | ConvertTo-Json	

    $result = Invoke-PBIRequest -authToken $authToken -method Post -resource "groups/$groupId/users" -Body $body -ignoreGroup	

	Write-Output $result
}


Function Get-PBIDataSet{
<#
.SYNOPSIS    
	Gets all the PowerBI existing datasets and returns as an array of custom objects.
	Or
	Check if a dataset exists with the specified name and if exists returns it's metadata

.DESCRIPTION	
	Gets all the PowerBI existing datasets and returns as an array of custom objects.
	Or
	Check if a dataset exists with the specified name and if exists returns it's metadata

.PARAMETER AuthToken
    The authorization token required to communicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER Name
    The dataset name		
	
.PARAMETER Id
    The dataset id
	
.PARAMETER IncludeDefinition
    If specified will include the dataset definition properties
	
.PARAMETER IncludeTables
    If specified will include the dataset tables
	
.EXAMPLE
			
		Get-PBIDataSet -authToken $authToken
		Get-PBIDataSet -authToken $authToken -name "DataSetName"		
		Get-PBIDataSet -authToken $authToken -name "DataSetName" -includeDefinition -includeTables

#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$false)] [string] $name,
		[Parameter(Mandatory=$false)] [string] $id,
		[Parameter(Mandatory=$false)] [switch] $includeDefinition,
		[Parameter(Mandatory=$false)] [switch] $includeTables		
	)
	
	if ([string]::IsNullOrEmpty($id))
	{
		Write-Verbose "Getting DataSets"				
		
        $dataSets = @(Invoke-PBIRequest -authToken $authToken -method Get -resource "datasets")				
		
		Write-Verbose "Found $($dataSets.count) datasets."	
		
		$dataSets = Find-ByIdOrName -items $dataSets -name $name				
		
		# if IncludeDefinition is true then go get the definition of the dataset and change the PSObject
		
		if ($includeDefinition)
		{				
			$dataSets |% {
				$dataSet = $_
				
				$dataSetDefinition = Get-PBIDataSet -authToken $authToken -id $_.Id -ErrorAction Continue
				
				$dataSetDefinition | Get-Member -MemberType NoteProperty |%{
					
                    $dataSet | Add-Member -MemberType NoteProperty -Name $_.Name -Value $dataSetDefinition.$($_.Name) -Force					
				}								
			}
		}
	}
	else
	{
		Write-Verbose "Getting DataSet Definition"
		
        $dataSets = @(Invoke-PBIRequest -authToken $authToken -method Get -resource "datasets/$id")				
	}
	
	# if IncludeTables is true then call the GetTables operation
	
	if ($includeTables)
	{				
		$dataSets |% {
			$dataSet = $_						
			
			$tables = Get-PBIDataSetTables -authToken $authToken -dataSetId $_.Id
					
			$dataSet | Add-Member -MemberType NoteProperty -Name "tables" -Value $tables			
		}
	}
	
	Write-Output $dataSets
}

Function Get-PBIDataSetTables{
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true)] [string] $dataSetId		
	)
			
	Write-Verbose "Getting DataSet '$dataSetId' Tables"
		
	try
	{	
		$result = Invoke-PBIRequest -authToken $authToken -method Get -resource "datasets/$dataSetId/tables"	
        		
		Write-Output $result	
	}
	catch
	{
    
		Write-Warning "Cannot retrieve DataSet '$dataSetId' tables: $($_.Exception.Message)"
	}
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

.PARAMETER Name
    The dataset name		
	
.EXAMPLE
								
		Test-PBIDataSet -authToken $authToken -name "DataSetName"
		Returns $true if the dataset exists

#>
	[CmdletBinding()]	
	[OutputType([bool])]
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true)] $name
	)
			
	$dataSet = Get-PBIDataSet -authToken $authToken -name $name
	
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
		[Parameter(Mandatory=$false)] [string]$defaultRetentionPolicy,
		[Parameter(Mandatory=$false)] [hashtable]$types
	)
			
	if ($dataSet -is [hashtable])
	{
		Assert-DataSetObjectSchema $dataSet				
	}
	elseif ($dataSet -is [System.Data.DataSet])
	{
		$dataSet = ConvertTo-PBIDataSet $dataSet
	}
	else
	{
		throw "Invalid 'dataSet' type, must be of type [hashtable] or [dataset]"
	}
	
	$jsonBody = ConvertTo-PBIJson -obj $dataSet -types $types
	
	Write-Verbose "Creating new dataset"	
	
	$resource = "datasets"
	
	if (-not [string]::IsNullOrEmpty($defaultRetentionPolicy))
	{		
		$resource = $resource + "?defaultRetentionPolicy=$defaultRetentionPolicy"
	}		

    $result = Invoke-PBIRequest -authToken $authToken -method Post -resource $resource -body $jsonBody				
	
	Write-Verbose "DataSet created with id: '$($result.id)"
	
	Write-Output $result
}

Function Update-PBITableSchema{
<#
.SYNOPSIS
    Updates a PowerBI Dataset Table Schema.
	Note: This operation will delete all the table rows

.DESCRIPTION	
	Updates a PowerBI Dataset Table Schema	

.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER Table
    The table object, this object must be one of two types: hashtable or System.Data.DataTable
	
	If a hashtable is supplied it must have the following structure:
		
		$table = @{ 
					name = "TableName"
					; columns = @( 
						@{ name = "Col1"; dataType = "Int64"  }
						, @{ name = "Col2"; dataType = "string"  }
						) 
				}

.EXAMPLE
								
		Update-PBITableSchema -authToken $authToken -dataSetId <dataSetId> -table <tableSchema>		

#>
	[CmdletBinding()]	
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true)] [string] $dataSetId,				
		[Parameter(Mandatory=$true, HelpMessage = "Must be of type [hashtable] or [datatable]")] $table,
		[Parameter(Mandatory=$false)] [hashtable] $types
	)
							
	if ($table -is [hashtable])
	{
		Assert-DataSetTableObjectSchema $table			
	}
	elseif ($table -is [System.Data.DataTable])
	{				
		$table = ConvertTo-PBITableFromDataTable $table					
	}
	else
	{
		throw "Invalid 'table' type, must be of type [hashtable] or [dataset]"
	}
	
	$jsonBody = ConvertTo-PBIJson -obj $table -types $types
		
	Write-Verbose "Updating Table Schema of '$($table.Name)' on DataSet '$dataSetId'"	
		
    Invoke-PBIRequest -authToken $authToken -method Put -resource "datasets/$dataSetId/tables/$($table.Name)" -body $jsonBody	  			
	
	Write-Verbose "Table schema updated"
		
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
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ParameterSetName = "dataSetId")] [string] $dataSetId,
		[Parameter(Mandatory=$true, ParameterSetName = "dataSetName")] [string] $dataSetName,
		[Parameter(Mandatory=$true)] [string] $tableName,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $rows,
		[Parameter(Mandatory=$false)] [int] $batchSize = 1000		
	)
	
	begin{
						
		$rowsBatch = @()	
		
		if ($PsCmdlet.ParameterSetName -eq "dataSetName")
		{
			$dataSet = Get-PBIDataSet -authToken $authToken -name $dataSetName
			
			if (-not $dataSet)
			{
				throw "Cannot find a DataSet named '$dataSetName'"
			}
			
			$dataSetId = $dataSet.Id
		}					
	}
	process{
		
		# Build the batch of rows
				
		$rowsBatch += $rows		
		
		# When the batch is complete send to PBI
		
		if ($batchSize -ne -1 -and $rowsBatch.Count -ge $batchSize)
		{
			Add-PBITableRowsInternal -rows $rowsBatch
			$rowsBatch = @()
		}
	}
	end{
	
		# If its only one batch upload or is any batch left send to PBI
		
		if ($batchSize -eq -1 -or $rowsBatch.Count -gt 0)
		{
			Add-PBITableRowsInternal -rows $rowsBatch 
		}		
	}					
}

Function Add-PBITableRowsInternal{  		
	param(									
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
	
	if ($bodyObj -match """value"":.+\/Date\(")
	{
		Write-Warning "There's an issue with [datetime] and ConvertTo-Json... As an workaround please use -Types parameter to force the column type as [datetime] for example: -Types @{""Table.Date""=""datetime""} and set the row values as string like 'colValue.ToString(""yyyy-MM-dd"")'"
	}		

    Invoke-PBIRequest -authToken $authToken -method Post -resource "datasets/$dataSetId/tables/$tableName/rows" -body $bodyObj | Out-Null
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
        Clear-PBITableRows -authToken "authToken" -DataSetId "DataSetId" -TableName "Table"

#>
	[CmdletBinding()]
	[CmdletBinding(DefaultParameterSetName = "dataSetId")]	
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ParameterSetName = "dataSetId")] [string] $dataSetId,
		[Parameter(Mandatory=$true, ParameterSetName = "dataSetName")] [string] $dataSetName,
		[Parameter(Mandatory=$true)] [string] $tableName		
	)
	
	if ($PsCmdlet.ParameterSetName -eq "dataSetName")
	{
		$dataSet = Get-PBIDataSet -authToken $authToken -name $dataSetName
		
		if (-not $dataSet)
		{
			throw "Cannot find a DataSet named '$dataSetName'"
		}
		
		$dataSetId = $dataSet.Id
	}
			
	Write-Verbose "Deleting all the rows of '$tableName' table of dataset '$dataSetId'"

    Invoke-PBIRequest -authToken $authToken -method Delete -resource "datasets/$dataSetId/tables/$tableName/rows" -body $bodyObj	 
	
}

Function Out-PowerBI
{
    <#
            .SYNOPSIS
            A one line cmdlet that you can use to send data into PowerBI

            .DESCRIPTION


            .PARAMETER Data
            The data that will be sent to PowerBI

            .PARAMETER ClientId
            The Client Id of the Azure AD application

            .PARAMETER AuthToken
            The AccessToken - Optional

            .PARAMETER Credential
            specifies a PSCredential object used to authenticate to the PowerBI service. This is used to automate the
            sign in process so you aren't prompted to enter a username and password in the GUI.

            .PARAMETER DataSetName
            The name of the dataset - Optional, by default will always create a new dataset with a timestamp

            .PARAMETER TableName
            The name of the table in the DataSet - Optional, by default will be named "Table"

            .PARAMETER BatchSize
            The size of the batch that is sent to PowerBI as HttpPost.

            If for example the batch size is 100 and a collection of
            1000 rows are being pushed then this cmdlet will make 10
            HttpPosts

            .PARAMETER MultipleTables
            A indication that the hashtable passed is a multitable

            .EXAMPLE
            Get-Process | Out-PowerBI -clientId "7a7be4f7-c64d-41da-94db-7fb8200f029c"

            1..53 |% {
            @{
                Id = $_
                ; Name = "Record $_"
                ; Date = [datetime]::Now
                ; Value = (Get-Random -Minimum 10 -Maximum 1000)
            }
            } | Out-PowerBI -clientId "7a7be4f7-c64d-41da-94db-7fb8200f029c"  -verbose

    #>
    [CmdletBinding(DefaultParameterSetName = "authToken")]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $Data,

        [Parameter(ParameterSetName = "authToken")]
        [string]
        $AuthToken,

        [Parameter(Mandatory = $true, ParameterSetName = "credential")]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [string]
        $DataSetName = ("PowerBIPS_{0:yyyyMMdd_HHmmss}"	-f (Get-Date)),

        [string]
        $TableName	= "Table",
        
        [int]
        $BatchSize = 1000,

        # Need this because $data could be an hashtable (multiple tables) and the rows also can be hashtables...
        [switch]
        $MultipleTables,

        [switch]
        $ForceAskCredentials,

        [switch]
        $ForceTableSchemaUpdate,

        [hashtable]
        $Types
    )

    begin
    {
        $dataToProcess = @()
    }
    process
    {
        $dataToProcess += $Data
    }
    end
    {
        if ($dataToProcess.Count -eq 0)
        {
            Write-Verbose "There is no data to process"
            return
        }

        if ($PsCmdlet.ParameterSetName -eq "credential")
        {
            $AuthToken = Get-PBIAuthToken -Credential $Credential
        }
        elseif ([string]::IsNullOrEmpty($AuthToken))
        {
            $AuthToken = Get-PBIAuthToken -forceAskCredentials:$ForceAskCredentials
        }       

        # Prepare the Data to be processed
        if ($dataToProcess.Count -eq 1)
        {
            $dataToProcessSample = $dataToProcess[0]

            # If is a DataSet then transform to a hashtable with DataTables in it
            if ($dataToProcessSample -is [System.Data.DataSet])
            {
                $dataToProcess = @{}

                $dataToProcessSample.Tables | Foreach-Object {
                    $dataToProcess.Add($_.TableName, $_)
                }
            }
            elseif ($MultipleTables -and ($dataToProcessSample -is [hashtable]))
            {
                $dataToProcess = $dataToProcess[0]
            }
            else
            {
                $dataToProcess = @{$TableName = $dataToProcess}
                #throw "When -multipleTables is specified you must pass into -data an hashtable with a key for each table"
            }
        }
        else
        {
            $dataToProcess = @{$TableName = $dataToProcess}
        }

        # Remove empty tables
        $tablesToRemove = $dataToProcess.GetEnumerator() | Where-Object {-not $_.Value } | Select-Object -ExpandProperty Key

        $tablesToRemove | Foreach-Object {
            $dataToProcess.Remove($_)
        }

        # Create the DataSet in PowerBI (if not exists)
        $pbiDataSet = Get-PBIDataSet -authToken $AuthToken -name $DataSetName

        if ($pbiDataSet -eq $null -or $ForceTableSchemaUpdate)
        {
            # Create the DataSet schema object
            $dataSet = @{
                name = $DataSetName
                tables = @()
            }

            # Process each table schema individually
            foreach ($h in ($dataToProcess.GetEnumerator() | Sort-Object -Property Name)) {

                $dataSet.tables += ConvertTo-PBITable -obj $h.Value -name $h.Name
            }

            if ($pbiDataSet -eq $null)
            {
                $pbiDataSet = New-PBIDataSet -authToken $AuthToken -dataSet $dataSet -types $Types
            }
            else
            {
                # Updates the schema of all the tables
                $dataSet.tables | Foreach-Object {
                    Update-PBITableSchema -authToken $AuthToken -dataSetId $pbiDataSet.id -table $_ -types $Types
                }
            }
        }

        # Upload rows for each table
        foreach ($h in ($dataToProcess.GetEnumerator() | Sort-Object -Property Name))
		{

            $TableName = $h.Name
            $tableData = ConvertTo-PBITableData $h.Value
            $tableData | Add-PBITableRows -authToken $AuthToken -dataSetId $pbiDataSet.Id -tableName $TableName -batchSize $BatchSize
        }
    }
}

Function Get-PBIImports{
<#
.SYNOPSIS    
	Gets all the PowerBI imports made by the user and returns as an array of custom objects.
.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string
.PARAMETER ImportId
    The id of the import in PowerBI
.EXAMPLE
		Get-PBIImports -authToken $authToken		

.EXAMPLE
        Get-PBIImports -authToken $authToken
#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$false)] [string] $importId
	)
	
	Write-Verbose "Getting Imports"
	
	$resource = "imports"
	
	if (-not [string]::IsNullOrEmpty($importId))
	{
		$resource = "imports/$importId"
	}	
	
	$result = Invoke-PBIRequest -authToken $authToken -method Get -resource $resource
	
	Write-Output $result
}

Function Import-PBIFile{
	[CmdletBinding()]		
	param(		
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$false)] [string] $dataSetName,
		[Parameter(Mandatory=$false)]
		[ValidateSet("Abort","Overwrite","Ignore")]
		[string]$nameConflict = "Ignore",
		[Parameter(Mandatory=$true)] [string]$filePath		
	)
		
	$fileName = [uri]::EscapeDataString([IO.Path]::GetFileName($filePath))
	
	if ([string]::IsNullOrEmpty($dataSetName))
	{
		$dataSetName = $fileName
	}			    			
	
	$boundary = [System.Guid]::NewGuid().ToString("N")   
		
	$fileBin = [IO.File]::ReadAllBytes($filePath)	      
    
	$enc = [System.Text.Encoding]::GetEncoding("iso-8859-1")
	
	$fileEnc = $enc.GetString($fileBin)	
	
    $LF = [System.Environment]::NewLine
	
	$bodyLines = (
		"--$boundary",
		"Content-Disposition: form-data; name=`"file0`"; filename=`"$fileName`"; filename*=UTF-8''$fileName",
		"Content-Type: application/x-zip-compressed$LF",
		$fileEnc,
		"--$boundary--$LF"
	) -join $LF			

    $result = Invoke-PBIRequest -authToken $authToken -method Post -resource "imports?datasetDisplayName=$dataSetName&nameConflict=$nameConflict" `
        -ContentType "multipart/form-data; boundary=--$boundary" -Body $bodyLines
	
	Write-Output $result
}

Function Export-PBIReport{
<#
.SYNOPSIS    
	Download reports as PBIX files to the specified folder.

.EXAMPLE	

	Get-Report -name "SampleReport" | Export-PBIReport

.EXAMPLE	

	# Get's all reports from current workspace and saves them on the destination folder
	Get-PBIReport | Export-PBIReport -destinationFolder ".\OutputFolder"

.EXAMPLE

	Export-PBIReport -report {ReportGUID}

.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER Report
	The PBI Report Object or Report Id (GUID)

.PARAMETER destinationFolder
	A string with the path to the destination folder

.PARAMETER Timeout
	Timeout seconds for the export HTTP request

#>
	[CmdletBinding()]
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $report,
		[Parameter(Mandatory=$false)] [string] $destinationFolder = ".",
		[Parameter(Mandatory=$false)] [int] $timeout = 300
	)

	begin
	{
		# ensure folder
		New-Item -ItemType Directory -Path $destinationFolder -Force -ErrorAction SilentlyContinue | Out-Null   		
	}
	process
	{		       
		if ($report -is [string])
		{			
			$report = Get-PBIReport -authToken $authToken -id $report
		}		

		Write-Verbose "Downloading report '$($report.id)' to '$destinationFolder\$($report.name).pbix"
	
		Invoke-PBIRequest -authToken $authToken -method Get -resource "reports/$($report.id)/Export" -TimeoutSec $timeout -OutFile "$destinationFolder\$($report.name).pbix" | Out-Null
	}    
}

Function Copy-PBIReports{
<#
.SYNOPSIS    
	Duplicate reports by suppling a list of the reports to copy.
	Returns an object containing the new reports' metadata.
.EXAMPLE
	Copy-PBIReport -authToken $authToken -reportsObj $reportsObj

.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER ReportsObj
	An hashtable with the following structure:

	$reports = @(
				@{
					originalReportId = "7b32b78f-6336-4a2d-9b68-47w783f6c74e"
					targetName = "Copied Report"
					targetWorkspaceId = "2073317d-3bed-4165-916e-ca0aa2b95ed9"
					targetModelId = "154f4378-b161-4a7e-a491-2523941d295c"
				}
			)
	or
	$reports = @(
				@{
					originalReportName = "Original Report"
					targetName = "Copied Report"
					targetWorkspaceName = "Some Workspace"
					targetModelName = "Some Dataset"
				}
			)
	
	originalReportId or originalReportName - The id or name of the report to copy
	targetName - (Opcional) The name of the new report. If not setted,it will use the same name as the original report.
	targetWorkspaceId or targetWorkspaceName- (Opcional) The id or name of the destination workspace. If not setted, the copy will be made to the actual workspace.
	targetModelId or targetWorkspaceName - (Opcional) The id or name of the dataset to bind the new report. Mandatory if targetWorkspaceId or targetWorkspaceName is setted.

#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$false)] $reportsObj
	)	

	$reports = Get-PBIReport -authToken $authToken

	$workspaces = Get-PBIGroup -authToken $authToken	

	if ($reportsObj)
	{		
		$reportsObj | ForEach-Object{
		
			$report = Find-ByIdOrName -items $reports -id $_.originalReportId -name $_.originalReportName
			
			if ($report.Count -ne 0)
			{
				if (-not [string]::IsNullOrEmpty($_.targetName)){
					$bodyObj = @{name=$_.targetName}
				}
				else{
					$bodyObj = @{name=$report.name}
				}

				if (($_.targetWorkspaceId -or $_.targetWorkspaceName) -and ($_.targetModelId -or $_.targetModelName)){

					$workspace = Find-ByIdOrName -items $workspaces -id $_.targetWorkspaceId -name $_.targetWorkspaceName
					
					if ($workspace.Count -ne 0)
					{
						$workspaceDatasets = Get-PBIGroupDatasets -authToken $authToken -groupId $workspace.id

						$dataset = Find-ByIdOrName -items $workspaceDatasets -id $_.targetModelId -name $_.targetModelName

						if ($dataset.Count -ne 0){
							$bodyObj.targetWorkspaceId = $workspace.id
							$bodyObj.targetModelId = $dataset.id
						}
						else {
							throw "Cannot find dataset '$($_.targetModelId)/$($_.targetModelName)'"
						}
					}
					else
					{
						throw "Cannot find workspace '$($_.targetWorkspaceId)/$($_.targetWorkspaceName)'"
					}
				}				

                $res = Invoke-PBIRequest -authToken $authToken -method Post -resource "reports/$($report.id)/Clone" -Body ($bodyObj | ConvertTo-Json)

				Write-Output $res				
			}
			else
			{
				throw "Cannot find report '$($_.reportName)'"
			}
		}		
	}
}


Function Set-PBIReportsDataset{
<#
.SYNOPSIS    
	Rebind reports to another dataset on the same workspace.

.EXAMPLE
	Set-PBIReportsDataset -report "ReportId" -targetDatasetId "DataSetId"

.EXAMPLE
	Get-PBIReport | Set-PBIReportsDataset -targetDatasetId "DataSetId"

.EXAMPLE
	# Rebind all the reports from Source DataSet to the Target DataSet
	Set-PBIReportsDataset -sourceDatasetId "SourceDataSetId" -targetDatasetId "DataSetId"

.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER report
	The PBI Report Object or Report Id (GUID) 

.PARAMETER sourceDataSetId
	A string with the source dataset id, when executed with this parameter all the reports that target the source dataset will be rebinded

.PARAMETER targetDatasetId
	A string with the new dataset id to bind the reports

#>
	[CmdletBinding(DefaultParameterSetName = 'default')]
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true, ParameterSetName="default")] $report,
		[Parameter(Mandatory=$true, ParameterSetName="sourceDS")] $sourceDatasetId,		
		[Parameter(Mandatory=$true)] [string] $targetDatasetId,		
		[Parameter(Mandatory=$false)] [int] $timeout = 300
	)
	
	begin
	{		
		$targetDataSet = Get-PBIDataSet -authToken $authToken -id $targetDatasetId
		
		if ($PSCmdlet.ParameterSetName -eq 'sourceDS')
		{
			# Get all reports that target the source dataset

			$reportArray = @(Get-PBIReport -authToken $authToken) |? datasetId -eq $sourceDatasetId
		}	
	}
	process
	{		          
		if (!$reportArray)
		{
			if ($report -is [string])
			{			
				$report = Get-PBIReport -authToken $authToken -id $report
			}		

			$reportArray = @($report) 
		}

		$reportArray |% {
		
			$report = $_

			Write-Verbose "Rebinding report '$($report.name)' (id: $($report.id)) to dataset $($targetDataSet.name) (id: $($targetDataSet.id))"

			$bodyObj = @{datasetId=$targetDataSet.id}				
			
			Invoke-PBIRequest -authToken $authToken -method Post -resource "reports/$($report.id)/Rebind" -Body ($bodyObj | ConvertTo-Json)

		}				
	}       
}

Function Request-PBIDatasetRefresh{
<#
.SYNOPSIS    
	Refresh one or more datasets

.EXAMPLE
	Request-PBIDatasetRefresh -dataset "GUID"

.EXAMPLE
	Get-PBIDataSet -name "Dataset name" | Request-PBIDatasetRefresh

.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

#>
	[CmdletBinding()][Alias("Update-PBIDataset")]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $dataset
	)
	
	begin {}
	process
	{		          
		if ($dataset -is [string])
		{			
			$dataset = Get-PBIDataSet -authToken $authToken -id $dataset
		}	

		Invoke-PBIRequest -authToken $authToken -method Post -resource "datasets/$($dataset.id)/refreshes"

        Write-Verbose "Sent refresh command for dataset '$($dataset.name)' (id: $($dataset.id))"
	}     
}

Function Get-PBIDatasetRefreshHistory{
<#
.SYNOPSIS    
	Get refresh history of one or more datasets

.EXAMPLE
	Get-PBIDatasetRefreshHistory -dataset "GUID"

.EXAMPLE
	Get-PBIDataSet -name "Dataset name" | Get-PBIDatasetRefreshHistory	

.PARAMETER AuthToken
	The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER Top
	Limit the number of items returned by the top N

#>
	[CmdletBinding()]		
	param(
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $dataset,
		[Parameter(Mandatory=$false)] [int] $top
	)
	
	begin {}
	process
	{		          
		if ($dataset -is [string])
		{			
			$dataset = Get-PBIDataSet -authToken $authToken -id $dataset
		}	

		if ($dataset.isRefreshable)
        {
            $uriScope="datasets/$($dataset.id)/refreshes"
				
            if ($top){
                $uriScope+="/?`$top=$top"
            }
				
            Write-Verbose "Getting Refresh History for DataSet: $($dataset.name)"

            $res = Invoke-PBIRequest -authToken $authToken -method Get -resource $uriScope

            Write-Output $res    
        }
        else
        {
            Write-Verbose "DataSet '$($dataset.name)' is not refreshable"
		}  
	}   	
}

function Get-PBIDatasetParameters{
<#
.SYNOPSIS    
	Gets all parameters available in one or more datasets.
		
.EXAMPLE
	Get-PBIDatasetParametersy -dataset "GUID"

.EXAMPLE
	Get-PBIDataSet -name "Dataset name" | Get-PBIDatasetParameters

.PARAMETER AuthToken
	The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $dataset
	)
	
	begin {}
	process
	{		          
		$res = Invoke-PBIRequest -authToken $authToken -method Get -resource "datasets/$($dataset.id)/parameters"

        Write-Output $res
	}   
}

function Set-PBIDatasetParameters{
<#
.SYNOPSIS    
	Change parameter values in one or more datasets.
		
.EXAMPLE
	Set-PBIDatasetParameters -dataset "GUID" -parameters @(...)

.EXAMPLE
	Get-PBIDataSet -name "Dataset name" | Set-PBIDatasetParameters -parameters @(...)

.PARAMETER AuthToken
	The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER Parameters
	An hashtable with the following structure:

	$parameters = @(
            @{
                name="ParameterName"
                newValue="NewParameterValue"
			},
			...
        )

#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $dataset,
		[Parameter(Mandatory=$true)] $parameters
	)

	begin {}
	process
	{		          
		$bodyObj = @{updateDetails=$parameters}

        Invoke-PBIRequest -authToken $authToken -method Post -resource "datasets/$($dataset.id)/UpdateParameters" -Body ($bodyObj | ConvertTo-Json)			

        Write-Verbose "Parameters changed on dataset $($dataset.name) $($dataset.id)"	
	}   
}


Function Update-PBIDatasetDatasources {
<#
.SYNOPSIS
    Update the datasource of a dataset
.DESCRIPTION
	Changes the connection string of an existing dataset in PowerBI
.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string
.PARAMETER DatasetId
    The Id of the dataset which conection is to be modified. 
.PARAMETER DatasourceType
    The type of the datasource. The type cannot be changed from original to target.
	e.g. "AnalysisServices" or "Sql"
.PARAMETER OriginalServer
    Original server.
.PARAMETER originalDatabase
    Original database.
.PARAMETER TargetServer
    New Server.
.PARAMETER TargetDatabase
    New database.
.EXAMPLE
    Update-PBIDatasetDatasources -datasetId xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -datasourceType AnalysisServices -originalServer "asazure://eastus.asazure.windows.net/myssas" -originalDatabase  "wideworldimporters" -targetServer  "asazure://eastus.asazure.windows.net/myssas" -targetDatabase "wideworldimporters2"
#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true)] $datasetId,
		[Parameter(Mandatory=$true)] $datasourceType,
		[Parameter(Mandatory=$true)] $originalServer,
		[Parameter(Mandatory=$true)] $originalDatabase,
		[Parameter(Mandatory=$true)] $targetServer,
		[Parameter(Mandatory=$true)] $targetDatabase
	)
  
	
	$body = @"
{ 
  "updateDetails":[ 
    { 
      "connectionDetails": 
      { 
        "server": "$($targetServer)", 
        "database": "$($targetDatabase)" 
      }, 
      "datasourceSelector": 
      {         
        "datasourceType": "$($datasourceType)", 
        "connectionDetails":  
        { 
          "server": "$($originalServer)", 
          "database": "$($originalDatabase)" 
        } 
      } 
    } 
  ] 
} 
"@

    # documentation at https://msdn.microsoft.com/en-us/library/mt814715.aspx

    Invoke-PBIRequest -authToken $authToken -method Post -resource "datasets/$datasetId/updatedatasources" -Body $body		

}

Function Get-PBIDatasources{
<#
.SYNOPSIS    
	Gets DataSet connections
		

#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true)] [string] $dataSetId
	)
    
    $result = Invoke-PBIRequest -authToken $authToken -method Get -resource "datasets/$dataSetId/dataSources" -Body $body

    Write-Output $result			
}

Function Invoke-PBIRequest{
<#
.SYNOPSIS    
	Invoke a raw PBI Post/Get
		
#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true)] [string] $resource,
        [Parameter(Mandatory=$false)] [ValidateSet('Get','Post','Delete', 'Put')] [string] $method = "Get",
        [Parameter(Mandatory=$false)] $body,
        [Parameter(Mandatory=$false)] [switch] $ignoreGroup = $false,
        [Parameter(Mandatory=$false)] [ValidateSet('Individual','Admin')] [string] $scope = "Individual",
        [Parameter(Mandatory=$false)] [string] $contentType = "application/json",
        [Parameter(Mandatory=$false)] [int] $timeoutSec = 240,
        [Parameter(Mandatory=$false)] [string] $outFile
	)
	  	
    if ([string]::IsNullOrEmpty($authToken))
	{
		$authToken = Get-PBIAuthToken
	}	

	$headers = @{
		'Content-Type'= $contentType
		'Authorization'= "Bearer $authToken"
		}    

    try
    {

        $result = Invoke-RestMethod -Uri (Get-PowerBIRequestUrl -scope $resource -ignoreGroup:$ignoreGroup) -Headers $headers -Method $method -Body ($body) -ContentType $contentType `
            -TimeoutSec $timeoutSec -OutFile $outFile        

		if ($result.value)
		{
			Write-Output $result.value
		}
		else {
			Write-Output $result
		}        
    }
    catch [System.Net.WebException]
    {
        $ex = $_.Exception

        try
        {
            $stream = $_.Exception.Response.GetResponseStream()

            $reader = New-Object System.IO.StreamReader($stream)

            $errorContent = $reader.ReadToEnd()
          
            $message = "$($ex.Message) - '$errorContent'"

            Write-Error -Exception $ex -Message $message
        }
        finally
        {
            if ($reader) { $reader.Dispose() }
            
            if ($stream) { $stream.Dispose() }
        }       		
    }
}

#region Private Methods

Function Get-PowerBIRequestUrl{	
	[CmdletBinding()]	
	param(													
		[Parameter(Mandatory=$true)] [string] $scope,				
		[Parameter(Mandatory=$false)] [switch] $ignoreGroup = $false	
	)
					
	$groupId = $script:pbiGroupId

	if ($ignoreGroup)
	{
		$groupId = $null
	}

	if ([string]::IsNullOrEmpty($groupId))
	{
		return "$script:pbiAPIUrl/$scope"
	}
	else
	{
		return "$script:pbiAPIUrl/groups/$groupId/$scope"
	}
	
}



Function ConvertTo-PBIJson{
	param(		
			$obj,
			[hashtable] $types
		)
		
	$jsonBody = $obj | ConvertTo-Json -Depth 4
	
	# If custom types are defined change them	
	
	if ($types -ne $null -and $types.count -ne 0)
	{
		# Workaround to not have issues with DateTimes & ConvertTo-Json (http://stackoverflow.com/questions/26067906/format-a-datetime-in-powershell-to-json-as-date1411704000000)
	
		Write-Verbose "Changing dataset types"
		
		$jsonObj = ConvertFrom-Json $jsonBody
		
		$tables = $jsonObj.tables
		
		if (-not $tables)
		{	
			$tables = @($jsonObj)
		}
		
		$tables |% {
				$table = $_
				$table.columns |% {
					
					$typeKey = "$($table.name).$($_.name)"
					
					if ($types.containsKey($typeKey))
					{
						$_.dataType = $types[$typeKey]
					}			
				}
			}
		
		$jsonBody = $jsonObj | ConvertTo-Json -Depth 4	
	}
	
	$jsonBody
}

Function ConvertTo-PBIDataSet($dataSet)
{
	$ds = @{
			name = $dataSet.DataSetName
		    ; tables = $dataSet.Tables |%{
				
				$table = $_
				
				ConvertTo-PBITableFromDataTable $table									
			}						
		}
		
	return $ds
}

Function ConvertTo-PBITableFromDataTable($table)
{												
	$pbiTable = @{ 
		name = $table.TableName
		; columns = $table.Columns |% {
			$column = $_
			
			$columnTypeName = $column.DataType.Name
			
			$pbiTypeName = ConvertTo-PBIDataType $column.DataType.Name 		
											
			return @{ name = $column.ColumnName; dataType = $pbiTypeName  }
		}												
	}											
		
	return $pbiTable
}

Function ConvertTo-PBITable($obj, $name)
{				
	$pbiTable = @{name = $name; columns = @()}
	
	if ($obj -is [System.Data.DataTable])
	{
		$pbiTable = ConvertTo-PBITableFromDataTable $obj						
	}
	elseif($obj -is [array] -and $obj[0] -is [System.Data.DataRow])
	{
		$pbiTable = ConvertTo-PBITableFromDataTable $obj[0].Table
	}
	else
	{
		$sampleRow = $obj | Select -First 1							
				
		if ($sampleRow -is [hashtable])
		{
			$properties = $sampleRow.Keys | Select @{N="Name";E={$_}}
		}			
		elseif ($sampleRow.PSStandardMembers.DefaultDisplayPropertySet)
		{
			$properties = $sampleRow | Get-Member -MemberType *Property -Name $sampleRow.PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames	
		}
		else
		{
			$properties = $sampleRow | Get-Member -MemberType *Property
		}
					
		$properties |% {
			
			$value = $sampleRow.$($_.Name)

            if ($value -ne $null)
            {
                $typeName = $value.GetType().Name
			
			    $pbiDataType = ConvertTo-PBIDataType $typeName
            }
            else
            {
                $typeName = "string"
            }            
							
			$pbiTable.columns += @{name = $_.Name; dataType = $pbiDataType}				
		}
	}									
		
	return $pbiTable
}

Function ConvertTo-PBITableData($data)
{			
	# DataTable already define the columns that are to be uploaded
	
	if ($data -is [System.Data.DataTable])
	{
		return $data
	}
	
	$sampleRow = $data | Select -First 1							
			
	if ($sampleRow -is [System.Data.DataRow])
	{
		return (,$sampleRow.Table)
	}
	elseif ($sampleRow -is [hashtable])
	{				
		# Hashtable already defines the properties to send to PBI
		return $data
	}			
	elseif ($sampleRow.PSStandardMembers.DefaultDisplayPropertySet)
	{
		$properties = $sampleRow | Get-Member -MemberType *Property -Name $sampleRow.PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames	
	}
	else
	{
		$properties = $sampleRow | Get-Member -MemberType *Property
	}
	
	$data = $data | select @($properties | Select -ExpandProperty Name)	
	
	return $data				
}

Function ConvertTo-PBIDataType($typeName, $errorIfNotCompatible = $true)
{			
	$pbiTypeName = switch -regex ($typeName) 
    { 
        "Int(?:\d{2})?" {"Int64"}
		"Double|Decimal" {"Double"}
		"Boolean" {"bool"}
		"Datetime" {"Datetime"}
		"String" {"String"}
        default {
			if ($errorIfNotCompatible)
			{
				throw "Type '$typeName' not supported in PowerBI"
			}			
		}
    }	
	
	return $pbiTypeName
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
		
		Assert-DataSetTableObjectSchema $table
		
	}
}

Function Assert-DataSetTableObjectSchema($table)
{				
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

Function Resolve-GroupId($authToken, $groupId, $groupName)
{		
	if (-not [string]::IsNullOrEmpty($groupName))
	{
		$groupId = @(Get-PBIGroup -authToken $authToken -name $groupName)[0].id
	}	
	
	return $groupId
}

function Get-PBIGroupDatasets ($authToken, $groupId) {
	$actualGroupId = $script:pbiGroupId
	try{
		Set-PBIGroup -authToken $authToken -id $groupId
		$datasets = Get-PBIDataSet -authToken $authToken
	}
	finally{
		Set-PBIGroup -authToken $authToken -id $actualGroupId
	}
	return $datasets
}

function Find-ByIdOrName ($items, $id, $name) {
	
	if (![string]::IsNullOrEmpty($id)){
		Write-Output @($items | Where-Object id -eq $id)
	}
	elseif (![string]::IsNullOrEmpty($name)){
		Write-Output @($items | Where-Object name -eq $name)
		}
		else {
			Write-Output $items
		}		
}

#endregion