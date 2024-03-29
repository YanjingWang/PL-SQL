      
      Insert
      
      Into
        [Gk_Territory]
        ([Territory_Id],
        [Salesrep],
        [State],
        [Zip_Start],
        [Zip_End],
        [Region],
        [Userid],
        [Region_Mgr],
        [Gk_Territory_Id],
        [Territory_Type])
        (Select

  [Gk_Territory].[Territory_Id] AS [Territory_Id],
  [Gk_Territory].[Salesrep] AS [Salesrep],
  Trim( [Gk_Territory].[State] ) AS [State_Out],
  [Gk_Territory].[Zip_Start] AS [Zip_Start],
  [Gk_Territory].[Zip_End] AS [Zip_End],
  [Gk_Territory].[Region] AS [Region],
  [Gk_Territory].[Userid] AS [Userid],
  [Gk_Territory].[Region_Mgr] AS [Region_Mgr],
  [Gk_Territory].[Gk_Territoryid] AS [Gk_Territoryid],
  [Gk_Territory].[Territory_Type] AS [Territory_Type]
From
  [Sysdba].[Gk_Territory]@[Slx@Slx_Prod_Location] AS [Gk_Territory]
        );

