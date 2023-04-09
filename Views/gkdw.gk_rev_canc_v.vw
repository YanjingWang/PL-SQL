DROP VIEW GKDW.GK_REV_CANC_V;

/* Formatted on 29/01/2021 11:27:43 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_REV_CANC_V
(
   OPS_COUNTRY,
   EVENT_MODALITY,
   BOOK_PERIOD,
   REV_PERIOD,
   CANC_COUNT,
   CANC_AMT
)
AS
     SELECT   e.ops_country,
              e.event_modality,
              LPAD (tb.dim_month_num, 2, '0') || '-' || tb.dim_period_name
                 book_period,
              LPAD (tr.dim_month_num, 2, '0') || '-' || tr.dim_period_name
                 rev_period,
              COUNT (enroll_id) canc_count,
              SUM (f.book_amt) canc_amt
       FROM            order_fact f
                    INNER JOIN
                       event_dim e
                    ON f.event_id = e.event_id
                 INNER JOIN
                    time_dim tr
                 ON f.rev_date = tr.dim_date
              INNER JOIN
                 time_dim tb
              ON f.book_date = tb.dim_date
      WHERE       enroll_status_date >= TO_DATE ('1/1/2006', 'mm/dd/yyyy')
              AND e.event_channel = 'INDIVIDUAL/PUBLIC'
              AND enroll_status = 'Cancelled'
              AND book_amt < 0
   GROUP BY   e.ops_country,
              e.event_modality,
              tb.dim_period_name,
              tb.dim_month_num,
              tr.dim_period_name,
              tr.dim_month_num
   ORDER BY   1 DESC,
              e.event_modality,
              tb.dim_month_num,
              tr.dim_month_num;


