---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Set-PBICapacityWorkload

## SYNOPSIS
Changes the state and/or maximum memory percentage of the specified workload

## SYNTAX

```
Set-PBICapacityWorkload [[-authToken] <String>] [-capacity] <Object> [-workloadName] <String> [-disable]
 [[-maxMemoryPercentageSetByUser] <Int32>] [[-groupId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Changes the state of a specific workload to Enabled or Disabled. 
When enabling a workload the maximum memory percentage that the workload can consume must be set.

## EXAMPLES

### EXAMPLE 1
```
Set-PBICapacityWorkload -authToken $authtoken -capacity $capacity -workloadName "Dataflows" -maxMemoryPercentageSetByUser 20
```

### EXAMPLE 2
```
Set-PBICapacityWorkload -authToken $authtoken -capacity $capacity -workloadName "Dataflows" -disable
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

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -disable
By default, the cmdlet will Enable the workload.
Use -disable to Disable it.

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

### -maxMemoryPercentageSetByUser
The memory percentage maximum limit set by the user.
Mandatory if you are gonna Enable the workload.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -groupId
{{ Fill groupId Description }}

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
