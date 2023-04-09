DROP VIEW GKDW.GK_COURSE_TYPE_PER_WEEK_V;

/* Formatted on 29/01/2021 11:38:59 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_TYPE_PER_WEEK_V
(
   COUNTRY,
   COURSE_TYPE,
   MAX_PER_WEEK
)
AS
     SELECT   f.country,
              cd.course_type,
              CEIL (SUM (year_dist) / 50) max_per_week
       FROM      gk_auto_sched_freq_v f
              LEFT OUTER JOIN
                 course_dim cd
              ON f.course_code = cd.course_code AND f.country = cd.country
   GROUP BY   f.country, cd.course_type;


