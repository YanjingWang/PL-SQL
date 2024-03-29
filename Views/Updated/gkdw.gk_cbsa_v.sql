


Create Or Alter View Hold.Gk_Cbsa_V
(
   Zipcode,
   Csa_Code,
   Csa_Name,
   Cbsa_Code,
   Cbsa_Name,
   Cbsa_Type,
   Div_Code,
   Div_Name,
   County_Fips,
   Cbsa_Name_Rpt,
   Territory_Id,
   Salesrep,
   Region
)
As
   Select   Distinct
            C.*,
            Case
               When O.Area_Name Is Null Then C.Cbsa_Name
               Else O.Area_Name
            End
               Cbsa_Name_Rpt,
            T.Territory_Id,
            Salesrep,
            Region
     From         Gkdw.Gk_Cbsa C
               Left Outer Join
                  Gkdw.Gk_Occ_Mv O
               On C.Cbsa_Code = O.Area_Number
            Left Outer Join
               Gkdw.Gk_Territory T
            On C.Zipcode Between T.Zip_Start And T.Zip_End
               And Territory_Type = 'Ob';



