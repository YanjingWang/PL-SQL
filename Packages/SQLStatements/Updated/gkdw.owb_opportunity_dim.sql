Merge
Into
  [Opportunity_Dim]
Using
  (Select
  [Setop_2].[Opportunity_Id_3] AS [Opportunity_Id],
  [Setop_2].[Account_Id_3] AS [Account_Id],
  [Setop_2].[Description_3] AS [Description],
  [Setop_2].[Closed_3] AS [Closed],
  [Setop_2].[Stage_3] AS [Stage],
  [Setop_2].[Sales_Potential_3] AS [Sales_Potential],
  [Setop_2].[Close_Probability_3] AS [Close_Probability],
  [Setop_2].[Actual_Amount_3] AS [Actual_Amount],
  [Setop_2].[Estimated_Close_3] AS [Estimated_Close],
  [Setop_2].[Actual_Close_3] AS [Actual_Close],
  [Setop_2].[Notes_3] AS [Notes],
  [Setop_2].[Account_Manager_Id_3] AS [Account_Manager_Id],
  [Setop_2].[Status_3] AS [Status],
  [Setop_2].[Eo_Next_Step_3] AS [Next_Step],
  [Setop_2].[Reason_3] AS [Reason],
  [Setop_2].[Leadsource_Id_3] AS [Leadsource_Id],
  [Setop_2].[Seccode_Id_3] AS [Seccode_Id],
  [Setop_2].[Create_User_3] AS [Create_User],
  [Setop_2].[So_Createdate_3] AS [Creation_Date],
  [Setop_2].[Modifyuser_3] AS [Modifyuser],
  [Setop_2].[So_Modifydate_3] AS [Last_Update_Date],
  [Owb_Opportunity_Dim].[Get_Const_1_Gkdw_Source] AS [Gkdw_Source]
From
  (Select
  [Opportunity_Id] AS [Opportunity_Id_3],
  [Account_Id] AS [Account_Id_3],
  [Description] AS [Description_3],
  [Closed] AS [Closed_3],
  [Stage] AS [Stage_3],
  [Sales_Potential] AS [Sales_Potential_3],
  [Close_Probability] AS [Close_Probability_3],
  [Actual_Amount] AS [Actual_Amount_3],
  [Estimated_Close] AS [Estimated_Close_3],
  [Actual_Close] AS [Actual_Close_3],
  [Notes] AS [Notes_3],
  [Account_Manager_Id] AS [Account_Manager_Id_3],
  [Status] AS [Status_3],
  [Eo_Next_Step] AS [Eo_Next_Step_3],
  [Reason] AS [Reason_3],
  [Leadsource_Id] AS [Leadsource_Id_3],
  [Seccode_Id] AS [Seccode_Id_3],
  [Create_User] AS [Create_User_3],
  [So_Createdate] AS [So_Createdate_3],
  [Modifyuser] AS [Modifyuser_3],
  [So_Modifydate] AS [So_Modifydate_3],
  [Create_Date_Out] AS [Create_Date_Out_2],
  [Modify_Date_Out] AS [Modify_Date_Out_2]
From
  (Select
  [Opportunity].[Opportunityid] AS [Opportunity_Id],
  [Opportunity].[Accountid] AS [Account_Id],
  [Opportunity].[Description],
  [Opportunity].[Closed],
  [Opportunity].[Stage],
  [Opportunity].[Salespotential] AS [Sales_Potential],
  [Opportunity].[Closeprobability] AS [Close_Probability],
  [Opportunity].[Actualamount] AS [Actual_Amount],
  [Opportunity].[Estimatedclose] AS [Estimated_Close],
  [Opportunity].[Actualclose] AS [Actual_Close],
  [Opportunity].[Notes],
  [Opportunity].[Accountmanagerid] AS [Account_Manager_Id],
  [Opportunity].[Status],
  [Opportunity].[Nextstep] AS [Eo_Next_Step],
  [Opportunity].[Reason],
  [Opportunity].[Leadsourceid] AS [Leadsource_Id],
  [Opportunity].[Seccodeid] AS [Seccode_Id],
  [Opportunity].[Createuser] AS [Create_User],
  [Opportunity].[Createdate] AS [So_Createdate],
  [Opportunity].[Modifyuser],
  [Opportunity].[Modifydate] AS [So_Modifydate],
  [Owb_Opportunity_Dim].[Premapping_1_Create_Date_Out] AS [Create_Date_Out],
  [Owb_Opportunity_Dim].[Premapping_2_Modify_Date_Out] AS [Modify_Date_Out]
From
  [Base].[Opportunity] AS [Opportunity]
  Where 
  ( [Opportunity].[Createdate] >= [Owb_Opportunity_Dim].[Premapping_1_Create_Date_Out] Or [Opportunity].[Modifydate] >= [Owb_Opportunity_Dim].[Premapping_2_Modify_Date_Out] )
Union
Select
  [Gk_Sales_Opportunity].[Gk_Sales_Opportunityid] AS [Opportunity_Id],
  [Gk_Ent_Opportunity].[Accountid] AS [Account_Id],
  [Gk_Sales_Opportunity].[Description],
  [Gk_Ent_Opportunity].[Closed],
  [Gk_Ent_Opportunity].[Stage],
  [Gk_Sales_Opportunity].[Listprice] AS [Sales_Potential],
  [Gk_Sales_Opportunity].[Estclosedate_Probability] AS [Close_Probability],
  [Gk_Sales_Opportunity].[Nettprice] AS [Actual_Amount],
  [Gk_Sales_Opportunity].[Estimatedclose] AS [Estimated_Close],
  [Gk_Ent_Opportunity].[Actualclose] AS [Actual_Close],
  [Gk_Ent_Opportunity].[Description] AS [Notes],
  [Gk_Ent_Opportunity].[Accountmanagerid] AS [Account_Manager_Id],
  [Gk_Ent_Opportunity].[Status],
  [Owb_Opportunity_Dim].[Get_Const_2_Eo_Next_Step] AS [Eo_Next_Step],
  [Gk_Ent_Opportunity].[Reason],
  [Owb_Opportunity_Dim].[Get_Const_3_Leadsource_Id] AS [Leadsource_Id],
  [Gk_Ent_Opportunity].[Seccodeid] AS [Seccode_Id],
  [Gk_Sales_Opportunity].[Createuser] AS [Create_User],
  [Gk_Sales_Opportunity].[Createdate] AS [So_Createdate],
  [Gk_Sales_Opportunity].[Modifyuser],
  [Gk_Sales_Opportunity].[Modifydate] AS [So_Modifydate],
  [Owb_Opportunity_Dim].[Premapping_1_Create_Date_Out] AS [Create_Date_Out],
  [Owb_Opportunity_Dim].[Premapping_2_Modify_Date_Out] AS [Modify_Date_Out]
From
  [Base].[Gk_Ent_Opportunity] AS [Gk_Ent_Opportunity],
[Base].[Gk_Sales_Opportunity] AS [Gk_Sales_Opportunity]
  Where 
  ( [Gk_Ent_Opportunity].[Gk_Ent_Opportunityid] = [Gk_Sales_Opportunity].[Gk_Ent_Opportunityid] ) And
  ( [Gk_Ent_Opportunity].[Accountid] Is Not Null ) And
  ( ( [Gk_Ent_Opportunity].[Createdate] >= [Owb_Opportunity_Dim].[Premapping_1_Create_Date_Out] Or [Gk_Ent_Opportunity].[Modifydate] >= [Owb_Opportunity_Dim].[Premapping_2_Modify_Date_Out] ) Or ( [Gk_Sales_Opportunity].[Createdate] >= [Owb_Opportunity_Dim].[Premapping_1_Create_Date_Out] Or [Gk_Sales_Opportunity].[Modifydate] >= [Owb_Opportunity_Dim].[Premapping_2_Modify_Date_Out] ) )) ) AS [Setop_2]
  )
    Source
