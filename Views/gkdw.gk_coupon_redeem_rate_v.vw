DROP VIEW GKDW.GK_COUPON_REDEEM_RATE_V;

/* Formatted on 29/01/2021 11:40:34 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COUPON_REDEEM_RATE_V
(
   COURSE_ID,
   ISSUED_CNT,
   REDEEM_CNT,
   REDEEM_RATE
)
AS
     SELECT   cd.course_id,
              COUNT ( * ) issued_cnt,
              SUM (CASE WHEN redeem_date IS NOT NULL THEN 1 ELSE 0 END)
                 redeem_cnt,
              ROUND (
                 (SUM (CASE WHEN redeem_date IS NOT NULL THEN 1 ELSE 0 END)
                  / COUNT ( * ))
                 + .1,
                 2
              )
                 redeem_rate
       FROM         gk_coupon@gkprod gc
                 INNER JOIN
                    event_dim ed
                 ON gc.evxeventid = ed.event_id
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
   GROUP BY   cd.course_id
   UNION
     SELECT   pd.product_id,
              COUNT ( * ) issued_cnt,
              SUM (CASE WHEN redeem_date IS NOT NULL THEN 1 ELSE 0 END)
                 redeem_cnt,
              ROUND (
                 (SUM (CASE WHEN redeem_date IS NOT NULL THEN 1 ELSE 0 END)
                  / COUNT ( * ))
                 + .1,
                 2
              )
                 redeem_rate
       FROM      gk_coupon@gkprod gc
              INNER JOIN
                 product_dim pd
              ON gc.evxeventid = pd.product_id
   GROUP BY   pd.product_id;


