DROP MATERIALIZED VIEW GKDW.GK_DAILY_SALES_BOOKINGS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_DAILY_SALES_BOOKINGS_MV 
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
NOLOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:25:18 (QP5 v5.115.810.9015) */
SELECT   'OE' TYPE,
         f.enroll_id,
         f.event_id,
         NULL evxppcardid,
         TRUNC (f.book_date) book_date,
         TRUNC (f.enroll_date) enroll_date,
         TRUNC (f.rev_date) rev_date,
         f.book_amt,
         cd.course_ch,
         cd.ch_num,
         cd.course_pl,
         cd.pl_num,
         cd.course_mod,
         cd.md_num,
         td1.dim_year book_year,
         TO_CHAR (book_date, 'd') Day_num,
         td1.dim_month book_month,
         TRUNC (f.book_date) dim_day,
         td1.fiscal_year,
         td1.fiscal_week,
         UPPER (c.country) country,
         CASE
            WHEN SUBSTR (UPPER (c.country), 1, 2) = 'CA' THEN 'CANADA'
            ELSE 'USA'
         END
            Revenue_country
  FROM               order_fact f
                  INNER JOIN
                     event_dim ed
                  ON f.event_id = ed.event_id
               INNER JOIN
                  course_dim cd
               ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
            INNER JOIN
               time_dim td1
            ON TRUNC (f.book_date) = td1.dim_date
         INNER JOIN
            cust_dim c
         ON f.cust_id = c.cust_id
 WHERE   cd.ch_num = '10' AND f.book_amt <> 0 AND td1.fiscal_year >= 2015
UNION
SELECT   'Dedicated' TYPE,
         evxevenrollid,
         EVXEVENTID,
         NULL evxppcardid,
         book_date,
         enroll_date,
         rev_date,
         book_amt,
         course_ch,
         ch_num,
         course_pl,
         pl_num,
         course_mod,
         md_num,
         book_year,
         Day_num,
         book_month,
         dim_day,
         fiscal_year,
         fiscal_week,
         country,
         Revenue_country
  FROM   (SELECT   t.evxevenrollid,
                   t.EVXEVENTID,
                   TRUNC (t."SYSDATE" - 1) book_date,
                   TRUNC (t."SYSDATE" - 1) enroll_date,
                   TRUNC (t.startdate) rev_date,
                   t.actual_extended_amount book_amt,
                   cd.course_ch,
                   cd.ch_num,
                   cd.course_pl,
                   cd.pl_num,
                   cd.course_mod,
                   cd.md_num,
                   td1.dim_year book_year,
                   td1.dim_month book_month,
                   UPPER (t.eventcountry) country,
                   CASE
                      WHEN md_num = '20'
                      THEN
                         CASE
                            WHEN SUBSTR (UPPER (c.country), 1, 2) = 'CA'
                            THEN
                               'CANADA'
                            ELSE
                               'USA'
                         END
                      ELSE
                         CASE
                            WHEN SUBSTR (UPPER (t.eventcountry), 1, 2) = 'CA'
                            THEN
                               'CANADA'
                            ELSE
                               'USA'
                         END
                   END
                      Revenue_country,
                   TRUNC (t."SYSDATE" - 1) dim_day,
                   TO_CHAR (TRUNC (t."SYSDATE" - 1), 'd') Day_num,
                   td1.fiscal_year,
                   td1.fiscal_week
            FROM               ent_trans_bookings_mv t
                            INNER JOIN
                               event_dim ed
                            ON t.evxeventid = ed.event_id
                         INNER JOIN
                            course_dim cd
                         ON ed.course_id = cd.course_id
                            AND ed.ops_country = cd.country
                      INNER JOIN
                         time_dim td1
                      ON TRUNC (t."SYSDATE" - 1) = td1.dim_date
                   INNER JOIN
                      cust_dim c
                   ON t.contactid = c.cust_id
           WHERE       ROUND (t.actual_extended_amount) <> 0
                   AND NVL (cd.ch_num, 0) <> '35'
                   AND td1.fiscal_year >= 2015)
