DROP VIEW GKDW.TPS_3_NEW_PACK_V;

/* Formatted on 29/01/2021 11:22:34 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.TPS_3_NEW_PACK_V
(
   EVXPPCARDID,
   ISSUEDDATE,
   CARDSHORTCODE,
   CARDSTATUS,
   BILLTOCOUNTRY,
   CARDTYPE,
   EVENTPASSCOUNTAVAILABLE,
   EVENTPASSCOUNTREDEEMED,
   EVENTPASSCOUNTTOTAL,
   ISSUEDTOCONTACT,
   ISSUEDTOACCOUNT,
   VALUEPURCHASEDBASE,
   VALUEREDEEMEDBASE,
   VALUEBALANCEBASE,
   SALESPERSON,
   SHIP_TO_ZIPCODE,
   BILL_TO_ZIPCODE,
   ORDERED_BY_ZIPCODE,
   ORDERED_BY_PROVINCE,
   SALES_REP
)
AS
     SELECT   ep.evxppcardid,
              ep.issueddate,
              cardshortcode,
              cardstatus,
              eo.billtocountry,
              cardtype,
              eventpasscountavailable,
              eventpasscountredeemed,
              eventpasscounttotal,
              issuedtocontact,
              issuedtoaccount,
              valuepurchasedbase,
              valueredeemedbase,
              valuebalancebase,
              so.salesperson,
              so.ship_to_zipcode,
              so.bill_to_zipcode,
              so.ordered_by_zipcode,
              so.ordered_by_province,
              CASE
                 WHEN pp.ob_rep_name IS NOT NULL THEN pp.ob_rep_name
                 WHEN pp.iam_rep_name IS NOT NULL THEN pp.iam_rep_name
                 WHEN pp.tam_rep_name IS NOT NULL THEN pp.tam_rep_name
                 WHEN pp.nam_rep_name IS NOT NULL THEN pp.nam_rep_name
                 WHEN pp.fsd_rep_name IS NOT NULL THEN pp.fsd_rep_name
              END
                 sales_rep
       FROM            slxdw.evxppcard ep
                    INNER JOIN
                       slxdw.evxso eo
                    ON ep.evxsoid = eo.evxsoid
                 INNER JOIN
                    gkdw.sales_order_fact so
                 ON eo.evxsoid = so.sales_order_id
              INNER JOIN
                 gkdw.ppcard_dim pp
              ON ep.evxppcardid = pp.ppcard_id
      WHERE   ep.issueddate >= TO_DATE ('1/1/2014', 'mm/dd/yyyy')
              AND ep.cardstatus != 'Void'
   ORDER BY   1;


