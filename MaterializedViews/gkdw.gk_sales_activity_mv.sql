DROP MATERIALIZED VIEW GKDW.GK_SALES_ACTIVITY_MV;
CREATE MATERIALIZED VIEW GKDW.GK_SALES_ACTIVITY_MV 
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
/* Formatted on 29/01/2021 12:22:39 (QP5 v5.115.810.9015) */
  SELECT   accountid,
           account_name,
           account_city,
           account_state,
           account_country,
           account_group_name,
           sales_segment,
           sales_rep,
           ob_terr,
           fiscal_year,
           fiscal_quarter,
           fiscal_month_num,
           fiscal_period_name,
           fiscal_week,
           user_name,
           user_division,
           user_dept,
           user_region,
           SUM (act_literature) act_literature,
           SUM (act_meeting) act_meeting,
           SUM (act_phone) act_phone,
           SUM (act_to_do) act_to_do,
           SUM (act_email) act_email,
           SUM (act_note) act_note,
           SUM (act_doc) act_doc,
           SUM (act_db) act_db,
           SUM (act_pa) act_pa,
           0 act_other,
           SUM (act_cnt) act_cnt,
           SUM (opp_cnt) opp_cnt,
           SUM (opp_potential) opp_potential,
           SUM (bookings) bookings
    FROM   (  SELECT   ad.acct_id accountid,
                       ad.acct_name account_name,
                       UPPER (ad.city) account_city,
                       UPPER (ad.state) account_state,
                       ad.country account_country,
                       UPPER(CASE
                                WHEN TRIM (sl.acct_group) IS NOT NULL
                                THEN
                                   TO_CHAR (sl.acct_group)
                                WHEN TRIM (qa.account_group) IS NOT NULL
                                THEN
                                   qa.account_group
                                ELSE
                                   TRIM (ad.acct_name)
                             END)
                          account_group_name,
                       TO_CHAR (sl.sales_segment) sales_segment,
                       sl.sales_rep,
                       sl.ob_terr,
                       td1.fiscal_year,
                       td1.fiscal_quarter,
                          LPAD (td1.fiscal_month_num, 2, '0')
                       || '-'
                       || td1.fiscal_month
                          fiscal_month_num,
                       td1.fiscal_period_name,
                       td1.fiscal_week,
                       NVL (ui.username, a.modifyuser) user_name,
                       ui.division user_division,
                       ui.department user_dept,
                       ui.region user_region,
                       SUM(CASE
                              WHEN t.activity_desc = 'Literature' THEN 1
                              ELSE 0
                           END)
                          act_literature,
                       SUM (
                          CASE WHEN t.activity_desc = 'Meeting' THEN 1 ELSE 0 END
                       )
                          act_meeting,
                       SUM(CASE
                              WHEN t.activity_desc = 'Phone Call' THEN 1
                              ELSE 0
                           END)
                          act_phone,
                       SUM (
                          CASE WHEN t.activity_desc = 'To Do' THEN 1 ELSE 0 END
                       )
                          act_to_do,
                       SUM (
                          CASE WHEN t.activity_desc = 'E-mail' THEN 1 ELSE 0 END
                       )
                          act_email,
                       SUM (CASE WHEN t.activity_desc = 'Note' THEN 1 ELSE 0 END)
                          act_note,
                       SUM(CASE
                              WHEN t.activity_desc = 'Document' THEN 1
                              ELSE 0
                           END)
                          act_doc,
                       SUM(CASE
                              WHEN t.activity_desc = 'Database Change' THEN 1
                              ELSE 0
                           END)
                          act_db,
                       SUM(CASE
                              WHEN t.activity_desc = 'Personal Activity' THEN 1
                              ELSE 0
                           END)
                          act_pa,
                       SUM(CASE
                              WHEN t.activity_desc IN
                                         ('Literature',
                                          'Meeting',
                                          'Phone Call',
                                          'To Do',
                                          'E-mail',
                                          'Note',
                                          'Document',
                                          'Database Change',
                                          'Personal Activity')
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                          act_cnt,
                       0 opp_cnt,
                       0 opp_potential,
                       0 bookings
                FROM                        cust_dim cd
                                         INNER JOIN
                                            account_dim ad
                                         ON cd.acct_id = ad.acct_id
                                      INNER JOIN
                                         slxdw.qg_account qa
                                      ON ad.acct_id = qa.accountid
                                   LEFT OUTER JOIN
                                      gk_account_segment_lookup_mv sl
                                   ON cd.acct_id = sl.accountid
                                INNER JOIN
                                   slxdw.activity a
                                ON cd.cust_id = a.contactid
                                   AND a.modifyuser != 'ADMIN'
                             INNER JOIN
                                slxdw.activity_types t
                             ON a.activitytype = t.activity_code
                          INNER JOIN
                             time_dim td1
                          ON TRUNC (a.createdate) = td1.dim_date
                             AND td1.fiscal_year IN (2015, 2016)
                       LEFT OUTER JOIN
                          slxdw.userinfo ui
                       ON a.userid = ui.userid
               WHERE   ad.country = 'USA'
            GROUP BY   ad.acct_id,
                       ad.acct_name,
                       UPPER (ad.city),
                       UPPER (ad.state),
                       ad.country,
                       UPPER(CASE
                                WHEN TRIM (sl.acct_group) IS NOT NULL
                                THEN
                                   TO_CHAR (sl.acct_group)
                                WHEN TRIM (qa.account_group) IS NOT NULL
                                THEN
                                   qa.account_group
                                ELSE
                                   TRIM (ad.acct_name)
                             END),
                       TO_CHAR (sl.sales_segment),
                       sl.sales_rep,
                       sl.ob_terr,
                       td1.fiscal_year,
                       td1.fiscal_quarter,
                          LPAD (td1.fiscal_month_num, 2, '0')
                       || '-'
                       || td1.fiscal_month,
                       td1.fiscal_period_name,
                       td1.fiscal_week,
                       NVL (ui.username, a.modifyuser),
                       ui.department,
                       ui.division,
                       ui.region
            UNION ALL
              SELECT   ad.acct_id accountid,
                       ad.acct_name account_name,
                       UPPER (ad.city) account_city,
                       UPPER (ad.state) account_state,
                       ad.country account_country,
                       UPPER(CASE
                                WHEN TRIM (sl.acct_group) IS NOT NULL
                                THEN
                                   TO_CHAR (sl.acct_group)
                                WHEN TRIM (qa.account_group) IS NOT NULL
                                THEN
                                   qa.account_group
                                ELSE
                                   TRIM (ad.acct_name)
                             END)
                          account_group_name,
                       TO_CHAR (sl.sales_segment),
                       sl.sales_rep,
                       sl.ob_terr,
                       td1.fiscal_year,
                       td1.fiscal_quarter,
                          LPAD (td1.fiscal_month_num, 2, '0')
                       || '-'
                       || td1.fiscal_month
                          fiscal_month_num,
                       td1.fiscal_period_name,
                       td1.fiscal_week,
                       NVL (ui.username, a.modifyuser) user_name,
                       ui.division user_division,
                       ui.department user_dept,
                       ui.region user_region,
                       SUM(CASE
                              WHEN t.activity_desc = 'Literature' THEN 1
                              ELSE 0
                           END)
                          act_literature,
                       SUM (
                          CASE WHEN t.activity_desc = 'Meeting' THEN 1 ELSE 0 END
                       )
                          act_meeting,
                       SUM(CASE
                              WHEN t.activity_desc = 'Phone Call' THEN 1
                              ELSE 0
                           END)
                          act_phone,
                       SUM (
                          CASE WHEN t.activity_desc = 'To Do' THEN 1 ELSE 0 END
                       )
                          act_to_do,
                       SUM (
                          CASE WHEN t.activity_desc = 'E-mail' THEN 1 ELSE 0 END
                       )
                          act_email,
                       SUM (CASE WHEN t.activity_desc = 'Note' THEN 1 ELSE 0 END)
                          act_note,
                       SUM(CASE
                              WHEN t.activity_desc = 'Document' THEN 1
                              ELSE 0
                           END)
                          act_doc,
                       SUM(CASE
                              WHEN t.activity_desc = 'Database Change' THEN 1
                              ELSE 0
                           END)
                          act_db,
                       SUM(CASE
                              WHEN t.activity_desc = 'Personal Activity' THEN 1
                              ELSE 0
                           END)
                          act_pa,
                       SUM(CASE
                              WHEN t.activity_desc IN
                                         ('Literature',
                                          'Meeting',
                                          'Phone Call',
                                          'To Do',
                                          'E-mail',
                                          'Note',
                                          'Document',
                                          'Database Change',
                                          'Personal Activity')
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                          act_cnt,
                       0 opp_cnt,
                       0 opp_potential,
                       0 bookings
                FROM                        cust_dim cd
                                         INNER JOIN
                                            account_dim ad
                                         ON cd.acct_id = ad.acct_id
                                      INNER JOIN
                                         slxdw.qg_account qa
                                      ON ad.acct_id = qa.accountid
                                   LEFT OUTER JOIN
                                      gk_account_segment_lookup_mv sl
                                   ON cd.acct_id = sl.accountid
                                INNER JOIN
                                   slxdw.history a
                                ON cd.cust_id = a.contactid
                                   AND a.modifyuser != 'ADMIN'
                             INNER JOIN
                                slxdw.activity_types t
                             ON a.history_type = t.activity_code
                          INNER JOIN
                             time_dim td1
                          ON TRUNC (a.createdate) = td1.dim_date
                             AND td1.fiscal_year IN (2015, 2016)
                       LEFT OUTER JOIN
                          slxdw.userinfo ui
                       ON a.userid = ui.userid
               WHERE   ad.country = 'USA'
            GROUP BY   ad.acct_id,
                       ad.acct_name,
                       UPPER (ad.city),
                       UPPER (ad.state),
                       ad.country,
                       UPPER(CASE
                                WHEN TRIM (sl.acct_group) IS NOT NULL
                                THEN
                                   TO_CHAR (sl.acct_group)
                                WHEN TRIM (qa.account_group) IS NOT NULL
                                THEN
                                   qa.account_group
                                ELSE
                                   TRIM (ad.acct_name)
                             END),
                       TO_CHAR (sl.sales_segment),
                       sl.sales_rep,
                       sl.ob_terr,
                       td1.fiscal_year,
                       td1.fiscal_quarter,
                          LPAD (td1.fiscal_month_num, 2, '0')
                       || '-'
                       || td1.fiscal_month,
                       td1.fiscal_period_name,
                       td1.fiscal_week,
                       NVL (ui.username, a.modifyuser),
                       ui.department,
                       ui.division,
                       ui.region
            UNION ALL
              SELECT   ad.acct_id accountid,
                       ad.acct_name account_name,
                       UPPER (ad.city) account_city,
                       UPPER (ad.state) account_state,
                       ad.country account_country,
                       UPPER(CASE
                                WHEN TRIM (sl.acct_group) IS NOT NULL
                                THEN
                                   TO_CHAR (sl.acct_group)
                                WHEN TRIM (qa.account_group) IS NOT NULL
                                THEN
                                   qa.account_group
                                ELSE
                                   TRIM (ad.acct_name)
                             END)
                          account_group_name,
                       TO_CHAR (sl.sales_segment) sales_segment,
                       sl.sales_rep,
                       sl.ob_terr,
                       td1.fiscal_year,
                       td1.fiscal_quarter,
                          LPAD (td1.fiscal_month_num, 2, '0')
                       || '-'
                       || td1.fiscal_month,
                       td1.fiscal_period_name,
                       td1.fiscal_week,
                       NVL (ui.username, d.account_manager_id) user_name,
                       ui.division user_division,
                       ui.department user_dept,
                       ui.region user_region,
                       0 act_literature,
                       0 act_meeting,
                       0 act_phone,
                       0 act_to_do,
                       0 act_email,
                       0 act_note,
                       0 act_doc,
                       0 act_db,
                       0 act_pa,
                       0 act_cnt,
                       COUNT (DISTINCT d.opportunity_id) opp_cnt,
                       SUM (NVL (sales_potential, 0)) opp_potential,
                       0 bookings
                FROM                        account_dim ad
                                         INNER JOIN
                                            slxdw.qg_account qa
                                         ON ad.acct_id = qa.accountid
                                      LEFT OUTER JOIN
                                         gk_account_segment_lookup_mv sl
                                      ON ad.acct_id = sl.accountid
                                   INNER JOIN
                                      opportunity_dim d
                                   ON ad.acct_id = d.account_id
                                INNER JOIN
                                   slxdw.qg_oppcourses oc
                                ON d.opportunity_id = oc.opportunityid
                             INNER JOIN
                                course_dim cd
                             ON     oc.evxcourseid = cd.course_id
                                AND cd.country = 'USA'
                                AND cd.ch_num IN ('10', '40')
                          INNER JOIN
                             time_dim td1
                          ON TRUNC (d.creation_date) = td1.dim_date
                             AND td1.fiscal_year IN (2015, 2016)
                       LEFT OUTER JOIN
                          slxdw.userinfo ui
                       ON d.account_manager_id = ui.userid
               WHERE   ad.country = 'USA'
            GROUP BY   ad.acct_id,
                       ad.acct_name,
                       UPPER (ad.city),
                       UPPER (ad.state),
                       ad.country,
                       UPPER(CASE
                                WHEN TRIM (sl.acct_group) IS NOT NULL
                                THEN
                                   TO_CHAR (sl.acct_group)
                                WHEN TRIM (qa.account_group) IS NOT NULL
                                THEN
                                   qa.account_group
                                ELSE
                                   TRIM (ad.acct_name)
                             END),
                       TO_CHAR (sl.sales_segment),
                       sl.sales_rep,
                       sl.ob_terr,
                       td1.fiscal_year,
                       td1.fiscal_quarter,
                          LPAD (td1.fiscal_month_num, 2, '0')
                       || '-'
                       || td1.fiscal_month,
                       td1.fiscal_period_name,
                       td1.fiscal_week,
                       NVL (ui.username, d.account_manager_id),
                       ui.department,
                       ui.division,
                       ui.region
            UNION ALL
              SELECT   ad.acct_id accountid,
                       ad.acct_name account_name,
                       UPPER (ad.city) account_city,
                       UPPER (ad.state) account_state,
                       ad.country account_country,
                       UPPER(CASE
                                WHEN TRIM (sl.acct_group) IS NOT NULL
                                THEN
                                   TO_CHAR (sl.acct_group)
                                WHEN TRIM (qa.account_group) IS NOT NULL
                                THEN
                                   qa.account_group
                                ELSE
                                   TRIM (ad.acct_name)
                             END)
                          account_group_name,
                       CASE
                          WHEN cp.partner_key_code IS NOT NULL THEN 'Channel'
                          ELSE TO_CHAR (sl.sales_segment)
                       END
                          sales_segment,
                       sl.sales_rep,
                       sl.ob_terr,
                       td1.fiscal_year,
                       td1.fiscal_quarter,
                          LPAD (td1.fiscal_month_num, 2, '0')
                       || '-'
                       || td1.fiscal_month,
                       td1.fiscal_period_name,
                       td1.fiscal_week,
                       NVL (ui.username, f.salesperson) user_name,
                       ui.division user_division,
                       ui.department user_dept,
                       ui.region user_region,
                       0 act_literature,
                       0 act_meeting,
                       0 act_phone,
                       0 act_to_do,
                       0 act_email,
                       0 act_note,
                       0 act_doc,
                       0 act_db,
                       0 act_pa,
                       0 act_cnt,
                       0 opp_cnt,
                       0 opp_potential,
                       SUM (f.book_amt) bookings
                FROM                              cust_dim cd
                                               INNER JOIN
                                                  account_dim ad
                                               ON cd.acct_id = ad.acct_id
                                            INNER JOIN
                                               slxdw.qg_account qa
                                            ON ad.acct_id = qa.accountid
                                         LEFT OUTER JOIN
                                            gk_account_segment_lookup_mv sl
                                         ON cd.acct_id = sl.accountid
                                      INNER JOIN
                                         order_fact f
                                      ON cd.cust_id = f.cust_id
                                   INNER JOIN
                                      event_dim ed
                                   ON f.event_id = ed.event_id
                                INNER JOIN
                                   course_dim c
                                ON     ed.course_id = c.course_id
                                   AND ed.ops_country = c.country
                                   AND c.ch_num IN ('10', '40')
                             INNER JOIN
                                time_dim td1
                             ON f.book_date = td1.dim_date
                                AND td1.fiscal_year IN (2015, 2016)
                          LEFT OUTER JOIN
                             gk_channel_partner cp
                          ON f.keycode = cp.partner_key_code
                       LEFT OUTER JOIN
                          slxdw.userinfo ui
                       ON f.salesperson = ui.username AND ui.region != 'Retired'
               WHERE   ad.country = 'USA'
            GROUP BY   ad.acct_id,
                       ad.acct_name,
                       UPPER (ad.city),
                       UPPER (ad.state),
                       ad.country,
                       UPPER(CASE
                                WHEN TRIM (sl.acct_group) IS NOT NULL
                                THEN
                                   TO_CHAR (sl.acct_group)
                                WHEN TRIM (qa.account_group) IS NOT NULL
                                THEN
                                   qa.account_group
                                ELSE
                                   TRIM (ad.acct_name)
                             END),
                       CASE
                          WHEN cp.partner_key_code IS NOT NULL THEN 'Channel'
                          ELSE TO_CHAR (sl.sales_segment)
                       END,
                       sl.sales_rep,
                       sl.ob_terr,
                       td1.fiscal_year,
                       td1.fiscal_quarter,
                          LPAD (td1.fiscal_month_num, 2, '0')
                       || '-'
                       || td1.fiscal_month,
                       td1.fiscal_period_name,
                       td1.fiscal_week,
                       NVL (ui.username, f.salesperson),
                       ui.division,
                       ui.department,
                       ui.region)
GROUP BY   accountid,
           account_name,
           account_city,
           account_state,
           account_country,
           account_group_name,
           sales_segment,
           sales_rep,
           ob_terr,
           fiscal_year,
           fiscal_quarter,
           fiscal_month_num,
           fiscal_period_name,
           fiscal_week,
           user_name,
           user_division,
           user_dept,
           user_region;

COMMENT ON MATERIALIZED VIEW GKDW.GK_SALES_ACTIVITY_MV IS 'snapshot table for snapshot GKDW.GK_SALES_ACTIVITY_MV';

GRANT SELECT ON GKDW.GK_SALES_ACTIVITY_MV TO DWHREAD;

