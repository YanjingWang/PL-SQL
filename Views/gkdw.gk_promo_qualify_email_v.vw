DROP VIEW GKDW.GK_PROMO_QUALIFY_EMAIL_V;

/* Formatted on 29/01/2021 11:28:23 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PROMO_QUALIFY_EMAIL_V
(
   ENROLL_ID,
   ADDL_INFO,
   EMAIL_DATE,
   EMAIL_TYPE,
   STEP_NUM,
   STEP_STATUS
)
AS
   SELECT   s.evxevenrollid enroll_id,
            CASE
               WHEN pe."promo_code" = 'IPADMINI2013'
               THEN
                  'https://secure.globalknowledge.com/promo/ipadmini2013.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'CAIPADMINI2013'
               THEN
                  'https://secure.globalknowledge.com/promo/caipadmini2013.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'IPAD4'
               THEN
                  'https://secure.globalknowledge.com/promo/ipad4.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'CAIPAD42013'
               THEN
                  'https://secure.globalknowledge.com/promo/caipad42013.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'TABLET'
               THEN
                  'https://secure.globalknowledge.com/promo/tablet.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'TABLETCA'
               THEN
                  'https://secure.globalknowledge.com/promo/tabletca.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'SCREENSIZE'
               THEN
                  'https://secure.globalknowledge.com/promo/screensize.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'IPADAIR'
               THEN
                  'https://secure.globalknowledge.com/promo/ipadair.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'IPADAIRCA'
               THEN
                  'https://secure.globalknowledge.com/promo/ipadairca.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'GAME'
               THEN
                  'https://secure.globalknowledge.com/promo/game.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'GAME15'
               THEN
                  'https://secure.globalknowledge.com/promo/game15.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'GIFTCARDCA'
               THEN
                  'https://secure.globalknowledge.com/promo/giftcardca.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'PRO'
               THEN
                  'https://secure.globalknowledge.com/promo/pro.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'CAGOPRO'
               THEN
                  'https://secure.globalknowledge.com/promo/cagopro.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'HELLO'
               THEN
                  'https://secure.globalknowledge.com/promo/hello.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'HELLO10'
               THEN
                  'https://secure.globalknowledge.com/promo/hello10.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'SHAPE'
               THEN
                  'https://secure.globalknowledge.com/promo/shape.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'SHAPE500'
               THEN
                  'https://secure.globalknowledge.com/promo/shape500.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'COOLSTUFF'
               THEN
                  'https://secure.globalknowledge.com/promo/coolstuff.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'COOLSTUFF500'
               THEN
                  'https://secure.globalknowledge.com/promo/coolstuff500.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'COOLSTUFF2PACK'
               THEN
                  'https://secure.globalknowledge.com/promo/coolstuff2pack.aspx?evid='
                  || s.evxevenrollid
               WHEN pe."promo_code" = 'CASUPERPOWERSVCL'
               THEN
                  'https://secure.globalknowledge.com/promo/casuperpowersvcl.aspx?evid='
                  || s.evxevenrollid
            END
               addl_info,
            TO_CHAR ("datesent", 'yyyy-mm-dd') email_date,
            TO_CHAR ("email_type") email_type,
            step_num,
            'Email Sent' step_status
     FROM      promo_emails_sent@mkt_catalog pe
            INNER JOIN
               gk_promo_status@slx s
            ON pe."evxenrollid" = s.evxevenrollid AND s.step_num = 3
    WHERE   pe."email_type" = 'QUALIFY'
            AND NOT EXISTS
                  (SELECT   1
                     FROM   gk_promo_status@slx s2
                    WHERE       s.evxevenrollid = s2.evxevenrollid
                            AND s.step_num = s2.step_num
                            AND s.additional_info = s2.additional_info);


