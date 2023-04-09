DROP VIEW GKDW.GK_ENTERPRISE_TODO_V;

/* Formatted on 29/01/2021 11:37:20 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ENTERPRISE_TODO_V
(
   CREATE_YEAR,
   CREATE_QUARTER,
   CREATE_MONTH_NUM,
   CREATE_PERIOD_NAME,
   CREATE_WEEK,
   DEPARTMENT,
   SALES_GROUP,
   SALES_TEAM,
   USER_MANAGER,
   USERNAME,
   ACTIVITYID,
   ACTIVITY_DESC,
   ACCT_NAME,
   CUST_NAME,
   ACCT_ID,
   CUST_ID,
   PRIORITY,
   CATEGORY,
   RESULT,
   START_DATE,
   CLOSE_DATE,
   CREATE_DATE,
   CURRENT_TODO_CNT,
   PAST_DUE_TODO_CNT,
   COMPLETED_TODO_CNT
)
AS
   SELECT   td.dim_year create_year,
            td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0')
               create_quarter,
            td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0')
               create_month_num,
            td.DIM_PERIOD_NAME create_period_name,
            td.dim_year || '-' || LPAD (td.dim_week, 2, '0') create_week,
            ui1.department,
            ui1.region sales_group,
            ui1.division sales_team,
            um.username user_manager,
            ui1.username,
            h.ACTIVITYID,
            t.activity_desc,
            cd.acct_name,
            cd.cust_name,
            cd.ACCT_ID,
            cd.CUST_ID,
            h.priority,
            h.category,
            h.result,
            TRUNC (h.STARTDATE) start_Date,
            TRUNC (h.completeddate) close_date,
            TRUNC (h.CREATEDATE) create_date,
            0 Current_todo_cnt,
            0 Past_due_todo_cnt,
            1 completed_todo_cnt
     FROM                     slxdw.history h
                           INNER JOIN
                              slxdw.activity_types t
                           ON h.history_type = t.activity_code
                        INNER JOIN
                           slxdw.userinfo ui1
                        ON h.userid = ui1.userid
                     INNER JOIN
                        slxdw.usersecurity us
                     ON ui1.userid = us.userid
                  INNER JOIN
                     slxdw.userinfo um
                  ON us.managerid = um.userid
               INNER JOIN
                  gkdw.time_dim td
               ON TRUNC (h.CREATEDATE) = td.dim_date
            INNER JOIN
               gkdw.cust_dim cd
            ON h.contactid = cd.cust_id
    WHERE       history_type = 262147
            AND UPPER (ui1.department) LIKE '%ENTERPRISE%' --and upper(ui1.region) like '%COMMERCIAL%' and ui1.division = 'Commercial Team 1'
            AND td.dim_year >= 2011
   UNION
   SELECT   td.dim_year create_year,
            td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0')
               create_quarter,
            td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0')
               create_month_num,
            td.DIM_PERIOD_NAME create_period_name,
            td.dim_year || '-' || LPAD (td.dim_week, 2, '0') create_week,
            ui1.department,
            ui1.region sales_group,
            ui1.division sales_team,
            um.username user_manager,
            ui1.username,
            a.ACTIVITYID,
            t.activity_desc,
            cd.acct_name,
            cd.cust_name,
            cd.ACCT_ID,
            cd.CUST_ID,
            a.PRIORITY,
            a.CATEGORY,
            ' OPEN' result,
            TRUNC (a.STARTDATE) start_Date,
            NULL close_date,
            TRUNC (a.CREATEDATE) create_date,
            CASE
               WHEN TRUNC (a.startDate) >= TRUNC (SYSDATE) THEN 1
               ELSE 0
            END
               Current_todo_cnt,
            CASE WHEN TRUNC (a.startDate) < TRUNC (SYSDATE) THEN 1 ELSE 0 END
               past_due_todo_cnt,
            0 completed_todo_cnt
     FROM                     slxdw.activity a
                           INNER JOIN
                              slxdw.activity_types t
                           ON a.ACTIVITYTYPE = t.activity_code
                        INNER JOIN
                           slxdw.userinfo ui1
                        ON a.USERID = ui1.userid
                     INNER JOIN
                        slxdw.usersecurity us
                     ON ui1.userid = us.userid
                  INNER JOIN
                     slxdw.userinfo um
                  ON us.managerid = um.userid
               INNER JOIN
                  gkdw.time_dim td
               ON TRUNC (a.CREATEDATE) = td.dim_date
            INNER JOIN
               gkdw.cust_dim cd
            ON a.contactid = cd.cust_id
    WHERE       a.ACTIVITYTYPE = 262147
            AND UPPER (ui1.department) LIKE '%ENTERPRISE%'
            --and upper(ui1.region) like '%COMMERCIAL%' and ui1.division = 'Commercial Team 1'
            AND td.dim_year >= 2011;


