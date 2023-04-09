DROP VIEW GKDW.GK_INST_COURSE_CERT_V;

/* Formatted on 29/01/2021 11:34:00 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INST_COURSE_CERT_V
(
   INSTRUCTOR_ID,
   COURSE_CODE,
   STATUS
)
AS
   SELECT   slx_contact_id instructor_id,
            ric.coursecode || 'C' course_code,
            ric.status
     FROM      rmsdw.rms_instructor ri
            INNER JOIN
               rmsdw.rms_instructor_cert ric
            ON ri.rms_instructor_id = ric.rms_instructor_id
    WHERE   modality_group = 'C-LEARNING'
   UNION
   SELECT   slx_contact_id instructor_id,
            ric.coursecode || 'N' course_code,
            ric.status
     FROM      rmsdw.rms_instructor ri
            INNER JOIN
               rmsdw.rms_instructor_cert ric
            ON ri.rms_instructor_id = ric.rms_instructor_id
    WHERE   modality_group = 'C-LEARNING'
   UNION
   SELECT   slx_contact_id instructor_id,
            ric.coursecode || 'L' course_code,
            ric.status
     FROM      rmsdw.rms_instructor ri
            INNER JOIN
               rmsdw.rms_instructor_cert ric
            ON ri.rms_instructor_id = ric.rms_instructor_id
    WHERE   modality_group = 'V-LEARNING'
   UNION
   SELECT   slx_contact_id instructor_id,
            ric.coursecode || 'V' course_code,
            ric.status
     FROM      rmsdw.rms_instructor ri
            INNER JOIN
               rmsdw.rms_instructor_cert ric
            ON ri.rms_instructor_id = ric.rms_instructor_id
    WHERE   modality_group = 'V-LEARNING'
   ORDER BY   1, 2;


