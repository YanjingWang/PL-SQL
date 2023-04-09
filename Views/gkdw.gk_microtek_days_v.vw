DROP VIEW GKDW.GK_MICROTEK_DAYS_V;

/* Formatted on 29/01/2021 11:33:13 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_MICROTEK_DAYS_V
(
   MICROTEK_DAYS
)
AS
   SELECT   NVL (SUM (ed.end_date - ed.start_date + 1), 1) microtek_days
     FROM                  event_dim ed
                        INNER JOIN
                           course_dim cd
                        ON ed.course_id = cd.course_id
                           AND ed.ops_country = cd.country
                     INNER JOIN
                        rmsdw.rms_event re
                     ON ed.event_id = re.slx_event_id
                  INNER JOIN
                     gk_microtek_location ml
                  ON ed.location_id = ml.location_id
               INNER JOIN
                  time_dim td
               ON ed.start_date = td.dim_date
            INNER JOIN
               time_dim td2
            ON td2.dim_date = TRUNC (SYSDATE) + 7
    WHERE       status IN ('Open', 'Verified')
            AND td.dim_year = td2.dim_year
            AND ed.end_date <= TRUNC (SYSDATE);


