


Create Or Alter View Hold.Gk_Bookings_Terr_All_V
(
   Terr_Id,
   Acct_Id,
   Acct_Name,
   Total_Bookings,
   Bookings_Rank
)
As
     Select   Terr_Id,
              Acct_Id,
              Acct_Name,
              Total_Bookings,
              Bookings_Rank
       From   (  Select   Lpad (Territory_Id, 2, '0') Terr_Id,
                          Acct_Id,
                          Acct_Name,
                          Sum (Book_Amt) Total_Bookings,
                          Rank ()
                             Over (Partition By Lpad (Territory_Id, 2, '0')
                                   Order By Sum (Book_Amt) Desc)
                             Bookings_Rank
                   From   Gkdw.Gk_Open_Enrollment_Mv
                  Where       Book_Year >= 2007
                          And (Itbt_Flag = 'Itbt' Or Itbt_Flag Is Null)
                          And Ch_Flag = 'N'
                          And Nat_Flag = 'N'
                          And Mta_Flag = 'N'
               Group By   Lpad (Territory_Id, 2, '0'), Acct_Id, Acct_Name) a1
   ;



