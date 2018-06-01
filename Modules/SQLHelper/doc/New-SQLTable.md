---
external help file: SQLHelper-help.xml
Module Name: SQLHelper
online version:
schema: 2.0.0
---

# New-SQLTable

## SYNOPSIS
Creates a new SQL Server table for the specified schema

## SYNTAX

### connStr (Default)
```
New-SQLTable -connectionString <String> -data <Object> -tableName <String> [-customColumns <String>]
 [-identityColumnName <String>] [-force] [<CommonParameters>]
```

### conn
```
New-SQLTable -connection <SqlConnection> [-transaction <SqlTransaction>] -data <Object> -tableName <String>
 [-customColumns <String>] [-identityColumnName <String>] [-force] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -connectionString
{{Fill connectionString Description}}

```yaml
Type: String
Parameter Sets: connStr
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -connection
{{Fill connection Description}}

```yaml
Type: SqlConnection
Parameter Sets: conn
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -transaction
{{Fill transaction Description}}

```yaml
Type: SqlTransaction
Parameter Sets: conn
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -data
{{Fill data Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tableName
{{Fill tableName Description}}

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

### -customColumns
{{Fill customColumns Description}}

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

### -identityColumnName
{{Fill identityColumnName Description}}

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

### -force
{{Fill force Description}}

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
