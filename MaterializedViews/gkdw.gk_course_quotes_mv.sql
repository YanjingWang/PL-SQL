DROP MATERIALIZED VIEW GKDW.GK_COURSE_QUOTES_MV;
CREATE MATERIALIZED VIEW GKDW.GK_COURSE_QUOTES_MV 
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
/* Formatted on 29/01/2021 12:25:32 (QP5 v5.115.810.9015) */
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
  FROM                  slxdw.qg_oppcourses qo
                     INNER JOIN
                        slxdw.opportunity o
                     ON qo.opportunityid = o.opportunityid
                  INNER JOIN
                     slxdw.opportunity_contact oc
                  ON o.opportunityid = oc.opportunityid
               INNER JOIN
                  cust_dim cd
               ON oc.contactid = cd.cust_id
            INNER JOIN
               course_dim c
            ON qo.evxcourseid = c.course_id
               AND UPPER (qo.deliverycountry) = c.country
         INNER JOIN
            slxdw.userinfo ui
         ON o.accountmanagerid = ui.userid
 WHERE   qo.createdate >= TO_DATE ('01/01/2007', 'mm/dd/yyyy');

COMMENT ON MATERIALIZED VIEW GKDW.GK_COURSE_QUOTES_MV IS 'snapshot table for snapshot GKDW.GK_COURSE_QUOTES_MV';

GRANT SELECT ON GKDW.GK_COURSE_QUOTES_MV TO DWHREAD;

