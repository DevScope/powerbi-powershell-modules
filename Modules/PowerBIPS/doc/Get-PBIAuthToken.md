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

```
Get-PBIAuthToken [[-credential] <Object>] [-forceAskCredentials] [[-clientId] <String>]
 [[-redirectUri] <String>] [[-tenantId] <String>] [[-clientSecret] <String>] [-returnADALObj]
 [<CommonParameters>]
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

### EXAMPLE 2
```
Get-PBIAuthToken -ClientId "C0E8435C-614D-49BF-A758-3EF858F8901B" -Credential (Get-Credential)
```

### EXAMPLE 3
```
"
```

## PARAMETERS

### -credential
Specifies a PSCredential object or a string username used to authenticate to PowerBI.
If only a username is specified 
this will prompt for the password.
Note that this will not work with federated users.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -forceAskCredentials
Forces the authentication popup to always ask for the username and password

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -clientId
The Client Id of the Azure AD application

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -redirectUri
The redirect URI associated with the native client application

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tenantId
The Azure AD Tenant Id, optional and only needed if you are using the App Authentication Flow

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -clientSecret
The Azure AD client secret, optional and only needed it the ClientId is a Azure AD WebApp type

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -returnADALObj
{{Fill returnADALObj Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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
