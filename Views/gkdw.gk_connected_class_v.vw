DROP VIEW GKDW.GK_CONNECTED_CLASS_V;

/* Formatted on 29/01/2021 11:40:42 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CONNECTED_CLASS_V
(
   COURSE_PL,
   SHORT_NAME,
   DIM_YEAR,
   DIM_WEEK,
   COURSE_CODE,
   COURSE_ID,
   FACILITY_REGION_METRO,
   OPS_COUNTRY,
   EVENT_ID,
   EVENT_DESC,
   START_DATE,
   END_DATE,
   STATUS,
   LOCATION_NAME,
   ENROLL_CNT,
   BOOK_AMT,
   CAPACITY,
   START_TIME,
   END_TIME,
   INS_NAME,
   CONNECTED_C,
   CONNECTED_V_TO_C,
   FEECODE
)
AS
     SELECT   q.course_pl,
              q.short_name,
              q.dim_year,
              q.dim_week,
              q.course_code,
              q.course_id,
              q.facility_region_metro,
              q.ops_country,
              q.event_id,
              q.event_desc,
              q.start_date,
              q.end_date,
              q.status,
              q.location_name,
              COUNT (DISTINCT f.enroll_id) enroll_cnt,
              SUM (NVL (f.book_amt, 0)) book_amt,
              q.capacity,
              q.start_time,
              q.end_time,
              ie.firstname1 || ' ' || ie.lastname1 ins_name,
              'Y' connected_c,
              NULL connected_v_to_c,
              ie.feecode1 feecode
       FROM         (  SELECT   cd.course_pl,
                                cd.short_name,
                                td.dim_year,
                                td.dim_week,
                                cd.course_code,
                                cd.course_id,
                                ed1.facility_region_metro,
                                ed1.ops_country,
                                ed1.event_id,
                                ed1.event_desc,
                                ed1.start_date,
                                ed1.end_date,
                                ed1.status,
                                ed1.location_name,
                                ed1.capacity,
                                ed1.start_time,
                                ed1.end_time
                         FROM               "connected_events"@rms_prod c
                                         INNER JOIN
                                            event_dim ed1
                                         ON c."parent_evxeventid" = ed1.event_id
                                            AND ed1.status != 'Cancelled'
                                      INNER JOIN
                                         course_dim cd
                                      ON ed1.course_id = cd.course_id
                                         AND ed1.ops_country = cd.country
                                   INNER JOIN
                                      time_dim td
                                   ON ed1.start_date = td.dim_date
                                LEFT OUTER JOIN
                                   order_fact f
                                ON ed1.event_id = f.event_id
                     GROUP BY   cd.course_pl,
                                cd.short_name,
                                td.dim_year,
                                td.dim_week,
                                cd.course_code,
                                cd.course_id,
                                ed1.facility_region_metro,
                                ed1.ops_country,
                                ed1.event_id,
                                ed1.event_desc,
                                ed1.start_date,
                                ed1.end_date,
                                ed1.status,
                                ed1.location_name,
                                ed1.capacity,
                                ed1.start_time,
                                ed1.end_time) q
                 LEFT OUTER JOIN
                    order_fact f
                 ON q.event_id = f.event_id AND f.enroll_status != 'Cancelled'
              LEFT OUTER JOIN
                 gk_all_event_instr_v ie
              ON q.event_id = ie.event_id
   GROUP BY   q.course_pl,
              q.short_name,
              q.dim_year,
              q.dim_week,
              q.course_code,
              q.course_id,
              q.facility_region_metro,
              q.ops_country,
              q.event_id,
              q.event_desc,
              q.start_date,
              q.end_date,
              q.status,
              q.location_name,
              q.capacity,
              q.start_time,
              q.end_time,
              ie.firstname1 || ' ' || ie.lastname1,
              ie.feecode1
   UNION
     SELECT   cd.course_pl,
              cd.short_name,
              td.dim_year,
              td.dim_week,
              cd.course_code,
              cd.course_id,
              ed1.facility_region_metro,
              ed1.ops_country,
              ed1.event_id,
              ed1.event_desc,
              ed1.start_date,
              ed1.end_date,
              ed1.status,
              ed1.location_name,
              COUNT (DISTINCT f.enroll_id),
              SUM (NVL (f.book_amt, 0)) book_amt,
              ed1.capacity,
              ed1.start_time,
              ed1.end_time,
              ie.firstname1 || ' ' || ie.lastname1 ins_name,
              NULL,
              c."parent_evxeventid" connected_v_to_c,
              ie.feecode1
       FROM                     "connected_events"@rms_prod c
                             INNER JOIN
                                event_dim ed
                             ON c."parent_evxeventid" = ed.event_id
                                AND ed.status != 'Cancelled'
                          INNER JOIN
                             event_dim ed1
                          ON c."child_evxeventid" = ed1.event_id
                             AND ed1.status != 'Cancelled'
                       INNER JOIN
                          course_dim cd
                       ON ed1.course_id = cd.course_id
                          AND ed1.ops_country = cd.country
                    INNER JOIN
                       time_dim td
                    ON ed1.start_date = td.dim_date
                 LEFT OUTER JOIN
                    order_fact f
                 ON ed1.event_id = f.event_id
                    AND f.enroll_status != 'Cancelled'
              LEFT OUTER JOIN
                 gk_all_event_instr_v ie
              ON ed1.event_id = ie.event_id
   GROUP BY   cd.course_pl,
              cd.short_name,
              td.dim_year,
              td.dim_week,
              cd.course_code,
              cd.course_id,
              ed1.facility_region_metro,
              ed1.ops_country,
              ed1.event_id,
              ed1.event_desc,
              ed1.start_date,
              ed1.end_date,
              ed1.status,
              ed1.location_name,
              ed1.capacity,
              ed1.start_time,
              ed1.end_time,
              ie.firstname1 || ' ' || ie.lastname1,
              c."parent_evxeventid",
              ie.feecode1
   ORDER BY   course_pl,
              short_name,
              start_date,
              course_code;


