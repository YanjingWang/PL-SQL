


Create Or Alter View Hold.Gk_Enrollment_Analysis_V
(
   Dim_Year,
   Dim_Month_Num,
   Dim_Period_Name,
   Dim_Week_Num,
   Ops_Country,
   Metro,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Short_Name,
   Course_Type,
   Enroll_Id,
   Book_Date,
   Canc_Date,
   Start_Date,
   Book_Amt,
   Enroll_Status,
   Cancel_Reason,
   Enroll_Cnt,
   Reenrollment_Cnt,
   Reenrolled_Cnt,
   Enroll_Days_Out,
   Canc_Days_Out,
   Enroll_Type
)
As
   Select   Td.Dim_Year,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0')
               Dim_Month_Num,
            Td.Dim_Period_Name,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0') Dim_Week_Num,
            Ed.Ops_Country,
            Ed.Facility_Region_Metro Metro,
            Cd.Course_Ch,
            Cd.Course_Mod,
            Cd.Course_Pl,
            Cd.Course_Code + '(' + Cd.Short_Name + ')' Short_Name,
            Cd.Course_Type,
            F.Enroll_Id,
            F.Book_Date,
            Null Canc_Date,
            Ed.Start_Date,
            F.Book_Amt,
            F.Enroll_Status,
            Ed.Cancel_Reason,
            1 Enroll_Cnt,
            Case When F.Orig_Enroll_Id Is Not Null Then 1 Else 0 End
               Reenrollment_Cnt,
            Case When F.Transfer_Enroll_Id Is Not Null Then 1 Else 0 End
               Reenrolled_Cnt,
            Ed.Start_Date - F.Book_Date + 1 Enroll_Days_Out,
            0 Canc_Days_Out,
            Case
               When F.Orig_Enroll_Id Is Not Null Then 'Re-Enrollment'
               Else 'Orig Enrollment'
            End
               Enroll_Type
     From            Gkdw.Order_Fact F
                  Inner Join
                     Gkdw.Event_Dim Ed
                  On F.Event_Id = Ed.Event_Id
               Inner Join
                  Gkdw.Time_Dim Td
               On Ed.Start_Date = Td.Dim_Date
            Inner Join
               Gkdw.Course_Dim Cd
            On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
    Where       Td.Dim_Year >= 2009
            And Cd.Ch_Num = '10'
            And Cd.Md_Num In ('10', '20')
            And F.Enroll_Status != 'Cancelled'
            And F.Book_Amt <> 0
            And F.Book_Date Is Not Null
            And F.Gkdw_Source = 'Slxdw'
   Union
     Select   Dim_Year,
              Dim_Month_Num,
              Dim_Period_Name,
              Dim_Week_Num,
              Ops_Country,
              Metro,
              Course_Ch,
              Course_Mod,
              Course_Pl,
              Short_Name,
              Course_Type,
              Enroll_Id,
              Min (Book_Date) Book_Date,
              Min (Canc_Date) Canc_Date,
              Start_Date,
              Sum (Book_Amt) Book_Amt,
              Enroll_Status,
              Cancel_Reason,
              1 Enroll_Cnt,
              Sum (Reenrolled_Cnt) Reenrollment_Cnt,
              Sum (Reenroll_Cnt) Reenrolled_Cnt,
              Sum (Enroll_Days_Out) Enroll_Days_Out,
              Sum (Canc_Days_Out) Canc_Days_Out,
              Case
                 When Sum (Reenrolled_Cnt) <> 0 Then 'Re-Enrollment'
                 Else 'Orig Enrollment'
              End
                 Enroll_Type
       From   (Select   Td.Dim_Year,
                        Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0')
                           Dim_Month_Num,
                        Td.Dim_Period_Name,
                        Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0')
                           Dim_Week_Num,
                        Ed.Ops_Country,
                        Ed.Facility_Region_Metro Metro,
                        Cd.Course_Ch,
                        Cd.Course_Mod,
                        Cd.Course_Pl,
                        Cd.Course_Code + '(' + Cd.Short_Name + ')'
                           Short_Name,
                        Cd.Course_Type,
                        F.Enroll_Id,
                        Case When F.Book_Amt > 0 Then F.Book_Date End Book_Date,
                        Case When F.Book_Amt < 0 Then F.Book_Date End Canc_Date,
                        Ed.Start_Date,
                        F.Book_Amt Book_Amt,
                        F.Enroll_Status,
                        Ed.Cancel_Reason,
                        Case
                           When F.Orig_Enroll_Id Is Not Null Then 1
                           Else 0
                        End
                           Reenrolled_Cnt,
                        Case
                           When F.Transfer_Enroll_Id Is Not Null Then 1
                           Else 0
                        End
                           Reenroll_Cnt,
                        Isnull(
                             Ed.Start_Date
                           - Case When F.Book_Amt > 0 Then F.Book_Date End
                           + 1,
                           0
                        )
                           Enroll_Days_Out,
                        Isnull(
                             Ed.Start_Date
                           - Case When F.Book_Amt < 0 Then F.Book_Date End
                           + 1,
                           0
                        )
                           Canc_Days_Out
                 From            Gkdw.Order_Fact F
                              Inner Join
                                 Gkdw.Event_Dim Ed
                              On F.Event_Id = Ed.Event_Id
                           Inner Join
                              Gkdw.Time_Dim Td
                           On Ed.Start_Date = Td.Dim_Date
                        Inner Join
                           Gkdw.Course_Dim Cd
                        On Ed.Course_Id = Cd.Course_Id
                           And Ed.Ops_Country = Cd.Country
                Where       Td.Dim_Year >= 2009
                        And Cd.Ch_Num = '10'
                        And Cd.Md_Num In ('10', '20')
                        And F.Enroll_Status = 'Cancelled'
                        And F.Book_Amt <> 0
                        And F.Book_Date Is Not Null
                        And F.Gkdw_Source = 'Slxdw') a1
   Group By   Dim_Year,
              Dim_Month_Num,
              Dim_Period_Name,
              Dim_Week_Num,
              Ops_Country,
              Metro,
              Course_Ch,
              Course_Mod,
              Course_Pl,
              Short_Name,
              Course_Type,
              Enroll_Id,
              Start_Date,
              Enroll_Status,
              Cancel_Reason
   ;



