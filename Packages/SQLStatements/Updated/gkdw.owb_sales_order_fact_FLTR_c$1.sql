Select
  [Evxso].[Evxsoid] AS [Evxsoid_1],
  [Product_Dim].[Prod_Num] AS [Prod_Num],
  [Evxso].[Shiptoaddress1] AS [Shiptoaddress1_1],
  [Evxso].[Shiptoaddress2] AS [Shiptoaddress2_1],
  [Evxso].[Shiptoaddress3] AS [Shiptoaddress3_1],
  [Evxso].[Shiptocity] AS [Shiptocity_1],
  Case Upper(Trim( [Evxso].[Shiptocountry]  )) When 'Canada'  Then Null  When 'Can'  Then Null  Else   [Evxso].[Shiptostate]  End [Ship_To_State],
  Case Upper(Trim( [Evxso].[Shiptocountry]   )) When 'Canada'  Then  [Evxso].[Shiptostate]   When 'Can'  Then  [Evxso].[Shiptostate]   Else  Null End [Ship_To_Province],
  [Evxso].[Shiptocountry] AS [Shiptocountry_1],
  [Evxso].[Shiptocounty] AS [Shiptocounty_1],
  [Evxso].[Shiptopostal] AS [Shiptopostal_1],
  [Evxso].[Billtoaddress1] AS [Billtoaddress1_1],
  [Evxso].[Billtoaddress2] AS [Billtoaddress2_1],
  [Evxso].[Billtoaddress3] AS [Billtoaddress3_1],
  [Evxso].[Billtocity] AS [Billtocity_1],
  Case Upper(Trim( [Evxso].[Billtocountry]  )) 
When 'Canada'  
Then Null  
When 'Can'  
Then Null  
Else  [Evxso].[Billtostate]  
End [Bill_To_State],
  Case Upper(Trim( [Evxso].[Billtocountry]  )) 
When 'Canada'  
Then [Evxso].[Billtostate]    
When 'Can'  
Then [Evxso].[Billtostate]    
Else  Null
End [Bill_To_Province],
  [Evxso].[Billtocountry] AS [Billtocountry_1],
  [Evxso].[Billtocounty] AS [Billtocounty_1],
  [Evxso].[Billtopostal] AS [Billtopostal_1],
  Case [Evxso].[Sostatus] 
When 'Cancelled'
Then [Evxso].[Modifydate] 
Else Null
End [Cancel_Date],
  [Evxso].[Shippeddate] AS [Shippeddate_1],
  [Evxso].[Createdate] AS [Createdate_1],
  [Evxso].[Modifydate] AS [Modifydate_1],
  Case  Trim([Evxso].[Recordtypecode] ) When '1' 
Then Upper(Trim([Evxso].[Shiptocountry]))
When '2' Then Upper(Trim([Evxso].[Billtocountry]))   
End [Country],
  [Market_Dim].[Territory] AS [Territory],
  [Market_Dim].[Region] AS [Region],
  [Market_Dim].[Sales_Rep] AS [Sales_Rep],
  [Market_Dim].[Region_Mgr] AS [Region_Mgr],
  Case  [Evxso].[Recordtypecode]  
When '1' 
Then  Trunc([Evxso].[Shippeddate]) 
Else Trunc( [Evxso].[Createdate] ) 
End [Book_Date],
  Case  [Evxso].[Recordtypecode]  
When '1' 
Then  Trunc([Evxso].[Shippeddate]) 
Else Null 
End [Rev_Date],
  [Evxsodetail].[Actualquantityordered] AS [Actualquantityordered],
  [Evxso].[Totalnotax] AS [Totalnotax_1],
  [Evxso].[Currencytype] AS [Currencytype_1],
  [Evxsodetail].[Soldbyuser] AS [Soldbyuser],
  [Evxso].[Opportunityid] AS [Opportunityid_1],
  Case  Trim([Evxso].[Recordtypecode] ) When '1' 
