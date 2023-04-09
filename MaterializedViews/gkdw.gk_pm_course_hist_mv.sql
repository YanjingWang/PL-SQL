DROP MATERIALIZED VIEW GKDW.GK_PM_COURSE_HIST_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PM_COURSE_HIST_MV 
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
/* Formatted on 29/01/2021 12:23:32 (QP5 v5.115.810.9015) */
(  SELECT   country,
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
            SUM (book_07) book_07,
            SUM (sched_2008) sched_08,
            SUM (ev_2008) ev_08,
            SUM (en_2008) en_08,
            SUM (book_08) book_08,
            SUM (sched_2009) sched_09,
            SUM (ev_2009) ev_09,
            SUM (en_2009) en_09,
            SUM (book_09) book_09,
            SUM (sched_2010) sched_10,
            SUM (ev_2010) ev_10,
            SUM (en_2010) en_10,
            SUM (book_10) book_10
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
                        SUM(CASE
                               WHEN f.attendee_type = 'Unlimited' THEN 950
                               ELSE f.book_amt
                            END)
                           book_07,
                        0 ev_2008,
                        0 en_2008,
                        0 book_08,
                        0 ev_2009,
                        0 en_2009,
                        0 book_09,
                        0 ev_2010,
                        0 en_2010,
                        0 book_10,
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
                        ON ed.event_id = f.event_id
                WHERE       td.dim_year = 2007
                        AND ch_num = '10'
                        AND md_num = '10'
                        AND ed.status IN ('Verified')
                        AND f.enroll_status = 'Attended'
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
                        COUNT (DISTINCT ed.event_id),
                        COUNT (f.enroll_id),
                        SUM(CASE
                               WHEN f.attendee_type = 'Unlimited' THEN 950
                               ELSE f.book_amt
                            END)
                           book_08,
                        0,
                        0,
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
                        ON ed.event_id = f.event_id
                WHERE       td.dim_year = 2008
                        AND ch_num = '10'
                        AND md_num = '10'
                        AND ed.status IN ('Verified')
                        AND f.enroll_status = 'Attended'
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
                        SUM(CASE
                               WHEN f.attendee_type = 'Unlimited' THEN 950
                               ELSE f.book_amt
                            END)
                           book_09,
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
                        ON ed.event_id = f.event_id
                WHERE       td.dim_year = 2009
                        AND ch_num = '10'
                        AND md_num = '10'
                        AND ed.status IN ('Verified')
                        AND f.enroll_status = 'Attended'
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
                        COUNT (DISTINCT ed.event_id),
                        COUNT (f.enroll_id),
                        SUM(CASE
                               WHEN f.attendee_type = 'Unlimited' THEN 950
                               ELSE f.book_amt
                            END)
                           book_10,
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
                        ON ed.event_id = f.event_id
                WHERE       td.dim_year = 2010
                        AND ed.start_date <= TRUNC (SYSDATE)
                        AND ch_num = '10'
                        AND md_num = '10'
                        AND ed.status IN ('Open', 'Verified')
                        AND f.enroll_status IN ('Confirmed', 'Attended')
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
                WHERE       td.dim_year = 2010
                        AND ed.start_date <= TRUNC (SYSDATE)
                        AND ch_num = '10'
                        AND md_num = '10'
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
            duration_days);

COMMENT ON MATERIALIZED VIEW GKDW.GK_PM_COURSE_HIST_MV IS 'snapshot table for snapshot GKDW.GK_PM_COURSE_HIST_MV';

GRANT SELECT ON GKDW.GK_PM_COURSE_HIST_MV TO DWHREAD;

