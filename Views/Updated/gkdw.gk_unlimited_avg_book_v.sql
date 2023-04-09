


Create Or Alter View Hold.Gk_Unlimited_Avg_Book_V
(
   Cust_Id,
   Enroll_Cnt,
   Book_Amt
)
As
     Select   Cust_Id, Count ( * ) Enroll_Cnt, 4400 / Count ( * ) Book_Amt
       From   Gkdw.Order_Fact
      Where       Attendee_Type = 'Unlimited'
              And Book_Amt = 0
              And Enroll_Status != 'Cancelled'
   Group By   Cust_Id;



