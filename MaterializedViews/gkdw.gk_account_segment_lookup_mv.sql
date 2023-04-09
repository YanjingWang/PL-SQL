DROP MATERIALIZED VIEW GKDW.GK_ACCOUNT_SEGMENT_LOOKUP_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ACCOUNT_SEGMENT_LOOKUP_MV 
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
/* Formatted on 29/01/2021 12:19:18 (QP5 v5.115.810.9015) */
SELECT   ac.accountid,
         TRIM (sl.account) acct_name,
         TO_CHAR(CASE
                    WHEN TRIM (sl.customer_name) = 'NULL' THEN NULL
                    ELSE TRIM (sl.customer_name)
                 END)
            acct_group,
         TO_CHAR(CASE
                    WHEN TRIM (sl.segment) = 'NULL' THEN NULL
                    ELSE TRIM (sl.segment)
                 END)
            sales_segment,
         TO_CHAR(CASE
                    WHEN TRIM (sl.field_terr) = 'NULL' THEN NULL
                    ELSE TRIM (sl.field_terr)
                 END)
            field_terr,
         TO_CHAR(CASE
                    WHEN TRIM (sl.field_rep) = 'NULL' THEN NULL
                    ELSE TRIM (sl.field_rep)
                 END)
            sales_rep,
         TO_CHAR(CASE
                    WHEN TRIM (sl.field_rep_id) = 'NULL' THEN NULL
                    ELSE TRIM (sl.field_rep_id)
                 END)
            sales_userid,
         TO_CHAR(CASE
                    WHEN TRIM (sl.ob_terr) = 'NULL' THEN NULL
                    ELSE TRIM (sl.ob_terr)
                 END)
            ob_terr,
         TO_CHAR(CASE
                    WHEN TRIM (sl.ob_rep) = 'NULL' THEN NULL
                    ELSE TRIM (sl.ob_rep)
                 END)
            ob_rep,
         TO_CHAR(CASE
                    WHEN TRIM (sl.ob_rep_id) = 'NULL' THEN NULL
                    ELSE TRIM (sl.ob_rep_id)
                 END)
            ob_rep_id
  FROM   gk_account_segments@slx sl, account@slx ac
 WHERE   UPPER (TRIM (sl.account)) = UPPER (TRIM (ac.account));

COMMENT ON MATERIALIZED VIEW GKDW.GK_ACCOUNT_SEGMENT_LOOKUP_MV IS 'snapshot table for snapshot GKDW.GK_ACCOUNT_SEGMENT_LOOKUP_MV';

GRANT SELECT ON GKDW.GK_ACCOUNT_SEGMENT_LOOKUP_MV TO DWHREAD;

