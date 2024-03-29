Select
  [Dedup_Input_Subquery2].[Contactid] AS [Contactid],
  [Contact].[Firstname] AS [Firstname],
  [Contact].[Lastname] AS [Lastname],
  [Contact].[Middlename] AS [Middlename],
  [Account].[Account] AS [Account],
  [Contact].[Accountid] AS [Accountid],
  [Address].[Address1] AS [Address1],
  [Address].[Address2] AS [Address2],
  [Address].[Address3] AS [Address3],
  [Address].[City] AS [City],
  [Address].[State] AS [State],
  [Address].[Country] AS [Country],
  [Address].[Postalcode] AS [Postalcode],
  [Address].[County] AS [County]
From
   ( Select
Distinct
  [Qg_Eventinstructors].[Contactid] AS [Contactid]
From
  [Base].[Qg_Eventinstructors] AS [Qg_Eventinstructors] ) AS [Dedup_Input_Subquery2]   
 Left Outer Join   [Base].[Contact]  [Contact] On ( ( [Contact].[Contactid] = [Dedup_Input_Subquery2].[Contactid] ) )
 Left Outer Join   [Base].[Account]  [Account] On ( ( [Account].[Accountid] = [Contact].[Accountid] ) )
 Left Outer Join   [Base].[Address]  [Address] On ( ( [Address].[Addressid] = [Contact].[Addressid] ) );