Then  [Evxso].[Shiptocontactid]  
When '2' Then  [Evxso].[Billtocontactid]  
End [Cust_Id],
  [Evxsodetail].[Productid] AS [Productid],
  [Oracletx_History].[Createdate] AS [Createdate],
  [Evxso].[Recordtype] AS [Recordtype_1],
  [Evxso].[Recordtypecode] AS [Recordtypecode_1],
  [Evxso].[Sostatus] AS [Sostatus_1],
  [Evxppcard].[Evxppcardid] AS [Evxppcardid],
  Case Upper(Trim(  [Evxso].[Orderedbycountry]   )) 
When 'Canada'  
Then Null  
When 'Can'  
Then Null  
Else    [Evxso].[Orderedbystate] 
End [Ordered_By_State],
  Case Upper(Trim([Evxso].[Orderedbycountry] )) 
When 'Canada'  
Then   [Evxso].[Orderedbystate]  
When 'Can'  
Then   [Evxso].[Orderedbystate]  
Else  Null 
End [Ordered_By_Province],
  [Evxso].[Orderedbypostal] AS [Orderedbypostal_1],
  [Evxso].[Orderedbycountry] AS [Orderedbycountry_1],
  [Evxso].[Orderedbycontactid] AS [Orderedbycontactid_1],
  Case Upper(Trim([Cust_Dim].[Country] )) 
When 'Usa'  
Then  Substr( [Cust_Dim].[Zipcode],1, 5)  
Else  [Cust_Dim].[Zipcode]  
End [Zip_Code],
  [Evxbillpayment].[Method] AS [Method],
  [Evxso].[Purchaseorder] AS [Purchaseorder_1],
  [Evxso].[Source] AS [Source_1],
  [Evxso].[Channel] AS [Channel_1]
From
    [Base].[Evxso]  [Evxso]   
 Left Outer Join   [Base].[Evxsodetail]  [Evxsodetail] On ( ( [Evxsodetail].[Evxsoid] = [Evxso].[Evxsoid] ) )
 Left Outer Join   [Product_Dim]  [Product_Dim] On ( ( [Product_Dim].[Product_Id] = [Evxsodetail].[Productid] ) )
 Left Outer Join   [Cust_Dim]  [Cust_Dim] On ( ( [Cust_Dim].[Cust_Id] = (Case  Trim([Evxso].[Recordtypecode] ) When '1' 
Then  [Evxso].[Shiptocontactid]  
When '2' Then  [Evxso].[Billtocontactid]  
End) ) )
 Left Outer Join   [Market_Dim]  [Market_Dim] On ( ( [Market_Dim].[Zipcode] = (Case Upper(Trim([Cust_Dim].[Country] )) 
When 'Usa'  
Then  Substr( [Cust_Dim].[Zipcode],1, 5)  
Else  [Cust_Dim].[Zipcode]  
End) ) )
 Left Outer Join   [Base].[Oracletx_History]  [Oracletx_History] On ( ( ( [Oracletx_History].[Transactiontype] = [Owb_Sales_Order_Fact].[Get_Const_2_Transaction_Type] ) ) And ( ( [Oracletx_History].[Evxeventid] = [Evxso].[Evxsoid] ) ) )
 Left Outer Join   [Base].[Evxppcard]  [Evxppcard] On ( ( [Evxppcard].[Evxsoid] = [Evxso].[Evxsoid] ) )
 Left Outer Join   [Base].[Evxbillpayment]  [Evxbillpayment] On ( ( [Evxbillpayment].[Evxsoid] = [Evxso].[Evxsoid] ) )
  Where 
  ( [Evxso].[Createdate] >= [Owb_Sales_Order_Fact].[Premapping_1_Create_Date_Out] Or [Evxso].[Modifydate] >= [Owb_Sales_Order_Fact].[Premapping_2_Modify_Date_Out] );

