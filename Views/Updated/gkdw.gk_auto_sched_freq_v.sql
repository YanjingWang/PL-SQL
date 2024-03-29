


Create Or Alter View Hold.Gk_Auto_Sched_Freq_V
(
   Country,
   Metro,
   Course_Code,
   Course_Id,
   Course_Pl,
   Short_Name,
   Course_Type,
   Duration_Days,
   Year_Dist,
   Year_Freq,
   Last_Week
)
As
     Select   Country,
              Metro,
              Course_Code,
              Course_Id,
              Course_Pl,
              Short_Name,
              Course_Type,
              Duration_Days,
              Year_Dist,
              Year_Freq,
              Max (Td2.Fiscal_Week) Last_Week
       From      (  Select   L.Country,
                             L.Metro,
                             L.Course_Code,
                             Cd.Course_Id,
                             Cd.Course_Pl,
                             Cd.Short_Name,
                             Cd.Course_Type,
                             Cd.Duration_Days,
                             L.Year_Dist,
                             Round (52 / Year_Dist) Year_Freq,
                             Isnull(Max (Lpad (Td.Fiscal_Week, 2, '0')), '52')
                                Last_Week
                      From            Gkdw.Gk_Auto_Sched_Load L
                                   Inner Join
                                      Gkdw.Course_Dim Cd
                                   On     L.Course_Code = Cd.Course_Code
                                      And L.Country = Cd.Country
                                      And Gkdw_Source = 'Slxdw'
                                Left Outer Join
                                   Gkdw.Event_Dim Ed
                                On Cd.Course_Id = Ed.Course_Id
                                   And L.Metro = Ed.Facility_Region_Metro
                             Left Outer Join
                                Gkdw.Time_Dim Td
                             On Td.Dim_Date = Ed.Start_Date
                                And Td.Fiscal_Year = 2016
                     Where   Year_Dist > 0
                  Group By   L.Country,
                             L.Metro,
                             L.Course_Code,
                             Cd.Course_Id,
                             Cd.Course_Pl,
                             Cd.Short_Name,
                             Cd.Course_Type,
                             Cd.Duration_Days,
                             L.Year_Dist,
                             Round (52 / Year_Dist)) Q
              Left Outer Join
                 Gkdw.Time_Dim Td2
              On Td2.Fiscal_Year = 2016
                 And Lpad (Td2.Fiscal_Week, 2, '0') = Q.Last_Week
   Group By   Country,
              Metro,
              Course_Code,
              Course_Id,
              Course_Pl,
              Short_Name,
              Course_Type,
              Duration_Days,
              Year_Dist,
              Year_Freq
   ;



