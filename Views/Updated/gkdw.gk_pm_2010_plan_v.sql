


Create Or Alter View Hold.Gk_Pm_2010_Plan_V
(
   Country,
   Coursecode,
   Plan_Sched,
   Plan_Run,
   Plan_Fillrate
)
As
     Select   Case
                 When P.Le_Num In ('210', '214') Then 'Usa'
                 When P.Le_Num In ('220', '224') Then 'Canada'
              End
                 Country,
              P.Course_Code Coursecode,
              Sum (Case When P.Acct_Num = '92050' Then P.Amt_Sum Else 0 End)
                 Plan_Sched,
              Sum (Case When P.Acct_Num = '92060' Then P.Amt_Sum Else 0 End)
                 Plan_Run,
              Case
                 When Sum(Case
                             When P.Acct_Num = '92060' Then P.Amt_Sum
                             Else 0
                          End) = 0
                 Then
                    0
                 Else
                    (Sum(Case
                            When P.Acct_Num = '92122' And P.Ch_Num = '20'
                            Then
                               P.Amt_Sum
                            Else
                               0
                         End)
                     + Sum(Case
                              When P.Acct_Num = '92122' And P.Ch_Num = '10'
                              Then
                                 P.Amt_Sum
                              Else
                                 0
                           End))
                    / Sum(Case
                             When P.Acct_Num = '92060' Then P.Amt_Sum
                             Else 0
                          End)
              End
                 Plan_Fillrate
       From   Gkdw.Gk_Us_Plan P
      --       Left Outer Join Gkdw.Course_Dim Cd On P.Course_Code = Cd.Course_Code And Cd.Country = Case When P.Le_Num = '220' Then 'Canada' Else 'Usa' End And Cd.Gkdw_Source = 'Slxdw'
      --       Left Outer Join Gkdw.Product_Dim Pd On P.Course_Code = Pd.Prod_Num
      Where   P.Period_Year = Format(Getutcdate(), 'Yyyy')
              And P.Acct_Num In ('41105', '92122', '92123', '92060', '92050')
   Group By   Case
                 When P.Le_Num In ('210', '214') Then 'Usa'
                 When P.Le_Num In ('220', '224') Then 'Canada'
              End, P.Course_Code;



