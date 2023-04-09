DROP VIEW GKDW.GK_DAILY_SALES_BOOKINGS_V;

/* Formatted on 29/01/2021 11:38:04 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_DAILY_SALES_BOOKINGS_V
(
   TYPE,
   ENROLL_ID,
   EVENT_ID,
   ENROLL_STATUS,
   COUNTRY,
   BOOK_DATE,
   REV_DATE,
   BOOK_AMT,
   COURSE_CH,
   CH_NUM,
   COURSE_PL,
   PL_NUM,
   COURSE_MOD,
   MD_NUM,
   DIM_DATE,
   BOOK_MONTH,
   BOOK_YEAR,
   DAY_NUM,
   FISCAL_WEEK,
   FISCAL_YEAR,
   PAYMENT
)
AS
   SELECT   DISTINCT 'OE' TYPE,
                     enroll_id,
                     event_id,
                     enroll_status,
                     country,
                     book_date,
                     rev_date,
                     book_amt,
                     course_ch,
                     ch_num,
                     course_pl,
                     pl_num,
                     course_mod,
                     md_num,
                     dim_date,
                     book_month,
                     book_year,
                     day_num,
                     fiscal_week,
                     fiscal_year,
                     payment_type
     FROM   (SELECT   f.enroll_id,
                      f.event_id,
                      f.enroll_status,
                      TRUNC (f.book_date) book_date,
                      f.enroll_date,
                      f.rev_date,
                      ROUND (f.book_amt) book_amt,
                      cd.course_ch,
                      cd.ch_num,
                      cd.course_pl,
                      cd.pl_num,
                      cd.course_mod,
                      cd.md_num,
                      td1.dim_year book_year,
                      TO_CHAR (book_date, 'd') Day_num,
                      td1.dim_month book_month,
                      TRUNC (f.book_date) dim_date,
                      td1.fiscal_year,
                      td1.fiscal_week,
                      c.country,
                      f.payment_method payment_type
               --,sum(book_amt) over(partition by trunc(book_date) order by  trunc(book_date)) total_booking
               FROM               order_fact f
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
                      INNER JOIN
                         cust_dim c
                      ON f.cust_id = c.cust_id
              WHERE       cd.ch_num = 10
                      AND f.book_amt <> 0
                      AND td1.fiscal_year >= '2015' --and (td1.fiscal_week = :p_week or :p_week  is null)
                                                   --      and substr(upper(c.country),1,2) = :p_country
            )
   UNION
   -- Onsites/Dedicated/Enterprise
   SELECT   DISTINCT 'Dedicated' TYPE,
                     evxevenrollid,
                     EVXEVENTID,
                     enrollstatus,
                     country,
                     book_date,
                     rev_date,
                     book_amt,
                     course_ch,
                     ch_num,
                     course_pl,
                     pl_num,
                     course_mod,
                     md_num,
                     dim_date,
                     book_month,
                     book_year,
                     day_num,
                     fiscal_week,
                     fiscal_year,
                     payment_type
     FROM   (SELECT   t.evxevenrollid,
                      t.EVXEVENTID,
                      t.ENROLLSTATUS,
                      t.eventcountry country,
                      TRUNC (t."SYSDATE" - 1) book_date,
                      TRUNC (t."SYSDATE" - 1) enroll_date,
                      t.startdate rev_date,
                      t.actual_extended_amount book_amt,
                      cd.course_ch,
                      cd.ch_num,
                      cd.course_pl,
                      cd.pl_num,
                      cd.course_mod,
                      cd.md_num,
                      td1.dim_year book_year,
                      td1.dim_month book_month,
                      TRUNC (t."SYSDATE" - 1) dim_date,
                      TO_CHAR (TRUNC (t."SYSDATE" - 1), 'd') Day_num,
                      td1.fiscal_year,
                      td1.fiscal_week,
                      bp.method payment_type
               FROM               ent_trans_bookings_mv t
                               LEFT JOIN
                                  slxdw.evxbillpayment bp
                               ON t.evxbillingid = bp.evxbillingid
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
              WHERE   ROUND (t.actual_extended_amount) <> 0
                      AND td1.fiscal_year >= '2015' --and (td1.fiscal_week = :p_week or :p_week  is null)
                                                   --and substr(upper(t.eventcountry),1,2) =  :p_country
            )
   UNION
   -- Digital ('A' modality)
   SELECT   'Digital' TYPE,
            enroll_id,
            event_id,
            enroll_status,
            country,
            book_date,
            rev_date,
            book_amt,
            course_ch,
            ch_num,
            course_pl,
            pl_num,
            course_mod,
            md_num,
            dim_date,
            book_month,
            book_year,
            day_num,
            fiscal_week,
            fiscal_year,
            payment_type
     FROM   (SELECT   f.enroll_id,
                      f.event_id,
                      f.enroll_status,
                      TRUNC (f.book_date) book_date,
                      f.enroll_date,
                      f.rev_date,
                      f.book_amt book_amt,
                      cd.course_ch,
                      cd.ch_num,
                      cd.course_pl,
                      cd.pl_num,
                      cd.course_mod,
                      cd.md_num,
                      td1.dim_year book_year,
                      TO_CHAR (book_date, 'd') Day_num,
                      td1.dim_month book_month,
                      TRUNC (f.book_date) dim_date,
                      td1.fiscal_year,
                      td1.fiscal_week,
                      c.country                                   --a.country,
                               ,
                      SUM(book_amt)
                         OVER (PARTITION BY TRUNC (book_date)
                               ORDER BY TRUNC (book_date))
                         total_booking,
                      f.payment_method payment_type
               FROM               order_fact f
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
                      INNER JOIN
                         cust_dim c
                      ON f.cust_id = c.cust_id
              WHERE       cd.md_num = '33'
                      AND f.book_amt <> 0
                      AND td1.fiscal_year >= '2015' --and (td1.fiscal_week = :p_week or :p_week  is null)
                                                   --       and substr(upper(c.country),1,2) = :p_country
            )
   UNION
   -- Prepay Card Sales
   SELECT   'Pack sales' TYPE,
            evxppcardid,
            NULL,
            NULL,
            country,
            book_date,
            NULL rev_date,
            book_amt,
            NULL course_ch,
            NULL ch_num,
            NULL course_pl,
            NULL pl_num,
            NULL course_mod,
            NULL md_num,
            dim_date,
            book_month,
            book_year,
            day_num,
            fiscal_week,
            fiscal_year,
            payment_type
     FROM   (SELECT   ep.evxppcardid,
                      TRUNC (ep.issueddate) book_date,
                      cardstatus,
                      eo.billtocountry country,
                      cardtype,
                      ep.VALUEPURCHASEDBASE book_amt,
                      td1.dim_year book_year,
                      TO_CHAR (ep.issueddate, 'd') Day_num,
                      td1.dim_month book_month,
                      TRUNC (ep.issueddate) dim_date,
                      td1.fiscal_year,
                      td1.fiscal_week,
                      eb.method payment_type
               FROM                  slxdw.evxppcard ep
                                  INNER JOIN
                                     slxdw.evxso eo
                                  ON ep.evxsoid = eo.evxsoid
                               INNER JOIN
                                  slxdw.evxppcard_tx et
                               ON ep.evxppcardid = et.evxppcardid
                                  AND et.transdesc = 'Purchase'
                            INNER JOIN
                               gkdw.ppcard_dim pp
                            ON ep.EVXPPCARDID = pp.PPCARD_ID
                         INNER JOIN
                            time_dim td1
                         ON TRUNC (ep.issueddate) = td1.dim_date
                      LEFT OUTER JOIN
                         slxdw.evxbillpayment eb
                      ON et.EVXPPCARD_TXID = eb.EVXPPCARD_TXID
              WHERE   td1.fiscal_year >= '2015' --and (td1.fiscal_week = :p_week or :p_week  is null)
                                               AND ep.cardstatus != 'Void')
   UNION
   -- Prepay Burn down
   SELECT   DISTINCT 'Pack Burns' TYPE,
                     evxppcardid,
                     NULL,
                     NULL,
                     country,
                     book_date,
                     rev_date,
                     book_amt,
                     NULL course_ch,
                     NULL ch_num,
                     NULL course_pl,
                     NULL pl_num,
                     NULL course_mod,
                     NULL md_num,
                     dim_date,
                     book_month,
                     book_year,
                     day_num,
                     fiscal_week,
                     fiscal_year,
                     payment_type
     FROM   (SELECT   ep.evxppcardid,
                      TRUNC (et.transdate) book_date,
                      eo.billtocountry country,
                      cardtype,
                      et.valueprepaybase book_amt,
                      td1.dim_year book_year,
                      TO_CHAR (et.transdate, 'd') Day_num,
                      td1.dim_month book_month,
                      TRUNC (et.transdate) dim_date,
                      td1.fiscal_year,
                      td1.fiscal_week,
                      NVL (ee.startdate, es.createdate) rev_date,
                      eb.method payment_type
               FROM                           slxdw.evxppcard ep
                                           --    inner join gkdw.ppcard_dim pp on ep.EVXPPCARDID = pp.PPCARD_ID
                                           INNER JOIN
                                              slxdw.evxso eo
                                           ON ep.evxsoid = eo.evxsoid
                                        INNER JOIN
                                           slxdw.evxppcard_tx et
                                        ON ep.evxppcardid = et.evxppcardid
                                           AND et.transdesc != 'Purchase'
                                     INNER JOIN
                                        time_dim td1
                                     ON TRUNC (et.transdate) = td1.dim_date
                                  LEFT OUTER JOIN
                                     slxdw.evxbillpayment eb
                                  ON et.evxbillpaymentid =
                                        eb.evxbillpaymentid
                               LEFT OUTER JOIN
                                  slxdw.qg_billingpayment qb
                               ON eb.evxbillpaymentid = qb.evxbillpaymentid
                            LEFT OUTER JOIN
                               slxdw.evxenrollhx eh
                            ON qb.evxevenrollid = eh.evxevenrollid
                         LEFT OUTER JOIN
                            slxdw.evxevent ee
                         ON eh.evxeventid = ee.evxeventid
                      LEFT OUTER JOIN
                         slxdw.evxso es
                      ON eb.evxsoid = es.evxsoid
              WHERE   td1.fiscal_year >= '2015' AND -- (td1.fiscal_week = :p_week or :p_week  is null) and
                                                   ep.cardstatus != 'Void' --and substr(upper(eo.billtocountry),1,2) = :p_country
                                                                          );