UNION
SELECT   'Room Rental' TYPE,
         evxevenrollid,
         EVXEVENTID,
         NULL evxppcardid,
         book_date,
         enroll_date,
         rev_date,
         book_amt,
         course_ch,
         ch_num,
         course_pl,
         pl_num,
         course_mod,
         md_num,
         book_year,
         Day_num,
         book_month,
         dim_day,
         fiscal_year,
         fiscal_week,
         country,
         Revenue_country
  FROM   (--SELECT t.evxevenrollid,
          --               t.EVXEVENTID,
          --               TRUNC (t."SYSDATE" - 1)                book_date,
          --               TRUNC (t."SYSDATE" - 1)                enroll_date,
          --               TRUNC (t.startdate)                    rev_date,
          --               t.actual_extended_amount               book_amt,
          --               cd.course_ch,
          --               cd.ch_num,
          --               cd.course_pl,
          --               cd.pl_num,
          --               cd.course_mod,
          --               cd.md_num,
          --               td1.dim_year                           book_year,
          --               td1.dim_month                          book_month,
          --               UPPER (t.eventcountry)                 country,
          --               CASE
          --                   WHEN SUBSTR (UPPER (t.eventcountry), 1, 2) = 'CA'
          --                   THEN
          --                       'CANADA'
          --                   ELSE
          --                       'USA'
          --               END
          --                   Revenue_country,
          --               TRUNC (t."SYSDATE" - 1)                dim_day,
          --               TO_CHAR (TRUNC (t."SYSDATE" - 1), 'd') Day_num,
          --               td1.fiscal_year,
          --               td1.fiscal_week
          --          FROM ent_trans_bookings_mv  t
          --               INNER JOIN event_dim ed ON t.evxeventid = ed.event_id
          --               INNER JOIN course_dim cd
          --                   ON     ed.course_id = cd.course_id
          --                      AND ed.ops_country = cd.country
          --               INNER JOIN time_dim td1
          --                   ON TRUNC (t."SYSDATE" - 1) = td1.dim_date
          --         WHERE     ROUND (t.actual_extended_amount) <> 0
          --               AND NVL (cd.ch_num, 0) = '35'
          --               AND td1.fiscal_year >= 2015
          --        UNION
          SELECT   f.enroll_id evxevenrollid,
                   f.event_id evxeventid,
                   TRUNC (f.book_date) book_date,
                   TRUNC (f.enroll_date) enroll_date,
                   TRUNC (f.rev_date) rev_date,
                   f.book_amt,
                   cd.course_ch,
                   cd.ch_num,
                   cd.course_pl,
                   cd.pl_num,
                   cd.course_mod,
                   cd.md_num,
                   td1.dim_year book_year,
                   td1.dim_month book_month,
                   UPPER (ed.country) country,
                   CASE
                      WHEN SUBSTR (UPPER (ed.country), 1, 2) = 'CA'
                      THEN
                         'CANADA'
                      ELSE
                         'USA'
                   END
                      Revenue_country,
                   TRUNC (f.book_date) dim_day,
                   TO_CHAR (book_date, 'd') Day_num,
                   td1.fiscal_year,
                   td1.fiscal_week
            FROM            order_fact f
                         INNER JOIN
                            event_dim ed
                         ON f.event_id = ed.event_id
                      INNER JOIN
                         course_dim cd
                      ON ed.course_id = cd.course_id
                         AND ed.ops_country = cd.country
                   INNER JOIN
                      time_dim td1
                   ON TRUNC (f.book_date) = td1.dim_date
           -- INNER JOIN cust_dim c ON f.cust_id = c.cust_id
           WHERE       cd.ch_num = '35'
                   AND f.book_amt <> 0
                   AND td1.fiscal_year >= 2015)
