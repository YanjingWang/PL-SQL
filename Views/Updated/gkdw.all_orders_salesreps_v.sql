


Create Or Alter View Hold.All_Orders_Salesreps_V
(
   Order_Id,
   Event_Id,
   Prod_Name,
   Product_Id,
   Enroll_Date,
   Enroll_Status,
   Book_Amt,
   Bill_Date,
   Bill_Status,
   Curr_Code,
   Taker,
   Cust_Id,
   Cust_Name,
   Zipcode,
   Country,
   State,
   Workphone,
   Email,
   Title,
   Salesrep,
   Territory_Id
)
As
   Select   Sales_Order_Id Order_Id,
            Null Event_Id,
            P.Prod_Name,
            P.Product_Id,
            Trunc (So.Creation_Date) Enroll_Date,
            So.Record_Type Enroll_Status,
            Book_Amt,
            Cast(Bill_Date As Date),
            Bill_Status,
            Curr_Code,
            Salesperson Taker,
            Cust_Id,
            C.Cust_Name,
            C.Zipcode,
            So.Country,
            Decode (Upper (C.Country), 'Canada', C.Province, C.State) State,
            C.Workphone,
            C.Email,
            Isnull(Trim (C.Title), 'N/A'),
            G.Salesrep,
            G.Territory_Id
     From            Gkdw.Sales_Order_Fact So
                  Left Outer Join
                     Gkdw.Product_Dim P
                  On So.Product_Id = P.Product_Id
               Left Outer Join
                  Gkdw.Cust_Dim C
               On So.Cust_Id = C.Cust_Id
            Left Outer Join
               Gkdw.Gk_Territory G
            On Substring(C.Zipcode, 1,  5) Between G.Zip_Start
                                            And  Substring(G.Zip_End, 1,  5)
               And Decode (Upper (C.Country), 'Canada', C.Province, C.State) =
                     Trim (Upper (G.State))
   Union All
   Select   Enroll_Id Order_Id,
            O.Event_Id,
            E.Course_Code,
            E.Course_Id,
            Cast(Enroll_Date As Date),
            Enroll_Status,
            Book_Amt,
            Cast(Bill_Date As Date),
            Bill_Status,
            Curr_Code,
            Salesperson,
            C.Cust_Id,
            Cust_Name,
            C.Zipcode,
            O.Country,
            Decode (Upper (C.Country), 'Canada', C.Province, C.State) State,
            C.Workphone,
            C.Email,
            Isnull(Trim (C.Title), 'N/A'),
            G.Salesrep,
            G.Territory_Id
     From            Gkdw.Order_Fact O
                  Left Outer Join
                     Gkdw.Event_Dim E
                  On O.Event_Id = E.Event_Id
               Left Outer Join
                  Gkdw.Cust_Dim C
               On O.Cust_Id = C.Cust_Id
            Left Outer Join
               Gkdw.Gk_Territory G
            On Substring(C.Zipcode, 1,  5) Between G.Zip_Start
                                            And  Substring(G.Zip_End, 1,  5)
               And Decode (Upper (C.Country), 'Canada', C.Province, C.State) =
                     Trim (Upper (G.State));



