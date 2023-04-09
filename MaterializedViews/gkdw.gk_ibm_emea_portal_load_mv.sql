DROP MATERIALIZED VIEW GKDW.GK_IBM_EMEA_PORTAL_LOAD_MV;
CREATE MATERIALIZED VIEW GKDW.GK_IBM_EMEA_PORTAL_LOAD_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:24:55 (QP5 v5.115.810.9015) */
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
         s.timezone,                                 --lpad(s.timezone,2,'0'),
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
         c.region_id,
         CASE WHEN gtr.gtr_level IS NOT NULL THEN '1' ELSE '0' END gtr_flag
  FROM            gk_emea_ibm_sched_v s
               INNER JOIN
                  ibm_tier_xml tx
               ON s.coursecode = tx.coursecode
            INNER JOIN
               countries@part_portals c
            ON UPPER (s.isoctry) = c.iso_code
         LEFT OUTER JOIN
            gk_gtr_events gtr
         ON s.classnum = gtr.event_id;

COMMENT ON MATERIALIZED VIEW GKDW.GK_IBM_EMEA_PORTAL_LOAD_MV IS 'snapshot table for snapshot GKDW.GK_IBM_EMEA_PORTAL_LOAD_MV';

GRANT SELECT ON GKDW.GK_IBM_EMEA_PORTAL_LOAD_MV TO DWHREAD;

