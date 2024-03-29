


Create Or Alter View Hold.Gk_Book_Analysis_V
(
   Dim_Year,
   Dim_Period_Name,
   Event_Modality,
   Metro_Area,
   Tot_Conf_Att,
   Book_Amt,
   Tot_Fee_Stud,
   Full_Cnt,
   Full_Amt,
   Full_Fee_Stud,
   Disc_Cnt,
   Disc_Amt,
   Disc_Fee_Stud,
   Prepay_Cnt,
   Prepay_Amt,
   Prepay_Fee_Stud,
   Gk_Canc_Cnt,
   Gk_Canc_Amt,
   Stud_Canc_Cnt,
   Stud_Canc_Amt
)
As
     Select   T.Dim_Year,
              T.Dim_Period_Name,
              E.Event_Modality,
              E.Facility_Region_Metro Metro_Area,
              Sum (Case When F.Enroll_Status != 'Cancelled' Then 1 Else 0 End)
                 Tot_Conf_Att,
              Sum(Case
                     When F.Enroll_Status != 'Cancelled' Then Book_Amt
                     Else 0
                  End)
                 Book_Amt,
              Case
                 When Sum(Case
                             When F.Enroll_Status != 'Cancelled' Then 1
                             Else 0
                          End) = 0
                 Then
                    0
                 Else
                    Sum(Case
                           When F.Enroll_Status != 'Cancelled' Then Book_Amt
                           Else 0
                        End)
                    / Sum(Case
                             When F.Enroll_Status != 'Cancelled' Then 1
                             Else 0
                          End)
              End
                 Tot_Fee_Stud,
              Sum(Case
                     When Book_Amt >= Isnull(List_Price, Book_Amt)
                          And (Pp_Sales_Order_Id Is Null
                               Or Pd.Card_Type = 'Valuecard')
                          And F.Enroll_Status != 'Cancelled'
                     Then
                        1
                     Else
                        0
                  End)
                 Full_Cnt,
              Sum(Case
                     When Book_Amt >= Isnull(List_Price, Book_Amt)
                          And (Pp_Sales_Order_Id Is Null
                               Or Pd.Card_Type = 'Valuecard')
                          And F.Enroll_Status != 'Cancelled'
                     Then
                        Book_Amt
                     Else
                        0
                  End)
                 Full_Amt,
              Case
                 When Sum(Case
                             When Book_Amt >= Isnull(List_Price, Book_Amt)
                                  And (Pp_Sales_Order_Id Is Null
                                       Or Pd.Card_Type = 'Valuecard')
                                  And F.Enroll_Status != 'Cancelled'
                             Then
                                1
                             Else
                                0
                          End) = 0
                 Then
                    0
                 Else
                    Sum(Case
                           When Book_Amt >= Isnull(List_Price, Book_Amt)
                                And (Pp_Sales_Order_Id Is Null
                                     Or Pd.Card_Type = 'Valuecard')
                                And F.Enroll_Status != 'Cancelled'
                           Then
                              Book_Amt
                           Else
                              0
                        End)
                    / Sum(Case
                             When Book_Amt >= Isnull(List_Price, Book_Amt)
                                  And (Pp_Sales_Order_Id Is Null
                                       Or Pd.Card_Type = 'Valuecard')
                                  And F.Enroll_Status != 'Cancelled'
                             Then
                                1
                             Else
                                0
                          End)
              End
                 Full_Fee_Stud,
              Sum(Case
                     When Book_Amt < List_Price
                          And (Pp_Sales_Order_Id Is Null
                               Or Pd.Card_Type = 'Valuecard')
                          And F.Enroll_Status != 'Cancelled'
                     Then
                        1
                     Else
                        0
                  End)
                 Disc_Cnt,
              Sum(Case
                     When Book_Amt < List_Price
                          And (Pp_Sales_Order_Id Is Null
                               Or Pd.Card_Type = 'Valuecard')
                          And F.Enroll_Status != 'Cancelled'
                     Then
                        List_Price - Book_Amt
                     Else
                        0
                  End)
                 Disc_Amt,
              Sum(Case
                     When Book_Amt < List_Price
                          And (Pp_Sales_Order_Id Is Null
                               Or Pd.Card_Type = 'Valuecard')
                          And F.Enroll_Status != 'Cancelled'
                     Then
                        List_Price - Book_Amt
                     Else
                        0
                  End)
              / (Case
                    When Sum(Case
                                When Book_Amt < List_Price
                                     And (Pp_Sales_Order_Id Is Null
                                          Or Pd.Card_Type = 'Valuecard')
                                     And F.Enroll_Status != 'Cancelled'
                                Then
                                   1
                                Else
                                   0
                             End) = 0
                    Then
                       1
                    Else
                       Sum(Case
                              When Book_Amt < List_Price
                                   And (Pp_Sales_Order_Id Is Null
                                        Or Pd.Card_Type = 'Valuecard')
                                   And F.Enroll_Status != 'Cancelled'
                              Then
                                 1
                              Else
                                 0
                           End)
                 End)
                 Disc_Fee_Stud,
              Sum(Case
                     When     Pp_Sales_Order_Id Is Not Null
                          And Pd.Card_Type = 'Eventcard'
                          And F.Enroll_Status != 'Cancelled'
                     Then
                        1
                     Else
                        0
                  End)
                 Prepay_Cnt,
              Sum(Case
                     When     Pp_Sales_Order_Id Is Not Null
                          And Pd.Card_Type = 'Eventcard'
                          And F.Enroll_Status != 'Cancelled'
                     Then
                        Book_Amt
                     Else
                        0
                  End)
                 Prepay_Amt,
              Sum(Case
                     When     Pp_Sales_Order_Id Is Not Null
                          And Pd.Card_Type = 'Eventcard'
                          And F.Enroll_Status != 'Cancelled'
                     Then
                        Book_Amt
                     Else
                        0
                  End)
              / Case
                   When Sum(Case
                               When     Pp_Sales_Order_Id Is Not Null
                                    And Pd.Card_Type = 'Eventcard'
                                    And F.Enroll_Status != 'Cancelled'
                               Then
                                  1
                               Else
                                  0
                            End) = 0
                   Then
                      1
                   Else
                      Sum(Case
                             When     Pp_Sales_Order_Id Is Not Null
                                  And Pd.Card_Type = 'Eventcard'
                                  And F.Enroll_Status != 'Cancelled'
                             Then
                                1
                             Else
                                0
                          End)
                End
                 Prepay_Fee_Stud,
              Sum(Case
                     When     Enroll_Status = 'Cancelled'
                          And Bill_Status = 'Cancelled'
                          And Book_Amt < 0
                          And Enroll_Status_Desc = 'Event Cancellation'
                     Then
                        1
                     Else
                        0
                  End)
                 Gk_Canc_Cnt,
              Sum(Case
                     When     Enroll_Status = 'Cancelled'
                          And Bill_Status = 'Cancelled'
                          And Book_Amt < 0
                          And Enroll_Status_Desc = 'Event Cancellation'
                     Then
                        Book_Amt
                     Else
                        0
                  End)
                 Gk_Canc_Amt,
              Sum(Case
                     When     Enroll_Status = 'Cancelled'
                          And Bill_Status = 'Cancelled'
                          And Book_Amt < 0
                          And Enroll_Status_Desc Not In
                                   ('Event Cancellation', 'Order Entry Error')
                     Then
                        1
                     Else
                        0
                  End)
                 Stud_Canc_Cnt,
              Sum(Case
                     When     Enroll_Status = 'Cancelled'
                          And Bill_Status = 'Cancelled'
                          And Book_Amt < 0
                          And Enroll_Status_Desc Not In
                                   ('Event Cancellation', 'Order Entry Error')
                     Then
                        Book_Amt
                     Else
                        0
                  End)
                 Stud_Canc_Amt
       From            Gkdw.Order_Fact F
                    Inner Join
                       Gkdw.Time_Dim T
                    On F.Book_Date = T.Dim_Date
                 Inner Join
                    Gkdw.Event_Dim E
                 On F.Event_Id = E.Event_Id
              Left Outer Join
                 Gkdw.Ppcard_Dim Pd
              On F.Pp_Sales_Order_Id = Pd.Sales_Order_Id
      Where       E.Event_Channel = 'Individual/Public'
              --And E.Event_Modality In ('C-Learning')
              And Country = 'Usa'
              And Book_Date >= To_Date ('1/1/2006', 'Mm/Dd/Yyyy')
   Group By   T.Dim_Year,
              T.Dim_Period_Name,
              T.Dim_Month_Num,
              E.Event_Modality,
              E.Facility_Region_Metro
   ;



