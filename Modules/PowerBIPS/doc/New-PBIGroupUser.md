---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# New-PBIGroupUser

## SYNOPSIS
Add a user to a group

## SYNTAX

```
New-PBIGroupUser [[-authToken] <String>] [-groupId] <String> [-emailAddress] <String>
 [[-groupUserAccessRight] <String>] [<CommonParameters>]
```

## DESCRIPTION
Adds a new user to an existing group (app workspace) in PowerBI

## EXAMPLES

### EXAMPLE 1
```
New-PBIGroupUser -authToken $authToken -groupId $groupId -emailAddress "someone@your-organisation.com"
```

## PARAMETERS

### -authToken
The authorization token required to comunicate with the PowerBI APIs
Use 'Get-PBIAuthToken' to get the authorization token string

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

### -groupId
The id of the group in PowerBI

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -emailAddress
The email address of the user in your organisation that you want to add to the group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -groupUserAccessRight
The access right the user gets on the group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Admin
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
