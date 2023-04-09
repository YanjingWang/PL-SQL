DROP VIEW GKDW.GK_PRODUCT_DESC_V;

/* Formatted on 29/01/2021 11:29:41 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PRODUCT_DESC_V
(
   US_CODE,
   PRODUCT_CODE,
   DESCRIPTION,
   EVENT_PROD_LINE
)
AS
     SELECT   p."us_code" us_code,
              p."product_code" product_code,
              p."description" description,
              cd.course_pl event_prod_line
       FROM   "product"@rms_prod p,
              "product_modality_mode"@rms_prod mm,
              gkdw.course_dim cd
      WHERE       p."id" = mm."product"
              AND mm."slx_id" = cd.course_id
              AND cd.gkdw_source = 'SLXDW'
              AND cd.course_pl IS NOT NULL
              AND cd.inactive_flag = 'F'
              AND p."active_course_master" = 'yes'
   GROUP BY   p."us_code",
              p."product_code",
              p."description",
              cd.course_pl;


