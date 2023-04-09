Select
  [Lookup_Input_Subquery].[Contactid] AS [Contactid],
  [Lookup_Input_Subquery].[Firstname] AS [Firstname],
  [Lookup_Input_Subquery].[Lastname] AS [Lastname],
  [Lookup_Input_Subquery].[Middlename] AS [Middlename],
  [Lookup_Input_Subquery].[County] AS [County],
  Isnull([Account_Dim].[Acct_Name], Null) AS [Acct_Name],
  [Lookup_Input_Subquery].[Accountid] AS [Accountid],
  [Lookup_Input_Subquery].[Address1] AS [Address1],
  [Lookup_Input_Subquery].[Address2] AS [Address2],
  [Lookup_Input_Subquery].[Address3] AS [Address3],
  [Lookup_Input_Subquery].[City] AS [City],
  [Lookup_Input_Subquery].[State] AS [State],
  [Lookup_Input_Subquery].[Country] AS [Country],
  [Lookup_Input_Subquery].[Postalcode] AS [Postalcode],
  [Lookup_Input_Subquery].[Createdate] AS [Createdate],
  [Lookup_Input_Subquery].[Modifydate] AS [Modifydate],
  [Lookup_Input_Subquery].[Title] AS [Title],
  [Lookup_Input_Subquery].[Workphone] AS [Workphone],
  [Lookup_Input_Subquery].[Email] AS [Email],
  [Lookup_Input_Subquery].[Donotemail] AS [Donotemail],
  [Lookup_Input_Subquery].[Donotphone] AS [Donotphone],
  [Lookup_Input_Subquery].[Donotmail] AS [Donotmail],
  Isnull([Qg_Contact].[Id_Number], Null) AS [Id_Number],
  [Lookup_Input_Subquery].[Department] AS [Department],
  Isnull([Qg_Contact].[Extension], Null) AS [Extension],
  Isnull([Qg_Contact].[Att_Flag], Null) AS [Att_Flag],
  Isnull([Qg_Contact].[Max_Startdate], Null) AS [Max_Startdate],
  Isnull([Qg_Contact].[Title_Code], Null) AS [Title_Code]
From
   ( Select
  [Contact].[Contactid] AS [Contactid],
  [Contact].[Contacttype] AS [Contacttype],
  [Contact].[Accountid] AS [Accountid],
  [Contact].[Account] AS [Account],
  [Contact].[Department] AS [Department],
  [Contact].[Isprimary] AS [Isprimary],
  [Contact].[Lastname] AS [Lastname],
  [Contact].[Firstname] AS [Firstname],
  [Contact].[Middlename] AS [Middlename],
  [Contact].[Workphone] AS [Workphone],
  [Contact].[Homephone] AS [Homephone],
  [Contact].[Fax] AS [Fax],
  [Contact].[Mobile] AS [Mobile],
  [Contact].[Email] AS [Email],
  [Contact].[Description] AS [Description],
  [Contact].[Title] AS [Title],
  [Contact].[Seccodeid] AS [Seccodeid],
  [Contact].[Accountmanagerid] AS [Accountmanagerid],
  [Contact].[Status] AS [Status],
  [Contact].[Createdate] AS [Createdate],
  [Contact].[Createuser] AS [Createuser],
  [Contact].[Modifydate] AS [Modifydate],
  [Contact].[Modifyuser] AS [Modifyuser],
  [Contact].[Title_Code] AS [Title_Code],
  [Contact].[Legacyid] AS [Legacyid],
  [Contact].[Delegate] AS [Delegate],
  [Contact].[Decision_Maker] AS [Decision_Maker],
  [Contact].[Influencer] AS [Influencer],
  [Contact].[Booking_Contact] AS [Booking_Contact],
  [Contact].[Email_Not_Available] AS [Email_Not_Available],
  [Contact].[Email_Not_Available_Reason] AS [Email_Not_Available_Reason],
  [Contact].[Campaignid] AS [Campaignid],
  [Contact].[Directnumber] AS [Directnumber],
  [Contact].[Qg_Territoryid] AS [Qg_Territoryid],
  [Owb_Cust_Dim_Sb].[Premapping_1_Create_Date_Out] AS [Create_Date_Out],
  [Owb_Cust_Dim_Sb].[Premapping_2_Modify_Date_Out] AS [Modify_Date_Out],
  [Contact].[Addressid] AS [Addressid],
  [Contact].[Donotemail] AS [Donotemail],
  [Contact].[Donotmail] AS [Donotmail],
  [Contact].[Donotphone] AS [Donotphone],
  [Account].[Createdate] AS [Createdate_Account],
  [Account].[Modifydate] AS [Modifydate_Account],
  [Address].[Createdate] AS [Createdate_Address],
  [Address].[Modifydate] AS [Modifydate_Address],
  [Address].[Address1] AS [Address1],
  [Address].[Address2] AS [Address2],
  [Address].[City] AS [City],
  [Address].[State] AS [State],
  [Address].[Postalcode] AS [Postalcode],
  [Address].[County] AS [County],
  [Address].[Country] AS [Country],
  [Address].[Address3] AS [Address3]
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
  [Base].[Account] AS [Account] ) AS [Account] On ( ( [Contact].[Accountid] = [Account].[Accountid] ) ) ) AS [Lookup_Input_Subquery]   
 Left Outer Join   [Account_Dim]  [Account_Dim] On ( ( [Account_Dim].[Acct_Id] = [Lookup_Input_Subquery].[Accountid] ) )
 Left Outer Join   [Base].[Qg_Contact]  [Qg_Contact] On ( ( [Qg_Contact].[Contactid] = [Lookup_Input_Subquery].[Contactid] ) )
  Where 
  ( ( [Lookup_Input_Subquery].[Createdate] >= '7-Jul-2020' Or [Lookup_Input_Subquery].[Modifydate] >= '7-Jul-2020' ) 
  Or ( [Lookup_Input_Subquery].[Createdate_Account] >= '7-Jul-2020' Or [Lookup_Input_Subquery].[Modifydate_Account] >= '7-Jul-2020' )
   Or ( [Lookup_Input_Subquery].[Createdate_Address] >= '7-Jul-2020' Or [Lookup_Input_Subquery].[Modifydate_Address] >= '7-Jul-2020' ) );

