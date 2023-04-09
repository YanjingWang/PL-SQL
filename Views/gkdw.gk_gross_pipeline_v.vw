DROP VIEW GKDW.GK_GROSS_PIPELINE_V;

/* Formatted on 29/01/2021 11:35:34 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GROSS_PIPELINE_V
(
   OPPORTUNITYID,
   ACCOUNTID,
   ACCOUNT,
   DESCRIPTION,
   STAGE,
   CLOSEPROBABILITY,
   OPP_STATUS,
   OPP_STAGE,
   ENT_POTENTIAL_AMOUNT,
   SALESPOTENTIAL,
   SALESPROCESS_NAME,
   USERNAME,
   USER_MANAGER,
   DEPARTMENT,
   SALES_GROUP,
   SALES_TEAM,
   OPP_CREATE_DATE,
   DIM_YEAR,
   DIM_QUARTER,
   DIM_MONTH_NUM,
   DIM_PERIOD_NAME,
   DIM_WEEK,
   EST_CLOSE_DATE,
   ROLLING_3_MO,
   ROLLING_12_MO,
   BOOK_AMT,
   GROSS_PIPELINE,
   CLOSE_GE_50,
   CLOSE_GE_70,
   LOB,
   SECTOR,
   SUBSECTOR,
   WEIGHTED_AMT,
   AGE,
   AGE_CATEGORY,
   UNWEIGHTED_CATEGORY,
   WEIGHTED_CATEGORY
)
AS
   SELECT   o.opportunityid,
            o.accountid,
            ac.ACCOUNT,
            o.description,
            o.stage,
            LPAD (NVL (spa.probability, 0), 3, '0') || '%' closeprobability,
            o.status opp_status,
               LPAD (NVL (spa.stageorder, '99'), 2, '0')
            || '-'
            || spa.stagename
            || '('
            || spa.probability
            || '%)'
               opp_stage,
            NVL (qo.ent_potential_amount, 0) ent_potential_amount,
            NVL (salespotential, 0) salespotential,
            sp.NAME salesprocess_name,
            ui1.username,
            um.username user_manager,
            ui1.department,
            ui1.region sales_group,
            ui1.division sales_team,
            o.createdate opp_create_date,
            td.dim_year,
            CASE
               WHEN td.dim_year IS NULL THEN NULL
               ELSE td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0')
            END
               dim_quarter,
            CASE
               WHEN td.dim_year IS NULL THEN NULL
               ELSE td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0')
            END
               dim_month_num,
            td.dim_period_name,
            CASE
               WHEN td.dim_year IS NULL THEN NULL
               ELSE td.dim_year || '-' || LPAD (td.dim_week, 2, '0')
            END
               dim_week,
            TRUNC (o.estimatedclose) est_close_date,
            CASE
               WHEN td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') BETWEEN td2.dim_year
                                                                                  || '-'
                                                                                  || LPAD (
                                                                                        td2.dim_month_num,
                                                                                        2,
                                                                                        '0'
                                                                                     )
                                                                              AND  td3.dim_year
                                                                                   || '-'
                                                                                   || LPAD (
                                                                                         td3.dim_month_num,
                                                                                         2,
                                                                                         '0'
                                                                                      )
               THEN
                  'Y'
               ELSE
                  'N'
            END
               rolling_3_mo,
            CASE
               WHEN td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') BETWEEN td2.dim_year
                                                                                  || '-'
                                                                                  || LPAD (
                                                                                        td2.dim_month_num,
                                                                                        2,
                                                                                        '0'
                                                                                     )
                                                                              AND  td4.dim_year
                                                                                   || '-'
                                                                                   || LPAD (
                                                                                         td4.dim_month_num,
                                                                                         2,
                                                                                         '0'
                                                                                      )
               THEN
                  'Y'
               ELSE
                  'N'
            END
               rolling_12_mo,
            ob.book_amt,
            CASE
               WHEN qo.ent_potential_amount IS NULL
               THEN
                  NVL (o.salespotential, 0)
               WHEN qo.ent_potential_amount = 0
               THEN
                  NVL (o.salespotential, 0)
               ELSE
                  qo.ent_potential_amount
            END
               gross_pipeline,
            --       nvl(qo.ent_potential_amount,o.salespotential) gross_pipeline,
            CASE WHEN spa.probability >= 50 THEN 'Y' ELSE 'N' END close_ge_50,
            CASE WHEN spa.probability >= 70 THEN 'Y' ELSE 'N' END close_ge_70,
            qo.knowledge_center LOB,
            qa.sector,
            qa.subsector,
            (o.salespotential * spa.probability) / 100 weighted_amt,
            TRUNC (SYSDATE) - TRUNC (o.createdate) + 1 age,
            CASE
               WHEN TRUNC (SYSDATE) - TRUNC (o.createdate) + 1 <= 30
               THEN
                  '30'
               WHEN TRUNC (SYSDATE) - TRUNC (o.createdate) + 1 <= 60
               THEN
                  '60'
               WHEN TRUNC (SYSDATE) - TRUNC (o.createdate) + 1 <= 90
               THEN
                  '90'
               WHEN TRUNC (SYSDATE) - TRUNC (o.createdate) + 1 <= 120
               THEN
                  '120'
               WHEN TRUNC (SYSDATE) - TRUNC (o.createdate) + 1 > 120
               THEN
                  '120+'
            END
               age_category,
            CASE
               WHEN o.salespotential < 2000 THEN '$0-1999'
               WHEN o.salespotential < 10000 THEN '$2000-9999'
               WHEN o.salespotential < 20000 THEN '$10000-19999'
               WHEN o.salespotential < 40000 THEN '$20000-39999'
               WHEN o.salespotential < 50000 THEN '$40000-49999'
               WHEN o.salespotential >= 50000 THEN '$50000+'
            END
               unweighted_category,
            CASE
               WHEN (o.salespotential * spa.probability) / 100 < 2000
               THEN
                  '$0-1999'
               WHEN (o.salespotential * spa.probability) / 100 < 10000
               THEN
                  '$2000-9999'
               WHEN (o.salespotential * spa.probability) / 100 < 20000
               THEN
                  '$10000-19999'
               WHEN (o.salespotential * spa.probability) / 100 < 40000
               THEN
                  '$20000-39999'
               WHEN (o.salespotential * spa.probability) / 100 < 50000
               THEN
                  '$40000-49999'
               WHEN (o.salespotential * spa.probability) / 100 >= 50000
               THEN
                  '$50000+'
            END
               weighted_category
     --       case when nvl(qo.ent_potential_amount,0)-nvl(ob.book_amt,0) < 0 then 0
     --            else nvl(qo.ent_potential_amount,0)-nvl(ob.book_amt,0)
     --       end gross_pipeline
     FROM                                          slxdw.opportunity o
                                                INNER JOIN
                                                   slxdw.qg_opportunity qo
                                                ON o.opportunityid =
                                                      qo.opportunityid
                                             INNER JOIN
                                                slxdw.userinfo ui1
                                             ON o.accountmanagerid =
                                                   ui1.userid
                                          INNER JOIN
                                             slxdw.usersecurity us
                                          ON ui1.userid = us.userid
                                       INNER JOIN
                                          slxdw.userinfo um
                                       ON us.managerid = um.userid
                                    INNER JOIN
                                       slxdw.ACCOUNT ac
                                    ON o.accountid = ac.accountid
                                 INNER JOIN
                                    slxdw.qg_account qa
                                 ON ac.accountid = qa.accountid
                              LEFT OUTER JOIN
                                 time_dim td
                              ON TRUNC (o.estimatedclose) = td.dim_date
                           LEFT OUTER JOIN
                              slxdw.salesprocesses sp
                           ON o.opportunityid = sp.entityid
                        LEFT OUTER JOIN
                           slxdw.salesprocessaudit spa
                        ON sp.salesprocessesid = spa.salesprocessid
                           AND o.stage =
                                 spa.stageorder || '-' || spa.stagename
                           AND spa.processtype = 'STAGE'
                     INNER JOIN
                        time_dim td2
                     ON td2.dim_date = TRUNC (SYSDATE)
                  INNER JOIN
                     time_dim td3
                  ON td3.dim_date = TRUNC (SYSDATE) + 90
               INNER JOIN
                  time_dim td4
               ON td4.dim_date = TRUNC (SYSDATE) + 365
            LEFT OUTER JOIN
               gk_opp_bookings_v ob
            ON o.opportunityid = ob.opportunityid
    WHERE       td.dim_year >= 2009
            AND o.status = 'Open'
            AND UPPER (ui1.department) LIKE '%ENTERPRISE%';


GRANT SELECT ON GKDW.GK_GROSS_PIPELINE_V TO COGNOS_RO;

