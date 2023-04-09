DROP VIEW GKDW.RMS_POD_RESERVATIONS_V;

/* Formatted on 29/01/2021 11:22:56 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.RMS_POD_RESERVATIONS_V
(
   POD_NAME,
   POD_RESERVATION_TYPE,
   EVENTSTART,
   EVENTEND,
   COUNTRY,
   EVENT_STATUS,
   POD_COUNT,
   EVENT_COMMENT,
   DUE_DATE
)
AS
     SELECT   pod_name,
              CASE lab_date_type
                 WHEN 1 THEN 'Lab Maintenance Work'
                 WHEN 2 THEN 'Instructor Preparation'
                 WHEN 3 THEN 'Third Party Booking'
                 WHEN 4 THEN 'Reservation'
                 ELSE 'N/A'
              END
                 pod_reservation_type,
              eventstart,
              eventend,
              country,
              event_status,
              COUNT (DISTINCT pod_id) pod_count,
              event_comment,
              due_date
       FROM   RMS_POD_LABS_MV
   GROUP BY   pod_name,
              lab_date_type,
              eventstart,
              eventend,
              country,
              event_status,
              event_comment,
              due_date;


GRANT SELECT ON GKDW.RMS_POD_RESERVATIONS_V TO COGNOS_RO;

GRANT SELECT ON GKDW.RMS_POD_RESERVATIONS_V TO EXCEL_RO;

GRANT SELECT ON GKDW.RMS_POD_RESERVATIONS_V TO PORTAL;

