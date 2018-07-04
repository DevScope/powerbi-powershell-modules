---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Remove-PBIReport

## SYNOPSIS
Delete a report from a workspace

## SYNTAX

```
Remove-PBIReport [[-authToken] <String>] [-report] <Object> [[-groupId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Delete a report from a workspace

## EXAMPLES

### EXAMPLE 1
```
Remove-PBIReport -dataset "dataset id"
```

### EXAMPLE 2
```
Get-PBIDataset -name "DataSetName" | Remove-PBIReport
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

### -report
A report object or id

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
Id of the workspace

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
