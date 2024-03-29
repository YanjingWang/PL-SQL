


Create Or Alter View Hold.Gk_Tx_Book_Audit_V
(
   Bookdate,
   Source,
   Ordertype,
   Event_Channel,
   Event_Modality,
   Event_Prod_Line,
   Tr_Type,
   Tx_Cnt,
   Tx_Amt,
   Bk_Cnt,
   Bk_Amt,
   Method
)
As
     Select   Bookdate,
              Source,
              Ordertype,
              Event_Channel,
              Event_Modality,
              Event_Prod_Line,
              Tr_Type,
              Sum (Tx_Cnt) Tx_Cnt,
              Sum (Tx_Amt) Tx_Amt,
              Sum (Bk_Cnt) Bk_Cnt,
              Sum (Bk_Amt) Bk_Amt,
              Method
       From   (  Select   Cast(Bookdate As Date) Bookdate,
                          Case
                             When Country = 'Canada' Then 'Ca_Ops'
                             Else 'Us_Ops'
                          End
                             Source,
                          Case
                             When Orderstatus In ('Attended', 'Confirmed')
                             Then
                                'Invoice'
                             When Enroll_Status = 'Shipped'
                             Then
                                'Invoice'
                             When Orderstatus = 'Cancelled'
                             Then
                                'Credit'
                             Else
                                Enroll_Status
                          End
                             Ordertype,
                          Ch_Desc Event_Channel,
                          Md_Desc Event_Modality,
                          Pl_Desc Event_Prod_Line,
                          'Standard' Tr_Type,
                          0 Tx_Cnt,
                          0 Tx_Amt,
                          Count (Distinct Enrollid) Bk_Cnt,
                          Sum (Round (Enroll_Amt)) Bk_Amt,
                          Case
                             When Bp.Method = 'Prepay Card'
                                  Or Bp1.Method = 'Prepay Card'
                             Then
                                'Prepay'
                             Else
                                'Standard'
                          End
                             Method
                   From               Gkdw.Gk_Daily_Bookings_V B
                                   Left Outer Join
                                      Gkdw.Evxev_Txfee Et
                                   On B.Evxev_Txfeeid = Et.Evxev_Txfeeid
                                Left Outer Join
                                   Gkdw.Evxbilling Eb
                                On Et.Evxbillingid = Eb.Evxbillingid
                             Left Outer Join
                                Gkdw.Evxbillpayment Bp
                             On Eb.Evxbillingid = Bp.Evxbillingid
                          Left Outer Join
                             Gkdw.Evxbillpayment Bp1
                          On B.Enrollid = Bp1.Evxsoid
                  Where   Ch_Value In ('10', '40')
               Group By   Cast(Bookdate As Date),
                          Case
                             When Country = 'Canada' Then 'Ca_Ops'
                             Else 'Us_Ops'
                          End,
                          Case
                             When Orderstatus In ('Attended', 'Confirmed')
                             Then
                                'Invoice'
                             When Enroll_Status = 'Shipped'
                             Then
                                'Invoice'
                             When Orderstatus = 'Cancelled'
                             Then
                                'Credit'
                             Else
                                Enroll_Status
                          End,
                          Ch_Desc,
                          Md_Desc,
                          Pl_Desc,
                          Case
                             When Bp.Method = 'Prepay Card'
                                  Or Bp1.Method = 'Prepay Card'
                             Then
                                'Prepay'
                             Else
                                'Standard'
                          End
               Union All
                 Select   Cast(Createdate As Date) Bookdate,
                          Source,
                          Ordertype,
                          C.Course_Ch,
                          C.Course_Mod,
                          C.Course_Pl,
                          Case
                             When Transactiontype = 'Recapture' Then 'Breakage'
                             Else 'Standard'
                          End
                             Tr_Type,
                          Count (Evxevenrollid) Tx_Cnt,
                          Sum (Round (Actualamountlesstax)) Tx_Amt,
                          0 Bk_Cnt,
                          0 Bk_Amt,
                          Case
                             When Evxppcardid Is Not Null Then 'Prepay'
                             Else 'Standard'
                          End
                             Method
                   From         Gkdw.Oracletx_History H
                             Inner Join
                                Gkdw.Event_Dim E
                             On H.Evxeventid = E.Event_Id
                          Inner Join
                             Gkdw.Course_Dim C
                          On E.Course_Id = C.Course_Id
                             And E.Ops_Country = C.Country
                  Where   C.Ch_Num In ('10', '40')
                          And (Transactiontype != 'Recapture'
                               Or Transactiontype Is Null)
               Group By   Cast(Createdate As Date),
                          Source,
                          Ordertype,
                          C.Course_Ch,
                          C.Course_Mod,
                          C.Course_Pl,
                          Case
                             When Transactiontype = 'Recapture' Then 'Breakage'
                             Else 'Standard'
                          End,
                          Case
                             When Evxppcardid Is Not Null Then 'Prepay'
                             Else 'Standard'
                          End
               Union All
                 Select   Cast(Createdate As Date) Bookdate,
                          H.Source,
                          Ordertype,
                          P.Prod_Channel,
                          P.Prod_Modality,
                          P.Prod_Line,
                          Case
                             When Transactiontype = 'Recapture' Then 'Breakage'
                             Else 'Standard'
                          End
                             Tr_Type,
                          Count (Evxevenrollid) Tx_Cnt,
                          Case
                             When Ordertype = 'Credit' Then 0
                             Else Sum (Round (Actualamountlesstax))
                          End
                             Tx_Amt,
                          0 Bk_Cnt,
                          0 Bk_Amt,
                          Case
                             When Evxppcardid Is Not Null Then 'Prepay'
                             Else 'Standard'
                          End
                             Method
                   From         Gkdw.Oracletx_History H
                             Inner Join
                                Gkdw.Sales_Order_Fact S
                             On H.Evxeventid = S.Sales_Order_Id
                          Inner Join
                             Gkdw.Product_Dim P
                          On S.Product_Id = P.Product_Id
                  Where   P.Prod_Channel = 'Individual/Public'
                          And (Transactiontype != 'Recapture'
                               Or Transactiontype Is Null)
               Group By   Cast(Createdate As Date),
                          H.Source,
                          Ordertype,
                          P.Prod_Channel,
                          P.Prod_Modality,
                          P.Prod_Line,
                          Case
                             When Transactiontype = 'Recapture' Then 'Breakage'
                             Else 'Standard'
                          End,
                          Case
                             When Evxppcardid Is Not Null Then 'Prepay'
                             Else 'Standard'
                          End) a1
      Where   Bookdate > Cast(Getutcdate() As Date) - 30
   Group By   Bookdate,
              Source,
              Ordertype,
              Event_Channel,
              Event_Modality,
              Event_Prod_Line,
              Tr_Type,
              Method;



