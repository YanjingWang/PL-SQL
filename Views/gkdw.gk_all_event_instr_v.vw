DROP VIEW GKDW.GK_ALL_EVENT_INSTR_V;

/* Formatted on 29/01/2021 11:43:05 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ALL_EVENT_INSTR_V
(
   EVENT_ID,
   QG_INSTRUCTORID1,
   CONTACTID1,
   FEECODE1,
   FIRSTNAME1,
   LASTNAME1,
   ACCOUNT1,
   EMAIL1,
   QG_INSTRUCTORID2,
   CONTACTID2,
   FEECODE2,
   FIRSTNAME2,
   LASTNAME2,
   ACCOUNT2,
   EMAIL2,
   QG_INSTRUCTORID3,
   CONTACTID3,
   FEECODE3,
   FIRSTNAME3,
   LASTNAME3,
   ACCOUNT3,
   EMAIL3
)
AS
   SELECT   DISTINCT ed.event_id,
                     ie1.qg_eventinstructorsid qg_instructorid1,
                     ie1.contactid contactid1,
                     UPPER (TRIM (SUBSTR (ie1.feecode, 1, 3))) feecode1,
                     ie1.firstname firstname1,
                     ie1.lastname lastname1,
                     ie1.ACCOUNT account1,
                     ie1.email email1,
                     ie2.qg_eventinstructorsid qg_instructorid2,
                     ie2.contactid contactid2,
                     UPPER (TRIM (SUBSTR (ie2.feecode, 1, 3))) feecode2,
                     ie2.firstname firstname2,
                     ie2.lastname lastname2,
                     ie2.ACCOUNT account2,
                     ie2.email email2,
                     ie3.qg_eventinstructorsid qg_instructorid3,
                     ie3.contactid contactid3,
                     UPPER (TRIM (SUBSTR (ie3.feecode, 1, 3))) feecode3,
                     ie3.firstname firstname3,
                     ie3.lastname lastname3,
                     ie3.ACCOUNT account3,
                     ie3.email email3
     FROM   event_dim ed,
            instructor_event_v ie1,
            instructor_event_v ie2,
            instructor_event_v ie3
    WHERE       ed.instructor1 = ie1.qg_eventinstructorsid(+)
            AND ed.instructor2 = ie2.qg_eventinstructorsid(+)
            AND ed.instructor3 = ie3.qg_eventinstructorsid(+);


