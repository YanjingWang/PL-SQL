


Create Or Alter View Hold.Gk_Terillian_Events_V
(
   Course_Id,
   Course_Code,
   Class_Id,
   Event_Name,
   Status,
   Location_Id,
   Company_Id,
   Maxseats,
   Minseat,
   Connected_C,
   Connected_V_To_C,
   Start_Time,
   End_Time,
   Start_Date,
   End_Date,
   Tzgenericname,
   Country,
   [Manufacturer_Custom_Code],
   Terillian_Course_Code,
   Md_Num
)
As
   Select   Distinct
            Ed.Course_Id,
            Ed.Course_Code,
            Ed.Event_Id Class_Id,
            Ed.Event_Name,
            Ed.Status,
            Ed.Location_Id,
            Null Company_Id,
            Ed.Capacity Maxseats,
            Ee.Minenrollment Minseat,
            Ed.Connected_C,
            Ed.Connected_V_To_C,
            Ed.Start_Time,
            Ed.End_Time,
            Ed.Start_Date,
            Ed.End_Date,
            Tz.[Tzgenericname],
            Ed.Country,
            S.[Manufacturer_Custom_Code],
            Case (Substring(Course_Code, 1,  4))
               When '7016' Then S.[Manufacturer_Custom_Code]
               Else Ed.Course_Code
            End
               Terillian_Course_Code,
            Cd.Md_Num
     From                     Gkdw.Event_Dim Ed
                           Join
                              Gkdw.Evxevent Ee
                           On Ed.Event_Id = Ee.Evxeventid
                        Left Join
                           Base.Rms_Schedule S
                        On S.[Slx_Id] = Ed.Event_Id
                     Left Join
                        Base.Rms_Location_Func Lf
                     On S.[Location_Func] = Lf.[Id]
                  Left Join
                     Base.Rms_Slx_Timezone Tz
                  On Lf.[Timezone] = Tz.[Off_Set]
               Left Join
                  Base.Rms_Lab_Courses Lc
               On Lc.[Product] = S.[Product]
            Inner Join
               Gkdw.Course_Dim Cd
            On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
    Where   Lc.[Lab] = 293 And Ed.Course_Code <> '9995V'
            And Substring(Cd.Course_Code, Len(Cd.Course_Code),  1) In
                     ('C', 'L', 'N', 'V', 'B', 'Z', 'E')      -- Sr 02/14/2019
