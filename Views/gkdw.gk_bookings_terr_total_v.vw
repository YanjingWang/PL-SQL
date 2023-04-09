DROP VIEW GKDW.GK_BOOKINGS_TERR_TOTAL_V;

/* Formatted on 29/01/2021 11:42:29 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_BOOKINGS_TERR_TOTAL_V
(
   TERR_ID,
   TOTAL_BOOKINGS_2009,
   TOTAL_BOOKINGS_2008,
   TOTAL_BOOKINGS_2007
)
AS
     SELECT   terr_id,
              SUM (CASE WHEN book_year = 2009 THEN total_bookings ELSE 0 END)
                 total_bookings_2009,
              SUM (CASE WHEN book_year = 2008 THEN total_bookings ELSE 0 END)
                 total_bookings_2008,
              SUM (CASE WHEN book_year = 2007 THEN total_bookings ELSE 0 END)
                 total_bookings_2007
       FROM   gk_bookings_terr_year_mv
   GROUP BY   terr_id;


