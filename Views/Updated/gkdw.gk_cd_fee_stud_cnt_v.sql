


Create Or Alter View Hold.Gk_Cd_Fee_Stud_Cnt_V
(
   Event_Id,
   Numstudents,
   Revamt
)
As
     Select   Ed.Event_Id,
              Case
                 When Sum(Case
                             When F.Fee_Type != 'Ons - Base'
                                  And F.Enroll_Status In
                                           ('Confirmed', 'Attended')
                             Then
                                1
                             Else
                                0
                          End) > 0
                 Then
                    Sum(Case
                           When F.Fee_Type != 'Ons - Base'
                                And F.Enroll_Status In
                                         ('Confirmed', 'Attended')
                           Then
                              1
                           Else
                              0
                        End)
                 When Ed.Onsite_Attended Is Not Null
                 Then
                    Ed.Onsite_Attended
                 When Isnull(Fc.New_Numattendees, F.Numstudents) Is Not Null
                 Then
                    Isnull(Fc.New_Numattendees, F.Numstudents)
                 Else
                    Ed.Capacity
              End
                 Numstudents,
              Sum (F.Book_Amt) Revamt
       From                  Gkdw.Event_Dim Ed
                          Inner Join
                             Gkdw.Course_Dim Cd
                          On Ed.Course_Id = Cd.Course_Id
                             And Ed.Ops_Country = Cd.Country
                       Inner Join
                          Gkdw.Order_Fact F
                       On Ed.Event_Id = F.Event_Id
                    Left Outer Join
                       Base.Gk_Onsitereq_Courses Oc
                    On Ed.Event_Id = Oc.Evxeventid
                 Left Outer Join
                    Base.Gk_Onsitereq_Fdc F
                 On Oc.Gk_Onsitereq_Fdcid = F.Gk_Onsitereq_Fdcid
              Left Outer Join
                 Gkdw.Gk_Fdc_Attendee_Change_V Fc
              On F.Gk_Onsitereq_Fdcid = Fc.Gk_Onsitereq_Fdcid
      Where   Cd.Ch_Num = '20'
   Group By   Ed.Event_Id,
              Ed.Onsite_Attended,
              Isnull(Fc.New_Numattendees, F.Numstudents),
              Ed.Capacity
   Union
     Select   Ed.Event_Id, Count ( * ) Numstudents, Sum (F.Book_Amt) Revamt
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Cd.Ch_Num = '10'
              And Ed.Status != 'Cancelled'
              And F.Enroll_Status In ('Confirmed', 'Attended')
              And F.Book_Amt > 0
   Group By   Ed.Event_Id;



