DROP VIEW GKDW.GK_ENROLL_LEADSOURCE_V;

/* Formatted on 29/01/2021 11:37:38 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ENROLL_LEADSOURCE_V
(
   ENROLL_ID,
   TXFEE_ID,
   KEYCODE,
   ITEMID,
   ABBREVDESC
)
AS
   SELECT   enroll_id,
            txfee_id,
            keycode,
            CL.ITEMID,
            L.ABBREVDESC
     FROM         order_FAct f
               JOIN
                  slxdw.qg_contactleadsource cl
               ON cl.itemid = F.ENROLL_ID
            JOIN
               SLXDW.LEADSOURCE l
            ON CL.LEADSOURCEID = L.LEADSOURCEID
    WHERE       enroll_date >= '01-JAN-2014'
            AND F.GKDW_SOURCE = 'SLXDW'
            AND F.KEYCODE <> L.ABBREVDESC;


