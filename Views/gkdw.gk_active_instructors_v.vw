DROP VIEW GKDW.GK_ACTIVE_INSTRUCTORS_V;

/* Formatted on 29/01/2021 11:43:10 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ACTIVE_INSTRUCTORS_V
(
   INSTRUCTOR_ID,
   ACCT_TYPE
)
AS
   SELECT   f."slx_contact_id" instructor_id, 'INTERNAL' acct_type
     FROM   "employee_func"@rms_prod ef,
            "instructor_func"@rms_prod f,
            "person"@rms_prod pr
    WHERE       ef."person" = f."person"
            AND ef."person" = pr."id"
            AND pr."activ" = 'yes'
   UNION
   SELECT   f."slx_contact_id", 'EXTERNAL'
     FROM   "instructor_func"@rms_prod ef,
            "instructor_func"@rms_prod f,
            "person"@rms_prod pr
    WHERE       ef."person" = f."person"
            AND ef."person" = pr."id"
            AND pr."activ" = 'yes';


