


Create Or Alter View Hold.Gk_Pm_Rolling_3Mo_V
(
   Country,
   Course_Id,
   Course_Code,
   Rev_Amt,
   Enroll_Cnt,
   Event_Cnt,
   Rev_Stud
)
As
     Select   Cd.Country,
              Cd.Course_Id,
              Cd.Course_Code,
              Sum (F.Book_Amt) Rev_Amt,
              Count (F.Enroll_Id) Enroll_Cnt,
              Count (Distinct Ed.Event_Id) Event_Cnt,
              Sum (F.Book_Amt) / Count (F.Enroll_Id) Rev_Stud
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Ed.Status != 'Cancelled'
              And F.Enroll_Status != 'Cancelled'
              And Ed.Start_Date >= Cast(Getutcdate() As Date) - 90
   Group By   Cd.Country, Cd.Course_Id, Cd.Course_Code;



