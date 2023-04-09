DROP VIEW GKDW.GK_EVENT_CONSOLIDATION_V;

/* Formatted on 29/01/2021 11:37:16 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EVENT_CONSOLIDATION_V
(
   EVENT_ID,
   COURSE_ID,
   COURSE_CODE,
   SHORT_NAME,
   START_DATE,
   END_DATE,
   STATUS,
   FACILITY_CODE,
   FACILITY_REGION_METRO,
   CITY,
   STATE,
   ZIPCODE,
   ENROLL_CNT,
   ENROLL_ID,
   BOOK_DATE,
   KEYCODE,
   BOOK_AMT,
   FEE_TYPE,
   SOURCE,
   LIST_PRICE,
   PO_NUMBER,
   PAYMENT_METHOD,
   CUST_ID,
   FIRST_NAME,
   LAST_NAME,
   ACCT_NAME,
   EMAIL,
   CUST_CITY,
   CUST_STATE,
   CUST_ZIPCODE,
   CUST_LAT,
   CUST_LONG,
   DISTANCE_MI
)
AS
     SELECT   q.*,
              f.enroll_id,
              f.book_date,
              f.keycode,
              f.book_amt,
              f.fee_type,
              f.source,
              f.list_price,
              f.po_number,
              f.payment_method,
              cd.cust_id,
              cd.first_name,
              cd.last_name,
              cd.acct_name,
              cd.email,
              cd.city cust_city,
              cd.state cust_state,
              SUBSTR (cd.zipcode, 1, 5) cust_zipcode,
              l2.latitude cust_lat,
              l2.longitude cust_long,
              ROUND (get_distance (l1.latitude,
                                   l1.longitude,
                                   l2.latitude,
                                   l2.longitude))
                 distance_mi
       FROM               (  SELECT   ed.event_id,
                                      ed.course_id,
                                      cd.course_code,
                                      cd.short_name,
                                      ed.start_date,
                                      ed.end_date,
                                      ed.status,
                                      ed.facility_code,
                                      ed.facility_region_metro,
                                      ed.city,
                                      ed.state,
                                      ed.zipcode,
                                      SUM(CASE
                                             WHEN f.enroll_status = 'Confirmed'
                                                  AND f.book_amt > 0
                                             THEN
                                                1
                                             ELSE
                                                0
                                          END)
                                         enroll_cnt
                               FROM               event_dim ed
                                               INNER JOIN
                                                  course_dim cd
                                               ON ed.course_id = cd.course_id
                                                  AND ed.ops_country = cd.country
                                            INNER JOIN
                                               order_fact f
                                            ON ed.event_id = f.event_id
                                         INNER JOIN
                                            time_dim td1
                                         ON ed.start_date = td1.dim_date
                                      INNER JOIN
                                         time_dim td2
                                      ON td2.dim_date = TRUNC (SYSDATE)
                              WHERE   td1.dim_year = td2.dim_year
                                      AND td1.dim_week BETWEEN td2.dim_week + 4
                                                           AND  td2.dim_week + 8
                                      AND NOT EXISTS
                                            (SELECT   1
                                               FROM   gk_nested_courses n
                                              WHERE   n.nested_course_code =
                                                         cd.course_code)
                                      AND ed.ops_country = 'USA'
                                      AND cd.ch_num = '10'
                                      AND cd.md_num = '10'
                                      AND ed.status = 'Open'
                           GROUP BY   ed.event_id,
                                      ed.course_id,
                                      cd.course_code,
                                      cd.short_name,
                                      ed.start_date,
                                      ed.end_date,
                                      ed.status,
                                      ed.facility_code,
                                      ed.facility_region_metro,
                                      ed.city,
                                      ed.state,
                                      ed.zipcode
                             HAVING   SUM(CASE
                                             WHEN f.enroll_status = 'Confirmed'
                                                  AND f.book_amt > 0
                                             THEN
                                                1
                                             ELSE
                                                0
                                          END) <= 3) q
                       INNER JOIN
                          order_fact f
                       ON q.event_id = f.event_id
                    INNER JOIN
                       cust_dim cd
                    ON f.cust_id = cd.cust_id
                 LEFT OUTER JOIN
                    gk_zipcode_lat_long l1
                 ON q.zipcode = LPAD (l1.zipcode, 5, '0')
              LEFT OUTER JOIN
                 gk_zipcode_lat_long l2
              ON SUBSTR (cd.zipcode, 1, 5) = LPAD (l2.zipcode, 5, '0')
      WHERE   f.enroll_status = 'Confirmed' AND f.book_amt > 0
   ORDER BY   q.start_date, q.event_id, f.book_date;


