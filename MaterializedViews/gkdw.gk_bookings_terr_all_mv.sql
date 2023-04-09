DROP MATERIALIZED VIEW GKDW.GK_BOOKINGS_TERR_ALL_MV;
CREATE MATERIALIZED VIEW GKDW.GK_BOOKINGS_TERR_ALL_MV 
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
/* Formatted on 29/01/2021 12:19:09 (QP5 v5.115.810.9015) */
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
                     AND event_prod_line != 'OTHER'
                     AND event_modality != 'RESELLER - C-LEARNING'
          GROUP BY   LPAD (territory_id, 2, '0'), acct_id, acct_name);

COMMENT ON MATERIALIZED VIEW GKDW.GK_BOOKINGS_TERR_ALL_MV IS 'snapshot table for snapshot GKDW.GK_BOOKINGS_TERR_ALL_MV';

GRANT SELECT ON GKDW.GK_BOOKINGS_TERR_ALL_MV TO DWHREAD;

