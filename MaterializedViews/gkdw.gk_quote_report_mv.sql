DROP MATERIALIZED VIEW GKDW.GK_QUOTE_REPORT_MV;
CREATE MATERIALIZED VIEW GKDW.GK_QUOTE_REPORT_MV 
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
/* Formatted on 29/01/2021 12:22:47 (QP5 v5.115.810.9015) */
SELECT   o.opportunityid,
         o.description,
         oc.nettprice price,
         numattendees quantity,
         (oc.assallowpercent * .01) discountpct,
         ( (oc.listprice * oc.numattendees) - oc.nettprice) discount,
         c.coursecode,
         cd.course_pl productline,
         cd.course_mod modality,
         cd.course_ch channel,
         cd.line_of_business,
         cd.course_group,
         o.status,
         o.stage,
         TRUNC (o.createdate) createdate,
         c.coursename,
         c.shortname,
         vendorcode,
         a.accountid,
         a.account,
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
         con.firstname || ' ' || con.lastname cust_name,
         con.email,
         con.workphone,
         ca.city contact_city,
         ca.state contact_state,
         ca.postalcode zip,
         ca.country contact_country,
         con.title contact_title,
         td.dim_week create_week,
         td.dim_month create_month,
         td.dim_year create_year,
         td2.dim_month est_close_month,
         td2.dim_year est_close_year,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               'Field Only'
            WHEN sl.segment = 'Channel'
            THEN
               ui2.division
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'SP 1'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'SP 2'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'SP 2'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               gt.territory_id
            WHEN TO_CHAR (sl.ob_terr) IS NOT NULL
            THEN
               TO_CHAR (sl.ob_terr)
            ELSE
               NVL (NVL (ui.division, gt.territory_id), ui3.division)
         END
            sales_terr_id,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               ui2.username
            WHEN sl.segment = 'Channel'
            THEN
               ui2.username
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'Carl Beardsworth'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Kechia Mackey'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Kechia Mackey'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               gt.salesrep
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (ui.username, ui2.username)
            ELSE
               NVL (NVL (ui.username, gt.salesrep), ui3.username)
         END
            sales_rep,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               um2.username
            WHEN sl.segment = 'Channel'
            THEN
               um2.username
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'Adam VanDamia'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Adam VanDamia'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Adam VanDamia'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               gt.region_mgr
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (um.username, um2.username)
            ELSE
               NVL (NVL (um.username, gt.region_mgr), um3.username)
         END
            sales_manager,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               'Field Only'
            WHEN sl.segment = 'Channel'
            THEN
               'Channel'
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'Strategic Partner'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Strategic Partner'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Strategic Partner'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               'Canada'
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (ui.region, ui2.region)
            ELSE
               NVL (NVL (ui.region, gt.region), ui3.region)
         END
            sales_region,
         td.fiscal_week fscl_create_week,
         td.fiscal_month fscl_create_month,
         td.fiscal_year fscl_create_year,
         td2.fiscal_month fscl_est_close_month,
         td2.fiscal_year fscl_est_close_year
  FROM                                                                        slxdw.opportunity o
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
                                                                  slxdw.address ca
                                                               ON con.addressid =
                                                                     ca.addressid
                                                            INNER JOIN
                                                               slxdw.account a
                                                            ON o.accountid =
                                                                  a.accountid
                                                         INNER JOIN
                                                            slxdw.address ad
                                                         ON a.addressid =
                                                               ad.addressid
                                                      INNER JOIN
                                                         slxdw.evxcourse c
                                                      ON oc.evxcourseid =
                                                            c.evxcourseid
                                                   INNER JOIN
                                                      slxdw.qg_course qc
                                                   ON c.evxcourseid =
                                                         qc.evxcourseid
                                                INNER JOIN
                                                   gkdw.time_dim td
                                                ON TRUNC (o.createdate) =
                                                      td.dim_date
                                             LEFT OUTER JOIN
                                                gkdw.course_dim cd
                                             ON c.evxcourseid = cd.course_id
                                                AND CASE
                                                      WHEN UPPER (ad.country) =
                                                              'CANADA'
                                                      THEN
                                                         'CANADA'
                                                      ELSE
                                                         'USA'
                                                   END = cd.country
                                          LEFT OUTER JOIN
                                             gkdw.time_dim td2
                                          ON TRUNC (o.estimatedclose) =
                                                td2.dim_date
                                       LEFT OUTER JOIN
                                          gk_account_segments_mv sl
                                       ON con.accountid = sl.accountid
                                    LEFT OUTER JOIN
                                       gk_territory gt
                                    ON ca.postalcode BETWEEN gt.zip_start
                                                         AND  gt.zip_end
                                       AND gt.territory_type = 'OB'
                                 LEFT OUTER JOIN
                                    slxdw.userinfo ui
                                 ON ui.userid = NVL (sl.ob_rep_id, gt.userid)
                              --          ON     CASE
                              --                    WHEN sl.ob_terr IS NOT NULL THEN sl.ob_terr
                              --                    ELSE gt.territory_id
                              --                 END = ui.division
                              --             AND (ui.department = 'Outbound' OR ui.region = 'Channel')
                              LEFT OUTER JOIN
                                 slxdw.usersecurity us
                              ON ui.userid = us.userid
                           LEFT OUTER JOIN
                              slxdw.userinfo um
                           ON us.managerid = um.userid
                        LEFT OUTER JOIN
                           slxdw.userinfo ui2
                        ON sl.field_rep_id = ui2.userid
                           AND ui2.region != 'Retired'
                     LEFT OUTER JOIN
                        slxdw.usersecurity us2
                     ON ui2.userid = us2.userid
                  LEFT OUTER JOIN
                     slxdw.userinfo um2
                  ON us2.managerid = um2.userid
               LEFT OUTER JOIN
                  slxdw.userinfo ui3
               ON o.accountmanagerid = ui3.userid AND ui3.region != 'Retired'
            LEFT OUTER JOIN
               slxdw.usersecurity us3
            ON ui2.userid = us3.userid
         LEFT OUTER JOIN
            slxdw.userinfo um3
         ON us3.managerid = um3.userid
 WHERE   oppc.isprimary = 'T' AND td.fiscal_year >= 2015
