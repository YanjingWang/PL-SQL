Select
  [Lookup_Input_Subquery_1].[Evxevenrollid_1] AS [Evxevenrollid_1],
  [Lookup_Input_Subquery_1].[Evxeventid_1] AS [Evxeventid_1],
  [Lookup_Input_Subquery_1].[Attendeecontactid_1] AS [Attendeecontactid_1],
  Trunc([Lookup_Input_Subquery_1].[Createdate_Hx_1]) AS [Enroll_Date],
  [Lookup_Input_Subquery_1].[Evxevticketid_1] AS [Evxevticketid_1],
  Case
When 
([Event_Dim].[Event_Channel]  = 'Individual/Public' Or
([Event_Dim].[Event_Channel] Is Null 
And  [Event_Dim].[Event_Type] = 'Open Enrollment'))
Then 
        Trunc([Lookup_Input_Subquery_1].[Billingdate_1])
When 
( [Event_Dim].[Event_Channel]  = 'Enterprise/Private' Or 
( [Event_Dim].[Event_Channel] Is Null 
And  [Event_Dim].[Event_Type]  = 'Onsite'))
Then
        Trunc([Lookup_Input_Subquery_1].[Createdate_Txfee_1])
Else
        Trunc([Lookup_Input_Subquery_1].[Createdate_Txfee_1] )
End [Book_Date],
  Case  When (Case
When 
([Event_Dim].[Event_Channel]  = 'Individual/Public' Or
([Event_Dim].[Event_Channel] Is Null 
And  [Event_Dim].[Event_Type] = 'Open Enrollment'))
Then 
        Trunc([Lookup_Input_Subquery_1].[Billingdate_1])
When 
( [Event_Dim].[Event_Channel]  = 'Enterprise/Private' Or 
( [Event_Dim].[Event_Channel] Is Null 
And  [Event_Dim].[Event_Type]  = 'Onsite'))
Then
        Trunc([Lookup_Input_Subquery_1].[Createdate_Txfee_1])
Else
        Trunc([Lookup_Input_Subquery_1].[Createdate_Txfee_1] )
End) Is Null Then Null When  [Event_Dim].[Start_Date] <  (Case
When 
([Event_Dim].[Event_Channel]  = 'Individual/Public' Or
([Event_Dim].[Event_Channel] Is Null 
And  [Event_Dim].[Event_Type] = 'Open Enrollment'))
Then 
        Trunc([Lookup_Input_Subquery_1].[Billingdate_1])
When 
( [Event_Dim].[Event_Channel]  = 'Enterprise/Private' Or 
( [Event_Dim].[Event_Channel] Is Null 
And  [Event_Dim].[Event_Type]  = 'Onsite'))
Then
        Trunc([Lookup_Input_Subquery_1].[Createdate_Txfee_1])
Else
        Trunc([Lookup_Input_Subquery_1].[Createdate_Txfee_1] )
End)  Then  (Case
When 
([Event_Dim].[Event_Channel]  = 'Individual/Public' Or
([Event_Dim].[Event_Channel] Is Null 
And  [Event_Dim].[Event_Type] = 'Open Enrollment'))
Then 
        Trunc([Lookup_Input_Subquery_1].[Billingdate_1])
When 
( [Event_Dim].[Event_Channel]  = 'Enterprise/Private' Or 
( [Event_Dim].[Event_Channel] Is Null 
And  [Event_Dim].[Event_Type]  = 'Onsite'))
Then
        Trunc([Lookup_Input_Subquery_1].[Createdate_Txfee_1])
Else
        Trunc([Lookup_Input_Subquery_1].[Createdate_Txfee_1] )
End)  Else  [Event_Dim].[Start_Date]  End [Rev_Date],
  [Lookup_Input_Subquery_1].[Enrollsource_1] AS [Enrollsource_1],
  [Lookup_Input_Subquery_1].[Enrollqty_1] AS [Enrollqty_1],
  [Lookup_Input_Subquery_1].[Actualamount_1] AS [Actualamount_1],
  [Lookup_Input_Subquery_1].[Currencytype_1] AS [Currencytype_1],
  [Lookup_Input_Subquery_1].[Soldbyuser_1] AS [Soldbyuser_1],
  [Lookup_Input_Subquery_1].[Opportunityid_1] AS [Opportunityid_1],
  [Get_Ora_Trx_Num]([Lookup_Input_Subquery_1].[Evxev_Txfeeid_2]) AS [Evxev_Txfeeid_1],
  Case Upper(Trim([Cust_Dim].[Country] )) When 'Usa'  Then  Substr( [Cust_Dim].[Zipcode],1, 5)  Else  [Cust_Dim].[Zipcode]  End [Zip_Code],
  [Event_Dim].[Country] AS [Country],
  [Market_Dim].[Territory] AS [Territory],
  [Market_Dim].[Region] AS [Region],
  [Market_Dim].[Sales_Rep] AS [Sales_Rep],
  [Market_Dim].[Region_Mgr] AS [Region_Mgr],
  [Lookup_Input_Subquery_1].[Createdate_Txfee_1] AS [Create_Date],
  [Lookup_Input_Subquery_1].[Modifydate_Txfee_1] AS [Modifydate_Txfee_1],
  [Lookup_Input_Subquery_1].[Enrollstatus_1] AS [Enrollstatus_1],
  [Lookup_Input_Subquery_1].[Evxev_Txfeeid_2] AS [Evxev_Txfeeid_2],
  [Lookup_Input_Subquery_1].[Billingdate_1] AS [Billingdate_1],
  [Lookup_Input_Subquery_1].[Enrollstatusdesc_1] AS [Enrollstatusdesc_1],
  [Lookup_Input_Subquery_1].[Feetype_1] AS [Feetype_1],
  [Lookup_Input_Subquery_1].[Enrollstatusdate_1] AS [Enrollstatusdate_1],
  [Ppcard_Dim].[Sales_Order_Id] AS [Sales_Order_Id],
  [Lookup_Input_Subquery_1].[Source_1] AS [Source_1],
  [Evxbilling].[Balancedue] AS [Balancedue],
  Case When 
