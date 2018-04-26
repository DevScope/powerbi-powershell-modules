---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Get-PBIAuthToken

## SYNOPSIS
Gets the authentication token required to comunicate with the PowerBI API's

## SYNTAX

### default (Default)
```
Get-PBIAuthToken [-ForceAskCredentials] [<CommonParameters>]
```

### credential
```
Get-PBIAuthToken -Credential <Object> [<CommonParameters>]
```

## DESCRIPTION
To authenticate with PowerBI uses OAuth 2.0 with the Azure AD Authentication Library (ADAL)

If a credential is not supplied a popup will appear for the user to authenticate.

It will automatically download and install the required nuget: "Microsoft.IdentityModel.Clients.ActiveDirectory".

## EXAMPLES

### EXAMPLE 1
```
Get-PBIAuthToken -clientId "C0E8435C-614D-49BF-A758-3EF858F8901B"
```

Returns the access token for the PowerBI REST API using the client ID.
You'll be presented with a pop-up window for 
user authentication.

### EXAMPLE 2
```
$Credential = Get-Credential
```

Get-PBIAuthToken -ClientId "C0E8435C-614D-49BF-A758-3EF858F8901B" -Credential $Credential
         Returns the access token for the PowerBI REST API using the client ID and a PSCredential object.

## PARAMETERS

### -Credential
Specifies a PSCredential object or a string username used to authenticate to PowerBI.
If only a username is specified 
this will prompt for the password.
Note that this will not work with federated users.

```yaml
Type: Object
Parameter Sets: credential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForceAskCredentials
Forces the authentication popup to always ask for the username and password

```yaml
Type: SwitchParameter
Parameter Sets: default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS
