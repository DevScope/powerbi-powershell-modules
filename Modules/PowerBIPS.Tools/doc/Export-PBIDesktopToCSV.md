---
external help file: PowerBIPS.Tools-help.xml
Module Name: PowerBIPS.Tools
online version:
schema: 2.0.0
---

# Export-PBIDesktopToCSV

## SYNOPSIS
A way to export all your Power BI Desktop model tables into CSV files

## SYNTAX

```
Export-PBIDesktopToCSV [-pbiDesktopWindowName] <String> [[-tables] <String[]>] [-outputPath] <String>
 [<CommonParameters>]
```

## DESCRIPTION
A way to export all your Power BI Desktop model tables into CSV files

## EXAMPLES

### EXAMPLE 1
```
Export-PBIDesktopToCSV -pbiDesktopWindowName "*Van Arsdel*" -outputPath ".\CSVOutput"
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

### -tables
The tables to be exported - if empty all the tables get exported

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -outputPath
Path to the output folder

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
