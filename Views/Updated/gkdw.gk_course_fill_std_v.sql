


Create Or Alter View Hold.Gk_Course_Fill_Std_V
(
   Event_Channel,
   Event_Modality,
   Course_Code,
   Start_Day,
   End_Day,
   Min_Enroll_Cnt,
   Max_Enroll_Cnt,
   Avg_Fill_Rate
)
As
     Select   Event_Channel,
              Event_Modality,
              Course_Code,
              Start_Day,
              End_Day,
              Min (Enroll_Cnt) Min_Enroll_Cnt,
              Max (Enroll_Cnt) Max_Enroll_Cnt,
              Round (Sum (Enroll_Cnt) / Sum (Event_Cnt), 2) Avg_Fill_Rate
       From   (  Select   Ed.Event_Channel,
                          Ed.Event_Modality,
                          Ed.Course_Code,
                          Ed.Event_Id,
                          70 Start_Day,
                          365 End_Day,
                          Sum(Case
                                 When Ed.Start_Date - F.Enroll_Date + 1 >= 70
                                 Then
                                    1
                                 Else
                                    0
                              End)
                             Enroll_Cnt,
                          Count (Distinct Ed.Event_Id) Event_Cnt
                   From      Gkdw.Order_Fact F
                          Inner Join
                             Gkdw.Event_Dim Ed
                          On F.Event_Id = Ed.Event_Id
                  Where       Enroll_Status In ('Confirmed', 'Attended')
                          And Ed.Event_Channel = 'Individual/Public'
                          And Ed.Event_Modality = 'C-Learning'
                          And Ed.Status = 'Verified'
                          And Ed.Ops_Country = 'Usa'
                          And Ed.Start_Date >= To_Date ('1/1/2006', 'Mm/Dd/Yyyy')
               Group By   Ed.Event_Channel,
                          Ed.Event_Modality,
                          Ed.Course_Code,
                          Ed.Event_Id
               Union All
                 Select   Ed.Event_Channel,
                          Ed.Event_Modality,
                          Ed.Course_Code,
                          Ed.Event_Id,
                          56 Start_Day,
                          69 End_Day,
                          Sum(Case
                                 When Ed.Start_Date - F.Enroll_Date + 1 >= 56
                                 Then
                                    1
                                 Else
                                    0
                              End)
                             Enroll_Cnt,
                          Count (Distinct Ed.Event_Id) Event_Cnt
                   From      Gkdw.Order_Fact F
                          Inner Join
                             Gkdw.Event_Dim Ed
                          On F.Event_Id = Ed.Event_Id
                  Where       Enroll_Status In ('Confirmed', 'Attended')
                          And Ed.Event_Channel = 'Individual/Public'
                          And Ed.Event_Modality = 'C-Learning'
                          And Ed.Status = 'Verified'
                          And Ed.Ops_Country = 'Usa'
                          And Ed.Start_Date >= To_Date ('1/1/2006', 'Mm/Dd/Yyyy')
               Group By   Ed.Event_Channel,
                          Ed.Event_Modality,
                          Ed.Course_Code,
                          Ed.Event_Id
               Union All
                 Select   Ed.Event_Channel,
                          Ed.Event_Modality,
                          Ed.Course_Code,
                          Ed.Event_Id,
                          42 Start_Day,
                          55 End_Day,
                          Sum(Case
                                 When Ed.Start_Date - F.Enroll_Date + 1 >= 42
                                 Then
                                    1
                                 Else
                                    0
                              End)
                             Enroll_Cnt,
                          Count (Distinct Ed.Event_Id) Event_Cnt
                   From      Gkdw.Order_Fact F
                          Inner Join
                             Gkdw.Event_Dim Ed
                          On F.Event_Id = Ed.Event_Id
                  Where       Enroll_Status In ('Confirmed', 'Attended')
                          And Ed.Event_Channel = 'Individual/Public'
                          And Ed.Event_Modality = 'C-Learning'
                          And Ed.Status = 'Verified'
                          And Ed.Ops_Country = 'Usa'
                          And Ed.Start_Date >= To_Date ('1/1/2006', 'Mm/Dd/Yyyy')
               Group By   Ed.Event_Channel,
                          Ed.Event_Modality,
                          Ed.Course_Code,
                          Ed.Event_Id
               Union All
                 Select   Ed.Event_Channel,
                          Ed.Event_Modality,
                          Ed.Course_Code,
                          Ed.Event_Id,
                          21 Start_Day,
                          41 End_Day,
                          Sum(Case
                                 When Ed.Start_Date - F.Enroll_Date + 1 >= 21
                                 Then
                                    1
                                 Else
                                    0
                              End)
                             Enroll_Cnt,
                          Count (Distinct Ed.Event_Id) Event_Cnt
                   From      Gkdw.Order_Fact F
                          Inner Join
                             Gkdw.Event_Dim Ed
                          On F.Event_Id = Ed.Event_Id
                  Where       Enroll_Status In ('Confirmed', 'Attended')
                          And Ed.Event_Channel = 'Individual/Public'
                          And Ed.Event_Modality = 'C-Learning'
                          And Ed.Status = 'Verified'
                          And Ed.Ops_Country = 'Usa'
                          And Ed.Start_Date >= To_Date ('1/1/2006', 'Mm/Dd/Yyyy')
               Group By   Ed.Event_Channel,
                          Ed.Event_Modality,
                          Ed.Course_Code,
                          Ed.Event_Id
               Union All
                 Select   Ed.Event_Channel,
                          Ed.Event_Modality,
                          Ed.Course_Code,
                          Ed.Event_Id,
                          0 Start_Day,
                          20 End_Day,
                          Count (Enroll_Id) Enroll_Cnt,
                          Count (Distinct Ed.Event_Id) Event_Cnt
                   From      Gkdw.Order_Fact F
                          Inner Join
                             Gkdw.Event_Dim Ed
                          On F.Event_Id = Ed.Event_Id
                  Where       Enroll_Status In ('Confirmed', 'Attended')
                          And Ed.Event_Channel = 'Individual/Public'
                          And Ed.Event_Modality = 'C-Learning'
                          And Ed.Status = 'Verified'
                          And Ed.Ops_Country = 'Usa'
                          And Ed.Start_Date >= To_Date ('1/1/2006', 'Mm/Dd/Yyyy')
               Group By   Ed.Event_Channel,
                          Ed.Event_Modality,
                          Ed.Course_Code,
                          Ed.Event_Id) a1
   Group By   Event_Channel,
              Event_Modality,
              Course_Code,
              Start_Day,
              End_Day
   ;



