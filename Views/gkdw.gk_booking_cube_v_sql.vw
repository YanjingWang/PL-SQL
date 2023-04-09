DROP VIEW GKDW.GK_BOOKING_CUBE_V_SQL;

/* Formatted on 29/01/2021 11:42:25 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_BOOKING_CUBE_V_SQL
(
   BOOK_DATE,
   REV_DATE,
   BOOK_AMT,
   EVENTLENGTH,
   LIST_PRICE,
   REV_YEAR,
   BOOK_YEAR,
   AGE,
   ENT_COUNT,
   PUBLIC_ENROLL_COUNT,
   PUBLIC_CANCEL_COUNT,
   PUBLIC_GUEST_COUNT,
   OPS_COUNTRY,
   COURSE_CODE,
   STATE,
   CUST_STATE,
   SALES_REP,
   CH_NUM,
   MD_NUM,
   PL_NUM,
   COUNTRY,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   COURSE_NAME,
   ACCT_NAME,
   CUST_NAME,
   REV_MONTH_NUM,
   REV_WEEK,
   BOOK_MONTH_NUM,
   BOOK_WEEK,
   ENROLL_ID,
   EVENT_ID,
   CUST_ID,
   FEE_TYPE,
   ENROLL_STATUS,
   EVENT_TYPE,
   FACILITY_REGION_METRO,
   CUST_COUNTRY,
   CUST_ZIP,
   REV_MONTH,
   BOOK_MONTH,
   REV_QUARTER,
   BOOK_QUARTER
)
AS
   SELECT   TRUNC (book_date) book_date,
            TRUNC (rev_date) rev_date,
            book_amt,
            eventlength,
            list_price,
            rev_year,
            book_year,
            age,
            ent_count,
            public_enroll_count,
            public_cancel_count,
            public_guest_count,
            ops_country,
            course_code,
            bc.state,
            cust_state,
            sales_rep,
            ch_num,
            md_num,
            pl_num,
            bc.country,
            course_ch,
            course_mod,
            course_pl,
            course_name,
            bc.acct_name,
            bc.cust_name,
            rev_month_num,
            rev_week,
            book_month_num,
            book_week,
            enroll_id,
            event_id,
            bc.cust_id,
            fee_type,
            enroll_status,
            event_type,
            facility_region_metro,
            cust_country,
            SUBSTR (bc.cust_zip, 1, 5) cust_zip,
            rev_month,
            book_month,
            rev_quarter,
            book_quarter
     FROM   gk_booking_cube_mv bc
    WHERE       (bc.course_ch = '10' OR bc.event_type = 'Open Enrollment')
            AND bc.country = 'USA'
            AND bc.cust_country = 'USA'
            AND bc.rev_date >= '01-JAN-2006'
            AND bc.cust_zip NOT IN ('XXXX', 'APO', 'INTL', 'BANGK', '00000');