On (
  [Opportunity_Dim].[Opportunity_Id] = [Source].[Opportunity_Id]
   )
  
  When Matched Then
    Update
    Set
                  [Account_Id] = [Source].[Account_Id],
  [Description] = [Source].[Description],
  [Closed] = [Source].[Closed],
  [Stage] = [Source].[Stage],
  [Sales_Potential] = [Source].[Sales_Potential],
  [Close_Probability] = [Source].[Close_Probability],
  [Actual_Amount] = [Source].[Actual_Amount],
  [Estimated_Close] = [Source].[Estimated_Close],
  [Actual_Close] = [Source].[Actual_Close],
  [Notes] = [Source].[Notes],
  [Account_Manager_Id] = [Source].[Account_Manager_Id],
  [Status] = [Source].[Status],
  [Next_Step] = [Source].[Next_Step],
  [Reason] = [Source].[Reason],
  [Leadsource_Id] = [Source].[Leadsource_Id],
  [Seccode_Id] = [Source].[Seccode_Id],
  [Create_User] = [Source].[Create_User],
  [Creation_Date] = [Source].[Creation_Date],
  [Modifyuser] = [Source].[Modifyuser],
  [Last_Update_Date] = [Source].[Last_Update_Date],
  [Gkdw_Source] = [Source].[Gkdw_Source]
       
  When Not Matched Then
    Insert
      ([Opportunity_Id],
      [Account_Id],
      [Description],
      [Closed],
      [Stage],
      [Sales_Potential],
      [Close_Probability],
      [Actual_Amount],
      [Estimated_Close],
      [Actual_Close],
      [Notes],
      [Account_Manager_Id],
      [Status],
      [Next_Step],
      [Reason],
      [Leadsource_Id],
      [Seccode_Id],
      [Create_User],
      [Creation_Date],
      [Modifyuser],
      [Last_Update_Date],
      [Gkdw_Source])
    Values
      ([Source].[Opportunity_Id],
      [Source].[Account_Id],
      [Source].[Description],
      [Source].[Closed],
      [Source].[Stage],
      [Source].[Sales_Potential],
      [Source].[Close_Probability],
      [Source].[Actual_Amount],
      [Source].[Estimated_Close],
      [Source].[Actual_Close],
      [Source].[Notes],
      [Source].[Account_Manager_Id],
      [Source].[Status],
      [Source].[Next_Step],
      [Source].[Reason],
      [Source].[Leadsource_Id],
      [Source].[Seccode_Id],
      [Source].[Create_User],
      [Source].[Creation_Date],
      [Source].[Modifyuser],
      [Source].[Last_Update_Date],
      [Source].[Gkdw_Source])
  ;

