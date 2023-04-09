DROP VIEW GKDW.GK_INSTRUCTOR_CERT_V;

/* Formatted on 29/01/2021 11:34:39 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INSTRUCTOR_CERT_V
(
   INSTRUCTOR_RMS_ID,
   PERSON_RMS_ID,
   FIRSTNAME,
   LASTNAME,
   COUNTRY,
   CITY,
   STATE,
   SLX_CONTACT_ID,
   VENDOR_NAME,
   CERTIFICATE_NUM,
   CERT_PRODUCT
)
AS
     SELECT   f."id" instructor_rms_id,
              p."id" person_rms_id,
              p."firstname" firstname,
              p."lastname" lastname,
              a."country" country,
              a."city" city,
              s."abbr" state,
              f."slx_contact_id" slx_contact_id,
              v."name" vendor_name,
              iv."certificate_number" certificate_num,
              c."product_code" cert_product
       FROM                        "instructor_func"@rms_prod f
                                INNER JOIN
                                   "person"@rms_prod p
                                ON f."person" = p."id"
                             INNER JOIN
                                "address"@rms_prod a
                             ON p."address" = a."id"
                          INNER JOIN
                             "state"@rms_prod s
                          ON a."state" = s."id"
                       INNER JOIN
                          "instructor_vendor"@rms_prod iv
                       ON f."id" = iv."instructor"
                    INNER JOIN
                       "vendor"@rms_prod v
                    ON iv."vendor" = v."id"
                 INNER JOIN
                    "instructor_certificate"@rms_prod ic
                 ON f."id" = ic."instructor"
              INNER JOIN
                 "certificate"@rms_prod c
              ON ic."certificate" = c."id" AND v."id" = c."vendor"
   ORDER BY   p."lastname",
              p."firstname",
              v."name",
              c."product_code";


