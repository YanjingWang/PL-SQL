DROP MATERIALIZED VIEW GKDW.GK_ACTIVITY_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ACTIVITY_MV 
TABLESPACE GDWLRG
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
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
/* Formatted on 29/01/2021 12:19:34 (QP5 v5.115.810.9015) */
SELECT   ui.userid,
         ui.username,
         h.activityid,
         h.historyid,
         t.activity_code,
         t.activity_desc,
         CASE
            WHEN TRUNC (h.createdate) > TRUNC (completeddate) THEN 1
            ELSE TRUNC (completeddate) - TRUNC (h.createdate) + 1
         END
            totaldays,
         1 activity_cnt,
         h.accountid,
         h.accountname,
         h.contactid,
         h.contactname,
         h.priority,
         h.category,
         h.createdate create_date,
         startdate,
         h.completeddate closed_date,
         result,
         td1.dim_year create_year,
         td1.dim_quarter create_qtr,
         td1.dim_period_name create_period,
         td1.dim_month_num create_period_num,
         td1.dim_week create_week,
         td2.dim_year comp_year,
         td2.dim_quarter comp_qtr,
         td2.dim_period_name comp_period,
         td2.dim_month_num comp_period_num,
         td2.dim_week comp_week,
         z.msa_desc,
         NVL (z.consolidated_msa, z.msa_desc) reporting_msa
  FROM                     slxdw.history h
                        INNER JOIN
                           slxdw.userinfo ui
                        ON h.completeduser = ui.userid
                     INNER JOIN
                        time_dim td1
                     ON TRUNC (h.createdate) = td1.dim_date
                  INNER JOIN
                     time_dim td2
                  ON TRUNC (h.completeddate) = td2.dim_date
               INNER JOIN
                  cust_dim cd
               ON h.contactid = cd.cust_id
            INNER JOIN
               gk_msa_zips z
            ON SUBSTR (cd.zipcode, 1, 5) = z.zip_code
         LEFT OUTER JOIN
            slxdw.activity_types t
         ON h.history_type = t.activity_code
 WHERE   h.createdate >= TO_DATE ('1/1/2007', 'mm/dd/yyyy')
         AND h.activityid IS NOT NULL
UNION
SELECT   ui.userid,
         ui.username,
         a.activityid,
         NULL,
         t.activity_code,
         t.activity_desc,
         TRUNC (SYSDATE) - TRUNC (createdate) + 1 totaldays,
         1 activity_cnt,
         accountid,
         accountname,
         contactid,
         contactname,
         priority,
         category,
         createdate,
         startdate,
         NULL,
         'Open',
         td.dim_year,
         td.dim_quarter,
         dim_period_name,
         td.dim_month_num,
         td.dim_week,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         z.msa_desc,
         NVL (z.consolidated_msa, z.msa_desc) reporting_msa
  FROM                  slxdw.activity a
                     INNER JOIN
                        slxdw.userinfo ui
                     ON a.userid = ui.userid
                  INNER JOIN
                     time_dim td
                  ON TRUNC (a.createdate) = td.dim_date
               INNER JOIN
                  cust_dim cd
               ON a.contactid = cd.cust_id
            INNER JOIN
               gk_msa_zips z
            ON SUBSTR (cd.zipcode, 1, 5) = z.zip_code
         LEFT OUTER JOIN
            slxdw.activity_types t
         ON a.activitytype = t.activity_code
 WHERE   a.createdate >= TO_DATE ('1/1/2007', 'mm/dd/yyyy');

COMMENT ON MATERIALIZED VIEW GKDW.GK_ACTIVITY_MV IS 'snapshot table for snapshot GKDW.GK_ACTIVITY_MV';

GRANT SELECT ON GKDW.GK_ACTIVITY_MV TO DWHREAD;

