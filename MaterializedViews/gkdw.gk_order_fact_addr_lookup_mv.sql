DROP MATERIALIZED VIEW GKDW.GK_ORDER_FACT_ADDR_LOOKUP_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ORDER_FACT_ADDR_LOOKUP_MV 
TABLESPACE GDWMED
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
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:23:39 (QP5 v5.115.810.9015) */
SELECT   DISTINCT enroll_id,
                  acct_name,
                  acct_address1,
                  acct_address2,
                  acct_city,
                  acct_state,
                  acct_zipcode,
                  acct_country,
                  acct_county,
                  cust_first_name,
                  cust_last_name,
                  cust_email,
                  cust_address1,
                  cust_address2,
                  cust_city,
                  cust_state,
                  cust_zipcode,
                  cust_country,
                  cust_county
  FROM   order_fact
 WHERE   cust_first_name IS NOT NULL AND rev_date >= '01-JAN-2013';

COMMENT ON MATERIALIZED VIEW GKDW.GK_ORDER_FACT_ADDR_LOOKUP_MV IS 'snapshot table for snapshot GKDW.GK_ORDER_FACT_ADDR_LOOKUP_MV';

CREATE INDEX GKDW.GFA_IDX1 ON GKDW.GK_ORDER_FACT_ADDR_LOOKUP_MV
(ENROLL_ID)
LOGGING
TABLESPACE GDWSML
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
NOPARALLEL;

GRANT SELECT ON GKDW.GK_ORDER_FACT_ADDR_LOOKUP_MV TO DWHREAD;

