


Create Or Alter View Hold.Gk_Inst_Rental_Rate_V
(
   Metroarea,
   Total_Rental_Rays,
   Total_Rental,
   Avg_Rental
)
As
     Select   Metroarea,
              Sum (Ed.End_Date - Ed.Start_Date + 1) Total_Rental_Rays,
              Sum (Isnull(Rental_Total1, 0) + Isnull(Rental_Total2, 0))
                 Total_Rental,
              Round(Sum (Isnull(Rental_Total1, 0) + Isnull(Rental_Total2, 0))
                    / Sum (Ed.End_Date - Ed.Start_Date + 1))
                 Avg_Rental
       From      Inst_Travel@Gkprod T
              Inner Join
                 Gkdw.Event_Dim Ed
              On T.Evxeventid = Ed.Event_Id
      Where   Isnull(Rental_Total1, 0) + Isnull(Rental_Total2, 0) > 0
              And Create_Date >= Cast(Getutcdate() As Date) - 365
   Group By   Metroarea;



