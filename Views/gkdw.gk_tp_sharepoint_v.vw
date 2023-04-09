DROP VIEW GKDW.GK_TP_SHAREPOINT_V;

/* Formatted on 29/01/2021 11:24:39 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_TP_SHAREPOINT_V
(
   TAB_TYPE,
   SALES_REP,
   SALES_REP_EMAIL,
   MANAGER_NAME,
   MANAGER_EMAIL,
   DIM_YEAR,
   DIM_MONTH_NUM,
   BOOK_MO,
   BOOK_DATE,
   BOOK_AMT,
   CUSTOMER_PARENT,
   SALES_TEAM,
   EVXEVENROLLID,
   EVENTID,
   COURSECODE,
   EVENTNAME,
   STARTDATE,
   PREPAY_CARD,
   PACK_ISSUED,
   STUDENT_POSTALCODE,
   PROVINCE,
   PACK_TYPE,
   EVENTCOUNTRY
)
AS
   SELECT   tp.*
     FROM      gk_tps_data_mv tp
            INNER JOIN
               time_dim td
            ON td.dim_date = TRUNC (SYSDATE)
    WHERE   tp.dim_year = td.dim_year AND tp.dim_month_num = td.dim_month_num
            AND EXTRACT (YEAR FROM tp.book_date) =
                  EXTRACT (YEAR FROM SYSDATE)
            AND EXTRACT (MONTH FROM tp.book_date) =
                  EXTRACT (MONTH FROM SYSDATE);


