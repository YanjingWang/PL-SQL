DROP MATERIALIZED VIEW GKDW.GK_ALL_EVENT_INSTR_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ALL_EVENT_INSTR_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
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
/* Formatted on 29/01/2021 12:19:45 (QP5 v5.115.810.9015) */
SELECT   DISTINCT ed.event_id,
                  ie1.qg_eventinstructorsid qg_instructorid1,
                  ie1.contactid contactid1,
                  UPPER (TRIM (SUBSTR (ie1.feecode, 1, 3))) feecode1,
                  ie1.firstname firstname1,
                  ie1.lastname lastname1,
                  ie1.account account1,
                  ie1.email email1,
                  ie2.qg_eventinstructorsid qg_instructorid2,
                  ie2.contactid contactid2,
                  UPPER (TRIM (SUBSTR (ie2.feecode, 1, 3))) feecode2,
                  ie2.firstname firstname2,
                  ie2.lastname lastname2,
                  ie2.account account2,
                  ie2.email email2,
                  ie3.qg_eventinstructorsid qg_instructorid3,
                  ie3.contactid contactid3,
                  UPPER (TRIM (SUBSTR (ie3.feecode, 1, 3))) feecode3,
                  ie3.firstname firstname3,
                  ie3.lastname lastname3,
                  ie3.account account3,
                  ie3.email email3
  FROM   event_dim ed,
         instructor_event_v ie1,
         instructor_event_v ie2,
         instructor_event_v ie3
 WHERE       ed.instructor1 = ie1.qg_eventinstructorsid(+)
         AND ed.instructor2 = ie2.qg_eventinstructorsid(+)
         AND ed.instructor3 = ie3.qg_eventinstructorsid(+);

COMMENT ON MATERIALIZED VIEW GKDW.GK_ALL_EVENT_INSTR_MV IS 'snapshot table for snapshot GKDW.GK_ALL_EVENT_INSTR_MV';

GRANT SELECT ON GKDW.GK_ALL_EVENT_INSTR_MV TO COGNOS_RO;

GRANT SELECT ON GKDW.GK_ALL_EVENT_INSTR_MV TO DWHREAD;

GRANT SELECT ON GKDW.GK_ALL_EVENT_INSTR_MV TO EXCEL_RO;

GRANT SELECT ON GKDW.GK_ALL_EVENT_INSTR_MV TO PORTAL;

