DROP VIEW GKDW.GK_PROMO_RESPONSE_V;

/* Formatted on 29/01/2021 11:28:18 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PROMO_RESPONSE_V
(
   ENROLL_ID,
   STEP_NUM,
   STEP_STATUS,
   STATUS_DATE,
   ADDL_INFO,
   PROMO_ITEM
)
AS
   SELECT   s.evxevenrollid enroll_id,
            s.step_num,
            CASE
               WHEN ps."shipping_accept" = 'True' THEN 'Accepted'
               ELSE 'Declined'
            END
               step_status,
            TO_CHAR (ps."date_received", 'yyyy-mm-dd') status_date,
            CASE
               WHEN ps."shipping_accept" = 'True'
                    AND s.promo_code IN ('HELLO', 'HELLO10')
               THEN
                  TO_CHAR (ps."email")
               WHEN ps."shipping_accept" = 'True'
               THEN
                  TO_CHAR(   TRIM (ps."address1")
                          || ','
                          || TRIM (ps."address2")
                          || ','
                          || TRIM (ps."city")
                          || ','
                          || TRIM (ps."state")
                          || ','
                          || TRIM (ps."zip"))
               ELSE
                  'N/A'
            END
               addl_info,
            ps."item" promo_item
     FROM      promo_shipping@mkt_catalog ps
            INNER JOIN
               gk_promo_status@slx s
            ON ps."evxenrollid" = s.evxevenrollid AND s.step_num = 4
    WHERE   ps."currententry" = 1
            AND NOT EXISTS
                  (SELECT   1
                     FROM   gk_promo_status@slx s2
                    WHERE       s.evxevenrollid = s2.evxevenrollid
                            AND s.step_num = s2.step_num
                            AND s.additional_info = s2.additional_info)
   UNION
   SELECT   s.evxevenrollid enroll_id,
            s.step_num,
            CASE
               WHEN ps."shipping_accept" = 'True' THEN 'Accepted'
               ELSE 'Declined'
            END
               step_status,
            TO_CHAR (ps."date_received", 'yyyy-mm-dd') status_date,
            CASE
               WHEN ps."shipping_accept" = 'True'
               THEN
                  TO_CHAR(   TRIM (ps."address1")
                          || ','
                          || TRIM (ps."address2")
                          || ','
                          || TRIM (ps."city")
                          || ','
                          || TRIM (ps."state")
                          || ','
                          || TRIM (ps."zip"))
               ELSE
                  'N/A'
            END
               addl_info,
            ps."item" promo_item
     FROM      promo_shipping@mkt_catalog ps
            INNER JOIN
               gk_promo_status@slx s
            ON ps."evxenrollid" = s.evxevenrollid AND s.step_num = 4
    WHERE       ps."currententry" = 1
            AND ps."item" IS NOT NULL
            AND s.step_num = 7
            AND NOT EXISTS
                  (SELECT   1
                     FROM   gk_promo_status@slx s3
                    WHERE       s.evxevenrollid = s3.evxevenrollid
                            AND TRIM (ps."item") = TRIM (s3.additional_info)
                            AND s3.step_num = 7);


