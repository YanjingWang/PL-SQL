DROP VIEW GKDW.GK_OE_ATTENDED_CNT_V;

/* Formatted on 29/01/2021 11:32:05 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_OE_ATTENDED_CNT_V
(
   EVENT_ID,
   COURSE_ID,
   COURSE_CODE,
   CAPACITY,
   ENROLL_CNT
)
AS
     SELECT   ed.event_id,
              ed.course_id,
              cd.course_code,
              ed.capacity,
              COUNT ( * ) enroll_cnt
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              INNER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
      WHERE       cd.md_num IN ('10', '20')
              AND cd.ch_num = '10'
              AND ed.status != 'Cancelled'
              AND f.enroll_status IN ('Attended', 'Confirmed')
   GROUP BY   ed.event_id,
              ed.course_id,
              cd.course_code,
              ed.capacity;


