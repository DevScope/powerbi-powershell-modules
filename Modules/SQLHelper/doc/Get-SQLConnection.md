---
external help file: SQLHelper-help.xml
Module Name: SQLHelper
online version:
schema: 2.0.0
---

# Get-SQLConnection

## SYNOPSIS
Gets a DBConnection object of the specified provider to a connectionstring

## SYNTAX

```
Get-SQLConnection [[-providerName] <String>] [-connectionString] <String> [-open] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
Get-SQLConnection -providerName "System.Data.SqlClient" -connectionString "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=DomusSocialDW;Data Source=.\sql2014" -Open
```

Gets a DBConnection of type SqlConnection and open it

## PARAMETERS

### -providerName
Set provider name e.g.
"System.Data.SqlClient"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: System.Data.SqlClient
Accept pipeline input: False
Accept wildcard characters: False
```

### -connectionString
Set connection string e.g.
"Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=DW;Data Source=.\sql2017"

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

### -open
Choice if connection returns open or not

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
