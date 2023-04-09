DROP VIEW GKDW.GK_GTR_DAILY_PULL_V;

/* Formatted on 29/01/2021 11:35:17 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GTR_DAILY_PULL_V
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
   GTR_CREATE_DATE,
   GTR_LEVEL
)
AS
   SELECT   ug.ops_country,
            ug.start_week,
            ug.start_date,
            ug.event_id,
            ug.metro,
            ug.facility_code,
            ug.course_code,
            ug.course_ch,
            ug.course_mod,
            ug.course_pl,
            ug.course_type,
            ug.inst_type,
            ug.inst_name,
            ug.revenue,
            ug.total_cost,
            ug.enroll_cnt,
            ug.margin,
            SYSDATE gtr_create_date,
            ug.gtr_level
     FROM      gk_us_gtr_v ug
            INNER JOIN
               event_dim ed
            ON ug.event_id = ed.event_id
    WHERE   NOT EXISTS (SELECT   1
                          FROM   gk_gtr_events e
                         WHERE   ug.event_id = e.event_id)
            AND ed.event_id NOT IN
                     ('Q6UJ9APXYIY2',
                      'Q6UJ9APXYH9H',
                      'Q6UJ9APXYH9G',
                      'Q6UJ9APXYH9E',
                      'Q6UJ9APXYH9D',
                      'Q6UJ9APXYH9B',
                      'Q6UJ9APXYH99',
                      'Q6UJ9APXYH97',
                      'Q6UJ9APXYH90',
                      'Q6UJ9APXYH8Z',
                      'Q6UJ9APXYH8X',
                      'Q6UJ9APXYH8W',
                      'Q6UJ9APXYH8U',
                      'Q6UJ9APXYHHO',
                      'Q6UJ9APXYH8P',
                      'Q6UJ9APXYH8M',
                      'Q6UJ9APXYH8K',
                      'Q6UJ9APXYH8I',
                      'Q6UJ9APXYH8H',
                      'Q6UJ9APXYH8C',
                      'Q6UJ9APXYH8B',
                      'Q6UJ9APXYK7D',
                      'Q6UJ9APXYK7C')
   UNION
   SELECT   ed1.ops_country,
            g.start_week,
            ed1.start_date,
            ed1.event_id,
            g.metro,
            g.facility_code,
            g.course_code,
            g.course_ch,
            g.course_mod,
            g.course_pl,
            g.course_type,
            g.inst_type,
            g.inst_name,
            g.revenue,
            g.total_cost,
            g.enroll_cnt,
            g.margin,
            SYSDATE,
            g.gtr_level
     FROM      gk_us_gtr_v g
            INNER JOIN
               event_dim ed1
            ON     g.course_code = ed1.course_code
               AND g.start_date = ed1.start_date
               AND g.metro = ed1.facility_region_metro
               AND ed1.ops_country = 'CANADA'
    WHERE   NOT EXISTS (SELECT   1
                          FROM   gk_gtr_events e
                         WHERE   ed1.event_id = e.event_id)
   --union
   --select ed2.ops_country,td.dim_year||'-'||lpad(td.dim_week,2,0) start_week,ed2.start_date,ed2.event_id,ed2.facility_region_metro,ed2.facility_code,ed2.course_code,
   --       cd.course_ch,cd.course_mod,cd.course_pl,cd.course_type,null,null,book_amt,null,enroll_cnt,null,sysdate
   --  from event_dim ed2
   --       inner join course_dim cd on ed2.course_id = cd.course_id and ed2.ops_country = cd.country
   --       inner join gk_us_gtr_phase_3 p on ed2.event_id = p.event_id
   --       inner join time_dim td on ed2.start_date = td.dim_date
   -- where not exists (select 1 from gk_us_gtr_v ug where ed2.event_id = ug.event_id)
   --   and not exists (select 1 from gk_gtr_events e where ed2.event_id = e.event_id)
   ORDER BY   3, 7;


