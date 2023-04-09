DROP PROCEDURE GKDW.GK_DISCOUNT_ELIGIBLE_PDM_UPD;

CREATE OR REPLACE PROCEDURE GKDW.gk_discount_eligible_pdm_upd
AS
   CURSOR c1
   IS
      SELECT DISTINCT
             LPAD (de.course_code, 4, 0) || de.prod_modality AS course_code,
             de.discount_eligible,
             --p."us_code"||plm."mode" AS pdm_course_code,
             pm."slx_id" AS courseid,
             pm."discount_flag" AS discount_flag,
             -- pm."modality_status" AS modality_status,
             pm."changed" AS modified_date,
             --  plm."mode",
             plc."modality" AS modality 
        FROM GK_DISCOUNT_ELIGIBLE_UPD de
             INNER JOIN "product"@rms_prod p
                ON LPAD (de.course_code, 4, 0) = p."us_code"
             INNER JOIN "product_modality_mode"@rms_prod pm
                ON p."id" = pm."product"
             INNER JOIN "product_line_mode"@rms_prod plm
                ON pm."product_line_mode" = plm."id"
             INNER JOIN "product_line_category"@rms_prod plc
                ON plm."category" = plc."id"
       WHERE     p."us_code" || plm."mode" =
                    LPAD (de.course_code, 4, 0) || de.prod_modality
             AND plc."modality" IN ('10', '20')
             AND plm."mode" IN ('C', 'L');

   CURSOR c2
   IS
      SELECT distinct courseid FROM GK_DISCOUNT_ELIGIBLE_BKP;
BEGIN
   DELETE FROM GK_DISCOUNT_ELIGIBLE_BKP;

   FOR r1 IN c1
   LOOP
      INSERT INTO GK_DISCOUNT_ELIGIBLE_BKP
           VALUES (r1.course_code,
                   r1.discount_eligible,
                   r1.courseid,
                   r1.discount_flag,
                   SYSDATE,
                   r1.modality);
   END LOOP;

   COMMIT;

   FOR r2 IN c2
   LOOP
      UPDATE "product_modality_mode"@rms_prod
         SET "discount_flag" = 'Y'
       WHERE "slx_id" = r2.courseid;
   END LOOP;
   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_DISCOUNT_ELIGIBLE_PDM_UPD FAILED',SQLERRM);
END;
/


