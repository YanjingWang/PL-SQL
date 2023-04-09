DROP MATERIALIZED VIEW GKDW.GK_OCC_MV;
CREATE MATERIALIZED VIEW GKDW.GK_OCC_MV 
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
/* Formatted on 29/01/2021 12:24:10 (QP5 v5.115.810.9015) */
  SELECT   o.occ_year,
           CASE
              WHEN o.occ_code IN
                         ('15-1021',
                          '15-1031',
                          '15-1032',
                          '15-1061',
                          '15-1131',
                          '15-1132',
                          '15-1133',
                          '15-1141')
              THEN
                 'Developer'
              WHEN o.occ_code IN
                         ('15-1041', '15-1051', '15-1071', '15-1081', '15-1142')
              THEN
                 'Network'
              WHEN o.occ_code IN
                         ('15-1011',
                          '15-1099',
                          '17-2061',
                          '15-1111',
                          '15-1121',
                          '15-1150',
                          '15-1179')
              THEN
                 'IT-Other'
              WHEN o.occ_code IN
                         ('11-1011', '11-1021', '11-3021', '11-3042', '11-3131')
              THEN
                 'Executive/Manager'
              WHEN o.occ_code IN ('13-1073', '13-1079', '13-1078')
              THEN
                 'Training'
           END
              it_category,
           o.primary_state,
           CASE
              WHEN o.area_number = '70750' THEN '12620'
              WHEN o.area_number = '70900' THEN '12700'
              WHEN o.area_number = '71950' THEN '14860'
              WHEN o.area_number = '72400' THEN '15540'
              WHEN o.area_number = '73450' THEN '25540'
              WHEN o.area_number = '74650' THEN '30340'
              WHEN o.area_number = '76600' THEN '38340'
              WHEN o.area_number = '76750' THEN '38860'
              WHEN o.area_number = '71654' THEN '14460'
              WHEN o.area_number = '74950' THEN '31700'
              WHEN o.area_number = '76450' THEN '35980'
              WHEN o.area_number = '76900' THEN '39020'
              WHEN o.area_number = '77200' THEN '39300'
              WHEN o.area_number = '78100' THEN '44140'
              WHEN o.area_number = '79600' THEN '49340'
              WHEN o.area_number = '14600' THEN '35840'
              WHEN o.area_number = '42260' THEN '35840'
              WHEN o.area_number = '23020' THEN '18880'
              WHEN o.area_number = '75550' THEN '39300'
              WHEN o.area_number = '75700' THEN '35300'
              WHEN o.area_number = '16974' THEN '16980'
              WHEN o.area_number = '29404' THEN '16980'
              WHEN o.area_number = '23844' THEN '16980'
              WHEN o.area_number = '23104' THEN '19100'
              WHEN o.area_number = '19124' THEN '19100'
              WHEN o.area_number = '19804' THEN '19820'
              WHEN o.area_number = '47644' THEN '19820'
              WHEN o.area_number = '31084' THEN '31100'
              WHEN o.area_number = '42044' THEN '31100'
              WHEN o.area_number = '33124' THEN '33100'
              WHEN o.area_number = '22744' THEN '33100'
              WHEN o.area_number = '48424' THEN '33100'
              WHEN o.area_number = '35004' THEN '35620'
              WHEN o.area_number = '35084' THEN '35620'
              WHEN o.area_number = '20764' THEN '35620'
              WHEN o.area_number = '35644' THEN '35620'
              WHEN o.area_number = '48864' THEN '37980'
              WHEN o.area_number = '15804' THEN '37980'
              WHEN o.area_number = '37964' THEN '37980'
              WHEN o.area_number = '36084' THEN '41860'
              WHEN o.area_number = '41884' THEN '41860'
              WHEN o.area_number = '45104' THEN '42660'
              WHEN o.area_number = '42644' THEN '42660'
              WHEN o.area_number = '47894' THEN '47900'
              WHEN o.area_number = '13644' THEN '47900'
              ELSE o.area_number
           END
              area_number,
           CASE
              WHEN o.area_number IN ('16974', '29404', '23844')
              THEN
                 'Chicago-Naperville-Joliet, IL Metropolitan Division'
              WHEN o.area_number IN ('23104', '19124')
              THEN
                 'Dallas-Plano-Irving, TX Metropolitan Division'
              WHEN o.area_number IN ('31084', '42044')
              THEN
                 'Los Angeles-Long Beach-Glendale, CA  Metropolitan Division'
              WHEN o.area_number IN ('33124', '22744', '48424')
              THEN
                 'Miami-Miami Beach-Kendall, FL Metropolitan Division'
              WHEN o.area_number IN ('35004', '35084', '20764', '35644')
              THEN
                 'New York-White Plains-Wayne, NY-NJ Metropolitan Division'
              WHEN o.area_number IN ('14600', '42260')
              THEN
                 'Bradenton-Sarasota-Venice, FL'
              WHEN o.area_number IN ('48864', '15804', '37964')
              THEN
                 'Philadelphia, PA Metropolitan Division'
              WHEN o.area_number IN ('77200', '75550')
              THEN
                 'Providence-Fall River-Warwick, RI-MA'
              WHEN o.area_number IN ('36084', '41884')
              THEN
                 'San Francisco-San Mateo-Redwood City, CA Metropolitan Division'
              WHEN o.area_number IN ('45104', '42644')
              THEN
                 'Seattle-Bellevue-Everett, WA Metropolitan Division'
              WHEN o.area_number IN ('47894', '13644')
              THEN
                 'Washington-Arlington-Alexandria, DC-VA-MD-WV Metropolitan Division'
              WHEN o.area_number IN ('19804', '47644')
              THEN
                 'Detroit-Livonia-Dearborn, MI Metropolitan Division'
              WHEN o.area_number IN ('20500', '39580')
              THEN
                 'Raleigh-Cary-Durham, NC'
              ELSE
                 TRIM (o.area_name)
           END
              area_name,
           SUBSTR (o.area_name, 1, INSTR (o.area_name, ',') - 1) msa_name,
              SUBSTR (o.area_name, 1, INSTR (o.area_name, ',') - 1)
           || '-'
           || SUBSTR (o.area_name, INSTR (o.area_name, ', ') + 2, 2)
              msa_desc,
           o.occ_code,
           o.occ_title,
           SUM (NVL (tot_emp, 0)) occ_emp_cnt
    FROM   gk_msa_occ o
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
                  '17-2061',
                  '11-3131',
                  '13-1078',
                  '15-1111',
                  '15-1121',
                  '15-1131',
                  '15-1132',
                  '15-1133',
                  '15-1141',
                  '15-1142',
                  '15-1150',
                  '15-1179')
