DROP VIEW GKDW.GK_CANADA_ORDER_HISTORY_V;

/* Formatted on 29/01/2021 11:42:08 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CANADA_ORDER_HISTORY_V
(
   CUST_ID,
   SOURCE_CONTACTID,
   ENROLL_ID,
   ENROLL_STATUS,
   ENROLL_DATE,
   EVENT_NAME,
   COURSE_CODE,
   COURSE_PL,
   COURSE_TYPE,
   START_DATE,
   BOOK_AMT
)
AS
   SELECT   cust_id,
            source_contactid,
            enroll_id,
            enroll_status,
            enroll_date,
            event_name,
            course_code,
            course_pl,
            course_type,
            start_date,
            book_amt
     FROM            order_fact o
                  INNER JOIN
                     event_dim e
                  ON o.event_id = e.event_id
               INNER JOIN
                  course_dim c
               ON e.course_id = c.course_id
            INNER JOIN
               slxdw.gk_enrollment g
            ON o.cust_id = g.attendeecontactid
    WHERE   c.country = 'CANADA'
   UNION
   SELECT   attendeecontactid,
            student_no,
            enroll_no,
            status,
            orderdate,
            coursename,
            custshortcode,
            custproductline,
            custproductline,
            startdate,
            amount
     FROM      nexdw.tp_enrollments e
            INNER JOIN
               slxdw.gk_enrollment g
            ON e.student_no = g.source_contactid
   ORDER BY   1;


