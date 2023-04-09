DROP VIEW GKDW.GK_EXT_VIRTUAL_WEB_V;

/* Formatted on 29/01/2021 11:36:33 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EXT_VIRTUAL_WEB_V
(
   EVENT_ID,
   INSTRUCTOR_ID,
   INSTRUCTOR_NAME,
   COURSE_CODE,
   DELIVERY_METHOD,
   CLASS_START_TIME,
   CLASS_END_TIME,
   CLASS_DAY1,
   CLASS_DAY2,
   CLASS_DAY3,
   CLASS_DAY4,
   CLASS_DAY5,
   CLASS_DAY6,
   CLASS_DAY7,
   CLASS_DAY8,
   OFFICE_START_TIME,
   OFFICE_END_TIME,
   OFFICE_DAY1,
   OFFICE_DAY2,
   OFFICE_DAY3,
   OFFICE_DAY4
)
AS
     SELECT   s1.event_id,
              s1.instructor_id,
              s1.instructor_name,
              s1.course_code,
              'Virtual Classroom' delivery_method,
              s1.start_time class_start_time,
              s1.end_time class_end_time,
              s1.day1 class_day1,
              s1.day2 class_day2,
              s1.day3 class_day3,
              s1.day4 class_day4,
              s1.day5 class_day5,
              s1.day6 class_day6,
              s1.day7 class_day7,
              s1.day8 class_day8,
              CASE WHEN ed2.status = 'Open' THEN s2.start_time ELSE NULL END
                 office_start_time,
              CASE WHEN ed2.status = 'Open' THEN s2.end_time ELSE NULL END
                 office_end_time,
              CASE WHEN ed2.status = 'Open' THEN s2.day1 ELSE NULL END
                 office_day1,
              CASE WHEN ed2.status = 'Open' THEN s2.day2 ELSE NULL END
                 office_day2,
              CASE WHEN ed2.status = 'Open' THEN s2.day3 ELSE NULL END
                 office_day3,
              CASE WHEN ed2.status = 'Open' THEN s2.day4 ELSE NULL END
                 office_day4
       FROM            gk_ext_virtual_schedule s1
                    INNER JOIN
                       event_dim ed1
                    ON s1.event_id = ed1.event_id AND ed1.status = 'Open'
                 LEFT OUTER JOIN
                    gk_ext_virtual_schedule s2
                 ON s1.instructor_id = s2.instructor_id
                    AND TO_CHAR (s1.day1, 'yyyy-iw') =
                          TO_CHAR (s2.day1, 'yyyy-iw')
                    AND TO_CHAR (s1.lastday, 'yyyy-iw') =
                          TO_CHAR (s2.lastday, 'yyyy-iw')
                    AND s2.office_hour_flag = 'Y'
              LEFT OUTER JOIN
                 event_dim ed2
              ON s2.event_id = ed2.event_id
      WHERE   s1.office_hour_flag = 'N'
   ORDER BY   class_day1, instructor_id, course_code;


