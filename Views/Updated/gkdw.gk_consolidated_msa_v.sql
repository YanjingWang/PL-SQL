


Create Or Alter View Hold.Gk_Consolidated_Msa_V
(
   Msa_Name,
   Msa_Desc,
   Consolidated_Msa
)
As
   Select   Distinct Msa_Name, Msa_Desc, Consolidated_Msa
     From   Gkdw.Gk_Msa_Zips
    Where   Consolidated_Msa Is Not Null;



