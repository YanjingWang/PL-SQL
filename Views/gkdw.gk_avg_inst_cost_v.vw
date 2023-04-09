DROP VIEW GKDW.GK_AVG_INST_COST_V;

/* Formatted on 29/01/2021 11:42:47 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_AVG_INST_COST_V
(
   METRO_LEVEL,
   FACILITY_REGION_METRO,
   AVG_HOTEL_DAY,
   AVG_AIRFARE_EVENT,
   AVG_RENTAL_DAY
)
AS
     SELECT   SUBSTR (travel_level, 1, 1) metro_level,
              facilityregionmetro facility_region_metro,
              ROUND (SUM (hotel_cost) / SUM (event_length)) avg_hotel_day,
              ROUND (SUM (airfare_cost) / COUNT (evxeventid)) avg_airfare_event,
              ROUND (SUM (rental_cost) / SUM (event_length)) avg_rental_day
       FROM   gk_inst_localization_v@gkprod
      WHERE   dim_year = 2008
   GROUP BY   SUBSTR (travel_level, 1, 1), facilityregionmetro;


