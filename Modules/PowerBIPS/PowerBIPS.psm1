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
.DESCRIPTION
Sets the module config variables like: API Url, App Id,...
.PARAMETER PBIAPIUrl
The url for the PBI API
.PARAMETER AzureADAppId
Your Azure AD Application Id
.PARAMETER AzureADAuthorityUrl
Url to the Azure AD Authority URL
Default: "https://login.microsoftonline.com/common/oauth2/authorize"
.PARAMETER AzureADRedirectUrl
Url to the Redirect Url of the Azure AD App
Default: "https://login.live.com/oauth20_desktop.srf"
.EXAMPLE
Set-PBIModuleConfig -pbiAPIUrl "https://api.powerbi.com/beta/myorg" -AzureADAppId "YOUR Azure AD GUID"
#>
    [CmdletBinding()]
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
		.DESCRIPTION
		Gets the module config variables like: API Url, App Id,...          
		.EXAMPLE
		Get-PBIModuleConfig
	#>
	[CmdletBinding()]
	param()

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
    
    [CmdletBinding()]
    [OutputType([string])]
    param
    (        
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,
        [Parameter(Mandatory=$false)]
        [switch]
		$ForceAskCredentials = $false,
		[Parameter(Mandatory=$false)]
        [string]
		$clientId,
		[Parameter(Mandatory=$false)]
        [string]
        $redirectUri
	)

    if ($Script:AuthContext -eq $null)
    {
        Write-Verbose -Message 'Creating new AuthenticationContext object'
        $script:AuthContext = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext -ArgumentList ($script:pbiAuthorityUrl)
    }

	if ([string]::IsNullOrEmpty($clientId))
	{
		$clientId = $script:pbiDefaultClientId
	}
	
	if ([string]::IsNullOrEmpty($redirectUri))
	{
		$redirectUri = $script:pbiDefaultAuthRedirectUri
	}
	
	Write-Verbose -Message 'Getting the Authentication Token'
	
    if ($PSCmdlet.ParameterSetName -eq 'credential')
    {
        Write-Verbose -Message 'Using username+password authentication flow'
		
		$UserCredential = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.UserPasswordCredential($Credential.UserName, $Credential.Password)
		
        $AuthResult = [Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContextIntegratedAuthExtensions]::AcquireTokenAsync($script:AuthContext
        , $script:pbiResourceUrl
		, $clientId
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
			, $clientId, [Uri]$redirectUri
			, $pltParams
		).Result        
    }

	Write-Verbose -Message "Authenticated as $($AuthResult.UserInfo.DisplayableId)"
	
    $AuthResult.AccessToken
}

Function Set-PBIGroup{
<#
.SYNOPSIS
   Set's the scope to the group specified, after execution all the following PowerBIPS cmdlets will execute over the defined group.
.DESCRIPTION
   Set's the scope to the group specified, after execution all the following PowerBIPS cmdlets will execute over the defined group.
.PARAMETER AuthToken
    The authorization token required to communicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string
.PARAMETER Id
    The id of the group
.PARAMETER Name
    The name of the group
.PARAMETER Clear
    If $true then will clear the group and all the requests will be made to the default user workspace
.EXAMPLE
	Set-PBIGroup -id "GUID"
.EXAMPLE
	Set-PBIGroup -name "Group Name"
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

Function Get-PBIGroup{
	<#
	.SYNOPSIS 
		Gets all the PowerBI existing workspaces
	.DESCRIPTION 
		Gets all the PowerBI existing workspaces
	.PARAMETER AuthToken
    	The authorization token required to communicate with the PowerBI APIs
		Use 'Get-PBIAuthToken' to get the authorization token string	
	.PARAMETER Name
		The name of the workspace	
	.PARAMETER id
		The id of the workspace
	.EXAMPLE	
		Get-PBIWorkspace -authToken $authToken		
	.EXAMPLE	
		Get-PBIWorkspace -authToken $authToken -name "Group Name"
	.EXAMPLE	
		Get-PBIWorkspace -authToken $authToken -id "GUID"
	
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
.PARAMETER authToken
	The authorization token required to communicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string	
.PARAMETER groupId
	The id of the group
.EXAMPLE
	Get-PBIGroupUsers -authToken $authToken	-groupId "GUID"	

#>
	[CmdletBinding()][Alias("Get-PBIWorkspaceUsers")]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$false)] [string] $groupId
	)

	Write-Verbose "Getting Users"

	$users = Invoke-PBIRequest -authToken $authToken -method Get -resource "users" -groupId $groupId	 				
	
	Write-Output $users	
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

	$res = Invoke-PBIRequest -authToken $authToken -method Post -resource "groups" -Body $body -ignoreGroup	
	
	Write-Output $res
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
		[Parameter(Mandatory=$true)] [string] $groupId,
		[Parameter(Mandatory=$true)] [string] $emailAddress,
		[Parameter(Mandatory=$false)]
		[ValidateSet("Admin", "Member")]
		[string]$groupUserAccessRight = "Admin"	
	)	

	$body = @{
		groupUserAccessRight = $groupUserAccessRight
		emailAddress = $emailAddress
	} | ConvertTo-Json	

	$result = Invoke-PBIRequest -authToken $authToken -method Post -resource "users" -Body $body -groupId $groupId	

	Write-Output $result	
}

