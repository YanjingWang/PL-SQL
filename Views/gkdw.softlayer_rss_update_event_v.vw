DROP VIEW GKDW.SOFTLAYER_RSS_UPDATE_EVENT_V;

/* Formatted on 29/01/2021 11:22:43 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.SOFTLAYER_RSS_UPDATE_EVENT_V
(
   EVENT_ID,
   COURSE_CODE,
   COURSE_NAME,
   IBM_COURSE_CODE,
   COURSE_URL,
   START_DATE,
   END_DATE,
   CITY,
   ISOCTRY,
   STATE_ABBRV,
   MODALITY,
   DURATION_DAYS,
   CLASSTYPE,
   OFFSETFROMUTC,
   START_TIME,
   END_TIME,
   INST_NAME,
   INST_EMAIL,
   EXTERNAL_STUDENTS,
   IBM_STUDENTS,
   GTR_FLAG
)
AS
     SELECT   ed.event_id,
              cd.course_code,
              cd.course_name,
              cd.course_code ibm_course_code,
              CASE
                 WHEN SUBSTR (cd.course_code, 1, 4) = '0741'
                 THEN
                    'http://www.globalknowledge.com/training/course.asp?pageid=9<subst>=24554<subst>=584'
                 WHEN SUBSTR (cd.course_code, 1, 4) = '0748'
                 THEN
                    'http://www.globalknowledge.com/training/course.asp?pageid=9<subst>=24556<subst>=584'
                 ELSE
                    'http://www.globalknowledge.com/training/category.asp?pageid=9<subst>;catid=584'
              END
                 course_url,
              ed.start_date,
              ed.end_date,
              INITCAP (CASE
                          WHEN cd.md_num IN ('32', '44') THEN NULL
                          WHEN cd.md_num = '20' THEN 'VIRTUAL EASTERN'
                          ELSE UPPER (ed.city)
                       END)
                 city,
              UPPER (SUBSTR (ed.country, 1, 2)) ISOCtry,
              UPPER (ed.state) state_abbrv,
              CASE WHEN cd.md_num = '20' THEN 'ILO' ELSE 'CR' END modality,
              cd.duration_days,
              CASE WHEN cd.ch_num = '20' THEN 'Private' ELSE 'Public' END
                 classtype,
              TO_CHAR (et.offsetfromutc) offsetfromutc,
              ed.start_time,
              ed.end_time,
              ie.firstname1 || ' ' || ie.lastname1 inst_name,
              ie.email1 inst_email,
              SUM (CASE WHEN c1.acct_name NOT LIKE 'IBM%' THEN 1 ELSE 0 END)
                 external_students,
              SUM (CASE WHEN c1.acct_name LIKE 'IBM%' THEN 1 ELSE 0 END)
                 ibm_students,
              CASE WHEN gtr.gtr_level IS NOT NULL THEN '1' ELSE '0' END
                 gtr_flag
       FROM                              event_dim ed
                                      INNER JOIN
                                         softlayer_rss_feed_tbl rf
                                      ON ed.event_id = rf.event_id
                                   LEFT OUTER JOIN
                                      gk_state_abbrev a
                                   ON UPPER (ed.state) = a.state_abbrv
                                INNER JOIN
                                   course_dim cd
                                ON ed.course_id = cd.course_id
                                   AND ed.ops_country = cd.country
                             INNER JOIN
                                slxdw.evxevent ev
                             ON ed.event_id = ev.evxeventid
                          INNER JOIN
                             gk_all_event_instr_mv ie
                          ON ed.event_id = ie.event_id
                       LEFT OUTER JOIN
                          slxdw.evxtimezone et
                       ON ev.evxtimezoneid = et.evxtimezoneid
                    LEFT OUTER JOIN
                       order_fact f
                    ON ed.event_id = f.event_id
                       AND f.enroll_status = 'Confirmed'
                 LEFT OUTER JOIN
                    cust_dim c1
                 ON f.cust_id = c1.cust_id
              LEFT OUTER JOIN
                 gk_gtr_events gtr
              ON ed.event_id = gtr.event_id
      WHERE       cd.course_pl = 'IBM'
              AND SUBSTR (cd.course_code, 1, 4) IN ('0741', '0748')
              AND cd.country IN ('USA', 'CANADA')
              AND ed.end_date >= TRUNC (SYSDATE)
              AND ed.status = 'Open'
              AND cd.ch_num = '10'
              AND cd.mfg_course_code IS NOT NULL
   GROUP BY   ed.event_id,
              cd.course_code,
              cd.course_name,
              ed.start_date,
              ed.end_date,
              INITCAP (CASE
                          WHEN cd.md_num IN ('32', '44') THEN NULL
                          WHEN cd.md_num = '20' THEN 'VIRTUAL EASTERN'
                          ELSE UPPER (ed.city)
                       END),
              UPPER (SUBSTR (ed.country, 1, 2)),
              UPPER (ed.state),
              CASE WHEN cd.md_num = '20' THEN 'ILO' ELSE 'CR' END,
              cd.duration_days,
              CASE WHEN cd.ch_num = '20' THEN 'Private' ELSE 'Public' END,
              et.offsetfromutc,
              ed.start_time,
              ed.end_time,
              ie.firstname1,
              ie.lastname1,
              ie.email1,
              gtr.gtr_level
   MINUS
   SELECT   event_id,
            course_code,
            course_name,
            ibm_course_code,
            TO_CHAR (course_url),
            start_date,
            end_date,
            city,
            isoctry,
            state_abbrv,
            modality,
            duration_days,
            classtype,
            offsetfromutc,
            start_time,
            end_time,
            inst_name,
            inst_email,
            external_students,
            ibm_students,
            gtr_flag
     FROM   softlayer_rss_feed_tbl;


