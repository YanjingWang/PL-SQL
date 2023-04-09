Select
  [Lookup_Input_Subquery].[Evxevenrollid] AS [Evxevenrollid],
  [Lookup_Input_Subquery].[Evxeventid] AS [Evxeventid],
  [Lookup_Input_Subquery].[Attendeecontactid] AS [Attendeecontactid],
  [Lookup_Input_Subquery].[Createdate_Hx] AS [Createdate_Hx],
  [Lookup_Input_Subquery].[Createdate_Txfee] AS [Createdate_Txfee],
  [Event_Dim].[Event_Channel] AS [Event_Channel],
  [Event_Dim].[Event_Type] AS [Event_Type],
  [Lookup_Input_Subquery].[Billingdate] AS [Billingdate],
  [Lookup_Input_Subquery].[Evxevticketid] AS [Evxevticketid],
  [Event_Dim].[Start_Date] AS [Start_Date],
  [Lookup_Input_Subquery].[Enrollsource] AS [Enrollsource],
  [Lookup_Input_Subquery].[Enrollqty] AS [Enrollqty],
  [Lookup_Input_Subquery].[Actualamount] AS [Actualamount],
  [Lookup_Input_Subquery].[Currencytype] AS [Currencytype],
  [Lookup_Input_Subquery].[Soldbyuser] AS [Soldbyuser],
  [Lookup_Input_Subquery].[Opportunityid] AS [Opportunityid],
  [Lookup_Input_Subquery].[Evxev_Txfeeid] AS [Evxev_Txfeeid],
  Case Upper(Trim([Cust_Dim].[Country] )) When 'Usa'  Then  Substr( [Cust_Dim].[Zipcode],1, 5)  Else  [Cust_Dim].[Zipcode]  End [Zip_Code],
  [Event_Dim].[Country] AS [Country],
  [Market_Dim].[Territory] AS [Territory],
  [Market_Dim].[Region] AS [Region],
  [Market_Dim].[Sales_Rep] AS [Sales_Rep],
  [Market_Dim].[Region_Mgr] AS [Region_Mgr],
  [Lookup_Input_Subquery].[Modifydate_Txfee] AS [Modifydate_Txfee],
  [Lookup_Input_Subquery].[Enrollstatus] AS [Enrollstatus],
  [Lookup_Input_Subquery].[Enrollstatusdesc] AS [Enrollstatusdesc],
  [Lookup_Input_Subquery].[Feetype] AS [Feetype],
  [Lookup_Input_Subquery].[Enrollstatusdate] AS [Enrollstatusdate],
  [Ppcard_Dim].[Sales_Order_Id] AS [Sales_Order_Id],
  [Lookup_Input_Subquery].[Source] AS [Source],
  [Evxbilling].[Balancedue] AS [Balancedue],
  [Evxbillpayment].[Method] AS [Method],
  [Evxbillpayment].[Evxppcardid] AS [Evxppcardid],
  [Lookup_Input_Subquery].[Actualrate] AS [Actualrate],
  [Lookup_Input_Subquery].[Ponumber] AS [Ponumber],
  [Lookup_Input_Subquery].[Channel] AS [Channel],
  [Lookup_Input_Subquery].[Createuser_Txfee] AS [Createuser_Txfee],
  [Lookup_Input_Subquery].[Modifyuser_Txfee] AS [Modifyuser_Txfee],
  [Lookup_Input_Subquery].[Reviewtype] AS [Reviewtype],
  [Lookup_Input_Subquery].[Attendeetype] AS [Attendeetype],
  [Evxbillpayment].[Checknumber] AS [Checknumber],
  [Lookup_Input_Subquery].[Comments] AS [Comments],
  [Cust_Dim].[Ob_National_Terr_Num] AS [Ob_National_Terr_Num],
  [Cust_Dim].[Ob_National_Rep_Id] AS [Ob_National_Rep_Id],
  [Cust_Dim].[Ob_National_Rep_Name] AS [Ob_National_Rep_Name],
  [Cust_Dim].[Ob_Terr_Num] AS [Ob_Terr_Num],
  [Cust_Dim].[Ob_Rep_Id] AS [Ob_Rep_Id],
  [Cust_Dim].[Ob_Rep_Name] AS [Ob_Rep_Name],
  [Cust_Dim].[Osr_Terr_Num] AS [Osr_Terr_Num],
  [Cust_Dim].[Osr_Id] AS [Osr_Id],
  [Cust_Dim].[Osr_Rep_Name] AS [Osr_Rep_Name],
  [Cust_Dim].[Ent_National_Terr_Num] AS [Ent_National_Terr_Num],
  [Cust_Dim].[Ent_National_Rep_Id] AS [Ent_National_Rep_Id],
  [Cust_Dim].[Ent_National_Rep_Name] AS [Ent_National_Rep_Name],
  [Cust_Dim].[Ent_Inside_Terr_Num] AS [Ent_Inside_Terr_Num],
  [Cust_Dim].[Ent_Inside_Rep_Id] AS [Ent_Inside_Rep_Id],
  [Cust_Dim].[Ent_Inside_Rep_Name] AS [Ent_Inside_Rep_Name],
  [Cust_Dim].[Ent_Federal_Terr_Num] AS [Ent_Federal_Terr_Num],
  [Cust_Dim].[Ent_Federal_Rep_Id] AS [Ent_Federal_Rep_Id],
  [Cust_Dim].[Ent_Federal_Rep_Name] AS [Ent_Federal_Rep_Name],
  [Cust_Dim].[Btsr_Terr_Num] AS [Btsr_Terr_Num],
  [Cust_Dim].[Btsr_Rep_Id] AS [Btsr_Rep_Id],
  [Cust_Dim].[Btsr_Rep_Name] AS [Btsr_Rep_Name],
  [Cust_Dim].[Bta_Terr_Num] AS [Bta_Terr_Num],
  [Cust_Dim].[Bta_Rep_Id] AS [Bta_Rep_Id],
  [Cust_Dim].[Bta_Rep_Name] AS [Bta_Rep_Name]
