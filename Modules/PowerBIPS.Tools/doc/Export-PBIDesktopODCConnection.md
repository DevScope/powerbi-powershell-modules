---
external help file: PowerBIPS.Tools-help.xml
Module Name: PowerBIPS.Tools
online version:
schema: 2.0.0
---

# Export-PBIDesktopODCConnection

## SYNOPSIS
Exports a PBIDesktop ODC connection file

## SYNTAX

```
Export-PBIDesktopODCConnection [[-pbiDesktopWindowName] <String>] [[-path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Exports a PBIDesktop ODC connection file

## EXAMPLES

### EXAMPLE 1
```
Export-PBIDesktopODCConnection -pbiDesktopWindowName "*VanArsdel - Sales*"
```

## PARAMETERS

### -pbiDesktopWindowName
Power BI Desktop window name, wildcards can be used.
Ex: "*name*"

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

### -path
ODC file path to be created

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