--   Or Ed.Event_Id = 'Q6uj9as5xw2t'
--   Union                   /** Non Ms Train The Trainer Courses *************/
--   Select Distinct
--          Ed.Course_Id,
--          Ed.Course_Code,
--          Ed.Event_Id Class_Id,
--          Ed.Event_Name,
--          Ed.Status,
--          Ed.Location_Id,
--          Null Company_Id,
--          Ed.Capacity Maxseats,
--          Ee.Minenrollment Minseat,
--          Ed.Connected_C,
--          Ed.Connected_V_To_C,
--          Ed.Start_Time,
--          Ed.End_Time,
--          Ed.Start_Date,
--          Ed.End_Date,
--          Tz.[Tzgenericname],
--          Ed.Country,
--          S.[Manufacturer_Custom_Code],
--          Case (Substring(Course_Code, 1,  4))
--             When '7016' Then S.[Manufacturer_Custom_Code]
--             Else Ed.Course_Code
--          End
--             Terillian_Course_Code,
--          Cd.Md_Num
--     From Gkdw.Event_Dim Ed
--          Join Gkdw.Evxevent Ee On Ed.Event_Id = Ee.Evxeventid
--          Left Join Base.Rms_Schedule S On S.[Slx_Id] = Ed.Event_Id
--          Left Join Base.Rms_Location_Func Lf
--             On S.[Location_Func] = Lf.[Id]
--          Left Join Base.Rms_Slx_Timezone Tz
--             On Lf.[Timezone] = Tz.[Off_Set]
--          Inner Join Gkdw.Course_Dim Cd
--             On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
--    Where     (Substring(Course_Code, 1,  4) In ('3326',
--                                              '3405',
--                                              '3410',
--                                              '3411',
--                                              '9995'))
--          And Ed.Course_Code <> '9995V'
--   Union
--   /*** Virtual Events With A Mygk Course Profile ***/
--   Select Distinct
--          Ed.Course_Id,
--          Ed.Course_Code,
--          Ed.Event_Id Class_Id,
--          Ed.Event_Name,
--          Ed.Status,
--          Ed.Location_Id,
--          Null Company_Id,
--          Ed.Capacity Maxseats,
--          Ee.Minenrollment Minseat,
--          Ed.Connected_C,
--          Ed.Connected_V_To_C,
--          Ed.Start_Time,
--          Ed.End_Time,
--          Ed.Start_Date,
--          Ed.End_Date,
--          Tz.[Tzgenericname] Tzgenericname,
--          Ed.Country,
--          S.[Manufacturer_Custom_Code] Manufacturer_Custom_Code,
--          Case
--             When Substring(Course_Code, 1,  4) = '7016'
--             Then
--                S.[Manufacturer_Custom_Code]
--             Else
--                Ed.Course_Code
--          End
--             Terillian_Course_Code,
--          Cd.Md_Num
--     From Gkdw.Event_Dim Ed
--          Inner Join Gkdw.Gk_Mygk_Course_Profile_V P
--             On Ed.Course_Code = P.Course_Code
--          Inner Join Gkdw.Evxevent Ee On Ed.Event_Id = Ee.Evxeventid
--          Left Outer Join Base.Rms_Schedule S On S.[Slx_Id] = Ed.Event_Id
--          Left Outer Join Base.Rms_Location_Func Lf
--             On S.[Location_Func] = Lf.[Id]
--          Inner Join Base.Rms_Slx_Timezone Tz
--             On Lf.[Timezone] = Tz.[Off_Set]
--          Inner Join Gkdw.Course_Dim Cd
--             On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
--    Where     Cd.Md_Num In ('20', '32', '21')
--          And Not Exists
--                 (Select 1
--                    From Gkdw.Course_Dim Cd2
--                   Where     Cd2.Course_Code = Ed.Course_Code
--                         And Cd2.Course_Code In ('9995V',
--                                                 '100098N',
--                                                 '100098V',
--                                                 '282575W',
--                                                 '283520W',
--                                                 '283901W',
--                                                 '283901W',
--                                                 '283901W',
--                                                 '283901W',
--                                                 '283913W',
--                                                 '283913W',
--                                                 '283913W',
--                                                 '283913W',
--                                                 '283918W',
--                                                 '283918W',
--                                                 '283918W',
--                                                 '283918W',
--                                                 '283918W'))
/*** Classroom Events With A Mygk Course Profile With A Connected Virtual ***/
--   Union
--   Select Distinct
--          Ed.Course_Id,
--          Ed.Course_Code,
--          Ed.Event_Id Class_Id,
--          Ed.Event_Name,
--          Ed.Status,
--          Ed.Location_Id,
--          Null Company_Id,
--          Ed.Capacity Maxseats,
--          Ee.Minenrollment Minseat,
--          Ed.Connected_C,
--          Ed.Connected_V_To_C,
--          Ed.Start_Time,
--          Ed.End_Time,
--          Ed.Start_Date,
--          Ed.End_Date,
--          Tz.[Tzgenericname] Tzgenericname,
--          Ed.Country,
--          S.[Manufacturer_Custom_Code] Manufacturer_Custom_Code,
--          Case
--             When Substring(Course_Code, 1,  4) = '7016'
--             Then
--                S.[Manufacturer_Custom_Code]
--             Else
--                Ed.Course_Code
--          End
--             Terillian_Course_Code,
--          Cd.Md_Num
--     From Gkdw.Event_Dim Ed2
--          Inner Join Gkdw.Event_Dim Ed On Ed2.Connected_V_To_C = Ed.Event_Id
--          Inner Join Gkdw.Gk_Mygk_Course_Profile_V P
--             On Ed.Course_Code = P.Course_Code
--          Inner Join Gkdw.Evxevent Ee On Ed.Event_Id = Ee.Evxeventid
--          Left Outer Join Base.Rms_Schedule S On S.[Slx_Id] = Ed.Event_Id
--          Left Outer Join Base.Rms_Location_Func Lf
--             On S.[Location_Func] = Lf.[Id]
--          Inner Join Base.Rms_Slx_Timezone Tz
--             On Lf.[Timezone] = Tz.[Off_Set]
--          Inner Join Gkdw.Course_Dim Cd
--             On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
--    Where     Cd.Md_Num = '10'
--          And (   Not Exists
--                     (Select 1
--                        From Gkdw.Course_Dim Cd2
--                       Where     Cd2.Course_Code = Ed2.Course_Code
--                             And Cd2.Course_Code In ('9995V',
--                                                     '100098N',
--                                                     '100098V'))
--               Or Substr (Course_Code, 0, Length (Cd.Course_Code) - 1) > 4);;



