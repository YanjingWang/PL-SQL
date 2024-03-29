


Create Or Alter View Hold.Gk_Prepay_Trans_V
(
   Prepaycard,
   Salesorder,
   Transdate,
   Transtype,
   Order_Num,
   Order_Type,
   Account,
   Contact,
   Valuestatementtotal
)
As
   Select   Et.Evxppcardid Prepaycard,
            Ep.Evxsoid Salesorder,
            Transdate,
            Transtype,
            Isnull(Eb.Evxsoid, Qb.Evxevenrollid) Order_Num,
            Case When Eb.Evxsoid = '' Then 'Enrollment' Else 'Salesorder' End Order_Type,
            Isnull(Eb.Attendeeaccount, Es.Shiptoaccount) Account,
            Isnull(Eb.Attendeecontact, Es.Shiptocontact) Contact,
            Valuestatementtotal
     From               Base.Evxppcard_Tx Et
                     Inner Join
                        Base.Evxppcard Ep
                     On Et.Evxppcardid = Ep.Evxppcardid
                  Inner Join
                     Base.Evxbillpayment Eb
                  On Et.Evxbillpaymentid = Eb.Evxbillpaymentid
               Left Outer Join
                  Base.Qg_Billingpayment Qb
               On Eb.Evxbillpaymentid = Qb.Evxbillpaymentid
            Left Outer Join
               Base.Evxso Es
            On Eb.Evxsoid = Es.Evxsoid
    Where   Transtype In ('Redeemed', 'Redeem Reverse');



