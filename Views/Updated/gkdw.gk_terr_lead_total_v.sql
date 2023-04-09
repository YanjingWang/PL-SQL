


Create Or Alter View Hold.Gk_Terr_Lead_Total_V
(
   Terr_Id,
   Terr_Lead_Total
)
As
     Select   Terr_Id, Sum (Lead_Cnt) Terr_Lead_Total
       From   Gkdw.Gk_Territory_Zip_Mv
   Group By   Terr_Id;