Function Get-PBIReport{
<#
.SYNOPSIS    
	Gets an array of Power BI Report metadata from a workspace
.DESCRIPTION
	Gets an array of Power BI Report metadata from a workspace
.PARAMETER AuthToken
    The authorization token required to communicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string
.PARAMETER Id
    The id of the report
.PARAMETER Name
	The name of the report
.PARAMETER GroupId
	Id of the workspace where the reports will get pulled
.EXAMPLE
	Get-PBIReport -authToken $authToken -id "GUID"
.EXAMPLE
	Get-PBIReport -authToken $authToken -id "GUID" -groupId "GUID"
.EXAMPLE
	Get-PBIReport -authToken $authToken -name "Report Name" -groupId "GUID"
#>
		[CmdletBinding()]		
		param(									
			[Parameter(Mandatory=$false)] [string] $authToken,
			[Parameter(Mandatory=$false)] [string] $name,
			[Parameter(Mandatory=$false)] [string] $id,
			[Parameter(Mandatory=$false)] [string] $groupId		
		)
					
		Write-Verbose "Getting Reports"

		$resource = "reports"

		if (![string]::IsNullOrEmpty($id))
		{
			$resource += "/$id"
		}

		$reports = @(Invoke-PBIRequest -authToken $authToken -method Get -resource $resource -groupId $groupId)
						
		Write-Verbose "Found $($reports.count) reports."

		$reports = Find-ByIdOrName -items $reports -id $id -name $name
		
		Write-Output $reports
}

Function Set-PBIReportContent{
<#
.SYNOPSIS    
	Replaces a target reports content with content from another source report in the same or different workspace
.DESCRIPTION
	Replaces a target reports content with content from another source report in the same or different workspace
.PARAMETER AuthToken
	The authorization token required to communicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string
.PARAMETER report
	The PBI Report Object or Report Id (GUID)
.PARAMETER targetReportId
	The target report id that content will get overwriten
.PARAMETER targetGroupId
	The target report workspace id
.EXAMPLE
	$sourceReport = Get-PBIReport -name "SourceReportName"
	$targetReport = Get-PBIReport -name "TargetReportName"
	$sourceReport | Set-PBIReportContent -targetReportId $targetReport.id
#>
		[CmdletBinding()]		
		param(									
			[Parameter(Mandatory=$false)] [string] $authToken,
			[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $report,
			[Parameter(Mandatory=$false)] [string] $groupId,
			[Parameter(Mandatory=$true)] [string] $targetReportId,
			[Parameter(Mandatory=$false)] [string] $targetGroupId		
		)
	begin{

	}	
	process
	{
		if ($report -is [string])
		{			
			$report = Get-PBIReport -authToken $authToken -id $report -groupId $groupId
		}	

		$bodyObj = @{
			sourceType="ExistingReport"
			sourceReport=@{
				sourceReportId = $report.id
				sourceWorkspaceId = $groupId
			}
		}

		$targetReport = Get-PBIReport -groupId $targetGroupId -id $targetReportId

		Invoke-PBIRequest -authToken $authToken -method Post -groupId $groupId -resource "reports/$($targetReport.id)/UpdateReportContent" -Body ($bodyObj | ConvertTo-Json)		
	}	
}

Function Get-PBIDashboard{
<#
.SYNOPSIS 
	Gets all the PowerBI existing dashboards and returns as an array of custom objects.
.DESCRIPTION 
	Gets all the PowerBI existing dashboards and returns as an array of custom objects.
.PARAMETER AuthToken
    The authorization token required to communicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string
.PARAMETER Id
    The id of the dashboard
.PARAMETER Name
	The name of the dashboard
.PARAMETER GroupId
	Id of the workspace where the reports will get pulled
.EXAMPLE			
	Get-PBIDashboard -authToken $authToken		
#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$false)] [string] $name,
		[Parameter(Mandatory=$false)] [string] $id,
		[Parameter(Mandatory=$false)] [string] $groupId	
	)
	
	Write-Verbose "Getting Dashboards"
	
	$dashboards = @(Invoke-PBIRequest -authToken $authToken -method Get -resource "dashboards" -groupId $groupId)		
	
	Write-Verbose "Found $($dashboards.count) dashboard."			

	Write-Output (Find-ByIdOrName -items $dashboards -id $id -name $name)		
}

