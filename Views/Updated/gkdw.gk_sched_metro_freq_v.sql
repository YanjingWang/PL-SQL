


Create Or Alter View Hold.Gk_Sched_Metro_Freq_V
(
   Ops_Country,
   Course_Code,
   Course_Pl,
   Course_Mod,
   Course_Ch,
   Course_Type,
   Short_Name,
   Facility_Region_Metro,
   Sched_Event,
   Total_Course,
   Metro_Pct
)
As
     Select   Ed.Ops_Country,
              Cd.Course_Code,
              Cd.Course_Pl,
              Cd.Course_Mod,
              Cd.Course_Ch,
              Cd.Course_Type,
              Cd.Short_Name,
              Ed.Facility_Region_Metro,
              Count (Ed.Event_Id) Sched_Event,
              Q.Total_Course,
              Count (Ed.Event_Id) / Q.Total_Course Metro_Pct
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On     Ed.Course_Id = Cd.Course_Id
                    And Ed.Ops_Country = Cd.Country
                    And Cd.Gkdw_Source = 'Slxdw'
              Inner Join
                 (  Select   Ed.Ops_Country,
                             Cd.Course_Code,
                             Cd.Course_Pl,
                             Cd.Course_Mod,
                             Cd.Course_Ch,
                             Cd.Course_Type,
                             Cd.Short_Name,
                             Count (Ed.Event_Id) Total_Course
                      From      Gkdw.Event_Dim Ed
                             Inner Join
                                Gkdw.Course_Dim Cd
                             On Ed.Course_Id = Cd.Course_Id
                                And Ed.Ops_Country = Cd.Country
                     Where   Ed.Start_Date Between Cast(Getutcdate() As Date) - 365
                                               And  Cast(Getutcdate() As Date)
                             And (Ed.Status In ('Verified', 'Open')
                                  Or (Ed.Status = 'Cancelled'
                                      And Ed.Cancel_Reason = 'Low Enrollment'))
                             And Substring(Ed.Course_Code, 5,  1) = 'C'
                             And Ed.Ops_Country = 'Usa'
                  Group By   Ed.Ops_Country,
                             Cd.Course_Code,
                             Cd.Course_Pl,
                             Cd.Course_Mod,
                             Cd.Course_Ch,
                             Cd.Course_Type,
                             Cd.Short_Name) Q
              On     Ed.Ops_Country = Q.Ops_Country
                 And Cd.Course_Code = Q.Course_Code
                 And Cd.Course_Mod = Q.Course_Mod
      Where   Ed.Start_Date Between Cast(Getutcdate() As Date) - 365 And Cast(Getutcdate() As Date)
              And (Ed.Status In ('Verified', 'Open')
                   Or (Ed.Status = 'Cancelled'
                       And Ed.Cancel_Reason = 'Low Enrollment'))
              And Substring(Ed.Course_Code, 5,  1) = 'C'
              And Ed.Ops_Country = 'Usa'
   Group By   Ed.Ops_Country,
              Cd.Course_Code,
              Cd.Course_Pl,
              Cd.Course_Mod,
              Cd.Course_Ch,
              Cd.Course_Type,
              Cd.Short_Name,
              Ed.Facility_Region_Metro,
              Q.Total_Course
   ;



