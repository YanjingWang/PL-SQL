DROP VIEW GKDW.GK_GO_NOGO_LIVE_V;

/* Formatted on 29/01/2021 11:35:44 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GO_NOGO_LIVE_V
(
   START_WEEK,
   OPS_COUNTRY,
   START_DATE,
   EVENT_ID,
   FACILITY_REGION_METRO,
   FACILITY_CODE,
   COURSE_CODE,
   SHORT_NAME,
   COURSE_MOD,
   COURSE_PL,
   ENROLL_CNT,
   ENROLL_AMT,
   GO_NOGO_CNT,
   GO_NOGO_REV
)
AS
     SELECT   td.dim_year || '-' || LPAD (td.dim_week, 2, '0') start_week,
              ed.ops_country,
              ed.start_date,
              ed.event_id,
              ed.facility_region_metro,
              ed.facility_code,
              cd.course_code,
              cd.short_name,
              cd.course_mod,
              cd.course_pl,
              ec.enroll_cnt,
              ec.enroll_amt,
              l.enroll_cnt go_nogo_cnt,
              l.rev_amt go_nogo_rev
       FROM   gk_event_enroll_cnt_v@slx ec,
                       event_dim ed
                    INNER JOIN
                       time_dim td
                    ON ed.start_date = td.dim_date
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              INNER JOIN
                 gk_go_nogo l
              ON ed.event_id = l.event_id
      WHERE       ec.event_id = ed.event_id
              AND ec.enroll_cnt <> l.enroll_cnt
              AND cd.ch_num = '10'
   ORDER BY   1, ed.start_date;


