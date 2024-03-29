


Create Or Alter View Hold.Gk_Oe_Attended_Cnt_V
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
      Where       Cd.Md_Num In ('10', '20')
              And Cd.Ch_Num = '10'
              And Ed.Status != 'Cancelled'
              And F.Enroll_Status In ('Attended', 'Confirmed')
   Group By   Ed.Event_Id,
              Ed.Course_Id,
              Cd.Course_Code,
              Ed.Capacity;



