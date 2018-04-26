---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Set-PBIReportsDataset

## SYNOPSIS
Rebind reports to another dataset on the same workspace.

## SYNTAX

### default (Default)
```
Set-PBIReportsDataset [-authToken <String>] -report <Object> -targetDatasetId <String> [-timeout <Int32>]
 [<CommonParameters>]
```

### sourceDS
```
Set-PBIReportsDataset [-authToken <String>] -sourceDatasetId <Object> -targetDatasetId <String>
 [-timeout <Int32>] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
Set-PBIReportsDataset -report "ReportId" -targetDatasetId "DataSetId"
```

### EXAMPLE 2
```
Get-PBIReport | Set-PBIReportsDataset -targetDatasetId "DataSetId"
```

### EXAMPLE 3
```
# Rebind all the reports from Source DataSet to the Target DataSet
```

Set-PBIReportsDataset -sourceDatasetId "SourceDataSetId" -targetDatasetId "DataSetId"

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

### -report
The PBI Report Object or Report Id (GUID)

```yaml
Type: Object
Parameter Sets: default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -sourceDatasetId
A string with the source dataset id, when executed with this parameter all the reports that target the source dataset will be rebinded

```yaml
Type: Object
Parameter Sets: sourceDS
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -targetDatasetId
A string with the new dataset id to bind the reports

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

### -timeout
{{Fill timeout Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 300
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
