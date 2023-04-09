DROP MATERIALIZED VIEW GKDW.GK_TPS_DATA_MV;
CREATE MATERIALIZED VIEW GKDW.GK_TPS_DATA_MV 
TABLESPACE GDWMED
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
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
/* Formatted on 29/01/2021 12:21:14 (QP5 v5.115.810.9015) */
SELECT   "TAB_TYPE",
         "SALES_REP",
         "SALES_REP_EMAIL",
         "MANAGER_NAME",
         "MANAGER_EMAIL",
         "DIM_YEAR",
         "DIM_MONTH_NUM",
         "BOOK_MO",
         "BOOK_DATE",
         "BOOK_AMT",
         "CUSTOMER_PARENT",
         "SALES_TEAM",
         "EVXEVENROLLID",
         "EVENTID",
         "COURSECODE",
         "EVENTNAME",
         "STARTDATE",
         "PREPAY_CARD",
         "PACK_ISSUED",
         "STUDENT_POSTALCODE",
         "PROVINCE",
         "PACK_TYPE",
         "EVENTCOUNTRY"
  FROM   (SELECT   'Dedicated Bookings' tab_type,
                   ui.username sales_rep,
                   CASE
                      WHEN ui.email IS NULL AND ui.firstname IS NULL
                      THEN
                         REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN ui.email IS NULL
                      THEN
                            REPLACE (ui.firstname, ' ', '')
                         || '.'
                         || REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         ui.email
                   END
                      sales_rep_email,
                   um.username manager_name,
                   CASE
                      WHEN um.email IS NULL AND um.firstname IS NULL
                      THEN
                         REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN um.email IS NULL
                      THEN
                            REPLACE (um.firstname, ' ', '')
                         || '.'
                         || REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         um.email
                   END
                      manager_email,
                   td.dim_year,
                   td.dim_month_num,
                   SUBSTR (td.dim_month, 1, 3) book_mo,
                   TRUNC (et.createdate) book_date,
                   actual_extended_amount book_amt,
                   et.account customer_parent,
                   ui.division sales_team,
                   et.evxevenrollid,
                   et.evxeventid eventid,
                   et.coursecode,
                   et.eventname,
                   et.startdate,
                   NULL course_lob,
                   et.evxppcardid prepay_card,
                   NULL pack_issued,
                   et.student_postalcode,
                   NULL first_digit,
                   CASE
                      WHEN UPPER (a.country) = 'CANADA' THEN a.state
                      ELSE NULL
                   END
                      province,
                   NULL pack_type,
                   UPPER (et.eventcountry) eventcountry
            FROM                     ent_trans_bookings_mv et
                                  INNER JOIN
                                     slxdw.userinfo ui
                                  ON REPLACE (UPPER (et.sold_by), ' ', '') =
                                        REPLACE (UPPER (ui.username),
                                                 ' ',
                                                 '')
                               INNER JOIN
                                  slxdw.usersecurity us
                               ON ui.userid = us.userid AND us.enabled = 'T'
                            LEFT OUTER JOIN
                               slxdw.userinfo um
                            ON us.managerid = um.userid
                         INNER JOIN
                            time_dim td
                         ON TRUNC (et.createdate) = td.dim_date
                      INNER JOIN
                         slxdw.contact c
                      ON et.contactid = c.contactid
                   INNER JOIN
                      slxdw.address a
                   ON c.contactid = a.entityid AND a.isprimary = 'T'
           WHERE   td.dim_year >= EXTRACT (YEAR FROM SYSDATE)
          UNION
          SELECT   'Misc Items' tab_type,
                   ui.username sales_rep,
                   CASE
                      WHEN ui.email IS NULL AND ui.firstname IS NULL
                      THEN
                         REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN ui.email IS NULL
                      THEN
                            REPLACE (ui.firstname, ' ', '')
                         || '.'
                         || REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         ui.email
                   END
                      sales_rep_email,
                   um.username manager_name,
                   CASE
                      WHEN um.email IS NULL AND um.firstname IS NULL
                      THEN
                         REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN um.email IS NULL
                      THEN
                            REPLACE (um.firstname, ' ', '')
                         || '.'
                         || REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         um.email
                   END
                      manager_email,
                   td.dim_year,
                   td.dim_month_num,
                   SUBSTR (td.dim_month, 1, 3) book_mo,
                   TO_DATE (
                         LPAD (book_mon, 2, '0')
                      || '/'
                      || LPAD (book_day, 2, '0')
                      || '/20'
                      || LPAD (book_year, 2, '0'),
                      'mm/dd/yyyy'
                   )
                      book_date,
                   TO_NUMBER (amount) book_amount,
                   eb.customer_name,
                   ui.division sales_team,
                   NULL evxevenrollid,
                   NULL eventid,
                   NULL coursecode,
                   eb.project_name,
                   NULL startdate,
                   NULL course_lob,
                   NULL prepay_card,
                   NULL pack_issued,
                   NULL student_postalcode,
                   NULL first_digit,
                   NULL province,
                   NULL pack_type,
                   'USA' eventcountry
            FROM               gk_misc_ent_bookings eb
                            INNER JOIN
                               time_dim td
                            ON TO_DATE (
                                     LPAD (book_mon, 2, '0')
                                  || '/'
                                  || LPAD (book_day, 2, '0')
                                  || '/20'
                                  || LPAD (book_year, 2, '0'),
                                  'mm/dd/yyyy'
                               ) = td.dim_date
                         INNER JOIN
                            slxdw.userinfo ui
                         ON REPLACE (UPPER (eb.sales_rep), ' ', '') =
                               REPLACE (UPPER (ui.username), ' ', '')
                      INNER JOIN
                         slxdw.usersecurity us
                      ON ui.userid = us.userid AND us.enabled = 'T'
                   LEFT OUTER JOIN
                      slxdw.userinfo um
                   ON us.managerid = um.userid
           WHERE       misc_type = 'Onsite'
                   AND eb.book_mon BETWEEN '1' AND '12'
                   AND td.dim_year >= EXTRACT (YEAR FROM SYSDATE)
          UNION
          SELECT   'ELS Items' tab_type,
                   ui.username sales_rep,
                   CASE
                      WHEN ui.email IS NULL AND ui.firstname IS NULL
                      THEN
                         REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN ui.email IS NULL
                      THEN
                            REPLACE (ui.firstname, ' ', '')
                         || '.'
                         || REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         ui.email
                   END
                      sales_rep_email,
                   um.username manager_name,
                   CASE
                      WHEN um.email IS NULL AND um.firstname IS NULL
                      THEN
                         REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN um.email IS NULL
                      THEN
                            REPLACE (um.firstname, ' ', '')
                         || '.'
                         || REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         um.email
                   END
                      manager_email,
                   td.dim_year,
                   td.dim_month_num,
                   SUBSTR (td.dim_month, 1, 3) book_mo,
                   TO_DATE (
                         LPAD (book_mon, 2, '0')
                      || '/'
                      || LPAD (book_day, 2, '0')
                      || '/20'
                      || LPAD (book_year, 2, '0'),
                      'mm/dd/yyyy'
                   )
                      book_date,
                   TO_NUMBER (amount) book_amount,
                   eb.customer_name,
                   ui.division sales_team,
                   NULL evxevenrollid,
                   NULL eventid,
                   NULL coursecode,
                   eb.project_name,
                   NULL startdate,
                   NULL course_lob,
                   NULL prepay_card,
                   NULL pack_issued,
                   NULL student_postalcode,
                   NULL first_digit,
                   NULL province,
                   NULL pack_type,
                   'USA' eventcountry
            FROM               gk_misc_ent_bookings eb
                            INNER JOIN
                               time_dim td
                            ON TO_DATE (
                                     LPAD (book_mon, 2, '0')
                                  || '/'
                                  || LPAD (book_day, 2, '0')
                                  || '/20'
                                  || LPAD (book_year, 2, '0'),
                                  'mm/dd/yyyy'
                               ) = td.dim_date
                         INNER JOIN
                            slxdw.userinfo ui
                         ON REPLACE (UPPER (eb.sales_rep), ' ', '') =
                               REPLACE (UPPER (ui.username), ' ', '')
                      INNER JOIN
                         slxdw.usersecurity us
                      ON ui.userid = us.userid AND us.enabled = 'T'
                   LEFT OUTER JOIN
                      slxdw.userinfo um
                   ON us.managerid = um.userid
           WHERE       misc_type = 'ELS'
                   AND eb.book_mon BETWEEN '1' AND '12'
                   AND td.dim_year >= EXTRACT (YEAR FROM SYSDATE)
          UNION
          SELECT   'OE Bookings' tab_type,
                   ui.username sales_rep,
                   CASE
                      WHEN ui.email IS NULL AND ui.firstname IS NULL
                      THEN
                         REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN ui.email IS NULL
                      THEN
                            REPLACE (ui.firstname, ' ', '')
                         || '.'
                         || REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         ui.email
                   END
                      sales_rep_email,
                   um.username manager_name,
                   CASE
                      WHEN um.email IS NULL AND um.firstname IS NULL
                      THEN
                         REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN um.email IS NULL
                      THEN
                            REPLACE (um.firstname, ' ', '')
                         || '.'
                         || REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         um.email
                   END
                      manager_email,
                   td.dim_year,
                   td.dim_month_num,
                   SUBSTR (td.dim_month, 1, 3) book_mo,
                   tps2.book_date,
                   tps2.book_amt,
                   tps2.acct_name customer_parent,
                   ui.division sales_team,
                   tps2.enroll_id,
                   tps2.event_id,
                   tps2.course_code,
                   tps2.course_name,
                   TRUNC (tps2.start_date),
                   NULL course_lob,
                   tps2.ppcard_id,
                   NULL pack_issued,
                   tps2.zipcode,
                   NULL first_digit,
                   tps2.province,
                   NULL pack_type,
                   UPPER (tps2.ops_country) eventcountry
            FROM               tps_2_oe_ch_mp_v tps2
                            INNER JOIN
                               slxdw.userinfo ui
                            ON REPLACE (UPPER (tps2.channel_manager),
                                        ' ',
                                        '') =
                                  REPLACE (UPPER (ui.username), ' ', '')
                         INNER JOIN
                            slxdw.usersecurity us
                         ON ui.userid = us.userid AND us.enabled = 'T'
                      LEFT OUTER JOIN
                         slxdw.userinfo um
                      ON us.managerid = um.userid
                   INNER JOIN
                      time_dim td
                   ON tps2.book_date = td.dim_date
           WHERE   td.dim_year >= EXTRACT (YEAR FROM SYSDATE)
          UNION
          SELECT   'OE Bookings' tab_type,
                   ui.username sales_rep,
                   CASE
                      WHEN ui.email IS NULL AND ui.firstname IS NULL
                      THEN
                         REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN ui.email IS NULL
                      THEN
                            REPLACE (ui.firstname, ' ', '')
                         || '.'
                         || REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         ui.email
                   END
                      sales_rep_email,
                   um.username manager_name,
                   CASE
                      WHEN um.email IS NULL AND um.firstname IS NULL
                      THEN
                         REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN um.email IS NULL
                      THEN
                            REPLACE (um.firstname, ' ', '')
                         || '.'
                         || REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         um.email
                   END
                      manager_email,
                   td.dim_year,
                   td.dim_month_num,
                   SUBSTR (td.dim_month, 1, 3) book_mo,
                   tps2.book_date,
                   tps2.book_amt * .5,
                   tps2.acct_name customer_parent,
                   ui.division sales_team,
                   tps2.enroll_id,
                   tps2.event_id,
                   tps2.course_code,
                   tps2.course_name,
                   TRUNC (tps2.start_date),
                   NULL course_lob,
                   tps2.ppcard_id,
                   NULL pack_issued,
                   tps2.zipcode,
                   NULL first_digit,
                   tps2.province,
                   NULL pack_type,
                   UPPER (tps2.ops_country) eventcountry
            FROM               tps_2_oe_ch_mp_v tps2
                            INNER JOIN
                               slxdw.userinfo ui
                            ON REPLACE (
                                  UPPER(SUBSTR (
                                           tps2.channel_manager,
                                           1,
                                           INSTR (tps2.channel_manager, '/')
                                           - 1
                                        )),
                                  ' ',
                                  ''
                               ) = REPLACE (UPPER (ui.username), ' ', '')
                         INNER JOIN
                            slxdw.usersecurity us
                         ON ui.userid = us.userid AND us.enabled = 'T'
                      LEFT OUTER JOIN
                         slxdw.userinfo um
                      ON us.managerid = um.userid
                   INNER JOIN
                      time_dim td
                   ON tps2.book_date = td.dim_date
           WHERE   td.dim_year >= EXTRACT (YEAR FROM SYSDATE)
                   AND channel_manager LIKE '%/%'
          UNION
          SELECT   'OE Bookings' tab_type,
                   ui.username sales_rep,
                   CASE
                      WHEN ui.email IS NULL AND ui.firstname IS NULL
                      THEN
                         REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN ui.email IS NULL
                      THEN
                            REPLACE (ui.firstname, ' ', '')
                         || '.'
                         || REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         ui.email
                   END
                      sales_rep_email,
                   um.username manager_name,
                   CASE
                      WHEN um.email IS NULL AND um.firstname IS NULL
                      THEN
                         REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN um.email IS NULL
                      THEN
                            REPLACE (um.firstname, ' ', '')
                         || '.'
                         || REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         um.email
                   END
                      manager_email,
                   td.dim_year,
                   td.dim_month_num,
                   SUBSTR (td.dim_month, 1, 3) book_mo,
                   tps2.book_date,
                   tps2.book_amt * .5,
                   tps2.acct_name customer_parent,
                   ui.division sales_team,
                   tps2.enroll_id,
                   tps2.event_id,
                   tps2.course_code,
                   tps2.course_name,
                   TRUNC (tps2.start_date),
                   NULL course_lob,
                   tps2.ppcard_id,
                   NULL pack_issued,
                   tps2.zipcode,
                   NULL first_digit,
                   tps2.province,
                   NULL pack_type,
                   UPPER (tps2.ops_country) eventcountry
            FROM               tps_2_oe_ch_mp_v tps2
                            INNER JOIN
                               slxdw.userinfo ui
                            ON REPLACE (
                                  UPPER(SUBSTR (
                                           tps2.channel_manager,
                                           INSTR (tps2.channel_manager, '/')
                                           + 1
                                        )),
                                  ' ',
                                  ''
                               ) = REPLACE (UPPER (ui.username), ' ', '')
                         INNER JOIN
                            slxdw.usersecurity us
                         ON ui.userid = us.userid AND us.enabled = 'T'
                      LEFT OUTER JOIN
                         slxdw.userinfo um
                      ON us.managerid = um.userid
                   INNER JOIN
                      time_dim td
                   ON tps2.book_date = td.dim_date
           WHERE   td.dim_year >= EXTRACT (YEAR FROM SYSDATE)
                   AND channel_manager LIKE '%/%'
          UNION
          SELECT   'Pack Sales' tab_type,
                   ui.username sales_rep,
                   CASE
                      WHEN ui.email IS NULL AND ui.firstname IS NULL
                      THEN
                         REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN ui.email IS NULL
                      THEN
                            REPLACE (ui.firstname, ' ', '')
                         || '.'
                         || REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         ui.email
                   END
                      sales_rep_email,
                   um.username manager_name,
                   CASE
                      WHEN um.email IS NULL AND um.firstname IS NULL
                      THEN
                         REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN um.email IS NULL
                      THEN
                            REPLACE (um.firstname, ' ', '')
                         || '.'
                         || REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         um.email
                   END
                      manager_email,
                   td.dim_year,
                   td.dim_month_num,
                   SUBSTR (td.dim_month, 1, 3) book_mo,
                   TRUNC (tps3.issueddate) book_date,
                   valuepurchasedbase,
                   tps3.issuedtoaccount,
                   ui.division,
                   NULL enroll_id,
                   NULL event_id,
                   NULL course_code,
                   NULL course_name,
                   NULL start_date,
                   NULL course_lob,
                   tps3.evxppcardid,
                   tps3.issueddate,
                   tps3.ordered_by_zipcode,
                   NULL first_digit,
                   tps3.ordered_by_province,
                   tps3.cardtype,
                   UPPER (tps3.billtocountry)
            FROM               tps_3_new_pack_v tps3
                            INNER JOIN
                               slxdw.userinfo ui
                            ON REPLACE (UPPER (tps3.sales_rep), ' ', '') =
                                  REPLACE (UPPER (ui.username), ' ', '')
                         INNER JOIN
                            slxdw.usersecurity us
                         ON ui.userid = us.userid AND us.enabled = 'T'
                      LEFT OUTER JOIN
                         slxdw.userinfo um
                      ON us.managerid = um.userid
                   INNER JOIN
                      time_dim td
                   ON TRUNC (tps3.issueddate) = td.dim_date
           WHERE   td.dim_year >= EXTRACT (YEAR FROM SYSDATE)
          UNION
          SELECT   'OE Pack Burn' tab_type,
                   ui.username sales_rep,
                   CASE
                      WHEN ui.email IS NULL AND ui.firstname IS NULL
                      THEN
                         REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN ui.email IS NULL
                      THEN
                            REPLACE (ui.firstname, ' ', '')
                         || '.'
                         || REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         ui.email
                   END
                      sales_rep_email,
                   um.username manager_name,
                   CASE
                      WHEN um.email IS NULL AND um.firstname IS NULL
                      THEN
                         REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN um.email IS NULL
                      THEN
                            REPLACE (um.firstname, ' ', '')
                         || '.'
                         || REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         um.email
                   END
                      manager_email,
                   td.dim_year,
                   td.dim_month_num,
                   SUBSTR (td.dim_month, 1, 3) book_mo,
                   TRUNC (t4.transdate) book_date,
                   t4.book_amt,
                   t4.issuedtoaccount,
                   ui.division,
                   t4.enroll_id,
                   t4.evxeventid,
                   t4.course_code,
                   t4.prod_name,
                   t4.rev_date,
                   NULL course_lob,
                   t4.evxppcardid,
                   NULL pack_issued,
                   t4.student_zip,
                   NULL first_digit,
                   t4.province,
                   NULL pack_type,
                   UPPER (t4.billtocountry)
            FROM               tps_4_pack_burn_v t4
                            INNER JOIN
                               slxdw.userinfo ui
                            ON REPLACE (UPPER (t4.sales_rep), ' ', '') =
                                  REPLACE (UPPER (ui.username), ' ', '')
                         INNER JOIN
                            slxdw.usersecurity us
                         ON ui.userid = us.userid AND us.enabled = 'T'
                      LEFT OUTER JOIN
                         slxdw.userinfo um
                      ON us.managerid = um.userid
                   INNER JOIN
                      time_dim td
                   ON TRUNC (t4.transdate) = td.dim_date
           WHERE   td.dim_year >= EXTRACT (YEAR FROM SYSDATE)
                   AND (EXISTS
                           (SELECT   1
                              FROM   tps_2_oe_ch_mp_v t2
                             WHERE   t4.enroll_id = t2.enroll_id
                                     AND t4.sales_rep = t2.channel_manager)
                        OR EXISTS
                             (SELECT   1
                                FROM   ent_trans_bookings_mv et
                               WHERE   t4.enroll_id = et.evxevenrollid
                                       AND t4.sales_rep = et.sold_by))
          UNION
          SELECT   'Onsite Pack Burn' tab_type,
                   ui.username sales_rep,
                   CASE
                      WHEN ui.email IS NULL AND ui.firstname IS NULL
                      THEN
                         REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN ui.email IS NULL
                      THEN
                            REPLACE (ui.firstname, ' ', '')
                         || '.'
                         || REPLACE (ui.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         ui.email
                   END
                      sales_rep_email,
                   um.username manager_name,
                   CASE
                      WHEN um.email IS NULL AND um.firstname IS NULL
                      THEN
                         REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      WHEN um.email IS NULL
                      THEN
                            REPLACE (um.firstname, ' ', '')
                         || '.'
                         || REPLACE (um.lastname, ' ', '')
                         || '@globalknowledge.com'
                      ELSE
                         um.email
                   END
                      manager_email,
                   td.dim_year,
                   td.dim_month_num,
                   SUBSTR (td.dim_month, 1, 3) book_mo,
                   TRUNC (t4.transdate) book_date,
                   t4.pp_trans_amt,
                   t4.issuedtoaccount,
                   ui.division,
                   t4.enroll_id,
                   t4.evxeventid,
                   t4.course_code,
                   t4.prod_name,
                   t4.rev_date,
                   NULL course_lob,
                   t4.evxppcardid,
                   NULL pack_issued,
                   t4.student_zip,
                   NULL first_digit,
                   t4.province,
                   NULL pack_type,
                   UPPER (t4.billtocountry)
            FROM               tps_4_ent_pack_burn_v t4
                            INNER JOIN
                               slxdw.userinfo ui
                            ON REPLACE (UPPER (t4.sales_rep), ' ', '') =
                                  REPLACE (UPPER (ui.username), ' ', '')
                         INNER JOIN
                            slxdw.usersecurity us
                         ON ui.userid = us.userid AND us.enabled = 'T'
                      LEFT OUTER JOIN
                         slxdw.userinfo um
                      ON us.managerid = um.userid
                   INNER JOIN
                      time_dim td
                   ON TRUNC (t4.transdate) = td.dim_date
           WHERE   td.dim_year >= EXTRACT (YEAR FROM SYSDATE)
          UNION
          SELECT   'PO/CLC' tab_type,
                   t3.username,
                   t3.sales_rep_email,
                   t3.manager_name,
                   t3.manager_email,
                   td.dim_year,
                   td.dim_month_num,
                   SUBSTR (td.dim_month, 1, 3) book_mo,
                   TRUNC (t3.createdate) book_date,
                   t3.amount,
                   t3.account,
                   t3.division,
                   NULL enroll_id,
                   NULL event_id,
                   NULL course_code,
                   t3.ordertype || '-' || t3.ponumber,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   t3.country
            FROM      tps_3_po_clc_v t3
                   INNER JOIN
                      time_dim td
                   ON TRUNC (t3.createdate) = td.dim_date
           WHERE   td.dim_year >= EXTRACT (YEAR FROM SYSDATE))
--where dim_year = 2015
--and dim_month_num = 12;

COMMENT ON MATERIALIZED VIEW GKDW.GK_TPS_DATA_MV IS 'snapshot table for snapshot GKDW.GK_TPS_DATA_MV';

GRANT SELECT ON GKDW.GK_TPS_DATA_MV TO DWHREAD;

