Merge

Into
  [Cust_Dim]
Using
  (Select
  [Qg_Contact].[Contactid] AS [Contactid_1],
  [Qg_Contact].[Ob_National_Terr_Num],
  [Qg_Contact].[Ob_National_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Ob_National_Rep_Id]) AS [Ob_National_Rep_Name],
  [Qg_Contact].[Ob_Terr_Num],
  [Qg_Contact].[Ob_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Ob_Rep_Id]) AS [Ob_Rep_Name],
  [Qg_Contact].[Osr_Terr_Num],
  [Qg_Contact].[Osr_Id],
  [Get_User_Name]([Qg_Contact].[Osr_Id]) AS [Osr_Rep_Name],
  [Qg_Contact].[Ent_National_Terr_Num],
  [Qg_Contact].[Ent_National_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Ent_National_Rep_Id]) AS [Ent_National_Rep_Name],
  [Qg_Contact].[Ent_Inside_Terr_Num],
  [Qg_Contact].[Ent_Inside_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Ent_Inside_Rep_Id]) AS [Ent_Inside_Rep_Name],
  [Qg_Contact].[Ent_Federal_Terr_Num],
  [Qg_Contact].[Ent_Federal_Rep_Id],
  [Get_Ora_Trx_Num]([Qg_Contact].[Ent_Federal_Rep_Id]) AS [Ent_Federal_Rep_Name],
  [Qg_Contact].[Btsr_Terr_Num],
  [Qg_Contact].[Btsr_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Btsr_Terr_Num]) AS [Btsr_Rep_Name],
  [Qg_Contact].[Bta_Terr_Num],
  [Qg_Contact].[Bta_Rep_Id],
  [Get_User_Name]([Qg_Contact].[Bta_Terr_Num]) AS [Bta_Rep_Name]
From
  [Base].[Qg_Contact] AS [Qg_Contact]
  Where 
  ( [Qg_Contact].[Createdate] >= [Owb_Cust_Dim_Terr_Upd].[Premapping_1_Create_Date_Out] Or [Qg_Contact].[Modifydate] >= [Owb_Cust_Dim_Terr_Upd].[Premapping_2_Modify_Date_Out] )
  )
    Source
On (
  [Cust_Dim].[Cust_Id] = [Source].[Contactid_1]
   )
  
  When Matched Then
    Update
    Set
                  [Ob_National_Terr_Num] = [Source].[Ob_National_Terr_Num],
  [Ob_National_Rep_Id] = [Source].[Ob_National_Rep_Id],
  [Ob_National_Rep_Name] = [Source].[Ob_National_Rep_Name],
  [Ob_Terr_Num] = [Source].[Ob_Terr_Num],
  [Ob_Rep_Id] = [Source].[Ob_Rep_Id],
  [Ob_Rep_Name] = [Source].[Ob_Rep_Name],
  [Osr_Terr_Num] = [Source].[Osr_Terr_Num],
  [Osr_Id] = [Source].[Osr_Id],
  [Osr_Rep_Name] = [Source].[Osr_Rep_Name],
  [Ent_National_Terr_Num] = [Source].[Ent_National_Terr_Num],
  [Ent_National_Rep_Id] = [Source].[Ent_National_Rep_Id],
  [Ent_National_Rep_Name] = [Source].[Ent_National_Rep_Name],
  [Ent_Inside_Terr_Num] = [Source].[Ent_Inside_Terr_Num],
  [Ent_Inside_Rep_Id] = [Source].[Ent_Inside_Rep_Id],
  [Ent_Inside_Rep_Name] = [Source].[Ent_Inside_Rep_Name],
  [Ent_Federal_Terr_Num] = [Source].[Ent_Federal_Terr_Num],
  [Ent_Federal_Rep_Id] = [Source].[Ent_Federal_Rep_Id],
  [Ent_Federal_Rep_Name] = [Source].[Ent_Federal_Rep_Name],
  [Btsr_Terr_Num] = [Source].[Btsr_Terr_Num],
  [Btsr_Rep_Id] = [Source].[Btsr_Rep_Id],
  [Btsr_Rep_Name] = [Source].[Btsr_Rep_Name],
  [Bta_Terr_Num] = [Source].[Bta_Terr_Num],
  [Bta_Rep_Id] = [Source].[Bta_Rep_Id],
  [Bta_Rep_Name] = [Source].[Bta_Rep_Name]
       
  ;

