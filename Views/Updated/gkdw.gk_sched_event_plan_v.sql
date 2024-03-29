


Create Or Alter View Hold.Gk_Sched_Event_Plan_V
(
   Ops_Country,
   Course_Code,
   Short_Name,
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
   Event_Ratio,
   Event_Cnt_Plan,
   Run_Pct_Factor,
   Sched_Cnt_Plan
)
As
     Select   P.Ops_Country,
              P.Course_Code,
              Short_Name,
              P.Course_Ch,
              P.Course_Mod,
              P.Course_Pl,
              P.Course_Type,
              Event_Cnt,
              Total_Cost,
              Total_Revenue,
              Enroll_Cnt,
              Avg_Cost,
              Avg_Fill_Rate,
              Avg_Fare,
              Min_Fill,
              Case
                 When Avg_Fill_Rate / Min_Fill > 1.20 Then 1.20
                 Else Round (Avg_Fill_Rate / Min_Fill, 2)
              End
                 Event_Ratio,
              Round(Event_Cnt
                    * Case
                         When Avg_Fill_Rate / Min_Fill > 1.20 Then 1.20
                         Else Round (Avg_Fill_Rate / Min_Fill, 2)
                      End)
                 Event_Cnt_Plan,
              Round ( (Run_Pct + Isnull(Type_Run_Pct, Run_Pct)) / 2, 2)
                 Run_Pct_Factor,
              Ceil( (Event_Cnt
                     * Case
                          When Avg_Fill_Rate / Min_Fill > 1.20 Then 1.20
                          Else Round (Avg_Fill_Rate / Min_Fill, 2)
                       End)
                   / ( (Run_Pct + Isnull(Type_Run_Pct, Run_Pct)) / 2))
                 Sched_Cnt_Plan
       From      Gkdw.Gk_Sched_Freq_Plan_V P
              Inner Join
                 Gkdw.Course_Dim Cd
              On     P.Course_Code = Cd.Course_Code
                 And P.Ops_Country = Cd.Country
                 And Cd.Gkdw_Source = 'Slxdw'
      Where   Ops_Country = 'Usa'
   ;



