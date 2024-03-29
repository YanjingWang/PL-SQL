Select
  [Lookup_Input_Subquery_1].[Contactid_1] AS [Contactid_1],
  Upper(Trim([Lookup_Input_Subquery_1].[Firstname_1]))  + ' ' +    Upper(Trim([Lookup_Input_Subquery_1].[Middlename_1]))  +  ' '  +    Upper(Trim([Lookup_Input_Subquery_1].[Lastname_1])) AS [Name],
  Isnull([Account_Dim].[Acct_Name], Null) AS [Acct_Name],
  [Lookup_Input_Subquery_1].[Accountid_1] AS [Accountid_1],
  [Lookup_Input_Subquery_1].[Address1_1] AS [Address1_1],
  [Lookup_Input_Subquery_1].[Address2_1] AS [Address2_1],
  [Lookup_Input_Subquery_1].[Address3_1] AS [Address3_1],
  [Lookup_Input_Subquery_1].[City_1] AS [City_1],
  Case Upper(Trim([Lookup_Input_Subquery_1].[Country_1] ))
When 'Canada' 
Then Null 
When 'Can' 
Then Null 
Else  Upper(Trim([Lookup_Input_Subquery_1].[State_1]))
End [State],
  [Lookup_Input_Subquery_1].[Postalcode_1] AS [Postalcode_1],
  Case Upper(Trim([Lookup_Input_Subquery_1].[Country_1] ))
When 'Canada'
Then  Upper(Trim([Lookup_Input_Subquery_1].[State_1]))
When 'Can'
Then  Upper(Trim([Lookup_Input_Subquery_1].[State_1]))
Else Null
End [Province],
  Upper(Trim( [Lookup_Input_Subquery_1].[Country_1] )) AS [Country],
  Upper(Trim( [Lookup_Input_Subquery_1].[County_1] )) AS [County],
  [Lookup_Input_Subquery_1].[Createdate_1] AS [Createdate_1],
  [Lookup_Input_Subquery_1].[Modifydate_1] AS [Modifydate_1],
  [Lookup_Input_Subquery_1].[Title_1] AS [Title_1],
  [Lookup_Input_Subquery_1].[Workphone_1] AS [Workphone_1],
  [Lookup_Input_Subquery_1].[Email_1] AS [Email_1],
  Upper(Trim([Lookup_Input_Subquery_1].[Lastname_1])) AS [Last_Name],
  Upper(Trim([Lookup_Input_Subquery_1].[Firstname_1])) AS [First_Name],
  [Lookup_Input_Subquery_1].[Donotemail_1] AS [Donotemail_1],
  [Lookup_Input_Subquery_1].[Donotphone_1] AS [Donotphone_1],
  [Lookup_Input_Subquery_1].[Donotmail_1] AS [Donotmail_1],
  Isnull([Qg_Contact].[Id_Number], Null) AS [Id_Number],
  [Lookup_Input_Subquery_1].[Department_1] AS [Department_1],
  Isnull([Qg_Contact].[Extension], Null) AS [Extension],
  Isnull([Qg_Contact].[Att_Flag], Null) AS [Att_Flag],
  Isnull([Qg_Contact].[Max_Startdate], Null) AS [Max_Startdate],
  Isnull([Qg_Contact].[Title_Code], Null) AS [Title_Code]
