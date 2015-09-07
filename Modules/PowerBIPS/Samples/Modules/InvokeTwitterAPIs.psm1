<#	
	===========================================================================
	 Created on:   	2/11/2015 1:04 PM
	 Created by:   	Shannon Conley & Mehmet Kaya
	 Filename:     	InvokeTwitterAPIs.psm1
	-------------------------------------------------------------------------
	 Module Name: InvokeTwitterAPIs
	 Description: Provides a command to call any Twitter REST API,
                  a command to access any of the Twitter Streaming APIs, 
                  and a command to upload media to Twitter.


     List of Twitter REST APIs:
     https://dev.twitter.com/rest/public

     Twitter Streamings APIs Info:
     https://dev.twitter.com/streaming/overview

     To use these commands, you must obtain a Twitter API key, API secret, 
     access token and access token secret
     https://twittercommunity.com/t/how-to-get-my-api-key/7033

     This was developed using Windows PowerShell 4.0.
                  
	===========================================================================
#>

function Get-OAuth {
     <#
          .SYNOPSIS
           This function creates the authorization string needed to send a POST or GET message to the Twitter API

          .PARAMETER AuthorizationParams
           This hashtable should the following key value pairs
           HttpEndPoint - the twitter resource url [Can be found here: https://dev.twitter.com/rest/public]
           RESTVerb - Either 'GET' or 'POST' depending on the action
           Params - A hashtable containing the rest parameters (key value pairs) associated that method
           OAuthSettings - A hashtable that must contain only the following keys and their values (Generate here: https://dev.twitter.com/oauth)
                       ApiKey 
                       ApiSecret 
		               AccessToken
	                   AccessTokenSecret
          .LINK
           This function evolved from code found in Adam Betram's Get-OAuthAuthorization function in his MyTwitter module.
           The MyTwitter module can be found here: https://gallery.technet.microsoft.com/scriptcenter/Tweet-and-send-Twitter-DMs-8c2d6f0a
           Adam Betram's blogpost here: http://www.adamtheautomator.com/twitter-powershell/ provides a detailed explanation
           about how to generate an access token needed to create the authorization string 

          .EXAMPLE
            $OAuth = @{'ApiKey' = 'yourapikey'; 'ApiSecret' = 'yourapisecretkey';'AccessToken' = 'yourapiaccesstoken';'AccessTokenSecret' = 'yourapitokensecret'}	
            $Parameters = @{'q'='rumi'}
            $AuthParams = @{}
            $AuthParams.Add('HttpEndPoint', 'https://api.twitter.com/1.1/search/tweets.json')
            $AuthParams.Add('RESTVerb', 'GET')
            $AuthParams.Add('Params', $Parameters)
            $AuthParams.Add('OAuthSettings', $OAuth)
            $AuthorizationString = Get-OAuth -AuthorizationParams $AuthParams

          
     #>
    [OutputType('System.Management.Automation.PSCustomObject')]
	 Param($AuthorizationParams)
     process{
     try {

    	    ## Generate a random 32-byte string. I'm using the current time (in seconds) and appending 5 chars to the end to get to 32 bytes
	        ## Base64 allows for an '=' but Twitter does not.  If this is found, replace it with some alphanumeric character
	        $OauthNonce = [System.Convert]::ToBase64String(([System.Text.Encoding]::ASCII.GetBytes("$([System.DateTime]::Now.Ticks.ToString())12345"))).Replace('=', 'g')
    	    ## Find the total seconds since 1/1/1970 (epoch time)
		    $EpochTimeNow = [System.DateTime]::UtcNow - [System.DateTime]::ParseExact("01/01/1970", "dd/MM/yyyy", $null)
		    $OauthTimestamp = [System.Convert]::ToInt64($EpochTimeNow.TotalSeconds).ToString();
        	## Build the signature
			$SignatureBase = "$([System.Uri]::EscapeDataString($AuthorizationParams.HttpEndPoint))&"
			$SignatureParams = @{
				'oauth_consumer_key' = $AuthorizationParams.OAuthSettings.ApiKey;
				'oauth_nonce' = $OauthNonce;
				'oauth_signature_method' = 'HMAC-SHA1';
				'oauth_timestamp' = $OauthTimestamp;
				'oauth_token' = $AuthorizationParams.OAuthSettings.AccessToken;
				'oauth_version' = '1.0';
			}
	        $AuthorizationParams.Params.Keys | % { $SignatureParams.Add($_ , [System.Net.WebUtility]::UrlEncode($AuthorizationParams.Params.Item($_)).Replace('+','%20'))}
        
		 
			## Create a string called $SignatureBase that joins all URL encoded 'Key=Value' elements with a &
			## Remove the URL encoded & at the end and prepend the necessary 'POST&' verb to the front
			$SignatureParams.GetEnumerator() | sort name | foreach { $SignatureBase += [System.Uri]::EscapeDataString("$($_.Key)=$($_.Value)&") }

            $SignatureBase = $SignatureBase.Substring(0,$SignatureBase.Length-1)
            $SignatureBase = $SignatureBase.Substring(0,$SignatureBase.Length-1)
            $SignatureBase = $SignatureBase.Substring(0,$SignatureBase.Length-1)
			$SignatureBase = $AuthorizationParams.RESTVerb+'&' + $SignatureBase
			
			## Create the hashed string from the base signature
			$SignatureKey = [System.Uri]::EscapeDataString($AuthorizationParams.OAuthSettings.ApiSecret) + "&" + [System.Uri]::EscapeDataString($AuthorizationParams.OAuthSettings.AccessTokenSecret);
			
			$hmacsha1 = new-object System.Security.Cryptography.HMACSHA1;
			$hmacsha1.Key = [System.Text.Encoding]::ASCII.GetBytes($SignatureKey);
			$OauthSignature = [System.Convert]::ToBase64String($hmacsha1.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($SignatureBase)));
			
			## Build the authorization headers using most of the signature headers elements.  This is joining all of the 'Key=Value' elements again
			## and only URL encoding the Values this time while including non-URL encoded double quotes around each value
			$AuthorizationParams = $SignatureParams
			$AuthorizationParams.Add('oauth_signature', $OauthSignature)
		
			
			$AuthorizationString = 'OAuth '
			$AuthorizationParams.GetEnumerator() | sort name | foreach { $AuthorizationString += $_.Key + '="' + [System.Uri]::EscapeDataString($_.Value) + '", ' }
			$AuthorizationString = $AuthorizationString.TrimEnd(', ')
            Write-Verbose "Using authorization string '$AuthorizationString'"			
			$AuthorizationString

        }
        catch {
			Write-Error $_.Exception.Message
		}

     }

}


function Invoke-TwitterMediaUpload{

<#
          .SYNOPSIS
           This function uploads a media file to twitter and returns the media file id. 

          .PARAMETER ResourceURL
           The desired twitter media upload resource url For API 1.1 https://upload.twitter.com/1.1/media/upload.json [REST APIs can be found here: https://dev.twitter.com/rest/public]
           
          .PARAMETER MediaFilePath 
          Local path of media

          .PARAMETER OAuthSettings 
           A hashtable that must contain only the following keys and their values (Generate here: https://dev.twitter.com/oauth)
                       ApiKey 
                       ApiSecret 
		               AccessToken
	                   AccessTokenSecret
          .LINK
          This function evolved from the following blog post https://devcentral.f5.com/articles/introducing-poshtwitpic-ndash-use-powershell-to-post-your-images-to-twitter-via-twitpic
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory)][System.IO.FileInfo] $MediaFilePath,
        [parameter(Mandatory)] [System.URI] $ResourceURL,
        [Parameter(Mandatory)]$OAuthSettings
    )

    process{
  
     try{
           $Parameters = @{}
           $AuthParams = @{}
           $AuthParams.Add('HttpEndPoint', $ResourceURL)
           $AuthParams.Add('RESTVerb', "POST")
           $AuthParams.Add('Params', $Parameters)
           $AuthParams.Add('OAuthSettings', $o)
           $AuthorizationString = Get-OAuth -AuthorizationParams $AuthParams
           $boundary = [System.Guid]::NewGuid().ToString();
           $header = "--{0}" -f $boundary;
           $footer = "--{0}--" -f $boundary;
           [System.Text.StringBuilder]$contents = New-Object System.Text.StringBuilder
           [void]$contents.AppendLine($header);
           $bytes = [System.IO.File]::ReadAllBytes($MediaFilePath)
           $enc = [System.Text.Encoding]::GetEncoding("iso-8859-1")
           $filedata = $enc.GetString($bytes)
           $contentTypeMap = @{
                    ".jpg"  = "image/jpeg";
                    ".jpeg" = "image/jpeg";
                    ".gif"  = "image/gif";
                    ".png"  = "image/png";
                 }
           $fileContentType = $contentTypeMap[$MediaFilePath.Extension.ToLower()]
           $fileHeader = "Content-Disposition: file; name=""{0}""; filename=""{1}""" -f "media", $file.Name  
           [void]$contents.AppendLine($fileHeader)
           [void]$contents.AppendLine("Content-Type: {0}" -f $fileContentType)
           [void]$contents.AppendLine()
           [void]$contents.AppendLine($fileData)
           [void]$contents.AppendLine($footer)
           $z =  $contents.ToString()
           $response = Invoke-RestMethod -Uri $ResourceURL -Body $z -Method Post -Headers @{ 'Authorization' = $AuthorizationString } -ContentType "multipart/form-data; boundary=`"$boundary`""
           $response.media_id
    }
    catch [System.Net.WebException] {
        Write-Error( "FAILED to reach '$URL': $_" )
        $_
        throw $_
    }
    }
}
 


function Invoke-TwitterRestMethod{
<#
          .SYNOPSIS
           This function sends a POST or GET message to the Twitter API and returns the JSON response. 

          .PARAMETER ResourceURL
           The desired twitter resource url [REST APIs can be found here: https://dev.twitter.com/rest/public]
           
          .PARAMETER RestVerb
           Either 'GET' or 'POST' depending on the resource URL

           .PARAMETER  Parameters
           A hashtable containing the rest parameters (key value pairs) associated that resource url. Pass empty hash if no paramters needed.

           .PARAMETER OAuthSettings 
           A hashtable that must contain only the following keys and their values (Generate here: https://dev.twitter.com/oauth)
                       ApiKey 
                       ApiSecret 
		               AccessToken
	                   AccessTokenSecret

           .EXAMPLE
            $OAuth = @{'ApiKey' = 'yourapikey'; 'ApiSecret' = 'yourapisecretkey';'AccessToken' = 'yourapiaccesstoken';'AccessTokenSecret' = 'yourapitokensecret'}
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/statuses/mentions_timeline.json' -RestVerb 'GET' -Parameters @{} -OAuthSettings $OAuth 
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/statuses/user_timeline.json' -RestVerb 'GET' -Parameters @{'count' = '1'} -OAuthSettings $OAuth 
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/statuses/home_timeline.json' -RestVerb 'GET' -Parameters @{'count' = '1'} -OAuthSettings $OAuth 
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/statuses/retweets_of_me.json' -RestVerb 'GET' -Parameters @{} -OAuthSettings $OAuth 
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/search/tweets.json' -RestVerb 'GET' -Parameters @{'q'='powershell';'count' = '1'}} -OAuthSettings $OAuth
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/account/settings.json' -RestVerb 'POST' -Parameters @{'lang'='tr'} -OAuthSettings $OAuth 
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/statuses/retweets/509457288717819904.json' -RestVerb 'GET' -Parameters @{} -OAuthSettings $OAuth
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/statuses/show.json' -RestVerb 'GET' -Parameters @{'id'='123'} -OAuthSettings $OAuth 
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/statuses/destroy/240854986559455234.json' -RestVerb 'GET' -Parameters @{} -OAuthSettings $OAuth 
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/statuses/update.json' -RestVerb 'POST' -Parameters @{'status'='@FollowBot'} -OAuthSettings $OAuth 
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/direct_messages.json' -RestVerb 'GET' -Parameters @{} -OAuthSettings $OAuth 
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/direct_messages/destroy.json' -RestVerb 'POST' -Parameters @{'id' = '559298305029844992'} -OAuthSettings $OAuth 
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/direct_messages/new.json' -RestVerb 'POST' -Parameters @{'text' = 'hello, there'; 'screen_name' = 'ruminaterumi' } -OAuthSettings $OAuth 
            $mediaId = Invoke-TwitterMEdiaUpload -MediaFilePath 'C:\Books\pic.png' -ResourceURL 'https://upload.twitter.com/1.1/media/upload.json' -OAuthSettings $OAuth 
            Invoke-TwitterRestMethod -ResourceURL 'https://api.twitter.com/1.1/statuses/update.json' -RestVerb 'POST' -Parameters @{'status'='FollowBot'; 'media_ids' = $mediaId } -OAuthSettings $OAuth 

     #>
         [CmdletBinding()]
	     [OutputType('System.Management.Automation.PSCustomObject')]
         Param(
                [Parameter(Mandatory)]
                [string]$ResourceURL,
                [Parameter(Mandatory)]
                [string]$RestVerb,
                [Parameter(Mandatory)]
                $Parameters,
                [Parameter(Mandatory)]
                $OAuthSettings

                )

          process{
              try{

                    $AuthParams = @{}
                    $AuthParams.Add('HttpEndPoint', $ResourceURL)
                    $AuthParams.Add('RESTVerb', $RestVerb)
                    $AuthParams.Add('Params', $Parameters)
                    $AuthParams.Add('OAuthSettings', $OAuthSettings)
                    $AuthorizationString = Get-OAuth -AuthorizationParams $AuthParams                 
                    $HTTPEndpoint= $ResourceURL
                    if($Parameters.Count -gt 0)
                    {
                        $HTTPEndpoint = $HTTPEndpoint + '?'
                        $Parameters.Keys | % { $HTTPEndpoint = $HTTPEndpoint + $_  +'='+ [System.Net.WebUtility]::UrlEncode($Parameters.Item($_)).Replace('+','%20') + '&'}
                        $HTTPEndpoint = $HTTPEndpoint.Substring(0,$HTTPEndpoint.Length-1)
  
                    }
                    Invoke-RestMethod -URI $HTTPEndpoint -Method $RestVerb -Headers @{ 'Authorization' = $AuthorizationString } -ContentType "application/x-www-form-urlencoded" 
                  }
                  catch{
                    Write-Error $_.Exception.Message
                  }
            }
}

function Invoke-ReadFromTwitterStream{
<#
          .SYNOPSIS
           This function can be used to download info from the Twitter Streaming APIs and record the json ouptut in a text file. 

          .PARAMETER ResourceURL
           The desired twitter resource url [Streaming APIs can be found here: https://dev.twitter.com/streaming/overview]
           
          .PARAMETER RestVerb
           Either 'GET' or 'POST' depending on the resource URL

           .PARAMETER  Parameters
           A hashtable containing the rest parameters (key value pairs) associated that resource url. Pass empty hash if no paramters needed.

           .PARAMETER OAuthSettings 
           A hashtable that must contain only the following keys and their values (Generate here: https://dev.twitter.com/oauth)
                       ApiKey 
                       ApiSecret 
		               AccessToken
	                   AccessTokenSecret

           .PARAMETER  MinsToCollectStream
           The number of minutes you want to attempt to stream content. Use -1 to run infinte loop. 

           .PARAMETER  OutFilePath
           The location of the out file text. Will create file if dne yet.

           .EXAMPLE 
            $OAuth = @{'ApiKey' = 'yourapikey'; 'ApiSecret' = 'yourapisecretkey';'AccessToken' = 'yourapiaccesstoken';'AccessTokenSecret' = 'yourapitokensecret'}
            Invoke-ReadFromTwitterStream -OAuthSettings $o -OutFilePath 'C:\books\foo.txt' -ResourceURL 'https://stream.twitter.com/1.1/statuses/filter.json' -RestVerb 'POST' -Parameters @{'track' = 'foo'} -MinsToCollectStream 1

           .LINK
           This function evolved from the following blog posts http://thoai-nguyen.blogspot.com.tr/2012/03/consume-twitter-stream-oauth-net.html, https://code.google.com/p/pstwitterstream/
#>
           [CmdletBinding()]
           Param(
                [Parameter(Mandatory)]
                $OAuthSettings,
                [Parameter(Mandatory)] 
                [String] $OutFilePath,
                [Parameter(Mandatory)] 
                [string]$ResourceURL,
                [Parameter(Mandatory)] 
                [string]$RestVerb,
                [Parameter(Mandatory)] 
                $Parameters,
                [Parameter(Mandatory)] 
                $MinsToCollectStream
                )

                process{
                $Ti = Get-Date  
                while($true)
                {
                  $NewD = Get-Date
                  if(($MinsToCollectStream -ne -1) -and (($NewD-$Ti).Minutes -gt $MinsToCollectStream))
                  { return "Finished"}
     
                  try
                  {
                    $AuthParams = @{}
                    $AuthParams.Add('HttpEndPoint', $ResourceURL)
                    $AuthParams.Add('RESTVerb', $RestVerb)
                    $AuthParams.Add('Params', $Parameters)
                    $AuthParams.Add('OAuthSettings', $OAuthSettings)
                    $AuthorizationString = Get-OAuth -AuthorizationParams $AuthParams

                    [System.Net.HttpWebRequest]$Request = [System.Net.WebRequest]::Create($ResourceURL)
                    $Request.Timeout = [System.Threading.Timeout]::Infinite
                    $Request.Method = $RestVerb
                    $Request.AutomaticDecompression = [System.Net.DecompressionMethods]::GZip, [System.Net.DecompressionMethods]::Deflate 
                    $Request.Headers.Add('Authorization', $AuthorizationString)
                    $Request.Headers.Add('Accept-Encoding', 'deflate,gzip')
                    $filter = $Null
                    if($Parameters.Count -gt 0)
                    {
                        $Parameters.Keys | % { $filter = $filter + $_  +'='+ [System.Net.WebUtility]::UrlEncode($Parameters.Item($_)).Replace('+','%20') + '&'}
                        $filter = $filter.Substring(0, $filter.Length-1)
                        $POSTData = [System.Text.Encoding]::UTF8.GetBytes($filter)
                        $Request.ContentType = "application/x-www-form-urlencoded"
                        $Request.ContentLength = $POSTData.Length
                        $RequestStream = $Request.GetRequestStream()
                        $RequestStream.Write($POSTData, 0, $POSTData.Length)
                        $RequestStream.Close()
                    }
                 
                    $Response =  [System.Net.HttpWebResponse]$Request.GetResponse()
                    [System.IO.StreamReader]$ResponseStream = $Response.GetResponseStream()
                    
                    while ($true) 
                    {
                            $NewDt = Get-Date
                            if(($MinsToCollectStream -ne -1) -and (($NewDt-$Ti).Minutes -gt $MinsToCollectStream))
                            { return "Finished"}

                            $Line = $ResponseStream.ReadLine()
                            if($Line -eq '') 
                            { continue }
                            Add-Content $OutFilePath $Line
                            $PowerShellRepresentation = $Line | ConvertFrom-Json
                            $PowerShellRepresentation
                            If ($ResponseStream.EndOfStream) { Throw "Stream closed." }                  
                    }
                 }
                 catch{
                    Write-Error $_.Exception.Message
                }
                }
              }
}