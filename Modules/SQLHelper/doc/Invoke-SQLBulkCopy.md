---
external help file: SQLHelper-help.xml
Module Name: SQLHelper
online version:
schema: 2.0.0
---

# Invoke-SQLBulkCopy

## SYNOPSIS
Inserts data in bulk to the specified SQL Server table

## SYNTAX

### connStr (Default)
```
Invoke-SQLBulkCopy -connectionString <String> -data <Object> -tableName <String> [-columnMappings <Hashtable>]
 [-batchSize <Int32>] [-ensureTableExists] [<CommonParameters>]
```

### conn
```
Invoke-SQLBulkCopy -connection <SqlConnection> [-transaction <SqlTransaction>] -data <Object>
 -tableName <String> [-columnMappings <Hashtable>] [-batchSize <Int32>] [-ensureTableExists]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
" -data "<source DataTable>" -tableName "<destination table>" -batchSize 1000 -Verbose
```

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

### -columnMappings
{{Fill columnMappings Description}}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -batchSize
{{Fill batchSize Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -ensureTableExists
{{Fill ensureTableExists Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
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
