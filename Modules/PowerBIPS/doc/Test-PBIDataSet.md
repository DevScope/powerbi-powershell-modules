---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Test-PBIDataSet

## SYNOPSIS
Check if a dataset exists by name

## SYNTAX

```
Test-PBIDataSet [[-authToken] <String>] [-name] <Object> [<CommonParameters>]
```

## DESCRIPTION
Check if a dataset exists with the specified name

## EXAMPLES

### EXAMPLE 1
```
Test-PBIDataSet -authToken $authToken -name "DataSetName"
```

Returns $true if the dataset exists

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

### -name
The dataset name

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean

## NOTES

## RELATED LINKS
