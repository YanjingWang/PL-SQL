DROP VIEW GKDW.GK_NEW_ISDB_CONTACTS_V;

/* Formatted on 29/01/2021 11:32:25 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_NEW_ISDB_CONTACTS_V
(
   ID,
   IMPORT_DATE,
   SOURCE,
   FIRST_NAME,
   LAST_NAME,
   TITLE,
   COMPANY,
   CITY,
   STATE,
   ZIP,
   KEYCODE,
   CUSTOMER_NUMBER,
   TIME_FRAME,
   METHOD,
   FINDOUT,
   KEYWORD,
   ADVERTISING,
   INT_ADVERTISING,
   IMPORT_STATUS,
   SLXID
)
AS
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
    WHERE   "SLXID" IS NOT NULL AND TO_CHAR ("importstatus") LIKE 'Imported%';


