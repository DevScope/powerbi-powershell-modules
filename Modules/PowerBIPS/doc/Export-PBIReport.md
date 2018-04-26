---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Export-PBIReport

## SYNOPSIS
Download reports as PBIX files to the specified folder.

## SYNTAX

```
Export-PBIReport [[-authToken] <String>] [-report] <Object> [[-destinationFolder] <String>]
 [[-timeout] <Int32>] [[-groupId] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
Get-Report -name "SampleReport" | Export-PBIReport
```

### EXAMPLE 2
```
# Get's all reports from current workspace and saves them on the destination folder
```

Get-PBIReport | Export-PBIReport -destinationFolder ".\OutputFolder"

### EXAMPLE 3
```
Export-PBIReport -report {ReportGUID}
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

### -report
The PBI Report Object or Report Id (GUID)

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

### -destinationFolder
A string with the path to the destination folder

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: .
Accept pipeline input: False
Accept wildcard characters: False
```

### -timeout
Timeout seconds for the export HTTP request

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 300
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
