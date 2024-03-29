


Create Or Alter View Hold.Gk_Terr_Lead_Ratio_V
(
   Terr_Id,
   Salesrep,
   Zip_Code,
   Region,
   Region_Mgr,
   Lead_Cnt,
   Terr_Lead_Total,
   Lead_Ratio
)
As
     Select   Z.Terr_Id,
              Salesrep,
              Zip_Code,
              Region,
              Region_Mgr,
              Lead_Cnt,
              Terr_Lead_Total,
              Lead_Cnt / Terr_Lead_Total Lead_Ratio
       From      Gkdw.Gk_Territory_Zip_Mv Z
              Inner Join
                 Gkdw.Gk_Terr_Lead_Total_V Lt
              On Z.Terr_Id = Lt.Terr_Id
      Where   Z.Terr_Id Between '01' And '99'
   ;



