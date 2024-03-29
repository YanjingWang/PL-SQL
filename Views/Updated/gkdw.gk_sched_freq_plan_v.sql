


Create Or Alter View Hold.Gk_Sched_Freq_Plan_V
(
   Ops_Country,
   Course_Code,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Course_Type,
   Event_Cnt,
   Total_Cost,
   Total_Revenue,
   Enroll_Cnt,
   Avg_Cost,
   Avg_Fill_Rate,
   Avg_Fare,
   Min_Fill,
   Run_Pct,
   Type_Run_Pct
)
As
     Select   G.Ops_Country,
              G.Course_Code,
              Course_Ch,
              Course_Mod,
              Course_Pl,
              Course_Type,
              Count (Event_Id) Event_Cnt,
              Sum (Total_Cost) Total_Cost,
              Sum (Revenue) Total_Revenue,
              Sum (Enroll_Cnt) Enroll_Cnt,
              Round (Sum (Total_Cost) / Count (Event_Id)) Avg_Cost,
              Round (Sum (Enroll_Cnt) / Count (Event_Id)) Avg_Fill_Rate,
              Round (Sum (Revenue) / Sum (Enroll_Cnt)) Avg_Fare,
              Case
                 When Round( ( (Sum (Total_Cost) / Count (Event_Id)) * 2)
                            / (Sum(Revenue) / Sum(Enroll_Cnt))) < 6
                 Then
                    6
                 Else
                    Round( ( (Sum (Total_Cost) / Count (Event_Id)) * 2)
                          / (Sum (Revenue) / Sum (Enroll_Cnt)))
              End
                 Min_Fill,
              Round (Cc.Run_Pct, 2) Run_Pct,
              Round (Q.Type_Run_Pct, 2) Type_Run_Pct
       From         Gkdw.Gk_Go_Nogo_All_V G
                 Left Outer Join
                    Gkdw.Gk_Course_Run_Rate_V Cc
                 On G.Ops_Country = Cc.Ops_Country
                    And G.Course_Code = Cc.Course_Code
              Left Outer Join
                 (  Select   Course_Pl,
                             Course_Type,
                             Sum (Sched_Cnt) Type_Sched,
                             Sum (Run_Cnt) Type_Run,
                             Sum (Run_Cnt) / Sum (Sched_Cnt) Type_Run_Pct
                      From   Gkdw.Gk_Course_Run_Rate_V
                  Group By   Course_Pl, Course_Type) Q
              On G.Course_Pl = Q.Course_Pl And G.Course_Type = Q.Course_Type
      Where   G.Start_Date Between Cast(Getutcdate() As Date) - 365 And Cast(Getutcdate() As Date)
              And Substring(G.Course_Code, 5,  1) In ('C')
              And G.Enroll_Cnt > 0
              And G.Course_Code In
                       (Select   Ed.Course_Code
                          From   Gkdw.Event_Dim Ed
                         Where   G.Course_Code = Ed.Course_Code
                                 And G.Ops_Country = Ed.Country
                                 And Format(Ed.Start_Date, 'Yyyy') =
                                       Format(Getutcdate(), 'Yyyy')
                                 And Ed.Status != 'Cancelled')
   Group By   G.Ops_Country,
              G.Course_Code,
              Course_Ch,
              Course_Mod,
              Course_Pl,
              Course_Type,
              Cc.Run_Pct,
              Q.Type_Run_Pct
     Having   Round (Sum (Revenue) / Sum (Enroll_Cnt)) > 0
   ;



