Merge
Into
  [Sales_Order_Fact]
Using
  (Select
  [Sales_Order_Fact].[Sales_Order_Id] AS [Sales_Order_Id_2],
  [Oracletx_History].[Createdate] AS [Bill_Date]
From
    [Sales_Order_Fact]  [Sales_Order_Fact]   
 Left Outer Join   [Base].[Oracletx_History]  [Oracletx_History] On ( ( ( [Oracletx_History].[Evxeventid] = [Sales_Order_Fact].[Sales_Order_Id] ) ) And ( ( [Oracletx_History].[Transactiontype] = [Owb_Sales_Order_Fact_Oratx_Upd].[Get_Const_0_Transactiontype] ) ) )
  Where 
  ( [Sales_Order_Fact].[Gkdw_Source] = 'Slxdw' ) And
  ( [Sales_Order_Fact].[Bill_Date] Is Null )
  )
    Source
On (
  [Sales_Order_Fact].[Sales_Order_Id] = [Source].[Sales_Order_Id_2]
   )
  
  When Matched Then
    Update
    Set
                  [Bill_Date] = [Source].[Bill_Date]
       
  ;

