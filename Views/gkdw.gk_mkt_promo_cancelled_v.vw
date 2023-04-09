DROP VIEW GKDW.GK_MKT_PROMO_CANCELLED_V;

/* Formatted on 29/01/2021 11:33:05 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_MKT_PROMO_CANCELLED_V
(
   ENROLL_ID,
   STATUS_DATE,
   ADDL_INFO
)
AS
     SELECT   DISTINCT
              f.enroll_id "ENROLL_ID",
              f.creation_date "STATUS_DATE",
              'This promotion expired on '
              || TO_CHAR (f.creation_date, 'yyyy-mm-dd')
                 "ADDL_INFO"
       FROM         gk_promo_status@slx s
                 INNER JOIN
                    order_fact f
                 ON s.evxevenrollid = f.enroll_id
              INNER JOIN
                 cust_dim c
              ON f.cust_id = c.cust_id
      WHERE       UPPER (c.acct_name) LIKE '%WELLS%FARGO%'
              AND s.step = 'Promo Status'
              AND s.step_status IS NULL
   ORDER BY   status_date DESC;


