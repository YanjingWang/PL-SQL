


Create Or Alter View Hold.Gk_Sched_Rev_Per_Stud_V
(
   Course_Id,
   Ops_Country,
   Rev_Amt,
   En_Cnt,
   Rev_Per_Stud
)
As
     Select   Ed.Course_Id,
              Ed.Ops_Country,
              Sum (F.Book_Amt) Rev_Amt,
              Count (Distinct F.Enroll_Id) En_Cnt,
              Sum (F.Book_Amt) / Count (Distinct F.Enroll_Id) Rev_Per_Stud
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Td.Dim_Year = Format(Getutcdate(), 'Yyyy')
              And Ed.Start_Date <= Cast(Getutcdate() As Date)
              And Ed.Status != 'Cancelled'
              And F.Enroll_Status != 'Cancelled'
   Group By   Ed.Course_Id, Ed.Ops_Country;



