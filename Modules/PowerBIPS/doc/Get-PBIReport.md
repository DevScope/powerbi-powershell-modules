---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Get-PBIReport

## SYNOPSIS
Gets an array of Power BI Report metadata from a workspace

## SYNTAX

```
Get-PBIReport [[-authToken] <String>] [[-name] <String>] [[-id] <String>] [[-groupId] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets an array of Power BI Report metadata from a workspace

## EXAMPLES

### EXAMPLE 1
```
Get-PBIReport
```

### EXAMPLE 2
```
Get-PBIReport -id "GUID"
```

### EXAMPLE 3
```
Get-PBIReport -id "GUID" -groupId "GUID"
```

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
The name of the report

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
The id of the report

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

### -groupId
Id of the workspace where the reports will get pulled

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
