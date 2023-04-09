DROP VIEW GKDW.GK_CDW_ONSITE_V;

/* Formatted on 29/01/2021 11:41:12 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CDW_ONSITE_V (EVENT_ID, BOOK_AMT)
AS
     SELECT   event_id, SUM (enroll_amt) book_amt
       FROM   gk_onsite_bookings_mv
   GROUP BY   event_id;


