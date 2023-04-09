DROP VIEW GKDW.GK_VIRTUAL_EVENT_LINK_V;

/* Formatted on 29/01/2021 11:24:08 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_VIRTUAL_EVENT_LINK_V
(
   VIRTUAL_EVENT,
   VIRTUAL_EVENT_LINK,
   COUNTRY,
   EVENT_LINK_COUNTRY
)
AS
     SELECT   DISTINCT ed1.event_id virtual_event,
                       ed2.event_id virtual_event_link,
                       ED1.COUNTRY,
                       ED2.COUNTRY event_link_Country
       FROM               event_dim ed1
                       LEFT OUTER JOIN
                          instructor_event_v ie1
                       ON ed1.event_id = ie1.evxeventid AND ie1.feecode = 'INS'
                    INNER JOIN
                       course_dim cd
                    ON ed1.course_id = cd.course_id
                       AND ed1.ops_country = cd.country
                 LEFT OUTER JOIN
                    event_dim ed2
                 ON     ed1.course_id = ed2.course_id
                    AND ed1.start_date = ed2.start_date
                    AND ed1.start_time = ed2.start_time
                    AND ed1.ops_country != ed2.ops_country
              LEFT OUTER JOIN
                 instructor_event_v ie2
              ON ed2.event_id = ie2.evxeventid AND ie2.feecode = 'INS'
      WHERE       cd.md_num = '20'
              AND ed1.status != 'Cancelled'
              AND NVL (ie1.contactid, 'NONE') = NVL (ie2.contactid, 'NONE')
   --   and exists (select 1 from order_fact f where ed2.event_id = f.event_id and f.enroll_status != 'Cancelled')
   ORDER BY   1, 2;


