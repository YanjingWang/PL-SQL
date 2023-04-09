DROP VIEW GKDW.GK_COURSE_FINANCIALS_LOAD_V;

/* Formatted on 29/01/2021 11:39:52 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_FINANCIALS_LOAD_V
(
   EVXCOURSEID,
   COURSECODE,
   COURSENAME,
   PL_NUM,
   COURSE_NUM,
   COURSECATEGORY,
   FEETYPE,
   US_PRIMARY_FEE,
   CA_PRIMARY_FEE
)
AS
     SELECT   evxcourseid,
              coursecode,
              coursename,
              pl_num,
              course_num,
              coursecategory,
              feetype,
              SUM (us_primary_fee) us_primary_fee,
              SUM (ca_primary_fee) ca_primary_fee
       FROM   (SELECT   c.evxcourseid,
                        c.coursecode,
                        c.coursename,
                        pd.pl_value pl_num,
                        CASE
                           WHEN SUBSTR (coursecode, -1) BETWEEN 'A' AND 'Z'
                                AND LENGTH (coursecode) = 7
                           THEN
                              SUBSTR (coursecode, 1, LENGTH (coursecode) - 1)
                           WHEN SUBSTR (coursecode, -1) BETWEEN 'A' AND 'Z'
                           THEN
                              LPAD (
                                 SUBSTR (coursecode,
                                         1,
                                         LENGTH (coursecode) - 1),
                                 4,
                                 '0'
                              )
                           ELSE
                              LPAD (coursecode, 6, '0')
                        END
                           course_num,
                        UPPER(REPLACE (c.coursecategory,
                                       'NETWORKING DATA/TELEPHONY',
                                       'NETWORKING'))
                           coursecategory,
                        cf.feetype,
                        cf.amount us_primary_fee,
                        0 ca_primary_fee
                 FROM         slxdw.evxcourse c
                           INNER JOIN
                              slxdw.evxcoursefee cf
                           ON c.evxcourseid = cf.evxcourseid
                        INNER JOIN
                           pl_dim pd
                        ON UPPER(REPLACE (c.coursecategory,
                                          'NETWORKING DATA/TELEPHONY',
                                          'NETWORKING')) = UPPER (pd.pl_desc)
                WHERE       TRIM (inactivedate) IS NULL
                        AND cf.pricelist = 'USA'
                        AND cf.feetype IN ('Ons - Base', 'Primary')
                        AND NOT EXISTS
                              (SELECT   1
                                 FROM   mtl_system_items_b@r12prd m
                                WHERE   c.coursecode = m.attribute1
                                        AND invoiceable_item_flag = 'Y')
                        AND (   EXISTS (SELECT   1
                                          FROM   event_dim ed
                                         WHERE   c.evxcourseid = ed.course_id)
                             OR EXISTS (SELECT   1
                                          FROM   slxdw.gk_onsitereq_idr oi
                                         WHERE   c.coursecode = oi.coursecode)
                             OR SUBSTR (c.coursecode, -1) IN ('A', 'B'))
               UNION
               SELECT   DISTINCT
                        c.evxcourseid,
                        c.coursecode,
                        c.coursename,
                        pd.pl_value pl_num,
                        CASE
                           WHEN SUBSTR (coursecode, -1) BETWEEN 'A' AND 'Z'
                                AND LENGTH (coursecode) = 7
                           THEN
                              SUBSTR (coursecode, 1, LENGTH (coursecode) - 1)
                           WHEN SUBSTR (coursecode, -1) BETWEEN 'A' AND 'Z'
                           THEN
                              LPAD (
                                 SUBSTR (coursecode,
                                         1,
                                         LENGTH (coursecode) - 1),
                                 4,
                                 '0'
                              )
                           ELSE
                              LPAD (coursecode, 6, '0')
                        END
                           course_num,
                        UPPER(REPLACE (c.coursecategory,
                                       'NETWORKING DATA/TELEPHONY',
                                       'NETWORKING'))
                           coursecategory,
                        cf.feetype,
                        0 us_primary_fee,
                        cf.amount ca_primary_fee
                 FROM            slxdw.evxcourse c
                              INNER JOIN
                                 slxdw.evxcoursefee cf
                              ON c.evxcourseid = cf.evxcourseid
                           INNER JOIN
                              pl_dim pd
                           ON UPPER(REPLACE (c.coursecategory,
                                             'NETWORKING DATA/TELEPHONY',
                                             'NETWORKING')) =
                                 UPPER (pd.pl_desc)
                        INNER JOIN
                           event_dim ed
                        ON c.evxcourseid = ed.course_id
                WHERE       TRIM (inactivedate) IS NULL
                        AND cf.pricelist = 'Canada'
                        AND cf.feetype IN ('Ons - Base', 'Primary')
                        AND NOT EXISTS
                              (SELECT   1
                                 FROM   mtl_system_items_b@r12prd m
                                WHERE   c.coursecode = m.attribute1
                                        AND invoiceable_item_flag = 'Y')
                        AND (   EXISTS (SELECT   1
                                          FROM   event_dim ed
                                         WHERE   c.evxcourseid = ed.course_id)
                             OR EXISTS (SELECT   1
                                          FROM   slxdw.gk_onsitereq_idr oi
                                         WHERE   c.coursecode = oi.coursecode)
                             OR SUBSTR (c.coursecode, -1) IN ('A', 'B')))
      WHERE   course_num IS NOT NULL
   GROUP BY   evxcourseid,
              coursecode,
              coursename,
              pl_num,
              course_num,
              coursecategory,
              feetype
   ORDER BY   2;


