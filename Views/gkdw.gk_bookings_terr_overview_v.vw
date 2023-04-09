DROP VIEW GKDW.GK_BOOKINGS_TERR_OVERVIEW_V;

/* Formatted on 29/01/2021 11:42:34 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_BOOKINGS_TERR_OVERVIEW_V
(
   ACCT_NAME,
   TERR_ID,
   BOOKINGS_RANK,
   TOTAL_BOOKINGS,
   TOTAL_BOOKINGS_2007,
   TOTAL_BOOKINGS_2008,
   TOTAL_BOOKINGS_2009,
   ACCT_NONPP_2009,
   ACCT_PP_2009,
   ACCT_TOTAL_2009,
   ACCT_NONPP_2008,
   ACCT_PP_2008,
   ACCT_TOTAL_2008,
   ACCT_NONPP_2007,
   ACCT_PP_2007,
   ACCT_TOTAL_2007,
   ACCT_TOTAL_3YR
)
AS
     SELECT   acct_name,
              terr_id,
              bookings_rank,
              total_bookings,
              total_bookings_2007,
              total_bookings_2008,
              total_bookings_2009,
              SUM (acct_nonpp_2009) acct_nonpp_2009,
              SUM (acct_pp_2009) acct_pp_2009,
              SUM (acct_total_2009) acct_total_2009,
              SUM (acct_nonpp_2008) acct_nonpp_2008,
              SUM (acct_pp_2008) acct_pp_2008,
              SUM (acct_total_2008) acct_total_2008,
              SUM (acct_nonpp_2007) acct_nonpp_2007,
              SUM (acct_pp_2007) acct_pp_2007,
              SUM (acct_total_2007) acct_total_2007,
              SUM (acct_total_2009 + acct_total_2008 + acct_total_2007)
                 acct_total_3yr
       FROM   (  SELECT   tt.acct_name,
                          tt.terr_id,
                          tt.bookings_rank,
                          tt.total_bookings,
                          bt.total_bookings_2007,
                          bt.total_bookings_2008,
                          bt.total_bookings_2009,
                          SUM(CASE
                                 WHEN NVL (payment_type, 'NONE') != 'PREPAY CARD'
                                 THEN
                                    book_amt
                                 ELSE
                                    0
                              END)
                             acct_nonpp_2009,
                          SUM(CASE
                                 WHEN payment_type = 'PREPAY CARD' THEN book_amt
                                 ELSE 0
                              END)
                             acct_pp_2009,
                          SUM (book_amt) acct_total_2009,
                          0 acct_nonpp_2008,
                          0 acct_pp_2008,
                          0 acct_total_2008,
                          0 acct_nonpp_2007,
                          0 acct_pp_2007,
                          0 acct_total_2007
                   FROM         gk_open_enrollment_mv oe
                             INNER JOIN
                                gk_bookings_terr_all_mv tt
                             ON oe.acct_id = tt.acct_id
                                AND LPAD (oe.territory_id, 2, '0') = tt.terr_id
                          INNER JOIN
                             gk_bookings_terr_total_v bt
                          ON tt.terr_id = bt.terr_id
                  WHERE       oe.book_year = 2009
                          AND (itbt_flag = 'ITBT' OR itbt_flag IS NULL)
                          AND ch_flag = 'N'
                          AND nat_flag = 'N'
                          AND mta_flag = 'N'
                          AND event_prod_line != 'OTHER'
                          AND event_modality != 'RESELLER - C-LEARNING'
               GROUP BY   tt.acct_name,
                          tt.terr_id,
                          tt.bookings_rank,
                          tt.total_bookings,
                          bt.total_bookings_2007,
                          bt.total_bookings_2008,
                          bt.total_bookings_2009
               UNION ALL
                 SELECT   tt.acct_name,
                          tt.terr_id,
                          tt.bookings_rank,
                          tt.total_bookings,
                          bt.total_bookings_2007,
                          bt.total_bookings_2008,
                          bt.total_bookings_2009,
                          0 acct_nonpp_2009,
                          0 acct_pp_2009,
                          0 acct_total_2009,
                          SUM(CASE
                                 WHEN NVL (payment_type, 'NONE') != 'PREPAY CARD'
                                 THEN
                                    book_amt
                                 ELSE
                                    0
                              END)
                             acct_nonpp_2008,
                          SUM(CASE
                                 WHEN payment_type = 'PREPAY CARD' THEN book_amt
                                 ELSE 0
                              END)
                             acct_pp_2008,
                          SUM (book_amt) acct_total_2008,
                          0 acct_nonpp_2007,
                          0 acct_pp_2007,
                          0 acct_total_2007
                   FROM         gk_open_enrollment_mv oe
                             INNER JOIN
                                gk_bookings_terr_all_mv tt
                             ON oe.acct_id = tt.acct_id
                                AND LPAD (oe.territory_id, 2, '0') = tt.terr_id
                          INNER JOIN
                             gk_bookings_terr_total_v bt
                          ON tt.terr_id = bt.terr_id
                  WHERE       oe.book_year = 2008
                          AND (itbt_flag = 'ITBT' OR itbt_flag IS NULL)
                          AND ch_flag = 'N'
                          AND nat_flag = 'N'
                          AND mta_flag = 'N'
                          AND event_prod_line != 'OTHER'
                          AND event_modality != 'RESELLER - C-LEARNING'
               GROUP BY   tt.acct_name,
                          tt.terr_id,
                          tt.bookings_rank,
                          tt.total_bookings,
                          bt.total_bookings_2007,
                          bt.total_bookings_2008,
                          bt.total_bookings_2009
               UNION ALL
                 SELECT   tt.acct_name,
                          tt.terr_id,
                          tt.bookings_rank,
                          tt.total_bookings,
                          bt.total_bookings_2007,
                          bt.total_bookings_2008,
                          bt.total_bookings_2009,
                          0 acct_nonpp_2009,
                          0 acct_pp_2009,
                          0 acct_total_2009,
                          0 acct_nonpp_2008,
                          0 acct_pp_2008,
                          0 acct_total_2008,
                          SUM(CASE
                                 WHEN NVL (payment_type, 'NONE') != 'PREPAY CARD'
                                 THEN
                                    book_amt
                                 ELSE
                                    0
                              END)
                             acct_nonpp_2007,
                          SUM(CASE
                                 WHEN payment_type = 'PREPAY CARD' THEN book_amt
                                 ELSE 0
                              END)
                             acct_pp_2007,
                          SUM (book_amt) acct_total_2007
                   FROM         gk_open_enrollment_mv oe
                             INNER JOIN
                                gk_bookings_terr_all_mv tt
                             ON oe.acct_id = tt.acct_id
                                AND LPAD (oe.territory_id, 2, '0') = tt.terr_id
                          INNER JOIN
                             gk_bookings_terr_total_v bt
                          ON tt.terr_id = bt.terr_id
                  WHERE       oe.book_year = 2007
                          AND (itbt_flag = 'ITBT' OR itbt_flag IS NULL)
                          AND ch_flag = 'N'
                          AND nat_flag = 'N'
                          AND mta_flag = 'N'
                          AND event_prod_line != 'OTHER'
                          AND event_modality != 'RESELLER - C-LEARNING'
               GROUP BY   tt.acct_name,
                          tt.terr_id,
                          tt.bookings_rank,
                          tt.total_bookings,
                          bt.total_bookings_2007,
                          bt.total_bookings_2008,
                          bt.total_bookings_2009)
   --where terr_id = '40'
   GROUP BY   acct_name,
              terr_id,
              bookings_rank,
              total_bookings,
              total_bookings_2007,
              total_bookings_2008,
              total_bookings_2009
   ORDER BY   bookings_rank ASC;


