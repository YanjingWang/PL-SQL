


Create Or Alter View Hold.Gk_Cdw_Onsite_V (Event_Id, Book_Amt)
As
     Select   Event_Id, Sum (Enroll_Amt) Book_Amt
       From   Gkdw.Gk_Onsite_Bookings_Mv
   Group By   Event_Id;