UNION
SELECT   'Digital' TYPE,
         f.enroll_id,
         f.event_id,
         NULL evxppcardid,
         TRUNC (f.book_date) book_date,
         TRUNC (f.enroll_date),
         TRUNC (f.rev_date),
         f.book_amt,
         cd.course_ch,
         cd.ch_num,
         cd.course_pl,
         cd.pl_num,
         cd.course_mod,
         cd.md_num,
         td1.dim_year book_year,
         TO_CHAR (book_date, 'd') Day_num,
         td1.dim_month book_month,
         TRUNC (f.book_date) dim_day,
         td1.fiscal_year,
         td1.fiscal_week,
         UPPER (c.country),
         CASE
            WHEN SUBSTR (UPPER (c.country), 1, 2) = 'CA' THEN 'CANADA'
            ELSE 'USA'
         END
            Revenue_country
  FROM               order_fact f
                  INNER JOIN
                     event_dim ed
                  ON f.event_id = ed.event_id
               INNER JOIN
                  course_dim cd
               ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
            INNER JOIN
               time_dim td1
            ON TRUNC (f.book_date) = td1.dim_date
         INNER JOIN
            cust_dim c
         ON f.cust_id = c.cust_id
 WHERE   cd.md_num = '33' AND f.book_amt <> 0 AND td1.fiscal_year >= 2015
UNION
-- Prepay Card Sales
SELECT   'Pack Sales' TYPE,
         NULL,
         NULL,
         evxppcardid,
         book_date,
         NULL,
         NULL,
         book_amt,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         book_year,
         Day_num,
         book_month,
         dim_day,
         Fiscal_Year,
         fiscal_week,
         UPPER (country),
         CASE
            WHEN SUBSTR (UPPER (country), 1, 2) = 'CA' THEN 'CANADA'
            ELSE 'USA'
         END
            Revenue_country
  FROM   (SELECT   ep.evxppcardid,
                   TRUNC (ep.issueddate) book_date,
                   cardstatus,
                   eo.billtocountry country,
                   cardtype,
                   ep.VALUEPURCHASEDBASE book_amt,
                   td1.dim_year book_year,
                   TO_CHAR (ep.issueddate, 'd') Day_num,
                   td1.dim_month book_month,
                   TRUNC (ep.issueddate) dim_day,
                   td1.fiscal_year,
                   td1.fiscal_week
            FROM            slxdw.evxppcard ep
                         INNER JOIN
                            slxdw.evxso eo
                         ON ep.evxsoid = eo.evxsoid
                      INNER JOIN
                         gkdw.ppcard_dim pp
                      ON ep.EVXPPCARDID = pp.PPCARD_ID
                   INNER JOIN
                      time_dim td1
                   ON TRUNC (ep.issueddate) = td1.dim_date
           WHERE   td1.fiscal_year >= '2015'    -- AND ep.cardstatus != 'Void'
                                            )
UNION                                            -- Pack sales negative record
SELECT   'Pack Sales' TYPE,
         NULL,
         NULL,
         evxppcardid,
         book_date,
         NULL,
         NULL,
         -1 * book_amt,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         book_year,
         Day_num,
         book_month,
         dim_day,
         Fiscal_Year,
         fiscal_week,
         UPPER (country),
         CASE
            WHEN SUBSTR (UPPER (country), 1, 2) = 'CA' THEN 'CANADA'
            ELSE 'USA'
         END
            Revenue_country
  FROM   (SELECT   ep.evxppcardid,
                   ep.cardstatus,
                   TRUNC (eo.modifydate) book_date,
                   cardstatus,
                   eo.billtocountry country,
                   cardtype,
                   ep.VALUEPURCHASEDBASE book_amt,
                   td1.dim_year book_year,
                   TO_CHAR (eo.modifydate, 'd') Day_num,
                   td1.dim_month book_month,
                   TRUNC (eo.modifydate) dim_day,
                   td1.fiscal_year,
                   td1.fiscal_week
            FROM            slxdw.evxppcard ep
                         INNER JOIN
                            slxdw.evxso eo
                         ON ep.evxsoid = eo.evxsoid
                      INNER JOIN
                         gkdw.ppcard_dim pp
                      ON ep.EVXPPCARDID = pp.PPCARD_ID
                   INNER JOIN
                      time_dim td1
                   ON TRUNC (eo.modifydate) = td1.dim_date
           WHERE   td1.fiscal_year >= '2015' AND ep.cardstatus = 'Void' -- and ep.evxppcardid in ('Q6UJ90APPPWH','Q6UJ90ATPK7W')
                                                                       )
