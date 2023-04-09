DROP MATERIALIZED VIEW GKDW.GK_CBSA_CONTACTS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_CBSA_CONTACTS_MV 
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
/* Formatted on 29/01/2021 12:26:28 (QP5 v5.115.810.9015) */
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
           COUNT (DISTINCT cd.cust_id) cust_cnt
    FROM      gk_cbsa_mv c
           INNER JOIN
              cust_dim cd
           ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
   WHERE   cd.creation_date <= '31-DEC-2006'
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
           END
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
           COUNT (DISTINCT cd.cust_id) cust_cnt
    FROM      gk_cbsa_mv c
           INNER JOIN
              cust_dim cd
           ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
   WHERE   cd.creation_date <= '31-DEC-2007'
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
           END
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
           COUNT (DISTINCT cd.cust_id) cust_cnt
    FROM      gk_cbsa_mv c
           INNER JOIN
              cust_dim cd
           ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
   WHERE   cd.creation_date <= '31-DEC-2008'
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
           END
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
           COUNT (DISTINCT cd.cust_id) cust_cnt
    FROM      gk_cbsa_mv c
           INNER JOIN
              cust_dim cd
           ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
   WHERE   cd.creation_date <= '31-DEC-2009'
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
           END
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
           COUNT (DISTINCT cd.cust_id) cust_cnt
    FROM      gk_cbsa_mv c
           INNER JOIN
              cust_dim cd
           ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
   WHERE   cd.creation_date <= '31-DEC-2010'
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
           END
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
           COUNT (DISTINCT cd.cust_id) cust_cnt
    FROM      gk_cbsa_mv c
           INNER JOIN
              cust_dim cd
           ON c.zipcode = SUBSTR (cd.zipcode, 1, 5)
   WHERE   cd.creation_date <= '31-DEC-2011'
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
           END;

COMMENT ON MATERIALIZED VIEW GKDW.GK_CBSA_CONTACTS_MV IS 'snapshot table for snapshot GKDW.GK_CBSA_CONTACTS_MV';

GRANT SELECT ON GKDW.GK_CBSA_CONTACTS_MV TO DWHREAD;

