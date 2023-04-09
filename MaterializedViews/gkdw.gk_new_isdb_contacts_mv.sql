DROP MATERIALIZED VIEW GKDW.GK_NEW_ISDB_CONTACTS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_NEW_ISDB_CONTACTS_MV 
TABLESPACE GDWLRG
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          504K
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
/* Formatted on 29/01/2021 12:24:13 (QP5 v5.115.810.9015) */
SELECT   "id" ID,
         "date" import_date,
         TO_CHAR ("source") SOURCE,
         TO_CHAR ("FirstName") first_name,
         TO_CHAR ("LastName") last_name,
         TO_CHAR ("title") title,
         TO_CHAR ("company") company,
         TO_CHAR ("city") city,
         TO_CHAR ("state") state,
         TO_CHAR ("zip") zip,
         TO_CHAR ("keycode") keycode,
         TO_CHAR ("customer_number") customer_number,
         TO_CHAR ("timeframe") time_frame,
         TO_CHAR ("method") method,
         TO_CHAR ("findout") findout,
         TO_CHAR ("keyword") keyword,
         TO_CHAR ("Advertising") advertising,
         TO_CHAR ("intadvertising") int_advertising,
         TO_CHAR ("importstatus") import_status,
         "SLXID"
  FROM   main@mkt_catalog mc
 WHERE   "SLXID" IS NOT NULL AND "importstatus" = 'Imported';

COMMENT ON MATERIALIZED VIEW GKDW.GK_NEW_ISDB_CONTACTS_MV IS 'snapshot table for snapshot GKDW.GK_NEW_ISDB_CONTACTS_MV';

CREATE INDEX GKDW.GK_NEW_ISDB_CONTACTS_MV_IDX ON GKDW.GK_NEW_ISDB_CONTACTS_MV
(SLXID, IMPORT_DATE)
LOGGING
TABLESPACE GDWIDX
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

GRANT SELECT ON GKDW.GK_NEW_ISDB_CONTACTS_MV TO DWHREAD;

