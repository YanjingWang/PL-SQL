DROP MATERIALIZED VIEW GKDW.MASTER_PREPAY_MV;
CREATE MATERIALIZED VIEW GKDW.MASTER_PREPAY_MV 
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
NOLOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:20:09 (QP5 v5.115.810.9015) */
SELECT   'Prepay Order' TYPE,
         PD.PPCARD_ID,
         --PD.CREATION_DATE,
         PD.CREATION_DATE,
         PD.LAST_UPDATE_DATE,
         CARD_NUMBER,
         CARD_SHORT_CODE,
         CARD_STATUS,
         VALUE_PURCHASED_BASE BOOK_AMT,
         CARD_STATUS_CODE,
         CARD_TITLE,
         CARD_TYPE,
         CARD_TYPE_CODE,
         COMMENTS,
         PD.CURR_CODE,
         EVENT_PASS_AVAILABLE,
         EVENT_PASS_EXPIRED,
         EVENT_PASS_REDEEMED,
         EVENT_PASS_TOTAL,
         PD.SALES_ORDER_ID,
         PD.TPPCARD_ID,
         EXPIRES_DATE,
         EXPIRE_CARD,
         ISSUED_DATE,
         ISSUED_TO_ACCT_ID,
         ISSUED_TO_CUST_ID,
         REDEEM_BY_ACCT_ID,
         REDEEM_BY_CUST_ID,
         USED_FIRST_DATE,
         USED_LAST_DATE,
         VALUE_BALANCE_BASE,
         VALUE_BALANCE_BONUS,
         VALUE_BALANCE_TOTAL,
         VALUE_PURCHASED_BASE,
         VALUE_PURCHASED_BONUS,
         VALUE_PURCHASED_TOTAL,
         VALUE_REDEEMED_BASE,
         VALUE_REDEEMED_BONUS,
         VALUE_REDEEMED_TOTAL,
         VALUE_STMT_BASE,
         VALUE_STMT_BONUS,
         VALUE_STMT_TOTAL,
         ACCTG_TRANS_ERROR,
         VALUE_REDEEM_CONVERTRATE,
         VALUE_RECAPTURED_BASE,
         VALUE_RECAPTURED_BONUS,
         VALUE_RECAPTURED_TOTAL,
         PD.GKDW_CREATED_BY,
         PD.GKDW_CREATE_DATE,
         PD.GKDW_UPDATED_BY,
         PD.GKDW_UPDATE_DATE,
         PD.GKDW_SOURCE,
         PPCARD_GK,
         CREATE_USER,
         MODIFY_USER,
         OSRPREPAY,
         BT_PREPAY,
         LEAD,
         OUTBOUND,
         ENTERPRISE,
         TEAMING,
         NEW_ACCOUNT,
         OSR_USERID,
         OBPREPAY,
         ICAMUSERID,
         CAMPREPAY,
         CAMUSERID,
         OBUSERID,
         ICAMPREPAY,
         FSDPREPAY,
         IAMUSERID,
         TAMPREPAY,
         TAMUSERID,
         NAMPREPAY,
         NAMUSERID,
         FSDUSERID,
         IAMPREPAY,
         OSR_REP_NAME,
         CAM_REP_NAME,
         OB_REP_NAME,
         ICAM_REP_NAME,
         IAM_REP_NAME,
         TAM_REP_NAME,
         NAM_REP_NAME,
         FSD_REP_NAME,
         SOF.CANCEL_DATE,
         COALESCE (PD.OSR_USERID,
                   PD.CAMUSERID,
                   PD.OBUSERID,
                   PD.ICAMUSERID,
                   PD.IAMUSERID,
                   PD.TAMUSERID,
                   PD.NAMUSERID,
                   PD.FSDUSERID,
                   PD.CREATE_USER)
            SALES_REP_ID,
         U.USERNAME CREATED_USER,
         SOF.CREATION_DATE BOOK_DATE,
         FISCAL_WEEK,
         FISCAL_MONTH_NUM,
         FISCAL_MONTH,
         FISCAL_PERIOD_NAME,
         FISCAL_QUARTER,
         FISCAL_YEAR,
         CD.CUST_NAME,
         AD.ACCT_NAME,
         GAS.SEGMENT,
         GAS.FIELD_TERR,
         GAS.FIELD_REP FIELD_SALES_REP,
         GAS.OB_TERR,
         GAS.OB_REP,
         U.DIVISION CREATE_USER_DIVISION,
         U.REGION CREATE_USER_REGION,
         GAS.FIELD_REP,
         CASE
            WHEN UPPER (U.REGION) = 'CHANNEL' THEN U.DIVISION
            ELSE GAS.OB_TERR
         END
            JULIES_OB_TERR_RULE,
         CASE
            WHEN UPPER (U.REGION) = 'CHANNEL' THEN U.USERNAME
            ELSE GAS.OB_REP
         END
            JULIES_OB_REP_RULE,
         CASE
            WHEN UPPER (U.REGION) = 'CHANNEL' THEN U.DIVISION
            ELSE FIELD_TERR
         END
            JULIES_FIELD_TERR_RULE,
         CASE
            WHEN UPPER (U.REGION) = 'CHANNEL' THEN U.USERNAME
            ELSE GAS.FIELD_REP
         END
            JULIES_FIELD_REP_RULE,
         CASE
            WHEN UPPER (U.REGION) = 'CHANNEL' THEN U.REGION
            ELSE GAS.SEGMENT
         END
            JULIES_FIELD_SEGMENT_RULE
  FROM                     PPCARD_DIM PD
                        LEFT OUTER JOIN
                           Sales_Order_Fact SOF
                        ON PD.SALES_ORDER_ID = SOF.SALES_ORDER_ID
                     LEFT OUTER JOIN
                        TIME_DIM TD
                     ON TD.DIM_DATE = TRUNC (PD.CREATION_DATE)
                  LEFT OUTER JOIN
                     CUST_DIM CD
                  ON CD.CUST_ID = PD.ISSUED_TO_CUST_ID
               LEFT OUTER JOIN
                  ACCOUNT_DIM AD
               ON AD.ACCT_ID = PD.ISSUED_TO_ACCT_ID
            LEFT OUTER JOIN
               GK_ACCOUNT_SEGMENTS_MV GAS
            ON GAS.ACCOUNTID = PD.ISSUED_TO_ACCT_ID
         LEFT OUTER JOIN
            USERINFO U
         ON (COALESCE (PD.OSR_USERID,
                       PD.CAMUSERID,
                       PD.OBUSERID,
                       PD.ICAMUSERID,
                       PD.IAMUSERID,
                       PD.TAMUSERID,
                       PD.NAMUSERID,
                       PD.FSDUSERID,
                       PD.CREATE_USER) = U.USERID
             OR GAS.FIELD_REP_ID = U.USERID)
 WHERE   PD.CREATION_DATE >= TO_DATE ('06/01/2014', 'MM/DD/YYYY')
