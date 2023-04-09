DROP VIEW GKDW.GK_ENROLL_PROMO_COST_V;

/* Formatted on 29/01/2021 11:37:34 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ENROLL_PROMO_COST_V
(
   ENROLL_ID,
   CONTACTID,
   LEADSOURCEID,
   DESCRIPTION,
   KEYCODE,
   ITEM_COST
)
AS
     SELECT   itemid enroll_id,
              contactid,
              cl.leadsourceid,
              l.description,
              L.abbrevdesc keycode,
              MAX (mfg_price) item_cost
       FROM         slxdw.qg_contactleadsource cl
                 INNER JOIN
                    slxdw.leadsource l
                 ON cl.leadsourceid = l.leadsourceid
              INNER JOIN
                 gk_ipad_promo_keycode k
              ON l.abbrevdesc = k.keycode
   GROUP BY   itemid,
              contactid,
              cl.leadsourceid,
              l.description,
              L.abbrevdesc;


