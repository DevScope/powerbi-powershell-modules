---
Module Name: PowerBIPS.Tools
Module Guid: 4380560b-ec14-4627-af81-635405ceb29f
Download Help Link: {{Please enter FwLink manually}}
Help Version: {{Please enter version of help manually (X.X.X.X) format}}
Locale: en-US
---

# PowerBIPS.Tools Module
## Description
This module is a collection of very useful tools for Power BI.
For example:
    - Export PBI Desktop into CSV/SQL
    - Convert from PBI Desktop into AS Tabular
    - Get a dataset schema from a Power BI Desktop file (to create a REST DataSet)

## Sample Script - Convert PBIX to AS Tabular

```powershell

Convert-PowerBIDesktopToASTabular -pbiDesktopWindowName "*VanArsdel - Sales*" -outputPath "$currentPath\SSAS"

```

## Sample Script - Export PBI Desktop to SQL Server

```powershell

Set-PBIWorkspace -id "GUID"

Export-PBIDesktopToSQL -pbiDesktopWindowName "*PowerBIETLSample*" -sqlConnStr "Data Source=.\sql2017; Initial Catalog=Dummy; Integrated Security=true" -sqlSchema "stg" -Verbose

```

## Sample Script - Create a REST API DataSet with Power BI Desktop

```powershell

$dataSetSchema = Get-PBIDataSetFromPBIDesktop -datasetName $datasetName -pbiDesktopWindowName "*RealTime*"

$dataSetSchema = New-PBIDataSet -authToken $authToken -dataSet $dataSetSchema -ignoreIfDataSetExists

```

## PowerBIPS.Tools Cmdlets
### [Convert-PowerBIDesktopToASTabular](doc/Convert-PowerBIDesktopToASTabular.md)
Convert from a Power BI Desktop into AS Tabular Project

### [Export-PBIDesktopToCSV](doc/Export-PBIDesktopToCSV.md)
Exports the tables from a Power BI Desktop model into CSV files

### [Export-PBIDesktopToSQL](doc/Export-PBIDesktopToSQL.md)
Exports the tables from a Power BI Desktop model into a SQL Server Database (automatically creates the tables)

### [Get-PBIDesktopTCPPort](doc/Get-PBIDesktopTCPPort.md)
Discover the TCP Port of the Analysis Services instance on Power BI Desktop

