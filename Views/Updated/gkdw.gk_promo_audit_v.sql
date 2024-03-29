


Create Or Alter View Hold.Gk_Promo_Audit_V
(
   Evxevenrollid,
   Enroll_Status,
   Event_Id,
   Cust_Id,
   Cust_Name,
   First_Name,
   Last_Name,
   Account_Name,
   Address1,
   Address2,
   City,
   State,
   Postalcode,
   Workphone,
   Email,
   Enroll_Date,
   Keycode,
   Book_Date,
   Book_Amt,
   List_Price,
   Po_Number,
   Payment_Method,
   Salesperson,
   Sales_Rep,
   Start_Date,
   Course_Code,
   Short_Name,
   Ops_Country,
   Paid_Status,
   Paid_Status_Date,
   Po_Num,
   Po_Line_Num,
   Tracking_Num,
   Shipped_Date,
   Itemname,
   Tile_Response,
   Tile_Response_Date,
   Fulfilled_Status,
   Fulfilled_Status_Date,
   Promo_Status,
   Promo_Status_Date,
   Expiration_Date,
   Cust_Dim_Email,
   Promoname
)
As
   Select   Pa.Evxevenrollid,
            F.Enroll_Status,
            Ed.Event_Id,
            F.Cust_Id,
            C.Cust_Name,
            C.First_Name,
            C.Last_Name,
            Pa.Account_Name,
            Pa.Address1,
            Pa.Address2,
            Pa.City,
            Pa.State,
            Pa.Postalcode,
            Pa.Workphone,
            Pa.Email,
            F.Enroll_Date,
            F.Keycode,
            F.Book_Date,
            F.Book_Amt,
            F.List_Price,
            F.Po_Number,
            F.Payment_Method,
            F.Salesperson,
            F.Sales_Rep,
            Ed.Start_Date,
            Ed.Course_Code,
            Cd.Short_Name,
            Ed.Ops_Country,
            Pa.Paid_Status,
            Pa.Paid_Status_Date,
            Pf.Po_Num,
            Pf.Po_Line_Num,
            Pf.Tracking_Num,
            Pf.Shipped_Date,
            Pa.Itemname,
            Pa.Tile_Response,
            Pa.Tile_Response_Date,
            Pa.Fulfilled_Status,
            Pa.Fulfilled_Status_Date,
            Pa.Promo_Status,
            Pa.Promo_Status_Date,
            Case
               When Pa.Promo_Status = 'Expired' Then Pa.Promo_Status_Date
               Else Null
            End
               Expiration_Date,
            C.Email Cust_Dim_Email,
            Pa.Promoname
     From                  Gk_Promo_Audit_V@Gkhub Pa
                        Inner Join
                           Gkdw.Order_Fact F
                        On Pa.Evxevenrollid = F.Enroll_Id
                     Inner Join
                        Gkdw.Cust_Dim C
                     On F.Cust_Id = C.Cust_Id
                  Inner Join
                     Gkdw.Event_Dim Ed
                  On F.Event_Id = Ed.Event_Id
               Inner Join
                  Gkdw.Course_Dim Cd
               On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
            Left Outer Join
               Gkdw.Gk_Promo_Fulfilled_Orders Pf
            On Pa.Evxevenrollid = Pf.Enroll_Id
    Where   F.Enroll_Status != 'Cancelled';