Function Get-PBIDashboardTile{
<#
.SYNOPSIS    
	Gets all the tiles for a specific dashboard.
.DESCRIPTION    
	Gets all the tiles for a specific dashboard.
.PARAMETER AuthToken
    The authorization token required to communicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string
.PARAMETER dashboardId
    The id of the dashboard
.PARAMETER tileId
	The id of the tile
.PARAMETER GroupId
	Id of the workspace where the reports will get pulled		
.EXAMPLE
			
	Get-PBIDashboardTile -dashboard "XXXX-XXXX-XXXX"		

.EXAMPLE
			
	Get-PBIDashboard -id "GUID" | Get-PBIDashboardTile	
#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $dashboard,
		[Parameter(Mandatory=$false)] [string] $tileId,
		[Parameter(Mandatory=$false)] [string] $groupId	
	)

	begin
	{		
	}
	process
	{		       
		if ($dashboard -is [string])
		{			
			$dashboard = Get-PBIDashboard -authToken $authToken -id $dashboard
		}		

		$scope = "dashboards/$($dashboard.id)/tiles"

		if (-not [string]::IsNullOrEmpty($tileId))
		{
			$scope += "/$tileId"
		}					

		$tiles = Invoke-PBIRequest -authToken $authToken -method Get -resource $scope -groupId $groupId

		Write-Output $tiles
	}   		
}

