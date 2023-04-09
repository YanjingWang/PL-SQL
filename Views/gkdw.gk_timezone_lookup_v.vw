DROP VIEW GKDW.GK_TIMEZONE_LOOKUP_V;

/* Formatted on 29/01/2021 11:25:04 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_TIMEZONE_LOOKUP_V (ZIPCODE, TIMEZONE)
AS
   SELECT   LPAD (zipcode, 5, '0') zipcode, timezone
     FROM   gk_zipcode_lat_long
    WHERE   zipcode IS NOT NULL
   UNION
   SELECT   DISTINCT UPPER (a.postalcode) zipcode, tz.offsetfromutc
     FROM      slxdw.address a
            INNER JOIN
               evxtimezone@slx tz
            ON CASE
                  WHEN a.postalcode LIKE 'A%' THEN 'NFT'
                  WHEN a.postalcode LIKE 'B%' THEN 'AST'
                  WHEN a.postalcode LIKE 'C%' THEN 'AST'
                  WHEN a.postalcode LIKE 'E%' THEN 'AST'
                  WHEN a.postalcode LIKE 'G%' THEN 'EST'
                  WHEN a.postalcode LIKE 'H%' THEN 'EST'
                  WHEN a.postalcode LIKE 'J%' THEN 'EST'
                  WHEN a.postalcode LIKE 'K%' THEN 'EST'
                  WHEN a.postalcode LIKE 'L%' THEN 'EST'
                  WHEN a.postalcode LIKE 'M%' THEN 'EST'
                  WHEN a.postalcode LIKE 'N%' THEN 'EST'
                  WHEN a.postalcode LIKE 'P%' THEN 'EST'
                  WHEN a.postalcode LIKE 'R%' THEN 'CST'
                  WHEN a.postalcode LIKE 'SPV%' THEN 'MST'
                  WHEN a.postalcode LIKE 'S%' THEN 'CST'
                  WHEN a.postalcode LIKE 'T%' THEN 'MST'
                  WHEN a.postalcode LIKE 'V%' THEN 'PST'
                  WHEN a.postalcode LIKE 'X%' THEN 'EST'
                  WHEN a.postalcode LIKE 'Y%' THEN 'PST'
               END = tz.tzabbreviation
    WHERE   UPPER (a.country) IN ('CANADA') AND a.postalcode IS NOT NULL
   ORDER BY   1;


