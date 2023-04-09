DROP MATERIALIZED VIEW GKDW.GK_CBSA_EVENT_MV;
CREATE MATERIALIZED VIEW GKDW.GK_CBSA_EVENT_MV 
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:26:25 (QP5 v5.115.810.9015) */
  SELECT   2006 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt cbsa_name,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           COUNT (ed.event_id) sched_cnt,
           SUM (CASE WHEN ed.status = 'Verified' THEN 1 ELSE 0 END) run_cnt
    FROM         gk_cbsa_mv c
              INNER JOIN
                 event_dim ed
              ON c.zipcode = SUBSTR (ed.zipcode, 1, 5)
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   ed.start_date BETWEEN '01-JAN-2006' AND '31-DEC-2006'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type
UNION ALL
  SELECT   2007 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           COUNT (ed.event_id) sched_cnt,
           SUM (CASE WHEN ed.status = 'Verified' THEN 1 ELSE 0 END) run_cnt
    FROM         gk_cbsa_mv c
              INNER JOIN
                 event_dim ed
              ON c.zipcode = SUBSTR (ed.zipcode, 1, 5)
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   ed.start_date BETWEEN '01-JAN-2007' AND '31-DEC-2007'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type
UNION ALL
  SELECT   2008 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           COUNT (ed.event_id) sched_cnt,
           SUM (CASE WHEN ed.status = 'Verified' THEN 1 ELSE 0 END) run_cnt
    FROM         gk_cbsa_mv c
              INNER JOIN
                 event_dim ed
              ON c.zipcode = SUBSTR (ed.zipcode, 1, 5)
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   ed.start_date BETWEEN '01-JAN-2008' AND '31-DEC-2008'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type
UNION ALL
  SELECT   2009 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           COUNT (ed.event_id) sched_cnt,
           SUM (CASE WHEN ed.status = 'Verified' THEN 1 ELSE 0 END) run_cnt
    FROM         gk_cbsa_mv c
              INNER JOIN
                 event_dim ed
              ON c.zipcode = SUBSTR (ed.zipcode, 1, 5)
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   ed.start_date BETWEEN '01-JAN-2009' AND '31-DEC-2009'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type
UNION ALL
  SELECT   2010 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           COUNT (ed.event_id) sched_cnt,
           SUM (CASE WHEN ed.status = 'Verified' THEN 1 ELSE 0 END) run_cnt
    FROM         gk_cbsa_mv c
              INNER JOIN
                 event_dim ed
              ON c.zipcode = SUBSTR (ed.zipcode, 1, 5)
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   ed.start_date BETWEEN '01-JAN-2010' AND '31-DEC-2010'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type
UNION ALL
  SELECT   2011 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           COUNT (ed.event_id) sched_cnt,
           SUM (CASE WHEN ed.status = 'Verified' THEN 1 ELSE 0 END) run_cnt
    FROM         gk_cbsa_mv c
              INNER JOIN
                 event_dim ed
              ON c.zipcode = SUBSTR (ed.zipcode, 1, 5)
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   ed.start_date BETWEEN '01-JAN-2011' AND '31-DEC-2011'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type;

COMMENT ON MATERIALIZED VIEW GKDW.GK_CBSA_EVENT_MV IS 'snapshot table for snapshot GKDW.GK_CBSA_EVENT_MV';

GRANT SELECT ON GKDW.GK_CBSA_EVENT_MV TO DWHREAD;

