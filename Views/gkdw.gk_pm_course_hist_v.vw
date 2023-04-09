DROP VIEW GKDW.GK_PM_COURSE_HIST_V;

/* Formatted on 29/01/2021 11:30:32 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PM_COURSE_HIST_V
(
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
   SCHED_07,
   EV_07,
   EN_07,
   SCHED_08,
   EV_08,
   EN_08,
   SCHED_09,
   EV_09,
   EN_09,
   SCHED_10,
   EV_10,
   EN_10
)
AS
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
              SUM (sched_2007) sched_07,
              SUM (ev_2007) ev_07,
              SUM (en_2007) en_07,
              SUM (sched_2008) sched_08,
              SUM (ev_2008) ev_08,
              SUM (en_2008) en_08,
              SUM (sched_2009) sched_09,
              SUM (ev_2009) ev_09,
              SUM (en_2009) en_09,
              SUM (sched_2010) sched_10,
              SUM (ev_2010) ev_10,
              SUM (en_2010) en_10
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
                          COUNT (DISTINCT ed.event_id) ev_2007,
                          COUNT (f.enroll_id) en_2007,
                          0 ev_2008,
                          0 en_2008,
                          0 ev_2009,
                          0 en_2009,
                          0 ev_2010,
                          0 en_2010,
                          0 sched_2007,
                          0 sched_2008,
                          0 sched_2009,
                          0 sched_2010
                   FROM            course_dim cd
                                INNER JOIN
                                   event_dim ed
                                ON cd.course_id = ed.course_id
                                   AND cd.country = ed.ops_country
                             INNER JOIN
                                time_dim td
                             ON ed.start_date = td.dim_date
                          INNER JOIN
                             order_fact f
                          ON     ed.event_id = f.event_id
                             AND f.enroll_status = 'Attended'
                             AND f.book_amt > 0
                  WHERE       td.dim_year = 2007
                          AND ch_num = '10'
                          AND md_num = '10'
                          AND ed.status IN ('Verified')
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
               UNION
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
                          0,
                          0,
                          COUNT (DISTINCT ed.event_id),
                          COUNT (f.enroll_id),
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0
                   FROM            course_dim cd
                                INNER JOIN
                                   event_dim ed
                                ON cd.course_id = ed.course_id
                                   AND cd.country = ed.ops_country
                             INNER JOIN
                                time_dim td
                             ON ed.start_date = td.dim_date
                          INNER JOIN
                             order_fact f
                          ON     ed.event_id = f.event_id
                             AND f.enroll_status = 'Attended'
                             AND f.book_amt > 0
                  WHERE       td.dim_year = 2008
                          AND ch_num = '10'
                          AND md_num = '10'
                          AND ed.status IN ('Verified')
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
               UNION
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
                          0,
                          0,
                          0,
                          0,
                          COUNT (DISTINCT ed.event_id),
                          COUNT (f.enroll_id),
                          0,
                          0,
                          0,
                          0,
                          0,
                          0
                   FROM            course_dim cd
                                INNER JOIN
                                   event_dim ed
                                ON cd.course_id = ed.course_id
                                   AND cd.country = ed.ops_country
                             INNER JOIN
                                time_dim td
                             ON ed.start_date = td.dim_date
                          INNER JOIN
                             order_fact f
                          ON     ed.event_id = f.event_id
                             AND f.enroll_status = 'Attended'
                             AND f.book_amt > 0
                  WHERE       td.dim_year = 2009
                          AND ch_num = '10'
                          AND md_num = '10'
                          AND ed.status IN ('Verified')
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
               UNION
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
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          COUNT (DISTINCT ed.event_id),
                          COUNT (f.enroll_id),
                          0,
                          0,
                          0,
                          0
                   FROM            course_dim cd
                                INNER JOIN
                                   event_dim ed
                                ON cd.course_id = ed.course_id
                                   AND cd.country = ed.ops_country
                             INNER JOIN
                                time_dim td
                             ON ed.start_date = td.dim_date
                          INNER JOIN
                             order_fact f
                          ON     ed.event_id = f.event_id
                             AND f.enroll_status = 'Attended'
                             AND f.book_amt > 0
                  WHERE       td.dim_year = 2010
                          AND ch_num = '10'
                          AND md_num = '10'
                          AND ed.status IN ('Verified')
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
               UNION
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
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          COUNT (ed.event_id),
                          0,
                          0,
                          0
                   FROM         course_dim cd
                             INNER JOIN
                                event_dim ed
                             ON cd.course_id = ed.course_id
                                AND cd.country = ed.ops_country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                  WHERE   td.dim_year = 2007 AND ch_num = '10' AND md_num = '10'
                          AND (ed.status IN ('Open', 'Verified')
                               OR (ed.status = 'Cancelled'
                                   AND ed.cancel_reason = 'Low Enrollment'))
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
               UNION
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
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          COUNT (ed.event_id),
                          0,
                          0
                   FROM         course_dim cd
                             INNER JOIN
                                event_dim ed
                             ON cd.course_id = ed.course_id
                                AND cd.country = ed.ops_country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                  WHERE   td.dim_year = 2008 AND ch_num = '10' AND md_num = '10'
                          AND (ed.status IN ('Open', 'Verified')
                               OR (ed.status = 'Cancelled'
                                   AND ed.cancel_reason = 'Low Enrollment'))
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
               UNION
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
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          COUNT (ed.event_id),
                          0
                   FROM         course_dim cd
                             INNER JOIN
                                event_dim ed
                             ON cd.course_id = ed.course_id
                                AND cd.country = ed.ops_country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                  WHERE   td.dim_year = 2009 AND ch_num = '10' AND md_num = '10'
                          AND (ed.status IN ('Open', 'Verified')
                               OR (ed.status = 'Cancelled'
                                   AND ed.cancel_reason = 'Low Enrollment'))
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
               UNION
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
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          COUNT (ed.event_id)
                   FROM         course_dim cd
                             INNER JOIN
                                event_dim ed
                             ON cd.course_id = ed.course_id
                                AND cd.country = ed.ops_country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                  WHERE   td.dim_year = 2010 AND ch_num = '10' AND md_num = '10'
                          AND (ed.status IN ('Open', 'Verified')
                               OR (ed.status = 'Cancelled'
                                   AND ed.cancel_reason = 'Low Enrollment'))
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
      WHERE   SUBSTR (course_code, 5, 1) = 'C'
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


