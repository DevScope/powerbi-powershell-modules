---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Set-PBICapacity

## SYNOPSIS
Assigns the specified workspace to the specified capacity

## SYNTAX

```
Set-PBICapacity [[-authToken] <String>] [-capacity] <Object> [[-groupId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Assigns the specified workspace to the specified capacity.
Note: To perform this operation, the user must be admin on the specified workspace and have admin or assign permissions on the capacity.

## EXAMPLES

### EXAMPLE 1
```
Set-PBICapacity -authToken $authtoken -capacity {your_capacity}
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

### -capacity
The Capacity object or the capacity ID (GUID)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -groupId
Id (GUID) of the workspace to which the capacity will be assigned

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
