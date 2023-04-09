DROP VIEW GKDW.GK_OUTBOUND_MOD_PL_V;

/* Formatted on 29/01/2021 11:30:56 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_OUTBOUND_MOD_PL_V
(
   OPPORTUNITYID,
   OPPORTUNITY_NAME,
   PRICE,
   QUANTITY,
   DISCOUNTPCT,
   DISCOUNT,
   COURSECODE,
   PRODUCTLINE,
   MODALITY,
   SALESREP,
   ACCT_MGR,
   MANAGER_NAME,
   STATUS,
   STAGE,
   DEPARTMENT,
   SALESREP_REGION,
   CREATEDATE,
   COURSENAME,
   SHORTNAME,
   VENDORCODE,
   ACCOUNTING_WEEK,
   ACCOUNTING_MONTH,
   ACCOUNTING_YEAR,
   ACCOUNTID,
   ACCOUNT,
   ADDRESS1,
   ADDRESS2,
   CITY,
   STATE,
   ZIP,
   COUNTRY,
   SALESPOTENTIAL,
   ESTIMATEDCLOSE,
   CLOSEPROBABILITY,
   DELIVERYDATE,
   CONTACTID,
   CONTACT_FIRSTNAME,
   CONTACT_LASTNAME,
   EMAIL,
   PHONE,
   REG_90DAYS,
   REG_60DAYS,
   REG_180DAYS,
   EST_CLOSE_MTH,
   EST_CLOSE_YR,
   OB_TERRITORY_NUM
)
AS
   SELECT   o.opportunityid,
            o.description,
            oc.nettprice price,
            numattendees quantity,
            (oc.assallowpercent * .01) discountpct,
            ( (oc.listprice * oc.numattendees) - oc.nettprice) discount,
            c.coursecode,
            cd.course_pl productline,
            cd.course_mod modality,
            u.username salesrep,
            u2.username,
            us.manager_name,
            o.status,
            o.stage,
            u.department,
            u.region,
            o.createdate,
            c.coursename,
            c.shortname,
            vendorcode,
            td.dim_week,
            td.dim_month,
            td.dim_year,
            a.accountid,
            a.ACCOUNT,
            ad.address1,
            ad.address2,
            ad.city,
            ad.state,
            ad.postalcode,
            ad.country,
            o.salespotential,
            o.estimatedclose,
            o.closeprobability,
            oc.reqdeliverydate,
            con.contactid,
            con.firstname,
            con.lastname,
            con.email,
            con.workphone,
            CASE
               WHEN tx.coursecode = c.coursecode
                    AND tx.createdate BETWEEN o.createdate
                                          AND  o.createdate + 90
               THEN
                  1
               ELSE
                  0
            END
               reg_90days,
            CASE
               WHEN tx.coursecode = c.coursecode
                    AND tx.createdate BETWEEN o.createdate
                                          AND  o.createdate + 60
               THEN
                  1
               ELSE
                  0
            END
               reg_60days,
            CASE
               WHEN tx.coursecode = c.coursecode
                    AND tx.createdate BETWEEN o.createdate
                                          AND  o.createdate + 180
               THEN
                  1
               ELSE
                  0
            END
               reg_180days,
            td2.dim_month,
            td2.dim_year,
            qcon.ob_terr_num
     FROM                                                slxdw.opportunity o
                                                      INNER JOIN
                                                         slxdw.qg_oppcourses oc
                                                      ON o.opportunityid =
                                                            oc.opportunityid
                                                   INNER JOIN
                                                      slxdw.opportunity_contact oppc
                                                   ON o.opportunityid =
                                                         oppc.opportunityid
                                                INNER JOIN
                                                   slxdw.contact con
                                                ON oppc.contactid =
                                                      con.contactid
                                             INNER JOIN
                                                slxdw.qg_contact qcon
                                             ON con.contactid =
                                                   qcon.contactid
                                          INNER JOIN
                                             slxdw.userinfo u
                                          ON o.createuser = u.userid
                                       INNER JOIN
                                          slxdw.userinfo u2
                                       ON o.accountmanagerid = u2.userid
                                    INNER JOIN
                                       slxdw.usersecurity us
                                    ON u.userid = us.userid
                                 INNER JOIN
                                    slxdw.ACCOUNT a
                                 ON o.accountid = a.accountid
                              INNER JOIN
                                 slxdw.address ad
                              ON a.addressid = ad.addressid
                           INNER JOIN
                              slxdw.evxcourse c
                           ON oc.evxcourseid = c.evxcourseid
                        INNER JOIN
                           slxdw.qg_course qc
                        ON c.evxcourseid = qc.evxcourseid
                     INNER JOIN
                        gkdw.time_dim td
                     ON TRUNC (o.createdate) = td.dim_date
                  LEFT OUTER JOIN
                     gkdw.course_dim cd
                  ON c.evxcourseid = cd.course_id
               LEFT OUTER JOIN
                  slxdw.oracletx_history tx
               ON     oppc.contactid = tx.attendeecontactid
                  AND tx.coursecode = c.coursecode
                  AND tx.createdate >= o.createdate
            LEFT OUTER JOIN
               gkdw.time_dim td2
            ON TRUNC (o.estimatedclose) = td2.dim_date
    WHERE   oppc.isprimary = 'T'
   --AND cd.country = 'USA' -- commented out on 4/13/11
   UNION ALL
   SELECT   o.opportunityid,
            o.description,
            op.extendedprice,
            quantity,
            op.discount discountpct,
            op.price * op.discount discount,
            actualid coursecode,
            pd.prod_line,
            pd.prod_modality,
            u.username salesrep,
            u2.username,
            us.manager_name,
            o.status,
            o.stage,
            u.department,
            u.region,
            o.createdate,
            p.product_name coursename,
            p.product_name shortname,
            NULL,
            td.dim_week,
            td.dim_month,
            td.dim_year,
            a.accountid,
            a.ACCOUNT,
            ad.address1,
            ad.address2,
            ad.city,
            ad.state,
            ad.postalcode,
            ad.country,
            o.salespotential,
            o.estimatedclose,
            o.closeprobability,
            NULL,
            con.contactid,
            con.firstname,
            con.lastname,
            con.email,
            con.workphone,
            NULL,
            NULL,
            NULL,
            td2.dim_month,
            td2.dim_year,
            qcon.ob_terr_num
     FROM                                          slxdw.opportunity o
                                                INNER JOIN
                                                   slxdw.opportunity_contact oppc
                                                ON o.opportunityid =
                                                      oppc.opportunityid
                                             INNER JOIN
                                                slxdw.contact con
                                             ON oppc.contactid =
                                                   con.contactid
                                          INNER JOIN
                                             slxdw.qg_contact qcon
                                          ON con.contactid = qcon.contactid
                                       INNER JOIN
                                          slxdw.opportunity_product op
                                       ON o.opportunityid = op.opportunityid
                                    INNER JOIN
                                       slxdw.product p
                                    ON op.productid = p.productid
                                 LEFT OUTER JOIN
                                    gkdw.product_dim pd
                                 ON p.productid = pd.product_id
                              INNER JOIN
                                 slxdw.userinfo u
                              ON o.createuser = u.userid
                           INNER JOIN
                              slxdw.userinfo u2
                           ON o.accountmanagerid = u2.userid
                        INNER JOIN
                           slxdw.usersecurity us
                        ON u.userid = us.userid
                     INNER JOIN
                        slxdw.ACCOUNT a
                     ON o.accountid = a.accountid
                  INNER JOIN
                     slxdw.address ad
                  ON a.addressid = ad.addressid
               INNER JOIN
                  gkdw.time_dim td
               ON TRUNC (o.createdate) = td.dim_date
            LEFT OUTER JOIN
               gkdw.time_dim td2
            ON TRUNC (o.estimatedclose) = td2.dim_date
    WHERE   oppc.isprimary = 'T'
   UNION
   SELECT   o.opportunityid,
            o.description,
            opp.nettprice,
            opp.quantity quantity,
            opp.discountpercent discountpct,
            (opp.nettprice * opp.discountpercent) discount,
            pd.prod_num coursecode,
            pd.prod_line,
            pd.prod_modality,
            u.username salesrep,
            u2.username,
            us.manager_name,
            o.status,
            --tp.EVXTPPCARDID,
            o.stage,
            u.department,
            u.region,
            o.createdate,
            pd.prod_name coursename,
            pd.prod_name shortname,
            NULL,
            td.dim_week,
            td.dim_month,
            td.dim_year,
            a.accountid,
            a.ACCOUNT,
            ad.address1,
            ad.address2,
            ad.city,
            ad.state,
            ad.postalcode,
            ad.country,
            o.salespotential,
            o.estimatedclose,
            o.closeprobability,
            NULL,
            con.contactid,
            con.firstname,
            con.lastname,
            con.email,
            con.workphone,
            NULL,
            NULL,
            NULL,
            td2.dim_month,
            td2.dim_year,
            qcon.ob_terr_num
     FROM                                             slxdw.opportunity o
                                                   INNER JOIN
                                                      slxdw.opportunity_contact oppc
                                                   ON o.opportunityid =
                                                         oppc.opportunityid
                                                INNER JOIN
                                                   slxdw.contact con
                                                ON oppc.contactid =
                                                      con.contactid
                                             INNER JOIN
                                                slxdw.qg_contact qcon
                                             ON con.contactid =
                                                   qcon.contactid
                                          INNER JOIN
                                             slxdw.qg_oppprepay opp
                                          ON o.opportunityid =
                                                opp.opportunityid
                                       INNER JOIN
                                          slxdw.evxtppcard tp
                                       ON opp.evxtppcardid = tp.evxtppcardid
                                    LEFT JOIN
                                       slxdw.evxtppcard_tx tpptx
                                    ON tp.evxtppcardid = tpptx.evxtppcardid
                                 LEFT JOIN
                                    gkdw.product_dim pd
                                 ON tpptx.soproductid = pd.product_id
                              INNER JOIN
                                 slxdw.userinfo u
                              ON o.createuser = u.userid
                           INNER JOIN
                              slxdw.userinfo u2
                           ON o.accountmanagerid = u2.userid
                        INNER JOIN
                           slxdw.usersecurity us
                        ON u.userid = us.userid
                     INNER JOIN
                        slxdw.ACCOUNT a
                     ON o.accountid = a.accountid
                  INNER JOIN
                     slxdw.address ad
                  ON a.addressid = ad.addressid
               INNER JOIN
                  gkdw.time_dim td
               ON TRUNC (o.createdate) = td.dim_date
            LEFT OUTER JOIN
               gkdw.time_dim td2
            ON TRUNC (o.estimatedclose) = td2.dim_date
    WHERE   oppc.isprimary = 'T'
   ORDER BY   opportunityid;