(   [Evxbillpayment].[Method]  = 'Prepay Card'
        Or  [Ppcard_Dim].[Sales_Order_Id]  Is Not Null
        Or  [Evxbillpayment].[Evxppcardid]  Is Not Null
       ) 
 And  (Trunc([Lookup_Input_Subquery_1].[Createdate_Hx_1]))  >= '01-May-2007'
 Then
  [Get_List_Price]( [Lookup_Input_Subquery_1].[Evxeventid_1],  
                        [Lookup_Input_Subquery_1].[Feetype_1],
                        (Trunc([Lookup_Input_Subquery_1].[Createdate_Hx_1])) )
Else
  [Lookup_Input_Subquery_1].[Actualrate_1] 
 End [List_Price_Out],
  [Lookup_Input_Subquery_1].[Ponumber_1] AS [Ponumber_1],
  [Evxbillpayment].[Evxppcardid] AS [Evxppcardid],
  [Evxbillpayment].[Method] AS [Method],
  [Lookup_Input_Subquery_1].[Channel_1] AS [Channel_1],
  [Lookup_Input_Subquery_1].[Createuser_Txfee_1] AS [Createuser_Txfee_1],
  [Lookup_Input_Subquery_1].[Modifyuser_Txfee_1] AS [Modifyuser_Txfee_1],
  [Lookup_Input_Subquery_1].[Reviewtype_1] AS [Reviewtype_1],
  [Lookup_Input_Subquery_1].[Attendeetype_1] AS [Attendeetype_1],
  [Evxbillpayment].[Checknumber] AS [Checknumber],
  [Lookup_Input_Subquery_1].[Comments_1] AS [Comments_1],
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
  [Owb_Order_Fact].[Premapping_1_Create_Date_Out] AS [Create_Date_Out_1],
  [Owb_Order_Fact].[Premapping_2_Modify_Date_Out] AS [Modify_Date_Out_1],
  [Evxev_Txfee].[Evxev_Txfeeid] AS [Evxev_Txfeeid_2],
  [Evxev_Txfee].[Createdate] AS [Createdate_Txfee_1],
  [Evxev_Txfee].[Modifydate] AS [Modifydate_Txfee_1],
  [Evxev_Txfee].[Actualamount] AS [Actualamount_1],
  [Evxev_Txfee].[Actualquantity] AS [Actualquantity_1],
  [Evxev_Txfee].[Evxeventid] AS [Evxeventid_1],
  [Evxev_Txfee].[Attendeecontactid] AS [Attendeecontactid_1],
  [Evxenrollhx].[Createdate] AS [Createdate_Hx_1],
  [Evxenrollhx].[Enrollqty] AS [Enrollqty_1],
  [Evxenrollhx].[Enrollstatus] AS [Enrollstatus_1],
  [Evxenrollhx].[Evxevenrollid] AS [Evxevenrollid_1],
  [Evxev_Txfee].[Evxevticketid] AS [Evxevticketid_1],
  [Evxenrollhx].[Enrollstatusdesc] AS [Enrollstatusdesc_1],
  [Evxenrollhx].[Enrollsource] AS [Enrollsource_1],
  [Evxev_Txfee].[Billingdate] AS [Billingdate_1],
  [Evxev_Txfee].[Currencytype] AS [Currencytype_1],
  [Evxev_Txfee].[Evxbillingid] AS [Evxbillingid_1],
  [Evxevticket].[Soldbyuser] AS [Soldbyuser_1],
  [Evxev_Txfee].[Feetype] AS [Feetype_1],
  [Evxenrollhx].[Enrollstatusdate] AS [Enrollstatusdate_1],
  [Evxenrollhx].[Modifydate] AS [Modifydate_Hx_1],
  [Evxev_Txfee].[Actualrate] AS [Actualrate_1],
  [Qg_Evenroll].[Source] AS [Source_1],
  [Qg_Evenroll].[Createdate] AS [Createdate_Qg_1],
  [Qg_Evenroll].[Modifydate] AS [Modifydate_Qg_1],
  [Qg_Evenroll].[Channel] AS [Channel_1],
  [Evxev_Txfee].[Createuser] AS [Createuser_Txfee_1],
  [Evxev_Txfee].[Modifyuser] AS [Modifyuser_Txfee_1],
  [Evxevticket].[Opportunityid] AS [Opportunityid_1],
  [Evxevticket].[Ponumber] AS [Ponumber_1],
  [Evxevticket].[Reviewtype] AS [Reviewtype_1],
  [Evxevticket].[Createdate] AS [Createdate_Tkt_1],
  [Evxevticket].[Modifydate] AS [Modifydate_Tkt_1],
  [Evxevticket].[Attendeetype] AS [Attendeetype_1],
  [Evxevticket].[Comments] AS [Comments_1]
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
 Join   [Base].[Evxevticket]  [Evxevticket] On ( ( [Evxev_Txfee].[Evxevticketid] = [Evxevticket].[Evxevticketid] ) ) ) AS [Lookup_Input_Subquery_1]   
 Left Outer Join   [Event_Dim]  [Event_Dim] On ( ( [Event_Dim].[Event_Id] = [Lookup_Input_Subquery_1].[Evxeventid_1] ) )
 Left Outer Join   [Cust_Dim]  [Cust_Dim] On ( ( [Cust_Dim].[Cust_Id] = [Lookup_Input_Subquery_1].[Attendeecontactid_1] ) )
 Left Outer Join   [Market_Dim]  [Market_Dim] On ( ( [Market_Dim].[Zipcode] = (Case Upper(Trim([Cust_Dim].[Country] )) When 'Usa'  Then  Substr( [Cust_Dim].[Zipcode],1, 5)  Else  [Cust_Dim].[Zipcode]  End) ) )
 Left Outer Join   [Base].[Evxbillpayment]  [Evxbillpayment] On ( ( [Evxbillpayment].[Evxbillingid] = [Lookup_Input_Subquery_1].[Evxbillingid_1] ) )
 Left Outer Join   [Ppcard_Dim]  [Ppcard_Dim] On ( ( [Ppcard_Dim].[Ppcard_Id] = [Evxbillpayment].[Evxppcardid] ) )
 Left Outer Join   [Base].[Evxbilling]  [Evxbilling] On ( ( ( [Evxbilling].[Evxbillingid] = [Lookup_Input_Subquery_1].[Evxbillingid_1] ) ) )
  Where 
  ( ( [Lookup_Input_Subquery_1].[Createdate_Txfee_1] >= [Lookup_Input_Subquery_1].[Create_Date_Out_1] Or [Lookup_Input_Subquery_1].[Modifydate_Txfee_1] >= [Lookup_Input_Subquery_1].[Modify_Date_Out_1] ) Or ( [Lookup_Input_Subquery_1].[Createdate_Hx_1] >= [Lookup_Input_Subquery_1].[Create_Date_Out_1] Or [Lookup_Input_Subquery_1].[Modifydate_Hx_1] >= [Lookup_Input_Subquery_1].[Modify_Date_Out_1] ) Or ( [Lookup_Input_Subquery_1].[Createdate_Qg_1] >= [Lookup_Input_Subquery_1].[Create_Date_Out_1] Or [Lookup_Input_Subquery_1].[Modifydate_Qg_1] >= [Lookup_Input_Subquery_1].[Modify_Date_Out_1] ) Or ( [Lookup_Input_Subquery_1].[Createdate_Tkt_1] >= [Lookup_Input_Subquery_1].[Create_Date_Out_1] Or [Lookup_Input_Subquery_1].[Modifydate_Tkt_1] >= [Lookup_Input_Subquery_1].[Modify_Date_Out_1] ) )
  And Not Exists (Select 1 From [Gk_Master_Account_Exclude] AS [Gk_Master_Account_Exclude] Where (([Gk_Master_Account_Exclude].[Acct_Id] = [Cust_Dim].[Acct_Id] )));

