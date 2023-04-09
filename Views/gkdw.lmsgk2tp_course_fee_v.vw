DROP VIEW GKDW.LMSGK2TP_COURSE_FEE_V;

/* Formatted on 29/01/2021 11:23:32 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.LMSGK2TP_COURSE_FEE_V
(
   COURSE_CODE,
   COUNTRY,
   OE_FEES,
   ONS_ADDL
)
AS
     SELECT   SUBSTR (cd.COURSE_CODE, 1, 4) course_code,
              cd.COUNTRY,
              MAX (DECODE (cf.FEETYPE, 'Primary', cf.amount, NULL)) AS OE_Fees,
              MAX(CASE
                     WHEN REPLACE (cf.FEETYPE, ' ') IN
                                ('Ons-Additional', 'Ons-Individual')
                     THEN
                        cf.amount
                     ELSE
                        NULL
                  END)
                 AS ONS_Addl
       FROM      course_dim cd
              JOIN
                 slxdw.EVXCOURSEFEE cf
              ON cd.COURSE_ID = cf.evxcourseid
                 AND cd.COUNTRY = UPPER (cf.PRICELIST)
      WHERE       cd.INACTIVE_FLAG = 'F'
              AND cf.FEEALLOWUSE = 'T'
              AND cf."FEEAVAILABLE" = 'T'
              AND REPLACE (cf.FEETYPE, ' ') IN
                       ('Ons-Additional', 'Primary', 'Ons-Individual')
              AND cd.COUNTRY IN ('USA', 'CANADA')
              AND SUBSTR (cd.COURSE_CODE, -1, 1) IN ('N', 'H', 'G', 'C')
   GROUP BY   SUBSTR (cd.COURSE_CODE, 1, 4), cd.COUNTRY
   ORDER BY   SUBSTR (cd.COURSE_CODE, 1, 4), cd.COUNTRY;


