


Create Or Alter View Hold.Gk_2013_Event_Plan_Proj
(
   Dim_Year,
   Country,
   Course_Code,
   Short_Name,
   Course_Pl,
   Course_Type,
   Metro,
   Dim_Qtr,
   Dim_Month,
   Event_Cnt,
   Proj_Event_Fill,
   Proj_Course_Fill,
   Proj_Course_Metro_Fill,
   Proj_Fill_Rate_2013
)
As
     Select   P1.Dim_Year,
              P1.Country,
              P1.Course_Code,
              P1.Short_Name,
              P1.Course_Pl,
              P1.Course_Type,
              P1.Metro,
              P1.Dim_Qtr,
              P1.Dim_Month,
              Count (P1.Course_Code) Event_Cnt,
              P2.Proj_Fill_Rate Proj_Event_Fill,
              P6.Proj_Fill_Rate Proj_Course_Fill,
              P7.Proj_Fill_Rate Proj_Course_Metro_Fill,
              Case
                 When (Case
                          When P2.Proj_Fill_Rate Is Not Null Then 1
                          Else 0
                       End
                       + Case
                            When P6.Proj_Fill_Rate Is Not Null Then 1
                            Else 0
                         End
                       + Case
                            When P7.Proj_Fill_Rate Is Not Null Then 1
                            Else 0
                         End) = 0
                 Then
                    0
                 Else
                    Round( (  2 * Isnull(P2.Proj_Fill_Rate, 0)
                            + .25 * Isnull(P6.Proj_Fill_Rate, 0)
                            + .75 * Isnull(P7.Proj_Fill_Rate, 0))
                          / (Case
                                When P2.Proj_Fill_Rate Is Not Null Then 2
                                Else 0
                             End
                             + Case
                                  When P6.Proj_Fill_Rate Is Not Null Then .25
                                  Else 0
                               End
                             + Case
                                  When P7.Proj_Fill_Rate Is Not Null Then .75
                                  Else 0
                               End))
              End
                 Proj_Fill_Rate_2013
       From            Gkdw.Gk_2013_Event_Plan P1
                    Left Outer Join
                       Gkdw.Gk_2013_Event_Plan_V P2
                    On     P1.Course_Code = P2.Course_Code
                       And P1.Metro = P2.Metro
                       And P1.Dim_Qtr = P2.Dim_Quarter
                 Left Outer Join
                    Gkdw.Gk_2013_Event_Course_V P6
                 On P1.Course_Code = P6.Course_Code
              Left Outer Join
                 Gkdw.Gk_2013_Event_Course_Metro_V P7
              On P1.Course_Code = P7.Course_Code And P1.Metro = P7.Metro
   -- Where P1.Course_Pl = 'Cisco'
   Group By   P1.Dim_Year,
              P1.Country,
              P1.Course_Code,
              P1.Short_Name,
              P1.Course_Pl,
              P1.Course_Type,
              P1.Metro,
              P1.Dim_Qtr,
              P1.Dim_Month,
              P2.Proj_Fill_Rate,
              P6.Proj_Fill_Rate,
              P7.Proj_Fill_Rate
   ;



