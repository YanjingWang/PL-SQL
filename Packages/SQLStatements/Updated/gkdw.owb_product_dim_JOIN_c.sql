Select
  [Product].[Productid] AS [Productid],
  [Product].[Product_Name] AS [Product_Name],
  [Product].[Description] AS [Description],
  [Product].[Actualid] AS [Actualid],
  [Product].[Family] AS [Family],
  [Productprogram].[Pp_Price] AS [Pp_Price],
  [Product].[Createdate] AS [Createdate],
  [Product].[Createuser] AS [Createuser],
  [Product].[Modifydate] AS [Modifydate],
  [Product].[Modifyuser] AS [Modifyuser],
  [Product].[Productgroup] AS [Productgroup],
  [Product].[Status] AS [Status],
  [Product].[Glaccountnumber] AS [Glaccountnumber],
  [Productprogram].[Pp_Createdate] AS [Pp_Createdate],
  [Productprogram].[Pp_Modifydate] AS [Pp_Modifydate]
From
    [Base].[Product]  [Product]   
 Left Outer Join  ( Select
  [Productprogram].[Productprogramid] AS [Productprogramid],
  [Productprogram].[Productid] AS [Pp_Productid],
  [Productprogram].[Createuser] AS [Pp_Createuser],
  [Productprogram].[Createdate] AS [Pp_Createdate],
  [Productprogram].[Modifyuser] AS [Pp_Modifyuser],
  [Productprogram].[Modifydate] AS [Pp_Modifydate],
  [Productprogram].[Program] AS [Pp_Program],
  [Productprogram].[Price] AS [Pp_Price],
  [Productprogram].[Defaultprogram] AS [Pp_Defaultprogram],
  [Productprogram].[Evx_Currencytype] AS [Pp_Evx_Currencytype]
From
  [Base].[Productprogram] AS [Productprogram] ) AS [Productprogram] On ( ( [Product].[Productid] = [Productprogram].[Pp_Productid] ) )
  Where 
  ( [Productprogram].[Pp_Defaultprogram] = 'T' And [Productprogram].[Pp_Evx_Currencytype] = 'Usd' );

