DROP VIEW GKDW.GK_FDC_ATTENDEE_CHANGE_V;

/* Formatted on 29/01/2021 11:36:08 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_FDC_ATTENDEE_CHANGE_V
(
   GK_ONSITEREQ_FDCID,
   CREATEDATE,
   NEW_NUMATTENDEES
)
AS
   SELECT   f1.gk_onsitereq_fdcid, f1.createdate, f1.new_numattendees
     FROM   slxdw.gk_onsitereq_fdcchange f1
    WHERE   f1.numattendees_change = 'Y'
            AND f1.createdate =
                  (SELECT   MAX (createdate)
                     FROM   slxdw.gk_onsitereq_fdcchange f2
                    WHERE   f1.gk_onsitereq_fdcid = f2.gk_onsitereq_fdcid);


