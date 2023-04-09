DROP VIEW GKDW.GK_OCC_V;

/* Formatted on 29/01/2021 11:32:09 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_OCC_V
(
   OCC_YEAR,
   IT_CATEGORY,
   PRIMARY_STATE,
   AREA_NUMBER,
   AREA_NAME,
   MSA_NAME,
   REPORTING_MSA,
   OCC_CODE,
   OCC_TITLE,
   OCC_EMP_CNT
)
AS
     SELECT   o.occ_year,
              CASE
                 WHEN o.occ_code IN
                            ('15-1021', '15-1031', '15-1032', '15-1061')
                 THEN
                    'Developer'
                 WHEN o.occ_code IN
                            ('15-1041', '15-1051', '15-1071', '15-1081')
                 THEN
                    'Network'
                 WHEN o.occ_code IN ('15-1011', '15-1099', '17-2061')
                 THEN
                    'IT-Other'
                 WHEN o.occ_code IN
                            ('11-1011', '11-1021', '11-3021', '11-3042')
                 THEN
                    'Executive/Manager'
                 WHEN o.occ_code IN ('13-1073', '13-1079')
                 THEN
                    'Training'
              END
                 it_category,
              o.primary_state,
              o.area_number,
              o.area_name,
              SUBSTR (o.area_name, 1, INSTR (o.area_name, ',') - 1) msa_name,
              CASE
                 WHEN area_name =
                         'New York-White Plains-Wayne, NY-NJ Metropolitan Division'
                 THEN
                    'New York-Northern New Jersey-Long Island-NY'
                 WHEN area_name = 'Philadelphia, PA Metropolitan Division'
                 THEN
                    'Philadelphia-Camden-Wilmington-PA'
                 WHEN area_name =
                         'Miami-Miami Beach-Kendall, FL Metropolitan Division'
                 THEN
                    'Miami-Fort Lauderdale-Pompano Beach-FL'
                 WHEN area_name =
                         'Detroit-Livonia-Dearborn, MI Metropolitan Division'
                 THEN
                    'Detroit-Livonia-Dearborn-Warren-MI'
                 WHEN area_name = 'Nashville-Davidson--Murfreesboro, TN'
                 THEN
                    'Nashville-Davidson-Murfreesboro-Franklin-TN'
                 WHEN area_name =
                         'Dallas-Plano-Irving, TX Metropolitan Division'
                 THEN
                    'Dallas-Fort Worth-Arlington-TX'
                 ELSE
                    NVL (
                       c.consolidated_msa,
                       SUBSTR (o.area_name, 1, INSTR (o.area_name, ',') - 1)
                       || '-'
                       || SUBSTR (o.area_name,
                                  INSTR (o.area_name, ', ') + 2,
                                  2)
                    )
              END
                 reporting_msa,
              o.occ_code,
              o.occ_title,
              SUM (NVL (tot_emp, 0)) occ_emp_cnt
       FROM      gk_msa_occ o
              LEFT OUTER JOIN
                 gk_consolidated_msa_v c
              ON    SUBSTR (o.area_name, 1, INSTR (o.area_name, ',') - 1)
                 || '-'
                 || SUBSTR (o.area_name, INSTR (o.area_name, ', ') + 2, 2) =
                    c.msa_desc
      WHERE   occ_code IN
                    ('15-1011',
                     '15-1021',
                     '15-1031',
                     '15-1032',
                     '15-1041',
                     '15-1051',
                     '15-1061',
                     '15-1071',
                     '15-1081',
                     '15-1099',
                     '11-1011',
                     '11-1021',
                     '11-3021',
                     '11-3042',
                     '13-073',
                     '13-1079',
                     '17-2061')
              AND CASE
                    WHEN area_name =
                            'New York-White Plains-Wayne, NY-NJ Metropolitan Division'
                    THEN
                       'New York-Northern New Jersey-Long Island-NY'
                    WHEN area_name = 'Philadelphia, PA Metropolitan Division'
                    THEN
                       'Philadelphia-Camden-Wilmington-PA'
                    WHEN area_name =
                            'Miami-Miami Beach-Kendall, FL Metropolitan Division'
                    THEN
                       'Miami-Fort Lauderdale-Pompano Beach-FL'
                    WHEN area_name =
                            'Detroit-Livonia-Dearborn, MI Metropolitan Division'
                    THEN
                       'Detroit-Livonia-Dearborn-Warren-MI'
                    WHEN area_name = 'Nashville-Davidson--Murfreesboro, TN'
                    THEN
                       'Nashville-Davidson-Murfreesboro-Franklin-TN'
                    WHEN area_name =
                            'Dallas-Plano-Irving, TX Metropolitan Division'
                    THEN
                       'Dallas-Fort Worth-Arlington-TX'
                    ELSE
                       NVL (
                          c.consolidated_msa,
                          SUBSTR (o.area_name, 1, INSTR (o.area_name, ',') - 1)
                          || '-'
                          || SUBSTR (o.area_name,
                                     INSTR (o.area_name, ', ') + 2,
                                     2)
                       )
                 END IN
                       (  SELECT   reporting_msa FROM gk_top_msa_v)
   GROUP BY   o.occ_year,
              o.primary_state,
              o.area_number,
              o.area_name,
              c.consolidated_msa,
              o.occ_code,
              o.occ_title
   ORDER BY   reporting_msa, o.occ_year;


