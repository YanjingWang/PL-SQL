DROP MATERIALIZED VIEW GKDW.GK_BOOKINGS_TERR_YEAR_MV;
CREATE MATERIALIZED VIEW GKDW.GK_BOOKINGS_TERR_YEAR_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:19:20 (QP5 v5.115.810.9015) */
SELECT   book_year,
         terr_id,
         acct_id,
         acct_name,
         total_bookings,
         bookings_rank
  FROM   (  SELECT   book_year,
                     LPAD (territory_id, 2, '0') terr_id,
                     acct_id,
                     acct_name,
                     SUM (book_amt) total_bookings,
                     RANK ()
                        OVER (
                           PARTITION BY LPAD (territory_id, 2, '0'), book_year
                           ORDER BY SUM (book_amt) DESC
                        )
                        bookings_rank
              FROM   gk_open_enrollment_mv
             WHERE       book_year >= 2007
                     AND (itbt_flag = 'ITBT' OR itbt_flag IS NULL)
                     AND ch_flag = 'N'
                     AND nat_flag = 'N'
                     AND mta_flag = 'N'
                     AND event_prod_line != 'OTHER'
                     AND event_modality != 'RESELLER - C-LEARNING'
          GROUP BY   book_year,
                     LPAD (territory_id, 2, '0'),
                     acct_id,
                     acct_name);

COMMENT ON MATERIALIZED VIEW GKDW.GK_BOOKINGS_TERR_YEAR_MV IS 'snapshot table for snapshot GKDW.GK_BOOKINGS_TERR_YEAR_MV';

GRANT SELECT ON GKDW.GK_BOOKINGS_TERR_YEAR_MV TO DWHREAD;

