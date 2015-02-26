# PowerBIPS.psm1

A lightweight powershell module with cmdlets to interact with PowerBI developer APIs

## List DataSets

```powershell

  $dataSets = Get-PBIDataSets -authToken (Get-PBIAuthToken -clientId "4c3c58d6-8c83-48c2-a604-67c1b740d167")

```

