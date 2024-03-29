Select
  [Account].[Accountid] AS [Accountid_1],
  Upper(Trim( [Account].[Account] )) AS [Account_Name],
  [Address].[Address1] AS [Address1],
  [Address].[Address2] AS [Address2],
  [Address].[Address3] AS [Address3],
  [Address].[City] AS [City],
  Case Upper(Trim([Address].[Country]))
When 'Canada' 
Then Null 
When 'Can' 
Then Null 
Else [Address].[State]  
End [State],
  [Address].[Postalcode] AS [Postalcode],
  Case Upper(Trim([Address].[Country] ))  When 'Canada'  Then   [Address].[State]   When 'Can'  Then [Address].[State]   Else Null  End [Province],
  Upper( Trim( [Address].[Country] ) ) AS [Country],
  Upper(Trim( [Address].[County]  )) AS [County],
  [Account].[Createdate] AS [Createdate_1],
  [Account].[Modifydate] AS [Modifydate_1],
  [Account].[Industry] AS [Industry_1],
  [Get_Natl_Terr_Id]([Account].[Accountid]) AS [Accountid_2]
From
    [Base].[Account]  [Account]   
 Left Outer Join   [Base].[Address]  [Address] On ( ( ( [Address].[Addressid] = [Account].[Addressid] ) ) )
  Where 
  (  Accountid='Agksq1099520');

