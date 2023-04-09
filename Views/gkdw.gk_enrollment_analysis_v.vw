DROP VIEW GKDW.GK_ENROLLMENT_ANALYSIS_V;

/* Formatted on 29/01/2021 11:37:46 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ENROLLMENT_ANALYSIS_V
(
   DIM_YEAR,
   DIM_MONTH_NUM,
   DIM_PERIOD_NAME,
   DIM_WEEK_NUM,
   OPS_COUNTRY,
   METRO,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   SHORT_NAME,
   COURSE_TYPE,
   ENROLL_ID,
   BOOK_DATE,
   CANC_DATE,
   START_DATE,
   BOOK_AMT,
   ENROLL_STATUS,
   CANCEL_REASON,
   ENROLL_CNT,
   REENROLLMENT_CNT,
   REENROLLED_CNT,
   ENROLL_DAYS_OUT,
   CANC_DAYS_OUT,
   ENROLL_TYPE
)
AS
   SELECT   td.dim_year,
            td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0')
               dim_month_num,
            td.dim_period_name,
            td.dim_year || '-' || LPAD (td.dim_week, 2, '0') dim_week_num,
            ed.ops_country,
            ed.facility_region_metro metro,
            cd.course_ch,
            cd.course_mod,
            cd.course_pl,
            cd.course_code || '(' || cd.short_name || ')' short_name,
            cd.course_type,
            f.enroll_id,
            f.book_date,
            NULL canc_date,
            ed.start_date,
            f.book_amt,
            f.enroll_status,
            ed.cancel_reason,
            1 enroll_cnt,
            CASE WHEN f.orig_enroll_id IS NOT NULL THEN 1 ELSE 0 END
               reenrollment_cnt,
            CASE WHEN f.transfer_enroll_id IS NOT NULL THEN 1 ELSE 0 END
               reenrolled_cnt,
            ed.start_date - f.book_date + 1 enroll_days_out,
            0 canc_days_out,
            CASE
               WHEN f.orig_enroll_id IS NOT NULL THEN 'Re-Enrollment'
               ELSE 'Orig Enrollment'
            END
               enroll_type
     FROM            order_fact f
                  INNER JOIN
                     event_dim ed
                  ON f.event_id = ed.event_id
               INNER JOIN
                  time_dim td
               ON ed.start_date = td.dim_date
            INNER JOIN
               course_dim cd
            ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
    WHERE       td.dim_year >= 2009
            AND cd.ch_num = '10'
            AND cd.md_num IN ('10', '20')
            AND f.enroll_status != 'Cancelled'
            AND f.book_amt <> 0
            AND f.book_date IS NOT NULL
            AND f.gkdw_source = 'SLXDW'
   UNION
     SELECT   dim_year,
              dim_month_num,
              dim_period_name,
              dim_week_num,
              ops_country,
              metro,
              course_ch,
              course_mod,
              course_pl,
              short_name,
              course_type,
              enroll_id,
              MIN (book_date) book_date,
              MIN (canc_date) canc_date,
              start_date,
              SUM (book_amt) book_amt,
              enroll_status,
              cancel_reason,
              1 enroll_cnt,
              SUM (reenrolled_cnt) reenrollment_cnt,
              SUM (reenroll_cnt) reenrolled_cnt,
              SUM (enroll_days_out) enroll_days_out,
              SUM (canc_days_out) canc_days_out,
              CASE
                 WHEN SUM (reenrolled_cnt) <> 0 THEN 'Re-Enrollment'
                 ELSE 'Orig Enrollment'
              END
                 enroll_type
       FROM   (SELECT   td.dim_year,
                        td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0')
                           dim_month_num,
                        td.dim_period_name,
                        td.dim_year || '-' || LPAD (td.dim_week, 2, '0')
                           dim_week_num,
                        ed.ops_country,
                        ed.facility_region_metro metro,
                        cd.course_ch,
                        cd.course_mod,
                        cd.course_pl,
                        cd.course_code || '(' || cd.short_name || ')'
                           short_name,
                        cd.course_type,
                        f.enroll_id,
                        CASE WHEN f.book_amt > 0 THEN f.book_date END book_date,
                        CASE WHEN f.book_amt < 0 THEN f.book_date END canc_date,
                        ed.start_date,
                        f.book_amt book_amt,
                        f.enroll_status,
                        ed.cancel_reason,
                        CASE
                           WHEN f.orig_enroll_id IS NOT NULL THEN 1
                           ELSE 0
                        END
                           reenrolled_cnt,
                        CASE
                           WHEN f.transfer_enroll_id IS NOT NULL THEN 1
                           ELSE 0
                        END
                           reenroll_cnt,
                        NVL (
                             ed.start_date
                           - CASE WHEN f.book_amt > 0 THEN f.book_date END
                           + 1,
                           0
                        )
                           enroll_days_out,
                        NVL (
                             ed.start_date
                           - CASE WHEN f.book_amt < 0 THEN f.book_date END
                           + 1,
                           0
                        )
                           canc_days_out
                 FROM            order_fact f
                              INNER JOIN
                                 event_dim ed
                              ON f.event_id = ed.event_id
                           INNER JOIN
                              time_dim td
                           ON ed.start_date = td.dim_date
                        INNER JOIN
                           course_dim cd
                        ON ed.course_id = cd.course_id
                           AND ed.ops_country = cd.country
                WHERE       td.dim_year >= 2009
                        AND cd.ch_num = '10'
                        AND cd.md_num IN ('10', '20')
                        AND f.enroll_status = 'Cancelled'
                        AND f.book_amt <> 0
                        AND f.book_date IS NOT NULL
                        AND f.gkdw_source = 'SLXDW')
   GROUP BY   dim_year,
              dim_month_num,
              dim_period_name,
              dim_week_num,
              ops_country,
              metro,
              course_ch,
              course_mod,
              course_pl,
              short_name,
              course_type,
              enroll_id,
              start_date,
              enroll_status,
              cancel_reason
   ORDER BY   enroll_id;


