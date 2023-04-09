DROP VIEW GKDW.GK_ONSITE_ATTENDED_CNT_V;

/* Formatted on 29/01/2021 11:31:40 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ONSITE_ATTENDED_CNT_V
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
              CASE
                 WHEN ed.onsite_attended IS NOT NULL THEN ed.onsite_attended
                 ELSE ed.capacity
              END
                 enroll_cnt
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              LEFT OUTER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
      WHERE       cd.md_num IN ('10', '20')
              AND cd.ch_num = '20'
              AND ed.status != 'Cancelled'
   --and ed.event_id = 'Q6UJ9A09PARU'
   GROUP BY   ed.event_id,
              ed.course_id,
              cd.course_code,
              ed.onsite_attended,
              ed.capacity
     HAVING   SUM (CASE WHEN f.enroll_status = 'Attended' THEN 1 ELSE 0 END) =
                 0
   UNION
     SELECT   ed.event_id,
              ed.course_id,
              cd.course_code,
              ed.capacity,
              SUM (CASE WHEN f.enroll_status = 'Attended' THEN 1 ELSE 0 END)
                 enroll_cnt
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              LEFT OUTER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
      WHERE       cd.md_num IN ('10', '20')
              AND cd.ch_num = '20'
              AND ed.status != 'Cancelled'
   --and ed.event_id = 'Q6UJ9A09PARU'
   GROUP BY   ed.event_id,
              ed.course_id,
              cd.course_code,
              ed.onsite_attended,
              ed.capacity,
              f.enroll_status
     HAVING   SUM (CASE WHEN f.enroll_status = 'Attended' THEN 1 ELSE 0 END) >
                 0;


