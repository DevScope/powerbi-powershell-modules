---
external help file: SQLHelper-help.xml
Module Name: SQLHelper
online version:
schema: 2.0.0
---

# Test-SQLObjectExists

## SYNOPSIS
Tests if the SQL Object Exists

## SYNTAX

### connStr (Default)
```
Test-SQLObjectExists -connectionString <String> -objectName <String> [-objectType <String>]
 [<CommonParameters>]
```

### conn
```
Test-SQLObjectExists -connection <SqlConnection> [-transaction <SqlTransaction>] -objectName <String>
 [-objectType <String>] [<CommonParameters>]
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

### -objectName
{{Fill objectName Description}}

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

### -objectType
{{Fill objectType Description}}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
