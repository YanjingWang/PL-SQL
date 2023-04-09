DROP VIEW GKDW.GK_SALES_CONTACT_V;

/* Formatted on 29/01/2021 11:27:19 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SALES_CONTACT_V
(
   CUST_ID,
   CUST_NAME,
   ACCT_ID,
   ACCT_NAME,
   MIN_ENROLL_DATE,
   ENROLL_CNT,
   CONTACT_ACT_CNT,
   ACCOUNT_ACT_CNT
)
AS
     SELECT   q3.cust_id,
              q3.cust_name,
              q3.acct_id,
              q3.acct_name,
              q3.min_enroll_date,
              q3.enroll_cnt,
              q3.contact_act_cnt,
              SUM (NVL (q4.account_act_cnt, 0)) account_act_cnt
       FROM      (  SELECT   q1.cust_id,
                             q1.cust_name,
                             q1.acct_id,
                             q1.acct_name,
                             q1.min_enroll_date,
                             q1.enroll_cnt,
                             SUM (NVL (q2.contact_act_cnt, 0)) contact_act_cnt
                      FROM      (  SELECT   f.cust_id,
                                            cd.cust_name,
                                            cd.acct_id,
                                            cd.acct_name,
                                            MIN (enroll_date) min_enroll_date,
                                            COUNT (DISTINCT f.enroll_id) enroll_cnt
                                     FROM      order_fact f
                                            INNER JOIN
                                               cust_dim cd
                                            ON f.cust_id = cd.cust_id
                                    WHERE   f.cust_id IN
                                                  ('C6UJ9A03M7CP',
                                                   'C6UJ9A03JYZX',
                                                   'C6UJ9A03EAX1',
                                                   'C6UJ9A03E02J',
                                                   'C6UJ9A03BERQ',
                                                   'C6UJ9A03D9UW',
                                                   'C6UJ9A03C4R4',
                                                   'C6UJ9A03E9XA',
                                                   'C6UJ9A02S8D1')
                                 GROUP BY   f.cust_id,
                                            cd.cust_name,
                                            cd.acct_id,
                                            cd.acct_name) q1
                             LEFT OUTER JOIN
                                (  SELECT   h.contactid,
                                            TRUNC (h.createdate) act_date,
                                            COUNT (DISTINCT h.activityid)
                                               contact_act_cnt
                                     FROM   slxdw.history h
                                    WHERE   contactid IN
                                                  ('C6UJ9A03M7CP',
                                                   'C6UJ9A03JYZX',
                                                   'C6UJ9A03EAX1',
                                                   'C6UJ9A03E02J',
                                                   'C6UJ9A03BERQ',
                                                   'C6UJ9A03D9UW',
                                                   'C6UJ9A03C4R4',
                                                   'C6UJ9A03E9XA',
                                                   'C6UJ9A02S8D1')
                                 GROUP BY   h.contactid, TRUNC (h.createdate)) q2
                             ON q1.cust_id = q2.contactid
                                AND q1.min_enroll_date >= q2.act_date
                  GROUP BY   q1.cust_id,
                             q1.cust_name,
                             q1.acct_id,
                             q1.acct_name,
                             q1.min_enroll_date,
                             q1.enroll_cnt) q3
              LEFT OUTER JOIN
                 (  SELECT   h.accountid,
                             TRUNC (h.createdate) act_date,
                             COUNT (DISTINCT h.activityid) account_act_cnt
                      FROM      cust_dim cd
                             INNER JOIN
                                slxdw.history h
                             ON cd.acct_id = h.accountid
                     WHERE   cd.cust_id IN
                                   ('C6UJ9A03M7CP',
                                    'C6UJ9A03JYZX',
                                    'C6UJ9A03EAX1',
                                    'C6UJ9A03E02J',
                                    'C6UJ9A03BERQ',
                                    'C6UJ9A03D9UW',
                                    'C6UJ9A03C4R4',
                                    'C6UJ9A03E9XA',
                                    'C6UJ9A02S8D1')
                  GROUP BY   h.accountid, TRUNC (h.createdate)) q4
              ON q3.acct_id = q4.accountid
                 AND q3.min_enroll_date >= q4.act_date
   GROUP BY   q3.cust_id,
              q3.cust_name,
              q3.acct_id,
              q3.acct_name,
              q3.min_enroll_date,
              q3.enroll_cnt,
              q3.contact_act_cnt;


