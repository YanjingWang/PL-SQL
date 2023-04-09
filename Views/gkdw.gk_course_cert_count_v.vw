DROP VIEW GKDW.GK_COURSE_CERT_COUNT_V;

/* Formatted on 29/01/2021 11:40:05 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_CERT_COUNT_V
(
   COUNTRY,
   COURSE_CODE,
   COURSE_ID,
   CERT_CNT
)
AS
     SELECT   cd.country,
              cd.course_code,
              cd.course_id,
              COUNT (DISTINCT ri.slx_contact_id) cert_cnt
       FROM         rmsdw.rms_instructor ri
                 INNER JOIN
                    rmsdw.rms_instructor_cert ic
                 ON ri.rms_instructor_id = ic.rms_instructor_id
              INNER JOIN
                 course_dim cd
              ON     ic.coursecode = SUBSTR (cd.course_code, 1, 4)
                 AND ic.modality_group = cd.course_mod
                 AND ri.instr_country = SUBSTR (cd.country, 1, 2)
                 AND cd.ch_num IN ('10', '20')
      WHERE   ri.status = 'yes' AND ic.status = 'certready'
   GROUP BY   cd.country, cd.course_code, cd.course_id
   ORDER BY   4 ASC;


