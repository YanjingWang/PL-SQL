DROP VIEW GKDW.GK_COURSE_PER_WEEK_V;

/* Formatted on 29/01/2021 11:39:40 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_PER_WEEK_V
(
   COUNTRY,
   COURSE_CODE,
   MAX_COURSE_PER_WEEK,
   MAX_PL_PER_WEEK,
   MAX_TYPE_PER_WEEK
)
AS
     SELECT   f.country,
              f.course_code,
              CEIL (SUM (year_dist) / 50) max_course_per_week,
              NVL (cp.max_per_week, 0) max_pl_per_week,
              NVL (ct.max_per_week, 0) max_type_per_week
       FROM            gk_auto_sched_freq_v f
                    LEFT OUTER JOIN
                       course_dim cd
                    ON     f.course_code = cd.course_code
                       AND f.country = cd.country
                       AND cd.gkdw_source = 'SLXDW'
                 LEFT OUTER JOIN
                    gk_course_pl_per_week_v cp
                 ON cd.country = cp.country AND cd.course_pl = cp.course_pl
              LEFT OUTER JOIN
                 gk_course_type_per_week_v ct
              ON cd.country = ct.country AND cd.course_type = ct.course_type
   GROUP BY   f.country,
              f.course_code,
              NVL (cp.max_per_week, 0),
              NVL (ct.max_per_week, 0);


