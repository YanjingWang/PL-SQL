DROP VIEW GKDW.GK_CD_FEE_STUD_CNT_V;

/* Formatted on 29/01/2021 11:41:03 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CD_FEE_STUD_CNT_V
(
   EVENT_ID,
   NUMSTUDENTS,
   REVAMT
)
AS
     SELECT   ed.event_id,
              CASE
                 WHEN SUM(CASE
                             WHEN f.fee_type != 'Ons - Base'
                                  AND f.enroll_status IN
                                           ('Confirmed', 'Attended')
                             THEN
                                1
                             ELSE
                                0
                          END) > 0
                 THEN
                    SUM(CASE
                           WHEN f.fee_type != 'Ons - Base'
                                AND f.enroll_status IN
                                         ('Confirmed', 'Attended')
                           THEN
                              1
                           ELSE
                              0
                        END)
                 WHEN ed.onsite_attended IS NOT NULL
                 THEN
                    ed.onsite_attended
                 WHEN NVL (fc.new_numattendees, f.numstudents) IS NOT NULL
                 THEN
                    NVL (fc.new_numattendees, f.numstudents)
                 ELSE
                    ed.capacity
              END
                 numstudents,
              SUM (f.book_amt) revamt
       FROM                  event_dim ed
                          INNER JOIN
                             course_dim cd
                          ON ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                       INNER JOIN
                          order_fact f
                       ON ed.event_id = f.event_id
                    LEFT OUTER JOIN
                       slxdw.gk_onsitereq_courses oc
                    ON ed.event_id = oc.evxeventid
                 LEFT OUTER JOIN
                    slxdw.gk_onsitereq_fdc f
                 ON oc.gk_onsitereq_fdcid = f.gk_onsitereq_fdcid
              LEFT OUTER JOIN
                 gk_fdc_attendee_change_v fc
              ON f.gk_onsitereq_fdcid = fc.gk_onsitereq_fdcid
      WHERE   cd.ch_num = '20'
   GROUP BY   ed.event_id,
              ed.onsite_attended,
              NVL (fc.new_numattendees, f.numstudents),
              ed.capacity
   UNION
     SELECT   ed.event_id, COUNT ( * ) numstudents, SUM (f.book_amt) revamt
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              INNER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
      WHERE       cd.ch_num = '10'
              AND ed.status != 'Cancelled'
              AND f.enroll_status IN ('Confirmed', 'Attended')
              AND f.book_amt > 0
   GROUP BY   ed.event_id;


