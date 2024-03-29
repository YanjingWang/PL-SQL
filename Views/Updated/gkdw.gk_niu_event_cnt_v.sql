


Create Or Alter View Hold.Gk_Niu_Event_Cnt_V
(
   Event_Id,
   Course_Id,
   Course_Code,
   Capacity,
   Enroll_Cnt
)
As
     Select   Distinct Ed.Event_Id,
                       Ed.Course_Id,
                       Ed.Course_Code,
                       Ed.Capacity,
                       Count ( * ) Enroll_Cnt
       From                  Gkdw.Event_Dim Ed
                          Inner Join
                             Gkdw.Course_Dim Cd
                          On Ed.Course_Id = Cd.Course_Id
                             And Ed.Ops_Country = Cd.Country
                       Inner Join
                          Rmsdw.Rms_Event Re
                       On Ed.Event_Id = Re.Slx_Event_Id
                          And Upper (Re.Contract_Status) In
                                   ('Contract On File', 'Dedicated Room')
                    Inner Join
                       Gkdw.Time_Dim Td
                    On Ed.Start_Date = Td.Dim_Date
                 Inner Join
                    Gkdw.Time_Dim Td2
                 On Td2.Dim_Date = Cast(Getutcdate() As Date)
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Ed.Status != 'Cancelled'
              And F.Enroll_Status In ('Attended', 'Confirmed')
              And Ed.Facility_Code = 'Niu-Chi'
   Group By   Ed.Event_Id,
              Ed.Course_Id,
              Ed.Course_Code,
              Ed.Capacity;



