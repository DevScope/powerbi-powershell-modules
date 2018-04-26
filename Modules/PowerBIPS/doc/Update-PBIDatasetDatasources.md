---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Update-PBIDatasetDatasources

## SYNOPSIS
Update the datasource of a dataset

## SYNTAX

```
Update-PBIDatasetDatasources [[-authToken] <String>] [-dataset] <Object> [-datasourceType] <Object>
 [-originalServer] <Object> [-originalDatabase] <Object> [-targetServer] <Object> [-targetDatabase] <Object>
 [<CommonParameters>]
```

## DESCRIPTION
Changes the connection string of an existing dataset in PowerBI

## EXAMPLES

### EXAMPLE 1
```
Update-PBIDatasetDatasources -dataset xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -datasourceType AnalysisServices -originalServer "asazure://eastus.asazure.windows.net/myssas" -originalDatabase  "wideworldimporters" -targetServer  "asazure://eastus.asazure.windows.net/myssas" -targetDatabase "wideworldimporters2"
```

### EXAMPLE 2
```
Get-PBIDataSet -name "DS Name" | Update-PBIDatasetDatasources -datasourceType AnalysisServices -originalServer "asazure://eastus.asazure.windows.net/myssas" -originalDatabase  "wideworldimporters" -targetServer  "asazure://eastus.asazure.windows.net/myssas" -targetDatabase "wideworldimporters2"
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

### -dataset
{{Fill dataset Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -datasourceType
The type of the datasource.
The type cannot be changed from original to target.
e.g.
"AnalysisServices" or "Sql"

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

### -originalServer
Original server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -originalDatabase
Original database.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -targetServer
New Server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -targetDatabase
New database.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
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