Function New-PBIDashboard{
	<#
	.SYNOPSIS
		Create a new Dashboard
	.DESCRIPTION	
		Create a new Dashboard in PowerBI		
	.PARAMETER AuthToken
		The authorization token required to comunicate with the PowerBI APIs
		Use 'Get-PBIAuthToken' to get the authorization token string
	.PARAMETER GroupId
		The id of the group in PowerBI
	.PARAMETER Name
		The name of the new dashboard
	.EXAMPLE
									
			New-PBIDashboard -authToken $authToken -groupId $groupId
			A new dashboard will be created and in case of success return the internal dashboard id
	#>
	[CmdletBinding()]	
	param(									
		[Parameter(Mandatory=$true)] [string] $authToken,		
		[Parameter(Mandatory=$true)] [string] $name,
		[Parameter(Mandatory=$false)] [string] $groupId
	)						
	
	$jsonBody = ConvertTo-PBIJson -obj @{ name = $name }
	
	Write-Verbose "Creating new dashboard"	

	$result = Invoke-PBIRequest -authToken $authToken -method Post -resource "dashboards" -Body $jsonBody -groupId $groupId
	
	Write-Verbose "Dashboard created with id: '$($result.id)"

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
.PARAMETER GroupId
	Id of the workspace where the reports will get pulled	
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
		[Parameter(Mandatory=$false)] [switch] $includeTables,
		[Parameter(Mandatory=$false)] [string] $groupId
	)
	
	if ([string]::IsNullOrEmpty($id))
	{
		Write-Verbose "Getting DataSets"				
		
        $dataSets = @(Invoke-PBIRequest -authToken $authToken -method Get -resource "datasets" -groupId $groupId)				
		
		Write-Verbose "Found $($dataSets.count) datasets."	
		
		$dataSets = Find-ByIdOrName -items $dataSets -name $name				
		
		# if IncludeDefinition is true then go get the definition of the dataset and change the PSObject
		
		if ($includeDefinition)
		{				
			$dataSets |% {
				$dataSet = $_
				
				$dataSetDefinition = Get-PBIDataSet -authToken $authToken -id $_.Id -groupId $groupId -ErrorAction Continue
				
				$dataSetDefinition | Get-Member -MemberType NoteProperty |%{
					
                    $dataSet | Add-Member -MemberType NoteProperty -Name $_.Name -Value $dataSetDefinition.$($_.Name) -Force					
				}								
			}
		}
	}
	else
	{
		Write-Verbose "Getting DataSet Definition"
		
        $dataSets = @(Invoke-PBIRequest -authToken $authToken -method Get -resource "datasets/$id" -groupId $groupId)				
	}
	
	# if IncludeTables is true then call the GetTables operation
	
	if ($includeTables)
	{				
		$dataSets |% {
			$dataSet = $_						
			
			$tables = Get-PBIDataSetTables -authToken $authToken -dataSetId $_.Id -groupId $groupId
					
			$dataSet | Add-Member -MemberType NoteProperty -Name "tables" -Value $tables			
		}
	}
	
	Write-Output $dataSets
}

Function Get-PBIDataSetTables{
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true)] [string] $dataSetId,
		[Parameter(Mandatory=$false)] [string] $groupId		
	)
			
	Write-Verbose "Getting DataSet '$dataSetId' Tables"
		
	try
	{	
		$result = Invoke-PBIRequest -authToken $authToken -method Get -resource "datasets/$dataSetId/tables" -groupId $groupId	
        		
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
.PARAMETER GroupId
	Id of the workspace where the reports will get pulled	
.EXAMPLE
								
		Test-PBIDataSet -authToken $authToken -name "DataSetName"
		Returns $true if the dataset exists

#>
	[CmdletBinding()]	
	[OutputType([bool])]
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true)] $name,
		[Parameter(Mandatory=$false)] [string] $groupId	
	)
			
	$dataSet = Get-PBIDataSet -authToken $authToken -name $name -groupId $groupId
	
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
	Create a new DataSet in PowerBI.com

.DESCRIPTION	
	Create a new DataSet in PowerBI.Com
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

.PARAMETER ignoreIfDataSetExists
	Checks if the dataset exists before the creation
.PARAMETER GroupId
	Id of the workspace where the reports will get pulled	
.EXAMPLE
								
		New-PBIDataSet -authToken $authToken -dataSet $dataSet
		A new dataset will be created and in case of success return the internal dataset id

