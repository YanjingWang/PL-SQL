


Create Or Alter View Hold.Gk_Ibm_Course_Master_V
(
   Ibm_Ww_Course_Code,
   Ibm_Title,
   Ibm_Brand,
   Pdm_Flag
)
As
   Select   Ibm_Ww_Course_Code,
            Ibm_Title,
            Ibm_Brand,
            'Y' Pdm_Flag
     From   Gkdw.Gk_Ibm_Course_Master M
    Where   Exists (Select   1
                      From   Gkdw.Course_Dim Cd
                     Where   M.Ibm_Ww_Course_Code = Cd.Mfg_Course_Code)
   Union
   Select   Ibm_Ww_Course_Code,
            Ibm_Title,
            Ibm_Brand,
            'N' Pdm_Flag
     From   Gkdw.Gk_Ibm_Course_Master M
    Where   Not Exists (Select   1
                          From   Gkdw.Course_Dim Cd
                         Where   M.Ibm_Ww_Course_Code = Cd.Mfg_Course_Code)
   ;



