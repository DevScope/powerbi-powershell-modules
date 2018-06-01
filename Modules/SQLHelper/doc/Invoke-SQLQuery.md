---
external help file: SQLHelper-help.xml
Module Name: SQLHelper
online version:
schema: 2.0.0
---

# Invoke-SQLQuery

## SYNOPSIS
Invokes a SQL select query

## SYNTAX

### connStr (Default)
```
Invoke-SQLQuery [-providerName <String>] -connectionString <String> -query <String> [-parameters <Object>]
 [-commandTimeout <Int32>] [<CommonParameters>]
```

### conn
```
Invoke-SQLQuery -connection <DbConnection> [-transaction <SqlTransaction>] -query <String>
 [-parameters <Object>] [-commandTimeout <Int32>] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
" -commandText "select * from [table]"
```

Executes the SQL select command and returns to the pipeline a hashtable representing the row columns

## PARAMETERS

### -providerName
{{Fill providerName Description}}

```yaml
Type: String
Parameter Sets: connStr
Aliases:

Required: False
Position: Named
Default value: System.Data.SqlClient
Accept pipeline input: False
Accept wildcard characters: False
```

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
Type: DbConnection
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

### -query
{{Fill query Description}}

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

### -parameters
{{Fill parameters Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -commandTimeout
{{Fill commandTimeout Description}}

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
