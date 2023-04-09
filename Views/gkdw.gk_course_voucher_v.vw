DROP VIEW GKDW.GK_COURSE_VOUCHER_V;

/* Formatted on 29/01/2021 11:38:55 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_VOUCHER_V
(
   EVXCOURSEID,
   COURSE_CODE,
   VOUCHER_COST
)
AS
   SELECT   evxcourseid,
            course_code,
            (max_unit_price * voucher_num) * NVL (redeem_pct_pad, .2)
               voucher_cost
     FROM         course_voucher@gkprod v
               INNER JOIN
                  gk_voucher_unit_price_mv@gkprod p
               ON v.voucher_type = p.voucher_type
            LEFT OUTER JOIN
               gk_voucher_redeem_v vr
            ON v.course_code = vr.coursecode;


