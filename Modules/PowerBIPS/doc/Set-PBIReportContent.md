---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Set-PBIReportContent

## SYNOPSIS
Replaces a target reports content with content from another source report in the same or different workspace

## SYNTAX

```
Set-PBIReportContent [[-authToken] <String>] [-report] <Object> [[-groupId] <String>]
 [-targetReportId] <String> [[-targetGroupId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Replaces a target reports content with content from another source report in the same or different workspace

## EXAMPLES

### EXAMPLE 1
```
$sourceReport = Get-PBIReport -name "SourceReportName"
```

$targetReport = Get-PBIReport -name "TargetReportName"
$sourceReport | Set-PBIReportContent -targetReportId $targetReport.id

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

### -groupId
{{Fill groupId Description}}

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

### -targetReportId
The target report id that content will get overwriten

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -targetGroupId
The target report workspace id

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
