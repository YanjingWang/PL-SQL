DROP MATERIALIZED VIEW GKDW.GK_SCHED_TEMP_MV;
CREATE MATERIALIZED VIEW GKDW.GK_SCHED_TEMP_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:22:29 (QP5 v5.115.810.9015) */
  SELECT   country,
           course_ch,
           course_mod,
           course_pl,
           course_type,
           root_code,
           course_id,
           course_code,
           short_name,
           duration_days,
           SUM (sched_2) sched_2,
           SUM (ev_2) ev_2,
           SUM (en_2) en_2,
           SUM (fill_2) fill_2,
           SUM (sched_1) sched_1,
           SUM (ev_1) ev_1,
           SUM (en_1) en_1,
           SUM (fill_1) fill_1,
           SUM (sched_0) sched_0,
           SUM (ev_0) ev_0,
           SUM (en_0) en_0,
           SUM (fill_0) fill_0,
           SUM (book_0) book_0,
           SUM (sched_plan) sched_plan,
           SUM (ev_plan) ev_plan,
           SUM (en_plan) en_plan,
           SUM (fill_plan) fill_plan,
           SUM (rev_stud_3mo) rev_stud_3mo,
           SUM (book_plan) book_plan,
           SUM (book_future) book_future
    FROM   (SELECT   country,
                     course_ch,
                     course_mod,
                     course_pl,
                     course_type,
                     root_code,
                     course_id,
                     course_code,
                     short_name,
                     duration_days,
                     sched_cnt sched_2,
                     ev_cnt ev_2,
                     en_cnt en_2,
                     CASE
                        WHEN ev_cnt = 0 THEN 0
                        ELSE ROUND (en_cnt / ev_cnt, 1)
                     END
                        fill_2,
                     0 sched_1,
                     0 ev_1,
                     0 en_1,
                     0 fill_1,
                     0 sched_0,
                     0 ev_0,
                     0 en_0,
                     0 fill_0,
                     0 book_0,
                     0 sched_plan,
                     0 ev_plan,
                     0 en_plan,
                     0 fill_plan,
                     0 rev_stud_3mo,
                     0 book_plan,
                     0 book_future
              FROM   gk_sched_2_ago_v
            UNION ALL
            SELECT   country,
                     course_ch,
                     course_mod,
                     course_pl,
                     course_type,
                     root_code,
                     course_id,
                     course_code,
                     short_name,
                     duration_days,
                     0 sched_2,
                     0 ev_2,
                     0 en_2,
                     0 fill_2,
                     sched_cnt sched_1,
                     ev_cnt ev_1,
                     en_cnt en_1,
                     CASE
                        WHEN ev_cnt = 0 THEN 0
                        ELSE ROUND (en_cnt / ev_cnt, 1)
                     END
                        fill_1,
                     0 sched_0,
                     0 ev_0,
                     0 en_0,
                     0 fill_0,
                     0 book_0,
                     0 sched_plan,
                     0 ev_plan,
                     0 en_plan,
                     0 fill_plan,
                     0 rev_stud_3mo,
                     0 book_plan,
                     0 book_future
              FROM   gk_sched_1_ago_v
            UNION ALL
            SELECT   country,
                     course_ch,
                     course_mod,
                     course_pl,
                     course_type,
                     root_code,
                     course_id,
                     course_code,
                     short_name,
                     duration_days,
                     0 sched_2,
                     0 ev_2,
                     0 en_2,
                     0 fill_2,
                     0 sched_1,
                     0 ev_1,
                     0 en_1,
                     0 fill_1,
                     sched_cnt sched_0,
                     ev_cnt ev_0,
                     en_cnt en_0,
                     CASE
                        WHEN ev_cnt = 0 THEN 0
                        ELSE ROUND (en_cnt / ev_cnt, 1)
                     END
                        fill_0,
                     book_amt book_0,
                     0 sched_plan,
                     0 ev_plan,
                     0 en_plan,
                     0 fill_plan,
                     0 rev_stud_3mo,
                     0 book_plan,
                     0 book_future
              FROM   gk_sched_ytd_v
            UNION ALL
            SELECT   country,
                     course_ch,
                     course_mod,
                     course_pl,
                     course_type,
                     root_code,
                     course_id,
                     course_code,
                     short_name,
                     duration_days,
                     0 sched_2,
                     0 ev_2,
                     0 en_2,
                     0 fill_2,
                     0 sched_1,
                     0 ev_1,
                     0 en_1,
                     0 fill_1,
                     0 sched_0,
                     0 ev_0,
                     0 en_0,
                     0 fill_0,
                     0 book_0,
                     sched_cnt sched_plan,
                     ev_cnt ev_plan,
                     en_cnt en_plan,
                     CASE
                        WHEN ev_cnt = 0 THEN 0
                        ELSE ROUND (en_cnt / ev_cnt, 1)
                     END
                        fill_plan,
                     rev_stud_3mo,
                     book_amt book_plan,
                     0 book_future
              FROM   gk_sched_plan_v
            UNION ALL
            SELECT   country,
                     course_ch,
                     course_mod,
                     course_pl,
                     course_type,
                     root_code,
                     course_id,
                     course_code,
                     short_name,
                     duration_days,
                     0 sched_2,
                     0 ev_2,
                     0 en_2,
                     0 fill_2,
                     0 sched_1,
                     0 ev_1,
                     0 en_1,
                     0 fill_1,
                     0 sched_0,
                     0 ev_0,
                     0 en_0,
                     0 fill_0,
                     0 book_0,
                     0 sched_plan,
                     0 ev_plan,
                     0 en_plan,
                     0 fill_plan,
                     0 rev_stud_3mo,
                     0 book_plan,
                     book_amt book_future
              FROM   gk_sched_future_v)
GROUP BY   country,
           course_ch,
           course_mod,
           course_pl,
           course_type,
           root_code,
           course_id,
           course_code,
           short_name,
           duration_days;

COMMENT ON MATERIALIZED VIEW GKDW.GK_SCHED_TEMP_MV IS 'snapshot table for snapshot GKDW.GK_SCHED_TEMP_MV';

GRANT SELECT ON GKDW.GK_SCHED_TEMP_MV TO DWHREAD;

