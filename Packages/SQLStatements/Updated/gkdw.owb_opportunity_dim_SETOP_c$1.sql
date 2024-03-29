Select
  [Setop_1].[Opportunity_Id_1] AS [Opportunity_Id_1],
  [Setop_1].[Account_Id_1] AS [Account_Id_1],
  [Setop_1].[Description_1] AS [Description_1],
  [Setop_1].[Closed_1] AS [Closed_1],
  [Setop_1].[Stage_1] AS [Stage_1],
  [Setop_1].[Sales_Potential_1] AS [Sales_Potential_1],
  [Setop_1].[Close_Probability_1] AS [Close_Probability_1],
  [Setop_1].[Actual_Amount_1] AS [Actual_Amount_1],
  [Setop_1].[Estimated_Close_1] AS [Estimated_Close_1],
  [Setop_1].[Actual_Close_1] AS [Actual_Close_1],
  [Setop_1].[Notes_1] AS [Notes_1],
  [Setop_1].[Account_Manager_Id_1] AS [Account_Manager_Id_1],
  [Setop_1].[Status_1] AS [Status_1],
  [Setop_1].[Eo_Next_Step_1] AS [Eo_Next_Step_1],
  [Setop_1].[Reason_1] AS [Reason_1],
  [Setop_1].[Leadsource_Id_1] AS [Leadsource_Id_1],
  [Setop_1].[Seccode_Id_1] AS [Seccode_Id_1],
  [Setop_1].[Create_User_1] AS [Create_User_1],
  [Setop_1].[So_Createdate_1] AS [So_Createdate_1],
  [Setop_1].[Modifyuser_1] AS [Modifyuser_1],
  [Setop_1].[So_Modifydate_1] AS [So_Modifydate_1]
From
  (Select
  [Opportunity_Id] AS [Opportunity_Id_1],
  [Account_Id] AS [Account_Id_1],
  [Description] AS [Description_1],
  [Closed] AS [Closed_1],
  [Stage] AS [Stage_1],
  [Sales_Potential] AS [Sales_Potential_1],
  [Close_Probability] AS [Close_Probability_1],
  [Actual_Amount] AS [Actual_Amount_1],
  [Estimated_Close] AS [Estimated_Close_1],
  [Actual_Close] AS [Actual_Close_1],
  [Notes] AS [Notes_1],
  [Account_Manager_Id] AS [Account_Manager_Id_1],
  [Status] AS [Status_1],
  [Eo_Next_Step] AS [Eo_Next_Step_1],
  [Reason] AS [Reason_1],
  [Leadsource_Id] AS [Leadsource_Id_1],
  [Seccode_Id] AS [Seccode_Id_1],
  [Create_User] AS [Create_User_1],
  [So_Createdate] AS [So_Createdate_1],
  [Modifyuser] AS [Modifyuser_1],
  [So_Modifydate] AS [So_Modifydate_1],
  [Create_Date_Out] AS [Create_Date_Out_1],
  [Modify_Date_Out] AS [Modify_Date_Out_1]
From
  (Select
  [Opportunity].[Opportunityid] AS [Opportunity_Id],
  [Opportunity].[Accountid] AS [Account_Id],
  [Opportunity].[Description] AS [Description],
  [Opportunity].[Closed] AS [Closed],
  [Opportunity].[Stage] AS [Stage],
  [Opportunity].[Salespotential] AS [Sales_Potential],
  [Opportunity].[Closeprobability] AS [Close_Probability],
  [Opportunity].[Actualamount] AS [Actual_Amount],
  [Opportunity].[Estimatedclose] AS [Estimated_Close],
  [Opportunity].[Actualclose] AS [Actual_Close],
  [Opportunity].[Notes] AS [Notes],
  [Opportunity].[Accountmanagerid] AS [Account_Manager_Id],
  [Opportunity].[Status] AS [Status],
  [Opportunity].[Nextstep] AS [Eo_Next_Step],
  [Opportunity].[Reason] AS [Reason],
  [Opportunity].[Leadsourceid] AS [Leadsource_Id],
  [Opportunity].[Seccodeid] AS [Seccode_Id],
  [Opportunity].[Createuser] AS [Create_User],
  [Opportunity].[Createdate] AS [So_Createdate],
  [Opportunity].[Modifyuser] AS [Modifyuser],
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
  [Gk_Sales_Opportunity].[Description] AS [Description],
  [Gk_Ent_Opportunity].[Closed] AS [Closed],
  [Gk_Ent_Opportunity].[Stage] AS [Stage],
  [Gk_Sales_Opportunity].[Listprice] AS [Sales_Potential],
  [Gk_Sales_Opportunity].[Estclosedate_Probability] AS [Close_Probability],
  [Gk_Sales_Opportunity].[Nettprice] AS [Actual_Amount],
  [Gk_Sales_Opportunity].[Estimatedclose] AS [Estimated_Close],
  [Gk_Ent_Opportunity].[Actualclose] AS [Actual_Close],
  [Gk_Ent_Opportunity].[Description] AS [Notes],
  [Gk_Ent_Opportunity].[Accountmanagerid] AS [Account_Manager_Id],
  [Gk_Ent_Opportunity].[Status] AS [Status],
  [Owb_Opportunity_Dim].[Get_Const_2_Eo_Next_Step] AS [Eo_Next_Step],
  [Gk_Ent_Opportunity].[Reason] AS [Reason],
  [Owb_Opportunity_Dim].[Get_Const_3_Leadsource_Id] AS [Leadsource_Id],
  [Gk_Ent_Opportunity].[Seccodeid] AS [Seccode_Id],
  [Gk_Sales_Opportunity].[Createuser] AS [Create_User],
  [Gk_Sales_Opportunity].[Createdate] AS [So_Createdate],
  [Gk_Sales_Opportunity].[Modifyuser] AS [Modifyuser],
  [Gk_Sales_Opportunity].[Modifydate] AS [So_Modifydate],
  [Owb_Opportunity_Dim].[Premapping_1_Create_Date_Out] AS [Create_Date_Out],
  [Owb_Opportunity_Dim].[Premapping_2_Modify_Date_Out] AS [Modify_Date_Out]
From
  [Base].[Gk_Ent_Opportunity] AS [Gk_Ent_Opportunity],
[Base].[Gk_Sales_Opportunity] AS [Gk_Sales_Opportunity]
  Where 
  ( [Gk_Ent_Opportunity].[Gk_Ent_Opportunityid] = [Gk_Sales_Opportunity].[Gk_Ent_Opportunityid] ) And
  ( [Gk_Ent_Opportunity].[Accountid] Is Not Null ) And
  ( ( [Gk_Ent_Opportunity].[Createdate] >= [Owb_Opportunity_Dim].[Premapping_1_Create_Date_Out] Or [Gk_Ent_Opportunity].[Modifydate] >= [Owb_Opportunity_Dim].[Premapping_2_Modify_Date_Out] ) Or ( [Gk_Sales_Opportunity].[Createdate] >= [Owb_Opportunity_Dim].[Premapping_1_Create_Date_Out] Or [Gk_Sales_Opportunity].[Modifydate] >= [Owb_Opportunity_Dim].[Premapping_2_Modify_Date_Out] ) )) ) AS [Setop_1];

