---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Get-PBICapacityAssignmentStatus

## SYNOPSIS
Gets the status of the assignment to capacity operation of the specified workspace

## SYNTAX

```
Get-PBICapacityAssignmentStatus [[-authToken] <String>] [[-groupId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the status of the assignment to capacity operation of the specified workspace.
Note: To perform this operation, the user must be admin on the specified workspace.

## EXAMPLES

### EXAMPLE 1
```
Get-PBICapacityAssignmentStatus -authToken $authtoken
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

### -groupId
Id (GUID) of the workspace to which the capacity will be unassigned

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
