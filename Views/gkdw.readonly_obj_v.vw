DROP VIEW GKDW.READONLY_OBJ_V;

/* Formatted on 29/01/2021 11:23:08 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.READONLY_OBJ_V
(
   OWNER,
   NAME,
   TYPE,
   LINE,
   TEXT
)
AS
   SELECT   "OWNER",
            "NAME",
            "TYPE",
            "LINE",
            "TEXT"
     FROM   all_source
    WHERE   TYPE IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE')
            AND owner IN ('GKDW', 'SLXDW');


GRANT SELECT ON GKDW.READONLY_OBJ_V TO COGNOS_RO;

GRANT SELECT ON GKDW.READONLY_OBJ_V TO DWHREAD;