#>
	[CmdletBinding()]	
	param(									
		[Parameter(Mandatory=$true)] [string] $authToken,
		[Parameter(Mandatory=$true, HelpMessage = "Must be of type [hashtable] or [dataset]")] $dataSet,
		[Parameter(Mandatory=$false)] [string]$defaultRetentionPolicy,
		[Parameter(Mandatory=$false)] [hashtable]$types,
		[switch]$ignoreIfDataSetExists,
		[Parameter(Mandatory=$false)] [string] $groupId	
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
	
	$dsExists = $false

	if ($ignoreIfDataSetExists)
	{
		$jsonObj = $jsonBody | ConvertFrom-Json

		$result = Get-PBIDataSet -authToken $authToken -name $jsonObj.name -groupId $groupId -Verbose

		if ($result -ne $null)
		{
			$dsExists = $true
		}
	}

	if (!$dsExists)
	{
		Write-Verbose "Creating new dataset"	
	
		$resource = "datasets"
		
		if (-not [string]::IsNullOrEmpty($defaultRetentionPolicy))
		{		
			$resource = $resource + "?defaultRetentionPolicy=$defaultRetentionPolicy"
		}		

		$result = Invoke-PBIRequest -authToken $authToken -method Post -resource $resource -body $jsonBody -groupId $groupId				
		
		Write-Verbose "DataSet created with id: '$($result.id)"
			
	}
	else {
		Write-Verbose "Dataset already exists with id: '$($result.id)"
	}
	
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
.PARAMETER GroupId
	Id of the workspace where the reports will get pulled	
.EXAMPLE
								
		Update-PBITableSchema -authToken $authToken -dataSetId <dataSetId> -table <tableSchema>		

#>
	[CmdletBinding()]	
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true)] [string] $dataSetId,				
		[Parameter(Mandatory=$true, HelpMessage = "Must be of type [hashtable] or [datatable]")] $table,
		[Parameter(Mandatory=$false)] [hashtable] $types,
		[Parameter(Mandatory=$false)] [string] $groupId
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
		
    Invoke-PBIRequest -authToken $authToken -method Put -resource "datasets/$dataSetId/tables/$($table.Name)" -body $jsonBody -groupId $groupId	  			
	
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
.PARAMETER GroupId
	Id of the workspace where the reports will get pulled	
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
		[Parameter(Mandatory=$false)] [int] $batchSize = 1000,
		[Parameter(Mandatory=$false)] [string] $groupId		
	)
	
	begin{
						
		$rowsBatch = @()	
		
		if ($PsCmdlet.ParameterSetName -eq "dataSetName")
		{
			$dataSet = Get-PBIDataSet -authToken $authToken -name $dataSetName -groupId $groupId
			
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

    Invoke-PBIRequest -authToken $authToken -method Post -resource "datasets/$dataSetId/tables/$tableName/rows" -body $bodyObj -groupId $groupId | Out-Null
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
.PARAMETER GroupId
	Id of the workspace where the reports will get pulled	
.EXAMPLE
        Clear-PBITableRows -authToken "authToken" -DataSetId "DataSetId" -TableName "Table"

#>
	[CmdletBinding()]
	[CmdletBinding(DefaultParameterSetName = "dataSetId")]	
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ParameterSetName = "dataSetId")] [string] $dataSetId,
		[Parameter(Mandatory=$true, ParameterSetName = "dataSetName")] [string] $dataSetName,
		[Parameter(Mandatory=$true)] [string] $tableName,
		[Parameter(Mandatory=$false)] [string] $groupId		
	)
	
	if ($PsCmdlet.ParameterSetName -eq "dataSetName")
	{
		$dataSet = Get-PBIDataSet -authToken $authToken -name $dataSetName -groupId $groupId
		
		if (-not $dataSet)
		{
			throw "Cannot find a DataSet named '$dataSetName'"
		}
		
		$dataSetId = $dataSet.Id
	}
			
	Write-Verbose "Deleting all the rows of '$tableName' table of dataset '$dataSetId'"

    Invoke-PBIRequest -authToken $authToken -method Delete -resource "datasets/$dataSetId/tables/$tableName/rows" -body $bodyObj -groupId $groupId	 
	
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
.PARAMETER GroupId
	Id of the workspace where the reports will get pulled	
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
		$Types,
		[Parameter(Mandatory=$false)] [string] $groupId
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
        $pbiDataSet = Get-PBIDataSet -authToken $AuthToken -name $DataSetName -groupId $groupId

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
                $pbiDataSet = New-PBIDataSet -authToken $AuthToken -dataSet $dataSet -types $Types -groupId $groupId
            }
            else
            {
                # Updates the schema of all the tables
                $dataSet.tables | Foreach-Object {
                    Update-PBITableSchema -authToken $AuthToken -dataSetId $pbiDataSet.id -table $_ -types $Types -groupId $groupId
                }
            }
        }

        # Upload rows for each table
        foreach ($h in ($dataToProcess.GetEnumerator() | Sort-Object -Property Name))
		{
            $TableName = $h.Name
            $tableData = ConvertTo-PBITableData $h.Value
            $tableData | Add-PBITableRows -authToken $AuthToken -dataSetId $pbiDataSet.Id -tableName $TableName -batchSize $BatchSize -groupId $groupId
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
.PARAMETER GroupId
	Id of the workspace where the reports will get pulled	
.EXAMPLE
		Get-PBIImports -authToken $authToken		

.EXAMPLE
        Get-PBIImports -authToken $authToken
#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$false)] [string] $importId,
		[Parameter(Mandatory=$false)] [string] $groupId
	)
	
	Write-Verbose "Getting Imports"
	
	$resource = "imports"
	
	if (-not [string]::IsNullOrEmpty($importId))
	{
		$resource = "imports/$importId"
	}	
	
	$result = Invoke-PBIRequest -authToken $authToken -method Get -resource $resource -groupId $groupId
	
	Write-Output $result
}

