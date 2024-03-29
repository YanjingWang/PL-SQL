


Create Or Alter View Hold.Gk_Event_Meeting_Days_V
(
   Event_Id,
   Adj_Day_Val
)
As
   Select   Event_Id, Case
                         When Total_Hrs <= 2 Then .25
                         When Total_Hrs <= 4 Then .5
                         When Total_Hrs <= 6 Then .75
                         Else 1
                      End
                         Adj_Day_Val
     From   (Select   Ed.Event_Id,
                      Ed.End_Date - Ed.Start_Date + 1 Meeting_Days,
                      (Case
                          When Ed.End_Time Like '%Pm'
                               And Substring(Ed.End_Time, 1,  2) < '12'
                          Then
                             To_Number (Substring(Ed.End_Time, 1,  2)) + 12
                          When     Ed.End_Time Like '%Am'
                               And Ed.Start_Time Like '%Pm'
                               And Substring(Ed.End_Time, 1,  2) < '12'
                          Then
                             To_Number (Substring(Ed.End_Time, 1,  2)) + 12
                          Else
                             To_Number (Substring(Ed.End_Time, 1,  2))
                       End
                       + Case
                            When Substring(Ed.End_Time, 4,  2) = '15' Then .25
                            When Substring(Ed.End_Time, 4,  2) = '30' Then .5
                            When Substring(Ed.End_Time, 4,  2) = '45' Then .75
                            Else .0
                         End)
                      - (Case
                            When     Ed.Start_Time Like '%Pm'
                                 And Ed.End_Time Not Like '%Am'
                                 And Substring(Ed.Start_Time, 1,  2) < '12'
                            Then
                               To_Number (Substring(Ed.Start_Time, 1,  2)) + 12
                            When Ed.End_Time Like '%Am'
                                 And Ed.Start_Time Like '%Pm'
                            Then
                               To_Number (Substring(Ed.Start_Time, 1,  2))
                            Else
                               To_Number (Substring(Ed.Start_Time, 1,  2))
                         End
                         + Case
                              When Substring(Ed.Start_Time, 4,  2) = '15'
                              Then
                                 .25
                              When Substring(Ed.Start_Time, 4,  2) = '30'
                              Then
                                 .5
                              When Substring(Ed.Start_Time, 4,  2) = '45'
                              Then
                                 .75
                              Else
                                 .0
                           End)
                         Total_Hrs
               From   Gkdw.Event_Dim Ed) a1;