UNION
SELECT   o.opportunityid,
         o.description,
         op.extendedprice,
         quantity,
         op.discount discountpct,
         op.price * op.discount discount,
         actualid coursecode,
         pd.prod_line,
         pd.prod_modality,
         pd.prod_channel,
         pd.prod_line,
         pd.prod_family,
         o.status,
         o.stage,
         TRUNC (o.createdate) createdate,
         p.product_name coursename,
         p.product_name shortname,
         NULL vendorcode,
         a.accountid,
         a.account,
         ad.address1,
         ad.address2,
         ad.city,
         ad.state,
         ad.postalcode,
         ad.country,
         o.salespotential,
         o.estimatedclose,
         o.closeprobability,
         NULL reqdeliverydate,
         con.contactid,
         con.firstname,
         con.lastname,
         con.firstname || ' ' || con.lastname cust_name,
         con.email,
         con.workphone,
         ca.city contact_city,
         ca.state contact_state,
         ca.postalcode zip,
         ca.country contact_country,
         con.title contact_title,
         td.dim_week create_week,
         td.dim_month create_month,
         td.dim_year create_year,
         td2.dim_month est_close_month,
         td2.dim_year est_close_year,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               'Field Only'
            WHEN sl.segment = 'Channel'
            THEN
               ui2.division
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'SP 1'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'SP 2'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'SP 2'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               gt.territory_id
            WHEN sl.ob_terr IS NOT NULL
            THEN
               sl.ob_terr
            ELSE
               NVL (NVL (ui.division, gt.territory_id), ui3.division)
         END
            sales_terr_id,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               ui2.username
            WHEN sl.segment = 'Channel'
            THEN
               ui2.username
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'Carl Beardsworth'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Kechia Mackey'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Kechia Mackey'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               gt.salesrep
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (ui.username, ui2.username)
            ELSE
               NVL (NVL (ui.username, gt.salesrep), ui3.username)
         END
            sales_rep,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               um2.username
            WHEN sl.segment = 'Channel'
            THEN
               um2.username
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'Adam VanDamia'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Adam VanDamia'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Adam VanDamia'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               gt.region_mgr
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (um.username, um2.username)
            ELSE
               NVL (NVL (um.username, gt.region_mgr), um3.username)
         END
            sales_manager,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               'Field Only'
            WHEN sl.segment = 'Channel'
            THEN
               'Channel'
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'Strategic Partner'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Strategic Partner'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Strategic Partner'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               'Canada'
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (ui.region, ui2.region)
            ELSE
               NVL (NVL (ui.region, gt.region), ui3.region)
         END
            sales_region,
         td.fiscal_week fscl_create_week,
         td.fiscal_month fscl_create_month,
         td.fiscal_year fscl_create_year,
         td2.fiscal_month fscl_est_close_month,
         td2.fiscal_year fscl_est_close_year
  FROM                                                                     slxdw.opportunity o
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
                                                                  slxdw.address ca
                                                               ON con.addressid =
                                                                     ca.addressid
                                                            INNER JOIN
                                                               slxdw.opportunity_product op
                                                            ON o.opportunityid =
                                                                  op.opportunityid
                                                         INNER JOIN
                                                            slxdw.product p
                                                         ON op.productid =
                                                               p.productid
                                                      LEFT OUTER JOIN
                                                         gkdw.product_dim pd
                                                      ON p.productid =
                                                            pd.product_id
                                                   INNER JOIN
                                                      slxdw.account a
                                                   ON o.accountid =
                                                         a.accountid
                                                INNER JOIN
                                                   slxdw.address ad
                                                ON a.addressid = ad.addressid
                                             INNER JOIN
                                                gkdw.time_dim td
                                             ON TRUNC (o.createdate) =
                                                   td.dim_date
                                          LEFT OUTER JOIN
                                             gkdw.time_dim td2
                                          ON TRUNC (o.estimatedclose) =
                                                td2.dim_date
                                       LEFT OUTER JOIN
                                          gk_account_segments_mv sl
                                       ON con.accountid = sl.accountid
                                    LEFT OUTER JOIN
                                       gk_territory gt
                                    ON ca.postalcode BETWEEN gt.zip_start
                                                         AND  gt.zip_end
                                       AND gt.territory_type = 'OB'
                                 LEFT OUTER JOIN
                                    slxdw.userinfo ui
                                 ON ui.userid = NVL (sl.ob_rep_id, gt.userid)
                              --          ON     CASE
                              --                    WHEN sl.ob_terr IS NOT NULL THEN sl.ob_terr
                              --                    ELSE gt.territory_id
                              --                 END = ui.division
                              --             AND (ui.department = 'Outbound' OR ui.region = 'Channel')
                              LEFT OUTER JOIN
                                 slxdw.usersecurity us
                              ON ui.userid = us.userid
                           LEFT OUTER JOIN
                              slxdw.userinfo um
                           ON us.managerid = um.userid
                        LEFT OUTER JOIN
                           slxdw.userinfo ui2
                        ON sl.field_rep_id = ui2.userid
                           AND ui2.region != 'Retired'
                     LEFT OUTER JOIN
                        slxdw.usersecurity us2
                     ON ui2.userid = us2.userid
                  LEFT OUTER JOIN
                     slxdw.userinfo um2
                  ON us2.managerid = um2.userid
               LEFT OUTER JOIN
                  slxdw.userinfo ui3
               ON o.accountmanagerid = ui3.userid AND ui3.region != 'Retired'
            LEFT OUTER JOIN
               slxdw.usersecurity us3
            ON ui2.userid = us3.userid
         LEFT OUTER JOIN
            slxdw.userinfo um3
         ON us3.managerid = um3.userid
 WHERE   oppc.isprimary = 'T' AND td.fiscal_year >= 2015
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
         pd.prod_channel,
         pd.prod_line,
         pd.prod_family,
         o.status,
         o.stage,
         TRUNC (o.createdate) createdate,
         pd.prod_name coursename,
         pd.prod_name shortname,
         NULL vendorcode,
         a.accountid,
         a.account,
         ad.address1,
         ad.address2,
         ad.city,
         ad.state,
         ad.postalcode,
         ad.country,
         o.salespotential,
         o.estimatedclose,
         o.closeprobability,
         NULL reqdeliverydate,
         con.contactid,
         con.firstname,
         con.lastname,
         con.firstname || ' ' || con.lastname cust_name,
         con.email,
         con.workphone,
         ca.city contact_city,
         ca.state contact_state,
         ca.postalcode zip,
         ca.country contact_country,
         con.title contact_title,
         td.dim_week create_week,
         td.dim_month create_month,
         td.dim_year create_year,
         td2.dim_month est_close_month,
         td2.dim_year est_close_year,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               'Field Only'
            WHEN sl.segment = 'Channel'
            THEN
               ui2.division
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'SP 1'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'SP 2'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'SP 2'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               gt.territory_id
            WHEN sl.ob_terr IS NOT NULL
            THEN
               sl.ob_terr
            ELSE
               NVL (NVL (ui.division, gt.territory_id), ui3.division)
         END
            sales_terr_id,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               ui2.username
            WHEN sl.segment = 'Channel'
            THEN
               ui2.username
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'Carl Beardsworth'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Kechia Mackey'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Kechia Mackey'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               gt.salesrep
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (ui.username, ui2.username)
            ELSE
               NVL (NVL (ui.username, gt.salesrep), ui3.username)
         END
            sales_rep,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               um2.username
            WHEN sl.segment = 'Channel'
            THEN
               um2.username
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'Adam VanDamia'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Adam VanDamia'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Adam VanDamia'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               gt.region_mgr
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (um.username, um2.username)
            ELSE
               NVL (NVL (um.username, gt.region_mgr), um3.username)
         END
            sales_manager,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               'Field Only'
            WHEN sl.segment = 'Channel'
            THEN
               'Channel'
            WHEN sl.segment = 'Strategic Partner'
            THEN
               'Strategic Partner'
            WHEN sl.segment IS NULL
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Strategic Partner'
            WHEN     sl.segment = 'Inside'
                 AND sl.field_rep = 'TBD'
                 AND SUBSTR (UPPER (ca.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Strategic Partner'
            WHEN SUBSTR (UPPER (ca.country), 1, 2) = 'CA'
            THEN
               'Canada'
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (ui.region, ui2.region)
            ELSE
               NVL (NVL (ui.region, gt.region), ui3.region)
         END
            sales_region,
         td.fiscal_week fscl_create_week,
         td.fiscal_month fscl_create_month,
         td.fiscal_year fscl_create_year,
         td2.fiscal_month fscl_est_close_month,
         td2.fiscal_year fscl_est_close_year
  FROM                                                                        slxdw.opportunity o
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
                                                                     slxdw.address ca
                                                                  ON con.addressid =
                                                                        ca.addressid
                                                               INNER JOIN
                                                                  slxdw.qg_oppprepay opp
                                                               ON o.opportunityid =
                                                                     opp.opportunityid
                                                            INNER JOIN
                                                               slxdw.evxtppcard tp
                                                            ON opp.evxtppcardid =
                                                                  tp.evxtppcardid
                                                         LEFT JOIN
                                                            slxdw.evxtppcard_tx tpptx
                                                         ON tp.evxtppcardid =
                                                               tpptx.evxtppcardid
                                                      LEFT JOIN
                                                         gkdw.product_dim pd
                                                      ON tpptx.soproductid =
                                                            pd.product_id
                                                   INNER JOIN
                                                      slxdw.account a
                                                   ON o.accountid =
                                                         a.accountid
                                                INNER JOIN
                                                   slxdw.address ad
                                                ON a.addressid = ad.addressid
                                             INNER JOIN
                                                gkdw.time_dim td
                                             ON TRUNC (o.createdate) =
                                                   td.dim_date
                                          LEFT OUTER JOIN
                                             gkdw.time_dim td2
                                          ON TRUNC (o.estimatedclose) =
                                                td2.dim_date
                                       LEFT OUTER JOIN
                                          gk_account_segments_mv sl
                                       ON con.accountid = sl.accountid
                                    LEFT OUTER JOIN
                                       gk_territory gt
                                    ON ca.postalcode BETWEEN gt.zip_start
                                                         AND  gt.zip_end
                                       AND gt.territory_type = 'OB'
                                 LEFT OUTER JOIN
                                    slxdw.userinfo ui
                                 ON ui.userid = NVL (sl.ob_rep_id, gt.userid)
                              --           CASE
                              --                    WHEN sl.ob_terr IS NOT NULL THEN sl.ob_terr
                              --                    ELSE gt.territory_id
                              --                 END = ui.division
                              --             AND (ui.department = 'Outbound' OR ui.region = 'Channel')
                              LEFT OUTER JOIN
                                 slxdw.usersecurity us
                              ON ui.userid = us.userid
                           LEFT OUTER JOIN
                              slxdw.userinfo um
                           ON us.managerid = um.userid
                        LEFT OUTER JOIN
                           slxdw.userinfo ui2
                        ON sl.field_rep_id = ui2.userid
                           AND ui2.region != 'Retired'
                     LEFT OUTER JOIN
                        slxdw.usersecurity us2
                     ON ui2.userid = us2.userid
                  LEFT OUTER JOIN
                     slxdw.userinfo um2
                  ON us2.managerid = um2.userid
               LEFT OUTER JOIN
                  slxdw.userinfo ui3
               ON o.accountmanagerid = ui3.userid AND ui3.region != 'Retired'
            LEFT OUTER JOIN
               slxdw.usersecurity us3
            ON ui2.userid = us3.userid
         LEFT OUTER JOIN
            slxdw.userinfo um3
         ON us3.managerid = um3.userid
 WHERE   oppc.isprimary = 'T' AND td.fiscal_year >= 2015;

COMMENT ON MATERIALIZED VIEW GKDW.GK_QUOTE_REPORT_MV IS 'snapshot table for snapshot GKDW.GK_QUOTE_REPORT_MV';

GRANT SELECT ON GKDW.GK_QUOTE_REPORT_MV TO DWHREAD;

