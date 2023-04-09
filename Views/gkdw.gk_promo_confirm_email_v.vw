DROP VIEW GKDW.GK_PROMO_CONFIRM_EMAIL_V;

/* Formatted on 29/01/2021 11:28:37 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PROMO_CONFIRM_EMAIL_V
(
   ENROLL_ID,
   EMAIL_ADDR,
   EMAIL_DATE,
   EMAIL_TYPE,
   STEP_NUM,
   STEP_STATUS
)
AS
   SELECT   s.evxevenrollid enroll_id,
            'Email sent to: ' || TO_CHAR (TRIM ("email")) email_addr,
            TO_CHAR ("datesent", 'yyyy-mm-dd') email_date,
            TO_CHAR ("email_type") email_type,
            step_num,
            'Email Sent' step_status
     FROM      promo_emails_sent@mkt_catalog pe
            INNER JOIN
               gk_promo_status@slx s
            ON pe."evxenrollid" = s.evxevenrollid AND s.step_num = 2
    WHERE   pe."email_type" = 'CONFIRM'
            AND NOT EXISTS
                  (SELECT   1
                     FROM   gk_promo_status@slx s2
                    WHERE       s.evxevenrollid = s2.evxevenrollid
                            AND s.step_num = s2.step_num
                            AND s.additional_info = s2.additional_info);


