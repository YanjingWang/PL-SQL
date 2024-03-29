


Create Or Alter View Hold.Gk_Course_Per_Week_V
(
   Country,
   Course_Code,
   Max_Course_Per_Week,
   Max_Pl_Per_Week,
   Max_Type_Per_Week
)
As
     Select   F.Country,
              F.Course_Code,
              Ceil (Sum (Year_Dist) / 50) Max_Course_Per_Week,
              Isnull(Cp.Max_Per_Week, 0) Max_Pl_Per_Week,
              Isnull(Ct.Max_Per_Week, 0) Max_Type_Per_Week
       From            Gkdw.Gk_Auto_Sched_Freq_V F
                    Left Outer Join
                       Gkdw.Course_Dim Cd
                    On     F.Course_Code = Cd.Course_Code
                       And F.Country = Cd.Country
                       And Cd.Gkdw_Source = 'Slxdw'
                 Left Outer Join
                    Gkdw.Gk_Course_Pl_Per_Week_V Cp
                 On Cd.Country = Cp.Country And Cd.Course_Pl = Cp.Course_Pl
              Left Outer Join
                 Gkdw.Gk_Course_Type_Per_Week_V Ct
              On Cd.Country = Ct.Country And Cd.Course_Type = Ct.Course_Type
   Group By   F.Country,
              F.Course_Code,
              Isnull(Cp.Max_Per_Week, 0),
              Isnull(Ct.Max_Per_Week, 0);



