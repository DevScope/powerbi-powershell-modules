---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Get-PBICapacities

## SYNOPSIS
Gets an array of avaliable capacities the user has access to

## SYNTAX

```
Get-PBICapacities [[-authToken] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets an array of avaliable capacities the user has access to

## EXAMPLES

### EXAMPLE 1
```
Get-PBICapacities -authToken $authtoken
```

## PARAMETERS

### -authToken
The authorization token required to communicate with the PowerBI APIs
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
