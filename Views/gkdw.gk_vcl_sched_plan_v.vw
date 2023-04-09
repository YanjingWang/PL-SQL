DROP VIEW GKDW.GK_VCL_SCHED_PLAN_V;

/* Formatted on 29/01/2021 11:24:12 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_VCL_SCHED_PLAN_V
(
   EVENT_ID,
   COURSE_CODE,
   COURSE_ID,
   START_DATE,
   OPS_COUNTRY,
   STATUS,
   CONNECTED_V,
   SALES_REQUEST,
   EV_SCHED,
   EV_RUN,
   EV_CANC,
   EV_STUD
)
AS
   SELECT   CASE
               WHEN us_status IN ('Open', 'Verified') THEN us_event_id
               WHEN ca_status IN ('Open', 'Verified') THEN ca_event_id
               ELSE us_event_id
            END
               event_id,
            us_course_code course_code,
            course_id,
            us_start_date start_date,
            CASE
               WHEN us_status IN ('Open', 'Verified') THEN us_ops_country
               WHEN ca_status IN ('Open', 'Verified') THEN ca_ops_country
               ELSE us_ops_country
            END
               ops_country,
            CASE
               WHEN us_status IN ('Open', 'Verified') THEN us_status
               WHEN ca_status IN ('Open', 'Verified') THEN ca_status
               ELSE us_status
            END
               status,
            CASE
               WHEN us_connected_v = 'Y' OR ca_connected_v = 'Y' THEN 'Y'
               ELSE 'N'
            END
               connected_v,
            CASE
               WHEN us_sales_request = 'Y' OR ca_sales_request = 'Y' THEN 'Y'
               ELSE 'N'
            END
               sales_request,
            1 ev_sched,
            CASE
               WHEN us_status IN ('Open', 'Verified')
                    OR ca_status IN ('Open', 'Verified')
               THEN
                  1
               ELSE
                  0
            END
               ev_run,
            CASE
               WHEN us_status IN ('Open', 'Verified')
                    OR ca_status IN ('Open', 'Verified')
               THEN
                  0
               ELSE
                  1
            END
               ev_canc,
            us_enroll_cnt + ca_enroll_cnt ev_stud
     FROM   (  SELECT   ed1.event_id us_event_id,
                        ed1.course_code us_course_code,
                        ed1.course_id,
                        ed1.start_date us_start_date,
                        ed1.ops_country us_ops_country,
                        ed1.status us_status,
                        CASE
                           WHEN ed1.connected_v_to_c IS NOT NULL THEN 'Y'
                           ELSE 'N'
                        END
                           us_connected_v,
                        CASE
                           WHEN ed1.plan_type = 'Sales Request' THEN 'Y'
                           ELSE 'N'
                        END
                           us_sales_request,
                        ed2.event_id ca_event_id,
                        ed2.course_code ca_course_code,
                        ed2.start_date ca_start_date,
                        ed2.ops_country ca_ops_country,
                        ed2.status ca_status,
                        CASE
                           WHEN ed2.connected_v_to_c IS NOT NULL THEN 'Y'
                           ELSE 'N'
                        END
                           ca_connected_v,
                        CASE
                           WHEN ed2.plan_type = 'Sales Request' THEN 'Y'
                           ELSE 'N'
                        END
                           ca_sales_request,
                        COUNT (DISTINCT f1.enroll_id) us_enroll_cnt,
                        COUNT (DISTINCT f2.enroll_id) ca_enroll_cnt
                 FROM               event_dim ed1
                                 INNER JOIN
                                    course_dim cd1
                                 ON ed1.course_id = cd1.course_id
                                    AND ed1.ops_country = cd1.country
                              INNER JOIN
                                 event_dim ed2
                              ON     ed1.course_code = ed2.course_code
                                 AND ed1.start_date = ed2.start_date
                                 AND ed1.start_time = ed2.start_time
                                 AND ed1.ops_country != ed2.ops_country
                           LEFT OUTER JOIN
                              order_fact f1
                           ON ed1.event_id = f1.event_id
                              AND f1.enroll_status != 'Cancelled'
                        LEFT OUTER JOIN
                           order_fact f2
                        ON ed2.event_id = f2.event_id
                           AND f2.enroll_status != 'Cancelled'
                WHERE       ed1.start_date > TRUNC (SYSDATE) - 1095
                        AND cd1.md_num = '20'
                        AND ed1.ops_country = 'USA'
                        AND NVL (REPLACE (ed1.cancel_reason, CHR (13), ''),
                                 'NONE') NOT IN
                                 ('Course Delays - Equipment, Devel',
                                  'Course Discontinued',
                                  'Course Version Update',
                                  'Event in Error',
                                  'Event Postponed due to Acts of N',
                                  'OS XL - Rescheduled due to Holid',
                                  'Pre-Cancel (market/schedule righ')
             --   and nvl(replace(ed2.cancel_reason,chr(13),''),'NONE') not in ('Course Delays - Equipment, Devel','Course Discontinued','Course Version Update','Event in Error','Event Postponed due to Acts of N',
             --                                                                 'OS XL - Rescheduled due to Holid','Pre-Cancel (market/schedule righ')
             GROUP BY   ed1.event_id,
                        ed1.course_code,
                        ed1.course_id,
                        ed1.start_date,
                        ed1.ops_country,
                        ed1.status,
                        ed1.connected_v_to_c,
                        ed1.plan_type,
                        ed2.event_id,
                        ed2.course_code,
                        ed2.start_date,
                        ed2.ops_country,
                        ed2.status,
                        ed2.connected_v_to_c,
                        ed2.plan_type)
   UNION
     SELECT   ed.event_id,
              ed.course_code,
              ed.course_id,
              ed.start_date,
              ed.ops_country,
              ed.status,
              CASE WHEN ed.connected_v_to_c IS NOT NULL THEN 'Y' ELSE 'N' END
                 connected_v,
              CASE WHEN ed.plan_type = 'Sales Request' THEN 'Y' ELSE 'N' END
                 sales_request,
              1 ev_sched,
              CASE WHEN ed.status IN ('Open', 'Verified') THEN 1 ELSE 0 END
                 ev_run,
              CASE WHEN ed.status IN ('Cancelled') THEN 1 ELSE 0 END ev_canc,
              COUNT (DISTINCT f.enroll_id) enroll_cnt
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              LEFT OUTER JOIN
                 order_fact f
              ON ed.event_id = f.event_id AND f.enroll_status != 'Cancelled'
      WHERE   ed.start_date > TRUNC (SYSDATE) - 1095 AND cd.md_num = '20'
              AND NVL (REPLACE (ed.cancel_reason, CHR (13), ''), 'NONE') NOT IN
                       ('Course Delays - Equipment, Devel',
                        'Course Discontinued',
                        'Course Version Update',
                        'Event in Error',
                        'Event Postponed due to Acts of N',
                        'OS XL - Rescheduled due to Holid',
                        'Pre-Cancel (market/schedule righ')
              AND NOT EXISTS
                    (SELECT   1
                       FROM   event_dim ed2
                      WHERE       ed.course_code = ed2.course_code
                              AND ed.start_date = ed2.start_date
                              AND ed.start_time = ed2.start_time
                              AND ed.ops_country != ed2.ops_country)
   GROUP BY   ed.event_id,
              ed.course_code,
              ed.course_id,
              ed.start_date,
              ed.ops_country,
              ed.status,
              CASE WHEN ed.connected_v_to_c IS NOT NULL THEN 'Y' ELSE 'N' END,
              CASE WHEN ed.plan_type = 'Sales Request' THEN 'Y' ELSE 'N' END
   ORDER BY   start_date, course_code;


