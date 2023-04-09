DROP VIEW GKDW.GK_COURSE_QUOTES_QA_V;

/* Formatted on 29/01/2021 11:39:20 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_QUOTES_QA_V
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
   CUST_ID,
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
            c.course_code coursecode,
            c.short_name shortname,
            qo.numattendees,
            qo.listprice,
            o.stage,
            o.description,
            cd.cust_id,
            cd.cust_name,
            cd.acct_name,
            o.accountmanagerid,
            ui.username,
            ui.title,
            ui.department,
            UPPER (qo.deliverycountry) deliverycountry
     FROM   qg_oppcourses@slxqa qo,
            opportunity@slxqa o,
            opportunity_contact@slxqa oc,
            cust_dim cd,
            course_dim c,
            userinfo@slxqa ui
    WHERE       qo.opportunityid = o.opportunityid
            AND o.opportunityid = oc.opportunityid
            AND oc.contactid = cd.cust_id
            AND qo.evxcourseid = c.course_id
            AND UPPER (qo.deliverycountry) = c.country
            AND o.accountmanagerid = ui.userid
            AND qo.createdate >= TRUNC (SYSDATE) - 60
            AND o.status = 'Open'
            AND c.ch_num = '10';


