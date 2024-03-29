


Create Or Alter View Hold.Gk_Naics_Dnb_Cust_V
(
   Cust_Key,
   Company_Name,
   Primary_Addr1,
   Primary_City,
   Primary_State,
   Primary_Zip,
   Primary_Country,
   Conf_Code,
   Match_Grade,
   Bemfab,
   Duns_Number,
   Naics_Desc,
   Business_Name,
   Annual_Sales,
   Employees_Total,
   Employees_Here,
   Global_Ult_Business_Name,
   Parent_Hq_Name,
   Line_Of_Business,
   Bemfab_Acct_Match,
   Small_Business_Ind
)
As
   Select   Distinct
            Cust_Key,
            Company_Name,
            Primary_Addr1,
            Primary_City,
            Primary_State,
            Primary_Zip,
            Primary_Country,
            To_Number (Isnull(Replace (N.Conf_Code, Chr (13)), '0')) Conf_Code,
            Match_Grade,
            Bemfab,
            N.Duns_Number,
            Replace (Naics_Desc, Chr (13)) Naics_Desc,
            D.Business_Name,
            D.Annual_Sales,
            D.Employees_Total,
            D.Employees_Here,
            D.Global_Ult_Business_Name,
            D.Parent_Hq_Name,
            D.Line_Of_Business,
            Bemfab + '-' + Substring(Match_Grade, 1,  1) Bemfab_Acct_Match,
            D.Small_Business_Ind
     From      Gkdw.Gk_Naics_Append N
            Left Outer Join
               Gkdw.Gk_Duns_Append D
            On Lpad (Replace (N.Duns_Number, '-'), 9, '0') =
                  Lpad (D.Duns_Number, 9, '0');



