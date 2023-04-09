DROP MATERIALIZED VIEW GKDW.GK_LEAD_CONVERSION_MV;
CREATE MATERIALIZED VIEW GKDW.GK_LEAD_CONVERSION_MV 
TABLESPACE GDWLRG
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
/* Formatted on 29/01/2021 12:24:23 (QP5 v5.115.810.9015) */
SELECT   isdb.id,
         cd.first_name,
         cd.last_name,
         isdb.advertising,
         isdb.import_date,
         isdb.source,
         isdb.slxid,
         cd.title,
         cd.acct_name,
         cd.address1,
         cd.address2,
         cd.address3,
         cd.city,
         DECODE (cd.country, 'CANADA', cd.province, cd.state) state,
         cd.zipcode,
         cd.country,
         cd.email,
         cd.workphone,
         o.enroll_id,
         o.book_amt,
         o.event_id,
         o.book_date,
         o.order_type,
         o.enroll_status,
         o.course_code,
         o.course_name,
         o.facility_region_metro,
         FIRST_VALUE (isdb.advertising)
            OVER (PARTITION BY isdb.slxid ORDER BY isdb.import_date)
            first_imp_advertising,
         FIRST_VALUE (isdb.source)
            OVER (PARTITION BY isdb.slxid ORDER BY isdb.import_date)
            first_imp_source
  FROM         gk_new_isdb_contacts_mv isdb
            LEFT JOIN
               gk_all_orders_mv o
            ON isdb.slxid = o.cust_id
               AND o.order_type IN ('Enrollment', 'SPEL')
         LEFT JOIN
            cust_dim cd
         ON isdb.slxid = cd.cust_id;

COMMENT ON MATERIALIZED VIEW GKDW.GK_LEAD_CONVERSION_MV IS 'snapshot table for snapshot GKDW.GK_LEAD_CONVERSION_MV';

GRANT SELECT ON GKDW.GK_LEAD_CONVERSION_MV TO DWHREAD;

