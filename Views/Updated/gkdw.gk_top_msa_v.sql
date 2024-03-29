


Create Or Alter View Hold.Gk_Top_Msa_V
(
   Reporting_Msa,
   Rev_Amt
)
As
     Select   Isnull(Z.Consolidated_Msa, Z.Msa_Desc) Reporting_Msa,
              Sum (Book_Amt) Rev_Amt
       From                  Gkdw.Order_Fact F
                          Inner Join
                             Gkdw.Event_Dim Ed
                          On F.Event_Id = Ed.Event_Id
                       Inner Join
                          Gkdw.Course_Dim C
                       On Ed.Course_Id = C.Course_Id
                          And Ed.Ops_Country = C.Country
                    Inner Join
                       Gkdw.Time_Dim Td
                    On Ed.Start_Date = Td.Dim_Date
                 Inner Join
                    Gkdw.Cust_Dim Cd
                 On F.Cust_Id = Cd.Cust_Id
              Inner Join
                 Gkdw.Gk_Msa_Zips Z
              On Substring(Cd.Zipcode, 1,  5) = Z.Zip_Code
      Where       Td.Dim_Year Between 2007 And 2009
              And F.Enroll_Status != 'Cancelled'
              And Ed.Status != 'Cancelled'
              And C.Ch_Num In ('10', '20')
              And C.Md_Num = '10'
              And Z.Msa_Desc Not Like '%Nonmetro%'
   Group By   Isnull(Z.Consolidated_Msa, Z.Msa_Desc)
     Having   Sum (Book_Amt) >= 1000000
   ;



