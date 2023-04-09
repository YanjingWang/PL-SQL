DROP VIEW GKDW.GK_SHIPPING_ADDRESS_V;

/* Formatted on 29/01/2021 11:26:18 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SHIPPING_ADDRESS_V
(
   ENTITYID,
   ADDRESSID,
   MAX_MODIFYDATE,
   ADDRESS_RANK
)
AS
   SELECT   entityid,
            addressid,
            max_modifydate,
            address_rank
     FROM   (  SELECT   UPPER (entityid) entityid,
                        addressid,
                        MAX (modifydate) max_modifydate,
                        RANK ()
                           OVER (
                              PARTITION BY UPPER (entityid)
                              ORDER BY MAX (modifydate) DESC, MAX (addressid)
                           )
                           address_rank
                 FROM   slxdw.address
                WHERE   ismailing = 'T'
             GROUP BY   UPPER (entityid), addressid
             ORDER BY   3 DESC)
    WHERE   address_rank = 1;


