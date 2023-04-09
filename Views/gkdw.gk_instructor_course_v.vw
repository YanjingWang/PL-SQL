DROP VIEW GKDW.GK_INSTRUCTOR_COURSE_V;

/* Formatted on 29/01/2021 11:34:35 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INSTRUCTOR_COURSE_V
(
   OPS_COUNTRY,
   CONTACTID,
   COURSE_ID,
   COURSE_CODE,
   EVENT_MODALITY,
   SHORT_NAME,
   EVENT_PROD_LINE,
   COURSE_CNT,
   CONNECTED_CNT,
   MIN_EVENT_DATE
)
AS
     SELECT   ed.ops_country,
              ie.contactid,
              ed.course_id,
              ed.course_code,
              ed.event_modality,
              cd.short_name,
              ed.event_prod_line,
              COUNT ( * ) course_cnt,
              SUM (CASE WHEN ed.connected_c = 'Y' THEN 1 ELSE 0 END)
                 connected_cnt,
              MIN (ed.start_date) min_event_date
       FROM         instructor_event_v ie
                 INNER JOIN
                    event_dim ed
                 ON ie.evxeventid = ed.event_id
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   ed.status != 'Cancelled' AND SUBSTR (ie.feecode, 1, 3) = 'INS'
   GROUP BY   ed.ops_country,
              ie.contactid,
              ed.course_id,
              ed.course_code,
              ed.event_prod_line,
              ed.event_modality,
              cd.short_name
   ORDER BY   ie.contactid;


