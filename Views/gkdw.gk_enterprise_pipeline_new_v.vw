DROP VIEW GKDW.GK_ENTERPRISE_PIPELINE_NEW_V;

/* Formatted on 29/01/2021 11:37:30 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ENTERPRISE_PIPELINE_NEW_V
(
   OPPORTUNITYID,
   CREATEDATE,
   USERNAME,
   USER_MANAGER,
   SALES_GROUP,
   DESCRIPTION,
   ACCOUNT,
   ESTIMATEDCLOSE,
   SALESPOTENTIAL,
   CLOSEPROBABILITY,
   OPP_STATUS,
   OPP_CREATE_DATE,
   MODIFYDATE,
   SALESPROCESS_TYPE,
   STAGE,
   COURSETYPE,
   COURSECODE,
   COURSENAME,
   NUMATTENDEES,
   NETTPRICE,
   POTENTIALCLOSEDATE,
   CURR_IDR_STATUS,
   PROGRAM_MANAGER,
   MANAGED_PROG_ID,
   CURR_FDC_STATUS,
   REQDELIVERYDATE,
   SUBMITDATE,
   EVXEVENTID,
   EVENTNAME,
   EVENTSTATUS,
   EVENTTYPE,
   EVENT_COURSECODE,
   STARTDATE,
   ENDDATE,
   EVENTLOCATIONDESC,
   EVENT_REV_AMT,
   DIM_YEAR,
   DIM_QUARTER,
   DIM_MONTH_NUM,
   DIM_PERIOD_NAME,
   DIM_WEEK,
   ROLLING_6_MO
)
AS
     SELECT   a1.opportunityid,
              a1.createdate,
              ui1.username,
              um.username user_manager,
              ui1.department sales_group,
              a1.description
              || CASE
                    WHEN ec2.coursecode IS NOT NULL
                    THEN
                       ' (' || ec2.coursecode || ')'
                    ELSE
                       NULL
                 END
                 description,
              a2.ACCOUNT,
              a1.estimatedclose,
              a1.salespotential,
              NVL (a1.closeprobability, 0) closeprobability,
              a1.status opp_status,
              a1.createdate opp_create_date,
              a1.modifydate,
              a4.NAME salesprocess_type,
              a1.stage || ' (' || NVL (a1.closeprobability, 0) || ')' stage,
              so.coursetype,
              CASE
                 WHEN ec.coursecode IS NULL
                 THEN
                    so.product_line || ' ' || so.ns_course_desc_disp
                 ELSE
                    ec.coursecode
              END
                 coursecode,
              CASE
                 WHEN ec.coursename IS NULL AND a5.nettprice IS NOT NULL
                 THEN
                    so.description
                 ELSE
                    ec.coursename
              END
                 coursename,
              so.numattendees,
              so.nettprice nettprice,
              a5.potentialclosedate,
              so.curr_idr_status,
              idr.program_manager,
              idr.managed_prog_id,
              idr.curr_fdc_status,
              a5.reqdeliverydate reqdeliverydate,
              fdc.submitdate,
              ev.evxeventid,
              ev.eventname,
              ev.eventstatus,
              ev.eventtype,
              ev.coursecode event_coursecode,
              ev.startdate,
              ev.enddate,
              ev.eventlocationdesc,
              SUM (f.book_amt) event_rev_amt,
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
                 rolling_6_mo
       FROM                                                      slxdw.opportunity a1
                                                              INNER JOIN
                                                                 slxdw.userinfo ui1
                                                              ON a1.accountmanagerid =
                                                                    ui1.userid
                                                           INNER JOIN
                                                              slxdw.usersecurity us
                                                           ON ui1.userid =
                                                                 us.userid
                                                        INNER JOIN
                                                           slxdw.userinfo um
                                                        ON us.managerid =
                                                              um.userid
                                                     INNER JOIN
                                                        slxdw.ACCOUNT a2
                                                     ON a1.accountid =
                                                           a2.accountid
                                                  LEFT OUTER JOIN
                                                     slxdw.qg_account a3
                                                  ON a2.accountid =
                                                        a3.accountid
                                               LEFT OUTER JOIN
                                                  qg_oppcourses@slx a5
                                               ON a1.opportunityid =
                                                     a5.opportunityid
                                            LEFT OUTER JOIN
                                               slxdw.evxcourse ec2
                                            ON a5.evxcourseid = ec2.evxcourseid
                                         LEFT OUTER JOIN
                                            time_dim td
                                         ON TRUNC (a1.estimatedclose) =
                                               td.dim_date
                                      LEFT OUTER JOIN
                                         slxdw.gk_sales_opportunity so
                                      ON a5.gk_sales_opportunityid =
                                            so.gk_sales_opportunityid
                                   LEFT OUTER JOIN
                                      slxdw.evxcourse ec
                                   ON so.evxcourseid = ec.evxcourseid
                                LEFT OUTER JOIN
                                   slxdw.gk_onsitereq_idr idr
                                ON so.current_idr = idr.gk_onsitereq_idrid
                             LEFT OUTER JOIN
                                slxdw.gk_onsitereq_fdc fdc
                             ON idr.current_fdc = fdc.gk_onsitereq_fdcid
                          LEFT OUTER JOIN
                             slxdw.evxevent ev
                          ON so.gk_sales_opportunityid = ev.opportunityid
                       LEFT OUTER JOIN
                          slxdw.salesprocesses a4
                       ON a1.opportunityid = a4.entityid
                    LEFT OUTER JOIN
                       order_fact f
                    ON ev.evxeventid = f.event_id
                 INNER JOIN
                    time_dim td2
                 ON td2.dim_date = TRUNC (SYSDATE)
              INNER JOIN
                 time_dim td3
              ON td3.dim_date = TRUNC (SYSDATE) + 180
      WHERE   a1.createdate >= '01-JAN-2009'
              AND UPPER (ui1.department) LIKE '%ENTERPRISE%'
   GROUP BY   a1.opportunityid,
              ui1.username,
              um.username,
              ui1.department,
              a1.description,
              a2.ACCOUNT,
              a1.estimatedclose,
              a1.salespotential,
              NVL (a1.closeprobability, 0),
              a1.status,
              a1.createdate,
              a1.modifydate,
              a4.NAME,
              a1.stage,
              so.coursetype,
              CASE
                 WHEN ec.coursecode IS NULL
                 THEN
                    so.product_line || ' ' || so.ns_course_desc_disp
                 ELSE
                    ec.coursecode
              END,
              CASE
                 WHEN ec.coursename IS NULL AND a5.nettprice IS NOT NULL
                 THEN
                    so.description
                 ELSE
                    ec.coursename
              END,
              so.numattendees,
              so.nettprice,
              a5.potentialclosedate,
              so.curr_idr_status,
              idr.program_manager,
              idr.managed_prog_id,
              idr.curr_fdc_status,
              a5.reqdeliverydate,
              fdc.submitdate,
              ev.evxeventid,
              ev.eventname,
              ev.eventstatus,
              ev.eventtype,
              ev.coursecode,
              ev.startdate,
              ev.enddate,
              ev.eventlocationdesc,
              td.dim_year,
              td.dim_month_num,
              td.dim_quarter,
              td.dim_period_name,
              td.dim_week,
              ec2.coursecode,
              td2.dim_year || '-' || LPAD (td2.dim_month_num, 2, '0'),
              td3.dim_year || '-' || LPAD (td3.dim_month_num, 2, '0')
   UNION
     SELECT   a1.opportunityid,
              a1.createdate,
              ui1.username,
              um.username user_manager,
              ui1.department sales_group,
              a1.description,
              a2.ACCOUNT,
              a1.estimatedclose,
              a1.salespotential,
              NVL (a1.closeprobability, 0) closeprobability,
              a1.status opp_status,
              a1.createdate,
              a1.modifydate,
              NULL salesprocess_type,
              a1.stage || ' (' || NVL (a1.closeprobability, 0) || ')' stage,
              cd.course_type,
              cd.course_code,
              cd.course_name,
              NULL numattendeees,
              NULL nettprice,
              NULL potentialclosedate,
              NULL curr_idr_status,
              NULL program_manager,
              NULL managed_prog_id,
              NULL curr_fdc_status,
              NULL reqdeliverydate,
              NULL submitdate,
              ed.event_id evxeventid,
              ed.event_name eventname,
              ed.status eventstatus,
              ed.event_type eventtype,
              ed.course_code coursecode,
              ed.start_date startdate,
              ed.end_date enddate,
              ed.location_name eventlocationdesc,
              SUM (NVL (f.book_amt, 0)) event_rev_amt,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              'N'
       FROM                        slxdw.opportunity a1
                                INNER JOIN
                                   slxdw.userinfo ui1
                                ON a1.accountmanagerid = ui1.userid
                             INNER JOIN
                                slxdw.usersecurity us
                             ON ui1.userid = us.userid
                          INNER JOIN
                             slxdw.userinfo um
                          ON us.managerid = um.userid
                       INNER JOIN
                          slxdw.ACCOUNT a2
                       ON a1.accountid = a2.accountid
                    INNER JOIN
                       order_fact f
                    ON a1.opportunityid = f.opportunity_id
                 INNER JOIN
                    event_dim ed
                 ON f.event_id = ed.event_id
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   a1.createdate >= '01-JAN-2009'       --   and a1.status = 'Open'
                                        --   and fee_type in ('Primary','GSA')
              AND UPPER (ui1.department) LIKE '%ENTERPRISE%'
   GROUP BY   a1.opportunityid,
              ui1.username,
              um.username,
              ui1.department,
              a1.description,
              a2.ACCOUNT,
              a1.estimatedclose,
              a1.salespotential,
              NVL (a1.closeprobability, 0),
              a1.status,
              a1.createdate,
              a1.modifydate,
              a1.stage,
              cd.course_type,
              cd.course_code,
              cd.course_name,
              ed.event_id,
              ed.event_name,
              ed.status,
              ed.event_type,
              ed.course_code,
              ed.start_date,
              ed.end_date,
              ed.location_name
   UNION
     SELECT   a1.opportunityid,
              a1.createdate,
              ui1.username,
              um.username user_manager,
              ui1.department sales_group,
              a1.description,
              a2.ACCOUNT,
              a1.estimatedclose,
              a1.salespotential,
              NVL (a1.closeprobability, 0) closeprobability,
              a1.status opp_status,
              a1.createdate,
              a1.modifydate,
              NULL salesprocess_type,
              a1.stage || ' (' || NVL (a1.closeprobability, 0) || ')' stage,
              f.record_type,
              pd.prod_num,
              pd.prod_name,
              NULL numattendeees,
              NULL nettprice,
              NULL potentialclosedate,
              NULL curr_idr_status,
              NULL program_manager,
              NULL managed_prog_id,
              NULL curr_fdc_status,
              NULL reqdeliverydate,
              NULL submitdate,
              f.product_id,
              pd.prod_name,
              f.so_status,
              f.record_type,
              pd.prod_num,
              TRUNC (f.creation_date),
              TRUNC (f.creation_date),
              'PRODUCT',
              SUM (NVL (f.book_amt, 0)) event_rev_amt,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              'N'
       FROM                     slxdw.opportunity a1
                             INNER JOIN
                                slxdw.userinfo ui1
                             ON a1.accountmanagerid = ui1.userid
                          INNER JOIN
                             slxdw.usersecurity us
                          ON ui1.userid = us.userid
                       INNER JOIN
                          slxdw.userinfo um
                       ON us.managerid = um.userid
                    INNER JOIN
                       slxdw.ACCOUNT a2
                    ON a1.accountid = a2.accountid
                 INNER JOIN
                    sales_order_fact f
                 ON a1.opportunityid = f.opportunity_id
              INNER JOIN
                 product_dim pd
              ON f.product_id = pd.product_id
      WHERE   a1.createdate >= '01-JAN-2009'       --   and a1.status = 'Open'
              AND UPPER (ui1.department) LIKE '%ENTERPRISE%'
   GROUP BY   a1.opportunityid,
              ui1.username,
              um.username,
              ui1.department,
              a1.description,
              a2.ACCOUNT,
              a1.estimatedclose,
              a1.salespotential,
              NVL (a1.closeprobability, 0),
              a1.status,
              a1.createdate,
              a1.modifydate,
              a1.stage,
              f.product_id,
              pd.prod_name,
              f.so_status,
              f.record_type,
              pd.prod_num,
              TRUNC (f.creation_date)
   ORDER BY   1;


