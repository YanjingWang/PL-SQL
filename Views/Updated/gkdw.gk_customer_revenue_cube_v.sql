


Create Or Alter View Hold.Gk_Customer_Revenue_Cube_V
(
   Dim_Year,
   Dim_Qtr,
   Dim_Month,
   Ops_Country,
   Group_Acct_Name,
   Naics_Desc,
   Rollup_Naics_Desc,
   Acct_Name,
   Acct_Id,
   City,
   State,
   Zipcode,
   Province,
   Country,
   National_Terr_Id,
   Territory,
   Region,
   Sales_Rep,
   Region_Mgr,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Course_Type,
   Total_Revenue
)
As
     Select   Td.Dim_Year,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Quarter, 2, '0') Dim_Qtr,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Dim_Month,
              Ed.Ops_Country,
              Upper (Isnull(N.Group_Acct_Name, Ad.Acct_Name)) Group_Acct_Name,
              Isnull(N.Group_Naics_Desc, N.Naics_Desc) Naics_Desc,
              Nl.Naics_Description Rollup_Naics_Desc,
              Ad.Acct_Name + ' (' + Ad.Acct_Id + ')' Acct_Name,
              Ad.Acct_Id,
              Ad.City,
              Ad.State,
              Ad.Zipcode,
              Ad.Province,
              Ad.Country,
              Ad.National_Terr_Id,
              Md.Territory,
              Md.Region,
              Md.Sales_Rep,
              Md.Region_Mgr,
              C.Course_Ch,
              C.Course_Mod,
              C.Course_Pl,
              C.Course_Type,
              Sum (Isnull(F.Book_Amt, 0)) Total_Revenue
       From                           Gkdw.Cust_Dim Cd
                                   Inner Join
                                      Gkdw.Account_Dim Ad
                                   On Cd.Acct_Id = Ad.Acct_Id
                                Inner Join
                                   Gkdw.Order_Fact F
                                On Cd.Cust_Id = F.Cust_Id
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On F.Event_Id = Ed.Event_Id
                          Inner Join
                             Gkdw.Course_Dim C
                          On Ed.Course_Id = C.Course_Id
                             And Ed.Ops_Country = C.Country
                       Inner Join
                          Gkdw.Time_Dim Td
                       On F.Book_Date = Td.Dim_Date
                    Left Outer Join
                       Gkdw.Gk_Account_Groups_Naics N
                    On Ad.Acct_Id = N.Acct_Id
                 Left Outer Join
                    Gkdw.Gk_Naics_Lookup Nl
                 On Substr (Isnull(N.Group_Naics_Code, N.Naics_Code), 1, 2) =
                       Nl.Naics_Code
              Left Outer Join
                 Gkdw.Market_Dim Md
              On Case
                    When Cd.Country = 'Usa' Then Substring(Ad.Zipcode, 1,  5)
                    Else Ad.Zipcode
                 End = Md.Zipcode
      Where   Td.Dim_Year >= 2010 And C.Ch_Num In ('10', '20')
   Group By   Td.Dim_Year,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Quarter, 2, '0'),
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0'),
              Ed.Ops_Country,
              Upper (Isnull(N.Group_Acct_Name, Ad.Acct_Name)),
              Isnull(N.Group_Naics_Desc, N.Naics_Desc),
              Ad.Acct_Name,
              Ad.Acct_Id,
              Ad.City,
              Ad.State,
              Ad.Zipcode,
              Ad.Province,
              Ad.Country,
              Ad.National_Terr_Id,
              Md.Territory,
              Md.Region,
              Md.Sales_Rep,
              Md.Region_Mgr,
              Nl.Naics_Description,
              C.Course_Ch,
              C.Course_Mod,
              C.Course_Pl,
              C.Course_Type
     Having   Sum (Isnull(F.Book_Amt, 0)) > 0;



