---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Add-PBITableRows

## SYNOPSIS
Add's a collection of rows into a powerbi dataset table in batches

## SYNTAX

### dataSetId
```
Add-PBITableRows [-authToken <String>] -dataSetId <String> -tableName <String> -rows <Object>
 [-batchSize <Int32>] [-groupId <String>] [<CommonParameters>]
```

### dataSetName
```
Add-PBITableRows [-authToken <String>] -dataSetName <String> -tableName <String> -rows <Object>
 [-batchSize <Int32>] [-groupId <String>] [<CommonParameters>]
```

## DESCRIPTION
Add's a collection of rows into a powerbi dataset table in batches

## EXAMPLES

### EXAMPLE 1
```
Add-PBITableRows -authToken $auth -dataSetId $dataSetId -tableName "Product" -rows $data -batchSize 10
```

### EXAMPLE 2
```
1..53 |% {	@{id = $_; name = "Product $_"}} | Add-PBITableRows -authToken $auth -dataSetId $dataSetId -tableName "Product" -batchSize 10
```

53 records are uploaded to PowerBI "Product" table in batches of 10 rows.

## PARAMETERS

### -authToken
The authorization token required to comunicate with the PowerBI APIs
Use 'Get-PBIAuthToken' to get the authorization token string

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

### -dataSetId
The id of the dataset in PowerBI

```yaml
Type: String
Parameter Sets: dataSetId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dataSetName
{{Fill dataSetName Description}}

```yaml
Type: String
Parameter Sets: dataSetName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tableName
The name of the table of the dataset

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

### -rows
The collection of rows to insert to the table.
This parameter can have it's value from the pipeline

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -batchSize
The size of the batch that is sent to PowerBI as HttpPost.

If for example the batch size is 100 and a collection of
1000 rows are being pushed then this cmdlet will make 10 
HttpPosts

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

### -groupId
Id of the workspace where the reports will get pulled

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
