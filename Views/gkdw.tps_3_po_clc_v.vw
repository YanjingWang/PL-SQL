DROP VIEW GKDW.TPS_3_PO_CLC_V;

/* Formatted on 29/01/2021 11:22:30 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.TPS_3_PO_CLC_V
(
   OSR_PURCH_ORDID,
   CREATEUSER,
   SALES_REP_EMAIL,
   MANAGER_NAME,
   MANAGER_EMAIL,
   CREATEDATE,
   MODIFYUSER,
   MODIFYDATE,
   PONUMBER,
   AMOUNT,
   STATUS,
   INACTIVEDATE,
   INACTIVEUSER,
   AMOUNTSPENT,
   ASSOCIATED_OSR,
   ACCOUNTID,
   ORDERTYPE,
   ACCOUNT,
   DEPARTMENT,
   FIRSTNAME,
   LASTNAME,
   REGION,
   USERNAME,
   DIVISION,
   COUNTRY
)
AS
     SELECT   po.osr_purch_ordid,
              po.createuser,
              CASE
                 WHEN ui.email IS NULL AND ui.firstname IS NULL
                 THEN
                    REPLACE (ui.lastname, ' ', '') || '@globalknowledge.com'
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
                    REPLACE (um.lastname, ' ', '') || '@globalknowledge.com'
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
              po.createdate,
              po.modifyuser,
              po.modifydate,
              po.ponumber,
              po.amount,
              po.status,
              po.inactivedate,
              po.inactiveuser,
              po.amountspent,
              po.associated_osr,
              po.accountid,
              po.ordertype,
              a.account,
              ui.department,
              ui.firstname,
              ui.lastname,
              ui.region,
              ui.username,
              ui.division,
              ad.country
       FROM                  slxdw.osr_purch_ord po
                          INNER JOIN
                             slxdw.account a
                          ON po.accountid = a.accountid
                       INNER JOIN
                          slxdw.address ad
                       ON a.addressid = ad.addressid
                    INNER JOIN
                       slxdw.userinfo ui
                    ON po.associated_osr = ui.userid
                 INNER JOIN
                    slxdw.usersecurity us
                 ON ui.userid = us.userid AND us.enabled = 'T'
              LEFT OUTER JOIN
                 slxdw.userinfo um
              ON us.managerid = um.userid
      WHERE   ui.region = 'TAM' AND po.createdate >= '01-JAN-2014'
   ORDER BY   po.createdate ASC;


