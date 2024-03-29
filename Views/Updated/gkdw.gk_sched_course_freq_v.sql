


Create Or Alter View Hold.Gk_Sched_Course_Freq_V
(
   Year_Offset,
   Ops_Country,
   Course_Id,
   Course_Code,
   Event_Sched_Cnt,
   Weeks_Sched,
   Freq_Weeks
)
As
     Select   1 Year_Offset,
              Ops_Country,
              Ed.Course_Id,
              Ed.Course_Code,
              Count (Distinct Event_Id) Event_Sched_Cnt,
              Ceil (Months_Between (Max (Start_Date), Min (Start_Date)) + 1)
              * 4
                 Weeks_Sched,
              Round (
                 (Ceil (
                     Months_Between (Max (Start_Date), Min (Start_Date)) + 1
                  )
                  * 4)
                 / (Count (Distinct Event_Id)),
                 2
              )
                 Freq_Weeks
       From      Gkdw.Event_Dim Ed
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Ed.Start_Date > Cast(Getutcdate() As Date)
              And Ed.Start_Date <= Cast(Getutcdate() As Date) + 365
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('9983', '9984', '9989', '9992', '9995')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '10'
              And Isnull(Replace (Ed.Cancel_Reason, Chr (13), ''), 'None') Not In
                       ('Course Delays - Equipment, Devel',
                        'Course Discontinued',
                        'Course Version Update',
                        'Event In Error',
                        'Event Postponed Due To Acts Of N',
                        'Os Xl - Rescheduled Due To Holid',
                        'Pre-Cancel (Market/Schedule Righ')
   Group By   Ops_Country, Ed.Course_Id, Ed.Course_Code
   Union
     Select   1 Year_Offset,
              Ops_Country,
              Ed.Course_Id,
              Ed.Course_Code,
              Count (Distinct Event_Id) Event_Sched_Cnt,
              Ceil (Months_Between (Max (Start_Date), Min (Start_Date)) + 1)
              * 4
                 Weeks_Sched,
              Round (
                 (Ceil (
                     Months_Between (Max (Start_Date), Min (Start_Date)) + 1
                  )
                  * 4)
                 / (Count (Distinct Event_Id)),
                 2
              )
                 Freq_Weeks
       From      Gkdw.Gk_Vcl_Sched_Plan_V Ed
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Ed.Start_Date > Cast(Getutcdate() As Date)
              And Ed.Start_Date <= Cast(Getutcdate() As Date) + 365
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('9983', '9984', '9989', '9992', '9995')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '20'
   Group By   Ops_Country, Ed.Course_Id, Ed.Course_Code
   Union
     Select   0 Year_Offset,
              Ops_Country,
              Ed.Course_Id,
              Ed.Course_Code,
              Count (Distinct Event_Id) Event_Sched_Cnt,
              Ceil (Months_Between (Max (Start_Date), Min (Start_Date)) + 1)
              * 4
                 Weeks_Sched,
              Round (
                 (Ceil (
                     Months_Between (Max (Start_Date), Min (Start_Date)) + 1
                  )
                  * 4)
                 / (Count (Distinct Event_Id)),
                 2
              )
                 Freq_Weeks
       From      Gkdw.Event_Dim Ed
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Ed.Start_Date > Cast(Getutcdate() As Date) - 365
              And Ed.Start_Date <= Cast(Getutcdate() As Date)
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('9983', '9984', '9989', '9992', '9995')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '10'
              And Isnull(Replace (Ed.Cancel_Reason, Chr (13), ''), 'None') Not In
                       ('Course Delays - Equipment, Devel',
                        'Course Discontinued',
                        'Course Version Update',
                        'Event In Error',
                        'Event Postponed Due To Acts Of N',
                        'Os Xl - Rescheduled Due To Holid',
                        'Pre-Cancel (Market/Schedule Righ')
   Group By   Ops_Country, Ed.Course_Id, Ed.Course_Code
   Union
     Select   0 Year_Offset,
              Ops_Country,
              Ed.Course_Id,
              Ed.Course_Code,
              Count (Distinct Event_Id) Event_Sched_Cnt,
              Ceil (Months_Between (Max (Start_Date), Min (Start_Date)) + 1)
              * 4
                 Weeks_Sched,
              Round (
                 (Ceil (
                     Months_Between (Max (Start_Date), Min (Start_Date)) + 1
                  )
                  * 4)
                 / (Count (Distinct Event_Id)),
                 2
              )
                 Freq_Weeks
       From      Gkdw.Gk_Vcl_Sched_Plan_V Ed
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Ed.Start_Date > Cast(Getutcdate() As Date) - 365
              And Ed.Start_Date <= Cast(Getutcdate() As Date)
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('9983', '9984', '9989', '9992', '9995')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '20'
   Group By   Ops_Country, Ed.Course_Id, Ed.Course_Code
   Union
     Select   -1 Year_Offset,
              Ops_Country,
              Ed.Course_Id,
              Ed.Course_Code,
              Count (Distinct Event_Id) Event_Sched_Cnt,
              Ceil (Months_Between (Max (Start_Date), Min (Start_Date)) + 1)
              * 4
                 Weeks_Sched,
              Round (
                 (Ceil (
                     Months_Between (Max (Start_Date), Min (Start_Date)) + 1
                  )
                  * 4)
                 / (Count (Distinct Event_Id)),
                 2
              )
                 Freq_Weeks
       From      Gkdw.Event_Dim Ed
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Ed.Start_Date > Cast(Getutcdate() As Date) - 730
              And Ed.Start_Date <= Cast(Getutcdate() As Date) - 365
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('9983', '9984', '9989', '9992', '9995')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '10'
              And Isnull(Replace (Ed.Cancel_Reason, Chr (13), ''), 'None') Not In
                       ('Course Delays - Equipment, Devel',
                        'Course Discontinued',
                        'Course Version Update',
                        'Event In Error',
                        'Event Postponed Due To Acts Of N',
                        'Os Xl - Rescheduled Due To Holid',
                        'Pre-Cancel (Market/Schedule Righ')
   Group By   Ops_Country, Ed.Course_Id, Ed.Course_Code
   Union
     Select   -1 Year_Offset,
              Ops_Country,
              Ed.Course_Id,
              Ed.Course_Code,
              Count (Distinct Event_Id) Event_Sched_Cnt,
              Ceil (Months_Between (Max (Start_Date), Min (Start_Date)) + 1)
              * 4
                 Weeks_Sched,
              Round (
                 (Ceil (
                     Months_Between (Max (Start_Date), Min (Start_Date)) + 1
                  )
                  * 4)
                 / (Count (Distinct Event_Id)),
                 2
              )
                 Freq_Weeks
       From      Gkdw.Gk_Vcl_Sched_Plan_V Ed
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Ed.Start_Date > Cast(Getutcdate() As Date) - 730
              And Ed.Start_Date <= Cast(Getutcdate() As Date) - 365
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('9983', '9984', '9989', '9992', '9995')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '20'
   Group By   Ops_Country, Ed.Course_Id, Ed.Course_Code
   Union
     Select   -2 Year_Offset,
              Ops_Country,
              Ed.Course_Id,
              Ed.Course_Code,
              Count (Distinct Event_Id) Event_Sched_Cnt,
              Ceil (Months_Between (Max (Start_Date), Min (Start_Date)) + 1)
              * 4
                 Weeks_Sched,
              Round (
                 (Ceil (
                     Months_Between (Max (Start_Date), Min (Start_Date)) + 1
                  )
                  * 4)
                 / (Count (Distinct Event_Id)),
                 2
              )
                 Freq_Weeks
       From      Gkdw.Event_Dim Ed
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Ed.Start_Date > Cast(Getutcdate() As Date) - 1095
              And Ed.Start_Date <= Cast(Getutcdate() As Date) - 730
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('9983', '9984', '9989', '9992', '9995')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '10'
              And Isnull(Replace (Ed.Cancel_Reason, Chr (13), ''), 'None') Not In
                       ('Course Delays - Equipment, Devel',
                        'Course Discontinued',
                        'Course Version Update',
                        'Event In Error',
                        'Event Postponed Due To Acts Of N',
                        'Os Xl - Rescheduled Due To Holid',
                        'Pre-Cancel (Market/Schedule Righ')
   Group By   Ops_Country, Ed.Course_Id, Ed.Course_Code
   Union
     Select   -2 Year_Offset,
              Ops_Country,
              Ed.Course_Id,
              Ed.Course_Code,
              Count (Distinct Event_Id) Event_Sched_Cnt,
              Ceil (Months_Between (Max (Start_Date), Min (Start_Date)) + 1)
              * 4
                 Weeks_Sched,
              Round (
                 (Ceil (
                     Months_Between (Max (Start_Date), Min (Start_Date)) + 1
                  )
                  * 4)
                 / (Count (Distinct Event_Id)),
                 2
              )
                 Freq_Weeks
       From      Gkdw.Gk_Vcl_Sched_Plan_V Ed
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Ed.Start_Date > Cast(Getutcdate() As Date) - 1095
              And Ed.Start_Date <= Cast(Getutcdate() As Date) - 730
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('9983', '9984', '9989', '9992', '9995')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '20'
   Group By   Ops_Country, Ed.Course_Id, Ed.Course_Code;



