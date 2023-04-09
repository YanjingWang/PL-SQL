DROP VIEW GKDW.GK_GG_ENROLLMENT_V;

/* Formatted on 29/01/2021 11:36:00 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GG_ENROLLMENT_V
(
   ENROLL_ID,
   EVENT_ID,
   START_DATE,
   CUST_ID,
   FIRST_NAME,
   LAST_NAME,
   EMAIL,
   COURSE_CODE,
   UNIT_PRICE,
   OPS_COUNTRY,
   CH_NUM,
   MD_NUM,
   PL_NUM,
   ACT_NUM,
   FEETYPE,
   COUNTRY
)
AS
   SELECT   eh.evxevenrollid enroll_id,
            ed.event_id,
            ed.start_date,
            c.contactid cust_id,
            c.firstname first_name,
            c.lastname last_name,
            c.email,
            cd.course_code,
            pc.unit_price,
            ed.ops_country,
            cd.ch_num,
            cd.md_num,
            cd.pl_num,
            cd.act_num,
            ef.feetype,
            UPPER (ad.country) country
     FROM                        course_dim cd
                              INNER JOIN
                                 event_dim ed
                              ON cd.course_id = ed.course_id
                                 AND cd.country = ed.ops_country
                           INNER JOIN
                              evxenrollhx@slx eh
                           ON ed.event_id = eh.evxeventid
                        INNER JOIN
                           evxevticket@slx et
                        ON eh.evxevticketid = et.evxevticketid
                     INNER JOIN
                        evxev_txfee@slx ef
                     ON et.evxevticketid = ef.evxevticketid
                  INNER JOIN
                     contact@slx c
                  ON et.attendeecontactid = c.contactid
               INNER JOIN
                  address@slx ad
               ON c.addressid = ad.addressid
            INNER JOIN
               gk_sec_plus_course pc
            ON SUBSTR (cd.course_code, 1, 4) = pc.course_code
               AND ed.start_date >= pc.avail_date
    WHERE       cd.ch_num IN ('10')
            AND cd.md_num IN ('10', '20')
            AND TRUNC (SYSDATE) BETWEEN ed.start_date - 14 AND ed.end_date
            AND ed.status != 'Cancelled'
            AND eh.enrollstatus != 'Cancelled'
            AND ef.feetype NOT IN
                     ('Ons-Additional',
                      'Ons - Additional',
                      'Ons - Base',
                      'SUB')
            AND SUBSTR (cd.course_code, 1, 4) NOT IN ('5330', '5335', '5340')
            AND NOT EXISTS (SELECT   1
                              FROM   gk_sec_plus_user_info ui
                             WHERE   eh.evxevenrollid = ui.enroll_id)
   UNION
   SELECT   eh.evxevenrollid enroll_id,
            ed.event_id,
            ed.start_date,
            c.contactid cust_id,
            c.firstname first_name,
            c.lastname last_name,
            c.email,
            cd.course_code,
            pc.unit_price,
            ed.ops_country,
            cd.ch_num,
            cd.md_num,
            cd.pl_num,
            cd.act_num,
            ef.feetype,
            UPPER (ad.country) country
     FROM                        course_dim cd
                              INNER JOIN
                                 event_dim ed
                              ON cd.course_id = ed.course_id
                                 AND cd.country = ed.ops_country
                           INNER JOIN
                              evxenrollhx@slx eh
                           ON ed.event_id = eh.evxeventid
                        INNER JOIN
                           evxevticket@slx et
                        ON eh.evxevticketid = et.evxevticketid
                     INNER JOIN
                        evxev_txfee@slx ef
                     ON et.evxevticketid = ef.evxevticketid
                  INNER JOIN
                     contact@slx c
                  ON et.attendeecontactid = c.contactid
               INNER JOIN
                  address@slx ad
               ON c.addressid = ad.addressid
            INNER JOIN
               gk_sec_plus_course pc
            ON SUBSTR (cd.course_code, 1, 4) = pc.course_code
               AND ed.start_date >= pc.avail_date
    WHERE       cd.ch_num IN ('20')
            AND cd.md_num IN ('10', '20')
            AND cd.course_code NOT IN ('3367N', '9730N')
            AND TRUNC (SYSDATE) BETWEEN ed.start_date - 14 AND ed.end_date
            AND ed.status != 'Cancelled'
            AND eh.enrollstatus != 'Cancelled'
            AND ef.feetype NOT IN
                     ('Ons-Additional',
                      'Ons - Additional',
                      'Ons - Base',
                      'SUB')
            AND SUBSTR (cd.course_code, 1, 4) NOT IN ('5330', '5335', '5340')
            AND NOT EXISTS (SELECT   1
                              FROM   gk_sec_plus_user_info ui
                             WHERE   eh.evxevenrollid = ui.enroll_id);


