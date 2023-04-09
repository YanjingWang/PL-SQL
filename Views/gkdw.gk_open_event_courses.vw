DROP VIEW GKDW.GK_OPEN_EVENT_COURSES;

/* Formatted on 29/01/2021 11:31:20 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_OPEN_EVENT_COURSES
(
   COURSE_CODE,
   CODE,
   COUNTRY,
   COURSE_NAME,
   LIST_PRICE,
   DURATION_DAYS,
   COURSE_PL,
   COURSE_TYPE,
   COURSE_MOD
)
AS
     SELECT   DISTINCT cd.course_code,
                       SUBSTR (cd.course_code, 1, 4) code,
                       cd.country,
                       cd.course_name,
                       cd.list_price,
                       cd.duration_days,
                       cd.course_pl,
                       cd.course_TYPE,
                       cd.course_mod
       --chr(9)||'<course>'||chr(10)||
       --chr(9)||chr(9)||'<code>'||cd.course_code||'</code>'||chr(10)||
       --chr(9)||chr(9)||'<title>'||cd.course_name||'</title>'||chr(10)||
       --chr(9)||chr(9)||'<listprice>'||cd.list_price||'</listprice>'||chr(10)||
       --chr(9)||chr(9)||'<durationdays>'||cd.duration_days||'</durationdays>'||chr(10)||
       --chr(9)||'</course>'||chr(10) xml_line
       FROM      course_dim cd
              INNER JOIN
                 event_dim ed
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE       ed.start_date >= TRUNC (SYSDATE)
              AND ed.status <> 'Cancelled'
              AND cd.ch_num <> 20
   ORDER BY   cd.course_code;


