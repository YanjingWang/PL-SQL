


Create Or Alter View Hold.Gk_2013_Event_Course_V
(
   Course_Code,
   Fill_Rate_0,
   Fill_Rate_1,
   Fill_Rate_2,
   Proj_Fill_Rate
)
As
     Select   C.Course_Code,
              Case
                 When Sum (Event_Cnt_0) = 0 Then 0
                 Else Round (Sum (Enroll_Cnt_0) / Sum (Event_Cnt_0))
              End
                 Fill_Rate_0,
              Case
                 When Sum (Event_Cnt_1) = 0 Then 0
                 Else Round (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1))
              End
                 Fill_Rate_1,
              Case
                 When Sum (Event_Cnt_2) = 0 Then 0
                 Else Round (Sum (Enroll_Cnt_2) / Sum (Event_Cnt_2))
              End
                 Fill_Rate_2,
              Round(Case
                       When Sum (Enroll_Cnt_2) = 0 And Sum (Enroll_Cnt_1) = 0
                       Then
                          Case
                             When Sum (Event_Cnt_0) = 0
                             Then
                                0
                             Else
                                Round (Sum (Enroll_Cnt_0) / Sum (Event_Cnt_0))
                          End
                       When Sum (Enroll_Cnt_2) = 0
                       Then
                          (Case
                              When Sum (Event_Cnt_0) = 0
                              Then
                                 0
                              Else
                                 Round (Sum (Enroll_Cnt_0) / Sum (Event_Cnt_0))
                           End
                           * .8)
                          + (Case
                                When Sum (Event_Cnt_1) = 0
                                Then
                                   0
                                Else
                                   Round (
                                      Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1)
                                   )
                             End
                             * .2)
                       Else
                          (Case
                              When Sum (Event_Cnt_0) = 0
                              Then
                                 0
                              Else
                                 Round (Sum (Enroll_Cnt_0) / Sum (Event_Cnt_0))
                           End
                           * .7)
                          + (Case
                                When Sum (Event_Cnt_1) = 0
                                Then
                                   0
                                Else
                                   Round (
                                      Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1)
                                   )
                             End
                             * .2)
                          + (Case
                                When Sum (Event_Cnt_2) = 0
                                Then
                                   0
                                Else
                                   Round (
                                      Sum (Enroll_Cnt_2) / Sum (Event_Cnt_2)
                                   )
                             End
                             * .1)
                    End)
                 Proj_Fill_Rate
       From      Gkdw.Gk_2013_Event_Plan_V E
              Inner Join
                 Gkdw.Course_Dim C
              On E.Course_Code = C.Course_Code And C.Country = E.Ops_Country
   Group By   C.Course_Code
   ;



