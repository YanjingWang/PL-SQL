DROP VIEW GKDW.GK_IBM_EMEA_PORTAL_LOAD_V;

/* Formatted on 29/01/2021 11:34:51 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_IBM_EMEA_PORTAL_LOAD_V
(
   EVENT_SCHEDULE_ID,
   COURSE_CODE,
   EVENT_ID,
   COURSE_NAME,
   IBM_COURSE_CODE,
   IBM_WW_COURSE_CODE,
   START_DATE,
   END_DATE,
   START_TIME,
   END_TIME,
   TIMEZONE,
   CITY,
   STATE_ID,
   COUNTRY_ID,
   COURSE_URL,
   CLASS_LANGUAGE,
   DELIVERY_METHOD,
   EVENT_TYPE,
   PARTNER_ID,
   ACTIVE,
   STATUS,
   STUDENT_CNT,
   REGION_ID
)
AS
     SELECT   s.classnum || '_' || s.isoctry event_schedule_id,
              s.coursecode course_code,
              s.classnum event_id,
              tx.title course_name,
              tx.coursecode ibm_course_code,
              tx.coursecode ibm_ww_course_code,
              TO_DATE (s.classstartdate, 'yyyy-mm-dd') start_date,
              TO_DATE (s.classenddate, 'yyyy-mm-dd') end_date,
              TO_CHAR (TO_DATE (s.classstarttime, 'hh24:mi'), 'hh:mi:ss AM')
                 start_time,
              TO_CHAR (TO_DATE (s.classendtime, 'hh24:mi'), 'hh:mi:ss AM')
                 end_time,
              s.timezone,
              INITCAP (s.city) city,
              INITCAP (s.state) state_id,
              c.country_id,
              s.courseurl course_url,
              INITCAP (s.classlanguage) class_language,
              s.modality delivery_method,
              INITCAP (s.eventtype) event_type,
              'PAR2014051211052205932780' partner_id,
              'T' active,
              CASE
                 WHEN status = 1 THEN 'Open'
                 WHEN status = 2 THEN 'Update'
                 WHEN status = 3 THEN 'Complete'
                 WHEN status = 4 THEN 'Cancelled'
              END
                 status,
              0 student_cnt,
              c.region_id
       FROM         gk_emea_ibm_sched_v s
                 INNER JOIN
                    ibm_tier_xml tx
                 ON s.coursecode = tx.coursecode
              INNER JOIN
                 countries@part_portals c
              ON UPPER (s.isoctry) = c.iso_code
   ORDER BY   status;


