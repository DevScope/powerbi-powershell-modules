---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Get-PBICapacityWorkloads

## SYNOPSIS
Returns the current state of the specified capacity workloads.

## SYNTAX

```
Get-PBICapacityWorkloads [[-authToken] <String>] [-capacity] <Object> [[-workloadName] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns the current state of the specified capacity workloads. 
If a workload is enabled also returns the maximum memory percentage that the workload can consume.

## EXAMPLES

### EXAMPLE 1
```
Get-PBICapacityWorkloads -authToken $authtoken -capacity $capacity
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

### -workloadName
The workload name

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
