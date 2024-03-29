Merge
Into
  [Cust_Dim]
Using
  (Select
  [Lookup_Input_Subquery_2].[Contactid_3] AS [Contactid_2],
  Upper(Trim([Lookup_Input_Subquery_2].[Firstname_2]))  + ' ' +    Upper(Trim([Lookup_Input_Subquery_2].[Middlename_2]))  +  ' '  +    Upper(Trim([Lookup_Input_Subquery_2].[Lastname_2])) AS [Cust_Name],
  Isnull([Account_Dim].[Acct_Name], Null) AS [Acct_Name],
  [Lookup_Input_Subquery_2].[Accountid_3] AS [Acct_Id],
  [Lookup_Input_Subquery_2].[Address1_3] AS [Address1],
  [Lookup_Input_Subquery_2].[Address2_3] AS [Address2],
  [Lookup_Input_Subquery_2].[Address3_3] AS [Address3],
  [Lookup_Input_Subquery_2].[City_3] AS [City],
  Case Upper(Trim([Lookup_Input_Subquery_2].[Country_3] ))
When 'Canada' 
Then Null 
When 'Can' 
Then Null 
Else  Upper(Trim([Lookup_Input_Subquery_2].[State_3]))
End [State],
  [Lookup_Input_Subquery_2].[Postalcode_3] AS [Zipcode],
  Case Upper(Trim([Lookup_Input_Subquery_2].[Country_3] ))
When 'Canada'
Then  Upper(Trim([Lookup_Input_Subquery_2].[State_3]))
When 'Can'
Then  Upper(Trim([Lookup_Input_Subquery_2].[State_3]))
Else Null
End [Province],
  Upper(Trim( [Lookup_Input_Subquery_2].[Country_3] )) AS [Country],
  Upper(Trim( [Lookup_Input_Subquery_2].[County_3] )) AS [County],
  [Lookup_Input_Subquery_2].[Createdate_3] AS [Creation_Date],
  [Lookup_Input_Subquery_2].[Modifydate_3] AS [Last_Update_Date],
  [Owb_Cust_Dim].[Get_Const_1_Source] AS [Gkdw_Source],
  [Lookup_Input_Subquery_2].[Title_3] AS [Title],
  [Lookup_Input_Subquery_2].[Workphone_3] AS [Workphone],
  [Lookup_Input_Subquery_2].[Email_3] AS [Email],
  Upper(Trim([Lookup_Input_Subquery_2].[Lastname_2])) AS [Last_Name],
  Upper(Trim([Lookup_Input_Subquery_2].[Firstname_2])) AS [First_Name],
  [Lookup_Input_Subquery_2].[Donotemail_3] AS [Donotemail],
  [Lookup_Input_Subquery_2].[Donotphone_3] AS [Donotphone],
  [Lookup_Input_Subquery_2].[Donotmail_3] AS [Donotmail],
  Isnull([Qg_Contact].[Employee_Id], Null) AS [Employee_Id],
  [Lookup_Input_Subquery_2].[Department_3] AS [Department],
  Isnull([Qg_Contact].[Extension], Null) AS [Extension],
  Isnull([Qg_Contact].[Att_Flag], Null) AS [Att_Flag],
  Isnull([Qg_Contact].[Max_Start_Date], Null) AS [Max_Start_Date],
  Isnull([Qg_Contact].[Title_Code], Null) AS [Title_Code]
From
   ( Select
  [Contact].[Contactid] AS [Contactid_3],
  [Contact].[Contacttype] AS [Contacttype_2],
  [Contact].[Accountid] AS [Accountid_3],
  [Contact].[Account] AS [Account_2],
  [Contact].[Department] AS [Department_3],
  [Contact].[Isprimary] AS [Isprimary_2],
  [Contact].[Lastname] AS [Lastname_2],
  [Contact].[Firstname] AS [Firstname_2],
  [Contact].[Middlename] AS [Middlename_2],
  [Contact].[Workphone] AS [Workphone_3],
  [Contact].[Homephone] AS [Homephone_2],
  [Contact].[Fax] AS [Fax_2],
  [Contact].[Mobile] AS [Mobile_2],
  [Contact].[Email] AS [Email_3],
  [Contact].[Description] AS [Description_2],
  [Contact].[Title] AS [Title_3],
  [Contact].[Seccodeid] AS [Seccodeid_2],
  [Contact].[Accountmanagerid] AS [Accountmanagerid_2],
  [Contact].[Status] AS [Status_2],
  [Contact].[Createdate] AS [Createdate_3],
  [Contact].[Createuser] AS [Createuser_2],
  [Contact].[Modifydate] AS [Modifydate_3],
  [Contact].[Modifyuser] AS [Modifyuser_2],
  [Contact].[Title_Code] AS [Title_Code_3],
  [Contact].[Legacyid] AS [Legacyid_2],
  [Contact].[Delegate] AS [Delegate_2],
  [Contact].[Decision_Maker] AS [Decision_Maker_2],
  [Contact].[Influencer] AS [Influencer_2],
  [Contact].[Booking_Contact] AS [Booking_Contact_2],
  [Contact].[Email_Not_Available] AS [Email_Not_Available_2],
  [Contact].[Email_Not_Available_Reason] AS [Email_Not_Available_Reason_2],
  [Contact].[Campaignid] AS [Campaignid_2],
  [Contact].[Directnumber] AS [Directnumber_2],
  [Contact].[Qg_Territoryid] AS [Qg_Territoryid_2],
  [Owb_Cust_Dim].[Premapping_1_Create_Date_Out] AS [Create_Date_Out_2],
  [Owb_Cust_Dim].[Premapping_2_Modify_Date_Out] AS [Modify_Date_Out_2],
  [Contact].[Addressid] AS [Addressid_2],
  [Contact].[Donotemail] AS [Donotemail_3],
  [Contact].[Donotmail] AS [Donotmail_3],
  [Contact].[Donotphone] AS [Donotphone_3],
  [Account].[Createdate] AS [Createdate_Account_2],
  [Account].[Modifydate] AS [Modifydate_Account_2],
  [Address].[Createdate] AS [Createdate_Address_2],
  [Address].[Modifydate] AS [Modifydate_Address_2],
  [Address].[Address1] AS [Address1_3],
  [Address].[Address2] AS [Address2_3],
  [Address].[City] AS [City_3],
  [Address].[State] AS [State_3],
  [Address].[Postalcode] AS [Postalcode_3],
  [Address].[County] AS [County_3],
  [Address].[Country] AS [Country_3],
  [Address].[Address3] AS [Address3_3]
From
    [Base].[Contact]  [Contact]   
 Left Outer Join  ( Select
  [Address].[Addressid] AS [Addressid],
  [Address].[Createdate] AS [Createdate],
  [Address].[Modifydate] AS [Modifydate],
  [Address].[Address1],
  [Address].[Address2],
  [Address].[City],
  [Address].[State],
  [Address].[Postalcode] AS [Postalcode],
  [Address].[County],
  [Address].[Country],
  [Address].[Address3]
From
  [Base].[Address] AS [Address] ) AS [Address] On ( ( [Contact].[Addressid] = [Address].[Addressid] ) )
 Left Outer Join  ( Select
  [Account].[Accountid] AS [Accountid],
  [Account].[Account] AS [Account],
  [Account].[Createdate] AS [Createdate],
  [Account].[Modifydate] AS [Modifydate]
From
  [Base].[Account] AS [Account] ) AS [Account] On ( ( [Contact].[Accountid] = [Account].[Accountid] ) ) ) AS [Lookup_Input_Subquery_2]   
 Left Outer Join   [Account_Dim]  [Account_Dim] On ( ( [Account_Dim].[Acct_Id] = [Lookup_Input_Subquery_2].[Accountid_3] ) )
 Left Outer Join   [Base].[Qg_Contact]  [Qg_Contact] On ( ( [Qg_Contact].[Contactid] = [Lookup_Input_Subquery_2].[Contactid_3] ) )
  Where 
  ( ( [Lookup_Input_Subquery_2].[Createdate_3] >= [Lookup_Input_Subquery_2].[Create_Date_Out_2] Or [Lookup_Input_Subquery_2].[Modifydate_3] >= [Lookup_Input_Subquery_2].[Modify_Date_Out_2] ) Or ( [Lookup_Input_Subquery_2].[Createdate_Account_2] >= [Lookup_Input_Subquery_2].[Create_Date_Out_2] Or [Lookup_Input_Subquery_2].[Modifydate_Account_2] >= [Lookup_Input_Subquery_2].[Modify_Date_Out_2] ) Or ( [Lookup_Input_Subquery_2].[Createdate_Address_2] >= [Lookup_Input_Subquery_2].[Create_Date_Out_2] Or [Lookup_Input_Subquery_2].[Modifydate_Address_2] >= [Lookup_Input_Subquery_2].[Modify_Date_Out_2] ) )
  )
    Source
