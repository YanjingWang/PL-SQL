


Create Or Alter View Hold.Gk_Sched_Plan_V
(
   Year_Offset,
   Dim_Year,
   Dim_Qtr,
   Dim_Month,
   Course_Id,
   Course_Code,
   Short_Name,
   Course_Pl,
   Course_Mod,
   Course_Type,
   Event_Id,
   Ops_Country,
   Metro,
   Metro_Tier,
   Tzabbreviation,
   Connected_C,
   Connected_V,
   Sales_Request,
   Ev_Sched,
   Ev_Run,
   Ev_Canc,
   Ev_Stud,
   Freq_Weeks
)
As
   Select   1 Year_Offset,
            Td.Dim_Year,
            Td.Dim_Year + '-' + Td.Dim_Quarter Dim_Qtr,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
            Cd.Course_Id,
            Cd.Course_Code,
            Cd.Short_Name + '(' + Cd.Course_Code + ')' Short_Name,
            Cd.Course_Pl,
            Cd.Course_Mod,
            Cd.Course_Type,
            Ed.Event_Id,
            Ed.Ops_Country,
            Ed.Facility_Region_Metro Metro,
            Case
               When Ed.Facility_Region_Metro In
                          ('Ott',
                           'Tor',
                           'Van',
                           'Mtl',
                           'Nyc',
                           'Was',
                           'Mrs',
                           'Dal',
                           'Chi',
                           'Snj',
                           'Rtp',
                           'Atl')
               Then
                  1
               When Ed.Facility_Region_Metro In ('Bos', 'Clb', 'Hou', 'Los')
               Then
                  2
               When Ed.Facility_Region_Metro In ('Vcl')
               Then
                  0
               Else
                  3
            End
               Metro_Tier,
            Ez.Tzabbreviation,
            Isnull(Ed.Connected_C, 'N') Connected_C,
            Case When Ed.Connected_V_To_C Is Not Null Then 'Y' Else 'N' End
               Connected_V,
            Case When Ed.Plan_Type = 'Sales Request' Then 'Y' Else 'N' End
               Sales_Request,
            1 Ev_Sched,
            Case When Ed.Status != 'Cancelled' Then 1 Else 0 End Ev_Run,
            Case When Ed.Status = 'Cancelled' Then 1 Else 0 End Ev_Canc,
            Isnull(Oa.Enroll_Cnt, 0) Ev_Stud,
            Cf.Freq_Weeks
     From                     Gkdw.Event_Dim Ed
                           Inner Join
                              Gkdw.Course_Dim Cd
                           On Ed.Course_Id = Cd.Course_Id
                              And Ed.Ops_Country = Cd.Country
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Ed.Start_Date = Td.Dim_Date
                     Inner Join
                        Gkdw.Gk_Sched_Course_Freq_V Cf
                     On     Ed.Course_Id = Cf.Course_Id
                        And Ed.Ops_Country = Cf.Ops_Country
                        And Cf.Year_Offset = 0
                  Left Outer Join
                     Gkdw.Gk_Oe_Attended_Cnt_V Oa
                  On Ed.Event_Id = Oa.Event_Id
               Left Outer Join
                  Base.Evxevent Ee
               On Ed.Event_Id = Ee.Evxeventid
            Left Outer Join
               Base.Evxtimezone Ez
            On Ee.Evxtimezoneid = Ez.Evxtimezoneid
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
   Union
   Select   1 Year_Offset,
            Td.Dim_Year,
            Td.Dim_Year + '-' + Td.Dim_Quarter Dim_Qtr,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
            Cd.Course_Id,
            Cd.Course_Code,
            Cd.Short_Name + '(' + Cd.Course_Code + ')' Short_Name,
            Cd.Course_Pl,
            Cd.Course_Mod,
            Cd.Course_Type,
            Sp.Event_Id,
            Sp.Ops_Country,
            'Vcl' Metro,
            0 Metro_Tier,
            'Est' Tzabbreviation,
            'N' Connected_C,
            Sp.Connected_V,
            Sp.Sales_Request,
            Sp.Ev_Sched,
            Sp.Ev_Run,
            Sp.Ev_Canc,
            Sp.Ev_Stud,
            Cf.Freq_Weeks
     From            Gkdw.Gk_Vcl_Sched_Plan_V Sp
                  Inner Join
                     Gkdw.Course_Dim Cd
                  On Sp.Course_Id = Cd.Course_Id
                     And Cd.Country = Sp.Ops_Country
               Inner Join
                  Gkdw.Time_Dim Td
               On Sp.Start_Date = Td.Dim_Date
            Inner Join
               Gkdw.Gk_Sched_Course_Freq_V Cf
            On     Sp.Course_Id = Cf.Course_Id
               And Sp.Ops_Country = Cf.Ops_Country
               And Cf.Year_Offset = 0
    Where   Sp.Start_Date > Cast(Getutcdate() As Date)
            And Sp.Start_Date <= Cast(Getutcdate() As Date) + 365
            And Substring(Cd.Course_Code, 1,  4) Not In
                     ('9983', '9984', '9989', '9992', '9995')
            And Cd.Ch_Num = '10'
            And Cd.Md_Num = '20'
   Union
   Select   0 Year_Offset,
            Td.Dim_Year,
            Td.Dim_Year + '-' + Td.Dim_Quarter Dim_Qtr,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
            Cd.Course_Id,
            Cd.Course_Code,
            Cd.Short_Name + '(' + Cd.Course_Code + ')' Short_Name,
            Cd.Course_Pl,
            Cd.Course_Mod,
            Cd.Course_Type,
            Ed.Event_Id,
            Ed.Ops_Country,
            Ed.Facility_Region_Metro Metro,
            Case
               When Ed.Facility_Region_Metro In
                          ('Ott',
                           'Tor',
                           'Van',
                           'Mtl',
                           'Nyc',
                           'Was',
                           'Mrs',
                           'Dal',
                           'Chi',
                           'Snj',
                           'Rtp',
                           'Atl')
               Then
                  1
               When Ed.Facility_Region_Metro In ('Bos', 'Clb', 'Hou', 'Los')
               Then
                  2
               When Ed.Facility_Region_Metro In ('Vcl')
               Then
                  0
               Else
                  3
            End
               Metro_Tier,
            Ez.Tzabbreviation,
            Isnull(Ed.Connected_C, 'N') Connected_C,
            Case When Ed.Connected_V_To_C Is Not Null Then 'Y' Else 'N' End
               Connected_V,
            Case When Ed.Plan_Type = 'Sales Request' Then 'Y' Else 'N' End
               Sales_Request,
            1 Ev_Sched,
            Case When Ed.Status != 'Cancelled' Then 1 Else 0 End Ev_Run,
            Case When Ed.Status = 'Cancelled' Then 1 Else 0 End Ev_Canc,
            Isnull(Oa.Enroll_Cnt, 0) Ev_Stud,
            Cf.Freq_Weeks
     From                     Gkdw.Event_Dim Ed
                           Inner Join
                              Gkdw.Course_Dim Cd
                           On Ed.Course_Id = Cd.Course_Id
                              And Ed.Ops_Country = Cd.Country
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Ed.Start_Date = Td.Dim_Date
                     Inner Join
                        Gkdw.Gk_Sched_Course_Freq_V Cf
                     On     Ed.Course_Id = Cf.Course_Id
                        And Ed.Ops_Country = Cf.Ops_Country
                        And Cf.Year_Offset = 0
                  Left Outer Join
                     Gkdw.Gk_Oe_Attended_Cnt_V Oa
                  On Ed.Event_Id = Oa.Event_Id
               Left Outer Join
                  Base.Evxevent Ee
               On Ed.Event_Id = Ee.Evxeventid
            Left Outer Join
               Base.Evxtimezone Ez
            On Ee.Evxtimezoneid = Ez.Evxtimezoneid
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
   Union
   Select   0 Year_Offset,
            Td.Dim_Year,
            Td.Dim_Year + '-' + Td.Dim_Quarter Dim_Qtr,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
            Cd.Course_Id,
            Cd.Course_Code,
            Cd.Short_Name + '(' + Cd.Course_Code + ')' Short_Name,
            Cd.Course_Pl,
            Cd.Course_Mod,
            Cd.Course_Type,
            Sp.Event_Id,
            Sp.Ops_Country,
            'Vcl' Metro,
            0 Metro_Tier,
            'Est' Tzabbreviation,
            'N' Connected_C,
            Sp.Connected_V,
            Sp.Sales_Request,
            Sp.Ev_Sched,
            Sp.Ev_Run,
            Sp.Ev_Canc,
            Sp.Ev_Stud,
            Cf.Freq_Weeks
     From            Gkdw.Gk_Vcl_Sched_Plan_V Sp
                  Inner Join
                     Gkdw.Course_Dim Cd
                  On Sp.Course_Id = Cd.Course_Id
                     And Cd.Country = Sp.Ops_Country
               Inner Join
                  Gkdw.Time_Dim Td
               On Sp.Start_Date = Td.Dim_Date
            Inner Join
               Gkdw.Gk_Sched_Course_Freq_V Cf
            On     Sp.Course_Id = Cf.Course_Id
               And Sp.Ops_Country = Cf.Ops_Country
               And Cf.Year_Offset = 0
    Where   Sp.Start_Date > Cast(Getutcdate() As Date) - 365
            And Sp.Start_Date <= Cast(Getutcdate() As Date)
            And Substring(Cd.Course_Code, 1,  4) Not In
                     ('9983', '9984', '9989', '9992', '9995')
            And Cd.Ch_Num = '10'
            And Cd.Md_Num = '20'
   Union
   Select   -1 Year_Offset,
            Td.Dim_Year,
            Td.Dim_Year + '-' + Td.Dim_Quarter Dim_Qtr,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
            Cd.Course_Id,
            Cd.Course_Code,
            Cd.Short_Name + '(' + Cd.Course_Code + ')' Short_Name,
            Cd.Course_Pl,
            Cd.Course_Mod,
            Cd.Course_Type,
            Ed.Event_Id,
            Ed.Ops_Country,
            Ed.Facility_Region_Metro Metro,
            Case
               When Ed.Facility_Region_Metro In
                          ('Ott',
                           'Tor',
                           'Van',
                           'Mtl',
                           'Nyc',
                           'Was',
                           'Mrs',
                           'Dal',
                           'Chi',
                           'Snj',
                           'Rtp',
                           'Atl')
               Then
                  1
               When Ed.Facility_Region_Metro In ('Bos', 'Clb', 'Hou', 'Los')
               Then
                  2
               When Ed.Facility_Region_Metro In ('Vcl')
               Then
                  0
               Else
                  3
            End
               Metro_Tier,
            Ez.Tzabbreviation,
            Isnull(Ed.Connected_C, 'N') Connected_C,
            Case When Ed.Connected_V_To_C Is Not Null Then 'Y' Else 'N' End
               Connected_V,
            Case When Ed.Plan_Type = 'Sales Request' Then 'Y' Else 'N' End
               Sales_Request,
            1 Ev_Sched,
            Case When Ed.Status != 'Cancelled' Then 1 Else 0 End Ev_Run,
            Case When Ed.Status = 'Cancelled' Then 1 Else 0 End Ev_Canc,
            Isnull(Oa.Enroll_Cnt, 0) Ev_Stud,
            Cf.Freq_Weeks
     From                     Gkdw.Event_Dim Ed
                           Inner Join
                              Gkdw.Course_Dim Cd
                           On Ed.Course_Id = Cd.Course_Id
                              And Ed.Ops_Country = Cd.Country
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Ed.Start_Date = Td.Dim_Date
                     Inner Join
                        Gkdw.Gk_Sched_Course_Freq_V Cf
                     On     Ed.Course_Id = Cf.Course_Id
                        And Ed.Ops_Country = Cf.Ops_Country
                        And Cf.Year_Offset = 0
                  Left Outer Join
                     Gkdw.Gk_Oe_Attended_Cnt_V Oa
                  On Ed.Event_Id = Oa.Event_Id
               Left Outer Join
                  Base.Evxevent Ee
               On Ed.Event_Id = Ee.Evxeventid
            Left Outer Join
               Base.Evxtimezone Ez
            On Ee.Evxtimezoneid = Ez.Evxtimezoneid
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
   Union
   Select   -1 Year_Offset,
            Td.Dim_Year,
            Td.Dim_Year + '-' + Td.Dim_Quarter Dim_Qtr,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
            Cd.Course_Id,
            Cd.Course_Code,
            Cd.Short_Name + '(' + Cd.Course_Code + ')' Short_Name,
            Cd.Course_Pl,
            Cd.Course_Mod,
            Cd.Course_Type,
            Sp.Event_Id,
            Sp.Ops_Country,
            'Vcl' Metro,
            0 Metro_Tier,
            'Est' Tzabbreviation,
            'N' Connected_C,
            Sp.Connected_V,
            Sp.Sales_Request,
            Sp.Ev_Sched,
            Sp.Ev_Run,
            Sp.Ev_Canc,
            Sp.Ev_Stud,
            Cf.Freq_Weeks
     From            Gkdw.Gk_Vcl_Sched_Plan_V Sp
                  Inner Join
                     Gkdw.Course_Dim Cd
                  On Sp.Course_Id = Cd.Course_Id
                     And Cd.Country = Sp.Ops_Country
               Inner Join
                  Gkdw.Time_Dim Td
               On Sp.Start_Date = Td.Dim_Date
            Inner Join
               Gkdw.Gk_Sched_Course_Freq_V Cf
            On     Sp.Course_Id = Cf.Course_Id
               And Sp.Ops_Country = Cf.Ops_Country
               And Cf.Year_Offset = 0
    Where   Sp.Start_Date > Cast(Getutcdate() As Date) - 730
            And Sp.Start_Date <= Cast(Getutcdate() As Date) - 365
            And Substring(Cd.Course_Code, 1,  4) Not In
                     ('9983', '9984', '9989', '9992', '9995')
            And Cd.Ch_Num = '10'
            And Cd.Md_Num = '20'
   Union
   Select   -2 Year_Offset,
            Td.Dim_Year,
            Td.Dim_Year + '-' + Td.Dim_Quarter Dim_Qtr,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
            Cd.Course_Id,
            Cd.Course_Code,
            Cd.Short_Name + '(' + Cd.Course_Code + ')' Short_Name,
            Cd.Course_Pl,
            Cd.Course_Mod,
            Cd.Course_Type,
            Ed.Event_Id,
            Ed.Ops_Country,
            Ed.Facility_Region_Metro Metro,
            Case
               When Ed.Facility_Region_Metro In
                          ('Ott',
                           'Tor',
                           'Van',
                           'Mtl',
                           'Nyc',
                           'Was',
                           'Mrs',
                           'Dal',
                           'Chi',
                           'Snj',
                           'Rtp',
                           'Atl')
               Then
                  1
               When Ed.Facility_Region_Metro In ('Bos', 'Clb', 'Hou', 'Los')
               Then
                  2
               When Ed.Facility_Region_Metro In ('Vcl')
               Then
                  0
               Else
                  3
            End
               Metro_Tier,
            Ez.Tzabbreviation,
            Isnull(Ed.Connected_C, 'N') Connected_C,
            Case When Ed.Connected_V_To_C Is Not Null Then 'Y' Else 'N' End
               Connected_V,
            Case When Ed.Plan_Type = 'Sales Request' Then 'Y' Else 'N' End
               Sales_Request,
            1 Ev_Sched,
            Case When Ed.Status != 'Cancelled' Then 1 Else 0 End Ev_Run,
            Case When Ed.Status = 'Cancelled' Then 1 Else 0 End Ev_Canc,
            Isnull(Oa.Enroll_Cnt, 0) Ev_Stud,
            Cf.Freq_Weeks
     From                     Gkdw.Event_Dim Ed
                           Inner Join
                              Gkdw.Course_Dim Cd
                           On Ed.Course_Id = Cd.Course_Id
                              And Ed.Ops_Country = Cd.Country
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Ed.Start_Date = Td.Dim_Date
                     Inner Join
                        Gkdw.Gk_Sched_Course_Freq_V Cf
                     On     Ed.Course_Id = Cf.Course_Id
                        And Ed.Ops_Country = Cf.Ops_Country
                        And Cf.Year_Offset = 0
                  Left Outer Join
                     Gkdw.Gk_Oe_Attended_Cnt_V Oa
                  On Ed.Event_Id = Oa.Event_Id
               Left Outer Join
                  Base.Evxevent Ee
               On Ed.Event_Id = Ee.Evxeventid
            Left Outer Join
               Base.Evxtimezone Ez
            On Ee.Evxtimezoneid = Ez.Evxtimezoneid
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
   Union
   Select   -2 Year_Offset,
            Td.Dim_Year,
            Td.Dim_Year + '-' + Td.Dim_Quarter Dim_Qtr,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
            Cd.Course_Id,
            Cd.Course_Code,
            Cd.Short_Name + '(' + Cd.Course_Code + ')' Short_Name,
            Cd.Course_Pl,
            Cd.Course_Mod,
            Cd.Course_Type,
            Sp.Event_Id,
            Sp.Ops_Country,
            'Vcl' Metro,
            0 Metro_Tier,
            'Est' Tzabbreviation,
            'N' Connected_C,
            Sp.Connected_V,
            Sp.Sales_Request,
            Sp.Ev_Sched,
            Sp.Ev_Run,
            Sp.Ev_Canc,
            Sp.Ev_Stud,
            Cf.Freq_Weeks
     From            Gkdw.Gk_Vcl_Sched_Plan_V Sp
                  Inner Join
                     Gkdw.Course_Dim Cd
                  On Sp.Course_Id = Cd.Course_Id
                     And Cd.Country = Sp.Ops_Country
               Inner Join
                  Gkdw.Time_Dim Td
               On Sp.Start_Date = Td.Dim_Date
            Inner Join
               Gkdw.Gk_Sched_Course_Freq_V Cf
            On     Sp.Course_Id = Cf.Course_Id
               And Sp.Ops_Country = Cf.Ops_Country
               And Cf.Year_Offset = 0
    Where   Sp.Start_Date > Cast(Getutcdate() As Date) - 1095
            And Sp.Start_Date <= Cast(Getutcdate() As Date) - 730
            And Substring(Cd.Course_Code, 1,  4) Not In
                     ('9983', '9984', '9989', '9992', '9995')
            And Cd.Ch_Num = '10'
            And Cd.Md_Num = '20'
   ;



