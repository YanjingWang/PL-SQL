


Create Or Alter View Hold.Gk_Reenroll_V
(
   Orig_Enroll_Id,
   Transfer_Enroll_Id,
   Cancelled_Date
)
As
   Select   F1.Enroll_Id Orig_Enroll_Id,
            F2.Enroll_Id Transfer_Enroll_Id,
            F1.Enroll_Status_Date Cancelled_Date
     From               Gkdw.Order_Fact F1
                     Inner Join
                        Gkdw.Event_Dim E1
                     On F1.Event_Id = E1.Event_Id
                  Inner Join
                     Gkdw.Time_Dim Td
                  On F1.Enroll_Status_Date = Td.Dim_Date
               Inner Join
                  Gkdw.Order_Fact F2
               On F1.Cust_Id = F2.Cust_Id
                  And F2.Book_Date Between F1.Enroll_Status_Date
                                       And  F1.Enroll_Status_Date + 30
                  And F1.Enroll_Id != F2.Enroll_Id
            Inner Join
               Gkdw.Event_Dim E2
            On F2.Event_Id = E2.Event_Id And E1.Course_Id = E2.Course_Id
    Where       Td.Dim_Year >= 2007
            And F1.Enroll_Status = 'Cancelled'
            And E1.Event_Id != E2.Event_Id
            And F1.Book_Amt < 0
            And F2.Book_Amt > 0
            And F1.Transfer_Enroll_Id Is Null
   Union
   Select   F1.Enroll_Id Orig_Enroll_Id,
            F2.Enroll_Id Transfer_Enroll_Id,
            F1.Enroll_Status_Date Cancelled_Date
     From               Gkdw.Order_Fact F1
                     Inner Join
                        Gkdw.Event_Dim E1
                     On F1.Event_Id = E1.Event_Id
                  Inner Join
                     Gkdw.Time_Dim Td
                  On F1.Enroll_Status_Date = Td.Dim_Date
               Inner Join
                  Gkdw.Order_Fact F2
               On F1.Cust_Id = F2.Cust_Id
                  And F2.Book_Date Between F1.Enroll_Status_Date
                                       And  F1.Enroll_Status_Date + 30
                  And F1.Enroll_Id != F2.Enroll_Id
            Inner Join
               Gkdw.Event_Dim E2
            On F2.Event_Id = E2.Event_Id
               And Substring(E1.Course_Code, 1,  4) =
                     Substring(E2.Course_Code, 1,  4)
               And E1.Course_Id != E2.Course_Id
    Where       Td.Dim_Year >= 2007
            And F1.Enroll_Status = 'Cancelled'
            And E1.Event_Id != E2.Event_Id
            And F1.Book_Amt < 0
            And F2.Book_Amt > 0
            And F1.Transfer_Enroll_Id Is Null
   ;



