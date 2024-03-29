Select
  [Qg_Contact].[Contactid] AS [Contactid],
  [Qg_Contact].[Ob_National_Terr_Num] AS [Ob_National_Terr_Num],
  [Qg_Contact].[Ob_National_Rep_Id] AS [Ob_National_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Ob_National_Rep_Id]) AS [Ob_National_Rep_Id_1],
  [Qg_Contact].[Ob_Terr_Num] AS [Ob_Terr_Num],
  [Qg_Contact].[Ob_Rep_Id] AS [Ob_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Ob_Rep_Id]) AS [Ob_Rep_Id_1],
  [Qg_Contact].[Osr_Terr_Num] AS [Osr_Terr_Num],
  [Qg_Contact].[Osr_Id] AS [Osr_Id],
  [Get_User_Name]([Qg_Contact].[Osr_Id]) AS [Osr_Id_1],
  [Qg_Contact].[Ent_National_Terr_Num] AS [Ent_National_Terr_Num],
  [Qg_Contact].[Ent_National_Rep_Id] AS [Ent_National_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Ent_National_Rep_Id]) AS [Ent_National_Rep_Id_1],
  [Qg_Contact].[Ent_Inside_Terr_Num] AS [Ent_Inside_Terr_Num],
  [Qg_Contact].[Ent_Inside_Rep_Id] AS [Ent_Inside_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Ent_Inside_Rep_Id]) AS [Ent_Inside_Rep_Id_1],
  [Qg_Contact].[Ent_Federal_Terr_Num] AS [Ent_Federal_Terr_Num],
  [Qg_Contact].[Ent_Federal_Rep_Id] AS [Ent_Federal_Rep_Id],
  [Get_Ora_Trx_Num]([Qg_Contact].[Ent_Federal_Rep_Id]) AS [Ent_Federal_Rep_Id_1],
  [Qg_Contact].[Btsr_Terr_Num] AS [Btsr_Terr_Num],
  [Qg_Contact].[Btsr_Rep_Id] AS [Btsr_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Btsr_Terr_Num]) AS [Btsr_Terr_Num_1],
  [Qg_Contact].[Bta_Terr_Num] AS [Bta_Terr_Num],
  [Qg_Contact].[Bta_Rep_Id] AS [Bta_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Bta_Terr_Num]) AS [Bta_Terr_Num_1]
From
  [Base].[Qg_Contact] AS [Qg_Contact]
  Where 
  ( [Qg_Contact].[Createdate] >= [Owb_Cust_Dim_Terr_Upd].[Premapping_1_Create_Date_Out] Or [Qg_Contact].[Modifydate] >= [Owb_Cust_Dim_Terr_Upd].[Premapping_2_Modify_Date_Out] );