GROUP BY   o.occ_year,
           o.primary_state,
           CASE
              WHEN o.area_number = '70750' THEN '12620'
              WHEN o.area_number = '70900' THEN '12700'
              WHEN o.area_number = '71950' THEN '14860'
              WHEN o.area_number = '72400' THEN '15540'
              WHEN o.area_number = '73450' THEN '25540'
              WHEN o.area_number = '74650' THEN '30340'
              WHEN o.area_number = '76600' THEN '38340'
              WHEN o.area_number = '76750' THEN '38860'
              WHEN o.area_number = '71654' THEN '14460'
              WHEN o.area_number = '74950' THEN '31700'
              WHEN o.area_number = '76450' THEN '35980'
              WHEN o.area_number = '76900' THEN '39020'
              WHEN o.area_number = '77200' THEN '39300'
              WHEN o.area_number = '78100' THEN '44140'
              WHEN o.area_number = '79600' THEN '49340'
              WHEN o.area_number = '14600' THEN '35840'
              WHEN o.area_number = '42260' THEN '35840'
              WHEN o.area_number = '23020' THEN '18880'
              WHEN o.area_number = '75550' THEN '39300'
              WHEN o.area_number = '75700' THEN '35300'
              WHEN o.area_number = '16974' THEN '16980'
              WHEN o.area_number = '29404' THEN '16980'
              WHEN o.area_number = '23844' THEN '16980'
              WHEN o.area_number = '23104' THEN '19100'
              WHEN o.area_number = '19124' THEN '19100'
              WHEN o.area_number = '19804' THEN '19820'
              WHEN o.area_number = '47644' THEN '19820'
              WHEN o.area_number = '31084' THEN '31100'
              WHEN o.area_number = '42044' THEN '31100'
              WHEN o.area_number = '33124' THEN '33100'
              WHEN o.area_number = '22744' THEN '33100'
              WHEN o.area_number = '48424' THEN '33100'
              WHEN o.area_number = '35004' THEN '35620'
              WHEN o.area_number = '35084' THEN '35620'
              WHEN o.area_number = '20764' THEN '35620'
              WHEN o.area_number = '35644' THEN '35620'
              WHEN o.area_number = '48864' THEN '37980'
              WHEN o.area_number = '15804' THEN '37980'
              WHEN o.area_number = '37964' THEN '37980'
              WHEN o.area_number = '36084' THEN '41860'
              WHEN o.area_number = '41884' THEN '41860'
              WHEN o.area_number = '45104' THEN '42660'
              WHEN o.area_number = '42644' THEN '42660'
              WHEN o.area_number = '47894' THEN '47900'
              WHEN o.area_number = '13644' THEN '47900'
              ELSE o.area_number
           END,
           CASE
              WHEN o.area_number IN ('16974', '29404', '23844')
              THEN
                 'Chicago-Naperville-Joliet, IL Metropolitan Division'
              WHEN o.area_number IN ('23104', '19124')
              THEN
                 'Dallas-Plano-Irving, TX Metropolitan Division'
              WHEN o.area_number IN ('31084', '42044')
              THEN
                 'Los Angeles-Long Beach-Glendale, CA  Metropolitan Division'
              WHEN o.area_number IN ('33124', '22744', '48424')
              THEN
                 'Miami-Miami Beach-Kendall, FL Metropolitan Division'
              WHEN o.area_number IN ('35004', '35084', '20764', '35644')
              THEN
                 'New York-White Plains-Wayne, NY-NJ Metropolitan Division'
              WHEN o.area_number IN ('14600', '42260')
              THEN
                 'Bradenton-Sarasota-Venice, FL'
              WHEN o.area_number IN ('48864', '15804', '37964')
              THEN
                 'Philadelphia, PA Metropolitan Division'
              WHEN o.area_number IN ('77200', '75550')
              THEN
                 'Providence-Fall River-Warwick, RI-MA'
              WHEN o.area_number IN ('36084', '41884')
              THEN
                 'San Francisco-San Mateo-Redwood City, CA Metropolitan Division'
              WHEN o.area_number IN ('45104', '42644')
              THEN
                 'Seattle-Bellevue-Everett, WA Metropolitan Division'
              WHEN o.area_number IN ('47894', '13644')
              THEN
                 'Washington-Arlington-Alexandria, DC-VA-MD-WV Metropolitan Division'
              WHEN o.area_number IN ('19804', '47644')
              THEN
                 'Detroit-Livonia-Dearborn, MI Metropolitan Division'
              WHEN o.area_number IN ('20500', '39580')
              THEN
                 'Raleigh-Cary-Durham, NC'
              ELSE
                 TRIM (o.area_name)
           END,
           o.area_name,
           o.occ_code,
           o.occ_title;

COMMENT ON MATERIALIZED VIEW GKDW.GK_OCC_MV IS 'snapshot table for snapshot GKDW.GK_OCC_MV';

GRANT SELECT ON GKDW.GK_OCC_MV TO DWHREAD;

