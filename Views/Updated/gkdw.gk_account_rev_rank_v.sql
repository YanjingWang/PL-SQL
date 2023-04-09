


Create Or Alter View Hold.Gk_Account_Rev_Rank_V
(
   Acct_Name,
   Rev_Amt,
   Rev_Rank
)
As
     Select   Acct_Name,
              Sum (Rev_Amt) Rev_Amt,
              Rank () Over (Order By Sum (Rev_Amt) Desc) Rev_Rank
       From   Gkdw.Gk_Account_Revenue_Mv
      Where   Dim_Year Between 2006 And 2010
   Group By   Acct_Name;



