


Create Or Alter View Hold.Gk_New_Buyer_V (Cust_Id, Init_Enroll_Date)
As
     Select   Cust_Id, Min (Min_Book_Date) Init_Enroll_Date
       From   (  Select   F.Cust_Id, Min (Book_Date) Min_Book_Date
                   From   Gkdw.Order_Fact F
               -- Where Book_Date >= To_Date('1/1/2008','Mm/Dd/Yyyy')
               Group By   F.Cust_Id
               Union
                 Select   Sf.Cust_Id, Min (Book_Date)
                   From   Gkdw.Sales_Order_Fact Sf
               -- Where Book_Date >= To_Date('1/1/2008','Mm/Dd/Yyyy')
               Group By   Sf.Cust_Id) a1
   Group By   Cust_Id;



