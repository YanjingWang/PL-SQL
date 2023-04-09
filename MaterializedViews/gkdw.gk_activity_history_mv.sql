DROP MATERIALIZED VIEW GKDW.GK_ACTIVITY_HISTORY_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ACTIVITY_HISTORY_MV 
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
START WITH TO_DATE('09-Jan-2009 01:30:00','dd-mon-yyyy hh24:mi:ss')
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:19:47 (QP5 v5.115.810.9015) */
  SELECT   ui.username,
           ui.email,
           ui.department,
           t.territory_id,
           t.region,
           t.region_mgr,
           td.dim_year,
           td.dim_year || '-Qtr ' || LPAD (td.dim_quarter, 2, '0') dim_quarter,
           td.dim_year || '-Prd ' || LPAD (td.dim_month_num, 2, '0')
              dim_month_num,
           td.dim_period_name dim_period,
           TRUNC (h.createdate) dim_date,
           t.activity_desc,
           COUNT (h.activityid) closed_act_cnt
    FROM               slxdw.history h
                    INNER JOIN
                       slxdw.userinfo ui
                    ON h.completeduser = ui.userid
                 INNER JOIN
                    slxdw.activity_types t
                 ON h.history_type = t.activity_code
              INNER JOIN
                 time_dim td
              ON TRUNC (h.createdate) = dim_date
           LEFT OUTER JOIN
              gk_territory t
           ON UPPER (ui.username) = UPPER (t.salesrep)
              AND t.territory_type = 'OB'
   WHERE   createdate >= TO_DATE ('1/1/2008', 'mm/dd/yyyy')
           AND ui.department = 'Outbound'
GROUP BY   ui.username,
           ui.email,
           ui.department,
           t.territory_id,
           t.region,
           t.region_mgr,
           td.dim_year,
           td.dim_year || '-Qtr ' || LPAD (td.dim_quarter, 2, '0'),
           td.dim_year || '-Prd ' || LPAD (td.dim_month_num, 2, '0'),
           td.dim_period_name,
           TRUNC (h.createdate),
           t.activity_desc;

COMMENT ON MATERIALIZED VIEW GKDW.GK_ACTIVITY_HISTORY_MV IS 'snapshot table for snapshot GKDW.GK_ACTIVITY_HISTORY_MV';

GRANT SELECT ON GKDW.GK_ACTIVITY_HISTORY_MV TO DWHREAD;

