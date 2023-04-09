DROP MATERIALIZED VIEW GKDW.GK_COURSE_TO_WATCH_MV;
CREATE MATERIALIZED VIEW GKDW.GK_COURSE_TO_WATCH_MV 
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
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:25:26 (QP5 v5.115.810.9015) */
  SELECT   ed.ops_country,
           w.start_week,
           w.start_date,
           ed.end_date,
           w.event_id,
           w.metro,
           w.facility_code,
           w.course_code,
           w.short_name,
           w.course_ch,
           w.course_mod,
           w.course_pl,
           w.enroll_cnt,
           w.revenue,
           w.total_cost,
           w.revenue - w.total_cost margin,
           w.margin margin_pct,
           COUNT (cq.opportunityid) opp_cnt,
           f.enroll_id,
           f.book_amt,
           f.book_date,
           cd.cust_name,
           cd.email,
           cd.acct_name,
           f.sales_rep,
           f.territory,
           f.region,
           f.region_rep,
           CASE
              WHEN NVL (ep.appliedamount, 0) >= f.book_amt
              THEN
                 'Paid'
              WHEN NVL (ep.appliedamount, 0) > 0
                   AND NVL (ep.appliedamount, 0) < f.book_amt
              THEN
                 'Partial'
              ELSE
                 'Unpaid'
           END
              pay_status,
           CASE WHEN keycode = 'GONOGO' THEN 'Y' ELSE NULL END gonogo_flag
    FROM                        gk_low_margin_event_v w
                             INNER JOIN
                                event_dim ed
                             ON w.event_id = ed.event_id
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                       INNER JOIN
                          time_dim td1
                       ON td1.dim_date = TRUNC (SYSDATE)
                    LEFT OUTER JOIN
                       order_fact f
                    ON w.event_id = f.event_id
                       AND f.enroll_status != 'Cancelled'
                 LEFT OUTER JOIN
                    cust_dim cd
                 ON f.cust_id = cd.cust_id
              LEFT OUTER JOIN
                 gk_course_quotes_mv cq
              ON ed.course_id = cq.evxcourseid
                 AND ed.ops_country = cq.deliverycountry
           LEFT OUTER JOIN
              slxdw.evxpmtapplied ep
           ON f.enroll_id = ep.evxevenrollid
   WHERE   td.dim_year >= td1.dim_year
GROUP BY   ed.ops_country,
           w.start_week,
           w.start_date,
           ed.end_date,
           w.event_id,
           w.metro,
           w.facility_code,
           w.course_code,
           w.short_name,
           w.course_ch,
           w.course_mod,
           w.course_pl,
           w.enroll_cnt,
           w.revenue,
           w.total_cost,
           w.revenue - w.total_cost,
           w.margin,
           f.enroll_id,
           f.book_amt,
           f.book_date,
           cd.cust_name,
           cd.email,
           cd.acct_name,
           f.sales_rep,
           f.territory,
           f.region,
           f.region_rep,
           NVL (ep.appliedamount, 0),
           CASE WHEN keycode = 'GONOGO' THEN 'Y' ELSE NULL END;

COMMENT ON MATERIALIZED VIEW GKDW.GK_COURSE_TO_WATCH_MV IS 'snapshot table for snapshot GKDW.GK_COURSE_TO_WATCH_MV';

GRANT SELECT ON GKDW.GK_COURSE_TO_WATCH_MV TO DWHREAD;

