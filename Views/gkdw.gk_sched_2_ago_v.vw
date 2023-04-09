DROP VIEW GKDW.GK_SCHED_2_AGO_V;

/* Formatted on 29/01/2021 11:26:59 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SCHED_2_AGO_V
(
   DIM_YEAR,
   COUNTRY,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   COURSE_TYPE,
   ROOT_CODE,
   COURSE_ID,
   COURSE_CODE,
   SHORT_NAME,
   DURATION_DAYS,
   SCHED_CNT,
   EV_CNT,
   EN_CNT,
   BOOK_AMT
)
AS
     SELECT   TO_CHAR (SYSDATE, 'YYYY') - 2 dim_year,
              country,
              course_ch,
              course_mod,
              course_pl,
              course_type,
              root_code,
              course_id,
              course_code,
              short_name,
              duration_days,
              SUM (sched_cnt) sched_cnt,
              SUM (ev_cnt) ev_cnt,
              SUM (en_cnt) en_cnt,
              SUM (book_amt) book_amt
       FROM   (  SELECT   cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days,
                          0 sched_cnt,
                          COUNT (DISTINCT ed.event_id) ev_cnt,
                          COUNT (f.enroll_id) en_cnt,
                          SUM (NVL (u.book_amt, f.book_amt)) book_amt
                   FROM               course_dim cd
                                   INNER JOIN
                                      event_dim ed
                                   ON cd.course_id = ed.course_id
                                      AND cd.country = ed.ops_country
                                INNER JOIN
                                   time_dim td
                                ON ed.start_date = td.dim_date
                             INNER JOIN
                                order_fact f
                             ON ed.event_id = f.event_id
                          LEFT OUTER JOIN
                             gk_unlimited_avg_book_v u
                          ON f.cust_id = u.cust_id
                  WHERE       td.dim_year = TO_CHAR (SYSDATE, 'YYYY') - 2
                          AND ch_num = '10'
                          AND md_num IN ('10', '20')
                          AND ed.status IN ('Verified', 'Open')
                          AND f.enroll_status != 'Cancelled'
                          AND (f.book_amt > 0 OR f.attendee_type = 'Unlimited')
               GROUP BY   cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days
               UNION ALL
                 SELECT   cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days,
                          COUNT ( * ) sched_cnt,
                          0 ev_cnt,
                          0 en_cnt,
                          0 book_amt
                   FROM         course_dim cd
                             INNER JOIN
                                event_dim ed
                             ON cd.course_id = ed.course_id
                                AND cd.country = ed.ops_country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                  WHERE       td.dim_year = TO_CHAR (SYSDATE, 'YYYY') - 2
                          AND ch_num = '10'
                          AND md_num IN ('10', '20')
               GROUP BY   cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days)
   GROUP BY   TO_CHAR (SYSDATE, 'YYYY') - 2,
              country,
              course_ch,
              course_mod,
              course_pl,
              course_type,
              root_code,
              course_id,
              course_code,
              short_name,
              duration_days;


