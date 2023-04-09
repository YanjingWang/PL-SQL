DROP VIEW GKDW.GK_NIU_EVENT_CNT_V;

/* Formatted on 29/01/2021 11:32:21 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_NIU_EVENT_CNT_V
(
   EVENT_ID,
   COURSE_ID,
   COURSE_CODE,
   CAPACITY,
   ENROLL_CNT
)
AS
     SELECT   DISTINCT ed.event_id,
                       ed.course_id,
                       ed.course_code,
                       ed.capacity,
                       COUNT ( * ) enroll_cnt
       FROM                  event_dim ed
                          INNER JOIN
                             course_dim cd
                          ON ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                       INNER JOIN
                          rmsdw.rms_event re
                       ON ed.event_id = re.slx_event_id
                          AND UPPER (re.contract_status) IN
                                   ('CONTRACT ON FILE', 'DEDICATED ROOM')
                    INNER JOIN
                       time_dim td
                    ON ed.start_date = td.dim_date
                 INNER JOIN
                    time_dim td2
                 ON td2.dim_date = TRUNC (SYSDATE)
              INNER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
      WHERE       ed.status != 'Cancelled'
              AND f.enroll_status IN ('Attended', 'Confirmed')
              AND ed.facility_code = 'NIU-CHI'
   GROUP BY   ed.event_id,
              ed.course_id,
              ed.course_code,
              ed.capacity;


