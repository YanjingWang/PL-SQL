DROP VIEW GKDW.GK_INSTRUCTOR_OFF_PODIUM_V;

/* Formatted on 29/01/2021 11:34:26 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INSTRUCTOR_OFF_PODIUM_V
(
   RMS_INSTRUCTOR_ID,
   INSTRUCTOR_ID,
   RMS_SCHEDULE_ID,
   INST_STATUS,
   INST_COMMENT,
   START_DATE,
   END_DATE
)
AS
     SELECT   "instructor" rms_instructor_id,
              f."slx_contact_id" instructor_id,
              "schedule" rms_schedule_id,
              vt."art" inst_status,
              v."comment" inst_comment,
              MIN ("day_value") start_date,
              MAX ("day_value") end_date
       FROM         "date_value"@rms_dev v
                 INNER JOIN
                    "date_value_type"@rms_dev vt
                 ON v."art" = vt."id"
              INNER JOIN
                 "instructor_func"@rms_dev f
              ON v."instructor" = f."id"
      --where v."art" in (2,3,4,5,6,7,8,9,10,11,13,14,15)
      WHERE   "day_value" >= '2012-01-01'
   GROUP BY   "instructor",
              f."slx_contact_id",
              "schedule",
              vt."art",
              v."comment"
   ORDER BY   1.6;


