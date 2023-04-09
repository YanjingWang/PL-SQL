DROP VIEW GKDW.GK_NON_BUYERS_V;

/* Formatted on 29/01/2021 11:32:17 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_NON_BUYERS_V
(
   ACCT_NAME,
   ACCT_CITY,
   ACCT_STATE,
   ACCT_ZIP,
   ACCT_COUNTRY,
   INDUSTRY,
   ACCT_CREATE_DATE,
   ACCT_MODIFY_DATE,
   CUST_NAME,
   CUST_ADDRESS1,
   CUST_ADDRESS2,
   CUST_CITY,
   CUST_STATE,
   CUST_ZIP,
   CUST_COUNTRY,
   WORKPHONE,
   EMAIL,
   TITLE,
   DEPARTMENT,
   CUST_CREATE_DATE,
   CUST_MODIFY_DATE,
   TERRITORY_ID,
   TERRITORY_TYPE,
   REGION
)
AS
     SELECT   ad.acct_name,
              ad.city acct_city,
              ad.state acct_state,
              ad.zipcode acct_zip,
              ad.country acct_country,
              ad.sic_code industry,
              ad.creation_date acct_create_date,
              ad.last_update_date acct_modify_date,
              cd.cust_name,
              cd.address1 cust_address1,
              cd.address2 cust_address2,
              cd.city cust_city,
              cd.state cust_state,
              cd.zipcode cust_zip,
              cd.country cust_country,
              cd.workphone,
              cd.email,
              cd.title,
              cd.department,
              cd.creation_date cust_create_date,
              cd.last_update_date cust_modify_date,
              gt.territory_id,
              gt.territory_type,
              gt.region
       FROM         cust_dim cd
                 INNER JOIN
                    account_dim ad
                 ON cd.acct_id = ad.acct_id
              INNER JOIN
                 gk_territory gt
              ON cd.zipcode BETWEEN gt.zip_start AND gt.zip_end
      WHERE   NOT EXISTS (SELECT   *
                            FROM   gk_booking_cube_mv mv
                           WHERE   mv.cust_id = cd.cust_id)
              AND NOT EXISTS (SELECT   *
                                FROM   sales_order_fact so
                               WHERE   so.cust_id = cd.cust_id)
   ORDER BY   ad.acct_name, cd.cust_name;


