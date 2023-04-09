DROP VIEW GKDW.GK_TERILLIAN_COURSES_V;

/* Formatted on 29/01/2021 11:25:36 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_TERILLIAN_COURSES_V
(
   COURSE_ID,
   LAB_TYPE
)
AS
   SELECT   pmm."slx_id" course_id, 'TERILLIAN' lab_type
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
    WHERE   pml."lab_request" = 'remote lab'
            AND pmc."special_setup" LIKE '%hosted remote labs%';


