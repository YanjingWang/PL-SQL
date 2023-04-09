DROP MATERIALIZED VIEW GKDW.GK_ARRA_ACT_ORDERS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ARRA_ACT_ORDERS_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:19:30 (QP5 v5.115.810.9015) */
  SELECT   o.enroll_id,
           o.event_id,
           o.cust_id,
           o.acct_id,
           o.book_date,
           o.rev_date,
           o.acct_name,
           o.cust_name,
           o.source,
           o.keycode,
           o.payment_method,
           o.ppcard_id,
           o.book_amt,
           o.course_code,
           o.course_name,
           o.ch_num,
           o.course_ch,
           o.md_num,
           o.course_mod,
           o.pl_num,
           o.course_pl,
           o.cust_city,
           o.cust_state,
           o.cust_country,
           COUNT (DISTINCT h.activityid) act_no,
           h.accountname act_acct,
           MAX (h.completeddate) act_comp_date,
           h.createuser act_create_userid,
           u1.username act_create_user,
           h.completeduser act_comp_userid,
           u2.username act_comp_user,
           td1.dim_week book_week,
           td1.dim_month_num book_month_num,
           td1.dim_period_name book_period,
           td1.dim_quarter book_qtr,
           td1.dim_year book_year,
           td2.dim_week rev_week,
           td2.dim_month_num rev_month_num,
           td2.dim_period_name rev_period,
           td2.dim_quarter rev_qtr,
           td2.dim_year rev_year
    FROM                  gk_all_orders_mv o
                       JOIN
                          slxdw.history h
                       ON o.acct_id = h.accountid AND h.startdate < o.book_date
                    JOIN
                       slxdw.userinfo u1
                    ON h.createuser = u1.userid
                 JOIN
                    slxdw.userinfo u2
                 ON h.completeduser = u2.userid
              JOIN
                 time_dim td1
              ON o.book_date = td1.dim_date
           JOIN
              time_dim td2
           ON o.rev_date = td2.dim_date
   WHERE   h.description = 'ARRA Lead'
GROUP BY   o.acct_name,
           o.acct_id,
           o.cust_name,
           o.cust_id,
           o.cust_country,
           o.cust_city,
           o.cust_state,
           o.ch_num,
           o.course_ch,
           o.md_num,
           o.course_mod,
           o.pl_num,
           o.course_pl,
           o.course_code,
           o.course_name,
           o.event_id,
           o.enroll_id,
           o.book_date,
           o.rev_date,
           o.source,
           o.keycode,
           o.payment_method,
           o.ppcard_id,
           o.book_amt,
           h.accountname,
           h.createuser,
           u1.username,
           h.completeduser,
           u2.username,
           td1.dim_week,
           td1.dim_month_num,
           td1.dim_period_name,
           td1.dim_quarter,
           td1.dim_year,
           td2.dim_week,
           td2.dim_month_num,
           td2.dim_period_name,
           td2.dim_quarter,
           td2.dim_year;

COMMENT ON MATERIALIZED VIEW GKDW.GK_ARRA_ACT_ORDERS_MV IS 'snapshot table for snapshot GKDW.GK_ARRA_ACT_ORDERS_MV';

GRANT SELECT ON GKDW.GK_ARRA_ACT_ORDERS_MV TO DWHREAD;

