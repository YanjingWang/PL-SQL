Merge

Into
  [Instructor_Dim]
Using
  (Select
  [Dedup_Input_Subquery2_2].[Contactid_3] AS [Contactid_2],
  Upper(Trim([Contact].[Firstname]))  + ' ' + 
  Upper(Trim([Contact].[Middlename]))  +  ' '  + 
  Upper(Trim([Contact].[Lastname])) AS [Cust_Name],
  Upper(Trim([Account].[Account])) AS [Acct_Name],
  [Contact].[Accountid] AS [Acct_Id],
  [Address].[Address1],
  [Address].[Address2],
  [Address].[Address3],
  [Address].[City],
  Case Upper(Trim([Address].[Country] )) When 'Canada' Then Null When 'Can' Then Null Else  [Address].[State]  End [State],
  [Address].[Postalcode] AS [Zipcode],
  Case Upper(Trim([Address].[Country] ))
When 'Canada'
Then  [Address].[State]  
When 'Can'
Then  [Address].[State] 
Else Null
End [Province],
  [Address].[Country],
  [Address].[County],
  [Owb_Instructor_Dim].[Get_Const_1_Source_Name] AS [Gkdw_Source]
From
   ( Select
Distinct
  [Qg_Eventinstructors].[Contactid] AS [Contactid_3]
From
  [Base].[Qg_Eventinstructors] AS [Qg_Eventinstructors] ) AS [Dedup_Input_Subquery2_2]   
 Left Outer Join   [Base].[Contact]  [Contact] On ( ( [Contact].[Contactid] = [Dedup_Input_Subquery2_2].[Contactid_3] ) )
 Left Outer Join   [Base].[Account]  [Account] On ( ( [Account].[Accountid] = [Contact].[Accountid] ) )
 Left Outer Join   [Base].[Address]  [Address] On ( ( [Address].[Addressid] = [Contact].[Addressid] ) )
  )
    Source
On (
  [Instructor_Dim].[Cust_Id] = [Source].[Contactid_2]
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
  [Gkdw_Source] = [Source].[Gkdw_Source]
       
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
      [Gkdw_Source])
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
      [Source].[Source_Name])
  ;

