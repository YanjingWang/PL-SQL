DROP VIEW GKDW.GK_EVENT_COUNT;

/* Formatted on 29/01/2021 11:37:12 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EVENT_COUNT
(
   METRO_AREA,
   START_DATE,
   TC_ROOMS,
   TC_ROOMS_W_PCS,
   EVENT_CNT
)
AS
     SELECT   metro_area,
              start_date,
              ff.tc_rooms,
              ff.tc_rooms_w_pcs,
              COUNT (rf.event_id) event_cnt
       FROM         gk_revenue_forecast rf
                 INNER JOIN
                    time_dim td
                 ON rf.start_date = td.dim_date
              LEFT OUTER JOIN
                 fcdw.fc_facility ff
              ON rf.metro_area = ff.metro_area
      WHERE   metro_area IS NOT NULL
   GROUP BY   metro_area,
              start_date,
              ff.tc_rooms,
              ff.tc_rooms_w_pcs;


