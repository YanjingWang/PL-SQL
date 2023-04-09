DROP VIEW GKDW.GK_BOOKINGS_TERR_ALL_V;

/* Formatted on 29/01/2021 11:42:38 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_BOOKINGS_TERR_ALL_V
(
   TERR_ID,
   ACCT_ID,
   ACCT_NAME,
   TOTAL_BOOKINGS,
   BOOKINGS_RANK
)
AS
     SELECT   terr_id,
              acct_id,
              acct_name,
              total_bookings,
              bookings_rank
       FROM   (  SELECT   LPAD (territory_id, 2, '0') terr_id,
                          acct_id,
                          acct_name,
                          SUM (book_amt) total_bookings,
                          RANK ()
                             OVER (PARTITION BY LPAD (territory_id, 2, '0')
                                   ORDER BY SUM (book_amt) DESC)
                             bookings_rank
                   FROM   gk_open_enrollment_mv
                  WHERE       book_year >= 2007
                          AND (itbt_flag = 'ITBT' OR itbt_flag IS NULL)
                          AND ch_flag = 'N'
                          AND nat_flag = 'N'
                          AND mta_flag = 'N'
               GROUP BY   LPAD (territory_id, 2, '0'), acct_id, acct_name)
   ORDER BY   terr_id, bookings_rank ASC;


