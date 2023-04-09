Select
  [Account].[Accountid] AS [Accountid],
  [Account].[Account] AS [Account],
  [Address].[County] AS [County],
  [Address].[Address1] AS [Address1],
  [Address].[Address2] AS [Address2],
  [Address].[Address3] AS [Address3],
  [Address].[City] AS [City],
  [Address].[Country] AS [Country],
  [Address].[State] AS [State],
  [Address].[Postalcode] AS [Postalcode],
  [Account].[Createdate] AS [Createdate],
  [Account].[Modifydate] AS [Modifydate],
  [Account].[Industry] AS [Industry]
From
    [Base].[Account]  [Account]   
 Left Outer Join   [Base].[Address]  [Address] On ( ( ( [Address].[Addressid] = [Account].[Addressid] ) ) )
  Where 
  (  Accountid='Agksq1099520' );

