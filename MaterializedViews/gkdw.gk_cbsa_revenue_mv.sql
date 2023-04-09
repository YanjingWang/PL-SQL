DROP MATERIALIZED VIEW GKDW.GK_CBSA_REVENUE_MV;
CREATE MATERIALIZED VIEW GKDW.GK_CBSA_REVENUE_MV 
TABLESPACE GDWMED
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
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
/* Formatted on 29/01/2021 12:26:19 (QP5 v5.115.810.9015) */
  SELECT   2006 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt cbsa_name,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END
              it_category,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           SUM (f.book_amt) rev_amt
    FROM               gk_cbsa_mv c
                    INNER JOIN
                       cust_dim cd
                    ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
                 INNER JOIN
                    order_fact f
                 ON cd.cust_id = f.cust_id AND f.enroll_status = 'Attended'
              INNER JOIN
                 event_dim ed
              ON f.event_id = ed.event_id
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   f.rev_date BETWEEN '01-JAN-2006' AND '31-DEC-2006'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type
UNION ALL
  SELECT   2007 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END
              it_category,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           SUM (f.book_amt) rev_amt
    FROM               gk_cbsa_mv c
                    INNER JOIN
                       cust_dim cd
                    ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
                 INNER JOIN
                    order_fact f
                 ON cd.cust_id = f.cust_id AND f.enroll_status = 'Attended'
              INNER JOIN
                 event_dim ed
              ON f.event_id = ed.event_id
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   f.rev_date BETWEEN '01-JAN-2007' AND '31-DEC-2007'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type
UNION ALL
  SELECT   2008 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END
              it_category,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           SUM (f.book_amt) rev_amt
    FROM               gk_cbsa_mv c
                    INNER JOIN
                       cust_dim cd
                    ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
                 INNER JOIN
                    order_fact f
                 ON cd.cust_id = f.cust_id AND f.enroll_status = 'Attended'
              INNER JOIN
                 event_dim ed
              ON f.event_id = ed.event_id
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   f.rev_date BETWEEN '01-JAN-2008' AND '31-DEC-2008'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type
UNION ALL
  SELECT   2009 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END
              it_category,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           SUM (f.book_amt) rev_amt
    FROM               gk_cbsa_mv c
                    INNER JOIN
                       cust_dim cd
                    ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
                 INNER JOIN
                    order_fact f
                 ON cd.cust_id = f.cust_id AND f.enroll_status = 'Attended'
              INNER JOIN
                 event_dim ed
              ON f.event_id = ed.event_id
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   f.rev_date BETWEEN '01-JAN-2009' AND '31-DEC-2009'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type
UNION ALL
  SELECT   2010 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END
              it_category,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           SUM (f.book_amt) rev_amt
    FROM               gk_cbsa_mv c
                    INNER JOIN
                       cust_dim cd
                    ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
                 INNER JOIN
                    order_fact f
                 ON cd.cust_id = f.cust_id AND f.enroll_status = 'Attended'
              INNER JOIN
                 event_dim ed
              ON f.event_id = ed.event_id
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   f.rev_date BETWEEN '01-JAN-2010' AND '31-DEC-2010'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type
UNION ALL
  SELECT   2011 dim_year,
           c.cbsa_code,
           c.cbsa_name_rpt,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END
              it_category,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type,
           SUM (f.book_amt) rev_amt
    FROM               gk_cbsa_mv c
                    INNER JOIN
                       cust_dim cd
                    ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
                 INNER JOIN
                    order_fact f
                 ON cd.cust_id = f.cust_id AND f.enroll_status = 'Attended'
              INNER JOIN
                 event_dim ed
              ON f.event_id = ed.event_id
           INNER JOIN
              course_dim co
           ON ed.course_id = co.course_id AND ed.ops_country = co.country
   WHERE   f.rev_date BETWEEN '01-JAN-2011' AND '31-DEC-2011'
GROUP BY   c.cbsa_code,
           c.cbsa_name_rpt,
           CASE
              WHEN cd.title_code IN
                         ('IT Director/Manager',
                          'Manager - Other',
                          'Project Manager',
                          'Executive/Manager - Other',
                          'Training Manager',
                          'Information Technology Manager',
                          'Vice President',
                          'Sales Director/Manager/Rep',
                          'Approving Manager',
                          'Operations Director/Manager',
                          'President',
                          'Chief Executive Officer',
                          'Marketing Director/Manager',
                          'Manager',
                          'Director of IT',
                          'VP of IT',
                          'Client Services Manager',
                          'IT Manager',
                          'It site manager',
                          'Supervisor',
                          'Program Manager',
                          'Principal',
                          'work group manager',
                          'VP Finance',
                          'Training Manager, Sales Training')
              THEN
                 'Executive/Manager'
              WHEN cd.title_code IN
                         ('Database Manager/Administrator',
                          'Application Developer',
                          'Developer - Other',
                          'Software Engineer',
                          'Programmer Analyst',
                          'Programmer - Other',
                          'Database Manager',
                          'Web Developer',
                          'Webmaster',
                          'Software Developer')
              THEN
                 'Developer'
              WHEN cd.title_code IN
                         ('Network Administrator',
                          'Network Engineer',
                          'Engineer',
                          'Systems Engineer',
                          'Network Manager',
                          'Network Analyst',
                          'Security Analyst',
                          'Telecommunications Engineer',
                          'Telecommunications Analyst',
                          'Security Consultant',
                          'Network Security Manager',
                          'TelecommunicationsTech',
                          'Network Supervisor')
              THEN
                 'Network'
              ELSE
                 'IT-Other'
           END,
           co.course_ch,
           co.course_mod,
           co.course_pl,
           co.course_type;

COMMENT ON MATERIALIZED VIEW GKDW.GK_CBSA_REVENUE_MV IS 'snapshot table for snapshot GKDW.GK_CBSA_REVENUE_MV';

GRANT SELECT ON GKDW.GK_CBSA_REVENUE_MV TO DWHREAD;

