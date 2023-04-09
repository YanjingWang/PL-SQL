DROP VIEW GKDW.GK_PMP_V;

/* Formatted on 29/01/2021 11:30:42 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PMP_V
(
   COURSE_ID,
   COURSE_CODE,
   EVENT_ID,
   START_DATE,
   CUST_ID,
   CUST_NAME,
   ACCT_ID,
   ACCT_NAME,
   ENROLL_DATE,
   ENROLL_STATUS,
   SALES_REP
)
AS
     SELECT   DISTINCT cd.course_id,
                       cd.course_code,
                       ed.event_id,
                       ed.start_date,
                       c.cust_id,
                       c.cust_name,
                       c.acct_id,
                       c.acct_name,
                       f.enroll_date,
                       f.enroll_status,
                       f.sales_rep
       FROM            course_dim cd
                    INNER JOIN
                       event_dim ed
                    ON cd.course_id = ed.course_id
                       AND cd.country = ed.ops_country
                 INNER JOIN
                    order_fact f
                 ON ed.event_id = f.event_id --and f.enroll_status in ('Confirmed','Attended')
              INNER JOIN
                 cust_dim c
              ON f.cust_id = c.cust_id
      WHERE   cd.course_code IN (  SELECT   course_code FROM gk_pmp_guided)
              AND f.enroll_date >= TRUNC (SYSDATE) - 150
   ORDER BY   cust_name, course_code;


