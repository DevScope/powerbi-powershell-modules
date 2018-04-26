---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Clear-PBITableRows

## SYNOPSIS
Delete all the rows of a PowerBI dataset table

## SYNTAX

### dataSetId
```
Clear-PBITableRows [-authToken <String>] -dataSetId <String> -tableName <String> [<CommonParameters>]
```

### dataSetName
```
Clear-PBITableRows [-authToken <String>] -dataSetName <String> -tableName <String> [<CommonParameters>]
```

## DESCRIPTION
Delete all the rows of a PowerBI dataset table

## EXAMPLES

### EXAMPLE 1
```
Clear-PBITableRows -authToken "authToken" -DataSetId "DataSetId" -TableName "Table"
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dataSetId
The id of the dataset in PowerBI

```yaml
Type: String
Parameter Sets: dataSetId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dataSetName
{{Fill dataSetName Description}}

```yaml
Type: String
Parameter Sets: dataSetName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tableName
The name of the table of the dataset

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
