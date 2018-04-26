---
external help file: PowerBIPS.Tools-help.xml
Module Name: PowerBIPS.Tools
online version:
schema: 2.0.0
---

# Convert-PowerBIDesktopToASTabular

## SYNOPSIS
A quick way to convert a Power BI Desktop file into an Analysis Services Tabular Project

## SYNTAX

### pbiDesktopWindowName
```
Convert-PowerBIDesktopToASTabular -pbiDesktopWindowName <String> -outputPath <String>
 [-removeInternalPBITables] [<CommonParameters>]
```

### pbiDesktopPbiTemplatePath
```
Convert-PowerBIDesktopToASTabular -pbiDesktopPbiTemplatePath <String> -outputPath <String>
 [-removeInternalPBITables] [<CommonParameters>]
```

## DESCRIPTION
A quick way to convert a Power BI Desktop file into an Analysis Services Tabular Project

## EXAMPLES

### EXAMPLE 1
```
Convert-PowerBIDesktopToASTabular -pbiDesktopWindowName "*VanArsdel - Sales*" -outputPath ".\SSASProj"
```

## PARAMETERS

### -pbiDesktopWindowName
Power BI Desktop window name, wildcards can be used.
Ex: "*name*"

```yaml
Type: String
Parameter Sets: pbiDesktopWindowName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -pbiDesktopPbiTemplatePath
Path to PowerBI Template

```yaml
Type: String
Parameter Sets: pbiDesktopPbiTemplatePath
Aliases:

Required: True
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -removeInternalPBITables
This remove internal tables like "Localdate_XXXXXX"

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
