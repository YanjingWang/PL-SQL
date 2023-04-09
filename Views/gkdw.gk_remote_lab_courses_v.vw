DROP VIEW GKDW.GK_REMOTE_LAB_COURSES_V;

/* Formatted on 29/01/2021 11:28:05 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_REMOTE_LAB_COURSES_V
(
   COURSE_ID,
   RMS_PRODUCT_ID,
   RMS_MODE_ID,
   LAB_TYPE,
   BANDWIDTH,
   INTERNET_TYPE,
   REMOTE_LAB_PROVIDER,
   SPECIAL_SETUP
)
AS
   SELECT   pmm."slx_id" course_id,
            pmm."product" rms_product_id,
            pmm."product_line_mode" rms_mode_id,
            pml."lab_request" lab_type,
            pmc."bandwidth" bandwidth,
            pmc."internet_type" internet_type,
            'REMOTE LAB' remote_lab_provider,
            pmc."special_setup" special_setup
     FROM            "product_modality_mode"@rms_prod pmm
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
    --     inner join "room_req_additional_fields"@rms_prod rr on pmm."product" = rr."product" and pmm."product_line_mode" = rr."mode_id"
    WHERE   pml."lab_request" = 'remote lab';


