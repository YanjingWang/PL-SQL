Select
  [Market_Dim].[Zipcode] AS [Zipcode],
  [Market_Dim].[Country] AS [Country],
  [Gk_Territory].[Territory_Id] AS [Territory_Id],
  [Gk_Territory].[Region] AS [Region_1],
  [Gk_Territory].[Salesrep] AS [Salesrep],
  [Gk_Territory].[Region_Mgr] AS [Region_Mgr_1],
  [Market_Dim].[State] AS [State],
  [Market_Dim].[City] AS [City],
  [Gk_Territory].[Userid] AS [Userid]
From
  [Market_Dim] AS [Market_Dim],
[Gk_Territory] AS [Gk_Territory]
  Where 
  ( [Gk_Territory].[Territory_Type] = 'Ob' ) And
  ( [Market_Dim].[Zipcode] Between [Gk_Territory].[Zip_Start] And [Gk_Territory].[Zip_End] );

