


Create Or Alter View Hold.Gk_Month_Name_V
(
   Dim_Period_Name,
   Dim_Month,
   Dim_Year
)
As
   Select   Distinct Dim_Period_Name, Dim_Month, Dim_Year From Gkdw.Time_Dim;



