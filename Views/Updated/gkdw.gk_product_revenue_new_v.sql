


Create Or Alter View Hold.Gk_Product_Revenue_New_V
(
   Event_Id,
   Status,
   Event_Desc,
   Rev_Date,
   Rev_Amt,
   Ops_Country,
   Facility_Region_Metro,
   Eventlength,
   Ch_Num,
   Course_Ch,
   Md_Num,
   Course_Mod,
   Pl_Num,
   Course_Pl,
   Course_Name,
   Delivery_Method,
   Delivery_Type,
   Sales_Channel,
   Product_Line,
   Business_Unit,
   Vendor,
   Product_Type,
   Course_Code,
   Rev_Year,
   Rev_Quarter,
   Rev_Mon_Num,
   Rev_Month,
   Rev_Week_Num,
   Ent_Cnt,
   Public_Enroll_Count,
   Public_Guest_Count,
   Event_Held_Cnt,
   Event_Sched_Cnt
)
As
     Select   Ed.Event_Id,
              Ed.Status,
                 Cd.Course_Code
              + '-'
              + Facility_Region_Metro
              + '-'
              + Format(Ed.Start_Date, 'Yymmdd')
              + '('
              + Ed.Event_Id
              + ')'
                 Event_Desc,
              Trunc (Ed.Start_Date) Rev_Date,
              Sum (Case When Ed.Status = 'Cancelled' Then 0 Else F.Book_Amt End) Rev_Amt,
              Ed.Ops_Country,
              Facility_Region_Metro,
              Case
                 When Nc.Nested_Course_Id Is Not Null Then 0
                 Else Trunc (Ed.End_Date) - Trunc (Ed.Start_Date) + 1
              End
                 Eventlength,
              Cd.Ch_Num,
              Cd.Course_Ch,
              Cd.Md_Num,
              Cd.Course_Mod,
              Cd.Pl_Num,
              Cd.Course_Pl,
              Cd.Course_Name,
              Ca.Delivery_Method,
              Ca.Delivery_Type,
              Ca.Sales_Channel,
              Ca.Product_Line,
              Ca.Business_Unit,
              Ca.Vendor,
              Ca.Product_Type,
              Case
                 When Nc.Nested_Course_Id Is Not Null
                 Then
                       Cd1.Course_Code
                    + '('
                    + Isnull(Trim (Cd1.Short_Name), ' ')
                    + ')'
                 Else
                       Cd.Course_Code
                    + '('
                    + Isnull(Trim (Cd.Short_Name), ' ')
                    + ')'
              End
                 Course_Code,
              Tdr.Dim_Year Rev_Year,
              Tdr.Dim_Year + '-Qtr ' + Tdr.Dim_Quarter Rev_Quarter,
              Tdr.Dim_Year + '-' + Lpad (Tdr.Dim_Month_Num, 2, '0')
                 Rev_Mon_Num,
              Tdr.Dim_Year + '-' + Tdr.Dim_Month Rev_Month,
              Tdr.Dim_Year + '-' + Lpad (Tdr.Dim_Week, 2, '0') Rev_Week_Num,
              Isnull(Oa.Enroll_Cnt, 0) Ent_Cnt,
              Sum(Case
                     When     Cd.Ch_Num <> '20'
                          And F.Enroll_Status In ('Attended', 'Confirmed')
                          And F.Book_Amt <> 0
                     Then
                        1
                     Else
                        0
                  End)
                 Public_Enroll_Count,
              Sum(Case
                     When     Cd.Ch_Num <> '20'
                          And F.Enroll_Status In ('Attended', 'Confirmed')
                          And F.Book_Amt = 0
                     Then
                        1
                     Else
                        0
                  End)
                 Public_Guest_Count,
              Case
                 When Nc.Nested_Course_Id Is Not Null
                 Then
                    0
                 Else
                    Count (
                       Distinct Case
                                   When Ed.Status != 'Cancelled'
                                   Then
                                      Ed.Event_Id
                                   Else
                                      Null
                                End
                    )
              End
                 Event_Held_Cnt,
              Case
                 When Nc.Nested_Course_Id Is Not Null Then 0
                 Else Count (Distinct Ed.Event_Id)
              End
                 Event_Sched_Cnt
       From                        Gkdw.Order_Fact F
                                Inner Join
                                   Gkdw.Event_Dim Ed
                                On F.Event_Id = Ed.Event_Id
                             Inner Join
                                Gkdw.Course_Dim Cd
                             On Ed.Course_Id = Cd.Course_Id
                                And Ed.Ops_Country = Cd.Country
                          Inner Join
                             Gkdw.Gk_Course_Attributes_V Ca
                          On Cd.Course_Id = Ca.Course_Id
                       Inner Join
                          Gkdw.Time_Dim Tdr
                       On Tdr.Dim_Date =
                             Case
                                When Cd.Md_Num In ('32', '44')
                                Then
                                   Trunc (F.Book_Date)
                                Else
                                   Ed.Start_Date
                             End        --Must Use Start Date For Kbi Accuracy
                    Left Outer Join
                       Gkdw.Gk_Onsite_Attended_Cnt_V Oa
                    On Ed.Event_Id = Oa.Event_Id
                 Left Outer Join
                    Gkdw.Gk_Nested_Courses Nc
                 On Cd.Course_Id = Nc.Nested_Course_Id
              Left Outer Join
                 Gkdw.Course_Dim Cd1
              On Nc.Master_Course_Id = Cd1.Course_Id
                 And Ed.Ops_Country = Cd1.Country
      Where   Ed.Start_Date >= To_Date ('1/1/2006', 'Mm/Dd/Yyyy')
              And Cd.Ch_Num In ('10', '20')
              And Cd.Short_Name Not In
                       ('0 Classroom Training Fee', 'Rhct Success Pack')
              And Cd.Course_Code Not In ('097')
   Group By   Ed.Event_Id,
              Ed.Status,
                 Cd.Course_Code
              + '-'
              + Facility_Region_Metro
              + '-'
              + Format(Ed.Start_Date, 'Yymmdd')
              + '('
              + Ed.Event_Id
              + ')',
              Trunc (Ed.Start_Date),
              Ed.Ops_Country,
              Facility_Region_Metro,
              Trunc (Ed.End_Date) - Trunc (Ed.Start_Date) + 1,
              Isnull(Cd.List_Price, 0),
              Cd.Ch_Num,
              Cd.Course_Ch,
              Cd.Md_Num,
              Cd.Course_Mod,
              Cd.Pl_Num,
              Cd.Course_Pl,
              Cd.Course_Type,
              Ca.Delivery_Method,
              Ca.Delivery_Type,
              Ca.Sales_Channel,
              Ca.Product_Line,
              Ca.Business_Unit,
              Ca.Vendor,
              Ca.Product_Type,
              Cd.Course_Name,
              Cd.Course_Code + '(' + Isnull(Trim (Cd.Short_Name), ' ') + ')',
                 Cd1.Course_Code
              + '('
              + Isnull(Trim (Cd1.Short_Name), ' ')
              + ')',
              Nc.Nested_Course_Id,
              Isnull(Oa.Enroll_Cnt, 0),
              Tdr.Dim_Year,
              Tdr.Dim_Year + '-Qtr ' + Tdr.Dim_Quarter,
              Tdr.Dim_Year + '-' + Lpad (Tdr.Dim_Month_Num, 2, '0'),
              Tdr.Dim_Year + '-' + Tdr.Dim_Month,
              Tdr.Dim_Year + '-' + Lpad (Tdr.Dim_Week, 2, '0'),
              Cd.Course_Type
   Union All
     Select   Pd.Product_Id,
              'Open',
              Pd.Prod_Num,
              Isnull(Trunc (S.Rev_Date), Trunc (S.Book_Date) + 7),
              Sum (S.Book_Amt),
              'Usa',
              'Spel',
              0,
              Pd.Ch_Num,
              Pd.Prod_Channel,
              Pd.Md_Num,
              Pd.Prod_Modality,
              Pd.Pl_Num,
              Pd.Prod_Line,
              Pd.Prod_Name,
              Ca.Delivery_Method,
              Ca.Delivery_Type,
              Ca.Sales_Channel,
              Ca.Product_Line,
              Ca.Business_Unit,
              Ca.Vendor,
              Ca.Product_Type,
              Pd.Prod_Num,
              Tdr.Dim_Year,
              Tdr.Dim_Year + '-Qtr ' + Tdr.Dim_Quarter,
              Tdr.Dim_Year + '-' + Lpad (Tdr.Dim_Month_Num, 2, '0')
                 Rev_Mon_Num,
              Tdr.Dim_Year + '-' + Tdr.Dim_Month,
              Tdr.Dim_Year + '-' + Lpad (Tdr.Dim_Week, 2, '0'),
              0 Ent_Count,
              Sum (S.Quantity) Public_Enroll_Count,
              0 Public_Guest_Count,
              0,
              0
       From                     Gkdw.Sales_Order_Fact S
                             Inner Join
                                Gkdw.Product_Dim Pd
                             On S.Product_Id = Pd.Product_Id
                          Inner Join
                             Gkdw.Gk_Course_Attributes_V Ca
                          On Pd.Product_Id = Ca.Course_Id
                       Inner Join
                          Gkdw.Time_Dim Tdr
                       On Trunc (S.Ship_Date) = Tdr.Dim_Date
                    Inner Join
                       Gkdw.Cust_Dim C
                    On S.Cust_Id = C.Cust_Id
                 Inner Join
                    Gkdw.Account_Dim A
                 On C.Acct_Id = A.Acct_Id
              Inner Join
                 Base.Evxso Es
              On S.Sales_Order_Id = Es.Evxsoid
      Where       S.Record_Type = 'Salesorder'
              And S.Ship_Date >= To_Date ('1/1/2006', 'Mm/Dd/Yyyy')
              And S.Cancel_Date Is Null
              And S.Book_Amt <> 0
              And Pd.Prod_Name Not In
                       ('0 Classroom Training Fee', 'Rhct Success Pack')
              And Pd.Prod_Num Not In ('097')
   Group By   Pd.Product_Id,
              Pd.Prod_Num,
              Isnull(Trunc (S.Rev_Date), Trunc (S.Book_Date) + 7),
              'Usa',
              S.Record_Type,
              'Spel',
              0,
              Pd.Ch_Num,
              Pd.Prod_Channel,
              Pd.Md_Num,
              Pd.Prod_Modality,
              Pd.Pl_Num,
              Pd.Prod_Line,
              Pd.Prod_Family,
              Pd.Prod_Name,
              Ca.Delivery_Method,
              Ca.Delivery_Type,
              Ca.Sales_Channel,
              Ca.Product_Line,
              Ca.Business_Unit,
              Ca.Vendor,
              Ca.Product_Type,
              Pd.Prod_Num,
              Tdr.Dim_Year,
              Tdr.Dim_Year + '-Qtr ' + Tdr.Dim_Quarter,
              Tdr.Dim_Year + '-' + Lpad (Tdr.Dim_Month_Num, 2, '0'),
              Tdr.Dim_Year + '-' + Tdr.Dim_Month,
              Tdr.Dim_Year + '-' + Lpad (Tdr.Dim_Week, 2, '0');



