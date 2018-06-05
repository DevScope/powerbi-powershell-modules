---
external help file: PowerBIPS.Tools-help.xml
Module Name: PowerBIPS.Tools
online version:
schema: 2.0.0
---

# Get-PBIDataSetFromPBIDesktop

## SYNOPSIS
A quick way to convert a Power BI Desktop file in a REST API enabled dataset

## SYNTAX

```
Get-PBIDataSetFromPBIDesktop [-pbiDesktopWindowName] <String> [-datasetName] <String> [<CommonParameters>]
```

## DESCRIPTION
A quick way to convert a Power BI Desktop file in a REST API enabled dataset

## EXAMPLES

### EXAMPLE 1
```
Get-PBIDataSetFromPBIDesktop -datasetName $datasetName -pbiDesktopWindowName "*RealTime*"
```

## PARAMETERS

### -pbiDesktopWindowName
Power BI Desktop window name, wildcards can be used.
Ex: "*name*"

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

### -datasetName
Name to Dataset

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
