---
external help file: PowerBIPS-help.xml
Module Name: PowerBIPS
online version:
schema: 2.0.0
---

# Import-PBIFile

## SYNOPSIS
Creates new content on the specified workspace from a .pbix file.

## SYNTAX

```
Import-PBIFile [[-authToken] <String>] [-file] <Object> [[-dataSetName] <String>] [[-nameConflict] <String>]
 [[-groupId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates new content on the specified workspace from a .pbix file.

## EXAMPLES

### EXAMPLE 1
```
$file = Resolve-Path .\Samples\PBIX\MyMovies.pbix
```

$authToken = Get-PBIAuthToken -Verbose
Import-PBIFile -authToken $authToken -file $file -verbose

### EXAMPLE 2
```
$file = Resolve-Path .\Samples\PBIX\MyMovies.pbix
```

$authToken = Get-PBIAuthToken -Verbose
$group = Get-PBIGroup -name "Test Workspace"
$result = Import-PBIFile -authToken $authToken -groupId $($group.id) -file $file -verbose
$importResult = Get-PBIImports $authToken -groupId $($group.id) -importId $($id.id)
$importResult | Out-GridView

## PARAMETERS

### -authToken
The authorization token required to comunicate with the PowerBI APIs.
Use \`Get-PBIAuthToken\` to get the authorization token string.

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

### -file
The full path to the .pbix file.

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

### -dataSetName
The display name of the dataset, should include file extension.

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

### -nameConflict
Determines what to do if a dataset with the same name already exists.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Ignore
Accept pipeline input: False
Accept wildcard characters: False
```

### -groupId
The workspace ID.

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
To import .pbix files larger than 1 GB, see https://docs.microsoft.com/en-us/rest/api/power-bi/imports/createtemporaryuploadlocation, suported only for workspaces on premium capacity.

## RELATED LINKS
