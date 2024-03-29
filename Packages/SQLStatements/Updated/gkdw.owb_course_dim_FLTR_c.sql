Select
  [Evxcourse].[Evxcourseid] AS [Evxcourseid],
  [Evxcourse].[Coursename] AS [Coursename],
  [Evxcoursefee].[Currency] AS [Currency],
  [Evxcourse].[Coursecode] AS [Coursecode],
  [Evxcoursefee].[Amount] AS [Amount],
  [Evxcourse].[Createdate] AS [Createdate],
  [Evxcourse].[Modifydate] AS [Modifydate],
  [Evxcourse].[Isinactive] AS [Isinactive],
  [Evxcourse].[Coursenumber] AS [Coursenumber],
  [Evxcourse].[Coursegroup] AS [Coursegroup],
  [Qg_Course].[Vendorcode] AS [Vendorcode],
  [Evxcourse].[Shortname] AS [Shortname],
  [Qg_Course].[Duration] AS [Duration],
  [Qg_Course].[Uom] AS [Uom],
  [Evxcourse].[Coursetype] AS [Coursetype],
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

