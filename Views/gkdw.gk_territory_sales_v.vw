DROP VIEW GKDW.GK_TERRITORY_SALES_V;

/* Formatted on 29/01/2021 11:25:17 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_TERRITORY_SALES_V
(
   DIM_YEAR,
   DIM_PERIOD_NAME,
   DIM_MONTH_NUM,
   ENROLL_ID,
   EVENT_ID,
   CUST_ID,
   BOOK_DATE,
   BOOK_AMT,
   ENROLL_STATUS,
   PARTNER_KEY_CODE,
   PARTNER_NAME,
   CUST_NAME,
   ACCT_NAME,
   ACCT_ID,
   ADDRESS1,
   ADDRESS2,
   CITY,
   STATE,
   ZIPCODE,
   COUNTRY,
   COUNTY,
   WORKPHONE,
   EMAIL,
   NATIONAL_TERR_ID,
   ACCT_ZIPCODE,
   TERRITORY_ID,
   SALESREP,
   REGION,
   REGION_MGR,
   CHANNEL,
   NATIONAL,
   MTA
)
AS
   SELECT   td.dim_year,
            td.dim_period_name,
            td.dim_month_num,
            f.enroll_id,
            f.event_id,
            f.cust_id,
            f.book_date,
            f.book_amt,
            f.enroll_status,
            cp.partner_key_code,
            partner_name,
            cd.cust_name,
            cd.acct_name,
            cd.acct_id,
            cd.address1,
            cd.address2,
            cd.city,
            cd.state,
            cd.zipcode,
            cd.country,
            cd.county,
            cd.workphone,
            cd.email,
            ad.national_terr_id,
            ad.zipcode acct_zipcode,
            gt.territory_id,
            gt.salesrep,
            gt.region,
            gt.region_mgr,
            CASE WHEN cp.partner_key_code IS NOT NULL THEN 'Y' ELSE 'N' END
               channel,
            CASE
               WHEN ad.national_terr_id IN ('32', '73', '52') THEN 'Y'
               ELSE 'N'
            END
               NATIONAL,
            CASE
               WHEN ad.national_terr_id BETWEEN '80' AND '89'
                    AND cd.zipcode = ad.zipcode
               THEN
                  'Y'
               ELSE
                  'N'
            END
               mta
     FROM                  order_fact f
                        INNER JOIN
                           time_dim td
                        ON f.book_date = td.dim_date
                     INNER JOIN
                        cust_dim cd
                     ON f.cust_id = cd.cust_id
                  INNER JOIN
                     account_dim ad
                  ON cd.acct_id = ad.acct_id
               INNER JOIN
                  gk_territory gt
               ON gt.territory_type = 'OB'
                  AND f.zip_code BETWEEN gt.zip_start AND gt.zip_end
            LEFT OUTER JOIN
               gk_channel_partner cp
            ON f.reg_code = cp.partner_key_code
    WHERE   td.dim_year >= 2008 AND cd.country = 'USA';


