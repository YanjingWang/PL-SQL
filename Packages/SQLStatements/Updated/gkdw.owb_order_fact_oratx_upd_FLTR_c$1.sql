Select
  [Order_Fact].[Txfee_Id] AS [Txfee_Id_1],
  [Oracletx_History].[Orderstatus] AS [Orderstatus]
From
    [Order_Fact]  [Order_Fact]   
 Left Outer Join   [Base].[Evxev_Txfee]  [Evxev_Txfee] On ( ( [Evxev_Txfee].[Evxev_Txfeeid] = [Order_Fact].[Txfee_Id] ) )
 Left Outer Join   [Base].[Oracletx_History]  [Oracletx_History] On ( ( ( Isnull(Oracletx_History.[Transactiontype], ' ') <> [Owb_Order_Fact_Oratx_Upd].[Get_Const_0_Transactiontype] ) ) And ( ( [Oracletx_History].[Evxbillingid] = [Evxev_Txfee].[Evxbillingid] ) ) )
  Where 
  ( [Order_Fact].[Gkdw_Source] = 'Slxdw' ) And
  ( [Order_Fact].[Bill_Status] Is Null );

