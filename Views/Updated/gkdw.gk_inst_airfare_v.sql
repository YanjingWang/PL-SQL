


Create Or Alter View Hold.Gk_Inst_Airfare_V
(
   Metroarea,
   Event_Cnt,
   Total_Airfare,
   Avg_Airfare
)
As
     Select   Metroarea,
              Count ( * ) Event_Cnt,
              Sum(  Isnull(Air_Cost1, 0)
                  + Isnull(Air_Cost2, 0)
                  + Isnull(Air_Cost3, 0)
                  + Isnull(Air_Cost4, 0)
                  + Isnull(Air_Cost5, 0))
                 Total_Airfare,
              Round(Sum(  Isnull(Air_Cost1, 0)
                        + Isnull(Air_Cost2, 0)
                        + Isnull(Air_Cost3, 0)
                        + Isnull(Air_Cost4, 0)
                        + Isnull(Air_Cost5, 0))
                    / Count ( * ))
                 Avg_Airfare
       From   Inst_Travel@Gkprod
      Where     Isnull(Air_Cost1, 0)
              + Isnull(Air_Cost2, 0)
              + Isnull(Air_Cost3, 0)
              + Isnull(Air_Cost4, 0)
              + Isnull(Air_Cost5, 0) > 0
              And Create_Date >= Cast(Getutcdate() As Date) - 365
   Group By   Metroarea;



