DROP VIEW GKDW.GK_INSTRUCTOR_EVENT_RATES_V;

/* Formatted on 29/01/2021 11:34:31 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INSTRUCTOR_EVENT_RATES_V
(
   RET_CAT,
   INSTRUCTOR_ID,
   FIRST_NAME,
   LAST_NAME,
   ACCT_ID,
   ACCT_NAME,
   PRODUCT_LINE,
   TECH_TYPE,
   TECH_SUB_TYPE,
   DAILY_RATE,
   BOOT_CAMP_RATE,
   COURSE_CODE,
   COURSE_PL,
   COURSE_TYPE,
   COURSE_SUBTYPE,
   EVENT_ID,
   START_DATE,
   END_DATE,
   STATUS,
   CONNECTED_C,
   CONNECTED_V_TO_C,
   FEECODE,
   START_TIME,
   END_TIME
)
AS
   SELECT   0 ret_cat,
            l.instructor_id,
            UPPER (l.first_name) first_name,
            UPPER (l.last_name) last_name,
            l.acct_id,
            l.acct_name,
            UPPER (l.product_line) product_line,
            UPPER (l.tech_type) tech_type,
            UPPER (l.tech_sub_type) tech_sub_type,
            TO_NUMBER (daily_rate) daily_rate,
            TO_NUMBER (boot_camp_rate) boot_camp_rate,
            cd.course_code,
            cd.course_pl,
            UPPER (cd.course_type) course_type,
            UPPER (cd.subtech_type1) course_subtype,
            ed.event_id,
            ed.start_date,
            ed.end_date,
            ed.status,
            ed.connected_c,
            ed.connected_v_to_c,
            ie.feecode,
            ed.start_time,
            ed.end_time
     FROM            instructor_master_rates_load l
                  INNER JOIN
                     instructor_event_v ie
                  ON l.instructor_id = ie.contactid
               INNER JOIN
                  event_dim ed
               ON ie.evxeventid = ed.event_id
            INNER JOIN
               course_dim cd
            ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
    WHERE   ed.status != 'Cancelled' AND l.course_code = cd.course_code
   UNION
   SELECT   1 ret_cat,
            l.instructor_id,
            UPPER (l.first_name) first_name,
            UPPER (l.last_name) last_name,
            l.acct_id,
            l.acct_name,
            UPPER (l.product_line) product_line,
            UPPER (l.tech_type) tech_type,
            UPPER (l.tech_sub_type) tech_sub_type,
            TO_NUMBER (daily_rate) daily_rate,
            TO_NUMBER (boot_camp_rate) boot_camp_rate,
            cd.course_code,
            cd.course_pl,
            UPPER (cd.course_type) course_type,
            UPPER (cd.subtech_type1) course_subtype,
            ed.event_id,
            ed.start_date,
            ed.end_date,
            ed.status,
            ed.connected_c,
            ed.connected_v_to_c,
            ie.feecode,
            ed.start_time,
            ed.end_time
     FROM            instructor_master_rates_load l
                  INNER JOIN
                     instructor_event_v ie
                  ON l.instructor_id = ie.contactid
               INNER JOIN
                  event_dim ed
               ON ie.evxeventid = ed.event_id
            INNER JOIN
               course_dim cd
            ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
    WHERE       ed.status != 'Cancelled'
            AND UPPER (l.product_line) = UPPER (cd.course_pl)
            AND UPPER (l.tech_type) = UPPER (cd.course_type)
            AND UPPER (l.tech_sub_type) = UPPER (cd.subtech_type1)
   UNION
   SELECT   2 ret_cat,
            l.instructor_id,
            UPPER (l.first_name) first_name,
            UPPER (l.last_name) last_name,
            l.acct_id,
            l.acct_name,
            UPPER (l.product_line) product_line,
            UPPER (l.tech_type) tech_type,
            UPPER (l.tech_sub_type) tech_sub_type,
            TO_NUMBER (daily_rate) daily_rate,
            TO_NUMBER (boot_camp_rate) boot_camp_rate,
            cd.course_code,
            cd.course_pl,
            UPPER (cd.course_type) course_type,
            UPPER (cd.subtech_type1) course_subtype,
            ed.event_id,
            ed.start_date,
            ed.end_date,
            ed.status,
            ed.connected_c,
            ed.connected_v_to_c,
            ie.feecode,
            ed.start_time,
            ed.end_time
     FROM            instructor_master_rates_load l
                  INNER JOIN
                     instructor_event_v ie
                  ON l.instructor_id = ie.contactid
               INNER JOIN
                  event_dim ed
               ON ie.evxeventid = ed.event_id
            INNER JOIN
               course_dim cd
            ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
    WHERE       ed.status != 'Cancelled'
            AND UPPER (l.product_line) = UPPER (cd.course_pl)
            AND UPPER (l.tech_type) = UPPER (cd.course_type)
   UNION
   SELECT   3 ret_cat,
            l.instructor_id,
            UPPER (l.first_name) first_name,
            UPPER (l.last_name) last_name,
            l.acct_id,
            l.acct_name,
            UPPER (l.product_line) product_line,
            UPPER (l.tech_type) tech_type,
            UPPER (l.tech_sub_type) tech_sub_type,
            TO_NUMBER (daily_rate) daily_rate,
            TO_NUMBER (boot_camp_rate) boot_camp_rate,
            cd.course_code,
            cd.course_pl,
            UPPER (cd.course_type) course_type,
            UPPER (cd.subtech_type1) course_subtype,
            ed.event_id,
            ed.start_date,
            ed.end_date,
            ed.status,
            ed.connected_c,
            ed.connected_v_to_c,
            ie.feecode,
            ed.start_time,
            ed.end_time
     FROM            instructor_master_rates_load l
                  INNER JOIN
                     instructor_event_v ie
                  ON l.instructor_id = ie.contactid
               INNER JOIN
                  event_dim ed
               ON ie.evxeventid = ed.event_id
            INNER JOIN
               course_dim cd
            ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
    WHERE   ed.status != 'Cancelled'
            AND UPPER (l.product_line) = UPPER (cd.course_pl);


