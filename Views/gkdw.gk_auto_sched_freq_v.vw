DROP VIEW GKDW.GK_AUTO_SCHED_FREQ_V;

/* Formatted on 29/01/2021 11:42:56 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_AUTO_SCHED_FREQ_V
(
   COUNTRY,
   METRO,
   COURSE_CODE,
   COURSE_ID,
   COURSE_PL,
   SHORT_NAME,
   COURSE_TYPE,
   DURATION_DAYS,
   YEAR_DIST,
   YEAR_FREQ,
   LAST_WEEK
)
AS
     SELECT   country,
              metro,
              course_code,
              course_id,
              course_pl,
              short_name,
              course_type,
              duration_days,
              year_dist,
              year_freq,
              MAX (td2.fiscal_week) last_week
       FROM      (  SELECT   l.country,
                             l.metro,
                             l.course_code,
                             cd.course_id,
                             cd.course_pl,
                             cd.short_name,
                             cd.course_type,
                             cd.duration_days,
                             l.year_dist,
                             ROUND (52 / year_dist) year_freq,
                             NVL (MAX (LPAD (td.fiscal_week, 2, '0')), '52')
                                last_week
                      FROM            gk_auto_sched_load l
                                   INNER JOIN
                                      course_dim cd
                                   ON     l.course_code = cd.course_code
                                      AND l.country = cd.country
                                      AND gkdw_source = 'SLXDW'
                                LEFT OUTER JOIN
                                   event_dim ed
                                ON cd.course_id = ed.course_id
                                   AND l.metro = ed.facility_region_metro
                             LEFT OUTER JOIN
                                time_dim td
                             ON td.dim_date = ed.start_date
                                AND td.fiscal_year = 2016
                     WHERE   year_dist > 0
                  GROUP BY   l.country,
                             l.metro,
                             l.course_code,
                             cd.course_id,
                             cd.course_pl,
                             cd.short_name,
                             cd.course_type,
                             cd.duration_days,
                             l.year_dist,
                             ROUND (52 / year_dist)) q
              LEFT OUTER JOIN
                 time_dim td2
              ON td2.fiscal_year = 2016
                 AND LPAD (td2.fiscal_week, 2, '0') = q.last_week
   GROUP BY   country,
              metro,
              course_code,
              course_id,
              course_pl,
              short_name,
              course_type,
              duration_days,
              year_dist,
              year_freq
   ORDER BY   country, course_code;


