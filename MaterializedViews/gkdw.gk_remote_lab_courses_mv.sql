DROP MATERIALIZED VIEW GKDW.GK_REMOTE_LAB_COURSES_MV;
CREATE MATERIALIZED VIEW GKDW.GK_REMOTE_LAB_COURSES_MV 
TABLESPACE GDWSML
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
/* Formatted on 29/01/2021 12:22:45 (QP5 v5.115.810.9015) */
SELECT   pmm."slx_id" course_id,
         pmm."product" rms_product_id,
         pmm."product_line_mode" rms_mode_id,
         pml."lab_request" lab_type,
         pmc."bandwidth" bandwidth,
         pmc."internet_type" internet_type,
         'REMOTE LAB' remote_lab_provider,
         rr."remote_lab_provider" remote_lab_vendor
  FROM               "product_modality_mode"@rms_prod pmm
                  INNER JOIN
                     "product_line_mode"@rms_prod plm
                  ON pmm."product_line_mode" = plm."id"
               INNER JOIN
                  "product_modality_category"@rms_prod pmc
               ON pmm."product" = pmc."product"
                  AND plm."category" = pmc."category"
            INNER JOIN
               "product_modality_lab_request"@rms_prod pml
            ON pmc."product" = pml."product"
               AND pmc."category" = pml."product_line_category"
         INNER JOIN
            "room_req_additional_fields"@rms_prod rr
         ON pmm."product" = rr."product"
            AND pmm."product_line_mode" = rr."mode_id"
 WHERE   pml."lab_request" = 'remote lab';

COMMENT ON MATERIALIZED VIEW GKDW.GK_REMOTE_LAB_COURSES_MV IS 'snapshot table for snapshot GKDW.GK_REMOTE_LAB_COURSES_MV';

GRANT SELECT ON GKDW.GK_REMOTE_LAB_COURSES_MV TO DWHREAD;

