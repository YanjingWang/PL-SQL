Merge
Into
  [Market_Dim]
Using
  (Select
  [Market_Dim].[Zipcode] AS [Zipcode],
  [Market_Dim].[Country],
  [Gk_Territory].[Territory_Id] AS [Territory],
  [Gk_Territory].[Region],
  [Gk_Territory].[Salesrep] AS [Sales_Rep],
  [Gk_Territory].[Region_Mgr],
  [Market_Dim].[State],
  [Market_Dim].[City],
  [Gk_Territory].[Userid] AS [Sales_Rep_Id]
From
  [Market_Dim] AS [Market_Dim],
[Gk_Territory] AS [Gk_Territory]
  Where 
  ( [Gk_Territory].[Territory_Type] = 'Ob' ) And
  ( [Market_Dim].[Zipcode] Between [Gk_Territory].[Zip_Start] And [Gk_Territory].[Zip_End] )
  )
    Source
On (
  [Market_Dim].[Zipcode] = [Source].[Zipcode]
   )
  
  When Matched Then
    Update
    Set
                  [Country] = [Source].[Country],
  [Territory] = [Source].[Territory],
  [Region] = [Source].[Region],
  [Sales_Rep] = [Source].[Sales_Rep],
  [Region_Mgr] = [Source].[Region_Mgr],
  [State] = [Source].[State],
  [City] = [Source].[City],
  [Sales_Rep_Id] = [Source].[Sales_Rep_Id]
       
  ;

