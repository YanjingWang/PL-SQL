


Create Or Alter View Hold.Gk_Bookings_Terr_Overview_V
(
   Acct_Name,
   Terr_Id,
   Bookings_Rank,
   Total_Bookings,
   Total_Bookings_2007,
   Total_Bookings_2008,
   Total_Bookings_2009,
   Acct_Nonpp_2009,
   Acct_Pp_2009,
   Acct_Total_2009,
   Acct_Nonpp_2008,
   Acct_Pp_2008,
   Acct_Total_2008,
   Acct_Nonpp_2007,
   Acct_Pp_2007,
   Acct_Total_2007,
   Acct_Total_3Yr
)
As
     Select   Acct_Name,
              Terr_Id,
              Bookings_Rank,
              Total_Bookings,
              Total_Bookings_2007,
              Total_Bookings_2008,
              Total_Bookings_2009,
              Sum (Acct_Nonpp_2009) Acct_Nonpp_2009,
              Sum (Acct_Pp_2009) Acct_Pp_2009,
              Sum (Acct_Total_2009) Acct_Total_2009,
              Sum (Acct_Nonpp_2008) Acct_Nonpp_2008,
              Sum (Acct_Pp_2008) Acct_Pp_2008,
              Sum (Acct_Total_2008) Acct_Total_2008,
              Sum (Acct_Nonpp_2007) Acct_Nonpp_2007,
              Sum (Acct_Pp_2007) Acct_Pp_2007,
              Sum (Acct_Total_2007) Acct_Total_2007,
              Sum (Acct_Total_2009 + Acct_Total_2008 + Acct_Total_2007)
                 Acct_Total_3Yr
       From   (  Select   Tt.Acct_Name,
                          Tt.Terr_Id,
                          Tt.Bookings_Rank,
                          Tt.Total_Bookings,
                          Bt.Total_Bookings_2007,
                          Bt.Total_Bookings_2008,
                          Bt.Total_Bookings_2009,
                          Sum(Case
                                 When Isnull(Payment_Type, 'None') != 'Prepay Card'
                                 Then
                                    Book_Amt
                                 Else
                                    0
                              End)
                             Acct_Nonpp_2009,
                          Sum(Case
                                 When Payment_Type = 'Prepay Card' Then Book_Amt
                                 Else 0
                              End)
                             Acct_Pp_2009,
                          Sum (Book_Amt) Acct_Total_2009,
                          0 Acct_Nonpp_2008,
                          0 Acct_Pp_2008,
                          0 Acct_Total_2008,
                          0 Acct_Nonpp_2007,
                          0 Acct_Pp_2007,
                          0 Acct_Total_2007
                   From         Gkdw.Gk_Open_Enrollment_Mv Oe
                             Inner Join
                                Gkdw.Gk_Bookings_Terr_All_Mv Tt
                             On Oe.Acct_Id = Tt.Acct_Id
                                And Lpad (Oe.Territory_Id, 2, '0') = Tt.Terr_Id
                          Inner Join
                             Gkdw.Gk_Bookings_Terr_Total_V Bt
                          On Tt.Terr_Id = Bt.Terr_Id
                  Where       Oe.Book_Year = 2009
                          And (Itbt_Flag = 'Itbt' Or Itbt_Flag Is Null)
                          And Ch_Flag = 'N'
                          And Nat_Flag = 'N'
                          And Mta_Flag = 'N'
                          And Event_Prod_Line != 'Other'
                          And Event_Modality != 'Reseller - C-Learning'
               Group By   Tt.Acct_Name,
                          Tt.Terr_Id,
                          Tt.Bookings_Rank,
                          Tt.Total_Bookings,
                          Bt.Total_Bookings_2007,
                          Bt.Total_Bookings_2008,
                          Bt.Total_Bookings_2009
               Union All
                 Select   Tt.Acct_Name,
                          Tt.Terr_Id,
                          Tt.Bookings_Rank,
                          Tt.Total_Bookings,
                          Bt.Total_Bookings_2007,
                          Bt.Total_Bookings_2008,
                          Bt.Total_Bookings_2009,
                          0 Acct_Nonpp_2009,
                          0 Acct_Pp_2009,
                          0 Acct_Total_2009,
                          Sum(Case
                                 When Isnull(Payment_Type, 'None') != 'Prepay Card'
                                 Then
                                    Book_Amt
                                 Else
                                    0
                              End)
                             Acct_Nonpp_2008,
                          Sum(Case
                                 When Payment_Type = 'Prepay Card' Then Book_Amt
                                 Else 0
                              End)
                             Acct_Pp_2008,
                          Sum (Book_Amt) Acct_Total_2008,
                          0 Acct_Nonpp_2007,
                          0 Acct_Pp_2007,
                          0 Acct_Total_2007
                   From         Gkdw.Gk_Open_Enrollment_Mv Oe
                             Inner Join
                                Gkdw.Gk_Bookings_Terr_All_Mv Tt
                             On Oe.Acct_Id = Tt.Acct_Id
                                And Lpad (Oe.Territory_Id, 2, '0') = Tt.Terr_Id
                          Inner Join
                             Gkdw.Gk_Bookings_Terr_Total_V Bt
                          On Tt.Terr_Id = Bt.Terr_Id
                  Where       Oe.Book_Year = 2008
                          And (Itbt_Flag = 'Itbt' Or Itbt_Flag Is Null)
                          And Ch_Flag = 'N'
                          And Nat_Flag = 'N'
                          And Mta_Flag = 'N'
                          And Event_Prod_Line != 'Other'
                          And Event_Modality != 'Reseller - C-Learning'
               Group By   Tt.Acct_Name,
                          Tt.Terr_Id,
                          Tt.Bookings_Rank,
                          Tt.Total_Bookings,
                          Bt.Total_Bookings_2007,
                          Bt.Total_Bookings_2008,
                          Bt.Total_Bookings_2009
               Union All
                 Select   Tt.Acct_Name,
                          Tt.Terr_Id,
                          Tt.Bookings_Rank,
                          Tt.Total_Bookings,
                          Bt.Total_Bookings_2007,
                          Bt.Total_Bookings_2008,
                          Bt.Total_Bookings_2009,
                          0 Acct_Nonpp_2009,
                          0 Acct_Pp_2009,
                          0 Acct_Total_2009,
                          0 Acct_Nonpp_2008,
                          0 Acct_Pp_2008,
                          0 Acct_Total_2008,
                          Sum(Case
                                 When Isnull(Payment_Type, 'None') != 'Prepay Card'
                                 Then
                                    Book_Amt
                                 Else
                                    0
                              End)
                             Acct_Nonpp_2007,
                          Sum(Case
                                 When Payment_Type = 'Prepay Card' Then Book_Amt
                                 Else 0
                              End)
                             Acct_Pp_2007,
                          Sum (Book_Amt) Acct_Total_2007
                   From         Gkdw.Gk_Open_Enrollment_Mv Oe
                             Inner Join
                                Gkdw.Gk_Bookings_Terr_All_Mv Tt
                             On Oe.Acct_Id = Tt.Acct_Id
                                And Lpad (Oe.Territory_Id, 2, '0') = Tt.Terr_Id
                          Inner Join
                             Gkdw.Gk_Bookings_Terr_Total_V Bt
                          On Tt.Terr_Id = Bt.Terr_Id
                  Where       Oe.Book_Year = 2007
                          And (Itbt_Flag = 'Itbt' Or Itbt_Flag Is Null)
                          And Ch_Flag = 'N'
                          And Nat_Flag = 'N'
                          And Mta_Flag = 'N'
                          And Event_Prod_Line != 'Other'
                          And Event_Modality != 'Reseller - C-Learning'
               Group By   Tt.Acct_Name,
                          Tt.Terr_Id,
                          Tt.Bookings_Rank,
                          Tt.Total_Bookings,
                          Bt.Total_Bookings_2007,
                          Bt.Total_Bookings_2008,
                          Bt.Total_Bookings_2009) a1
   --Where Terr_Id = '40'
   Group By   Acct_Name,
              Terr_Id,
              Bookings_Rank,
              Total_Bookings,
              Total_Bookings_2007,
              Total_Bookings_2008,
              Total_Bookings_2009
   ;



