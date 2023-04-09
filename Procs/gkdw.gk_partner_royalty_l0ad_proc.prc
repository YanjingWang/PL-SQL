DROP PROCEDURE GKDW.GK_PARTNER_ROYALTY_L0AD_PROC;

CREATE OR REPLACE PROCEDURE GKDW.GK_PARTNER_ROYALTY_L0AD_PROC (
   P_VENDOR_CODE           VARCHAR2,
   P_PRIMARY_CONTACT       VARCHAR2,
   P_ALTERNATE_CONTACT     VARCHAR2,
   P_ORACLE_VENDOR_ID      NUMBER,
   P_ORACLE_VENDOR_SITE    VARCHAR2,
   P_PO_ACTIVE             VARCHAR2,
   P_EVENT_AUDIT           VARCHAR2,
   P_ROSTER_AUDIT          VARCHAR2,
   P_AUDIT_MGR             VARCHAR2,
   P_PO_MGR_ID             NUMBER,
   P_LONG_RPT              VARCHAR2,
   P_PO_CREATE_METH        VARCHAR2,
   P_EMAIL_ORDER_FLAG      VARCHAR2,
   P_ORDER_FILE_LOC        VARCHAR2,
   P_SHIP_ORDER_FLAG       VARCHAR2,
   P_RPT_DAYS              VARCHAR2,
   P_EMAIL_SHIP_FLAG       VARCHAR2,
   P_SHIP_FILE_LOC         VARCHAR2,
   P_PRIVATE_FILE_LOC      CHAR)
--=======================================================================
-- Author Nam:Sruthi Reddy
-- Create date:07/27/2016
-- Description:This will be used to add or modify GK_PARTNER_ROLTY table

--=======================================================================
-- Change History
--=======================================================================
-- Version   Date        Author             Description    
--  1.0      07/27/2016  Sruthi Reddy       Initial Version
--========================================================================
AS
BEGIN
   MERGE INTO GK_PARTNER_ROYALTY PR
        USING GK_PARTNER_ROYALTY_STG@SLX PS
           ON (PR.VENDOR_CODE = PS.VENDOR_CODE)
   WHEN MATCHED
   THEN
      UPDATE SET PRIMARY_CONTACT = P_PRIMARY_CONTACT,
                 ALTERNATE_CONTACT = P_ALTERNATE_CONTACT,
                 ORACLE_VENDOR_ID = P_ORACLE_VENDOR_ID,
                 ORACLE_VENDOR_SITE = P_ORACLE_VENDOR_SITE,
                 PO_ACTIVE = P_PO_ACTIVE,
                 EVENT_AUDIT = P_EVENT_AUDIT,
                 ROSTER_AUDIT = P_ROSTER_AUDIT,
                 AUDIT_MGR = P_AUDIT_MGR,
                 PO_MGR_ID = P_PO_MGR_ID,
                 LONG_RPT = P_LONG_RPT,
                 PO_CREATE_METH = P_PO_CREATE_METH,
                 EMAIL_ORDER_FLAG = P_EMAIL_ORDER_FLAG,
                 ORDER_FILE_LOC = P_ORDER_FILE_LOC,
                 SHIP_ORDER_FLAG = P_SHIP_ORDER_FLAG,
                 RPT_DAYS = P_RPT_DAYS,
                 EMAIL_SHIP_FLAG = P_EMAIL_SHIP_FLAG,
                 SHIP_FILE_LOC = P_SHIP_FILE_LOC,
                 PRIVATE_FILE_LOC = P_PRIVATE_FILE_LOC
   WHEN NOT MATCHED
   THEN
      INSERT     (VENDOR_CODE,
                  PRIMARY_CONTACT,
                  ALTERNATE_CONTACT,
                  ORACLE_VENDOR_ID,
                  ORACLE_VENDOR_SITE,
                  PO_ACTIVE,
                  EVENT_AUDIT,
                  ROSTER_AUDIT,
                  AUDIT_MGR,
                  PO_MGR_ID,
                  LONG_RPT,
                  PO_CREATE_METH,
                  EMAIL_ORDER_FLAG,
                  ORDER_FILE_LOC,
                  SHIP_ORDER_FLAG,
                  RPT_DAYS,
                  EMAIL_SHIP_FLAG,
                  SHIP_FILE_LOC,
                  PRIVATE_FILE_LOC)
          VALUES (P_VENDOR_CODE,
                  P_PRIMARY_CONTACT,
                  P_ALTERNATE_CONTACT,
                  P_ORACLE_VENDOR_ID,
                  P_ORACLE_VENDOR_SITE,
                  P_PO_ACTIVE,
                  P_EVENT_AUDIT,
                  P_ROSTER_AUDIT,
                  P_AUDIT_MGR,
                  P_PO_MGR_ID,
                  P_LONG_RPT,
                  P_PO_CREATE_METH,
                  P_EMAIL_ORDER_FLAG,
                  P_ORDER_FILE_LOC,
                  P_SHIP_ORDER_FLAG,
                  P_RPT_DAYS,
                  P_EMAIL_SHIP_FLAG,
                  P_SHIP_FILE_LOC,
                  P_PRIVATE_FILE_LOC);
Exception 
when others then raise_application_error(-20001,'Unable to update the vendor code: '||p_vendor_code);
END;
/


