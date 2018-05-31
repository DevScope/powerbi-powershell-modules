---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Set-PBIModuleConfig

## SYNOPSIS
Sets the module config variables like: API Url, App Id,...

## SYNTAX

```
Set-PBIModuleConfig [[-PBIAPIUrl] <String>] [[-AzureADAppId] <String>] [[-AzureADAuthorityUrl] <String>]
 [[-AzureADResourceUrl] <String>] [[-AzureADRedirectUrl] <String>] [<CommonParameters>]
```

## DESCRIPTION
Sets the module config variables like: API Url, App Id,...

## EXAMPLES

### EXAMPLE 1
```
Set-PBIModuleConfig -pbiAPIUrl "https://api.powerbi.com/beta/myorg" -AzureADAppId "YOUR Azure AD GUID"
```

## PARAMETERS

### -PBIAPIUrl
The url for the PBI API

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AzureADAppId
Your Azure AD Application Id

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

### -AzureADAuthorityUrl
Url to the Azure AD Authority URL
Default: "https://login.microsoftonline.com/common/oauth2/authorize"

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

### -AzureADResourceUrl
{{Fill AzureADResourceUrl Description}}

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

### -AzureADRedirectUrl
Url to the Redirect Url of the Azure AD App
Default: "https://login.live.com/oauth20_desktop.srf"

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
