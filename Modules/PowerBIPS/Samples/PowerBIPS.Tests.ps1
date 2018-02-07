cls

$ErrorActionPreference = "Stop"

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition -Parent)

Import-Module "$currentPath\..\PowerBIPS" -Force

$authToken = Get-PBIAuthToken

$groupId = "f2af64e0-d98b-4b78-aeb1-48a77f0adeeb"
$dsId = "2be32d9a-fa30-4649-97e6-7b3428b9fd68"

Set-PBIGroup -id $groupId

$datasources = Get-PBIDatasources -authToken $authToken -dataSetId $dsId

$bodyStr = "{ 
  ""updateDetails"":[   
    { 
      ""connectionDetails"": 
      { 
        ""path"": ""\\nas04\private\managers\projectclassification.xlsx"",         
      }, 
      ""datasourceSelector"": 
      {         
        ""datasourceType"": ""File"", 
        ""connectionDetails"":  
        { 
          ""path"":""\\nas04\private\managers\project2classification.xlsx""
        } 
      } 
    } 
  ] 
}"


Execute-PBIPost -authToken $authToken -uri "/datasets/$dsId/updatedatasources" -body $bodyStr