Function Import-PBIFile{
	[CmdletBinding()]		
	param(		
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $file,
		[Parameter(Mandatory=$false)] [string] $dataSetName,
		[Parameter(Mandatory=$false)]
		[ValidateSet("Abort","Overwrite","Ignore")]
		[string]$nameConflict = "Ignore",
		[Parameter(Mandatory=$false)] [string] $groupId
	)
	
	begin
	{			
	}
	process
	{		       
		if ($file -is [System.IO.FileSystemInfo])
		{
			$filePath = $file.FullName
		}
		elseif ($file -is [string]) {
			$filePath = $file
		}
		else {
			throw "Unsuported type for -file"
		}

		$fileName = [uri]::EscapeDataString([IO.Path]::GetFileName($filePath))
	
        $reportDataSetName = $dataSetName

		if ([string]::IsNullOrEmpty($dataSetName))
		{
			$reportDataSetName = $fileName
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

		$result = Invoke-PBIRequest -authToken $authToken -method Post -resource "imports?datasetDisplayName=$reportDataSetName&nameConflict=$nameConflict" `
			-ContentType "multipart/form-data; boundary=--$boundary" -Body $bodyLines -groupId $groupId
		
		Write-Output $result
	}    	
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
		[Parameter(Mandatory=$false)] [int] $timeout = 300,
		[Parameter(Mandatory=$false)] [string] $groupId
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
	
		Invoke-PBIRequest -authToken $authToken -method Get -groupId $groupId -resource "reports/$($report.id)/Export" -TimeoutSec $timeout -OutFile "$destinationFolder\$($report.name).pbix" | Out-Null
	}    
}

Function Copy-PBIReports{
<#
.SYNOPSIS    
	Duplicate reports by suppling a list of the reports to copy.
	Returns an object containing the new reports' metadata.
.EXAMPLE
	Get-PBIReport | Copy-PBIReport -authToken $authToken -targetWorkspaceId GUID -targetDataSetId GUID

.PARAMETER AuthToken
    The authorization token required to comunicate with the PowerBI APIs
	Use 'Get-PBIAuthToken' to get the authorization token string

.PARAMETER report
	The PBI Report Object or Report Id (GUID) 
.PARAMETER targetName
	Name of the report in the target workspace
.PARAMETER targetWorkspaceId
	Target workspace id (GUID)
.PARAMETER targetModelId
	Target dataset id (GUID)
#>
	[CmdletBinding()]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,		
		[Parameter(Mandatory=$true, ValueFromPipeline = $true, ParameterSetName="default")] $report,
		[Parameter(Mandatory=$false)] [string] $targetName,
		[Parameter(Mandatory=$false)] [string] $targetWorkspaceId,
		[Parameter(Mandatory=$false)] [string] $targetModelId,
		[Parameter(Mandatory=$false)] [string] $groupId
	)	

	begin
	{		
	}
	process
	{	
		if ($report -is [string])
		{			
			$report = Get-PBIReport -authToken $authToken -id $report -groupId $groupId
		}		

		if ($report)
		{
			if ([string]::IsNullOrEmpty($targetName)){
				$targetName = $report.name
			}			
			
			$bodyObj = @{
				name=$targetName
				;
				targetWorkspaceId = $targetWorkspaceId
				;				
				targetModelId = $targetModelId
			}

			$res = Invoke-PBIRequest -authToken $authToken -method Post -groupId $groupId -resource "reports/$($report.id)/Clone" -Body ($bodyObj | ConvertTo-Json)

			Write-Output $res	
		}
		else {
			throw "Cannot find report '$report'"
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
		[Parameter(Mandatory=$false)] [int] $timeout = 300,
		[Parameter(Mandatory=$false)] [string] $groupId
	)
	
	begin
	{		
		$targetDataSet = Get-PBIDataSet -authToken $authToken -id $targetDatasetId -groupId $groupId
		
		if ($PSCmdlet.ParameterSetName -eq 'sourceDS')
		{
			# Get all reports that target the source dataset

			$reportArray = @(Get-PBIReport -authToken $authToken -groupId $groupId) |? datasetId -eq $sourceDatasetId
		}	
	}
	process
	{		          
		if (!$reportArray)
		{
			if ($report -is [string])
			{			
				$report = Get-PBIReport -authToken $authToken -id $report -groupId $groupId
			}		

			$reportArray = @($report) 
		}

		$reportArray |% {
		
			$report = $_

			Write-Verbose "Rebinding report '$($report.name)' (id: $($report.id)) to dataset $($targetDataSet.name) (id: $($targetDataSet.id))"

			$bodyObj = @{datasetId=$targetDataSet.id}				
			
			Invoke-PBIRequest -authToken $authToken -method Post -resource "reports/$($report.id)/Rebind" -Body ($bodyObj | ConvertTo-Json) -groupId $groupId

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
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $dataset,
		[Parameter(Mandatory=$false)] [string] $groupId
	)
	
	begin {}
	process
	{		          
		if ($dataset -is [string])
		{			
			$dataset = Get-PBIDataSet -authToken $authToken -id $dataset
		}	

		Invoke-PBIRequest -authToken $authToken -method Post -resource "datasets/$($dataset.id)/refreshes" -groupId $groupId

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
		[Parameter(Mandatory=$false)] [int] $top,
		[Parameter(Mandatory=$false)] [string] $groupId
	)
	
	begin {}
	process
	{		          
		if ($dataset -is [string])
		{			
			$dataset = Get-PBIDataSet -authToken $authToken -id $dataset -groupId $groupId
		}	

		if ($dataset.isRefreshable)
        {
            $uriScope="datasets/$($dataset.id)/refreshes"
				
            if ($top){
                $uriScope+="/?`$top=$top"
            }
				
            Write-Verbose "Getting Refresh History for DataSet: $($dataset.name)"

            $res = Invoke-PBIRequest -authToken $authToken -method Get -resource $uriScope -groupId $groupId

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
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $dataset,
		[Parameter(Mandatory=$false)] [string] $groupId
	)
	
	begin {}
	process
	{		          
		$res = Invoke-PBIRequest -authToken $authToken -method Get -resource "datasets/$($dataset.id)/parameters" -groupId $groupId

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
		[Parameter(Mandatory=$true)] $parameters,
		[Parameter(Mandatory=$false)] [string] $groupId
	)

	begin {}
	process
	{		          
		$bodyObj = @{updateDetails=$parameters}

        Invoke-PBIRequest -authToken $authToken -method Post -resource "datasets/$($dataset.id)/UpdateParameters" -Body ($bodyObj | ConvertTo-Json)	-groupId $groupId	

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
	Update-PBIDatasetDatasources -dataset xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -datasourceType AnalysisServices -originalServer "asazure://eastus.asazure.windows.net/myssas" -originalDatabase  "wideworldimporters" -targetServer  "asazure://eastus.asazure.windows.net/myssas" -targetDatabase "wideworldimporters2"
.EXAMPLE
	Get-PBIDataSet -name "DS Name" | Update-PBIDatasetDatasources -datasourceType AnalysisServices -originalServer "asazure://eastus.asazure.windows.net/myssas" -originalDatabase  "wideworldimporters" -targetServer  "asazure://eastus.asazure.windows.net/myssas" -targetDatabase "wideworldimporters2"
	
#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $dataset,
		[Parameter(Mandatory=$true)] $datasourceType,
		[Parameter(Mandatory=$true)] $originalServer,
		[Parameter(Mandatory=$true)] $originalDatabase,
		[Parameter(Mandatory=$true)] $targetServer,
		[Parameter(Mandatory=$true)] $targetDatabase,
		[Parameter(Mandatory=$false)] [string] $groupId
	)
  		
	begin {

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
	}
	process
	{		          
		if ($dataset -is [string])
		{			
			$dataset = Get-PBIDataSet -authToken $authToken -id $dataset
		}	

		# documentation at https://msdn.microsoft.com/en-us/library/mt814715.aspx

		Invoke-PBIRequest -authToken $authToken -method Post -resource "datasets/$($dataset.id)/updatedatasources" -Body $body -groupId

	} 
}

