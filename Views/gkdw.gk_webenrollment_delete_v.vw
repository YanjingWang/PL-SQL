DROP VIEW GKDW.GK_WEBENROLLMENT_DELETE_V;

/* Formatted on 29/01/2021 11:23:58 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_WEBENROLLMENT_DELETE_V
(
   GK_WEBENROLLMENTID,
   WEB_CREATEDATE,
   ATTENDEECONTACTID,
   ATTENDEEACCOUNTID,
   ATTENDEEFIRSTNAME,
   ATTENDEELASTNAME,
   ATTENDEEACCOUNTNAME,
   ATTENDEECITY,
   ATTENDEESTATE,
   ATTENDEECOUNTY,
   ATTENDEEPOSTALCODE,
   WEB_EVENTID,
   WEB_COURSECODE,
   WEB_STARTDATE,
   WEB_METRO,
   WEBFACILITY,
   SHORT_NAME,
   NETAMOUNT,
   TAXAMOUNT,
   CURRENCYTYPE,
   METHODOFPAYMENT,
   CC_CARDTYPE,
   CC_APPLIEDAMOUNT,
   CC_NUMBER,
   CC_AUTHNUMBER,
   CC_RESPONSEMSG,
   PONUMBER,
   REENROLL_BOOKDATE,
   REENROLL_BOOKAMT,
   REENROLL_TYPE,
   REENROLL_EVENTID,
   REENROLL_COURSECODE,
   REENROLL_STARTDATE,
   REENROLL_METRO,
   REENROLL_FACILITY
)
AS
   SELECT   w.gk_webenrollmentid,
            w.createdate web_createdate,
            w.attendeecontactid,
            w.attendeeaccountid,
            w.attendeefirstname,
            w.attendeelastname,
            w.attendeeaccountname,
            w.attendeecity,
            w.attendeestate,
            w.attendeecounty,
            w.attendeepostalcode,
            ed.event_id web_eventid,
            ed.course_code web_coursecode,
            ed.start_date web_startdate,
            ed.facility_region_metro web_metro,
            ed.facility_code webfacility,
            cd.short_name,
            w.netamount,
            w.taxamount,
            w.currencytype,
            w.methodofpayment,
            w.cc_cardtype,
            w.cc_appliedamount,
            w.cc_number,
            w.cc_authnumber,
            w.cc_responsemsg,
            w.ponumber,
            f.book_date reenroll_bookdate,
            f.book_amt reenroll_bookamt,
            f.enroll_type reenroll_type,
            ed2.event_id reenroll_eventid,
            ed2.course_code reenroll_coursecode,
            ed2.start_date reenroll_startdate,
            ed2.facility_region_metro reenroll_metro,
            ed2.facility_code reenroll_facility
     FROM               gk_webenrollment w
                     INNER JOIN
                        event_dim ed
                     ON w.evxeventid = ed.event_id
                  INNER JOIN
                     course_dim cd
                  ON ed.course_id = cd.course_id
                     AND ed.ops_country = cd.country
               INNER JOIN
                  order_fact f
               ON     w.attendeecontactid = f.cust_id
                  AND TRUNC (f.creation_date) >= TRUNC (w.createdate)
                  AND f.enroll_status != 'Cancelled'
            INNER JOIN
               event_dim ed2
            ON f.event_id = ed2.event_id AND ed.course_id = ed2.course_id
    WHERE   w.recordstatus = 'Deleted'
   --and w.enrollmentdate >= trunc(sysdate)-7
   UNION
   SELECT   w.gk_webenrollmentid,
            w.createdate,
            w.attendeecontactid,
            w.attendeeaccountid,
            w.attendeefirstname,
            w.attendeelastname,
            w.attendeeaccountname,
            w.attendeecity,
            w.attendeestate,
            w.attendeecounty,
            w.attendeepostalcode,
            ed.event_id,
            ed.course_code,
            ed.start_date,
            ed.facility_region_metro,
            ed.facility_code,
            cd.short_name,
            w.netamount,
            w.taxamount,
            w.currencytype,
            w.methodofpayment,
            w.cc_cardtype,
            w.cc_appliedamount,
            w.cc_number,
            w.cc_authnumber,
            w.cc_responsemsg,
            w.ponumber,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL,
            NULL
     FROM         gk_webenrollment w
               INNER JOIN
                  event_dim ed
               ON w.evxeventid = ed.event_id
            INNER JOIN
               course_dim cd
            ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
    WHERE   w.recordstatus = 'Deleted'
            --and w.enrollmentdate >= trunc(sysdate)-7
            AND NOT EXISTS
                  (SELECT   1
                     FROM      order_fact f
                            INNER JOIN
                               event_dim ed2
                            ON f.event_id = ed2.event_id
                    WHERE   ed2.course_id = ed.course_id
                            AND w.attendeecontactid = f.cust_id
                            AND TRUNC (f.creation_date) >=
                                  TRUNC (w.createdate)
                            AND f.enroll_status != 'Cancelled')
   ORDER BY   2, 3;


