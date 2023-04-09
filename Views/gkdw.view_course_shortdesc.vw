DROP VIEW GKDW.VIEW_COURSE_SHORTDESC;

/* Formatted on 29/01/2021 11:22:18 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.VIEW_COURSE_SHORTDESC
(
   COURSE_ID,
   "country",
   "short_desc"
)
AS
   SELECT   "COURSE_ID", "country", "short_desc"
     FROM   view_course_shortdesc@mkt_catalog;


