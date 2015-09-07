cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

# Import the PowerBIPS Powershell Module: https://github.com/DevScope/powerbi-powershell-modules
Import-Module "$currentPath\..\PowerBIPS" -Force

# Import the InvokeTwitterAPIs module: https://github.com/MeshkDevs/InvokeTwitterAPIs
Import-Module "$currentPath\Modules\InvokeTwitterAPIs.psm1" -Force

#region Twitter Settings

# Learn how to generate these keys at: https://dev.twitter.com/oauth and https://apps.twitter.com
$accessToken = "your access token key"
$accessTokenSecret = "your access token secret"
$apiKey = "your api key"
$apiSecret = "your api secret"

$twitterOAuth = @{'ApiKey' = $apiKey; 'ApiSecret' = $apiSecret; 'AccessToken' = $accessToken; 'AccessTokenSecret' = $accessTokenSecret}

#endregion

$sinceId = $null
$sinceIdFilePath = "$currentPath\twitterDemoSinceId.txt"

while($true)
{	
	if (Test-Path $sinceIdFilePath)
	{
		$sinceId = Get-Content $sinceIdFilePath
	}	

	# Hashtags to search (separated by comma) and the number of tweets to return, more examples of search options: https://dev.twitter.com/rest/public/search

	$twitterAPIParams = @{'q'='#powerbi';'count' = '5'}

	if (-not [string]::IsNullOrEmpty($sinceId))
	{
		$twitterAPIParams.Add("since_id", $sinceId)
	}

	# Ger Twitter Data (if SinceId is not Null it will get tweets since that one)

	$result = Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/search/tweets.json' -RestVerb 'GET' -Parameters $twitterAPIParams -OAuthSettings $twitterOAuth -Verbose

	# Parse the Twitter API data

	$twitterData = $result.statuses |? { [string]::IsNullOrEmpty($sinceId) -or $sinceId -ne $_.id_str } |% {
	
		$aux = @{
			Id = $_.id_str
			; UserId = $_.user.id
			; UserName = $_.user.name
			; UserScreenName = $_.user.screen_name
			; UserLocation = $_.user.location
			; Text = $_.text
			; CreatedAt =  [System.DateTime]::ParseExact($_.created_at, "ddd MMM dd HH:mm:ss zzz yyyy", [System.Globalization.CultureInfo]::InvariantCulture)		
		}

		# Get the Sentiment Score

		$textEncoded = [System.Web.HttpUtility]::UrlEncode($aux.Text, [System.Text.Encoding]::UTF8)

		$sentimentResult = Invoke-RestMethod -Uri "http://www.sentiment140.com/api/classify?text=$textEncoded" -Method Get -Verbose

		switch($sentimentResult.results[0].polarity)
		{
			"0" { $aux.Add("Sentiment", "Negative") }
			"4" { $aux.Add("Sentiment", "Positive") }
			default { $aux.Add("Sentiment", "Neutral") }
		}
		
		Write-Output $aux
	}

	if ($twitterData -and $twitterData.Count -ne 0)
	{
		# Persist the SinceId

		$sinceId = ($twitterData | Sort-Object "CreatedAt" -Descending | Select -First 1).Id
		
		Set-Content -Path $sinceIdFilePath -Value $sinceId

		# Send the data to PowerBI

		$twitterData | Out-PowerBI -dataSetName "TwitterPBIAnalysis" -tableName "Tweets" -types @{"Tweets.CreatedAt"="datetime"} -verbose
	}
	else
	{
		Write-Output "No tweets found."
	}

	Write-Output "Sleeping..."

	Sleep -Seconds 30
}