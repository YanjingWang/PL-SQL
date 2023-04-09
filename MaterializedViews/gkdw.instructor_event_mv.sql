DROP MATERIALIZED VIEW GKDW.INSTRUCTOR_EVENT_MV;
CREATE MATERIALIZED VIEW GKDW.INSTRUCTOR_EVENT_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:20:53 (QP5 v5.115.810.9015) */
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
  FROM         slxdw.qg_eventinstructors qe
            INNER JOIN
               slxdw.contact c
            ON qe.contactid = c.contactid
         LEFT OUTER JOIN
            slxdw.qg_accprofiletype qp
         ON c.accountid = qp.accountid;

COMMENT ON MATERIALIZED VIEW GKDW.INSTRUCTOR_EVENT_MV IS 'snapshot table for snapshot GKDW.INSTRUCTOR_EVENT_MV';

GRANT SELECT ON GKDW.INSTRUCTOR_EVENT_MV TO DWHREAD;