On (
  [Cust_Dim].[Cust_Id] = [Source].[Contactid_2]
   )
  
  When Matched Then
    Update
    Set
                  [Cust_Name] = [Source].[Cust_Name],
  [Acct_Name] = [Source].[Acct_Name],
  [Acct_Id] = [Source].[Acct_Id],
  [Address1] = [Source].[Address1],
  [Address2] = [Source].[Address2],
  [Address3] = [Source].[Address3],
  [City] = [Source].[City],
  [State] = [Source].[State],
  [Zipcode] = [Source].[Zipcode],
  [Province] = [Source].[Province],
  [Country] = [Source].[Country],
  [County] = [Source].[County],
  [Creation_Date] = [Source].[Creation_Date],
  [Last_Update_Date] = [Source].[Last_Update_Date],
  [Gkdw_Source] = [Source].[Gkdw_Source],
  [Title] = [Source].[Title],
  [Workphone] = [Source].[Workphone],
  [Email] = [Source].[Email],
  [Last_Name] = [Source].[Last_Name],
  [First_Name] = [Source].[First_Name],
  [Donotemail] = [Source].[Donotemail],
  [Donotphone] = [Source].[Donotphone],
  [Donotmail] = [Source].[Donotmail],
  [Employee_Id] = [Source].[Employee_Id],
  [Department] = [Source].[Department],
  [Extension] = [Source].[Extension],
  [Att_Flag] = [Source].[Att_Flag],
  [Max_Start_Date] = [Source].[Max_Start_Date],
  [Title_Code] = [Source].[Title_Code]
       
  When Not Matched Then
    Insert
      ([Cust_Id],
      [Cust_Name],
      [Acct_Name],
      [Acct_Id],
      [Address1],
      [Address2],
      [Address3],
      [City],
      [State],
      [Zipcode],
      [Province],
      [Country],
      [County],
      [Creation_Date],
      [Last_Update_Date],
      [Gkdw_Source],
      [Title],
      [Workphone],
      [Email],
      [Last_Name],
      [First_Name],
      [Donotemail],
      [Donotphone],
      [Donotmail],
      [Employee_Id],
      [Department],
      [Extension],
      [Att_Flag],
      [Max_Start_Date],
      [Title_Code])
    Values
      ([Source].[Contactid_2],
      [Source].[Cust_Name],
      [Source].[Acct_Name],
      [Source].[Acct_Id],
      [Source].[Address1],
      [Source].[Address2],
      [Source].[Address3],
      [Source].[City],
      [Source].[State],
      [Source].[Zipcode],
      [Source].[Province],
      [Source].[Country],
      [Source].[County],
      [Source].[Creation_Date],
      [Source].[Last_Update_Date],
      [Source].[Gkdw_Source],
      [Source].[Title],
      [Source].[Workphone],
      [Source].[Email],
      [Source].[Last_Name],
      [Source].[First_Name],
      [Source].[Donotemail],
      [Source].[Donotphone],
      [Source].[Donotmail],
      [Source].[Employee_Id],
      [Source].[Department],
      [Source].[Extension],
      [Source].[Att_Flag],
      [Source].[Max_Start_Date],
      [Source].[Title_Code_2])
  ;

