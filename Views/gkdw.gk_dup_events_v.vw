DROP VIEW GKDW.GK_DUP_EVENTS_V;

/* Formatted on 29/01/2021 11:37:55 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_DUP_EVENTS_V
(
   EVENT_ID,
   EVENT_DESC,
   LOCATION_NAME,
   START_DATE,
   COURSE_CODE,
   CREATION_DATE,
   STATUS,
   DUP_FLAG,
   ENROLL_CT,
   CANCEL_CT,
   CONTACTID1,
   CONTACTID2,
   CONTACTID3,
   NAME1,
   NAME2,
   NAME3,
   DUP_EVENT_ID,
   DUP_EVENT_DESC,
   DUP_LOCATION_NAME,
   DUP_START_DATE,
   DUP_COURSE_CODE,
   DUP_CREATION_DATE,
   DUP_STATUS,
   DUP_FLAG2,
   DUP_ENROLL_CT,
   DUP_CANCEL_CT,
   DUP_CONTACTID1,
   DUP_CONTACTID2,
   DUP_CONTACTID3,
   DUP_NAME1,
   DUP_NAME2,
   DUP_NAME3
)
AS
     SELECT   ed1.event_id,
              REPLACE (REPLACE (ed1.event_desc, CHR (13)), CHR (10)) event_desc,
              ed1.location_name,
              ed1.start_date,
              ed1.course_code,
              ed1.creation_date,
              ed1.status,
              NVL (ed1.dup_event_flag, 'F') dup_flag,
              (SELECT   COUNT ( * )
                 FROM   order_fact of1
                WHERE   of1.event_id = ed1.event_id
                        AND of1.enroll_status <> 'Cancelled')
                 enroll_ct,
              (SELECT   COUNT ( * )
                 FROM   order_fact of1
                WHERE   of1.event_id = ed1.event_id
                        AND of1.enroll_status = 'Cancelled')
                 cancel_ct,
              ei1.contactid1,
              ei1.contactid2,
              ei1.contactid3,
              ei1.firstname1 || ' ' || ei1.lastname1 name1,
              ei1.firstname2 || ' ' || ei1.lastname2 name2,
              ei1.firstname3 || ' ' || ei1.lastname3 name3,
              ed2.event_id dup_event_id,
              REPLACE (REPLACE (ed2.event_desc, CHR (13)), CHR (10))
                 dup_event_desc,
              ed2.location_name dup_location_name,
              ed2.start_date dup_start_date,
              ed2.course_code dup_course_code,
              ed2.creation_date dup_creation_date,
              ed2.status dup_status,
              NVL (ed2.dup_event_flag, 'F') dup_flag2,
              (SELECT   COUNT ( * )
                 FROM   order_fact of1
                WHERE   of1.event_id = ed2.event_id
                        AND of1.enroll_status <> 'Cancelled')
                 dup_enroll_ct,
              (SELECT   COUNT ( * )
                 FROM   order_fact of1
                WHERE   of1.event_id = ed2.event_id
                        AND of1.enroll_status = 'Cancelled')
                 dup_cancel_ct,
              ei2.contactid1 dup_contactid1,
              ei2.contactid2 dup_contactid2,
              ei2.contactid3 dup_contactid3,
              ei2.firstname1 || ' ' || ei2.lastname1 dup_name1,
              ei2.firstname2 || ' ' || ei2.lastname2 dup_name2,
              ei2.firstname3 || ' ' || ei2.lastname3 dup_name3
       FROM            event_dim ed1
                    INNER JOIN
                       event_dim ed2
                    ON ed1.course_code = ed2.course_code
                       AND UPPER (NVL (TRIM(ed1.location_name), ' ')) =
                             UPPER (NVL (TRIM (ed2.location_name), ' '))
                       AND ed1.start_date = ed2.start_date
                       AND ed1.facility_region_metro =
                             ed2.facility_region_metro
                 JOIN
                    gk_all_event_instr_v ei1
                 ON ei1.event_id = ed1.event_id
              JOIN
                 gk_all_event_instr_v ei2
              ON ei2.event_id = ed2.event_id
      WHERE       ed1.event_id < ed2.event_id
              AND ed1.event_id LIKE 'Q%'
              AND SUBSTR (ed1.course_code, 5, 1) IN ('C')
              AND ed1.ops_country = 'USA'
              AND (ed1.status != 'Cancelled' AND ed2.status != 'Cancelled')
   ORDER BY   ed1.start_date;


