


Create Or Alter View Hold.Gk_Micro_Event_Cnt_V
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
              Count ( * ) Enroll_Cnt
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Cd.Md_Num In ('10', '41')
              And Cd.Ch_Num = '10'
              And Ed.Status != 'Cancelled'
              And F.Enroll_Status In ('Attended', 'Confirmed')
   Group By   Ed.Event_Id,
              Ed.Course_Id,
              Cd.Course_Code,
              Ed.Capacity
   Union
     Select   Ed.Event_Id,
              Ed.Course_Id,
              Cd.Course_Code,
              Ed.Capacity,
              Case
                 When Count (F.Enroll_Id) = 0 Then 24
                 Else Count (F.Enroll_Id)
              End
                 Enroll_Cnt
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Left Outer Join
                 Gkdw.Order_Fact F
              On     Ed.Event_Id = F.Event_Id
                 And F.Enroll_Status In ('Attended', 'Confirmed')
                 And F.Fee_Type = 'Ons - Individual'
      Where       Cd.Md_Num In ('10', '41')
              And Cd.Ch_Num = '20'
              And Ed.Status != 'Cancelled'
   Group By   Ed.Event_Id,
              Ed.Course_Id,
              Cd.Course_Code,
              Ed.Capacity;



