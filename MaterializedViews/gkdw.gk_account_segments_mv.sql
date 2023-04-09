DROP MATERIALIZED VIEW GKDW.GK_ACCOUNT_SEGMENTS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ACCOUNT_SEGMENTS_MV 
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
/* Formatted on 29/01/2021 12:19:39 (QP5 v5.115.810.9015) */
SELECT   DISTINCT
         ac.accountid,
         UPPER (TRIM (sl.account)) acct_name,
         TO_CHAR(CASE
                    WHEN TRIM (sl.customer_name) = 'NULL' THEN NULL
                    ELSE TRIM (sl.customer_name)
                 END)
            customer_name,
         TO_CHAR(CASE
                    WHEN TRIM (sl.segment) = 'NULL' THEN NULL
                    ELSE TRIM (sl.segment)
                 END)
            segment,
         TO_CHAR(CASE
                    WHEN TRIM (sl.field_terr) = 'NULL' THEN NULL
                    ELSE TRIM (sl.field_terr)
                 END)
            field_terr,
         TO_CHAR(CASE
                    WHEN TRIM (sl.field_rep) = 'NULL' THEN NULL
                    ELSE TRIM (sl.field_rep)
                 END)
            field_rep,
         TO_CHAR(CASE
                    WHEN TRIM (sl.field_rep_id) = 'NULL' THEN NULL
                    ELSE TRIM (sl.field_rep_id)
                 END)
            field_rep_id,
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
            ob_rep_id,
         rep_3_id,
         rep_3,
         sl.state,
         sl.country
  FROM   gk_account_segments@slx sl, account@slx ac, address@slx ad      -- SR
 WHERE   UPPER (TRIM (sl.account)) = UPPER (TRIM (ac.account))
         AND ac.addressid = ad.addressid                                 -- SR
         AND UPPER (TRIM (sl.country)) =
               CASE
                  WHEN UPPER (ad.country) = 'CANADA' THEN UPPER (ad.country)
                  ELSE 'USA'
               END                                                        --JJ;

COMMENT ON MATERIALIZED VIEW GKDW.GK_ACCOUNT_SEGMENTS_MV IS 'snapshot table for snapshot GKDW.GK_ACCOUNT_SEGMENTS_MV';

GRANT SELECT ON GKDW.GK_ACCOUNT_SEGMENTS_MV TO DWHREAD;

