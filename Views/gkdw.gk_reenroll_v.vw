DROP VIEW GKDW.GK_REENROLL_V;

/* Formatted on 29/01/2021 11:28:14 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_REENROLL_V
(
   ORIG_ENROLL_ID,
   TRANSFER_ENROLL_ID,
   CANCELLED_DATE
)
AS
   SELECT   f1.enroll_id orig_enroll_id,
            f2.enroll_id transfer_enroll_id,
            f1.enroll_status_date cancelled_date
     FROM               order_fact f1
                     INNER JOIN
                        event_dim e1
                     ON f1.event_id = e1.event_id
                  INNER JOIN
                     time_dim td
                  ON f1.enroll_status_date = td.dim_date
               INNER JOIN
                  order_fact f2
               ON f1.cust_id = f2.cust_id
                  AND f2.book_date BETWEEN f1.enroll_status_date
                                       AND  f1.enroll_status_date + 30
                  AND f1.enroll_id != f2.enroll_id
            INNER JOIN
               event_dim e2
            ON f2.event_id = e2.event_id AND e1.course_id = e2.course_id
    WHERE       td.dim_year >= 2007
            AND f1.enroll_status = 'Cancelled'
            AND e1.event_id != e2.event_id
            AND f1.book_amt < 0
            AND f2.book_amt > 0
            AND f1.transfer_enroll_id IS NULL
   UNION
   SELECT   f1.enroll_id orig_enroll_id,
            f2.enroll_id transfer_enroll_id,
            f1.enroll_status_date cancelled_date
     FROM               order_fact f1
                     INNER JOIN
                        event_dim e1
                     ON f1.event_id = e1.event_id
                  INNER JOIN
                     time_dim td
                  ON f1.enroll_status_date = td.dim_date
               INNER JOIN
                  order_fact f2
               ON f1.cust_id = f2.cust_id
                  AND f2.book_date BETWEEN f1.enroll_status_date
                                       AND  f1.enroll_status_date + 30
                  AND f1.enroll_id != f2.enroll_id
            INNER JOIN
               event_dim e2
            ON f2.event_id = e2.event_id
               AND SUBSTR (e1.course_code, 1, 4) =
                     SUBSTR (e2.course_code, 1, 4)
               AND e1.course_id != e2.course_id
    WHERE       td.dim_year >= 2007
            AND f1.enroll_status = 'Cancelled'
            AND e1.event_id != e2.event_id
            AND f1.book_amt < 0
            AND f2.book_amt > 0
            AND f1.transfer_enroll_id IS NULL
   ORDER BY   1, 2;


