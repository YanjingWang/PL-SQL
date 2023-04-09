DROP MATERIALIZED VIEW GKDW.GK_INSTRUCTOR_INFO_V;
CREATE MATERIALIZED VIEW GKDW.GK_INSTRUCTOR_INFO_V 
TABLESPACE GDWMED
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:24:37 (QP5 v5.115.810.9015) */
SELECT   ri.rms_instructor_id,
         ri.slx_contact_id,
         ri.prospect_instructor,
         ri.allowed_to_teach,
         ri.travel_notes,
         ri.instr_country,
         c.firstname,
         c.lastname,
         c.workphone,
         c.mobile,
         c.email,
         a1.address1 inst_address1,
         a1.city inst_city,
         a1.state inst_state,
         a1.postalcode inst_postalcode,
         a1.county inst_county,
         a1.country inst_country,
         ac.accountid,
         ac.account,
         ac.mainphone,
         a2.address1,
         a2.city,
         a2.state,
         a2.postalcode,
         a2.county,
         a2.country,
         CV.course_code coursecode,
         CV.short_name,
         ic.status,
         CV.event_modality,
         CV.event_prod_line,
         CV.min_event_date,
         CV.course_cnt
  FROM                     gk_instructor_course_v CV
                        INNER JOIN
                           rmsdw.rms_instructor ri
                        ON CV.contactid = ri.slx_contact_id
                     INNER JOIN
                        slxdw.contact c
                     ON ri.slx_contact_id = c.contactid
                  INNER JOIN
                     slxdw.address a1
                  ON c.addressid = a1.addressid
               INNER JOIN
                  slxdw.account ac
               ON c.accountid = ac.accountid
            INNER JOIN
               slxdw.address a2
            ON ac.addressid = a2.addressid
         LEFT OUTER JOIN
            rmsdw.rms_instructor_cert ic
         ON     ri.rms_instructor_id = ic.rms_instructor_id
            AND CV.course_code = ic.coursecode
            AND CV.event_modality = ic.modality_group
 WHERE   ri.status = 'yes'
UNION ALL
SELECT   ri.rms_instructor_id,
         ri.slx_contact_id,
         ri.prospect_instructor,
         ri.allowed_to_teach,
         ri.travel_notes,
         ri.instr_country,
         c.firstname,
         c.lastname,
         c.workphone,
         c.mobile,
         c.email,
         a1.address1,
         a1.city,
         a1.state,
         a1.postalcode,
         a1.county,
         a1.country,
         ac.accountid,
         ac.account,
         ac.mainphone,
         a2.address1,
         a2.city,
         a2.state,
         a2.postalcode,
         a2.county,
         a2.country,
         ic.coursecode,
         pd.product_code,
         ic.status,
         ic.modality_group,
         pd.event_prod_line,
         NULL,
         0
  FROM                     rmsdw.rms_instructor ri
                        INNER JOIN
                           slxdw.contact c
                        ON ri.slx_contact_id = c.contactid
                     INNER JOIN
                        slxdw.address a1
                     ON c.addressid = a1.addressid
                  INNER JOIN
                     slxdw.account ac
                  ON c.accountid = ac.accountid
               INNER JOIN
                  slxdw.address a2
               ON ac.addressid = a2.addressid
            RIGHT OUTER JOIN
               rmsdw.rms_instructor_cert ic
            ON ri.rms_instructor_id = ic.rms_instructor_id
         RIGHT OUTER JOIN
            gk_product_desc_v pd
         ON ic.coursecode = pd.us_code
 WHERE   ri.status = 'yes'
         AND NOT EXISTS
               (SELECT   1
                  FROM   gk_instructor_course_v CV
                 WHERE       CV.contactid = c.contactid
                         AND CV.course_code = ic.coursecode
                         AND CV.event_modality = ic.modality_group);

COMMENT ON MATERIALIZED VIEW GKDW.GK_INSTRUCTOR_INFO_V IS 'snapshot table for snapshot GKDW.GK_INSTRUCTOR_INFO_V';

GRANT SELECT ON GKDW.GK_INSTRUCTOR_INFO_V TO DWHREAD;

