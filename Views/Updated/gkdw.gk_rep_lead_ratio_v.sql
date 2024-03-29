


Create Or Alter View Hold.Gk_Rep_Lead_Ratio_V
(
   Salesrep,
   Zip_Code,
   Region,
   Region_Mgr,
   Lead_Cnt,
   Rep_Lead_Total,
   Lead_Ratio
)
As
     Select   Lt.Salesrep,
              Zip_Code,
              Region,
              Region_Mgr,
              Lead_Cnt,
              Rep_Lead_Total,
              Lead_Cnt / Rep_Lead_Total Lead_Ratio
       From      Gkdw.Gk_Territory_Zip_Mv Z
              Inner Join
                 Gkdw.Gk_Rep_Lead_Total_V Lt
              On Z.Salesrep = Lt.Salesrep
      Where   Z.Terr_Id Between '01' And '99'
   ;



