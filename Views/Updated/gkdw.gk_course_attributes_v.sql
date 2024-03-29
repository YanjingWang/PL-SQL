


Create Or Alter View Hold.Gk_Course_Attributes_V
(
   Course_Id,
   Course_Code,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Course_Type,
   Vendor_Code,
   Short_Name,
   Delivery_Method,
   Delivery_Type,
   Sales_Channel,
   Product_Line,
   Business_Unit,
   Vendor,
   Product_Type
)
As
   Select   Distinct
            Cd.Course_Id,
            Cd.Course_Code,
            Cd.Course_Ch,
            Cd.Course_Mod,
            Cd.Course_Pl,
            Cd.Course_Type,
            Cd.Vendor_Code,
            Cd.Short_Name,
            Case
               When Substring(Cd.Course_Code, 5,  1) In
                          ('C', 'N', 'G', 'H', 'T', 'D')
               Then
                  'Classroom'
               When Substring(Cd.Course_Code, 5,  1) In ('L', 'V', 'U', 'Y')
               Then
                  'Virtual'
               When Substring(Cd.Course_Code, 5,  1) In ('R')
               Then
                  'Rental'
               When Cd.Course_Code Like '%W'
               Then
                  'Subscription'
               When Cd.Course_Code Like '%P'
               Then
                  'Subscription'
               When Cd.Course_Code Like '%S'
               Then
                  'Learning Product'
            End
               Delivery_Method,
            Case
               When Substring(Cd.Course_Code, 5,  1) In
                          ('C', 'N', 'L', 'V', 'R', 'T')
               Then
                  'Gk Direct'
               When Substring(Cd.Course_Code, 5,  1) In
                          ('G', 'H', 'U', 'Y', 'D')
               Then
                  'Partner Delivered'
               When Cd.Course_Code Like '%W' And Vendor_Code Is Null
               Then
                  'Gk Direct'
               When Cd.Course_Code Like '%W' And Vendor_Code Is Not Null
               Then
                  'Partner Delivered'
               When Cd.Course_Code Like '%S' And Vendor_Code Is Null
               Then
                  'Gk Direct'
               When Cd.Course_Code Like '%P'
               Then
                  'Gk Direct'
               When Cd.Course_Code Like '%S' And Vendor_Code Is Not Null
               Then
                  'Partner Delivered'
            End
               Delivery_Type,
            Case
               When Substring(Cd.Course_Code, 5,  1) In
                          ('C', 'L', 'G', 'U', 'T', 'R', 'D')
               Then
                  'Open Enrollment'
               When Substring(Cd.Course_Code, 5,  1) In ('N', 'V', 'H', 'Y')
               Then
                  'Enterprise'
               When Cd.Course_Code Like '%W'
               Then
                  'Open Enrollment'
               When Cd.Course_Code Like '%P'
               Then
                  'Open Enrollment'
               When Cd.Course_Code Like '%S'
               Then
                  'Open Enrollment'
            End
               Sales_Channel,
            Case
               When Cd.Course_Pl = 'Application Development'
               Then
                  'Application Development'
               When Cd.Course_Pl = 'Microsoft'
                    And Upper (Course_Type) In
                             ('.Net', 'Sharepoint', 'Other')
               Then
                  'Application Development'
               When Cd.Course_Pl = 'Cloudera'
               Then
                  'Application Development'
               When Cd.Course_Pl = 'Other'
                    And Upper (Course_Type) In
                             ('Software', 'Sharepoint', 'Programming', '.Net')
               Then
                  'Application Development'
               When Cd.Course_Pl = 'Networking'
               Then
                  'Networking'
               When Cd.Course_Pl = 'Cisco'
                    And Upper (Isnull(Course_Type, 'None')) In
                             ('Data Center',
                              'Unified Communications',
                              'Optical Networking',
                              'Routing And Switching',
                              'Routing & Switching',
                              'Wireless',
                              'Elab',
                              'None')
               Then
                  'Networking'
               When Cd.Course_Pl = 'Microsoft'
                    And Upper (Course_Type) In
                             ('Exchange', 'Unified Communications')
               Then
                  'Networking'
               When Cd.Course_Pl = 'Avaya'
               Then
                  'Networking'
               When Cd.Course_Pl = 'Hp'
               Then
                  'Networking'
               When Cd.Course_Pl = 'Juniper'
               Then
                  'Networking'
               When Cd.Course_Pl = 'Other'
                    And Upper (Course_Type) In
                             ('Routing & Switching',
                              'Unified Communications',
                              'Optical Networking',
                              'Telepresence',
                              'Networking',
                              'Voip And Telephony',
                              'Network Management',
                              'Network Infrastructure',
                              'Data Center',
                              'Cloud')
               Then
                  'Networking'
               When Cd.Course_Pl = 'Business Training'
               Then
                  'Business Training'
               When Cd.Course_Pl = 'Cisco'
                    And Upper (Course_Type) In
                             ('Sales Training', 'Business Architecture')
               Then
                  'Business Training'
               When Cd.Course_Pl = 'Microsoft'
                    And Upper (Course_Type) In
                             ('Ms Office', 'Office', 'Project Management')
               Then
                  'Business Training'
               When Cd.Course_Pl = 'Other'
                    And Upper (Course_Type) In
                             ('Business Objects',
                              'Project Management',
                              'Business Analysis',
                              'Six Sigma',
                              'Sales Training',
                              'Professional Skills',
                              'Itil',
                              'Business Service Management')
               Then
                  'Business Training'
               When Cd.Course_Pl = 'Operating Systems'
               Then
                  'Operating Systems/Database'
               When Cd.Course_Pl = 'Microsoft'
                    And Upper (Course_Type) In
                             ('Ms Moc',
                              'Boot Camp',
                              'Sql',
                              'Server',
                              'Windows 7',
                              'Windows Client',
                              'Vista',
                              'Xp',
                              'Operating Systems')
               Then
                  'Operating Systems/Database'
               When Cd.Course_Pl = 'Cisco'
                    And Upper (Course_Type) In ('Database')
               Then
                  'Operating Systems/Database'
               When Cd.Course_Pl = 'Other'
                    And Upper (Course_Type) In
                             ('Storage',
                              'Database',
                              'Operating Systems',
                              'Server')
               Then
                  'Operating Systems/Database'
               When Cd.Course_Pl = 'Other' And Vendor_Code = 'Act'
               Then
                  'Operating Systems/Database'
               When Cd.Course_Pl = 'Vmware'
               Then
                  'Virtualization'
               When Cd.Course_Pl = 'Microsoft'
                    And Upper (Course_Type) In ('Virtualization')
               Then
                  'Virtualization'
               When Cd.Course_Pl = 'Citrix'
               Then
                  'Virtualization'
               When Cd.Course_Pl = 'Other'
                    And Upper (Course_Type) In ('App Virtualization')
               Then
                  'Virtualization'
               When Cd.Course_Pl = 'Cisco'
                    And Upper (Course_Type) In ('Security')
               Then
                  'Security'
               When Cd.Course_Pl = 'Microsoft'
                    And Upper (Course_Type) In ('Security')
               Then
                  'Security'
               When Cd.Course_Pl = 'Rsa'
               Then
                  'Security'
               When Cd.Course_Pl = 'Other - Nest; Security-Emea'
                    And Upper (Isnull(Course_Type, 'None')) In
                             ('Other', 'None')
               Then
                  'Security'
               When Upper (Cd.Course_Type) In ('Security', 'Sonicwall')
               Then
                  'Security'
               When Cd.Course_Pl = 'Cisco'
               Then
                  'Networking'
               When Cd.Course_Pl = 'Microsoft'
               Then
                  'Operating Systems/Database'
               When Cd.Vendor_Code = 'Fishnet'
               Then
                  'Security'
               When Cd.Vendor_Code In ('Ca', 'Teleman', 'Akibia')
               Then
                  'Networking'
               When Cd.Vendor_Code In ('Sun', 'Emc')
               Then
                  'Operating Systems/Database'
               When Cd.Vendor_Code In ('Citrix')
               Then
                  'Virtualization'
               When Cd.Vendor_Code In ('Baker', 'Misti')
               Then
                  'Business Training'
               When Cd.Vendor_Code In ('West', 'Trivera', 'Exit')
               Then
                  'Application Development'
               When Upper (Cd.Course_Type) In
                          ('Unified Communications', 'Routing & Switching')
               Then
                  'Networking'
               When Cd.Course_Pl = 'Other' And Cd.Vendor_Code = 'Ibm'
               Then
                  'Application Development'
               Else
                  'Other'
            End
               Product_Line,
            Case
               When Cd.Course_Type = 'Lbs'
               Then
                  'Lbs'
               When Cd.Course_Pl = 'Business Training'
               Then
                  'Business Training'
               When Cd.Course_Pl = 'Cisco'
                    And Upper (Course_Type) In
                             ('Sales Training', 'Business Architecture')
               Then
                  'Business Training'
               When Cd.Course_Pl = 'Microsoft'
                    And Upper (Course_Type) In
                             ('Ms Office', 'Office', 'Project Management')
               Then
                  'Business Training'
               When Cd.Course_Pl = 'Other'
                    And Upper (Course_Type) In
                             ('Business Objects',
                              'Project Management',
                              'Business Analysis',
                              'Six Sigma',
                              'Sales Training',
                              'Professional Skills',
                              'Itil',
                              'Business Service Management')
               Then
                  'Business Training'
               When Cd.Vendor_Code In ('Baker', 'Misti')
               Then
                  'Business Training'
               Else
                  'Information Technology'
            End
               Business_Unit,
            Case
               When Cd.Course_Pl = 'Microsoft'
               Then
                  'Microsoft'
               When Cd.Course_Pl = 'Cisco'
               Then
                  'Cisco'
               When Cd.Course_Pl = 'Cloudera'
               Then
                  'Cloudera'
               When Cd.Course_Pl = 'Avaya'
               Then
                  'Avaya'
               When Cd.Course_Pl = 'Hp'
               Then
                  'Hp'
               When Cd.Course_Pl = 'Juniper'
               Then
                  'Juniper'
               When Cd.Course_Pl = 'Citrix'
               Then
                  'Citrix'
               When Cd.Course_Pl = 'Vmware'
               Then
                  'Vmware'
               When Cd.Course_Pl = 'Rsa'
               Then
                  'Rsa'
               When Cd.Vendor_Code = 'Citrix'
               Then
                  'Citrix'
               When Cd.Vendor_Code = 'Hp'
               Then
                  'Hp'
               When Cd.Vendor_Code = 'Emc'
               Then
                  'Emc'
               When Cd.Vendor_Code = 'Rhat'
               Then
                  'Red Hat'
               When Upper (Cd.Course_Type) In ('Apple')
               Then
                  'Apple'
               When Cd.Vendor_Code In ('Cisndm', 'Ciscohot')
               Then
                  'Cisco'
               When Upper (Cd.Course_Type) In
                          ('.Net', 'Ms Applications', 'Sharepoint')
               Then
                  'Microsoft'
               When Upper (Cd.Course_Type) = 'Adobe'
               Then
                  'Adobe'
               When Cd.Vendor_Code = 'Sap'
               Then
                  'Sap'
               When Cd.Vendor_Code = 'Ibm'
               Then
                  'Ibm'
               When Cd.Vendor_Code = '6Sig'
               Then
                  'Six Sigma'
               When Cd.Vendor_Code = 'Sonicwall'
               Then
                  'Sonic Wall'
               When Cd.Vendor_Code = 'Ama'
               Then
                  'American Management Assoc'
            End
               Vendor,
            Upper (Course_Type) Product_Type
     From      Gkdw.Course_Dim Cd
            Inner Join
               Gkdw.Event_Dim Ed
            On Cd.Course_Id = Ed.Course_Id And Cd.Country = Ed.Ops_Country
    Where   Cd.Gkdw_Source = 'Slxdw' And Isnull(Cd.Ch_Num, '00') > '00'
   Union
   Select   Distinct
            Pd.Product_Id,
            Pd.Prod_Num,
            Pd.Prod_Channel,
            Pd.Prod_Modality,
            Pd.Prod_Line,
            Pd.Prod_Family,
            Null Vendor_Code,
            Pd.Prod_Name,
            Case
               When Pd.Md_Num In ('32', '44', '50') Then 'Subscription'
               When Pd.Md_Num In ('31', '43') Then 'Learning Product'
            End
               Delivery_Method,
            Case
               When Pd.Md_Num In ('31', '32', '50') Then 'Gk Direct'
               When Pd.Md_Num In ('43', '44') Then 'Partner Delivered'
            End
               Delivery_Type,
            Case
               When Pd.Ch_Num = '10' Then 'Open Enrollment'
               When Pd.Ch_Num = '20' Then 'Enterprise'
            End
               Sales_Channel,
            Case
               When Pd.Prod_Line = 'Application Development'
               Then
                  'Application Development'
               When Pd.Prod_Line = 'Microsoft'
                    And Upper (Pd.Prod_Family) In
                             ('.Net', 'Sharepoint', 'Other')
               Then
                  'Application Development'
               When Pd.Prod_Line = 'Cloudera'
               Then
                  'Application Development'
               When Pd.Prod_Line = 'Other'
                    And Upper (Pd.Prod_Family) In
                             ('Software', 'Sharepoint', 'Programming', '.Net')
               Then
                  'Application Development'
               When Pd.Prod_Line = 'Networking'
               Then
                  'Networking'
               When Pd.Prod_Line = 'Cisco'
                    And Upper (Isnull(Pd.Prod_Family, 'None')) In
                             ('Data Center',
                              'Unified Communications',
                              'Optical Networking',
                              'Routing And Switching',
                              'Routing & Switching',
                              'Wireless',
                              'Elab',
                              'None')
               Then
                  'Networking'
               When Pd.Prod_Line = 'Microsoft'
                    And Upper (Pd.Prod_Family) In
                             ('Exchange', 'Unified Communications')
               Then
                  'Networking'
               When Pd.Prod_Line = 'Avaya'
               Then
                  'Networking'
               When Pd.Prod_Line = 'Hp'
               Then
                  'Networking'
               When Pd.Prod_Line = 'Juniper'
               Then
                  'Networking'
               When Pd.Prod_Line = 'Nortel'
               Then
                  'Networking'
               When Pd.Prod_Line = 'Other'
                    And Upper (Pd.Prod_Family) In
                             ('Routing & Switching',
                              'Unified Communications',
                              'Optical Networking',
                              'Telepresence',
                              'Networking',
                              'Voip And Telephony',
                              'Network Management',
                              'Network Infrastructure',
                              'Data Center',
                              'Cloud')
               Then
                  'Networking'
               When Pd.Prod_Line In
                          ('Business Training', 'Professional Skills')
               Then
                  'Business Training'
               When Pd.Prod_Line = 'Cisco'
                    And Upper (Pd.Prod_Family) In
                             ('Sales Training', 'Business Architecture')
               Then
                  'Business Training'
               When Pd.Prod_Line = 'Microsoft'
                    And Upper (Pd.Prod_Family) In
                             ('Ms Office', 'Office', 'Project Management')
               Then
                  'Business Training'
               When Pd.Prod_Line = 'Other'
                    And Upper (Pd.Prod_Family) In
                             ('Business Objects',
                              'Project Management',
                              'Business Analysis',
                              'Six Sigma',
                              'Sales Training',
                              'Professional Skills',
                              'Itil',
                              'Business Service Management',
                              'Thd')
               Then
                  'Business Training'
               When Pd.Prod_Line = 'Operating Systems'
               Then
                  'Operating Systems/Database'
               When Pd.Prod_Line = 'Microsoft'
                    And Upper (Pd.Prod_Family) In
                             ('Ms Moc',
                              'Boot Camp',
                              'Sql',
                              'Server',
                              'Windows 7',
                              'Windows Client',
                              'Vista',
                              'Xp',
                              'Operating Systems')
               Then
                  'Operating Systems/Database'
               When Pd.Prod_Line = 'Cisco'
                    And Upper (Pd.Prod_Family) In ('Database')
               Then
                  'Operating Systems/Database'
               When Pd.Prod_Line = 'Other'
                    And Upper (Pd.Prod_Family) In
                             ('Storage',
                              'Database',
                              'Operating Systems',
                              'Server')
               Then
                  'Operating Systems/Database'
               When Pd.Prod_Line = 'Vmware'
               Then
                  'Virtualization'
               When Pd.Prod_Line = 'Microsoft'
                    And Upper (Pd.Prod_Family) In ('Virtualization')
               Then
                  'Virtualization'
               When Pd.Prod_Line = 'Citrix'
               Then
                  'Virtualization'
               When Pd.Prod_Line = 'Other'
                    And Upper (Pd.Prod_Family) In ('App Virtualization')
               Then
                  'Virtualization'
               When Pd.Prod_Line = 'Cisco'
                    And Upper (Pd.Prod_Family) In ('Security')
               Then
                  'Security'
               When Pd.Prod_Line = 'Microsoft'
                    And Upper (Pd.Prod_Family) In ('Security')
               Then
                  'Security'
               When Pd.Prod_Line = 'Rsa'
               Then
                  'Security'
               When Pd.Prod_Line = 'Other - Nest; Security-Emea'
                    And Upper (Isnull(Pd.Prod_Family, 'None')) In
                             ('Other', 'None')
               Then
                  'Security'
               When Upper (Pd.Prod_Family) In ('Security', 'Sonicwall')
               Then
                  'Security'
               When Pd.Prod_Line = 'Cisco'
               Then
                  'Networking'
               When Pd.Prod_Line = 'Microsoft'
               Then
                  'Operating Systems/Database'
               When Upper (Pd.Prod_Family) In
                          ('Unified Communications', 'Routing & Switching')
               Then
                  'Networking'
               Else
                  'Other'
            End
               Product_Line,
            Case
               When Pd.Prod_Family = 'Lbs'
               Then
                  'Lbs'
               When Pd.Prod_Line In
                          ('Business Training', 'Professional Skills')
               Then
                  'Business Training'
               When Pd.Prod_Line = 'Cisco'
                    And Upper (Pd.Prod_Family) In
                             ('Sales Training', 'Business Architecture')
               Then
                  'Business Training'
               When Pd.Prod_Line = 'Microsoft'
                    And Upper (Pd.Prod_Family) In
                             ('Ms Office', 'Office', 'Project Management')
               Then
                  'Business Training'
               When Pd.Prod_Line = 'Other'
                    And Upper (Pd.Prod_Family) In
                             ('Business Objects',
                              'Project Management',
                              'Business Analysis',
                              'Six Sigma',
                              'Sales Training',
                              'Professional Skills',
                              'Itil',
                              'Business Service Management',
                              'Thd')
               Then
                  'Business Training'
               Else
                  'Information Technology'
            End
               Business_Unit,
            Case
               When Pd.Prod_Line = 'Microsoft'
               Then
                  'Microsoft'
               When Pd.Prod_Line = 'Cisco'
               Then
                  'Cisco'
               When Pd.Prod_Line = 'Cloudera'
               Then
                  'Cloudera'
               When Pd.Prod_Line = 'Avaya'
               Then
                  'Avaya'
               When Pd.Prod_Line = 'Hp'
               Then
                  'Hp'
               When Pd.Prod_Line = 'Juniper'
               Then
                  'Juniper'
               When Pd.Prod_Line = 'Citrix'
               Then
                  'Citrix'
               When Pd.Prod_Line = 'Vmware'
               Then
                  'Vmware'
               When Pd.Prod_Line = 'Rsa'
               Then
                  'Rsa'
               When Pd.Prod_Line = 'Nortel'
               Then
                  'Avaya'
               When Upper (Pd.Prod_Family) In ('Apple')
               Then
                  'Apple'
               When Upper (Pd.Prod_Family) In
                          ('.Net', 'Ms Applications', 'Sharepoint')
               Then
                  'Microsoft'
               When Upper (Pd.Prod_Family) = 'Adobe'
               Then
                  'Adobe'
               When Upper (Pd.Prod_Family) = 'Oracle'
               Then
                  'Oracle'
            End
               Vendor,
            Upper (Pd.Prod_Family) Product_Type
     From      Gkdw.Product_Dim Pd
            Inner Join
               Gkdw.Sales_Order_Fact Sf
            On Pd.Product_Id = Sf.Product_Id
    Where   Pd.Gkdw_Source = 'Slxdw' And Isnull(Pd.Ch_Num, '00') > '00'
   ;