From
   ( Select
  [Contact].[Contactid] AS [Contactid_1],
  [Contact].[Contacttype] AS [Contacttype_1],
  [Contact].[Accountid] AS [Accountid_1],
  [Contact].[Account] AS [Account_1],
  [Contact].[Department] AS [Department_1],
  [Contact].[Isprimary] AS [Isprimary_1],
  [Contact].[Lastname] AS [Lastname_1],
  [Contact].[Firstname] AS [Firstname_1],
  [Contact].[Middlename] AS [Middlename_1],
  [Contact].[Workphone] AS [Workphone_1],
  [Contact].[Homephone] AS [Homephone_1],
  [Contact].[Fax] AS [Fax_1],
  [Contact].[Mobile] AS [Mobile_1],
  [Contact].[Email] AS [Email_1],
  [Contact].[Description] AS [Description_1],
  [Contact].[Title] AS [Title_1],
  [Contact].[Seccodeid] AS [Seccodeid_1],
  [Contact].[Accountmanagerid] AS [Accountmanagerid_1],
  [Contact].[Status] AS [Status_1],
  [Contact].[Createdate] AS [Createdate_1],
  [Contact].[Createuser] AS [Createuser_1],
  [Contact].[Modifydate] AS [Modifydate_1],
  [Contact].[Modifyuser] AS [Modifyuser_1],
  [Contact].[Title_Code] AS [Title_Code_1],
  [Contact].[Legacyid] AS [Legacyid_1],
  [Contact].[Delegate] AS [Delegate_1],
  [Contact].[Decision_Maker] AS [Decision_Maker_1],
  [Contact].[Influencer] AS [Influencer_1],
  [Contact].[Booking_Contact] AS [Booking_Contact_1],
  [Contact].[Email_Not_Available] AS [Email_Not_Available_1],
  [Contact].[Email_Not_Available_Reason] AS [Email_Not_Available_Reason_1],
  [Contact].[Campaignid] AS [Campaignid_1],
  [Contact].[Directnumber] AS [Directnumber_1],
  [Contact].[Qg_Territoryid] AS [Qg_Territoryid_1],
  [Owb_Cust_Dim_Sb].[Premapping_1_Create_Date_Out] AS [Create_Date_Out_1],
  [Owb_Cust_Dim_Sb].[Premapping_2_Modify_Date_Out] AS [Modify_Date_Out_1],
  [Contact].[Addressid] AS [Addressid_1],
  [Contact].[Donotemail] AS [Donotemail_1],
  [Contact].[Donotmail] AS [Donotmail_1],
  [Contact].[Donotphone] AS [Donotphone_1],
  [Account].[Createdate] AS [Createdate_Account_1],
  [Account].[Modifydate] AS [Modifydate_Account_1],
  [Address].[Createdate] AS [Createdate_Address_1],
  [Address].[Modifydate] AS [Modifydate_Address_1],
  [Address].[Address1] AS [Address1_1],
  [Address].[Address2] AS [Address2_1],
  [Address].[City] AS [City_1],
  [Address].[State] AS [State_1],
  [Address].[Postalcode] AS [Postalcode_1],
  [Address].[County] AS [County_1],
  [Address].[Country] AS [Country_1],
  [Address].[Address3] AS [Address3_1]
From
    [Base].[Contact]  [Contact]   
 Left Outer Join  ( Select
  [Address].[Addressid] AS [Addressid],
  [Address].[Createdate] AS [Createdate],
  [Address].[Modifydate] AS [Modifydate],
  [Address].[Address1] AS [Address1],
  [Address].[Address2] AS [Address2],
  [Address].[City] AS [City],
  [Address].[State] AS [State],
  [Address].[Postalcode] AS [Postalcode],
  [Address].[County] AS [County],
  [Address].[Country] AS [Country],
  [Address].[Address3] AS [Address3]
From
  [Base].[Address] AS [Address] ) AS [Address] On ( ( [Contact].[Addressid] = [Address].[Addressid] ) )
 Left Outer Join  ( Select
  [Account].[Accountid] AS [Accountid],
  [Account].[Account] AS [Account],
  [Account].[Createdate] AS [Createdate],
  [Account].[Modifydate] AS [Modifydate]
From
  [Base].[Account] AS [Account] ) AS [Account] On ( ( [Contact].[Accountid] = [Account].[Accountid] ) ) ) AS [Lookup_Input_Subquery_1]   
 Left Outer Join   [Account_Dim]  [Account_Dim] On ( ( [Account_Dim].[Acct_Id] = [Lookup_Input_Subquery_1].[Accountid_1] ) )
 Left Outer Join   [Base].[Qg_Contact]  [Qg_Contact] On ( ( [Qg_Contact].[Contactid] = [Lookup_Input_Subquery_1].[Contactid_1] ) )
  Where 
  ( ( [Lookup_Input_Subquery_1].[Createdate_1] >= '7-Jul-2020' Or [Lookup_Input_Subquery_1].[Modifydate_1] >= '7-Jul-2020') 
  Or ( [Lookup_Input_Subquery_1].[Createdate_Account_1] >= '7-Jul-2020' Or [Lookup_Input_Subquery_1].[Modifydate_Account_1] >= '7-Jul-2020' )
  Or ( [Lookup_Input_Subquery_1].[Createdate_Address_1] >= '7-Jul-2020' Or [Lookup_Input_Subquery_1].[Modifydate_Address_1] >= '7-Jul-2020') );

