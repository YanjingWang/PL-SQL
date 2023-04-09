DROP VIEW GKDW.GK_MTM_INSTRUCTOR_V;

/* Formatted on 29/01/2021 11:32:57 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_MTM_INSTRUCTOR_V
(
   EVXEVENTID,
   CONTACTID,
   FIRSTNAME,
   LASTNAME
)
AS
   SELECT   evxeventid,
            contactid,
            firstname,
            lastname
     FROM   instructor_event_v
    WHERE   feecode = 'SS' AND NVL (profilestatus, 'Active') = 'Active'
   UNION
   SELECT   evxeventid,
            contactid,
            firstname,
            lastname
     FROM   instructor_event_v ie1
    WHERE   feecode = 'SI' AND NVL (profilestatus, 'Active') = 'Active'
            AND NOT EXISTS
                  (SELECT   1
                     FROM   instructor_event_v ie2
                    WHERE   ie1.evxeventid = ie2.evxeventid
                            AND feecode = 'SS')
   UNION
   SELECT   evxeventid,
            contactid,
            firstname,
            lastname
     FROM   instructor_event_v ie1
    WHERE   feecode = 'INS' AND NVL (profilestatus, 'Active') = 'Active';


