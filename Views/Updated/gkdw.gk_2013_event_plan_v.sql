


Create Or Alter View Hold.Gk_2013_Event_Plan_V
(
   Course_Code,
   Short_Name,
   Metro,
   Ops_Country,
   Dim_Quarter,
   Event_Cnt_0,
   Enroll_Cnt_0,
   Event_Cnt_1,
   Enroll_Cnt_1,
   Event_Cnt_2,
   Enroll_Cnt_2,
   Proj_Fill_Rate
)
As
     Select   Q.Course_Code,
              Q.Short_Name,
              Q.Metro,
              Q.Ops_Country,
              Q.Dim_Quarter,
              Sum (Event_Cnt_0) Event_Cnt_0,
              Sum (Enroll_Cnt_0) Enroll_Cnt_0,
              Sum (Event_Cnt_1) Event_Cnt_1,
              Sum (Enroll_Cnt_1) Enroll_Cnt_1,
              Sum (Event_Cnt_2) Event_Cnt_2,
              Sum (Enroll_Cnt_2) Enroll_Cnt_2,
              Round(Case
                       When Sum (Enroll_Cnt_2) = 0 And Sum (Enroll_Cnt_1) = 0
                       Then
                          (Case
                              When Sum (Event_Cnt_0) = 0
                              Then
                                 0
                              Else
                                 Round (Sum (Enroll_Cnt_0) / Sum (Event_Cnt_0))
                           End)
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
                       When Sum (Enroll_Cnt_1) = 0
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
                                When Sum (Event_Cnt_2) = 0
                                Then
                                   0
                                Else
                                   Round (
                                      Sum (Enroll_Cnt_2) / Sum (Event_Cnt_2)
                                   )
                             End
                             * .2)
                       When Sum (Enroll_Cnt_0) = 0
                       Then
                          (Case
                              When Sum (Event_Cnt_1) = 0
                              Then
                                 0
                              Else
                                 Round (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1))
                           End
                           * .6)
                          + (Case
                                When Sum (Event_Cnt_2) = 0
                                Then
                                   0
                                Else
                                   Round (
                                      Sum (Enroll_Cnt_2) / Sum (Event_Cnt_2)
                                   )
                             End
                             * .4)
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
       From   (  Select   Cd.Course_Code,
                          Cd.Short_Name,
                          Ed.Facility_Region_Metro Metro,
                          Ed.Ops_Country,
                          Td.Dim_Quarter Dim_Quarter,
                          Count (Distinct Ed.Event_Id) Event_Cnt_0,
                          Count (Distinct F.Enroll_Id) Enroll_Cnt_0,
                          0 Event_Cnt_1,
                          0 Enroll_Cnt_1,
                          0 Event_Cnt_2,
                          0 Enroll_Cnt_2
                   From               Gkdw.Event_Dim Ed
                                   Inner Join
                                      Gkdw.Course_Dim Cd
                                   On     Ed.Course_Id = Cd.Course_Id
                                      And Ed.Ops_Country = Cd.Country
                                      And Cd.Ch_Num = '10'
                                      And Cd.Md_Num = '10'
                                Inner Join
                                   Gkdw.Order_Fact F
                                On Ed.Event_Id = F.Event_Id
                             Inner Join
                                Gkdw.Time_Dim Td
                             On Ed.Start_Date = Td.Dim_Date
                          Inner Join
                             Gkdw.Time_Dim Td2
                          On Round (Getutcdate()) = Td2.Dim_Date
                  Where   Td.Dim_Year + '-' + Lpad (Td.Dim_Quarter - 1, 2, '0') Between Td2.Dim_Year
                                                                                          - 1
                                                                                          + '-'
                                                                                          + Lpad (
                                                                                                Td2.Dim_Quarter,
                                                                                                2,
                                                                                                '0'
                                                                                             )
                                                                                      And  Td2.Dim_Year
                                                                                           + '-'
                                                                                           + Lpad (
                                                                                                 Td2.Dim_Quarter
                                                                                                 - 1,
                                                                                                 2,
                                                                                                 '0'
                                                                                              )
                          And F.Book_Amt > 0
                          And F.Orig_Enroll_Id Is Null
                          And Isnull(F.Enroll_Status_Desc, 'None') Not In
                                   ('Order Entry Error', 'Accounting Fix')
                          --   And Ed.Status In ('Open','Verified')
                          --   And F.Enroll_Status In ('Confirmed','Attended')
                          And Ed.Plan_Type Not In ('Sales Request')
               Group By   Cd.Course_Code,
                          Cd.Short_Name,
                          Ed.Facility_Region_Metro,
                          Ed.Ops_Country,
                          Td.Dim_Quarter
               Union All
                 Select   Cd.Course_Code,
                          Cd.Short_Name,
                          Ed.Facility_Region_Metro,
                          Ed.Ops_Country,
                          Td.Dim_Quarter,
                          0 Event_Cnt_0,
                          0 Enroll_Cnt_0,
                          Count (Distinct Ed.Event_Id) Event_Cnt_1,
                          Count (Distinct F.Enroll_Id) Enroll_Cnt_1,
                          0 Event_Cnt_2,
                          0 Enroll_Cnt_2
                   From               Gkdw.Event_Dim Ed
                                   Inner Join
                                      Gkdw.Course_Dim Cd
                                   On     Ed.Course_Id = Cd.Course_Id
                                      And Ed.Ops_Country = Cd.Country
                                      And Cd.Ch_Num = '10'
                                      And Cd.Md_Num = '10'
                                Inner Join
                                   Gkdw.Order_Fact F
                                On Ed.Event_Id = F.Event_Id
                             Inner Join
                                Gkdw.Time_Dim Td
                             On Ed.Start_Date = Td.Dim_Date
                          Inner Join
                             Gkdw.Time_Dim Td2
                          On Round (Getutcdate()) = Td2.Dim_Date
                  Where   Td.Dim_Year + '-' + Lpad (Td.Dim_Quarter - 1, 2, '0') Between Td2.Dim_Year
                                                                                          - 2
                                                                                          + '-'
                                                                                          + Lpad (
                                                                                                Td2.Dim_Quarter,
                                                                                                2,
                                                                                                '0'
                                                                                             )
                                                                                      And  Td2.Dim_Year
                                                                                           - 1
                                                                                           + '-'
                                                                                           + Lpad (
                                                                                                 Td2.Dim_Quarter
                                                                                                 - 1,
                                                                                                 2,
                                                                                                 '0'
                                                                                              )
                          And F.Book_Amt > 0
                          And F.Orig_Enroll_Id Is Null
                          And Isnull(F.Enroll_Status_Desc, 'None') Not In
                                   ('Order Entry Error', 'Accounting Fix')
                          --   And Ed.Status In ('Open','Verified')
                          --   And F.Enroll_Status In ('Confirmed','Attended')
                          And Ed.Plan_Type Not In ('Sales Request')
               Group By   Cd.Course_Code,
                          Cd.Short_Name,
                          Ed.Facility_Region_Metro,
                          Ed.Ops_Country,
                          Td.Dim_Quarter
               Union All
                 Select   Cd.Course_Code,
                          Cd.Short_Name,
                          Ed.Facility_Region_Metro,
                          Ed.Ops_Country,
                          Td.Dim_Quarter,
                          0 Event_Cnt_0,
                          0 Enroll_Cnt_0,
                          0 Event_Cnt_1,
                          0 Enroll_Cnt_1,
                          Count (Distinct Ed.Event_Id) Event_Cnt_2,
                          Count (Distinct F.Enroll_Id) Enroll_Cnt_2
                   From               Gkdw.Event_Dim Ed
                                   Inner Join
                                      Gkdw.Course_Dim Cd
                                   On     Ed.Course_Id = Cd.Course_Id
                                      And Ed.Ops_Country = Cd.Country
                                      And Cd.Ch_Num = '10'
                                      And Cd.Md_Num = '10'
                                Inner Join
                                   Gkdw.Order_Fact F
                                On Ed.Event_Id = F.Event_Id
                             Inner Join
                                Gkdw.Time_Dim Td
                             On Ed.Start_Date = Td.Dim_Date
                          Inner Join
                             Gkdw.Time_Dim Td2
                          On Round (Getutcdate()) = Td2.Dim_Date
                  Where   Td.Dim_Year + '-' + Lpad (Td.Dim_Quarter - 1, 2, '0') Between Td2.Dim_Year
                                                                                          - 3
                                                                                          + '-'
                                                                                          + Lpad (
                                                                                                Td2.Dim_Quarter,
                                                                                                2,
                                                                                                '0'
                                                                                             )
                                                                                      And  Td2.Dim_Year
                                                                                           - 2
                                                                                           + '-'
                                                                                           + Lpad (
                                                                                                 Td2.Dim_Quarter
                                                                                                 - 1,
                                                                                                 2,
                                                                                                 '0'
                                                                                              )
                          And F.Book_Amt > 0
                          And F.Orig_Enroll_Id Is Null
                          And Isnull(F.Enroll_Status_Desc, 'None') Not In
                                   ('Order Entry Error', 'Accounting Fix')
                          --   And Ed.Status In ('Open','Verified')
                          --   And F.Enroll_Status In ('Confirmed','Attended')
                          And Ed.Plan_Type Not In ('Sales Request')
               Group By   Cd.Course_Code,
                          Cd.Short_Name,
                          Ed.Facility_Region_Metro,
                          Ed.Ops_Country,
                          Td.Dim_Quarter) Q
   Group By   Q.Course_Code,
              Q.Short_Name,
              Q.Metro,
              Q.Ops_Country,
              Q.Dim_Quarter;



