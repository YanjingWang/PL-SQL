DROP MATERIALIZED VIEW GKDW.GK_PM_COURSE_PLAN_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PM_COURSE_PLAN_MV 
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
/* Formatted on 29/01/2021 12:23:28 (QP5 v5.115.810.9015) */
(  SELECT   p.country,
            p.course_ch,
            p.course_mod,
            p.course_pl,
            p.course_type,
            p.root_code,
            p.course_id,
            p.course_code,
            p.short_name,
            CASE
               WHEN SUM(  NVL (sched_roll_1, 0) * .70
                        + NVL (sched_roll_2, 0) * .20
                        + NVL (sched_roll_3, 0) * .10) > 0
               THEN
                  ROUND (
                     1
                     - (SUM(  NVL (ev_roll_1, 0) * .70
                            + NVL (ev_roll_2, 0) * .20
                            + NVL (ev_roll_3, 0) * .10)
                        / SUM(  NVL (sched_roll_1, 0) * .70
                              + NVL (sched_roll_2, 0) * .20
                              + NVL (sched_roll_3, 0) * .10)),
                     2
                  )
               ELSE
                  0
            END
               hist_canc,
            CASE
               WHEN SUM(  NVL (ev_roll_1, 0) * .70
                        + NVL (ev_roll_2, 0) * .20
                        + NVL (ev_roll_3, 0) * .10) > 0
               THEN
                  ROUND(SUM(  NVL (en_roll_1, 0) * .70
                            + NVL (en_roll_2, 0) * .20
                            + NVL (en_roll_3, 0) * .10)
                        / SUM(  NVL (ev_roll_1, 0) * .70
                              + NVL (ev_roll_2, 0) * .20
                              + NVL (ev_roll_3, 0) * .10))
               ELSE
                  0
            END
               hist_fill,
            ROUND(CASE
                     WHEN SUM (ev_roll_1) = 0
                     THEN
                        0
                     WHEN AVG (NVL (fr.avg_fill, 0)) = 0
                     THEN
                        0
                     WHEN AVG (NVL (fr.max_fill, 0)) = 0
                     THEN
                        0
                     WHEN ROUND (SUM (en_roll_1) / SUM (ev_roll_1), 1) <
                             AVG (NVL (fr.avg_fill, 0))
                     THEN
                        ROUND(SUM (ev_roll_1)
                              * (  SUM (en_roll_1)
                                 / SUM (ev_roll_1)
                                 / AVG (NVL (fr.avg_fill, 0))))
                     WHEN ROUND (SUM (en_roll_1) / SUM (ev_roll_1), 1) BETWEEN AVG(NVL (
                                                                                      fr.avg_fill,
                                                                                      0
                                                                                   ))
                                                                           AND  AVG(NVL (
                                                                                       fr.max_fill,
                                                                                       0
                                                                                    ))
                     THEN
                        SUM (ev_roll_1)
                     WHEN ROUND (SUM (en_roll_1) / SUM (ev_roll_1), 1) >
                             AVG (NVL (fr.max_fill, 0))
                     THEN
                        ROUND(SUM (ev_roll_1)
                              * (  SUM (en_roll_1)
                                 / SUM (ev_roll_1)
                                 / AVG (NVL (fr.max_fill, 0))))
                  END
                  * (1
                     + (1
                        - (SUM(  NVL (ev_roll_1, 0) * .70
                               + NVL (ev_roll_2, 0) * .20
                               + NVL (ev_roll_3, 0) * .10)
                           / SUM(  NVL (sched_roll_1, 0) * .70
                                 + NVL (sched_roll_2, 0) * .20
                                 + NVL (sched_roll_3, 0) * .10)))))
               sched_cnt_plan,
            CASE
               WHEN SUM (ev_roll_1) = 0
               THEN
                  0
               WHEN AVG (NVL (fr.avg_fill, 0)) = 0
               THEN
                  0
               WHEN AVG (NVL (fr.max_fill, 0)) = 0
               THEN
                  0
               WHEN ROUND (SUM (en_roll_1) / SUM (ev_roll_1), 1) <
                       AVG (NVL (fr.avg_fill, 0))
               THEN
                  ROUND(SUM (ev_roll_1)
                        * (  SUM (en_roll_1)
                           / SUM (ev_roll_1)
                           / AVG (NVL (fr.avg_fill, 0))))
               WHEN ROUND (SUM (en_roll_1) / SUM (ev_roll_1), 1) BETWEEN AVG(NVL (
                                                                                fr.avg_fill,
                                                                                0
                                                                             ))
                                                                     AND  AVG(NVL (
                                                                                 fr.max_fill,
                                                                                 0
                                                                              ))
               THEN
                  SUM (ev_roll_1)
               WHEN ROUND (SUM (en_roll_1) / SUM (ev_roll_1), 1) >
                       AVG (NVL (fr.max_fill, 0))
               THEN
                  ROUND(SUM (ev_roll_1)
                        * (  SUM (en_roll_1)
                           / SUM (ev_roll_1)
                           / AVG (NVL (fr.max_fill, 0))))
            END
               ev_cnt_plan,
            ROUND(CASE
                     WHEN SUM (ev_roll_1) = 0
                     THEN
                        0
                     WHEN AVG (NVL (fr.avg_fill, 0)) = 0
                     THEN
                        0
                     WHEN AVG (NVL (fr.max_fill, 0)) = 0
                     THEN
                        0
                     WHEN ROUND (SUM (en_roll_1) / SUM (ev_roll_1), 1) <
                             AVG (NVL (fr.avg_fill, 0))
                     THEN
                        ROUND(SUM (ev_roll_1)
                              * (  SUM (en_roll_1)
                                 / SUM (ev_roll_1)
                                 / AVG (NVL (fr.avg_fill, 0))))
                     WHEN ROUND (SUM (en_roll_1) / SUM (ev_roll_1), 1) BETWEEN AVG(NVL (
                                                                                      fr.avg_fill,
                                                                                      0
                                                                                   ))
                                                                           AND  AVG(NVL (
                                                                                       fr.max_fill,
                                                                                       0
                                                                                    ))
                     THEN
                        SUM (ev_roll_1)
                     WHEN ROUND (SUM (en_roll_1) / SUM (ev_roll_1), 1) >
                             AVG (NVL (fr.max_fill, 0))
                     THEN
                        ROUND(SUM (ev_roll_1)
                              * (  SUM (en_roll_1)
                                 / SUM (ev_roll_1)
                                 / AVG (NVL (fr.max_fill, 0))))
                  END
                  * CASE
                       WHEN SUM(  NVL (ev_roll_1, 0) * .70
                                + NVL (ev_roll_2, 0) * .20
                                + NVL (ev_roll_3, 0) * .10) > 0
                       THEN
                          SUM(  NVL (en_roll_1, 0) * .70
                              + NVL (en_roll_2, 0) * .20
                              + NVL (en_roll_3, 0) * .10)
                          / SUM(  NVL (ev_roll_1, 0) * .70
                                + NVL (ev_roll_2, 0) * .20
                                + NVL (ev_roll_3, 0) * .10)
                       ELSE
                          0
                    END)
               en_cnt_plan
     FROM      gk_auto_sched_pm_v p
            LEFT OUTER JOIN
               gk_course_pm_fill_rate_v fr
            ON p.country = fr.ops_country AND p.course_id = fr.course_id
 GROUP BY   p.country,
            p.course_ch,
            p.course_mod,
            p.course_pl,
            p.course_type,
            p.root_code,
            p.course_id,
            p.course_code,
            p.short_name);

COMMENT ON MATERIALIZED VIEW GKDW.GK_PM_COURSE_PLAN_MV IS 'snapshot table for snapshot GKDW.GK_PM_COURSE_PLAN_MV';

GRANT SELECT ON GKDW.GK_PM_COURSE_PLAN_MV TO DWHREAD;

