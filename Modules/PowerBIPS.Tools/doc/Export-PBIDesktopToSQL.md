---
external help file: PowerBIPS.Tools-help.xml
Module Name: PowerBIPS.Tools
online version:
schema: 2.0.0
---

# Export-PBIDesktopToSQL

## SYNOPSIS
A way to export all your Power BI Desktop model tables into a SQL Server Database

## SYNTAX

```
Export-PBIDesktopToSQL [-pbiDesktopWindowName] <String> [[-tables] <String[]>] [-sqlConnStr] <String>
 [[-sqlSchema] <String>] [<CommonParameters>]
```

## DESCRIPTION
A way to export all your Power BI Desktop model tables into a SQL Server Database

## EXAMPLES

### EXAMPLE 1
```
Export-PBIDesktopToSQL -pbiDesktopWindowName "*Van Arsdel*" -sqlConnStr "Data Source=.\sql2017; Initial Catalog=Dummy; Integrated Security=true" -sqlSchema "stg" -Verbose
```

### EXAMPLE 2
```
Export-PBIDesktopToSQL -tables @("Product") -pbiDesktopWindowName "*Van Arsdel*" -sqlConnStr "Data Source=.\sql2017; Initial Catalog=Dummy; Integrated Security=true" -sqlSchema "stg" -Verbose
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

### -sqlConnStr
The SQL Server connection string

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

### -sqlSchema
The target sql server schema where all the tables will be created (if not exists)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Dbo
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
