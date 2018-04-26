---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# New-PBIDataSet

## SYNOPSIS
Create a new DataSet

## SYNTAX

```
New-PBIDataSet [-authToken] <String> [-dataSet] <Object> [[-defaultRetentionPolicy] <String>]
 [[-types] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
Create a new DataSet in PowerBI

## EXAMPLES

### EXAMPLE 1
```
New-PBIDataSet -authToken $authToken -dataSet $dataSet
```

A new dataset will be created and in case of success return the internal dataset id

## PARAMETERS

### -authToken
The authorization token required to comunicate with the PowerBI APIs
Use 'Get-PBIAuthToken' to get the authorization token string

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

### -dataSet
The dataset object, this object must be one of two types: hashtable or System.Data.DataSet

If a hashtable is supplied it must have the following structure:

$dataSet = @{
name = "DataSetName"	
  ; tables = @(
@{ 
	name = "TableName"
	; columns = @( 
		@{ name = "Col1"; dataType = "Int64"  }
		, @{ name = "Col2"; dataType = "string"  }
		) 
})
}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -defaultRetentionPolicy
The retention policy to be applied by PowerBI

Example: "basicFIFO"
http://blogs.msdn.com/b/powerbidev/archive/2015/03/23/automatic-retention-policy-for-real-time-data.aspx

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
