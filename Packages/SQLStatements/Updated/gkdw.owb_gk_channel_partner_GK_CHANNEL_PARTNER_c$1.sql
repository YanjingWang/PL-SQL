Select

  [Gk_Channel_Partner].[Partner_Name] AS [Partner_Name],
  [Gk_Channel_Partner].[Partner_Key_Code] AS [Partner_Key_Code],
  [Gk_Channel_Partner].[Channel_Manager] AS [Channel_Manager],
  [Gk_Channel_Partner].[Zip_Code] AS [Zip_Code],
  [Gk_Channel_Partner].[Ob_Comm_Type] AS [Ob_Comm_Type],
  [Gk_Channel_Partner].[Partner_Type] AS [Partner_Type]
From
  [Dbo].[Gk_Channel_Partner]@[Slx@Slx_Dbo_Location] AS [Gk_Channel_Partner];

