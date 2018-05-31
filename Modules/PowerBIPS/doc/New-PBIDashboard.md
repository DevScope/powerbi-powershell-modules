---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# New-PBIDashboard

## SYNOPSIS
Create a new Dashboard

## SYNTAX

```
New-PBIDashboard [-authToken] <String> [-name] <String> [[-groupId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Create a new Dashboard in PowerBI

## EXAMPLES

### EXAMPLE 1
```
New-PBIDashboard -authToken $authToken -groupId $groupId
```

A new dashboard will be created and in case of success return the internal dashboard id

## PARAMETERS

### -authToken
The authorization token required to comunicate with the PowerBI APIs
Use 'Get-PBIAuthToken' to get the authorization token string

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -name
The name of the new dashboard

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

### -groupId
The id of the group in PowerBI

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
