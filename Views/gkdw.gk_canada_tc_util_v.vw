DROP VIEW GKDW.GK_CANADA_TC_UTIL_V;

/* Formatted on 29/01/2021 11:42:03 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CANADA_TC_UTIL_V
(
   DIM_YEAR,
   DIM_WEEK,
   FACILITYNAME,
   FACILITYCODE,
   ROOMNAME,
   MON_RM,
   TUE_RM,
   WED_RM,
   THU_RM,
   FRI_RM
)
AS
   SELECT   td1.dim_year,
            td1.dim_week,
            gc.facilityname,
            gc.facilitycode,
            lr."name" roomname,
            CASE
               WHEN '2' BETWEEN TO_CHAR (gc.startdate, 'd')
                            AND  TO_CHAR (gc.enddate, 'd')
               THEN
                     gc.coursecode
                  || '-'
                  || gc.shortname
                  || '('
                  || gc.evxeventid
                  || ') En: '
                  || gc.enroll_cnt
               ELSE
                  NULL
            END
               mon_rm,
            CASE
               WHEN '3' BETWEEN TO_CHAR (gc.startdate, 'd')
                            AND  TO_CHAR (gc.enddate, 'd')
               THEN
                     gc.coursecode
                  || '-'
                  || gc.shortname
                  || '('
                  || gc.evxeventid
                  || ') En: '
                  || gc.enroll_cnt
               ELSE
                  NULL
            END
               tue_rm,
            CASE
               WHEN '4' BETWEEN TO_CHAR (gc.startdate, 'd')
                            AND  TO_CHAR (gc.enddate, 'd')
               THEN
                     gc.coursecode
                  || '-'
                  || gc.shortname
                  || '('
                  || gc.evxeventid
                  || ') En: '
                  || gc.enroll_cnt
               ELSE
                  NULL
            END
               wed_rm,
            CASE
               WHEN '5' BETWEEN TO_CHAR (gc.startdate, 'd')
                            AND  TO_CHAR (gc.enddate, 'd')
               THEN
                     gc.coursecode
                  || '-'
                  || gc.shortname
                  || '('
                  || gc.evxeventid
                  || ') En: '
                  || gc.enroll_cnt
               ELSE
                  NULL
            END
               thu_rm,
            CASE
               WHEN '6' BETWEEN TO_CHAR (gc.startdate, 'd')
                            AND  TO_CHAR (gc.enddate, 'd')
               THEN
                     gc.coursecode
                  || '-'
                  || gc.shortname
                  || '('
                  || gc.evxeventid
                  || ') En: '
                  || gc.enroll_cnt
               ELSE
                  NULL
            END
               fri_rm
     FROM            gk_canada_tc_v@slx gc
                  INNER JOIN
                     time_dim td1
                  ON gc.startdate = td1.dim_date
               INNER JOIN
                  "schedule"@rms_prod s
               ON gc.evxeventid = s."slx_id"
            INNER JOIN
               "location_rooms"@rms_prod lr
            ON s."location_rooms" = lr."id"
    WHERE   gc.eventstatus = 'Open'
   UNION
   SELECT   td1.dim_year,
            td1.dim_week,
            gc.facilityname,
            gc.facilitycode,
            NULL room_name,
            CASE
               WHEN '2' BETWEEN TO_CHAR (gc.startdate, 'd')
                            AND  TO_CHAR (gc.enddate, 'd')
               THEN
                     gc.coursecode
                  || '-'
                  || gc.shortname
                  || '('
                  || gc.evxeventid
                  || ') En: '
                  || gc.enroll_cnt
               ELSE
                  NULL
            END
               mon_rm,
            CASE
               WHEN '3' BETWEEN TO_CHAR (gc.startdate, 'd')
                            AND  TO_CHAR (gc.enddate, 'd')
               THEN
                     gc.coursecode
                  || '-'
                  || gc.shortname
                  || '('
                  || gc.evxeventid
                  || ') En: '
                  || gc.enroll_cnt
               ELSE
                  NULL
            END
               tue_rm,
            CASE
               WHEN '4' BETWEEN TO_CHAR (gc.startdate, 'd')
                            AND  TO_CHAR (gc.enddate, 'd')
               THEN
                     gc.coursecode
                  || '-'
                  || gc.shortname
                  || '('
                  || gc.evxeventid
                  || ') En: '
                  || gc.enroll_cnt
               ELSE
                  NULL
            END
               wed_rm,
            CASE
               WHEN '5' BETWEEN TO_CHAR (gc.startdate, 'd')
                            AND  TO_CHAR (gc.enddate, 'd')
               THEN
                     gc.coursecode
                  || '-'
                  || gc.shortname
                  || '('
                  || gc.evxeventid
                  || ') En: '
                  || gc.enroll_cnt
               ELSE
                  NULL
            END
               thu_rm,
            CASE
               WHEN '6' BETWEEN TO_CHAR (gc.startdate, 'd')
                            AND  TO_CHAR (gc.enddate, 'd')
               THEN
                     gc.coursecode
                  || '-'
                  || gc.shortname
                  || '('
                  || gc.evxeventid
                  || ') En: '
                  || gc.enroll_cnt
               ELSE
                  NULL
            END
               fri_rm
     FROM         gk_canada_tc_v@slx gc
               INNER JOIN
                  time_dim td1
               ON gc.startdate = td1.dim_date
            INNER JOIN
               "schedule"@rms_prod s
            ON gc.evxeventid = s."slx_id"
    WHERE   s."location_rooms" IS NULL AND gc.eventstatus = 'Open'
   ORDER BY   dim_year,
              dim_week,
              facilityname,
              roomname,
              facilitycode;


