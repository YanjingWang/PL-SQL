DROP VIEW GKDW.RMS_POD_COUNT_V;

/* Formatted on 29/01/2021 11:23:00 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.RMS_POD_COUNT_V
(
   SLX_EVENT_ID,
   POD_NAME,
   EVENT_COMMENT,
   POD_COUNT
)
AS
     SELECT   slx_event_id,
              pod_name,
              event_comment,
              COUNT (DISTINCT pod_id) pod_count
       FROM   RMS_EVENT_POD_MV
   GROUP BY   slx_event_id, pod_name, event_comment;


GRANT SELECT ON GKDW.RMS_POD_COUNT_V TO COGNOS_RO;

GRANT SELECT ON GKDW.RMS_POD_COUNT_V TO EXCEL_RO;

GRANT SELECT ON GKDW.RMS_POD_COUNT_V TO PORTAL;

