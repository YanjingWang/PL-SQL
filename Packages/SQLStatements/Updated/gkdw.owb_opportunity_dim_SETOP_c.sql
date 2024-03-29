Select
  [Setop].[Opportunity_Id] AS [Opportunity_Id],
  [Setop].[Account_Id] AS [Account_Id],
  [Setop].[Description] AS [Description],
  [Setop].[Closed] AS [Closed],
  [Setop].[Stage] AS [Stage],
  [Setop].[Sales_Potential] AS [Sales_Potential],
  [Setop].[Close_Probability] AS [Close_Probability],
  [Setop].[Actual_Amount] AS [Actual_Amount],
  [Setop].[Estimated_Close] AS [Estimated_Close],
  [Setop].[Actual_Close] AS [Actual_Close],
  [Setop].[Notes] AS [Notes],
  [Setop].[Account_Manager_Id] AS [Account_Manager_Id],
  [Setop].[Status] AS [Status],
  [Setop].[Eo_Next_Step] AS [Eo_Next_Step],
  [Setop].[Reason] AS [Reason],
  [Setop].[Leadsource_Id] AS [Leadsource_Id],
  [Setop].[Seccode_Id] AS [Seccode_Id],
  [Setop].[Create_User] AS [Create_User],
  [Setop].[So_Createdate] AS [So_Createdate],
  [Setop].[Modifyuser] AS [Modifyuser],
  [Setop].[So_Modifydate] AS [So_Modifydate]
From
  (Select
  [Opportunity_Id] AS [Opportunity_Id],
  [Account_Id] AS [Account_Id],
  [Description] AS [Description],
  [Closed] AS [Closed],
  [Stage] AS [Stage],
  [Sales_Potential] AS [Sales_Potential],
  [Close_Probability] AS [Close_Probability],
  [Actual_Amount] AS [Actual_Amount],
  [Estimated_Close] AS [Estimated_Close],
  [Actual_Close] AS [Actual_Close],
  [Notes] AS [Notes],
  [Account_Manager_Id] AS [Account_Manager_Id],
  [Status] AS [Status],
  [Eo_Next_Step] AS [Eo_Next_Step],
  [Reason] AS [Reason],
  [Leadsource_Id] AS [Leadsource_Id],
  [Seccode_Id] AS [Seccode_Id],
  [Create_User] AS [Create_User],
  [So_Createdate] AS [So_Createdate],
  [Modifyuser] AS [Modifyuser],
  [So_Modifydate] AS [So_Modifydate],
  [Create_Date_Out] AS [Create_Date_Out],
  [Modify_Date_Out] AS [Modify_Date_Out]
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
  ( ( [Gk_Ent_Opportunity].[Createdate] >= [Owb_Opportunity_Dim].[Premapping_1_Create_Date_Out] Or [Gk_Ent_Opportunity].[Modifydate] >= [Owb_Opportunity_Dim].[Premapping_2_Modify_Date_Out] ) Or ( [Gk_Sales_Opportunity].[Createdate] >= [Owb_Opportunity_Dim].[Premapping_1_Create_Date_Out] Or [Gk_Sales_Opportunity].[Modifydate] >= [Owb_Opportunity_Dim].[Premapping_2_Modify_Date_Out] ) )) ) AS [Setop];

