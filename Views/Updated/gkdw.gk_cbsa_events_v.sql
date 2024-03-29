


Create Or Alter View Hold.Gk_Cbsa_Events_V
(
   Cbsa_Code,
   Cbsa_Name,
   Ev_06,
   Ev_07,
   Ev_08,
   Ev_09,
   Ev_10
)
As
     Select   Cbsa_Code,
              Cbsa_Name,
              Sum (Events_06) Ev_06,
              Sum (Events_07) Ev_07,
              Sum (Events_08) Ev_08,
              Sum (Events_09) Ev_09,
              Sum (Events_10) Ev_10
       From   (  Select   Cbsa_Code,
                          Cbsa_Name,
                          Count (Distinct Ed.Event_Id) Events_06,
                          0 Events_07,
                          0 Events_08,
                          0 Events_09,
                          0 Events_10
                   From         Gkdw.Gk_Cbsa C
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On C.Zipcode = Substring(Ed.Zipcode, 1,  5)
                          Inner Join
                             Gkdw.Course_Dim Cd
                          On     Ed.Course_Id = Cd.Course_Id
                             And Ed.Ops_Country = Cd.Country
                             And Cd.Md_Num In ('10', '41')
                  Where   Ed.Start_Date Between '01-Dec-2006' And '31-Dec-2006'
               Group By   Cbsa_Code, Cbsa_Name
               Union All
                 Select   Cbsa_Code,
                          Cbsa_Name,
                          0,
                          Count (Distinct Ed.Event_Id),
                          0,
                          0,
                          0
                   From         Gkdw.Gk_Cbsa C
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On C.Zipcode = Substring(Ed.Zipcode, 1,  5)
                          Inner Join
                             Gkdw.Course_Dim Cd
                          On     Ed.Course_Id = Cd.Course_Id
                             And Ed.Ops_Country = Cd.Country
                             And Cd.Md_Num In ('10', '41')
                  Where   Ed.Start_Date Between '01-Dec-2007' And '31-Dec-2007'
               Group By   Cbsa_Code, Cbsa_Name
               Union All
                 Select   Cbsa_Code,
                          Cbsa_Name,
                          0,
                          0,
                          Count (Distinct Ed.Event_Id),
                          0,
                          0
                   From         Gkdw.Gk_Cbsa C
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On C.Zipcode = Substring(Ed.Zipcode, 1,  5)
                          Inner Join
                             Gkdw.Course_Dim Cd
                          On     Ed.Course_Id = Cd.Course_Id
                             And Ed.Ops_Country = Cd.Country
                             And Cd.Md_Num In ('10', '41')
                  Where   Ed.Start_Date Between '01-Dec-2008' And '31-Dec-2008'
               Group By   Cbsa_Code, Cbsa_Name
               Union All
                 Select   Cbsa_Code,
                          Cbsa_Name,
                          0,
                          0,
                          0,
                          Count (Distinct Ed.Event_Id),
                          0
                   From         Gkdw.Gk_Cbsa C
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On C.Zipcode = Substring(Ed.Zipcode, 1,  5)
                          Inner Join
                             Gkdw.Course_Dim Cd
                          On     Ed.Course_Id = Cd.Course_Id
                             And Ed.Ops_Country = Cd.Country
                             And Cd.Md_Num In ('10', '41')
                  Where   Ed.Start_Date Between '01-Dec-2009' And '31-Dec-2009'
               Group By   Cbsa_Code, Cbsa_Name
               Union All
                 Select   Cbsa_Code,
                          Cbsa_Name,
                          0,
                          0,
                          0,
                          0,
                          Count (Distinct Ed.Event_Id)
                   From         Gkdw.Gk_Cbsa C
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On C.Zipcode = Substring(Ed.Zipcode, 1,  5)
                          Inner Join
                             Gkdw.Course_Dim Cd
                          On     Ed.Course_Id = Cd.Course_Id
                             And Ed.Ops_Country = Cd.Country
                             And Cd.Md_Num In ('10', '41')
                  Where   Ed.Start_Date Between '01-Dec-2010' And '31-Dec-2010'
               Group By   Cbsa_Code, Cbsa_Name) a1
   Group By   Cbsa_Code, Cbsa_Name;



