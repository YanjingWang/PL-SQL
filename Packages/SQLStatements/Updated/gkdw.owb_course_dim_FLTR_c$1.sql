Select
  [Evxcourse].[Evxcourseid] AS [Evxcourseid_1],
  Upper(Trim( [Evxcourse].[Coursename] )) AS [Course_Name],
  [Evxcourse].[Coursecode] AS [Coursecode_1],
  Case  [Evxcoursefee].[Currency] 
When 'Usd'
Then 'Usa'
When 'Cad'
Then 'Canada'
Else 'Usa'
End [Country],
  [Evxcoursefee].[Amount] AS [Amount_1],
  [Evxcourse].[Createdate] AS [Createdate_1],
  [Evxcourse].[Modifydate] AS [Modifydate_1],
  [Evxcourse].[Isinactive] AS [Isinactive_1],
  [Evxcourse].[Coursenumber] AS [Coursenumber_1],
  [Evxcourse].[Coursegroup] AS [Coursegroup_1],
  [Qg_Course].[Vendorcode] AS [Vendorcode],
  [Evxcourse].[Shortname] AS [Shortname_1],
  Case
  When Upper(Trim( [Qg_Course].[Uom] )) Like 'Day%'
      Then  [Qg_Course].[Duration] 
  When Upper(Trim( [Qg_Course].[Uom] )) Like 'Hour%'
      Then  ([Qg_Course].[Duration]/8)
  When Upper(Trim( [Qg_Course].[Uom] )) Like 'Week%'
      Then  ([Qg_Course].[Duration]  * 5)
  Else Isnull([Qg_Course].[Duration] , 0)
  End [Duration_In_Days],
  [Evxcourse].[Coursetype] AS [Coursetype_1],
  [Qg_Course].[Capacity] AS [Capacity],
  [Rms_Course].[Course_Desc] AS [Course_Desc],
  [Rms_Course].[Itbt] AS [Itbt],
  [Rms_Course].[Root_Code] AS [Root_Code],
  [Rms_Course].[Line_Of_Business] AS [Line_Of_Business],
  [Rms_Course].[Mcmasters_Eligible] AS [Mcmasters_Eligible],
  [Rms_Course].[Mfg_Course_Code] AS [Mfg_Course_Code]
From
    [Base].[Evxcourse]  [Evxcourse]   
 Join   [Base].[Evxcoursefee]  [Evxcoursefee] On ( ( [Evxcourse].[Evxcourseid] = [Evxcoursefee].[Evxcourseid] ) )
 Left Outer Join   [Base].[Qg_Course]  [Qg_Course] On ( ( ( [Qg_Course].[Evxcourseid] = [Evxcourse].[Evxcourseid] ) ) )
 Left Outer Join   [Rmsdw].[Rms_Course]  [Rms_Course] On ( ( [Rms_Course].[Slx_Course_Id] = [Evxcourse].[Evxcourseid] ) )
  Where 
  ( ( [Evxcourse].[Createdate] >= [Owb_Course_Dim].[Premapping_1_Create_Date_Out] Or [Evxcourse].[Modifydate] >= [Owb_Course_Dim].[Premapping_2_Modify_Date_Out] ) Or ( [Evxcoursefee].[Createdate] >= [Owb_Course_Dim].[Premapping_1_Create_Date_Out] Or [Evxcoursefee].[Modifydate] >= [Owb_Course_Dim].[Premapping_2_Modify_Date_Out] ) ) And
  ( Upper ( Trim ( [Evxcoursefee].[Feetype] ) ) In ( 'Primary' , 'Ons - Base' ) ) And
  ( [Evxcoursefee].[Feeallowuse] = 'T' Or [Evxcourse].[Isinactive] = 'T' ) And
  ( [Evxcoursefee].[Feeavailable] = 'T' Or [Evxcourse].[Isinactive] = 'T' );

