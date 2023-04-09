DROP VIEW GKDW.GK_SCHED_METRO_FREQ_V;

/* Formatted on 29/01/2021 11:26:37 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SCHED_METRO_FREQ_V
(
   OPS_COUNTRY,
   COURSE_CODE,
   COURSE_PL,
   COURSE_MOD,
   COURSE_CH,
   COURSE_TYPE,
   SHORT_NAME,
   FACILITY_REGION_METRO,
   SCHED_EVENT,
   TOTAL_COURSE,
   METRO_PCT
)
AS
     SELECT   ed.ops_country,
              cd.course_code,
              cd.course_pl,
              cd.course_mod,
              cd.course_ch,
              cd.course_type,
              cd.short_name,
              ed.facility_region_metro,
              COUNT (ed.event_id) sched_event,
              q.total_course,
              COUNT (ed.event_id) / q.total_course metro_pct
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON     ed.course_id = cd.course_id
                    AND ed.ops_country = cd.country
                    AND cd.gkdw_source = 'SLXDW'
              INNER JOIN
                 (  SELECT   ed.ops_country,
                             cd.course_code,
                             cd.course_pl,
                             cd.course_mod,
                             cd.course_ch,
                             cd.course_type,
                             cd.short_name,
                             COUNT (ed.event_id) total_course
                      FROM      event_dim ed
                             INNER JOIN
                                course_dim cd
                             ON ed.course_id = cd.course_id
                                AND ed.ops_country = cd.country
                     WHERE   ed.start_date BETWEEN TRUNC (SYSDATE) - 365
                                               AND  TRUNC (SYSDATE)
                             AND (ed.status IN ('Verified', 'Open')
                                  OR (ed.status = 'Cancelled'
                                      AND ed.cancel_reason = 'Low Enrollment'))
                             AND SUBSTR (ed.course_code, 5, 1) = 'C'
                             AND ed.ops_country = 'USA'
                  GROUP BY   ed.ops_country,
                             cd.course_code,
                             cd.course_pl,
                             cd.course_mod,
                             cd.course_ch,
                             cd.course_type,
                             cd.short_name) q
              ON     ed.ops_country = q.ops_country
                 AND cd.course_code = q.course_code
                 AND cd.course_mod = q.course_mod
      WHERE   ed.start_date BETWEEN TRUNC (SYSDATE) - 365 AND TRUNC (SYSDATE)
              AND (ed.status IN ('Verified', 'Open')
                   OR (ed.status = 'Cancelled'
                       AND ed.cancel_reason = 'Low Enrollment'))
              AND SUBSTR (ed.course_code, 5, 1) = 'C'
              AND ed.ops_country = 'USA'
   GROUP BY   ed.ops_country,
              cd.course_code,
              cd.course_pl,
              cd.course_mod,
              cd.course_ch,
              cd.course_type,
              cd.short_name,
              ed.facility_region_metro,
              q.total_course
   ORDER BY   course_pl,
              course_type,
              course_code,
              facility_region_metro;


