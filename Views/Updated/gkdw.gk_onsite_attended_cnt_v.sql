


Create Or Alter View Hold.Gk_Onsite_Attended_Cnt_V
(
   Event_Id,
   Course_Id,
   Course_Code,
   Capacity,
   Enroll_Cnt
)
As
     Select   Ed.Event_Id,
              Ed.Course_Id,
              Cd.Course_Code,
              Ed.Capacity,
              Case
                 When Ed.Onsite_Attended Is Not Null Then Ed.Onsite_Attended
                 Else Ed.Capacity
              End
                 Enroll_Cnt
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Left Outer Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Cd.Md_Num In ('10', '20')
              And Cd.Ch_Num = '20'
              And Ed.Status != 'Cancelled'
   --And Ed.Event_Id = 'Q6uj9a09paru'
   Group By   Ed.Event_Id,
              Ed.Course_Id,
              Cd.Course_Code,
              Ed.Onsite_Attended,
              Ed.Capacity
     Having   Sum (Case When F.Enroll_Status = 'Attended' Then 1 Else 0 End) =
                 0
   Union
     Select   Ed.Event_Id,
              Ed.Course_Id,
              Cd.Course_Code,
              Ed.Capacity,
              Sum (Case When F.Enroll_Status = 'Attended' Then 1 Else 0 End)
                 Enroll_Cnt
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Left Outer Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Cd.Md_Num In ('10', '20')
              And Cd.Ch_Num = '20'
              And Ed.Status != 'Cancelled'
   --And Ed.Event_Id = 'Q6uj9a09paru'
   Group By   Ed.Event_Id,
              Ed.Course_Id,
              Cd.Course_Code,
              Ed.Onsite_Attended,
              Ed.Capacity,
              F.Enroll_Status
     Having   Sum (Case When F.Enroll_Status = 'Attended' Then 1 Else 0 End) >
                 0;



