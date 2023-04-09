DROP VIEW GKDW.GK_US_GTR_V;

/* Formatted on 29/01/2021 11:24:17 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_US_GTR_V
(
   OPS_COUNTRY,
   START_WEEK,
   START_DATE,
   EVENT_ID,
   METRO,
   FACILITY_CODE,
   COURSE_CODE,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   COURSE_TYPE,
   INST_TYPE,
   INST_NAME,
   REVENUE,
   TOTAL_COST,
   ENROLL_CNT,
   MARGIN,
   GTR_LEVEL
)
AS
   SELECT   gn.ops_country,
            gn.start_week,
            gn.start_date,
            gn.event_id,
            gn.metro,
            gn.facility_code,
            gn.course_code,
            gn.course_ch,
            gn.course_mod,
            gn.course_pl,
            gn.course_type,
            gn.inst_type,
            gn.inst_name,
            gn.revenue,
            CASE
               WHEN gn.facility_cost = 0 AND f.audit_rate IS NOT NULL
               THEN
                  total_cost
                  + f.audit_rate * (ed.end_date - ed.start_date + 1)
               ELSE
                  gn.total_cost
            END
               total_cost,
            gn.enroll_cnt,
            CASE
               WHEN revenue = 0
               THEN
                  0
               WHEN gn.facility_cost = 0 AND f.audit_rate IS NOT NULL
               THEN
                  (revenue
                   - (total_cost
                      + f.audit_rate * (ed.end_date - ed.start_date + 1)))
                  / revenue
               ELSE
                  gn.margin
            END
               margin,
            CASE
               WHEN gn.start_date BETWEEN TRUNC (SYSDATE)
                                      AND  TRUNC (SYSDATE) + 14
               THEN
                  '1'
               ELSE
                  '2'
            END
               gtr_level
     FROM            gk_go_nogo_v gn
                  INNER JOIN
                     event_dim ed
                  ON gn.event_id = ed.event_id
               INNER JOIN
                  course_dim cd
               ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
            LEFT OUTER JOIN
               gk_facility_cc_dim f
            ON ed.facility_code = f.facility_code
    WHERE   (    gn.ops_country = 'USA'
             AND CASE
                   WHEN revenue = 0
                   THEN
                      0
                   WHEN gn.facility_cost = 0 AND f.audit_rate IS NOT NULL
                   THEN
                      (revenue
                       - (total_cost
                          + f.audit_rate * (ed.end_date - ed.start_date + 1)))
                      / revenue
                   ELSE
                      gn.margin
                END >= .35
             AND enroll_cnt >= 4
             AND gn.start_date >= TRUNC (SYSDATE)
             AND inst_cost > 0
             AND NVL (ed.plan_type, 'NONE') != 'Sales Request'
             AND NVL (cd.course_type, 'NONE') != 'Virtual Short Course'
             AND cd.course_pl NOT IN ('OTHER - NEST; SECURITY-EMEA', 'RSA')
             AND (   f.audit_rate IS NOT NULL
                  OR gn.facility_cost > 0
                  OR gn.metro = 'VCL'))
            OR (gn.ops_country = 'USA'
                AND gn.start_date BETWEEN TRUNC (SYSDATE)
                                      AND  TRUNC (SYSDATE) + 14
                AND cd.course_pl != 'OTHER - NEST; SECURITY-EMEA');


