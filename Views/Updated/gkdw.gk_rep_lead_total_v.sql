


Create Or Alter View Hold.Gk_Rep_Lead_Total_V
(
   Salesrep,
   Rep_Lead_Total
)
As
     Select   Salesrep, Sum (Lead_Cnt) Rep_Lead_Total
       From   Gkdw.Gk_Territory_Zip_Mv
   Group By   Salesrep;



