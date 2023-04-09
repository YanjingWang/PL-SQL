DROP VIEW GKDW.GK_OPS_SESSION_V_BACKUP;

/* Formatted on 29/01/2021 11:31:06 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_OPS_SESSION_V_BACKUP
(
   EVENTCOUNTRY,
   DIM_YEAR,
   DIM_WEEK,
   EVENT_PROD_LINE,
   EVENT_MODALITY,
   EVENT_CHANNEL,
   COURSE_CODE,
   EVENT_ID,
   SHORTNAME,
   COURSE_TYPE,
   START_DATE,
   END_DATE,
   CANCEL_DATE,
   INSTRUCTOR,
   LOCATION_NAME,
   ADDRESS1,
   ADDRESS2,
   CITY,
   STATE,
   CAPACITY,
   CONFIRMEDENROLLMENT,
   WAITENROLLMENT,
   EVENT_STATUS,
   FEECODE,
   INSTRUCTOR2,
   FEECODE2,
   INSTRUCTOR3,
   FEECODE3,
   METRO_AREA,
   EVENTDESC,
   FACILITY_CODE,
   FACILITY_ID,
   START_TIME,
   END_TIME,
   TIME_ZONE,
   FAC_ZIPCODE,
   FAC_PHONE,
   FAC_CONTACT,
   INTERNAL_FACILITY
)
AS
   SELECT   DISTINCT
            qes.eventcountry,
            dim_year,
            dim_week,
            event_prod_line,
            event_modality,
            event_channel,
            course_code,
            event_id,
            ec.shortname,
            ec.coursetype,
            ed.start_date,
            end_date,
            cancel_date,
            CASE
               WHEN ed.instructor1 IS NULL THEN NULL
               ELSE c1.firstname || ' ' || c1.lastname
            END
               instructor,
            location_name,
            address1,
            address2,
            city,
            state,
            ed.capacity,
            ee.confirmedenrollment,
            waitenrollment,
            ed.status event_status,
            CASE WHEN ed.instructor1 IS NULL THEN NULL ELSE qe1.feecode END
               feecode,
            CASE
               WHEN ed.instructor2 IS NULL THEN NULL
               ELSE c2.firstname || ' ' || c2.lastname
            END
               instructor2,
            CASE WHEN ed.instructor2 IS NULL THEN NULL ELSE qe2.feecode END
               feecode2,
            CASE
               WHEN ed.instructor3 IS NULL THEN NULL
               ELSE c3.firstname || ' ' || c3.lastname
            END
               instructor3,
            CASE WHEN ed.instructor3 IS NULL THEN NULL ELSE qe3.feecode END
               feecode3,
            ed.facility_region_metro metro_area,
            ec.shortname,
            ed.facility_code,
            ed.location_id,
            --ee.starttime,
            TO_CHAR (ee.starttime, 'HH:MI:SS AM'),
            --ee.endtime,
            TO_CHAR (ee.endtime, 'HH:MI:SS AM'),
            ee.tzgenericname,
            ed.zipcode,
            ee.facilitymainphone,
            ee.facilitycontact,
            qes.internalfacility
     FROM   event_dim ed,
            slxdw.qg_event qes,
            slxdw.qg_eventinstructors qe1,
            slxdw.qg_eventinstructors qe2,
            slxdw.qg_eventinstructors qe3,
            evxcourse@slx ec,
            evxevent@slx ee,
            time_dim td,
            slxdw.contact c1,
            slxdw.contact c2,
            slxdw.contact c3
    WHERE       ed.start_date = td.dim_date
            AND ed.event_id = ee.evxeventid
            AND ee.evxcourseid = ec.evxcourseid
            AND ed.event_id = qes.evxeventid
            AND ed.instructor1 = qe1.qg_eventinstructorsid(+)
            AND qe1.contactid = c1.contactid(+)
            AND ed.instructor2 = qe2.qg_eventinstructorsid(+)
            AND qe2.contactid = c2.contactid(+)
            AND ed.instructor3 = qe3.qg_eventinstructorsid(+)
            AND qe3.contactid = c3.contactid(+);


