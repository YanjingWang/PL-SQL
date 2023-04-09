


Create Or Alter View Hold.Gk_Acct_Rollup_Summary_V
(
   Fortune_1000,
   Rollup_Acct_Name,
   Acct_Cnt
)
As
     Select   Fortune_1000, Rollup_Acct_Name, Count ( * ) Acct_Cnt
       From   Gkdw.Gk_Acct_Rollup
   Group By   Fortune_1000, Rollup_Acct_Name;



