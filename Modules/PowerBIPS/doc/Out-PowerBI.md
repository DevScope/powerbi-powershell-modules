---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Out-PowerBI

## SYNOPSIS
A one line cmdlet that you can use to send data into PowerBI

## SYNTAX

### authToken (Default)
```
Out-PowerBI -Data <Object> [-AuthToken <String>] [-DataSetName <String>] [-TableName <String>]
 [-BatchSize <Int32>] [-MultipleTables] [-ForceAskCredentials] [-ForceTableSchemaUpdate] [-Types <Hashtable>]
 [<CommonParameters>]
```

### credential
```
Out-PowerBI -Data <Object> -Credential <Object> [-DataSetName <String>] [-TableName <String>]
 [-BatchSize <Int32>] [-MultipleTables] [-ForceAskCredentials] [-ForceTableSchemaUpdate] [-Types <Hashtable>]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
Get-Process | Out-PowerBI -clientId "7a7be4f7-c64d-41da-94db-7fb8200f029c"
```

1..53 |% {
@{
    Id = $_
    ; Name = "Record $_"
    ; Date = \[datetime\]::Now
    ; Value = (Get-Random -Minimum 10 -Maximum 1000)
}
} | Out-PowerBI -clientId "7a7be4f7-c64d-41da-94db-7fb8200f029c"  -verbose

## PARAMETERS

### -Data
The data that will be sent to PowerBI

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

### -AuthToken
The AccessToken - Optional

```yaml
Type: String
Parameter Sets: authToken
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
specifies a PSCredential object used to authenticate to the PowerBI service.
This is used to automate the
sign in process so you aren't prompted to enter a username and password in the GUI.

```yaml
Type: Object
Parameter Sets: credential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataSetName
The name of the dataset - Optional, by default will always create a new dataset with a timestamp

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ("PowerBIPS_{0:yyyyMMdd_HHmmss}"	-f (Get-Date))
Accept pipeline input: False
Accept wildcard characters: False
```

### -TableName
The name of the table in the DataSet - Optional, by default will be named "Table"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Table
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
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

### -MultipleTables
A indication that the hashtable passed is a multitable

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

### -ForceAskCredentials
{{Fill ForceAskCredentials Description}}

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

### -ForceTableSchemaUpdate
{{Fill ForceTableSchemaUpdate Description}}

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

### -Types
{{Fill Types Description}}

```yaml
Type: Hashtable
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
