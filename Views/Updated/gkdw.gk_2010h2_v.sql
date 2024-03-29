


Create Or Alter View Hold.Gk_2010H2_V
(
   Event_Id,
   Fillrate,
   Sessrev,
   Revstud
)
As
     Select   Ed.Event_Id,
              Sum(Case
                     When Enroll_Status In ('Attended', 'Confirmed') Then 1
                     Else 0
                  End)
              / Count (Distinct Ed.Event_Id)
                 Fillrate,
              Sum (Book_Amt) Sessrev,
              Case
                 When Sum(Case
                             When F.Enroll_Status != 'Cancelled' Then 1
                             Else 0
                          End) = 0
                 Then
                    0
                 Else
                    Sum (Book_Amt)
                    / Sum(Case
                             When F.Enroll_Status != 'Cancelled' Then 1
                             Else 0
                          End)
              End
                 Revstud
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Td.Dim_Year = 2010
              And Cd.Md_Num = '10'
              And Cd.Ch_Num = '10'
              And Td.Dim_Month_Num Between 1 And 7
              And Ed.Status = 'Verified'
   Group By   Ed.Event_Id;



