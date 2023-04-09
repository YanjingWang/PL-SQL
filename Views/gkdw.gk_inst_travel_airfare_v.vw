DROP VIEW GKDW.GK_INST_TRAVEL_AIRFARE_V;

/* Formatted on 29/01/2021 11:33:45 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INST_TRAVEL_AIRFARE_V
(
   FACILITY_REGION_METRO,
   FAC_ZIP_3,
   INST_ZIP_3,
   TOTAL_AIRFARE,
   TOTAL_FLIGHTS,
   AVG_AIRFARE
)
AS
     SELECT   ed.facility_region_metro,
              SUBSTR (ed.zipcode, 1, 3) fac_zip_3,
              SUBSTR (zipcode, 1, 3) inst_zip_3,
              SUM (air_cost) total_airfare,
              COUNT ( * ) total_flights,
              ROUND (SUM (air_cost) / COUNT ( * )) avg_airfare
       FROM            gk_inst_airfare_v@gkprod a
                    INNER JOIN
                       event_dim ed
                    ON a.evxeventid = ed.event_id
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              INNER JOIN
                 cust_dim c
              ON a.instructor_id = c.cust_id
      WHERE       cd.ch_num IN ('10')
              AND cd.md_num IN ('10', '20')
              AND air_cost > 99
              AND ed.start_date > SYSDATE - 547
   GROUP BY   ed.facility_region_metro,
              SUBSTR (ed.zipcode, 1, 3),
              SUBSTR (zipcode, 1, 3);


