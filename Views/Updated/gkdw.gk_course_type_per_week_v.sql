


Create Or Alter View Hold.Gk_Course_Type_Per_Week_V
(
   Country,
   Course_Type,
   Max_Per_Week
)
As
     Select   F.Country,
              Cd.Course_Type,
              Ceil (Sum (Year_Dist) / 50) Max_Per_Week
       From      Gkdw.Gk_Auto_Sched_Freq_V F
              Left Outer Join
                 Gkdw.Course_Dim Cd
              On F.Course_Code = Cd.Course_Code And F.Country = Cd.Country
   Group By   F.Country, Cd.Course_Type;



