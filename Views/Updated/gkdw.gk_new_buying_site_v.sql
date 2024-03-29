


Create Or Alter View Hold.Gk_New_Buying_Site_V
(
   Acct_Id,
   Init_Enroll_Date
)
As
     Select   Acct_Id, Min (Min_Book_Date) Init_Enroll_Date
       From   (  Select   Cd.Acct_Id, Min (Book_Date) Min_Book_Date
                   From      Gkdw.Order_Fact F
                          Inner Join
                             Gkdw.Cust_Dim Cd
                          On F.Cust_Id = Cd.Cust_Id
               -- Where Book_Date >= To_Date('1/1/2008','Mm/Dd/Yyyy')
               Group By   Cd.Acct_Id
               Union
                 Select   Cd.Acct_Id, Min (Book_Date)
                   From      Gkdw.Sales_Order_Fact Sf
                          Inner Join
                             Gkdw.Cust_Dim Cd
                          On Sf.Cust_Id = Cd.Cust_Id
               -- Where Book_Date >= To_Date('1/1/2008','Mm/Dd/Yyyy')
               Group By   Cd.Acct_Id) a1
   Group By   Acct_Id;



