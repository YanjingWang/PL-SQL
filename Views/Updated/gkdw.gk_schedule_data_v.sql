


Create Or Alter View Hold.Gk_Schedule_Data_V
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
   Ops_Country,
   Metro,
   Metro_Tier,
   Connected_C,
   Connected_V,
   Ev_Sched,
   Ev_Run,
   Ev_Canc,
   Ev_Stud
)
As
     Select   0 Year_Offset,
              Td.Dim_Year,
              Td.Dim_Year + '-' + Td.Dim_Quarter Dim_Qtr,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
              Cd.Course_Id,
              Cd.Course_Code,
              Cd.Short_Name,
              Cd.Course_Pl,
              Cd.Course_Mod,
              Cd.Course_Type,
              Ed.Ops_Country,
              Ed.Facility_Region_Metro Metro,
              Case
                 When Ed.Facility_Region_Metro In
                            ('Mtl',
                             'Tor',
                             'Van',
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
              Isnull(Ed.Connected_C, 'N') Connected_C,
              Case When Ed.Connected_V_To_C Is Not Null Then 'Y' Else 'N' End
                 Connected_V,
              Count (Distinct Ed.Event_Id) Ev_Sched,
              Sum (Case When Ed.Status != 'Cancelled' Then 1 Else 0 End) Ev_Run,
              Sum (Case When Ed.Status = 'Cancelled' Then 1 Else 0 End) Ev_Canc,
              Isnull(Sum (Oa.Enroll_Cnt), 0) Ev_Stud
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Left Outer Join
                 Gkdw.Gk_Oe_Attended_Cnt_V Oa
              On Ed.Event_Id = Oa.Event_Id
      Where   Ed.Start_Date > Cast(Getutcdate() As Date) - 365
              And Ed.Start_Date <= Cast(Getutcdate() As Date)
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('9983', '9984', '9989', '9992', '9995')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20')
   Group By   Td.Dim_Year,
              Td.Dim_Year + '-' + Td.Dim_Quarter,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0'),
              Cd.Course_Id,
              Cd.Course_Code,
              Cd.Short_Name,
              Cd.Course_Pl,
              Cd.Course_Mod,
              Cd.Course_Type,
              Ed.Ops_Country,
              Ed.Facility_Region_Metro,
              Location_Name,
              Ed.Connected_C,
              Ed.Connected_V_To_C
   Union
     Select   -1 Year_Offset,
              Td.Dim_Year,
              Td.Dim_Year + '-' + Td.Dim_Quarter Dim_Qtr,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
              Cd.Course_Id,
              Cd.Course_Code,
              Cd.Short_Name,
              Cd.Course_Pl,
              Cd.Course_Mod,
              Cd.Course_Type,
              Ed.Ops_Country,
              Ed.Facility_Region_Metro Metro,
              Case
                 When Ed.Facility_Region_Metro In
                            ('Mtl',
                             'Tor',
                             'Van',
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
              Isnull(Ed.Connected_C, 'N') Connected_C,
              Case When Ed.Connected_V_To_C Is Not Null Then 'Y' Else 'N' End
                 Connected_V,
              Count (Distinct Ed.Event_Id) Ev_Sched,
              Sum (Case When Ed.Status != 'Cancelled' Then 1 Else 0 End) Ev_Run,
              Sum (Case When Ed.Status = 'Cancelled' Then 1 Else 0 End) Ev_Canc,
              Isnull(Sum (Oa.Enroll_Cnt), 0) Ev_Stud
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Left Outer Join
                 Gkdw.Gk_Oe_Attended_Cnt_V Oa
              On Ed.Event_Id = Oa.Event_Id
      Where   Ed.Start_Date > Cast(Getutcdate() As Date) - 730
              And Ed.Start_Date <= Cast(Getutcdate() As Date) - 365
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('9983', '9984', '9989', '9992', '9995')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20')
   Group By   Td.Dim_Year,
              Td.Dim_Year + '-' + Td.Dim_Quarter,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0'),
              Cd.Course_Id,
              Cd.Course_Code,
              Cd.Short_Name,
              Cd.Course_Pl,
              Cd.Course_Mod,
              Cd.Course_Type,
              Ed.Ops_Country,
              Ed.Facility_Region_Metro,
              Location_Name,
              Ed.Connected_C,
              Ed.Connected_V_To_C
   Union
     Select   -2 Year_Offset,
              Td.Dim_Year,
              Td.Dim_Year + '-' + Td.Dim_Quarter Dim_Qtr,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
              Cd.Course_Id,
              Cd.Course_Code,
              Cd.Short_Name,
              Cd.Course_Pl,
              Cd.Course_Mod,
              Cd.Course_Type,
              Ed.Ops_Country,
              Ed.Facility_Region_Metro Metro,
              Case
                 When Ed.Facility_Region_Metro In
                            ('Mtl',
                             'Tor',
                             'Van',
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
              Isnull(Ed.Connected_C, 'N') Connected_C,
              Case When Ed.Connected_V_To_C Is Not Null Then 'Y' Else 'N' End
                 Connected_V,
              Count (Distinct Ed.Event_Id) Ev_Sched,
              Sum (Case When Ed.Status != 'Cancelled' Then 1 Else 0 End) Ev_Run,
              Sum (Case When Ed.Status = 'Cancelled' Then 1 Else 0 End) Ev_Canc,
              Isnull(Sum (Oa.Enroll_Cnt), 0) Ev_Stud
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Left Outer Join
                 Gkdw.Gk_Oe_Attended_Cnt_V Oa
              On Ed.Event_Id = Oa.Event_Id
      Where   Ed.Start_Date > Cast(Getutcdate() As Date) - 1095
              And Ed.Start_Date <= Cast(Getutcdate() As Date) - 730
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('9983', '9984', '9989', '9992', '9995')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20')
   Group By   Td.Dim_Year,
              Td.Dim_Year + '-' + Td.Dim_Quarter,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0'),
              Cd.Course_Id,
              Cd.Course_Code,
              Cd.Short_Name,
              Cd.Course_Pl,
              Cd.Course_Mod,
              Cd.Course_Type,
              Ed.Ops_Country,
              Ed.Facility_Region_Metro,
              Location_Name,
              Ed.Connected_C,
              Ed.Connected_V_To_C
   ;



