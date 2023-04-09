DROP VIEW GKDW.GK_CO_GROUP_LOOKUP_V;

/* Formatted on 29/01/2021 11:38:50 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CO_GROUP_LOOKUP_V (ACCT_ID, CO_GROUP)
AS
     SELECT   c.acct_id, c.co_group
       FROM   gk_co_group_load c
      WHERE   c.acct_id IN (  SELECT   c1.acct_id
                                FROM   gk_co_group_load c1
                            GROUP BY   c1.acct_id
                              HAVING   COUNT ( * ) > 1)
   --and c.acct_id = 'A6UJ9A016614'
   GROUP BY   c.acct_id, c.co_group
   ORDER BY   1;


