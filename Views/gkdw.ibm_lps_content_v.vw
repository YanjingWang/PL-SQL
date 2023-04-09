DROP VIEW GKDW.IBM_LPS_CONTENT_V;

/* Formatted on 29/01/2021 11:23:53 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.IBM_LPS_CONTENT_V
(
   COURSE_NAME,
   SHORT_TITLE,
   PRIORITY,
   STATUS,
   ASSIGNED_TO,
   ROLLOUT_DATE,
   VCEL_UPLOAD,
   COURSE_CODE
)
AS
     SELECT   course_name,
              short_title,
              priority,
              status,
              assigned_to,
              rollout_date,
              vcel_upload,
              course_code
       FROM   IBM_COURSE_SUBMITTAL c
      WHERE   c.r_id = (SELECT   MAX (c2.r_id)
                          FROM   ibm_course_submittal c2
                         WHERE   c.short_title = c2.short_title)
   ORDER BY   short_title;


