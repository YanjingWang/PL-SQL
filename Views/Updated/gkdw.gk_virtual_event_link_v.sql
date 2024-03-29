


Create Or Alter View Hold.Gk_Virtual_Event_Link_V
(
   Virtual_Event,
   Virtual_Event_Link,
   Country,
   Event_Link_Country
)
As
     Select   Distinct Ed1.Event_Id Virtual_Event,
                       Ed2.Event_Id Virtual_Event_Link,
                       Ed1.Country,
                       Ed2.Country Event_Link_Country
       From               Gkdw.Event_Dim Ed1
                       Left Outer Join
                          Gkdw.Instructor_Event_V Ie1
                       On Ed1.Event_Id = Ie1.Evxeventid And Ie1.Feecode = 'Ins'
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed1.Course_Id = Cd.Course_Id
                       And Ed1.Ops_Country = Cd.Country
                 Left Outer Join
                    Gkdw.Event_Dim Ed2
                 On     Ed1.Course_Id = Ed2.Course_Id
                    And Ed1.Start_Date = Ed2.Start_Date
                    And Ed1.Start_Time = Ed2.Start_Time
                    And Ed1.Ops_Country != Ed2.Ops_Country
              Left Outer Join
                 Gkdw.Instructor_Event_V Ie2
              On Ed2.Event_Id = Ie2.Evxeventid And Ie2.Feecode = 'Ins'
      Where       Cd.Md_Num = '20'
              And Ed1.Status != 'Cancelled'
              And Isnull(Ie1.Contactid, 'None') = Isnull(Ie2.Contactid, 'None')
   --   And Exists (Select 1 From Gkdw.Order_Fact F Where Ed2.Event_Id = F.Event_Id And F.Enroll_Status != 'Cancelled')
   ;



