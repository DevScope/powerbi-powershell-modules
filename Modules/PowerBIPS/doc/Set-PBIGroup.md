---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Set-PBIGroup

## SYNOPSIS
Set's the scope to the group specified, after execution all the following PowerBIPS cmdlets will execute over the defined group.

## SYNTAX

```
Set-PBIGroup [[-authToken] <String>] [[-id] <String>] [[-name] <String>] [-clear] [<CommonParameters>]
```

## DESCRIPTION
Set's the scope to the group specified, after execution all the following PowerBIPS cmdlets will execute over the defined group.

## EXAMPLES

### EXAMPLE 1
```
Set-PBIGroup -id "GUID"
```

### EXAMPLE 2
```
Set-PBIGroup -name "Group Name"
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

### -id
The id of the group

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

### -name
The name of the group

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

### -clear
If $true then will clear the group and all the requests will be made to the default user workspace

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