From
   ( Select
  [Owb_Order_Fact].[Premapping_1_Create_Date_Out] AS [Create_Date_Out],
  [Owb_Order_Fact].[Premapping_2_Modify_Date_Out] AS [Modify_Date_Out],
  [Evxev_Txfee].[Evxev_Txfeeid] AS [Evxev_Txfeeid],
  [Evxev_Txfee].[Createdate] AS [Createdate_Txfee],
  [Evxev_Txfee].[Modifydate] AS [Modifydate_Txfee],
  [Evxev_Txfee].[Actualamount] AS [Actualamount],
  [Evxev_Txfee].[Actualquantity] AS [Actualquantity],
  [Evxev_Txfee].[Evxeventid] AS [Evxeventid],
  [Evxev_Txfee].[Attendeecontactid] AS [Attendeecontactid],
  [Evxenrollhx].[Createdate] AS [Createdate_Hx],
  [Evxenrollhx].[Enrollqty] AS [Enrollqty],
  [Evxenrollhx].[Enrollstatus] AS [Enrollstatus],
  [Evxenrollhx].[Evxevenrollid] AS [Evxevenrollid],
  [Evxev_Txfee].[Evxevticketid] AS [Evxevticketid],
  [Evxenrollhx].[Enrollstatusdesc] AS [Enrollstatusdesc],
  [Evxenrollhx].[Enrollsource] AS [Enrollsource],
  [Evxev_Txfee].[Billingdate] AS [Billingdate],
  [Evxev_Txfee].[Currencytype] AS [Currencytype],
  [Evxev_Txfee].[Evxbillingid] AS [Evxbillingid],
  [Evxevticket].[Soldbyuser] AS [Soldbyuser],
  [Evxev_Txfee].[Feetype] AS [Feetype],
  [Evxenrollhx].[Enrollstatusdate] AS [Enrollstatusdate],
  [Evxenrollhx].[Modifydate] AS [Modifydate_Hx],
  [Evxev_Txfee].[Actualrate] AS [Actualrate],
  [Qg_Evenroll].[Source] AS [Source],
  [Qg_Evenroll].[Createdate] AS [Createdate_Qg],
  [Qg_Evenroll].[Modifydate] AS [Modifydate_Qg],
  [Qg_Evenroll].[Channel] AS [Channel],
  [Evxev_Txfee].[Createuser] AS [Createuser_Txfee],
  [Evxev_Txfee].[Modifyuser] AS [Modifyuser_Txfee],
  [Evxevticket].[Opportunityid] AS [Opportunityid],
  [Evxevticket].[Ponumber] AS [Ponumber],
  [Evxevticket].[Reviewtype] AS [Reviewtype],
  [Evxevticket].[Createdate] AS [Createdate_Tkt],
  [Evxevticket].[Modifydate] AS [Modifydate_Tkt],
  [Evxevticket].[Attendeetype] AS [Attendeetype],
  [Evxevticket].[Comments] AS [Comments]
From
    [Base].[Evxenrollhx]  [Evxenrollhx]   
 Join   [Base].[Evxev_Txfee]  [Evxev_Txfee] On ( ( [Evxenrollhx].[Evxevenrollid] = [Evxev_Txfee].[Evxevenrollid] ) )
 Left Outer Join  ( Select
  [Qg_Evenroll].[Evxevenrollid] AS [Evxevenrollid],
  [Qg_Evenroll].[Createdate] AS [Createdate],
  [Qg_Evenroll].[Modifydate] AS [Modifydate],
  [Qg_Evenroll].[Source] AS [Source],
  [Qg_Evenroll].[Channel] AS [Channel]
From
  [Base].[Qg_Evenroll] AS [Qg_Evenroll] ) AS [Qg_Evenroll] On ( ( [Evxenrollhx].[Evxevenrollid] = [Qg_Evenroll].[Evxevenrollid] ) )
 Join   [Base].[Evxevticket]  [Evxevticket] On ( ( [Evxev_Txfee].[Evxevticketid] = [Evxevticket].[Evxevticketid] ) ) ) AS [Lookup_Input_Subquery]  
 Inner Join [Base].[Evxenrollhx] AS [Evxenrollhx1] On  [Lookup_Input_Subquery].[Evxevenrollid] =  [Evxenrollhx1].[Evxevenrollid]
 Left Outer Join   [Event_Dim]  [Event_Dim] On ( ( [Event_Dim].[Event_Id] = [Lookup_Input_Subquery].[Evxeventid] ) )
 Left Outer Join   [Cust_Dim]  [Cust_Dim] On ( ( [Cust_Dim].[Cust_Id] = [Lookup_Input_Subquery].[Attendeecontactid] ) )
 Left Outer Join   [Market_Dim]  [Market_Dim] On ( ( [Market_Dim].[Zipcode] = (Case Upper(Trim([Cust_Dim].[Country] )) When 'Usa'  Then  Substr( [Cust_Dim].[Zipcode],1, 5)  Else  [Cust_Dim].[Zipcode]  End) ) )
 Left Outer Join   [Base].[Evxbillpayment]  [Evxbillpayment] On ( ( [Evxbillpayment].[Evxbillingid] = [Lookup_Input_Subquery].[Evxbillingid] ) )
 Left Outer Join   [Ppcard_Dim]  [Ppcard_Dim] On ( ( [Ppcard_Dim].[Ppcard_Id] = [Evxbillpayment].[Evxppcardid] ) )
 Left Outer Join   [Base].[Evxbilling]  [Evxbilling] On ( ( ( [Evxbilling].[Evxbillingid] = [Lookup_Input_Subquery].[Evxbillingid] ) ) )
  Where 
  ( ( [Lookup_Input_Subquery].[Createdate_Txfee] >= [Lookup_Input_Subquery].[Create_Date_Out] Or [Lookup_Input_Subquery].[Modifydate_Txfee] >= [Lookup_Input_Subquery].[Modify_Date_Out] ) 
      Or ( [Lookup_Input_Subquery].[Createdate_Hx] >= [Lookup_Input_Subquery].[Create_Date_Out] Or [Lookup_Input_Subquery].[Modifydate_Hx] >= [Lookup_Input_Subquery].[Modify_Date_Out] ) 
      Or ( [Lookup_Input_Subquery].[Createdate_Qg] >= [Lookup_Input_Subquery].[Create_Date_Out] Or [Lookup_Input_Subquery].[Modifydate_Qg] >= [Lookup_Input_Subquery].[Modify_Date_Out] ) 
      Or ( [Lookup_Input_Subquery].[Createdate_Tkt] >= [Lookup_Input_Subquery].[Create_Date_Out] Or [Lookup_Input_Subquery].[Modifydate_Tkt] >= [Lookup_Input_Subquery].[Modify_Date_Out] ) )
      And Not Exists (Select 1 From [Gk_Master_Account_Exclude] AS [Gk_Master_Account_Exclude] Where (([Gk_Master_Account_Exclude].[Acct_Id] = [Cust_Dim].[Acct_Id] )));

