DROP VIEW GKDW.GK_CONSOLIDATED_MSA_V;

/* Formatted on 29/01/2021 11:40:38 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CONSOLIDATED_MSA_V
(
   MSA_NAME,
   MSA_DESC,
   CONSOLIDATED_MSA
)
AS
   SELECT   DISTINCT msa_name, msa_desc, consolidated_msa
     FROM   gk_msa_zips
    WHERE   consolidated_msa IS NOT NULL;


