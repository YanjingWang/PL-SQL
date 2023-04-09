DROP VIEW GKDW.GK_LAST_CLOSED_PERIOD_V;

/* Formatted on 29/01/2021 11:33:29 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_LAST_CLOSED_PERIOD_V (LAST_PERIOD)
AS
   SELECT   MAX (period_year || '-' || LPAD (period_num, 2, '0')) last_period
     FROM   gl_periods@r12prd
    WHERE   end_date < TRUNC (SYSDATE) AND period_set_name = 'GKNET ACCTG';


