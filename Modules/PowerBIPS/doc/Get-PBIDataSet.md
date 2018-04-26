---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Get-PBIDataSet

## SYNOPSIS
Gets all the PowerBI existing datasets and returns as an array of custom objects.
Or
Check if a dataset exists with the specified name and if exists returns it's metadata

## SYNTAX

```
Get-PBIDataSet [[-authToken] <String>] [[-name] <String>] [[-id] <String>] [-includeDefinition]
 [-includeTables] [[-groupId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets all the PowerBI existing datasets and returns as an array of custom objects.
Or
Check if a dataset exists with the specified name and if exists returns it's metadata

## EXAMPLES

### EXAMPLE 1
```
Get-PBIDataSet -authToken $authToken
```

Get-PBIDataSet -authToken $authToken -name "DataSetName"		
Get-PBIDataSet -authToken $authToken -name "DataSetName" -includeDefinition -includeTables

## PARAMETERS

### -authToken
The authorization token required to communicate with the PowerBI APIs
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

### -name
The dataset name

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

### -id
The dataset id

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

### -includeDefinition
If specified will include the dataset definition properties

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

### -includeTables
If specified will include the dataset tables

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

### -groupId
{{Fill groupId Description}}

```yaml
Type: String
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
