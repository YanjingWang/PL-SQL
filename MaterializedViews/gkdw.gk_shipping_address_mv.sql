DROP MATERIALIZED VIEW GKDW.GK_SHIPPING_ADDRESS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_SHIPPING_ADDRESS_MV 
TABLESPACE GDWLRG
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:22:26 (QP5 v5.115.810.9015) */
SELECT   entityid,
         addressid,
         max_modifydate,
         address_rank
  FROM   (  SELECT   UPPER (entityid) entityid,
                     addressid,
                     MAX (modifydate) max_modifydate,
                     RANK ()
                        OVER (PARTITION BY UPPER (entityid)
                              ORDER BY MAX (modifydate) DESC, MAX (addressid))
                        address_rank
              FROM   slxdw.address
             WHERE   ismailing = 'T'
          GROUP BY   UPPER (entityid), addressid
          ORDER BY   3 DESC)
 WHERE   address_rank = 1;

COMMENT ON MATERIALIZED VIEW GKDW.GK_SHIPPING_ADDRESS_MV IS 'snapshot table for snapshot GKDW.GK_SHIPPING_ADDRESS_MV';

GRANT SELECT ON GKDW.GK_SHIPPING_ADDRESS_MV TO DWHREAD;