UNION
SELECT   DISTINCT
         'Pack Burns' TYPE,
         evxevenrollid,
         evxeventid,
         evxppcardid,
         TRUNC (book_date),
         NULL,
         NULL,
         book_amt,
         course_ch,
         ch_num,
         course_pl,
         pl_num,
         course_mod,
         md_num,
         book_year,
         day_num,
         book_month,
         dim_day,
         fiscal_year,
         fiscal_week,
         UPPER (billtocountry),
         CASE
            WHEN SUBSTR (UPPER (billtocountry), 1, 2) = 'CA' THEN 'CANADA'
            ELSE 'USA'
         END
            Revenue_country
  FROM   (SELECT   ep.evxppcardid,
                   qb.evxevenrollid,
                   eh.evxeventid,
                   cd.course_ch,
                   cd.ch_num,
                   cd.course_pl,
                   cd.pl_num,
                   cd.course_mod,
                   cd.md_num,
                   TRUNC (et.transdate) book_date,
                   eo.billtocountry,
                   cardtype,
                   et.valueprepaybase book_amt,
                   td1.dim_year book_year,
                   TO_CHAR (et.transdate, 'd') Day_num,
                   td1.dim_month book_month,
                   TRUNC (et.transdate) dim_day,
                   td1.fiscal_year,
                   td1.fiscal_week,
                   NVL (ee.startdate, es.createdate) rev_date
            FROM                                 slxdw.evxppcard ep
                                              --    inner join gkdw.ppcard_dim pp on ep.EVXPPCARDID = pp.PPCARD_ID
                                              INNER JOIN
                                                 slxdw.evxso eo
                                              ON ep.evxsoid = eo.evxsoid
                                           INNER JOIN
                                              slxdw.evxppcard_tx et
                                           ON ep.evxppcardid = et.evxppcardid
                                              AND et.transdesc != 'Purchase'
                                              AND et.transdesc != 'Expiry'
                                        INNER JOIN
                                           time_dim td1
                                        ON TRUNC (et.transdate) =
                                              td1.dim_date
                                     LEFT OUTER JOIN
                                        slxdw.evxbillpayment eb
                                     ON et.evxbillpaymentid =
                                           eb.evxbillpaymentid
                                  LEFT OUTER JOIN
                                     slxdw.qg_billingpayment qb
                                  ON eb.evxbillpaymentid =
                                        qb.evxbillpaymentid
                               LEFT OUTER JOIN
                                  slxdw.evxenrollhx eh
                               ON qb.evxevenrollid = eh.evxevenrollid
                            LEFT OUTER JOIN
                               slxdw.evxevent ee
                            ON eh.evxeventid = ee.evxeventid
                         LEFT OUTER JOIN
                            event_dim ed
                         ON ee.evxeventid = ed.event_id
                      LEFT OUTER JOIN
                         course_dim cd
                      ON ed.course_id = cd.course_id
                         AND ed.ops_country = cd.country
                   LEFT OUTER JOIN
                      slxdw.evxso es
                   ON eb.evxsoid = es.evxsoid
           WHERE   td1.fiscal_year >= '2015' AND --(td1.fiscal_week = :p_week or :p_week  is null) and
                                                ep.cardstatus != 'Void' --and substr(upper(eo.billtocountry),1,2) =:p_country
                                                                       );

COMMENT ON MATERIALIZED VIEW GKDW.GK_DAILY_SALES_BOOKINGS_MV IS 'snapshot table for snapshot GKDW.GK_DAILY_SALES_BOOKINGS_MV';

GRANT SELECT ON GKDW.GK_DAILY_SALES_BOOKINGS_MV TO COGNOS_RO;

GRANT SELECT ON GKDW.GK_DAILY_SALES_BOOKINGS_MV TO DWHREAD;

