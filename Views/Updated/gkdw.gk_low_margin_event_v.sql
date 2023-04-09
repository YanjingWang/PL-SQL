


Create Or Alter View Hold.Gk_Low_Margin_Event_V
(
   Ops_Country,
   Start_Week,
   Start_Date,
   Event_Id,
   Metro,
   Metro_Level,
   Facility_Code,
   Course_Code,
   Short_Name,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Inst_Type,
   Revenue,
   Total_Cost,
   Enroll_Cnt,
   Margin,
   Inst_Cost,
   Inst_Travel_Cost,
   Cw_Cost,
   Freight_Cost,
   Voucher_Cost,
   Cisco_Dw_Cost,
   Facility_Cost,
   Hotel_Promo_Cost,
   Proctor_Exam_Cost
)
As
     Select   Ops_Country,
              Start_Week,
              Start_Date,
              Event_Id,
              Facility_Region_Metro Metro,
              Metro_Level,
              Facility_Code,
              Course_Code,
              Short_Name,
              Course_Ch,
              Course_Mod,
              Course_Pl,
              Inst_Type,
              Sum (Rev_Amt) Revenue,
              Sum(  Inst_Cost
                  + Travel_Cost
                  + Cw_Cost
                  + Freight_Cost
                  + Voucher_Cost
                  + Cdw_Cost
                  + Facility_Cost
                  + Hotel_Promo_Cost
                  + Proctor_Exam_Cost)
                 Total_Cost,
              Sum (Enroll_Cnt) Enroll_Cnt,
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
                           + Proctor_Exam_Cost))
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
              Sum (Proctor_Exam_Cost) Proctor_Exam_Cost
       From   (Select   L1.Ops_Country,
                        L1.Start_Week,
                        L1.Start_Date,
                        L1.Event_Id,
                        L1.Facility_Region_Metro,
                        Isnull(L1.Metro_Level, 0) Metro_Level,
                        L1.Facility_Code,
                        L1.Course_Code,
                        L1.Short_Name,
                        L1.Course_Ch,
                        L1.Course_Mod,
                        L1.Course_Pl,
                        L1.Inst_Type,
                        Isnull(L1.Rev_Amt, 0) Rev_Amt,
                        L1.Enroll_Cnt,
                        Isnull(Inst_Cost, 0) Inst_Cost,
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
                        Round (Isnull(Facility_Cost, 0), 2) Facility_Cost,
                        Isnull(Hotel_Promo_Cost, 0) Hotel_Promo_Cost,
                        Isnull(Proctor_Exam_Cost, 0) Proctor_Exam_Cost
                 From   Gkdw.Gk_Go_Nogo L1
                Where       L1.Ch_Num = '10'
                        And L1.Md_Num In ('10', '20') --And L1.Ops_Country = 'Usa'
                        And L1.Cancelled_Date Is Null
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
                          L1.Short_Name,
                          L1.Course_Ch,
                          L1.Course_Mod,
                          L1.Course_Pl,
                          L1.Inst_Type,
                          Sum (Isnull(L2.Rev_Amt, 0)) Rev_Amt,
                          Sum (L2.Enroll_Cnt),
                          0,
                          0,
                          Sum(  Isnull(L2.Cw_Cost, 0)
                              + Isnull(L2.Cw_Shipping_Cost, 0)
                              + Isnull(L1.Misc_Cw_Cost, 0))
                             Cw_Cost,
                          0,
                          Sum (Isnull(L2.Voucher_Cost, 0)) Voucher_Cost,
                          Sum (Isnull(L2.Cdw_Cost, 0)) Cdw_Cost,
                          0,
                          Sum (Isnull(L2.Hotel_Promo_Cost, 0)) Hotel_Promo_Cost,
                          Sum (Isnull(L2.Proctor_Exam_Cost, 0)) Proctor_Exam_Cost
                   From      Gkdw.Gk_Go_Nogo L1
                          Inner Join
                             Gkdw.Gk_Go_Nogo L2
                          On L1.Event_Id = L2.Nested_With
                  Where       L1.Ch_Num = '10'
                          And L1.Md_Num = '10'
                          And L1.Ops_Country = 'Usa'
                          And L1.Cancelled_Date Is Null
               Group By   L1.Ops_Country,
                          L1.Start_Week,
                          L1.Start_Date,
                          L1.Event_Id,
                          L1.Facility_Region_Metro,
                          Isnull(L1.Metro_Level, 0),
                          L1.Facility_Code,
                          L1.Course_Code,
                          L1.Short_Name,
                          L1.Course_Ch,
                          L1.Course_Mod,
                          L1.Course_Pl,
                          L1.Inst_Type) a1
   Group By   Ops_Country,
              Start_Week,
              Start_Date,
              Event_Id,
              Facility_Region_Metro,
              Metro_Level,
              Facility_Code,
              Course_Code,
              Short_Name,
              Course_Pl,
              Course_Ch,
              Course_Mod,
              Inst_Type
     Having   Case
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
                           + Proctor_Exam_Cost))
                    / Sum (Rev_Amt)
              End < .6;