Function Get-PBIDatasources{
<#
.SYNOPSIS    
	Gets DataSet connections	
#>
	[CmdletBinding()][Alias("Update-PBIDataset")]		
	param(									
		[Parameter(Mandatory=$false)] [string] $authToken,
		[Parameter(Mandatory=$true, ValueFromPipeline = $true)] $dataset,
		[Parameter(Mandatory=$false)] [string] $groupId
	)

	begin {}
	process
	{		          
		if ($dataset -is [string])
		{			
			$dataset = Get-PBIDataSet -authToken $authToken -id $dataset -groupId $groupId
		}	

		$result = Invoke-PBIRequest -authToken $authToken -method Get -resource "datasets/$($dataset.id)/dataSources" -groupId $groupId

    	Write-Output $result
	} 		
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
        [Parameter(Mandatory=$false)] [ValidateSet('Individual','Admin')] [string] $scope = "Individual",
        [Parameter(Mandatory=$false)] [string] $contentType = "application/json",
        [Parameter(Mandatory=$false)] [int] $timeoutSec = 240,
        [Parameter(Mandatory=$false)] [string] $outFile,
		[Parameter(Mandatory=$false)] [string] $groupId,
		[switch]$ignoreGroup = $false
	)
	  	
    if ([string]::IsNullOrEmpty($authToken))
	{
		$authToken = Get-PBIAuthToken
	}	

	$headers = @{
		'Content-Type'= $contentType
		'Authorization'= "Bearer $authToken"
		}    

	if (!$ignoreGroup)
	{
		if (![string]::IsNullOrEmpty($groupId))
		{
			$resource = "groups/$groupId/$resource"
		}		
		elseif (![string]::IsNullOrEmpty($script:pbiGroupId))
		{
			$resource = "groups/$script:pbiGroupId/$resource"
		}
	}

	$resource = "$script:pbiAPIUrl/$resource"

    try
    {
        $result = Invoke-RestMethod -Uri $resource -Headers $headers -Method $method -Body $body -ContentType $contentType `
            -TimeoutSec $timeoutSec -OutFile $outFile        
		
		if ($result -ne $null -and $result.PSObject.Properties['value'])
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
			if ($ex.Response -ne $null)
			{
				$stream = $ex.Response.GetResponseStream()

				$reader = New-Object System.IO.StreamReader($stream)

                $reader.BaseStream.Position = 0

                $reader.DiscardBufferedData()

				$errorContent = $reader.ReadToEnd()
			
				$message = "$($ex.Message) - '$errorContent'"
			}
			else {
				$message = "$($ex.Message) - 'Empty'"
			}

            Write-Error -Exception $ex -Message $message
		}
		catch
		{
			throw;
		}
        finally
        {
            if ($reader) { $reader.Dispose() }
            
            if ($stream) { $stream.Dispose() }
        }       		
    }
}


#region Private Methods

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

# https://stackoverflow.com/a/48154663
function ParseErrorForResponseBody($Error) {
    if ($PSVersionTable.PSVersion.Major -lt 6) {
        if ($Error.Exception.Response) {  
            $Reader = New-Object System.IO.StreamReader($Error.Exception.Response.GetResponseStream())
            $Reader.BaseStream.Position = 0
            $Reader.DiscardBufferedData()
            $ResponseBody = $Reader.ReadToEnd()
            if ($ResponseBody.StartsWith('{')) {
                $ResponseBody = $ResponseBody | ConvertFrom-Json | ConvertTo-Json -Compress
            }
            return $ResponseBody
        }
    }
    else {
        return $Error.ErrorDetails.Message
    }
}

#endregion