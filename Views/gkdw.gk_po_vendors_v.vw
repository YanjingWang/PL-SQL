DROP VIEW GKDW.GK_PO_VENDORS_V;

/* Formatted on 29/01/2021 11:30:12 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PO_VENDORS_V
(
   VENDOR_ID,
   VENDOR_NUMBER,
   VENDOR_NAME,
   COUNTRY,
   VENDOR_SITE_CODE,
   INVOICE_CURRENCY_CODE,
   PAYMENT_CURRENCY_CODE,
   PAYMENT_METHOD
)
AS
   SELECT   p.vendor_id,
            p.segment1 vendor_number,
            vendor_name,
            ps.country,
            ps.vendor_site_code,
            ps.invoice_currency_code,
            ps.payment_currency_code,
            ps.payment_method_lookup_code
     FROM      po_vendors@r12prd p
            INNER JOIN
               po_vendor_sites_all@r12prd ps
            ON p.vendor_id = ps.vendor_id
    WHERE   p.enabled_flag = 'Y'
            AND (ps.inactive_date IS NULL
                 OR ps.inactive_date >= TRUNC (SYSDATE));


GRANT SELECT ON GKDW.GK_PO_VENDORS_V TO COGNOS_RO;

