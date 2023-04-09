DROP VIEW GKDW.GK_COURSE_QUOTES_V;

/* Formatted on 29/01/2021 11:39:16 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_QUOTES_V
(
   CREATEDATE,
   OPPORTUNITYID,
   EVXCOURSEID,
   COURSECODE,
   SHORTNAME,
   NUMATTENDEES,
   LISTPRICE,
   STAGE,
   DESCRIPTION,
   CUST_NAME,
   ACCT_NAME,
   ACCOUNTMANAGERID,
   USERNAME,
   TITLE,
   DEPARTMENT,
   DELIVERYCOUNTRY
)
AS
   SELECT   qo.createdate,
            qo.opportunityid,
            qo.evxcourseid,
            c.coursecode,
            c.shortname,
            qo.numattendees,
            qo.listprice,
            o.stage,
            o.description,
            cd.cust_name,
            cd.acct_name,
            o.accountmanagerid,
            ui.username,
            ui.title,
            ui.department,
            UPPER (qo.deliverycountry) deliverycountry
     FROM                  slxdw.qg_oppcourses qo
                        INNER JOIN
                           slxdw.opportunity o
                        ON qo.opportunityid = o.opportunityid
                     INNER JOIN
                        slxdw.opportunity_contact oc
                     ON o.opportunityid = oc.opportunityid
                  INNER JOIN
                     slxdw.evxcourse c
                  ON qo.evxcourseid = c.evxcourseid
               INNER JOIN
                  cust_dim cd
               ON oc.contactid = cd.cust_id
            INNER JOIN
               slxdw.userinfo ui
            ON o.accountmanagerid = ui.userid
    WHERE   qo.createdate >= TRUNC (SYSDATE) - 60 AND o.status = 'Open';


