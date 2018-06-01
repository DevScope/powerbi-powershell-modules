---
external help file: SQLHelper-help.xml
Module Name: SQLHelper
online version:
schema: 2.0.0
---

# Invoke-SQLCommand

## SYNOPSIS
Invokes a SQLCommand with the following execution types: "Query", "QueryAsTable", "QueryAsDataSet", "NonQuery", "Scalar", "Reader", "Schema"

## SYNTAX

### connStr (Default)
```
Invoke-SQLCommand [-providerName <String>] -connectionString <String> [-executeType <String>]
 -commandText <String> [-commandType <CommandType>] [-parameters <Object>] [-commandTimeout <Int32>]
 [<CommonParameters>]
```

### conn
```
Invoke-SQLCommand -connection <DbConnection> [-transaction <SqlTransaction>] [-executeType <String>]
 -commandText <String> [-commandType <CommandType>] [-parameters <Object>] [-commandTimeout <Int32>]
 [<CommonParameters>]
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
Set provider name e.g.
"System.Data.SqlClient"

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

### -executeType
{{Fill executeType Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Query
Accept pipeline input: False
Accept wildcard characters: False
```

### -commandText
{{Fill commandText Description}}

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

### -commandType
{{Fill commandType Description}}

```yaml
Type: CommandType
Parameter Sets: (All)
Aliases:
Accepted values: Text, StoredProcedure, TableDirect

Required: False
Position: Named
Default value: Text
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
