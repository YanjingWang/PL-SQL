DROP VIEW GKDW.INSTRUCTOR_EVENT_V_TEST;

/* Formatted on 29/01/2021 11:23:37 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.INSTRUCTOR_EVENT_V_TEST
(
   QG_EVENTINSTRUCTORSID,
   EVXEVENTID,
   CONTACTID,
   FEECODE,
   FIRSTNAME,
   LASTNAME,
   ACCOUNT,
   TITLE,
   ACCOUNTID,
   PROFILESTATUS,
   PROFILETYPE,
   EMAIL
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
                     c.accountid,
                     NVL (qp.profilestatus, 'Active') profilestatus,
                     qp.profiletype,
                     c.email
     FROM         (SELECT   feecode,
                            evxeventid,
                            qg_eventinstructorsid,
                            contactid
                     FROM   qg_eventinstructors@slxqa) qe
               INNER JOIN
                  slxdw.contact c
               ON qe.contactid = c.contactid
            LEFT OUTER JOIN
               slxdw.qg_accprofiletype qp
            ON c.accountid = qp.accountid;


