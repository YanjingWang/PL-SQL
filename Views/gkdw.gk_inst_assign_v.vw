DROP VIEW GKDW.GK_INST_ASSIGN_V;

/* Formatted on 29/01/2021 11:34:09 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INST_ASSIGN_V
(
   EVENT_ID,
   COURSE_ID,
   LOCATION_ID,
   START_DATE,
   EVENT_CITY,
   EVENT_STATE,
   EVENT_ZIPCODE,
   FACILITY_REGION_METRO,
   FACILITY_CODE,
   OPS_COUNTRY,
   COURSE_CODE,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   CH_NUM,
   MD_NUM,
   PL_NUM,
   CONTACTID1,
   FEECODE1,
   INST1,
   ACCOUNT1,
   INST1_CITY,
   INST1_STATE,
   INST1_ZIPCODE,
   TRAVEL_LEVEL1,
   CONTACTID2,
   FEECODE2,
   INST2,
   ACCOUNT2,
   INST2_CITY,
   INST2_STATE,
   INST2_ZIPCODE,
   TRAVEL_LEVEL2,
   CONTACTID3,
   FEECODE3,
   INST3,
   ACCOUNT3,
   INST3_CITY,
   INST3_STATE,
   INST3_ZIPCODE,
   TRAVEL_LEVEL3
)
AS
     SELECT   ed.event_id,
              ed.course_id,
              ed.location_id,
              ed.start_date,
              ed.city event_city,
              ed.state event_state,
              ed.zipcode event_zipcode,
              ed.facility_region_metro,
              ed.facility_code,
              ed.ops_country,
              cd.course_code,
              cd.course_ch,
              cd.course_mod,
              cd.course_pl,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              ei.contactid1,
              ei.feecode1,
              ei.firstname1 || ' ' || ei.lastname1 inst1,
              ei.account1,
              ct1.city inst1_city,
              ct1.state inst1_state,
              ct1.zipcode inst1_zipcode,
              CASE
                 WHEN rm1.metro_level IS NULL AND ei.contactid1 IS NOT NULL
                 THEN
                    'NO LEVEL'
                 WHEN rm1.metro_level = 1
                 THEN
                    'FULL LOCAL'
                 WHEN rm1.metro_level = 2
                 THEN
                    'LIMITED LOCAL'
                 WHEN rm1.metro_level = 3
                 THEN
                    'FULL TRAVEL'
              END
                 travel_level1,
              ei.contactid2,
              ei.feecode2,
              ei.firstname2 || ' ' || ei.lastname2 inst2,
              ei.account2,
              ct2.city inst2_city,
              ct2.state inst2_state,
              ct2.zipcode inst2_zipcode,
              CASE
                 WHEN rm2.metro_level IS NULL AND ei.contactid2 IS NOT NULL
                 THEN
                    'NO LEVEL'
                 WHEN rm2.metro_level = 1
                 THEN
                    'FULL LOCAL'
                 WHEN rm2.metro_level = 2
                 THEN
                    'LIMITED LOCAL'
                 WHEN rm2.metro_level = 3
                 THEN
                    'FULL TRAVEL'
              END
                 travel_level2,
              ei.contactid3,
              ei.feecode3,
              ei.firstname3 || ' ' || ei.lastname3 inst3,
              ei.account3,
              ct3.city inst3_city,
              ct3.state inst3_state,
              ct3.zipcode inst3_zipcode,
              CASE
                 WHEN rm3.metro_level IS NULL AND ei.contactid3 IS NOT NULL
                 THEN
                    'NO LEVEL'
                 WHEN rm3.metro_level = 1
                 THEN
                    'FULL LOCAL'
                 WHEN rm3.metro_level = 2
                 THEN
                    'LIMITED LOCAL'
                 WHEN rm3.metro_level = 3
                 THEN
                    'FULL TRAVEL'
              END
                 travel_level3
       FROM                                       event_dim ed
                                               INNER JOIN
                                                  course_dim cd
                                               ON ed.course_id = cd.course_id
                                                  AND ed.ops_country =
                                                        cd.country
                                            INNER JOIN
                                               time_dim td
                                            ON ed.start_date = td.dim_date
                                         INNER JOIN
                                            gk_all_event_instr_v ei
                                         ON ed.event_id = ei.event_id
                                      INNER JOIN
                                         rmsdw.rms_instructor r1
                                      ON ei.contactid1 = r1.slx_contact_id
                                   INNER JOIN
                                      cust_dim ct1
                                   ON ei.contactid1 = ct1.cust_id
                                LEFT OUTER JOIN
                                   rmsdw.rms_instructor_metro rm1
                                ON r1.rms_instructor_id = rm1.rms_instructor_id
                                   AND ed.facility_region_metro =
                                         rm1.metro_code
                             LEFT OUTER JOIN
                                rmsdw.rms_instructor r2
                             ON ei.contactid2 = r2.slx_contact_id
                          LEFT OUTER JOIN
                             cust_dim ct2
                          ON ei.contactid2 = ct2.cust_id
                       LEFT OUTER JOIN
                          rmsdw.rms_instructor_metro rm2
                       ON r2.rms_instructor_id = rm2.rms_instructor_id
                          AND ed.facility_region_metro = rm2.metro_code
                    LEFT OUTER JOIN
                       rmsdw.rms_instructor r3
                    ON ei.contactid3 = r3.slx_contact_id
                 LEFT OUTER JOIN
                    cust_dim ct3
                 ON ei.contactid3 = ct3.cust_id
              LEFT OUTER JOIN
                 rmsdw.rms_instructor_metro rm3
              ON r3.rms_instructor_id = rm3.rms_instructor_id
                 AND ed.facility_region_metro = rm3.metro_code
      WHERE       td.dim_year || '-' || LPAD (td.dim_week, 2, '0') = '2008-20'
              AND ed.status != 'Cancelled'
              AND cd.md_num = '10'
   ORDER BY   facility_region_metro, facility_code;


