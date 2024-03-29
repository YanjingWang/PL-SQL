


Create Or Alter View Hold.Gk_Account_Revenue_V
(
   Rev_Rank,
   Acct_Name,
   Rev_Amt
)
As
     Select   Rank () Over (Order By Sum (Rev_Amt) Desc) Rev_Rank,
              Acct_Name,
              Sum (Rev_Amt) Rev_Amt
       From   (  Select   Isnull(R.Rollup_Acct_Name, C.Acct_Name) Acct_Name,
                          Sum(Case
                                 When F.Attendee_Type = 'Unlimited'
                                      And Book_Amt = 0
                                 Then
                                    U.Book_Amt
                                 Else
                                    F.Book_Amt
                              End)
                             Rev_Amt
                   From                  Gkdw.Order_Fact F
                                      Inner Join
                                         Gkdw.Event_Dim Ed
                                      On F.Event_Id = Ed.Event_Id
                                   Inner Join
                                      Gkdw.Cust_Dim C
                                   On F.Cust_Id = C.Cust_Id
                                Inner Join
                                   Gkdw.Time_Dim Td
                                On Ed.Start_Date = Td.Dim_Date
                             Left Outer Join
                                Gkdw.Gk_Unlimited_Avg_Book_V U
                             On F.Cust_Id = U.Cust_Id
                          Left Outer Join
                             Gkdw.Gk_Acct_Rollup R
                          On C.Acct_Id = R.Acct_Id
                  Where       Td.Dim_Year >= 2006
                          And F.Enroll_Status != 'Cancelled'
                          And C.Acct_Name Is Not Null
               Group By   Isnull(R.Rollup_Acct_Name, C.Acct_Name)
               Union
                 Select   Isnull(R.Rollup_Acct_Name, C.Acct_Name) Acct_Name,
                          Sum (F.Book_Amt) Rev_Amt
                   From            Gkdw.Sales_Order_Fact F
                                Inner Join
                                   Gkdw.Cust_Dim C
                                On F.Cust_Id = C.Cust_Id
                             Inner Join
                                Gkdw.Time_Dim Td
                             On F.Book_Date = Td.Dim_Date
                          Left Outer Join
                             Gkdw.Gk_Acct_Rollup R
                          On C.Acct_Id = R.Acct_Id
                  Where       Td.Dim_Year >= 2006
                          And F.Record_Type = 'Salesorder'
                          And F.So_Status != 'Cancelled'
                          And Acct_Name Is Not Null
               Group By   Isnull(R.Rollup_Acct_Name, C.Acct_Name)) a1
   Group By   Acct_Name
   ;



