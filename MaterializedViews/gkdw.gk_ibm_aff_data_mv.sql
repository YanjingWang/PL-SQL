DROP MATERIALIZED VIEW GKDW.GK_IBM_AFF_DATA_MV;
CREATE MATERIALIZED VIEW GKDW.GK_IBM_AFF_DATA_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
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
/* Formatted on 29/01/2021 12:25:00 (QP5 v5.115.810.9015) */
SELECT   f.enroll_id,
         c.first_name,
         c.last_name,
         c.email userid,
         c.email,
         SUBSTR (c.email, INSTR (c.email, '@') + 1) orgid,
         'EN' language,
         c.workphone,
         tx.coursecode,
         CASE
            WHEN tx.modality LIKE '%SPVC%' THEN 'SPVC'
            WHEN tx.modality LIKE '%WBT%' THEN 'WBT'
         END
            modality,
         ed.event_id class_num,
         c.acct_id customer_num,
         SUBSTR (c.email, INSTR (c.email, '@') + 1) oid,
         f.book_date start_date,
         f.book_date + 90 end_date,
         c.cust_id studentid,
         f.enroll_id log_num,
         CASE WHEN f.enroll_status = 'Cancelled' THEN 'CANC' ELSE 'CONF' END
            enrollstat,
         c.cust_name contact_name,
         REPLACE (REPLACE (c.acct_name, ',', ''), CHR (39), '') customer_name,
         CASE WHEN ed.ops_country = 'USA' THEN '897' ELSE '649' END country,
         '2' email_type,
         '1' brand_id,
         TO_CHAR (f.creation_date, 'yyyy-mm-dd hh24:mi:ss') insertts,
         TO_CHAR (SYSDATE, 'yyyy-mm-dd hh24:mi:ss') create_time,
         f.quantity quantity,
         '2' delivery_type,
         84 org_id,
         101 inv_org_id,
         CASE WHEN UPPER (c.country) = 'CANADA' THEN '220' ELSE '210' END le,
         '130' fe,
         '62405' acct,
         '10' ch,
         '32' md,
         '19' pl,
         cd.act_num act,
         '200' cc,
            'SPEL WEB ENROLLMENT: '
         || f.enroll_id
         || ' - STUDENT: '
         || c.first_name
         || ' '
         || c.last_name
            po_line_desc,
         CASE
            WHEN cd.list_price = 0 THEN 0
            WHEN tx.modality LIKE '%SPVC%' THEN 150
            WHEN tx.modality LIKE '%WBT%' THEN 30
         END
            po_line_amt,
         CASE WHEN ed.ops_country = 'USA' THEN '897' ELSE '649' END
            country_id
  FROM                  course_dim cd
                     INNER JOIN
                        event_dim ed
                     ON cd.course_id = ed.course_id
                        AND cd.country = ed.ops_country
                  INNER JOIN
                     order_fact f
                  ON ed.event_id = f.event_id
               INNER JOIN
                  cust_dim c
               ON f.cust_id = c.cust_id
            INNER JOIN
               ibm_tier_xml tx
            ON cd.mfg_course_code = tx.coursecode
               AND (tx.modality LIKE '%SPVC%' OR tx.modality LIKE '%WBT%')
         LEFT OUTER JOIN
            ibm_spel_web_modality wl
         ON cd.course_code = wl.course_code
 WHERE       cd.md_num = '32'
         AND cd.course_pl = 'IBM'
         AND f.enroll_status != 'Cancelled'
         AND NOT EXISTS (SELECT   1
                           FROM   gk_ibm_aff_audit a
                          WHERE   f.enroll_id = a.enroll_id);

COMMENT ON MATERIALIZED VIEW GKDW.GK_IBM_AFF_DATA_MV IS 'snapshot table for snapshot GKDW.GK_IBM_AFF_DATA_MV';

GRANT SELECT ON GKDW.GK_IBM_AFF_DATA_MV TO DWHREAD;

