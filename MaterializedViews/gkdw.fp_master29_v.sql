DROP MATERIALIZED VIEW GKDW.FP_MASTER29_V;
CREATE MATERIALIZED VIEW GKDW.FP_MASTER29_V 
TABLESPACE GDWMED
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
/* Formatted on 29/01/2021 12:19:23 (QP5 v5.115.810.9015) */
SELECT   "mrID" ID,
         --            "mrTITLE" mrTITLE,
         --            "mrPRIORITY" mrPRIORITY,
         "mrSTATUS" STATUS,
         --            "mrASSIGNEES" mrASSIGNEES,
         --            "mrATTACHMENTS" mrATTACHMENTS,
         --            "mrUPDATEDATE" mrUPDATEDATE,
         --            "mrSUBMITTER" mrSUBMITTER,
         --            "mrSUBMITDATE" mrSUBMITDATE,
         --            "mrUNASSIGNED" mrUNASSIGNED,
         --            "mrTIMESTAMP" mrTIMESTAMP,
         "Dispute__bType" DISPUTE_TYPE,
         "Action__bType" ACTION_TYPE,
         "Action__bReason" ACTION_REASON,
         "Supply__bGroup" SUPPLY_GROUP,
         "Transaction__b__3" Transaction_ID,
         --            "__4__bIncorrect",
         --            "Vendor__bID" Vendor__bID,
         --            "Vendor__bSite__bCode" Vendor__bSite__bCode,
         "Invoice__bID" INVOICE_ID,                                         --
         --            "Vendor__bName" Vendor__bName,
         "Transaction__bLine__b__3" TRANSACTION_LINE_NUM
  --            "Hold__bReason" Hold__bReason
  FROM   dbo.master29@fp;

COMMENT ON MATERIALIZED VIEW GKDW.FP_MASTER29_V IS 'snapshot table for snapshot GKDW.FP_MASTER29_V';

GRANT SELECT ON GKDW.FP_MASTER29_V TO DWHREAD;

