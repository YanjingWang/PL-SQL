


Create Or Alter View Hold.Gk_Daily_Sales_Bookings_V
(
   Type,
   Enroll_Id,
   Event_Id,
   Enroll_Status,
   Country,
   Book_Date,
   Rev_Date,
   Book_Amt,
   Course_Ch,
   Ch_Num,
   Course_Pl,
   Pl_Num,
   Course_Mod,
   Md_Num,
   Dim_Date,
   Book_Month,
   Book_Year,
   Day_Num,
   Fiscal_Week,
   Fiscal_Year,
   Payment
)
As
   Select   Distinct 'Oe' Type,
                     Enroll_Id,
                     Event_Id,
                     Enroll_Status,
                     Country,
                     Book_Date,
                     Rev_Date,
                     Book_Amt,
                     Course_Ch,
                     Ch_Num,
                     Course_Pl,
                     Pl_Num,
                     Course_Mod,
                     Md_Num,
                     Dim_Date,
                     Book_Month,
                     Book_Year,
                     Day_Num,
                     Fiscal_Week,
                     Fiscal_Year,
                     Payment_Type
     From   (Select   F.Enroll_Id,
                      F.Event_Id,
                      F.Enroll_Status,
                      Trunc (F.Book_Date) Book_Date,
                      F.Enroll_Date,
                      F.Rev_Date,
                      Round (F.Book_Amt) Book_Amt,
                      Cd.Course_Ch,
                      Cd.Ch_Num,
                      Cd.Course_Pl,
                      Cd.Pl_Num,
                      Cd.Course_Mod,
                      Cd.Md_Num,
                      Td1.Dim_Year Book_Year,
                      Format(Book_Date, 'D') Day_Num,
                      Td1.Dim_Month Book_Month,
                      Trunc (F.Book_Date) Dim_Date,
                      Td1.Fiscal_Year,
                      Td1.Fiscal_Week,
                      C.Country,
                      F.Payment_Method Payment_Type
               --,Sum(Book_Amt) Over(Partition By Cast(Book_Date As Date) Order By  Cast(Book_Date As Date)) Total_Booking
               From               Gkdw.Order_Fact F
                               Inner Join
                                  Gkdw.Event_Dim Ed
                               On F.Event_Id = Ed.Event_Id
                            Inner Join
                               Gkdw.Course_Dim Cd
                            On Ed.Course_Id = Cd.Course_Id
                               And Ed.Ops_Country = Cd.Country
                         Inner Join
                            Gkdw.Time_Dim Td1
                         On Trunc (F.Book_Date) = Td1.Dim_Date
                      Inner Join
                         Gkdw.Cust_Dim C
                      On F.Cust_Id = C.Cust_Id
              Where       Cd.Ch_Num = 10
                      And F.Book_Amt <> 0
                      And Td1.Fiscal_Year >= '2015' --And (Td1.Fiscal_Week = :P_Week Or :P_Week  Is Null)
                                                   --      And Substr(Upper(C.Country),1,2) = :P_Country
            ) a1
   Union
   -- Onsites/Dedicated/Enterprise
   Select   Distinct 'Dedicated' Type,
                     Evxevenrollid,
                     Evxeventid,
                     Enrollstatus,
                     Country,
                     Book_Date,
                     Rev_Date,
                     Book_Amt,
                     Course_Ch,
                     Ch_Num,
                     Course_Pl,
                     Pl_Num,
                     Course_Mod,
                     Md_Num,
                     Dim_Date,
                     Book_Month,
                     Book_Year,
                     Day_Num,
                     Fiscal_Week,
                     Fiscal_Year,
                     Payment_Type
     From   (Select   T.Evxevenrollid,
                      T.Evxeventid,
                      T.Enrollstatus,
                      T.Eventcountry Country,
                      Trunc (T.[Getutcdate()] - 1) Book_Date,
                      Trunc (T.[Getutcdate()] - 1) Enroll_Date,
                      T.Startdate Rev_Date,
                      T.Actual_Extended_Amount Book_Amt,
                      Cd.Course_Ch,
                      Cd.Ch_Num,
                      Cd.Course_Pl,
                      Cd.Pl_Num,
                      Cd.Course_Mod,
                      Cd.Md_Num,
                      Td1.Dim_Year Book_Year,
                      Td1.Dim_Month Book_Month,
                      Trunc (T.[Getutcdate()] - 1) Dim_Date,
                      Format(Trunc (T.[Getutcdate()] - 1), 'D') Day_Num,
                      Td1.Fiscal_Year,
                      Td1.Fiscal_Week,
                      Bp.Method Payment_Type
               From               Gkdw.Ent_Trans_Bookings_Mv T
                               Left Join
                                  Base.Evxbillpayment Bp
                               On T.Evxbillingid = Bp.Evxbillingid
                            Inner Join
                               Gkdw.Event_Dim Ed
                            On T.Evxeventid = Ed.Event_Id
                         Inner Join
                            Gkdw.Course_Dim Cd
                         On Ed.Course_Id = Cd.Course_Id
                            And Ed.Ops_Country = Cd.Country
                      Inner Join
                         Gkdw.Time_Dim Td1
                      On Trunc (T.[Getutcdate()] - 1) = Td1.Dim_Date
              Where   Round (T.Actual_Extended_Amount) <> 0
                      And Td1.Fiscal_Year >= '2015' --And (Td1.Fiscal_Week = :P_Week Or :P_Week  Is Null)
                                                   --And Substr(Upper(T.Eventcountry),1,2) =  :P_Country
            ) a2
   Union
   -- Digital ('A' Modality)
   Select   'Digital' Type,
            Enroll_Id,
            Event_Id,
            Enroll_Status,
            Country,
            Book_Date,
            Rev_Date,
            Book_Amt,
            Course_Ch,
            Ch_Num,
            Course_Pl,
            Pl_Num,
            Course_Mod,
            Md_Num,
            Dim_Date,
            Book_Month,
            Book_Year,
            Day_Num,
            Fiscal_Week,
            Fiscal_Year,
            Payment_Type
     From   (Select   F.Enroll_Id,
                      F.Event_Id,
                      F.Enroll_Status,
                      Trunc (F.Book_Date) Book_Date,
                      F.Enroll_Date,
                      F.Rev_Date,
                      F.Book_Amt Book_Amt,
                      Cd.Course_Ch,
                      Cd.Ch_Num,
                      Cd.Course_Pl,
                      Cd.Pl_Num,
                      Cd.Course_Mod,
                      Cd.Md_Num,
                      Td1.Dim_Year Book_Year,
                      Format(Book_Date, 'D') Day_Num,
                      Td1.Dim_Month Book_Month,
                      Trunc (F.Book_Date) Dim_Date,
                      Td1.Fiscal_Year,
                      Td1.Fiscal_Week,
                      C.Country                                   --A.Country,
                               ,
                      Sum(Book_Amt)
                         Over (Partition By Cast(Book_Date As Date)
                               Order By Cast(Book_Date As Date))
                         Total_Booking,
                      F.Payment_Method Payment_Type
               From               Gkdw.Order_Fact F
                               Inner Join
                                  Gkdw.Event_Dim Ed
                               On F.Event_Id = Ed.Event_Id
                            Inner Join
                               Gkdw.Course_Dim Cd
                            On Ed.Course_Id = Cd.Course_Id
                               And Ed.Ops_Country = Cd.Country
                         Inner Join
                            Gkdw.Time_Dim Td1
                         On Trunc (F.Book_Date) = Td1.Dim_Date
                      Inner Join
                         Gkdw.Cust_Dim C
                      On F.Cust_Id = C.Cust_Id
              Where       Cd.Md_Num = '33'
                      And F.Book_Amt <> 0
                      And Td1.Fiscal_Year >= '2015' --And (Td1.Fiscal_Week = :P_Week Or :P_Week  Is Null)
                                                   --       And Substr(Upper(C.Country),1,2) = :P_Country
            ) a3
   Union
   -- Prepay Card Sales
   Select   'Pack Sales' Type,
            Evxppcardid,
            Null,
            Null,
            Country,
            Book_Date,
            Null Rev_Date,
            Book_Amt,
            Null Course_Ch,
            Null Ch_Num,
            Null Course_Pl,
            Null Pl_Num,
            Null Course_Mod,
            Null Md_Num,
            Dim_Date,
            Book_Month,
            Book_Year,
            Day_Num,
            Fiscal_Week,
            Fiscal_Year,
            Payment_Type
     From   (Select   Ep.Evxppcardid,
                      Trunc (Ep.Issueddate) Book_Date,
                      Cardstatus,
                      Eo.Billtocountry Country,
                      Cardtype,
                      Ep.Valuepurchasedbase Book_Amt,
                      Td1.Dim_Year Book_Year,
                      Format(Ep.Issueddate, 'D') Day_Num,
                      Td1.Dim_Month Book_Month,
                      Trunc (Ep.Issueddate) Dim_Date,
                      Td1.Fiscal_Year,
                      Td1.Fiscal_Week,
                      Eb.Method Payment_Type
               From                  Base.Evxppcard Ep
                                  Inner Join
                                     Base.Evxso Eo
                                  On Ep.Evxsoid = Eo.Evxsoid
                               Inner Join
                                  Base.Evxppcard_Tx Et
                               On Ep.Evxppcardid = Et.Evxppcardid
                                  And Et.Transdesc = 'Purchase'
                            Inner Join
                               Gkdw.Ppcard_Dim Pp
                            On Ep.Evxppcardid = Pp.Ppcard_Id
                         Inner Join
                            Gkdw.Time_Dim Td1
                         On Trunc (Ep.Issueddate) = Td1.Dim_Date
                      Left Outer Join
                         Base.Evxbillpayment Eb
                      On Et.Evxppcard_Txid = Eb.Evxppcard_Txid
              Where   Td1.Fiscal_Year >= '2015' --And (Td1.Fiscal_Week = :P_Week Or :P_Week  Is Null)
                                               And Ep.Cardstatus != 'Void') a4
   Union
   -- Prepay Burn Down
   Select   Distinct 'Pack Burns' Type,
                     Evxppcardid,
                     Null,
                     Null,
                     Country,
                     Book_Date,
                     Rev_Date,
                     Book_Amt,
                     Null Course_Ch,
                     Null Ch_Num,
                     Null Course_Pl,
                     Null Pl_Num,
                     Null Course_Mod,
                     Null Md_Num,
                     Dim_Date,
                     Book_Month,
                     Book_Year,
                     Day_Num,
                     Fiscal_Week,
                     Fiscal_Year,
                     Payment_Type
     From   (Select   Ep.Evxppcardid,
                      Trunc (Et.Transdate) Book_Date,
                      Eo.Billtocountry Country,
                      Cardtype,
                      Et.Valueprepaybase Book_Amt,
                      Td1.Dim_Year Book_Year,
                      Format(Et.Transdate, 'D') Day_Num,
                      Td1.Dim_Month Book_Month,
                      Trunc (Et.Transdate) Dim_Date,
                      Td1.Fiscal_Year,
                      Td1.Fiscal_Week,
                      Isnull(Ee.Startdate, Es.Createdate) Rev_Date,
                      Eb.Method Payment_Type
               From                           Base.Evxppcard Ep
                                           --    Inner Join Gkdw.Ppcard_Dim Pp On Ep.Evxppcardid = Pp.Ppcard_Id
                                           Inner Join
                                              Base.Evxso Eo
                                           On Ep.Evxsoid = Eo.Evxsoid
                                        Inner Join
                                           Base.Evxppcard_Tx Et
                                        On Ep.Evxppcardid = Et.Evxppcardid
                                           And Et.Transdesc != 'Purchase'
                                     Inner Join
                                        Gkdw.Time_Dim Td1
                                     On Trunc (Et.Transdate) = Td1.Dim_Date
                                  Left Outer Join
                                     Base.Evxbillpayment Eb
                                  On Et.Evxbillpaymentid =
                                        Eb.Evxbillpaymentid
                               Left Outer Join
                                  Base.Qg_Billingpayment Qb
                               On Eb.Evxbillpaymentid = Qb.Evxbillpaymentid
                            Left Outer Join
                               Base.Evxenrollhx Eh
                            On Qb.Evxevenrollid = Eh.Evxevenrollid
                         Left Outer Join
                            Base.Evxevent Ee
                         On Eh.Evxeventid = Ee.Evxeventid
                      Left Outer Join
                         Base.Evxso Es
                      On Eb.Evxsoid = Es.Evxsoid
              Where   Td1.Fiscal_Year >= '2015' And -- (Td1.Fiscal_Week = :P_Week Or :P_Week  Is Null) And
                                                   Ep.Cardstatus != 'Void' --And Substr(Upper(Eo.Billtocountry),1,2) = :P_Country
                                                                          ) a5;



