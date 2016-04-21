
cls

Import-Module ".\..\..\SQLHelper"
Import-Module ".\..\..\PowerBIETL"

Export-PBIDesktopToSQL -pbiDesktopWindowName "*sample*" -sqlConnStr "Data Source=.\SQL2014; Initial Catalog=DestinationDB; Integrated Security=SSPI" -sqlSchema "stg" -verbose
