DROP VIEW GKDW.GK_NAICS_DNB_CUST_V;

/* Formatted on 29/01/2021 11:32:37 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_NAICS_DNB_CUST_V
(
   CUST_KEY,
   COMPANY_NAME,
   PRIMARY_ADDR1,
   PRIMARY_CITY,
   PRIMARY_STATE,
   PRIMARY_ZIP,
   PRIMARY_COUNTRY,
   CONF_CODE,
   MATCH_GRADE,
   BEMFAB,
   DUNS_NUMBER,
   NAICS_DESC,
   BUSINESS_NAME,
   ANNUAL_SALES,
   EMPLOYEES_TOTAL,
   EMPLOYEES_HERE,
   GLOBAL_ULT_BUSINESS_NAME,
   PARENT_HQ_NAME,
   LINE_OF_BUSINESS,
   BEMFAB_ACCT_MATCH,
   SMALL_BUSINESS_IND
)
AS
   SELECT   DISTINCT
            cust_key,
            company_name,
            primary_addr1,
            primary_city,
            primary_state,
            primary_zip,
            primary_country,
            TO_NUMBER (NVL (REPLACE (n.conf_code, CHR (13)), '0')) conf_code,
            match_grade,
            bemfab,
            n.duns_number,
            REPLACE (naics_desc, CHR (13)) naics_desc,
            d.business_name,
            d.annual_sales,
            d.employees_total,
            d.employees_here,
            d.global_ult_business_name,
            d.parent_hq_name,
            d.line_of_business,
            bemfab || '-' || SUBSTR (match_grade, 1, 1) bemfab_acct_match,
            d.small_business_ind
     FROM      gk_naics_append n
            LEFT OUTER JOIN
               gk_duns_append d
            ON LPAD (REPLACE (n.duns_number, '-'), 9, '0') =
                  LPAD (d.duns_number, 9, '0');


