


Create Or Alter View Hold.Gk_Customer_Revenue_V
(
   Group_Acct_Name,
   Rev_Rank,
   Total_Revenue
)
As
     Select   Upper (Isnull(N.Group_Acct_Name, Ad.Acct_Name)) Group_Acct_Name,
              Rank () Over (Order By Sum (Isnull(F.Book_Amt, 0)) Desc) Rev_Rank,
              Sum (Isnull(F.Book_Amt, 0)) Total_Revenue
       From                  Gkdw.Cust_Dim Cd
                          Inner Join
                             Gkdw.Account_Dim Ad
                          On Cd.Acct_Id = Ad.Acct_Id
                       Inner Join
                          Gkdw.Order_Fact F
                       On Cd.Cust_Id = F.Cust_Id
                    Inner Join
                       Gkdw.Event_Dim Ed
                    On F.Event_Id = Ed.Event_Id
                 Inner Join
                    Gkdw.Time_Dim Td
                 On F.Book_Date = Td.Dim_Date
              Left Outer Join
                 Gkdw.Gk_Account_Groups_Naics N
              On Ad.Acct_Id = N.Acct_Id
      Where   Td.Dim_Year >= 2007
   Group By   Upper (Isnull(N.Group_Acct_Name, Ad.Acct_Name))
     Having   Sum (Isnull(F.Book_Amt, 0)) > 0
   ;



