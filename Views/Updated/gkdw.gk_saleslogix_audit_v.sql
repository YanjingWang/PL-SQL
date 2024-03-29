


Create Or Alter View Hold.Gk_Saleslogix_Audit_V
(
   Enroll_Date,
   Enroll_So_Id,
   Record_Type,
   Status,
   Status_Desc,
   Tx_Date,
   Soldbyuser,
   Amount,
   Bill_Date,
   Contact,
   Account,
   Evxbillingid,
   Oracletxid,
   Oracletx_Create,
   Ordertype,
   Transactiontype,
   Evxppcardid,
   Actualamountlesstax,
   Trx_Number,
   Name,
   Type,
   Ra_Source,
   Feetype,
   Method,
   Evxevticketid,
   Source,
   Shiptocountry
)
As
   Select   Eh.Createdate Enroll_Date,
            Eh.Evxevenrollid Enroll_So_Id,
            'Enrollment' Record_Type,
            Eh.Enrollstatus Status,
            Eh.Enrollstatusdesc Status_Desc,
            Et.Createdate Tx_Date,
            Et.Soldbyuser,
            Et.Actualamount Amount,
            Et.Billingdate Bill_Date,
            Billtocontact Contact,
            Et.Billtoaccount Account,
            Et.Evxbillingid,
            Oh.Oracletxid,
            Oh.Createdate Oracletx_Create,
            Oh.Ordertype,
            Oh.Transactiontype,
            Oh.Evxppcardid,
            Oh.Actualamountlesstax,
            Rct.Trx_Number,
            Rctt.Name,
            Rctt.Type,
            Interface_Header_Context Ra_Source,
            Et.Feetype,
            Eb.Method,
            Et.Evxevticketid,
            Oh.Source,
            Ee.Eventcountry Shiptocountry
     From                     Gkdw.Evxenrollhx Eh
                           Inner Join
                              Gkdw.Qg_Event Ee
                           On Eh.Evxeventid = Ee.Evxeventid
                        Inner Join
                           Gkdw.Evxev_Txfee Et
                        On Eh.Evxevenrollid = Et.Evxevenrollid
                     Inner Join
                        Gkdw.Evxbillpayment Eb
                     On Et.Evxbillingid = Eb.Evxbillingid
                  Inner Join
                     Gkdw.Oracletx_History Oh
                  On Et.Evxevenrollid = Oh.Evxevenrollid
                     And Et.Evxbillingid = Oh.Evxbillingid
               Inner Join
                  Ra_Customer_Trx_All@R12prd Rct
               On     Oh.Evxevenrollid = Rct.Interface_Header_Attribute1
                  And Eb.Evxbillingid = Rct.Interface_Header_Attribute3
                  And Interface_Header_Context = 'Gk Order Interface'
            Inner Join
               Ra_Cust_Trx_Types_All@R12prd Rctt
            On Rct.Cust_Trx_Type_Id = Rctt.Cust_Trx_Type_Id
               And Rct.Org_Id = Rctt.Org_Id
    Where   Eh.Createdate >= To_Date ('10/3/2005', 'Mm/Dd/Yyyy')
   Union
   Select   Eh.Createdate Enroll_Date,
            Eh.Evxevenrollid Enroll_So_Id,
            'Enrollment' Record_Type,
            Eh.Enrollstatus Status,
            Eh.Enrollstatusdesc Status_Desc,
            Et.Createdate Tx_Date,
            Et.Soldbyuser,
            Et.Actualamount Amount,
            Et.Billingdate Bill_Date,
            Billtocontact Contact,
            Et.Billtoaccount Account,
            Et.Evxbillingid,
            Oh.Oracletxid,
            Oh.Createdate Oracletx_Create,
            Oh.Ordertype,
            Oh.Transactiontype,
            Oh.Evxppcardid,
            Oh.Actualamountlesstax,
            Rct.Trx_Number,
            Rctt.Name,
            Rctt.Type,
            Isnull(Interface_Header_Context, 'Manual'),
            Et.Feetype,
            Eb.Method,
            Et.Evxevticketid,
            Oh.Source,
            Ee.Eventcountry Shiptocountry
     From                     Gkdw.Evxenrollhx Eh
                           Inner Join
                              Gkdw.Qg_Event Ee
                           On Eh.Evxeventid = Ee.Evxeventid
                        Inner Join
                           Gkdw.Evxev_Txfee Et
                        On Eh.Evxevenrollid = Et.Evxevenrollid
                     Inner Join
                        Gkdw.Evxbillpayment Eb
                     On Et.Evxbillingid = Eb.Evxbillingid
                  Inner Join
                     Gkdw.Oracletx_History Oh
                  On Et.Evxevenrollid = Oh.Evxevenrollid
                     And Et.Evxbillingid = Oh.Evxbillingid
               Inner Join
                  Ra_Customer_Trx_All@R12prd Rct
               On     Oh.Evxevenrollid = Rct.Interface_Header_Attribute1
                  And Eb.Evxbillingid <> Rct.Interface_Header_Attribute3
                  And Interface_Header_Context Is Null
            Inner Join
               Ra_Cust_Trx_Types_All@R12prd Rctt
            On Rct.Cust_Trx_Type_Id = Rctt.Cust_Trx_Type_Id
               And Rct.Org_Id = Rctt.Org_Id
    Where   Eh.Createdate >= To_Date ('10/3/2005', 'Mm/Dd/Yyyy')
   Union
   Select   Eh.Createdate Enroll_Date,
            Eh.Evxevenrollid Enroll_So_Id,
            'Enrollment' Record_Type,
            Eh.Enrollstatus Status,
            Eh.Enrollstatusdesc Status_Desc,
            Et.Createdate Tx_Date,
            Et.Soldbyuser,
            Et.Actualamount Amount,
            Et.Billingdate Bill_Date,
            Billtocontact Contact,
            Et.Billtoaccount Account,
            Et.Evxbillingid,
            Oh.Oracletxid,
            Oh.Createdate Oracletx_Create,
            Oh.Ordertype,
            Oh.Transactiontype,
            Oh.Evxppcardid,
            Oh.Actualamountlesstax,
            Null,
            Null,
            Null,
            Null,
            Et.Feetype,
            Eb.Method,
            Et.Evxevticketid,
            Oh.Source,
            Ee.Eventcountry Shiptocountry
     From               Gkdw.Evxenrollhx Eh
                     Inner Join
                        Gkdw.Qg_Event Ee
                     On Eh.Evxeventid = Ee.Evxeventid
                  Inner Join
                     Gkdw.Evxev_Txfee Et
                  On Eh.Evxevenrollid = Et.Evxevenrollid
               Inner Join
                  Gkdw.Evxbillpayment Eb
               On Et.Evxbillingid = Eb.Evxbillingid
            Left Outer Join
               Gkdw.Oracletx_History Oh
            On Et.Evxevenrollid = Oh.Evxevenrollid
               And Et.Evxbillingid = Oh.Evxbillingid
    Where   Eh.Createdate >= To_Date ('10/3/2005', 'Mm/Dd/Yyyy')
            And Not Exists
                  (Select   1
                     From   Ra_Customer_Trx_All@R12prd
                    Where   Interface_Header_Attribute1 = Eh.Evxevenrollid)
   Union
   Select   Es.Createdate,
            Es.Evxsoid,
            'Salesorder',
            Es.Sostatus,
            Null,
            Es.Shippeddate,
            Es.Soldbyuser,
            Es.Totalnotax,
            Eb.Createdate,
            Eb.Receivedfromcontact,
            Eb.Receivedfromaccount,
            Evxbillpaymentid,
            Oh.Oracletxid,
            Oh.Createdate,
            Oh.Ordertype,
            Oh.Transactiontype,
            Oh.Evxppcardid,
            Oh.Actualamountlesstax,
            Rct.Trx_Number,
            Rctt.Name,
            Rctt.Type,
            Interface_Header_Context,
            Null,
            Eb.Method,
            Eb.Evxevticketid,
            Oh.Source,
            Es.Shiptocountry
     From               Gkdw.Evxso Es
                     Left Outer Join
                        Gkdw.Evxbillpayment Eb
                     On Es.Evxsoid = Eb.Evxsoid
                  Left Outer Join
                     Gkdw.Oracletx_History Oh
                  On Eb.Evxsoid = Oh.Evxeventid
               Left Outer Join
                  Ra_Customer_Trx_All@R12prd Rct
               On Eb.Evxsoid = Rct.Interface_Header_Attribute1
            Left Outer Join
               Ra_Cust_Trx_Types_All@R12prd Rctt
            On Rct.Cust_Trx_Type_Id = Rctt.Cust_Trx_Type_Id
               And Rct.Org_Id = Rctt.Org_Id
    Where   Recordtype = 'Salesorder'
            And Es.Createdate >= To_Date ('10/3/2005', 'Mm/Dd/Yyyy')
   Union
   Select   Es.Createdate,
            Es.Evxsoid,
            'Prepayorder',
            Es.Sostatus,
            Null,
            Es.Createdate,
            Es.Soldbyuser,
            Es.Totalnotax,
            Eb.Createdate,
            Eb.Receivedfromcontact,
            Eb.Receivedfromaccount,
            Evxbillpaymentid,
            Oh.Oracletxid,
            Oh.Createdate,
            Oh.Ordertype,
            Oh.Transactiontype,
            Oh.Evxevenrollid,
            Oh.Actualamountlesstax,
            Rct.Trx_Number,
            Rctt.Name,
            Rctt.Type,
            Interface_Header_Context,
            Null,
            Eb.Method,
            Eb.Evxevticketid,
            Oh.Source,
            Es.Shiptocountry
     From               Gkdw.Evxso Es
                     Left Outer Join
                        Gkdw.Evxbillpayment Eb
                     On Es.Evxsoid = Eb.Evxsoid
                  Left Outer Join
                     Gkdw.Oracletx_History Oh
                  On Eb.Evxsoid = Oh.Evxeventid
               Left Outer Join
                  Ra_Customer_Trx_All@R12prd Rct
               On Oh.Evxevenrollid = Rct.Interface_Header_Attribute1
            Left Outer Join
               Ra_Cust_Trx_Types_All@R12prd Rctt
            On Rct.Cust_Trx_Type_Id = Rctt.Cust_Trx_Type_Id
               And Rct.Org_Id = Rctt.Org_Id
    Where   Sotype = 'Prepay Card'
            And Es.Createdate >= To_Date ('10/3/2005', 'Mm/Dd/Yyyy');



