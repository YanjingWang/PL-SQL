DROP MATERIALIZED VIEW GKDW.GK_ADDRESS_XREF_HEADER_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ADDRESS_XREF_HEADER_MV 
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
/* Formatted on 29/01/2021 12:19:36 (QP5 v5.115.810.9015) */
SELECT   *
  FROM   (SELECT   GK_CUST_XREF_ID,
                   CUSTOMER_ID,
                   PARTY_ID,
                   CUST_ACCOUNT_ID,
                   CUST_ORIG_SYSTEM_REFERENCE,
                   ADDRESS_ID,
                   SITE_USE_ID,
                   SOURCE_NAME,
                   CREATED_BY,
                   CREATION_DATE,
                   LAST_UPDATED_BY,
                   LAST_UPDATE_DATE,
                   SOURCE_SITE_USE_CODE,
                   SOURCE_CUSTOMER_ID,
                   SOURCE_CUSTOMER_NAME,
                   SOURCE_ADDRESS1,
                   SOURCE_ADDRESS2,
                   SOURCE_ADDRESS3,
                   SOURCE_CITY,
                   SOURCE_COUNTY,
                   SOURCE_STATE,
                   SOURCE_ZIP,
                   SOURCE_COUNTRY,
                   ORG_ID,
                   START_DATE_ACTIVE,
                   END_DATE_ACTIVE,
                   ATTRIBUTE1,
                   ATTRIBUTE2,
                   ATTRIBUTE3,
                   ATTRIBUTE4,
                   ATTRIBUTE5
            FROM   GK_ADDRESS_XREF_HEADER_TBL@r12prd);

COMMENT ON MATERIALIZED VIEW GKDW.GK_ADDRESS_XREF_HEADER_MV IS 'snapshot table for snapshot GKDW.GK_ADDRESS_XREF_HEADER_MV';

GRANT SELECT ON GKDW.GK_ADDRESS_XREF_HEADER_MV TO DWHREAD;

