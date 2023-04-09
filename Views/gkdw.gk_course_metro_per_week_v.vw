DROP VIEW GKDW.GK_COURSE_METRO_PER_WEEK_V;

/* Formatted on 29/01/2021 11:39:44 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_METRO_PER_WEEK_V
(
   COUNTRY,
   METRO,
   MAX_PER_WEEK
)
AS
     SELECT   f.country, f.metro, CEIL (SUM (year_dist) / 50) max_per_week
       FROM   gk_auto_sched_freq_v f
   GROUP BY   f.country, f.metro;


