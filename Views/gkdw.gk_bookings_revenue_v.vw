DROP VIEW GKDW.GK_BOOKINGS_REVENUE_V;

/* Formatted on 29/01/2021 11:42:43 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_BOOKINGS_REVENUE_V
(
   GK_DIM_YEAR,
   GK_DIM_QUARTER,
   GK_DIM_PERIOD_NAME,
   GK_DIM_WEEK,
   GK_DIM_DATE,
   GK_CURR_CODE,
   GK_EVENT_CHANNEL,
   GK_EVENT_MODALITY,
   GK_EVENT_PROD_LINE,
   GK_BOOK_AMT,
   GK_REV_AMT
)
AS
     SELECT   gk_dim_year,
              gk_dim_quarter,
              gk_dim_period_name,
              gk_dim_week,
              gk_dim_date,
              gk_curr_code,
              gk_event_channel,
              gk_event_modality,
              gk_event_prod_line,
              SUM (gk_book_amt) gk_book_amt,
              SUM (gk_rev_amt) gk_rev_amt
       FROM   (SELECT   t.dim_year gk_dim_year,
                        t.dim_quarter gk_dim_quarter,
                        t.dim_period_name gk_dim_period_name,
                        t.dim_week gk_dim_week,
                        t.dim_date gk_dim_date,
                        curr_code gk_curr_code,
                        e.event_channel gk_event_channel,
                        e.event_modality gk_event_modality,
                        e.event_prod_line gk_event_prod_line,
                        f.book_amt gk_book_amt,
                        0 gk_rev_amt
                 FROM         order_fact f
                           INNER JOIN
                              event_dim e
                           ON f.event_id = e.event_id
                        INNER JOIN
                           time_dim t
                        ON f.book_date = t.dim_date
                WHERE   t.dim_year >= 2007
               UNION ALL
               SELECT   t.dim_year,
                        t.dim_quarter,
                        t.dim_period_name,
                        t.dim_week,
                        t.dim_date,
                        curr_code,
                        e.event_channel,
                        e.event_modality,
                        e.event_prod_line,
                        0 book_amt,
                        f.book_amt
                 FROM         order_fact f
                           INNER JOIN
                              event_dim e
                           ON f.event_id = e.event_id
                        INNER JOIN
                           time_dim t
                        ON f.rev_date = t.dim_date
                WHERE   t.dim_year >= 2007)
   GROUP BY   gk_dim_year,
              gk_dim_quarter,
              gk_dim_period_name,
              gk_dim_week,
              gk_dim_date,
              gk_curr_code,
              gk_event_channel,
              gk_event_modality,
              gk_event_prod_line
   ORDER BY   gk_dim_week, gk_curr_code;


