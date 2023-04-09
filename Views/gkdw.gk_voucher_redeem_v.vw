DROP VIEW GKDW.GK_VOUCHER_REDEEM_V;

/* Formatted on 29/01/2021 11:24:03 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_VOUCHER_REDEEM_V
(
   COURSECODE,
   VOUCHER_TYPE,
   REDEEM_PCT,
   REDEEM_PCT_PAD
)
AS
     SELECT   e.coursecode,
              c.voucher_type,
              SUM (CASE WHEN redeem_date IS NOT NULL THEN 1 ELSE 0 END)
              / COUNT (c.gk_coupon_num)
                 redeem_pct,
              ROUND (
                 SUM (CASE WHEN redeem_date IS NOT NULL THEN 1 ELSE 0 END)
                 / COUNT (c.gk_coupon_num),
                 2
              )
              + .20
                 redeem_pct_pad
       FROM         gk_coupon@evp c
                 INNER JOIN
                    event@evp e
                 ON c.evxeventid = e.evxeventid
              INNER JOIN
                 course_voucher@evp CV
              ON e.evxcourseid = CV.evxcourseid
      WHERE   CV.in_class_test = 'N'
   GROUP BY   e.coursecode, c.voucher_type
   UNION
     SELECT   e.coursecode,
              CV.voucher_type,
              1,
              1
       FROM      event@evp e
              INNER JOIN
                 course_voucher@evp CV
              ON e.evxcourseid = CV.evxcourseid
      WHERE   CV.in_class_test = 'Y'
   GROUP BY   e.coursecode, CV.voucher_type;


