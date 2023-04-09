DROP PROCEDURE GKDW.GK_SALES_REVENUE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_sales_revenue_proc as
cursor c1(p_date varchar2) is
SELECT distinct f.enroll_id,c.acct_id,c.country,
         ed.course_code,
         NULL Geography_Name,
         NVL (c.acct_name, f.acct_name) acct_name,
          CASE
                  WHEN f.keycode = 'C09901068P' THEN f.book_amt * 2
                  ELSE f.book_amt 
          END Selling_Price,
         f.curr_code,
         trunc(f.book_date) Incentive_Date,
         trunc(f.book_date) order_date,
         'Sales' Order_Type,--c.acct_id,
         CASE
            WHEN (   (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                  OR cd.course_pl = 'MICROSOFT APPS')
            THEN
               NULL
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('INSIDE','MID MARKET/GEO', 'COMMERCIAL/GEO','COMMERCIAL','MID MARKET','LARGE ENTERPRISE','CHANNEL','FEDERAL')
                 AND cd.ch_num = 20
            THEN
               nvl(ui2.username,ui5.username) --sl.FIELD_REP
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('INSIDE','FEDERAL','CHANNEL','LARGE ENTERPRISE','MID MARKET','COMMERCIAL')
                 AND cd.ch_num IN (10, 40)
            THEN
              nvl(ui2.username,ui5.username) --sl.FIELD_REP
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('GOVERNMENT','LARGE ENTERPRISE','CHANNEL','COMMERCIAL/GEO')
                 AND cd.ch_num in (10,40,20)
            THEN
               nvl(ui2.username,ui5.username)
ELSE NULL
         END field_rep_name,--GT.TERRITORY_ID,
         CASE
            WHEN (   (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                  OR cd.course_pl = 'MICROSOFT APPS')
            THEN
               NULL
             WHEN     SUBSTR (f.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('INSIDE','MID MARKET/GEO', 'COMMERCIAL/GEO','COMMERCIAL','MID MARKET','LARGE ENTERPRISE','CHANNEL','FEDERAL')
                 AND cd.ch_num = 20
            THEN
               nvl(ui2.accountinguserid,ui5.accountinguserid)
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('INSIDE','FEDERAL','CHANNEL','LARGE ENTERPRISE','MID MARKET','COMMERCIAL')
                 AND cd.ch_num IN (10, 40) 
              THEN nvl(ui2.accountinguserid,ui5.accountinguserid) -- sl.FIELD_REP_ID
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('GOVERNMENT', 'LARGE ENTERPRISE','CHANNEL', 'COMMERCIAL/GEO')
                 AND cd.ch_num in (10,20,40)
            THEN
                nvl(ui2.accountinguserid,ui5.accountinguserid) -- sl.FIELD_REP_ID
            ELSE NULL
         END field_rep_payroll_id,
            CASE
            WHEN (   (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                  OR cd.course_pl = 'MICROSOFT APPS')
            THEN
               NULL
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(qa.segment,sl.segment)) in ('INSIDE','MID MARKET/GEO', 'COMMERCIAL/GEO','COMMERCIAL','MID MARKET','LARGE ENTERPRISE','CHANNEL','FEDERAL')
                 AND cd.ch_num IN (10, 40)
            THEN
              nvl(ui.username,ui6.username)-- nvl(sl.ob_rep,ui5.username)
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('GOVERNMENT', 'LARGE ENTERPRISE','CHANNEL', 'COMMERCIAL/GEO')
                 AND cd.ch_num IN (10, 40)
            THEN nvl(ui.username,ui6.username)
               --sl.OB_REP
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'CA' -- Only for opps owner. for now included for all
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('GOVERNMENT', 'LARGE ENTERPRISE')
                 AND cd.ch_num = '20'
            THEN nvl(ui.username,ui6.username)
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(qa.segment,sl.segment)) = 'INSIDE'
                 AND cd.ch_num IN (10,40,20)
            THEN nvl(ui.username,ui6.username)
              -- sl.OB_REP
            WHEN  SUBSTR (f.cust_country, 1, 2) = 'US'
                 AND nvl(qa.segment,sl.segment) is NULL
                 AND cd.ch_num IN (10, 40)
                 THEN CASE WHEN GT.TERRITORY_ID LIKE 'NE%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'MA%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'MW%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'SC%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'SE%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'W%' THEN nvl(ui.username,GT.SALESREP)
                    ELSE NULL
                    END
            WHEN  SUBSTR (f.cust_country, 1, 2) ='US' 
            AND nvl(qa.segment,sl.segment) is NULL
                 AND cd.ch_num = 20 THEN 
                    CASE WHEN GT.TERRITORY_ID LIKE 'NE%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'MA%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'MW%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'SC%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'SE%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'W%' THEN nvl(ui.username,GT.SALESREP)
                    ELSE NULL
                    END 
            ELSE
               NULL
         END
            inside_sales_rep_name,
         CASE
            WHEN (   (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                  OR cd.course_pl = 'MICROSOFT APPS')
            THEN
               NULL
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(qa.segment,sl.segment)) in ('INSIDE','MID MARKET/GEO', 'COMMERCIAL/GEO','COMMERCIAL','MID MARKET','LARGE ENTERPRISE','CHANNEL','FEDERAL')
                 AND cd.ch_num IN (10, 40)
            THEN
               nvl(ui.accountinguserid,ui6.accountinguserid)--sl.ob_rep_id
             WHEN     SUBSTR (f.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('GOVERNMENT', 'LARGE ENTERPRISE','CHANNEL', 'COMMERCIAL/GEO')
                 AND cd.ch_num IN (10, 40)
            THEN
               nvl(ui.accountinguserid,ui6.accountinguserid) -- sl.OB_REP_ID
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'CA' -- Only for opps owner. for now included for all
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('GOVERNMENT', 'LARGE ENTERPRISE')
                 AND cd.ch_num = '20'
             THEN
               nvl(ui.accountinguserid,ui6.accountinguserid) -- sl.OB_REP_ID    
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(qa.segment,sl.segment)) = 'INSIDE'
                 AND cd.ch_num IN (10,40,20)
            THEN
               nvl(ui.accountinguserid,ui6.accountinguserid) -- sl.OB_REP_ID
            WHEN  SUBSTR (f.cust_country, 1, 2) = 'US'
                 AND nvl(qa.segment,sl.segment) is NULL
                 AND cd.ch_num IN (10, 40)
                 THEN CASE WHEN GT.TERRITORY_ID LIKE 'NE%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                           WHEN GT.TERRITORY_ID LIKE 'MA%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                           WHEN GT.TERRITORY_ID LIKE 'MW%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                           WHEN GT.TERRITORY_ID LIKE 'SC%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                           WHEN GT.TERRITORY_ID LIKE 'SE%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                           WHEN GT.TERRITORY_ID LIKE 'W%' THEN  nvl(ui.accountinguserid,ui4.accountinguserid)
                    ELSE NULL
                    END
            WHEN  SUBSTR (f.cust_country, 1, 2) = 'US' 
                    AND nvl(qa.segment,sl.segment) is NULL
                    AND cd.ch_num = 20 THEN  
                    CASE WHEN GT.TERRITORY_ID LIKE 'NE%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT.TERRITORY_ID LIKE 'MA%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT.TERRITORY_ID LIKE 'MW%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT.TERRITORY_ID LIKE 'SC%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT.TERRITORY_ID LIKE 'SE%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT.TERRITORY_ID LIKE 'W%' THEN  nvl(ui.accountinguserid,ui4.accountinguserid)
                    ELSE NULL
                    END
            ELSE
               NULL
         END
            inside_sales_rep_payroll_id,
            CASE
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'CA'
                 AND UPPER (NVL (nvl(qa.segment,sl.segment), '0')) NOT IN ('0', 'INSIDE')
                 AND cd.ch_num = 20
                 AND course_pl IN ('BUSINESS TRAINING',
                                   'LEADERSHIP AND BUSINESS SOLUTIONS')
            THEN
               ui3.username-- qc.rep_4_id
            ELSE
               NULL
         END
            csd_rep_name,
         CASE
            WHEN     SUBSTR (f.cust_country, 1, 2) = 'CA'
                 AND UPPER (NVL (nvl(qa.segment,sl.segment), '0')) NOT IN ('0', 'INSIDE')
                 AND cd.ch_num = 20
                 AND course_pl IN ('BUSINESS TRAINING',
                                   'LEADERSHIP AND BUSINESS SOLUTIONS')
            THEN
              ui3.accountinguserid --  qc.rep_4_id
            ELSE
               NULL
         END
            csd_payroll_id,
         CASE
            WHEN cd.ch_num = '20' THEN 'Enterprise'
            WHEN cd.ch_num IN ('10', '40') THEN 'Open Enrollment'
            WHEN cd.ch_num IS NULL THEN NULL
         END
            channel,
         cd.Course_name Product,
         CASE
            WHEN SUBSTR (ed.Course_code, -1, 1) IN ('N',
                                                    'C',
                                                    'G',
                                                    'H',
                                                    'D',
                                                    'I')
            THEN
               'Classroom'
            WHEN SUBSTR (ed.Course_code, -1, 1) IN ('V',
                                                    'L',
                                                    'Y',
                                                    'U')
            THEN
               'Virtual'
            WHEN SUBSTR (ed.Course_code, -1, 1) IN ('Z')
            THEN
               'Virtual Fit'
            WHEN SUBSTR (ed.Course_code, -1, 1) IN ('S',
                                                    'W',
                                                    'E',
                                                    'P')
            THEN
               'Digital'
            WHEN SUBSTR (ed.Course_code, -1, 1) IN ('A')
            THEN
               'Digital'
         END
            Delivery_format,
         ed.event_type Event_Type,
         nvl(f.payment_method,ft.payment_method) Payment_Method,
         cd.course_pl Product_Family,
         'Class' Product_Type,
         coalesce(qa.segment,sl.segment,gt.region) Segment,
         f.cust_first_name || ' ' || f.cust_last_name Student_Name
    FROM order_fact f
        inner join (select distinct enroll_id,payment_method from order_fact where bill_status <> 'Cancelled') ft on f.enroll_id = ft.enroll_id
         INNER JOIN cust_dim c ON f.cust_id = c.cust_id
         INNER JOIN event_dim ed ON f.event_id = ed.event_id
         INNER JOIN course_dim cd ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
         LEFT OUTER JOIN (select accountid,ob_national_rep_id,ob_rep_id,ent_national_rep_id,ent_inside_rep_id,gk_segment segment,rep_4_id from qg_account@slx) qa ON c.acct_id = qa.accountid
         LEFT OUTER JOIN GK_ACCOUNT_SEGMENTS_MV sl ON c.acct_id = sl.accountid
         LEFT OUTER JOIN gk_territory gt
          ON     c.zipcode BETWEEN gt.zip_start AND gt.zip_end
           and substr(c.country,1,2) = 'US'
         left outer join userinfo@slx ui on ui.userid = qa.ob_rep_id
         left outer join userinfo@slx ui6 on ui6.userid = sl.ob_rep_id
         left outer join userinfo@slx ui2 on ui2.userid = qa.ent_national_rep_id
         left outer join userinfo@slx ui5 on ui5.userid = sl.field_rep_id
         left outer join userinfo@slx ui3 on ui3.userid = qa.rep_4_id
         left outer join userinfo@slx ui4 on ui4.userid = gt.userid
   WHERE TO_CHAR (f.book_date, 'mm/yyyy') =  p_date --TO_CHAR (TRUNC (SYSDATE), 'mm/yyyy')
   and f.book_Amt<>'0'
   and ch_num in (10,20,40)
 --and f.enroll_id = 'QGKID09GAG6A'
UNION
select distinct et.evxevenrollid,c2.acct_id,f1.cust_country,
et.coursecode,
NULL Geography_Name,
nvl(c2.acct_name,et.account) acct_name,
case WHEN F1.KEYCODE = 'C09901068P' THEN et.actual_extended_amount *2 else et.actual_extended_amount end Selling_Price,
et.CURRENCYTYPE Selling_Price_Currency,
trunc(et.createdate) Incentive_Date,
trunc(et.createdate) Order_Date,
'Sales' Order_Type,
CASE
            WHEN (   (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                  OR cd.course_pl = 'MICROSOFT APPS')
            THEN
               NULL
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(q.segment,sl.segment)) IN ('INSIDE','MID MARKET/GEO', 'COMMERCIAL/GEO','COMMERCIAL','MID MARKET','LARGE ENTERPRISE','CHANNEL','FEDERAL')
                 AND cd.ch_num = 20
            THEN
               nvl(ui2.username,ui5.username) --sl.FIELD_REP
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(q.segment,sl.segment)) IN ('INSIDE','FEDERAL','CHANNEL','LARGE ENTERPRISE','MID MARKET','COMMERCIAL')
                 AND cd.ch_num IN (10, 40)
            THEN
              nvl(ui2.username,ui5.username) --sl.FIELD_REP
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(q.segment,sl.segment)) IN ('GOVERNMENT','LARGE ENTERPRISE','CHANNEL','COMMERCIAL/GEO')
                 AND cd.ch_num in (10,40,20)
            THEN
               nvl(ui2.username,ui5.username)
            ELSE NULL
         END
            Field_rep_name,
         CASE
            WHEN (   (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                  OR cd.course_pl = 'MICROSOFT APPS')
            THEN
               NULL
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(q.segment,sl.segment)) IN ('INSIDE','MID MARKET/GEO', 'COMMERCIAL/GEO','COMMERCIAL','MID MARKET','LARGE ENTERPRISE','CHANNEL','FEDERAL')
                 AND cd.ch_num = 20
            THEN
               nvl(ui2.accountinguserid,ui5.accountinguserid)
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(q.segment,sl.segment)) IN ('INSIDE','FEDERAL','CHANNEL','LARGE ENTERPRISE','MID MARKET','COMMERCIAL')
                 AND cd.ch_num IN (10, 40) 
              THEN nvl(ui2.accountinguserid,ui5.accountinguserid) -- sl.FIELD_REP_ID
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(q.segment,sl.segment)) IN ('GOVERNMENT', 'LARGE ENTERPRISE','CHANNEL', 'COMMERCIAL/GEO')
                 AND cd.ch_num in (10,20,40)
            THEN
                nvl(ui2.accountinguserid,ui5.accountinguserid) -- sl.FIELD_REP_ID
            ELSE NULL
         END
            field_rep_payroll_id,
            CASE
            WHEN (   (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                  OR cd.course_pl = 'MICROSOFT APPS')
            THEN
               NULL
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(q.segment,sl.segment)) in ('INSIDE','MID MARKET/GEO', 'COMMERCIAL/GEO','COMMERCIAL','MID MARKET','LARGE ENTERPRISE','CHANNEL','FEDERAL')
                 AND cd.ch_num IN (10, 40)
            THEN
              nvl(ui.username,ui6.username)-- nvl(sl.ob_rep,ui5.username)
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(q.segment,sl.segment)) IN ('GOVERNMENT', 'LARGE ENTERPRISE','CHANNEL', 'COMMERCIAL/GEO')
                 AND cd.ch_num IN (10, 40)
            THEN nvl(ui.username,ui6.username)
               --sl.OB_REP
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'CA' -- Only for opps owner. for now included for all
                 AND UPPER (nvl(q.segment,sl.segment)) IN ('GOVERNMENT', 'LARGE ENTERPRISE')
                 AND cd.ch_num = '20'
            THEN nvl(ui.username,ui6.username)
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(q.segment,sl.segment)) = 'INSIDE'
                 AND cd.ch_num IN (10,40,20)
            THEN nvl(ui.username,ui6.username)
              -- sl.OB_REP
            WHEN  SUBSTR (f1.cust_country, 1, 2) = 'US'
                 AND nvl(q.segment,sl.segment) is NULL
                 AND cd.ch_num IN (10, 40)
                 THEN CASE WHEN GT2.TERRITORY_ID LIKE 'NE%' THEN nvl(ui.username,GT2.SALESREP)
                    WHEN GT2.TERRITORY_ID LIKE 'MA%' THEN nvl(ui.username,GT2.SALESREP)
                    WHEN GT2.TERRITORY_ID LIKE 'MW%' THEN nvl(ui.username,GT2.SALESREP)
                    WHEN GT2.TERRITORY_ID LIKE 'SC%' THEN nvl(ui.username,GT2.SALESREP)
                    WHEN GT2.TERRITORY_ID LIKE 'SE%' THEN nvl(ui.username,GT2.SALESREP)
                    WHEN GT2.TERRITORY_ID LIKE 'W%' THEN nvl(ui.username,GT2.SALESREP)
                    ELSE NULL
                    END
            WHEN  SUBSTR (f1.cust_country, 1, 2) ='US' 
            AND nvl(q.segment,sl.segment) is NULL
                 AND cd.ch_num = 20 THEN 
                    CASE WHEN GT2.TERRITORY_ID LIKE 'NE%' THEN nvl(ui.username,GT2.SALESREP)
                    WHEN GT2.TERRITORY_ID LIKE 'MA%' THEN nvl(ui.username,GT2.SALESREP)
                    WHEN GT2.TERRITORY_ID LIKE 'MW%' THEN nvl(ui.username,GT2.SALESREP)
                    WHEN GT2.TERRITORY_ID LIKE 'SC%' THEN nvl(ui.username,GT2.SALESREP)
                    WHEN GT2.TERRITORY_ID LIKE 'SE%' THEN nvl(ui.username,GT2.SALESREP)
                    WHEN GT2.TERRITORY_ID LIKE 'W%' THEN nvl(ui.username,GT2.SALESREP)
                    ELSE NULL
                    END 
            ELSE
               NULL
         END
            inside_sales_rep_name,
         CASE
            WHEN (   (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                  OR cd.course_pl = 'MICROSOFT APPS')
            THEN
               NULL
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'US'
                 AND UPPER (nvl(q.segment,sl.segment)) in ('INSIDE','MID MARKET/GEO', 'COMMERCIAL/GEO','COMMERCIAL','MID MARKET','LARGE ENTERPRISE','CHANNEL','FEDERAL')
                 AND cd.ch_num IN (10, 40)
            THEN
               nvl(ui.accountinguserid,ui6.accountinguserid)--sl.ob_rep_id
             WHEN     SUBSTR (f1.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(q.segment,sl.segment)) IN ('GOVERNMENT', 'LARGE ENTERPRISE','CHANNEL', 'COMMERCIAL/GEO')
                 AND cd.ch_num IN (10, 40)
            THEN
               nvl(ui.accountinguserid,ui6.accountinguserid) -- sl.OB_REP_ID
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'CA' -- Only for opps owner. for now included for all
                 AND UPPER (nvl(q.segment,sl.segment)) IN ('GOVERNMENT', 'LARGE ENTERPRISE')
                 AND cd.ch_num = '20'
             THEN
               nvl(ui.accountinguserid,ui6.accountinguserid) -- sl.OB_REP_ID    
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'CA'
                 AND UPPER (nvl(q.segment,sl.segment)) = 'INSIDE'
                 AND cd.ch_num IN (10,40,20)
            THEN
               nvl(ui.accountinguserid,ui6.accountinguserid) -- sl.OB_REP_ID
            WHEN  SUBSTR (f1.cust_country, 1, 2) = 'US'
                 AND nvl(q.segment,sl.segment) is NULL
                 AND cd.ch_num IN (10, 40)
                 THEN CASE WHEN GT2.TERRITORY_ID LIKE 'NE%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                           WHEN GT2.TERRITORY_ID LIKE 'MA%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                           WHEN GT2.TERRITORY_ID LIKE 'MW%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                           WHEN GT2.TERRITORY_ID LIKE 'SC%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                           WHEN GT2.TERRITORY_ID LIKE 'SE%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                           WHEN GT2.TERRITORY_ID LIKE 'W%' THEN  nvl(ui.accountinguserid,ui4.accountinguserid)
                    ELSE NULL
                    END
             WHEN  SUBSTR (f1.cust_country, 1, 2) = 'US' 
                    AND nvl(q.segment,sl.segment) is NULL
                    AND cd.ch_num = 20 THEN  
                    CASE WHEN GT2.TERRITORY_ID LIKE 'NE%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT2.TERRITORY_ID LIKE 'MA%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT2.TERRITORY_ID LIKE 'MW%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT2.TERRITORY_ID LIKE 'SC%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT2.TERRITORY_ID LIKE 'SE%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT2.TERRITORY_ID LIKE 'W%' THEN  nvl(ui.accountinguserid,ui4.accountinguserid)
                    ELSE NULL
                    END 
            ELSE
               NULL
         END
            inside_sales_payroll_id,
            CASE
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'CA'
                 AND UPPER (NVL (nvl(q.segment,sl.segment), '0')) NOT IN ('0', 'INSIDE')
                 AND cd.ch_num = 20
                 AND course_pl IN ('BUSINESS TRAINING',
                                   'LEADERSHIP AND BUSINESS SOLUTIONS')
            THEN
               ui3.username-- qc.rep_4_id
            ELSE
               NULL
         END
            CSD_rep_name,
         CASE
            WHEN     SUBSTR (f1.cust_country, 1, 2) = 'CA'
                 AND UPPER (NVL (nvl(q.segment,sl.segment), '0')) NOT IN ('0', 'INSIDE')
                 AND cd.ch_num = 20
                 AND course_pl IN ('BUSINESS TRAINING',
                                   'LEADERSHIP AND BUSINESS SOLUTIONS')
            THEN
              ui3.accountinguserid --  qc.rep_4_id
            ELSE
               NULL
         END
            CSD_rep_payroll_id,
case when cd.ch_num = '20' then 'Enterprise'
     else 'Open Enrollment'
end Channel, 
cd.Course_name,
case when SUBSTR(ed.Course_code,-1,1) in ('N','C','G','H','D','I') then 'Classroom'
     when SUBSTR(ed.Course_code,-1,1) in ('V','L','Y','U') then 'Virtual'
     when SUBSTR(ed.Course_code,-1,1) in ('Z') then 'Virtual Fit'
     when SUBSTR(ed.Course_code,-1,1) in ('S','W','E','P') then 'Digital'
     when SUBSTR(ed.Course_code,-1,1) in ('A') then 'Digital'
End Delivery_Format,
ed.event_type Event_Type,
case when et.ponumber is not null then 'Purchase Order' 
     when et.evxppcardid is not null then 'Prepay Card'
     else ebp."METHOD"
end Payment_Method,
cd.course_pl Product_Family,
'Class' Product_Type,
coalesce(q.segment,sl.segment,gt2.region) "Segment",
nvl(f1.cust_first_name || ' ' || f1.cust_last_name,et.Attendee_name) Student_Name
from ent_trans_bookings@slx et
INNER join cust_dim c2 on et.contactid = c2.cust_id
INNER JOIN event_dim ed ON et.evxeventid = ed.event_id
INNER JOIN ORDER_FACT F1 ON F1.ENROLL_ID = ET.EVXEVENROLLID
INNER JOIN course_dim cd
          ON     ed.course_id = cd.course_id
             AND CASE
                    WHEN ed.ops_country in ('CA','CANADA') THEN 'CANADA'
                    ELSE 'USA'
                 END = cd.country
INNER join SLXDW.evxev_txfee etf on etf.evxevenrollid = et.evxevenrollid 
INNER join SLXDW.evxevticket etk on etf.evxevticketid = etk.evxevticketid
inner join SLXDW.evxbillpayment ebp on etf.EVXBILLINGID = ebp.EVXBILLINGID --and nvl(etf.evxbillingid,'0') <> '0'
LEFT OUTER JOIN (select accountid,ob_national_rep_id,ob_rep_id,ent_national_rep_id,ent_inside_rep_id,gk_segment segment,rep_4_id from qg_account@slx) q ON c2.acct_id = q.accountid
LEFT OUTER JOIN GK_ACCOUNT_SEGMENTS_MV sl ON c2.acct_id = sl.accountid
LEFT OUTER JOIN gk_territory gt2
          ON     c2.zipcode BETWEEN gt2.zip_start AND gt2.zip_end
          and  substr(c2.country,1,2) = 'US'
left outer join userinfo@slx ui on ui.userid = q.ob_rep_id 
left outer join userinfo@slx ui6 on ui6.userid = sl.ob_rep_id
left outer join userinfo@slx ui2 on ui2.userid = q.ent_national_rep_id
left outer join userinfo@slx ui5 on ui5.userid = sl.field_rep_id
left outer join userinfo@slx ui3 on ui3.userid = q.rep_4_id 
left outer join userinfo@slx ui4 on ui4.userid = gt2.userid
where to_char(et.createdate,'mm/yyyy') = p_date -- to_char(trunc(sysdate),'mm/yyyy')
and cd.ch_num in (10,20)
UNION
SELECT distinct epp.evxppcardid,c.acct_id,c.country,
         sf.prod_num,
         NULL Geography_Name,
         c.acct_name,
         case when sf.keycode = 'C09901068P' then sf.book_amt*2 else sf.book_amt end  Selling_Price,
         sf.curr_code Selling_Price_Currency,
         nvl(sf.book_date,creation_date) Incentive_Date,
         nvl(sf.book_date,creation_date) Order_Date,
         'Sales' Order_Type,--c.acct_id,
         case
         WHEN     SUBSTR (C.country, 1, 2) = 'US'
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('INSIDE','MID MARKET/GEO', 'COMMERCIAL/GEO','COMMERCIAL','MID MARKET','LARGE ENTERPRISE','CHANNEL','FEDERAL')
                 THEN NVL(ui2.username,ui5.username)
         WHEN  SUBSTR (C.country, 1, 2) = 'CA'
                AND upper(coalesce(qa.segment,sl.segment,gt.region)) in ('GOVERNMENT','LARGE ENTERPRISE','CHANNEL','COMMERCIAL/GEO') THEN NVL(ui2.username,ui5.username)
         end Field_Sales_Rep_name,--GT.TERRITORY_ID,
         case
         WHEN     SUBSTR (C.country, 1, 2) = 'US'
                 AND UPPER (nvl(qa.segment,sl.segment)) IN ('INSIDE','MID MARKET/GEO', 'COMMERCIAL/GEO','COMMERCIAL','MID MARKET','LARGE ENTERPRISE','CHANNEL','FEDERAL')
                 THEN NVL(ui2.accountinguserid,ui5.accountinguserid)
         WHEN  SUBSTR (C.country, 1, 2) = 'CA'
                AND upper(coalesce(qa.segment,sl.segment,gt.region)) in ('GOVERNMENT','LARGE ENTERPRISE','CHANNEL','COMMERCIAL/GEO') THEN NVL(ui2.accountinguserid,ui5.accountinguserid)
         end Field_Sales_payroll_id,
         case WHEN  SUBSTR (c.country, 1, 2) ='US' 
            AND nvl(qa.segment,sl.segment) is NULL
                 THEN 
                    CASE WHEN GT.TERRITORY_ID LIKE 'NE%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'MA%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'MW%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'SC%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'SE%' THEN nvl(ui.username,GT.SALESREP)
                    WHEN GT.TERRITORY_ID LIKE 'W%' THEN nvl(ui.username,GT.SALESREP)
                    ELSE NULL
                    END 
         when substr(c.country,1,2) = 'CA' 
              and sf.ppcard_id is not null 
              and upper(coalesce(qa.segment,sl.segment,gt.region)) in ('INSIDE','GOVERNMENT','LARGE ENTERPRISE')
              then nvl(ui.username,ui6.username)  end Inside_Sales_Rep_Name,
         case WHEN  SUBSTR (c.country, 1, 2) ='US' 
            AND nvl(qa.segment,sl.segment) is NULL
                 THEN 
                    CASE WHEN GT.TERRITORY_ID LIKE 'NE%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT.TERRITORY_ID LIKE 'MA%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT.TERRITORY_ID LIKE 'MW%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT.TERRITORY_ID LIKE 'SC%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT.TERRITORY_ID LIKE 'SE%' THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    WHEN GT.TERRITORY_ID LIKE 'W%'  THEN nvl(ui.accountinguserid,ui4.accountinguserid)
                    ELSE NULL
                    END 
         when substr(c.country,1,2) = 'CA' 
              and sf.ppcard_id is not null 
              and upper(coalesce(qa.segment,sl.segment,gt.region)) in ('INSIDE','GOVERNMENT','LARGE ENTERPRISE')
              then nvl(ui.accountinguserid,ui6.accountinguserid)  end Inside_Sales_payroll_id,
         null  CSD_rep_name,
         null  CSD_payroll_id,
         'Prepay' Channel,
         nvl(epp.cardtitle,p.prod_name) Product,
         'Prepay' Delivery_Format,
         'Prepay' Event_Type,
         sf.payment_method Payment_Method,
         'Prepay' Product_Family,
         'Prepay Card' Product_Type,
         coalesce(qa.segment,sl.segment,gt.region) "Segment",
         'Prepay' Student_Name
    FROM sales_order_fact sf
         left join slxdw.evxppcard epp on sf.sales_order_id = epp.evxsoid
         left join product_dim p on sf.product_id = p.product_id
         left join cust_dim c on sf.cust_id = c.cust_id
         LEFT OUTER JOIN (select accountid,ob_national_rep_id,ob_rep_id,ent_national_rep_id,ent_inside_rep_id,gk_segment segment,rep_4_id from qg_account@slx) qa ON c.acct_id = qa.accountid
         LEFT OUTER JOIN GK_ACCOUNT_SEGMENTS_MV sl ON c.acct_id = sl.accountid
         LEFT OUTER JOIN gk_territory gt
          ON     c.zipcode BETWEEN gt.zip_start AND gt.zip_end
          and substr(c.country,1,2) = 'US'
         left outer join userinfo@slx ui on ui.userid = qa.ob_rep_id
         left outer join userinfo@slx ui6 on ui6.userid = sl.ob_rep_id
         left outer join userinfo@slx ui2 on ui2.userid = qa.ent_national_rep_id
         left outer join userinfo@slx ui5 on ui5.userid = sl.field_rep_id
         left outer join userinfo@slx ui3 on ui3.userid = qa.rep_4_id
         left outer join userinfo@slx ui4 on ui4.userid = gt.userid
   WHERE TO_CHAR (trunc(sf.book_date), 'mm/yyyy') =  p_date -- TO_CHAR (TRUNC (SYSDATE), 'mm/yyyy')
   and sf.book_Amt<>'0'
   and sf.ppcard_id is not null;
  
  r1 c1%rowtype;
  v_file_name varchar2(50);
  v_file_name_full varchar2(250);
  p_DATE varchar2(10);
  l_DATE varchar2(10);
  v_hdr varchar2(1000);
  v_file utl_file.file_type;
  
  Begin
  
  select TO_CHAR (TRUNC (SYSDATE), 'mm/yyyy'), to_char(TRUNC (SYSDATE), 'MON-yyyy') into p_date,l_date from dual;

select l_date||'-Sales'||'.csv',
       '/usr/tmp/'||l_date||'-Sales'||'.csv'
  into v_file_name,v_file_name_full
  from dual;

select 'Transaction ID'||','||'Product Code'||','||'Geography Name'||','||'Sold to Account'||','||'Selling Price'||','||'Selling Price Currency'||','||
       'Incentive Date'||','||'Order Date'||','||'Order Type'||','||'Field Sales'||','||'Inside Sales'||','||'CSD'||','||
       'Channel'||','||'Product'||','||'Delivery Format'||','||'Event Type'||','||'Payment Method'||','||'Product Family'||','||'Product Type'||','||
       'Segment'||','||'Student Name'
  into v_hdr
  from dual;
  
  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

    utl_file.put_line(v_file,v_hdr);
end;
/


