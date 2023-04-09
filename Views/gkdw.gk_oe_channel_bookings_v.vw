DROP VIEW GKDW.GK_OE_CHANNEL_BOOKINGS_V;

/* Formatted on 29/01/2021 11:32:01 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_OE_CHANNEL_BOOKINGS_V
(
   ENROLL_ID,
   CUST_ID,
   BOOK_AMT,
   LIST_PRICE,
   SALES_REP,
   ACCOUNT_NAME,
   PARTNER_KEY_CODE,
   EVENT_ID,
   START_DATE,
   END_DATE,
   COURSE_CODE,
   DIM_YEAR,
   DIM_PERIOD_NAME,
   COURSE_CH,
   ONSITE_ATTENDED,
   ATTEND_ENROLLMENTS,
   NUM_STUDENTS,
   BASE_STUDENTS
)
AS
   SELECT   f.enroll_id,
            f.cust_id,
            f.book_amt,
            cd.list_price,
            channel_manager sales_rep,
            partner_name account_name,
            cp.partner_key_code,
            ed.event_id,
            ed.start_date,
            ed.end_date,
            cd.course_code,
            td.dim_year,
            td.dim_period_name,
            cd.course_ch,
            ed.onsite_attended,
            attend_enrollments,
            CASE
               WHEN ed.onsite_attended IS NULL
               THEN
                  ed.attend_enrollments
               ELSE
                  CASE
                     WHEN ed.onsite_attended > ed.attend_enrollments
                     THEN
                        ed.onsite_attended
                     ELSE
                        ed.attend_enrollments
                  END
            END
               num_students,
            capacity
     FROM               order_fact f
                     INNER JOIN
                        event_dim ed
                     ON f.event_id = ed.event_id
                  INNER JOIN
                     time_dim td
                  ON ed.start_date = td.dim_date
               INNER JOIN
                  course_dim cd
               ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
            INNER JOIN
               gk_channel_partner cp
            ON UPPER (f.keycode) = UPPER (cp.partner_key_code)
    WHERE   f.enroll_status IN ('Confirmed', 'Attended')
   --and ed.start_date between '01-JAN-2011' and '29-APR-2011'
   --and channel_manager in ('Brendan Duffy','Buck Milliken','Chuck Hernandez','Joe  Buonocore','Matthew Rosenblum')
   UNION
   SELECT   f.enroll_id,
            f.cust_id,
            f.book_amt,
            cd.list_price,
            f.salesperson,
            c.acct_name,
            '',
            ed.event_id,
            ed.start_date,
            ed.end_date,
            cd.course_code,
            td.dim_year,
            td.dim_period_name,
            cd.course_ch,
            ed.onsite_attended,
            attend_enrollments,
            CASE
               WHEN ed.onsite_attended IS NULL
               THEN
                  ed.attend_enrollments
               ELSE
                  CASE
                     WHEN ed.onsite_attended > ed.attend_enrollments
                     THEN
                        ed.onsite_attended
                     ELSE
                        ed.attend_enrollments
                  END
            END
               num_students,
            CASE WHEN pricing_cap IS NULL THEN 0 ELSE pricing_cap END
               base_students
     FROM                  order_fact f
                        INNER JOIN
                           cust_dim c
                        ON f.cust_id = c.cust_id
                     INNER JOIN
                        event_dim ed
                     ON f.event_id = ed.event_id
                  INNER JOIN
                     time_dim td
                  ON ed.start_date = td.dim_date
               INNER JOIN
                  course_dim cd
               ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
            LEFT OUTER JOIN
               slxdw.evxcoursefee cf
            ON     cd.course_id = cf.evxcourseid
               AND cd.country = UPPER (cf.pricelist)
               AND feetype = 'Ons - Base'
               AND feeallowuse = 'T'
    WHERE   f.enroll_status IN ('Confirmed', 'Attended')
            --and ed.start_date between '01-JAN-2011' and '29-APR-2011'
            AND (cd.ch_num = '20'
                 OR (cd.ch_num IS NULL AND ed.event_type = 'Onsite'))
            AND f.book_amt > 0
   --and f.salesperson in ('Brendan Duffy','Buck Milliken','Chuck Hernandez','Joe  Bounocore','Matthew Rosenblum')
   ORDER BY   sales_rep;