UNION
SELECT   'Prepay Order' TYPE,
         PD.PPCARD_ID,
         --PD.CREATION_DATE,
         PD.CREATION_DATE,
         PD.LAST_UPDATE_DATE,
         CARD_NUMBER,
         CARD_SHORT_CODE,
         CARD_STATUS,
         VALUE_PURCHASED_BASE * -1 BOOK_AMT,
         CARD_STATUS_CODE,
         CARD_TITLE,
         CARD_TYPE,
         CARD_TYPE_CODE,
         COMMENTS,
         PD.CURR_CODE,
         EVENT_PASS_AVAILABLE * -1 EVENT_PASS_AVAILABLE,
         EVENT_PASS_EXPIRED * -1 EVENT_PASS_EXPIRED,
         EVENT_PASS_REDEEMED * -1 EVENT_PASS_REDEEMED,
         EVENT_PASS_TOTAL * -1 EVENT_PASS_TOTAL,
         PD.SALES_ORDER_ID,
         PD.TPPCARD_ID,
         EXPIRES_DATE,
         EXPIRE_CARD,
         ISSUED_DATE,
         ISSUED_TO_ACCT_ID,
         ISSUED_TO_CUST_ID,
         REDEEM_BY_ACCT_ID,
         REDEEM_BY_CUST_ID,
         USED_FIRST_DATE,
         USED_LAST_DATE,
         VALUE_BALANCE_BASE * -1 VALUE_BALANCE_BASE,
         VALUE_BALANCE_BONUS * -1 VALUE_BALANCE_BONUS,
         VALUE_BALANCE_TOTAL * -1 VALUE_BALANCE_TOTAL,
         VALUE_PURCHASED_BASE * -1 VALUE_PURCHASED_BASE,
         VALUE_PURCHASED_BONUS * -1 VALUE_PURCHASED_BONUS,
         VALUE_PURCHASED_TOTAL * -1 VALUE_PURCHASED_TOTAL,
         VALUE_REDEEMED_BASE * -1 VALUE_REDEEMED_BASE,
         VALUE_REDEEMED_BONUS * -1 VALUE_REDEEMED_BONUS,
         VALUE_REDEEMED_TOTAL * -1 VALUE_REDEEMED_TOTAL,
         VALUE_STMT_BASE * -1 VALUE_STMT_BASE,
         VALUE_STMT_BONUS * -1 VALUE_STMT_BONUS,
         VALUE_STMT_TOTAL * -1 VALUE_STMT_TOTAL,
         ACCTG_TRANS_ERROR,
         VALUE_REDEEM_CONVERTRATE * -1 VALUE_REDEEM_CONVERTRATE,
         VALUE_RECAPTURED_BASE * -1 VALUE_RECAPTURED_BASE,
         VALUE_RECAPTURED_BONUS * -1 VALUE_RECAPTURED_BONUS,
         VALUE_RECAPTURED_TOTAL * -1 VALUE_RECAPTURED_TOTAL,
         PD.GKDW_CREATED_BY,
         PD.GKDW_CREATE_DATE,
         PD.GKDW_UPDATED_BY,
         PD.GKDW_UPDATE_DATE,
         PD.GKDW_SOURCE,
         PPCARD_GK,
         CREATE_USER,
         MODIFY_USER,
         OSRPREPAY,
         BT_PREPAY,
         LEAD,
         OUTBOUND,
         ENTERPRISE,
         TEAMING,
         NEW_ACCOUNT,
         OSR_USERID,
         OBPREPAY,
         ICAMUSERID,
         CAMPREPAY,
         CAMUSERID,
         OBUSERID,
         ICAMPREPAY,
         FSDPREPAY,
         IAMUSERID,
         TAMPREPAY,
         TAMUSERID,
         NAMPREPAY,
         NAMUSERID,
         FSDUSERID,
         IAMPREPAY,
         OSR_REP_NAME,
         CAM_REP_NAME,
         OB_REP_NAME,
         ICAM_REP_NAME,
         IAM_REP_NAME,
         TAM_REP_NAME,
         NAM_REP_NAME,
         FSD_REP_NAME,
         SOF.CANCEL_DATE,
         COALESCE (PD.OSR_USERID,
                   PD.CAMUSERID,
                   PD.OBUSERID,
                   PD.ICAMUSERID,
                   PD.IAMUSERID,
                   PD.TAMUSERID,
                   PD.NAMUSERID,
                   PD.FSDUSERID,
                   PD.CREATE_USER)
            SALES_REP_ID,
         U.USERNAME CREATED_USER,
         CASE
            WHEN SOF.RECORD_TYPE IS NULL AND SOF.CANCEL_DATE IS NOT NULL
            THEN
               SOF.CANCEL_DATE
            WHEN SOF.RECORD_TYPE IS NULL AND SOF.CANCEL_DATE IS NULL
            THEN
               PD.EXPIRES_DATE
            WHEN     SOF.RECORD_TYPE IS NULL
                 AND SOF.CANCEL_DATE IS NULL
                 AND PD.EXPIRES_DATE IS NULL
            THEN
               PD.USED_LAST_DATE
            ELSE
               SOF.CREATION_DATE
         END
            BOOK_DATE,
         FISCAL_WEEK,
         FISCAL_MONTH_NUM,
         FISCAL_MONTH,
         FISCAL_PERIOD_NAME,
         FISCAL_QUARTER,
         FISCAL_YEAR,
         CD.CUST_NAME,
         AD.ACCT_NAME,
         GAS.SEGMENT,
         GAS.FIELD_TERR,
         GAS.FIELD_REP FIELD_SALES_REP,
         GAS.OB_TERR,
         GAS.OB_REP,
         U.DIVISION CREATE_USER_DIVISION,
         U.REGION CREATE_USER_REGION,
         GAS.FIELD_REP,
         CASE
            WHEN UPPER (U.REGION) = 'CHANNEL' THEN U.DIVISION
            ELSE GAS.OB_TERR
         END
            JULIES_OB_TERR_RULE,
         CASE
            WHEN UPPER (U.REGION) = 'CHANNEL' THEN U.USERNAME
            ELSE GAS.OB_REP
         END
            JULIES_OB_REP_RULE,
         CASE
            WHEN UPPER (U.REGION) = 'CHANNEL' THEN U.DIVISION
            ELSE FIELD_TERR
         END
            JULIES_FIELD_TERR_RULE,
         CASE
            WHEN UPPER (U.REGION) = 'CHANNEL' THEN U.USERNAME
            ELSE GAS.FIELD_REP
         END
            JULIES_FIELD_REP_RULE,
         CASE
            WHEN UPPER (U.REGION) = 'CHANNEL' THEN U.REGION
            ELSE GAS.SEGMENT
         END
            JULIES_FIELD_SEGMENT_RULE
  FROM                     PPCARD_DIM PD
                        LEFT OUTER JOIN
                           Sales_Order_Fact SOF
                        ON PD.SALES_ORDER_ID = SOF.SALES_ORDER_ID
                     LEFT OUTER JOIN
                        TIME_DIM TD
                     ON TD.DIM_DATE = TRUNC (PD.CREATION_DATE)
                  LEFT OUTER JOIN
                     CUST_DIM CD
                  ON CD.CUST_ID = PD.ISSUED_TO_CUST_ID
               LEFT OUTER JOIN
                  ACCOUNT_DIM AD
               ON AD.ACCT_ID = PD.ISSUED_TO_ACCT_ID
            LEFT OUTER JOIN
               GK_ACCOUNT_SEGMENTS_MV GAS
            ON GAS.ACCOUNTID = PD.ISSUED_TO_ACCT_ID
         LEFT OUTER JOIN
            USERINFO U
         ON (COALESCE (PD.OSR_USERID,
                       PD.CAMUSERID,
                       PD.OBUSERID,
                       PD.ICAMUSERID,
                       PD.IAMUSERID,
                       PD.TAMUSERID,
                       PD.NAMUSERID,
                       PD.FSDUSERID,
                       PD.CREATE_USER) = U.USERID
             OR GAS.FIELD_REP_ID = U.USERID)
 WHERE   UPPER (PD.CARD_STATUS) = 'VOID'
         AND PD.CREATION_DATE >= TO_DATE ('06/01/2014', 'MM/DD/YYYY');

COMMENT ON MATERIALIZED VIEW GKDW.MASTER_PREPAY_MV IS 'snapshot table for snapshot GKDW.MASTER_PREPAY_MV';

GRANT SELECT ON GKDW.MASTER_PREPAY_MV TO DWHREAD;

