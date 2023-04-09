DROP VIEW GKDW.GK_CDW_COURSE_EXCEPT_V;

/* Formatted on 29/01/2021 11:41:32 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CDW_COURSE_EXCEPT_V
(
   CDW_GROUP,
   PERIOD_NAME,
   EVENT_ID,
   COURSE_CODE,
   START_DATE,
   FACILITY_CODE,
   SHORT_NAME,
   ATTENDED_CNT,
   ONSITE_ATTENDED,
   OPS_COUNTRY,
   CH_NUM,
   MD_NUM,
   GROSS_REVENUE
)
AS
     SELECT   'EX-NOT_ON_MASTER' cdw_group,
              td.dim_period_name period_name,
              ed.event_id,
              ed.course_code,
              ed.start_date,
              ed.facility_code,
              cd.short_name,
              COUNT (f.enroll_id) attended_cnt,
              NVL (ed.onsite_attended, 0) onsite_attended,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    UPPER (c.country)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    ed.ops_country
              END
                 ops_country,
              cd.ch_num,
              cd.md_num,
              SUM (NVL (f.book_amt, 0)) + NVL (ob.book_amt, 0) gross_revenue
       FROM                  event_dim ed
                          INNER JOIN
                             course_dim cd
                          ON ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                       INNER JOIN
                          time_dim td
                       ON ed.start_date = td.dim_date
                    LEFT OUTER JOIN
                       order_fact f
                    ON ed.event_id = f.event_id
                       AND f.enroll_status = 'Attended'
                 LEFT OUTER JOIN
                    cust_dim c
                 ON f.cust_id = c.cust_id
              LEFT OUTER JOIN
                 gk_cdw_onsite_v ob
              ON ed.event_id = ob.event_id
      WHERE   ed.status IN ('Open', 'Verified')
              AND ed.event_id NOT IN
                       (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND cd.ch_num IN ('10', '20')
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cd.course_code != '9989N'
              AND NOT EXISTS
                    (SELECT   1
                       FROM   gk_cdw_interface cc
                      WHERE   SUBSTR (ed.course_code, 1, 4) = cc.gk_course_num)
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              ed.start_date,
              ed.facility_code,
              ed.onsite_attended,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    UPPER (c.country)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    ed.ops_country
              END,
              cd.ch_num,
              cd.md_num,
              cd.short_name,
              NVL (ob.book_amt, 0);


