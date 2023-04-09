DROP VIEW GKDW.PL_DIM_V;

/* Formatted on 29/01/2021 11:23:16 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.PL_DIM_V (PL_VALUE, PL_DESC)
AS
     SELECT   pl_value, UPPER (pl_desc) pl_desc
       FROM   pl_dim
      WHERE   pl_value BETWEEN '02' AND '30'
   ORDER BY   2;


DROP SYNONYM COGNOS_RO.PL_DIM_V;

CREATE SYNONYM COGNOS_RO.PL_DIM_V FOR GKDW.PL_DIM_V;


GRANT SELECT ON GKDW.PL_DIM_V TO COGNOS_RO;
