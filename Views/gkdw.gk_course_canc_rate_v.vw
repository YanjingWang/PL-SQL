DROP VIEW GKDW.GK_COURSE_CANC_RATE_V;

/* Formatted on 29/01/2021 11:40:14 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_CANC_RATE_V
(
   OPS_COUNTRY,
   COURSE_CODE,
   SCHED_CNT,
   CANC_CNT,
   CANC_PCT
)
AS
     SELECT   ed.ops_country,
              cd.course_code,
              COUNT (ed.event_id) sched_cnt,
              SUM (CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END)
                 canc_cnt,
              SUM (CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END)
              / COUNT (ed.event_id)
                 canc_pct
       FROM      event_dim ed
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   start_date BETWEEN TRUNC (SYSDATE) - 365 AND TRUNC (SYSDATE)
   GROUP BY   ed.ops_country, cd.course_code;


