DROP VIEW GKDW.GK_RUN_STATUS_UPDATE_V;

/* Formatted on 29/01/2021 11:27:28 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_RUN_STATUS_UPDATE_V
(
   EVENT_ID,
   COURSE_CODE,
   ENROLL_ID,
   ENROLL_STATUS,
   START_DATE,
   ENROLL_DATE,
   CANCEL_DATE,
   ENROLL_DAYS,
   CANCEL_DAYS
)
AS
   SELECT   f.event_id,
            ed.course_code,
            f.enroll_id,
            f.enroll_status,
            ed.start_date,
            f.book_date enroll_date,
            NULL cancel_date,
            TRUNC (ed.start_date - book_date) enroll_days,
            0 cancel_days
     FROM      order_fact f
            INNER JOIN
               event_dim ed
            ON f.event_id = ed.event_id
    WHERE   enroll_status != 'Cancelled'
            AND ed.event_id IN
                     (SELECT   event_id
                        FROM   gk_go_nogo
                       WHERE   (   run_status IS NULL
                                OR run_status_3 IS NULL
                                OR run_status_6 IS NULL
                                OR run_status_8 IS NULL
                                OR run_status_10 IS NULL)
                               AND start_date <= TRUNC (SYSDATE) + 70
                               AND nested_with IS NULL
                               AND ch_num = 10
                               AND md_num = 10)
   UNION
   SELECT   f.event_id,
            ed.course_code,
            f.enroll_id,
            f.enroll_status,
            ed.start_date,
            f.enroll_date,
            f.book_date cancel_date,
            TRUNC (ed.start_date - enroll_date) enroll_days,
            CASE
               WHEN f.bill_status = 'Cancelled'
               THEN
                  TRUNC (ed.start_date - book_date)
               ELSE
                  0
            END
               cancel_days
     FROM      order_fact f
            INNER JOIN
               event_dim ed
            ON f.event_id = ed.event_id
    WHERE   f.bill_status = 'Cancelled'
            AND ed.event_id IN
                     (SELECT   event_id
                        FROM   gk_go_nogo
                       WHERE   (   run_status IS NULL
                                OR run_status_3 IS NULL
                                OR run_status_6 IS NULL
                                OR run_status_8 IS NULL
                                OR run_status_10 IS NULL)
                               AND start_date <= TRUNC (SYSDATE) + 70
                               AND nested_with IS NULL
                               AND ch_num = 10
                               AND md_num = 10)
   ORDER BY   1, 2, 5;


