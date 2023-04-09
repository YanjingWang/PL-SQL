DROP VIEW GKDW.GK_INST_CLASS_COUNT_V;

/* Formatted on 29/01/2021 11:34:04 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INST_CLASS_COUNT_V
(
   DIM_YEAR,
   DIM_WEEK,
   CONTACTID,
   METRO_LEVEL,
   CLASS_WEEK_CNT
)
AS
     SELECT   dim_year,
              dim_week,
              ie.contactid,
              MAX (im.metro_level) metro_level,
              1 class_week_cnt
       FROM               instructor_event_v ie
                       INNER JOIN
                          event_dim ed
                       ON ie.evxeventid = ed.event_id
                    INNER JOIN
                       time_dim td1
                    ON ed.start_date = td1.dim_date
                 LEFT OUTER JOIN
                    rmsdw.rms_instructor ri
                 ON ie.contactid = ri.slx_contact_id
              LEFT OUTER JOIN
                 rmsdw.rms_instructor_metro im
              ON ri.rms_instructor_id = im.rms_instructor_id
                 AND ed.facility_region_metro = im.metro_code
      WHERE   ie.feecode = 'INS'
   GROUP BY   dim_year, dim_week, ie.contactid;


