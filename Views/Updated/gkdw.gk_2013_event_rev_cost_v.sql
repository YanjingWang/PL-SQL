


Create Or Alter View Hold.Gk_2013_Event_Rev_Cost_V
(
   Ops_Country,
   Course_Code,
   Book_Amt,
   Enroll_Cnt,
   Avg_Fare,
   Event_Cost,
   Event_Cnt,
   Avg_Event_Cost,
   Avg_Margin
)
As
     Select   Ops_Country,
              Course_Code,
              Sum (Book_Amt) Book_Amt,
              Sum (Enroll_Cnt) Enroll_Cnt,
              Sum (Avg_Fare) Avg_Fare,
              Sum (Event_Cost) Event_Cost,
              Sum (Event_Cnt) Event_Cnt,
              Sum (Avg_Event_Cost) Avg_Event_Cost,
              Case
                 When Sum (Event_Cnt) = 0
                 Then
                    0
                 Else
                    Round (
                       (Sum (Book_Amt) - Sum (Event_Cost)) / Sum (Event_Cnt)
                    )
              End
                 Avg_Margin
       From   (  Select   Ed.Ops_Country,
                          Ed.Course_Code,
                          Sum (Book_Amt) Book_Amt,
                          Count (Enroll_Id) Enroll_Cnt,
                          Round (Sum (Book_Amt) / Count (Enroll_Id)) Avg_Fare,
                          0 Event_Cost,
                          0 Event_Cnt,
                          0 Avg_Event_Cost
                   From         Gkdw.Event_Dim Ed
                             Inner Join
                                Gkdw.Time_Dim Td
                             On Ed.Start_Date = Td.Dim_Date
                          Inner Join
                             Gkdw.Order_Fact F
                          On Ed.Event_Id = F.Event_Id
                  Where   Td.Dim_Year >=
                             To_Number (Format(Getutcdate(), 'Yyyy')) - 2
                          And F.Enroll_Status In ('Confirmed', 'Attended')
               Group By   Ed.Ops_Country, Ed.Course_Code
               Union All
                 Select   L.Ops_Country,
                          L.Course_Code,
                          0 Book_Amt,
                          0 Enroll_Cnt,
                          0 Avg_Fare,
                          Sum (Total_Cost) Event_Cost,
                          Count (L.Event_Id) Event_Cnt,
                          Round (Sum (Total_Cost) / Count (L.Event_Id))
                             Avg_Event_Cost
                   From      Gkdw.Gk_Go_Nogo L
                          Inner Join
                             Gkdw.Time_Dim Td
                          On L.Start_Date = Td.Dim_Date
                  Where   Td.Dim_Year >=
                             To_Number (Format(Getutcdate(), 'Yyyy')) - 2
                          And L.Cancelled_Date Is Null
               Group By   L.Ops_Country, L.Course_Code) a1
   Group By   Ops_Country, Course_Code;



