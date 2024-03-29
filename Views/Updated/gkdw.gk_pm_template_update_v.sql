


Create Or Alter View Hold.Gk_Pm_Template_Update_V
(
   Country,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Course_Type,
   Course_Id,
   Course_Code,
   Short_Name,
   Duration_Days,
   Sched_10,
   Ev_10,
   En_10,
   Book_10
)
As
   Select   H.Country,
            H.Course_Ch,
            H.Course_Mod,
            H.Course_Pl,
            H.Course_Type,
            H.Course_Id,
            H.Course_Code,
            H.Short_Name,
            H.Duration_Days,
            H.Sched_10,
            H.Ev_10,
            H.En_10,
            H.Book_10
     --       Case When H.Sched_10 > 0 Then Isnull(P.Sched_Cnt_Plan,0) Else 0 End Sched_Cnt_Plan,
     --       Case When H.Sched_10 > 0 Then Isnull(P.Ev_Cnt_Plan,0) Else 0 End Ev_Cnt_Plan,
     --       Case When H.Sched_10 > 0 Then Isnull(P.En_Cnt_Plan,0) Else 0 End En_Cnt_Plan,
     --       Case When H.Sched_10 > 0 Then
     --            Case When Isnull(P.Ev_Cnt_Plan,0) = 0 Then 0 Else P.En_Cnt_Plan/Ev_Cnt_Plan End
     --            Else 0
     --       End Fill_Plan
     From      Gkdw.Gk_Pm_Course_Hist_Mv H
            Left Outer Join
               Gkdw.Gk_Pm_Course_Plan_Mv P
            On H.Course_Id = P.Course_Id And H.Country = P.Country
    Where   H.Sched_10 > 0
   Except
   Select   Country,
            Course_Ch,
            Course_Mod,
            Course_Pl,
            Course_Type,
            Course_Id,
            Course_Code,
            Short_Name,
            Duration_Days,
            Sched_10,
            Ev_10,
            En_10,
            Book_10
     --       Sched_Cnt_Plan,Ev_Cnt_Plan,En_Cnt_Plan,Fill_Plan
     From   Gkdw.Gk_Pm_Template;



