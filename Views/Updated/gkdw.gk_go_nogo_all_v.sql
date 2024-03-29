


Create Or Alter View Hold.Gk_Go_Nogo_All_V
(
   Ops_Country,
   Start_Week,
   Start_Date,
   Event_Id,
   Reseller_Event_Id,
   Metro,
   Metro_Level,
   Facility_Code,
   Course_Code,
   Connected_Event,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Course_Type,
   Inst_Type,
   Inst_Name,
   Tp_Course,
   Tp_Status,
   Revenue,
   Total_Cost,
   Enroll_Cnt,
   Gk_Enroll_Cnt,
   Nex_Enroll_Cnt,
   Rate_Plan,
   Max_Daily_Rate,
   Margin,
   Inst_Cost,
   Inst_Travel_Cost,
   Cw_Cost,
   Freight_Cost,
   Voucher_Cost,
   Cisco_Dw_Cost,
   Facility_Cost,
   Hotel_Promo_Cost,
   Proctor_Exam_Cost,
   Unlimited_Enrollments,
   Lock_Promo_Cnt,
   Run_Status,
   Run_Status_3,
   Run_Status_6,
   Run_Status_8,
   Run_Status_10,
   Amt_Due_Remain,
   Rev_6_Weeks_Out,
   Lab_Rental,
   Sales_Comm,
   Gtr_Flag
)
As
     Select   Q.Ops_Country,
              Q.Start_Week,
              Q.Start_Date,
              Q.Event_Id,
              Ed.Reseller_Event_Id,
              Q.Facility_Region_Metro Metro,
              Metro_Level,
              Q.Facility_Code,
              Q.Course_Code,
              Q.Connected_Event,
              Q.Course_Ch,
              Q.Course_Mod,
              Q.Course_Pl,
              Cd.Course_Type,
              Q.Inst_Type,
              Q.Inst_Name,
              C.Course_Code Tp_Course,
              C.Status Tp_Status,
              Sum (Rev_Amt) Revenue,
              Sum(  Inst_Cost
                  + Travel_Cost
                  + Cw_Cost
                  + Freight_Cost
                  + Voucher_Cost
                  + Cdw_Cost
                  + Facility_Cost
                  + Hotel_Promo_Cost
                  + Proctor_Exam_Cost
                  + Lab_Rental
                  + Sales_Comm)
                 Total_Cost,
              Sum (Isnull(Q.Enroll_Cnt, 0)) Enroll_Cnt,
              Sum (Isnull(Gk_Enroll_Cnt, 0)) Gk_Enroll_Cnt,
              Sum (Isnull(Nex_Enroll_Cnt, 0)) Nex_Enroll_Cnt,
              Q.Rate_Plan,
              Q.Max_Daily_Rate,
              Case
                 When Sum (Rev_Amt) = 0
                 Then
                    0
                 Else
                    (Sum (Rev_Amt)
                     - Sum(  Inst_Cost
                           + Travel_Cost
                           + Cw_Cost
                           + Freight_Cost
                           + Voucher_Cost
                           + Cdw_Cost
                           + Facility_Cost
                           + Hotel_Promo_Cost
                           + Proctor_Exam_Cost
                           + Lab_Rental
                           + Sales_Comm))
                    / Sum (Rev_Amt)
              End
                 Margin,
              Sum (Inst_Cost) Inst_Cost,
              Sum (Travel_Cost) Inst_Travel_Cost,
              Sum (Cw_Cost) Cw_Cost,
              Sum (Freight_Cost) Freight_Cost,
              Sum (Voucher_Cost) Voucher_Cost,
              Sum (Cdw_Cost) Cisco_Dw_Cost,
              Sum (Facility_Cost) Facility_Cost,
              Sum (Hotel_Promo_Cost) Hotel_Promo_Cost,
              Sum (Proctor_Exam_Cost) Proctor_Exam_Cost,
              Sum (Unlimited_Cnt) Unlimited_Enrollments,
              Sum (Lock_Promo_Cnt) Lock_Promo_Cnt,
              Run_Status,
              Run_Status_3,
              Run_Status_6,
              Run_Status_8,
              Run_Status_10,
              Sum (Amt_Due_Remain) Amt_Due_Remain,
              Sum (Rev_6_Weeks_Out) Rev_6_Weeks_Out,
              Sum (Lab_Rental) Lab_Rental,
              Sum (Sales_Comm) Sales_Comm,
              Case When Ge.Event_Id Is Not Null Then 'Y' Else 'N' End Gtr_Flag
       From               (Select   L1.Ops_Country,
                                    L1.Start_Week,
                                    L1.Start_Date,
                                    L1.Event_Id,
                                    L1.Facility_Region_Metro,
                                    Isnull(L1.Metro_Level, 0) Metro_Level,
                                    L1.Facility_Code,
                                    L1.Course_Code,
                                    L1.Course_Ch,
                                    L1.Course_Mod,
                                    L1.Course_Pl,
                                    L1.Inst_Type,
                                    L1.Inst_Name,
                                    Isnull(L1.Rev_Amt, 0) Rev_Amt,
                                    L1.Enroll_Cnt,
                                    L1.Gk_Enroll_Cnt,
                                    L1.Nex_Enroll_Cnt,
                                    L1.Rate_Plan,
                                    L1.Max_Daily_Rate,
                                    Case
                                       When L1.Course_Mod = 'V-Learning'
                                            And L1.Ops_Country = 'Canada'
                                       Then
                                          0
                                       Else
                                          Isnull(Inst_Cost, 0)
                                    End
                                       Inst_Cost,
                                      Isnull(Hotel_Cost, 0)
                                    + Isnull(Airfare_Cost, 0)
                                    + Isnull(Rental_Cost, 0)
                                       Travel_Cost,
                                      Isnull(L1.Cw_Cost, 0)
                                    + Isnull(L1.Cw_Shipping_Cost, 0)
                                    + Isnull(L1.Misc_Cw_Cost, 0)
                                       Cw_Cost,
                                    Isnull(Freight_Cost, 0) Freight_Cost,
                                    Isnull(L1.Voucher_Cost, 0) Voucher_Cost,
                                    Isnull(L1.Cdw_Cost, 0) Cdw_Cost,
                                    Round (Isnull(Facility_Cost, 0), 2)
                                       Facility_Cost,
                                    Isnull(Hotel_Promo_Cost, 0) Hotel_Promo_Cost,
                                    Isnull(Proctor_Exam_Cost, 0)
                                       Proctor_Exam_Cost,
                                    Unlimited_Cnt,
                                    Lock_Promo_Cnt,
                                    L1.Run_Status,
                                    L1.Run_Status_3,
                                    L1.Run_Status_6,
                                    L1.Run_Status_8,
                                    L1.Run_Status_10,
                                    Isnull(L1.Amt_Due_Remain, 0) Amt_Due_Remain,
                                    Isnull(L1.Rev_6_Weeks_Out, 0) Rev_6_Weeks_Out,
                                    L1.Connected_Event,
                                    Isnull(L1.Lab_Rental, 0) Lab_Rental,
                                    Isnull(L1.Sales_Comm, 0) Sales_Comm
                             From   Gkdw.Gk_Go_Nogo L1
                            Where       L1.Ch_Num = '10'
                                    And L1.Md_Num In ('10', '20')
                                    And L1.Cancelled_Date Is Null
                                    And L1.Connected_To Is Null
                                    And Nested_With Is Null
                           Union All
                             Select   L1.Ops_Country,
                                      L1.Start_Week,
                                      L1.Start_Date,
                                      L1.Event_Id,
                                      L1.Facility_Region_Metro,
                                      Isnull(L1.Metro_Level, 0),
                                      L1.Facility_Code,
                                      L1.Course_Code,
                                      L1.Course_Ch,
                                      L1.Course_Mod,
                                      L1.Course_Pl,
                                      L1.Inst_Type,
                                      L1.Inst_Name,
                                      Sum (Isnull(L2.Rev_Amt, 0)) Rev_Amt,
                                      Sum (L2.Enroll_Cnt),
                                      Sum (L2.Gk_Enroll_Cnt),
                                      Sum (L2.Nex_Enroll_Cnt),
                                      L1.Rate_Plan,
                                      L1.Max_Daily_Rate,
                                      0,
                                      0,
                                      Sum(  Isnull(L2.Cw_Cost, 0)
                                          + Isnull(L2.Cw_Shipping_Cost, 0)
                                          + Isnull(L2.Misc_Cw_Cost, 0))
                                         Cw_Cost,
                                      0,
                                      Sum (Isnull(L2.Voucher_Cost, 0)) Voucher_Cost,
                                      Sum (Isnull(L2.Cdw_Cost, 0)) Cdw_Cost,
                                      0,
                                      Sum (Isnull(L2.Hotel_Promo_Cost, 0))
                                         Hotel_Promo_Cost,
                                      Sum (Isnull(L2.Proctor_Exam_Cost, 0))
                                         Proctor_Exam_Cost,
                                      Sum (L2.Unlimited_Cnt),
                                      Sum (L2.Lock_Promo_Cnt),
                                      L1.Run_Status,
                                      L1.Run_Status_3,
                                      L1.Run_Status_6,
                                      L1.Run_Status_8,
                                      L1.Run_Status_10,
                                      Sum (Isnull(L2.Amt_Due_Remain, 0))
                                         Amt_Due_Remain,
                                      Sum (Isnull(L2.Rev_6_Weeks_Out, 0))
                                         Rev_6_Weeks_Out,
                                      Null,
                                      Sum (Isnull(L2.Lab_Rental, 0)),
                                      Sum (Isnull(L2.Sales_Comm, 0))
                               From      Gkdw.Gk_Go_Nogo L1
                                      Inner Join
                                         Gkdw.Gk_Go_Nogo L2
                                      On L1.Event_Id = L2.Nested_With
                              Where       L1.Ch_Num = '10'
                                      And L1.Md_Num = '10'
                                      And L1.Cancelled_Date Is Null
                           Group By   L1.Ops_Country,
                                      L1.Start_Week,
                                      L1.Start_Date,
                                      L1.Event_Id,
                                      L1.Facility_Region_Metro,
                                      Isnull(L1.Metro_Level, 0),
                                      L1.Facility_Code,
                                      L1.Course_Code,
                                      L1.Course_Ch,
                                      L1.Course_Mod,
                                      L1.Course_Pl,
                                      L1.Inst_Type,
                                      L1.Inst_Name,
                                      L1.Rate_Plan,
                                      L1.Max_Daily_Rate,
                                      L1.Run_Status,
                                      L1.Run_Status_3,
                                      L1.Run_Status_6,
                                      L1.Run_Status_8,
                                      L1.Run_Status_10
                           Union All
                             Select   L1.Ops_Country,
                                      L1.Start_Week,
                                      L1.Start_Date,
                                      L1.Event_Id,
                                      L1.Facility_Region_Metro,
                                      Isnull(L1.Metro_Level, 0),
                                      L1.Facility_Code,
                                      L1.Course_Code,
                                      L1.Course_Ch,
                                      L1.Course_Mod,
                                      L1.Course_Pl,
                                      L1.Inst_Type,
                                      L1.Inst_Name,
                                      Sum (Isnull(L2.Rev_Amt, 0)) Rev_Amt,
                                      Sum (L2.Enroll_Cnt),
                                      Sum (L2.Gk_Enroll_Cnt),
                                      Sum (L2.Nex_Enroll_Cnt),
                                      L1.Rate_Plan,
                                      L1.Max_Daily_Rate,
                                      0,
                                      0,
                                      Sum(  Isnull(L2.Cw_Cost, 0)
                                          + Isnull(L2.Cw_Shipping_Cost, 0)
                                          + Isnull(L2.Misc_Cw_Cost, 0))
                                         Cw_Cost,
                                      0,
                                      Sum (Isnull(L2.Voucher_Cost, 0)) Voucher_Cost,
                                      Sum (Isnull(L2.Cdw_Cost, 0)) Cdw_Cost,
                                      0,
                                      Sum (Isnull(L2.Hotel_Promo_Cost, 0))
                                         Hotel_Promo_Cost,
                                      Sum (Isnull(L2.Proctor_Exam_Cost, 0))
                                         Proctor_Exam_Cost,
                                      Sum (L2.Unlimited_Cnt),
                                      Sum (L2.Lock_Promo_Cnt),
                                      L1.Run_Status,
                                      L1.Run_Status_3,
                                      L1.Run_Status_6,
                                      L1.Run_Status_8,
                                      L1.Run_Status_10,
                                      Sum (Isnull(L2.Amt_Due_Remain, 0))
                                         Amt_Due_Remain,
                                      Sum (Isnull(L2.Rev_6_Weeks_Out, 0))
                                         Rev_6_Weeks_Out,
                                      L1.Connected_Event,
                                      Sum (Isnull(L2.Lab_Rental, 0)),
                                      Sum (Isnull(L2.Sales_Comm, 0))
                               From      Gkdw.Gk_Go_Nogo L1
                                      Inner Join
                                         Gkdw.Gk_Go_Nogo L2
                                      On L1.Event_Id = L2.Connected_To
                              Where       L1.Ch_Num = '10'
                                      And L1.Md_Num = '10'
                                      And L1.Cancelled_Date Is Null
                           Group By   L1.Ops_Country,
                                      L1.Start_Week,
                                      L1.Start_Date,
                                      L1.Event_Id,
                                      L1.Facility_Region_Metro,
                                      Isnull(L1.Metro_Level, 0),
                                      L1.Facility_Code,
                                      L1.Course_Code,
                                      L1.Course_Ch,
                                      L1.Course_Mod,
                                      L1.Course_Pl,
                                      L1.Inst_Type,
                                      L1.Inst_Name,
                                      L1.Rate_Plan,
                                      L1.Max_Daily_Rate,
                                      L1.Run_Status,
                                      L1.Run_Status_3,
                                      L1.Run_Status_6,
                                      L1.Run_Status_8,
                                      L1.Run_Status_10,
                                      L1.Connected_Event) Q
                       Inner Join
                          Gkdw.Event_Dim Ed
                       On Q.Event_Id = Ed.Event_Id
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Left Outer Join
                    Gkdw.Gk_Gtr_Events Ge
                 On Q.Event_Id = Ge.Event_Id
              Left Outer Join
                 Base.Tp_Classes C
              On Ed.Reseller_Event_Id = C.Eventid --Where Q.Start_Date >= '01-Jan-2012'
                 And Substring(Q.Course_Code, 5,  1) Not In ('N', 'V')
   Group By   Q.Ops_Country,
              Q.Start_Week,
              Q.Start_Date,
              Q.Event_Id,
              Ed.Reseller_Event_Id,
              Q.Facility_Region_Metro,
              Metro_Level,
              Q.Facility_Code,
              Q.Course_Code,
              Q.Connected_Event,
              Q.Course_Pl,
              Q.Course_Ch,
              Q.Course_Mod,
              Cd.Course_Type,
              Q.Inst_Type,
              Q.Inst_Name,
              Q.Rate_Plan,
              Q.Max_Daily_Rate,
              C.Course_Code,
              C.Status,
              Run_Status,
              Run_Status_3,
              Run_Status_6,
              Run_Status_8,
              Run_Status_10,
              Case When Ge.Event_Id Is Not Null Then 'Y' Else 'N' End
   ;



