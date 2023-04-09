DROP VIEW GKDW.INSTRUCTOR_EVENT_SLX_V;

/* Formatted on 29/01/2021 11:23:45 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.INSTRUCTOR_EVENT_SLX_V
(
   QG_EVENTINSTRUCTORSID,
   EVXEVENTID,
   CONTACTID,
   FEECODE,
   FIRSTNAME,
   LASTNAME,
   ACCOUNT,
   TITLE,
   PROFILESTATUS,
   PROFILETYPE
)
AS
   SELECT   DISTINCT qg_eventinstructorsid,
                     evxeventid,
                     qe.contactid,
                     feecode,
                     c.firstname,
                     c.lastname,
                     c.ACCOUNT,
                     c.title,
                     qp.profilestatus,
                     /*
                     (case
                      when qp.PROFILETYPE  in ('GK Instructor', 'Instructor')
                      then qp.PROFILETYPE
                      else null
                      end
                      ) */
                     qp.profiletype
     FROM   qg_eventinstructors@slx qe, contact@slx c, qg_profiletype@slx qp
    WHERE   qe.contactid = c.contactid AND qe.contactid = qp.contactid(+);


