Merge
Into
  [Account_Dim]
Using
  (Select
  [Account].[Accountid] AS [Accountid_3],
  Upper(Trim( [Account].[Account] )) AS [Acct_Name],
  [Address].[Address1],
  [Address].[Address2],
  [Address].[Address3],
  [Address].[City],
  Case Upper(Trim([Address].[Country]))
When 'Canada' 
Then Null 
When 'Can' 
Then Null 
Else [Address].[State]  
End [State],
  [Address].[Postalcode] AS [Zipcode],
  Case Upper(Trim([Address].[Country] ))  When 'Canada'  Then   [Address].[State]   When 'Can'  Then [Address].[State]   Else Null  End [Province],
  Upper( Trim( [Address].[Country] ) ) AS [Country],
  Upper(Trim( [Address].[County]  )) AS [County],
  [Account].[Createdate] AS [Creation_Date],
  [Account].[Modifydate] AS [Last_Update_Date],
  [Owb_Account_Dim_New_Sb].[Get_Const_1_Source] AS [Gkdw_Source],
  [Account].[Industry] AS [Sic_Code],
  [Get_Natl_Terr_Id]([Account].[Accountid]) AS [National_Terr_Id]
From
    [Base].[Account]  [Account]   
 Left Outer Join   [Base].[Address]  [Address] On ( ( ( [Address].[Addressid] = [Account].[Addressid] ) ) )
  Where 
  ( Accountid='Agksq1099520' )
  )
    Source
On (
  [Account_Dim].[Acct_Id] = [Source].[Accountid_3]
   )
  
  When Matched Then
    Update
    Set
                  [Acct_Name] = [Source].[Acct_Name],
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
  [Sic_Code] = [Source].[Sic_Code],
  [National_Terr_Id] = [Source].[National_Terr_Id]
       
  When Not Matched Then
    Insert
      ([Acct_Id],
      [Acct_Name],
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
      [Sic_Code],
      [National_Terr_Id])
    Values
      ([Source].[Accountid_3],
      [Source].[Acct_Name],
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
      [Source].[Sic_Code],
      [Source].[Accountid_4])
  ;

