


Create Or Alter View Hold.Gk_Inst_Hotel_Rate_V
(
   Metroarea,
   Hotel_Days,
   Total_Hotel,
   Avg_Hotel_Day
)
As
     Select   Metroarea,
              Sum (Ed.End_Date - Ed.Start_Date + 1) Hotel_Days,
              Sum(  Isnull(Hotel_Total1, 0)
                  + Isnull(Hotel_Total2, 0)
                  + Isnull(Hotel_Total3, 0))
                 Total_Hotel,
              Round(Sum(  Isnull(Hotel_Total1, 0)
                        + Isnull(Hotel_Total2, 0)
                        + Isnull(Hotel_Total3, 0))
                    / Sum (Ed.End_Date - Ed.Start_Date + 1))
                 Avg_Hotel_Day
       From      Inst_Travel@Gkprod T
              Inner Join
                 Gkdw.Event_Dim Ed
              On T.Evxeventid = Ed.Event_Id
      Where     Isnull(Hotel_Total1, 0)
              + Isnull(Hotel_Total2, 0)
              + Isnull(Hotel_Total3, 0) > 0
              And Create_Date >= Cast(Getutcdate() As Date) - 365
   Group By   Metroarea;



