


Create Or Alter View Hold.Gk_Course_Metro_Per_Week_V
(
   Country,
   Metro,
   Max_Per_Week
)
As
     Select   F.Country, F.Metro, Ceil (Sum (Year_Dist) / 50) Max_Per_Week
       From   Gkdw.Gk_Auto_Sched_Freq_V F
   Group By   F.Country, F.Metro;



