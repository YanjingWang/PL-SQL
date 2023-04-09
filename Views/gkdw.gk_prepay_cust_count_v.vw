DROP VIEW GKDW.GK_PREPAY_CUST_COUNT_V;

/* Formatted on 29/01/2021 11:30:07 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PREPAY_CUST_COUNT_V
(
   PPCARD_ID,
   ISSUED_TO_CUST_ID,
   OLD_CARDS,
   OLD_CUST
)
AS
     SELECT   new.ppcard_id,
              new.ISSUED_TO_CUST_ID,
              COUNT (DISTINCT OLD.PPCARD_ID) old_cards,
              CASE
                 WHEN COUNT (DISTINCT OLD.PPCARD_ID) = 0 THEN 'N'
                 WHEN COUNT (DISTINCT OLD.PPCARD_ID) > 0 THEN 'Y'
              END
                 Old_CUST
       FROM      ppcard_dim new
              LEFT OUTER JOIN
                 ppcard_dim old
              ON NEW.ISSUED_TO_CUST_ID = old.issued_to_CUST_id
                 AND TRUNC (NEW.CREATION_DATE) > TRUNC (old.creation_date)
   GROUP BY   new.ppcard_id, new.ISSUED_TO_CUST_ID;


