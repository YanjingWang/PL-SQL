


Create Or Alter View Hold.Tps_3_New_Pack_V
(
   Evxppcardid,
   Issueddate,
   Cardshortcode,
   Cardstatus,
   Billtocountry,
   Cardtype,
   Eventpasscountavailable,
   Eventpasscountredeemed,
   Eventpasscounttotal,
   Issuedtocontact,
   Issuedtoaccount,
   Valuepurchasedbase,
   Valueredeemedbase,
   Valuebalancebase,
   Salesperson,
   Ship_To_Zipcode,
   Bill_To_Zipcode,
   Ordered_By_Zipcode,
   Ordered_By_Province,
   Sales_Rep
)
As
     Select   Ep.Evxppcardid,
              Ep.Issueddate,
              Cardshortcode,
              Cardstatus,
              Eo.Billtocountry,
              Cardtype,
              Eventpasscountavailable,
              Eventpasscountredeemed,
              Eventpasscounttotal,
              Issuedtocontact,
              Issuedtoaccount,
              Valuepurchasedbase,
              Valueredeemedbase,
              Valuebalancebase,
              So.Salesperson,
              So.Ship_To_Zipcode,
              So.Bill_To_Zipcode,
              So.Ordered_By_Zipcode,
              So.Ordered_By_Province,
              Case
                 When Pp.Ob_Rep_Name Is Not Null Then Pp.Ob_Rep_Name
                 When Pp.Iam_Rep_Name Is Not Null Then Pp.Iam_Rep_Name
                 When Pp.Tam_Rep_Name Is Not Null Then Pp.Tam_Rep_Name
                 When Pp.Nam_Rep_Name Is Not Null Then Pp.Nam_Rep_Name
                 When Pp.Fsd_Rep_Name Is Not Null Then Pp.Fsd_Rep_Name
              End
                 Sales_Rep
       From            Base.Evxppcard Ep
                    Inner Join
                       Base.Evxso Eo
                    On Ep.Evxsoid = Eo.Evxsoid
                 Inner Join
                    Gkdw.Sales_Order_Fact So
                 On Eo.Evxsoid = So.Sales_Order_Id
              Inner Join
                 Gkdw.Ppcard_Dim Pp
              On Ep.Evxppcardid = Pp.Ppcard_Id
      Where   Ep.Issueddate >= To_Date ('1/1/2014', 'Mm/Dd/Yyyy')
              And Ep.Cardstatus != 'Void'
   ;



