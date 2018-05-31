---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Update-PBITableSchema

## SYNOPSIS
Updates a PowerBI Dataset Table Schema.
Note: This operation will delete all the table rows

## SYNTAX

```
Update-PBITableSchema [[-authToken] <String>] [-dataSetId] <String> [-table] <Object> [[-types] <Hashtable>]
 [[-groupId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Updates a PowerBI Dataset Table Schema

## EXAMPLES

### EXAMPLE 1
```
-table <tableSchema>
```

## PARAMETERS

### -authToken
The authorization token required to comunicate with the PowerBI APIs
Use 'Get-PBIAuthToken' to get the authorization token string

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

### -dataSetId
{{Fill dataSetId Description}}

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

### -table
The table object, this object must be one of two types: hashtable or System.Data.DataTable

If a hashtable is supplied it must have the following structure:

$table = @{ 
	name = "TableName"
	; columns = @( 
		@{ name = "Col1"; dataType = "Int64"  }
		, @{ name = "Col2"; dataType = "string"  }
		) 
}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -types
{{Fill types Description}}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -groupId
Id of the workspace where the reports will get pulled

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
