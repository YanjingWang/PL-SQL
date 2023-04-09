DROP MATERIALIZED VIEW GKDW.GK_POD_MV;
CREATE MATERIALIZED VIEW GKDW.GK_POD_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE
START WITH TO_DATE('04-Feb-2021 02:00:00','dd-mon-yyyy hh24:mi:ss')
NEXT TRUNC(SYSDATE+7)+1/12  
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:23:26 (QP5 v5.115.810.9015) */
SELECT   t1.enroll_id,
         t1.event_id,
         t1.enroll_date,
         t1.keycode,
         t1.book_date,
         t1.book_amt,
         t1.curr_code,
         t1.promo_code,
         t1.enroll_status,
         t1.pp_sales_order_id,
         t1.po_number,
         t1.ppcard_id,
         t1.payment_method,
         t1.reg_code,
         t2.start_date,
         t3.course_name,
         t3.course_code,
         t4.cust_name,
         t4.email,
         t4.workphone,
         t1.source,
         t1.bal_due,
         t3.course_ch,
         t3.course_mod,
         t3.course_pl,
         t5.national_terr_id,
         t6.dim_month,
         t6.dim_year,
         t7.ob_comm_type,
         t8.territory_id,
         t8.salesrep,
         t8.state,
         CASE
            WHEN t7.ob_comm_type IN ('63', '9', 'Named Account', 'none')
            THEN
               t7.ob_comm_type
            WHEN t5.national_terr_id IS NOT NULL
            THEN
               t5.national_terr_id
            ELSE
               t8.territory_id
         END
            rev_territory
  FROM                        order_fact t1
                           INNER JOIN
                              event_dim t2
                           ON t1.event_id = t2.event_id
                        INNER JOIN
                           course_dim t3
                        ON t2.course_id = t3.course_id
                           AND t2.ops_country = t3.country
                     INNER JOIN
                        cust_dim t4
                     ON t1.cust_id = t4.cust_id
                  INNER JOIN
                     time_dim t6
                  ON t1.rev_date = t6.dim_date
               INNER JOIN
                  account_dim t5
               ON t4.acct_id = t5.acct_id
            LEFT OUTER JOIN
               gk_channel_partner t7
            ON t1.keycode = t7.partner_key_code
         LEFT OUTER JOIN
            gk_territory t8
         ON t4.zipcode BETWEEN t8.zip_start AND t8.zip_end
 WHERE       t6.dim_year >= 2009
         AND t3.course_ch = 'INDIVIDUAL/PUBLIC'
         AND NVL (t8.territory_type, 'OB') = 'OB';

COMMENT ON MATERIALIZED VIEW GKDW.GK_POD_MV IS 'snapshot table for snapshot GKDW.GK_POD_MV';

GRANT SELECT ON GKDW.GK_POD_MV TO DWHREAD;

