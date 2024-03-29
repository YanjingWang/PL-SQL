Select
  [Dedup_Input_Subquery2_1].[Contactid_1] AS [Contactid_1],
  Upper(Trim([Contact].[Firstname]))  + ' ' + 
  Upper(Trim([Contact].[Middlename]))  +  ' '  + 
  Upper(Trim([Contact].[Lastname])) AS [Name],
  Upper(Trim([Account].[Account])) AS [Acct_Name],
  [Contact].[Accountid] AS [Accountid],
  [Address].[Address1] AS [Address1],
  [Address].[Address2] AS [Address2],
  [Address].[Address3] AS [Address3],
  [Address].[City] AS [City],
  Case Upper(Trim([Address].[Country] )) When 'Canada' Then Null When 'Can' Then Null Else  [Address].[State]  End [State],
  [Address].[Postalcode] AS [Postalcode],
  Case Upper(Trim([Address].[Country] ))
When 'Canada'
Then  [Address].[State]  
When 'Can'
Then  [Address].[State] 
Else Null
End [Province],
  [Address].[Country] AS [Country],
  [Address].[County] AS [County]
From
   ( Select
Distinct
  [Qg_Eventinstructors].[Contactid] AS [Contactid_1]
From
  [Base].[Qg_Eventinstructors] AS [Qg_Eventinstructors] ) AS [Dedup_Input_Subquery2_1]   
 Left Outer Join   [Base].[Contact]  [Contact] On ( ( [Contact].[Contactid] = [Dedup_Input_Subquery2_1].[Contactid_1] ) )
 Left Outer Join   [Base].[Account]  [Account] On ( ( [Account].[Accountid] = [Contact].[Accountid] ) )
 Left Outer Join   [Base].[Address]  [Address] On ( ( [Address].[Addressid] = [Contact].[Addressid] ) );

