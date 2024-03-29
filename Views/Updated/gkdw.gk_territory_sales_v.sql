


Create Or Alter View Hold.Gk_Territory_Sales_V
(
   Dim_Year,
   Dim_Period_Name,
   Dim_Month_Num,
   Enroll_Id,
   Event_Id,
   Cust_Id,
   Book_Date,
   Book_Amt,
   Enroll_Status,
   Partner_Key_Code,
   Partner_Name,
   Cust_Name,
   Acct_Name,
   Acct_Id,
   Address1,
   Address2,
   City,
   State,
   Zipcode,
   Country,
   County,
   Workphone,
   Email,
   National_Terr_Id,
   Acct_Zipcode,
   Territory_Id,
   Salesrep,
   Region,
   Region_Mgr,
   Channel,
  [National],
   Mta
)
As
   Select   Td.Dim_Year,
            Td.Dim_Period_Name,
            Td.Dim_Month_Num,
            F.Enroll_Id,
            F.Event_Id,
            F.Cust_Id,
            F.Book_Date,
            F.Book_Amt,
            F.Enroll_Status,
            Cp.Partner_Key_Code,
            Partner_Name,
            Cd.Cust_Name,
            Cd.Acct_Name,
            Cd.Acct_Id,
            Cd.Address1,
            Cd.Address2,
            Cd.City,
            Cd.State,
            Cd.Zipcode,
            Cd.Country,
            Cd.County,
            Cd.Workphone,
            Cd.Email,
            Ad.National_Terr_Id,
            Ad.Zipcode Acct_Zipcode,
            Gt.Territory_Id,
            Gt.Salesrep,
            Gt.Region,
            Gt.Region_Mgr,
            Case When Cp.Partner_Key_Code Is Not Null Then 'Y' Else 'N' End
               Channel,
            Case
               When Ad.National_Terr_Id In ('32', '73', '52') Then 'Y'
               Else 'N'
            End
              [National],
            Case
               When Ad.National_Terr_Id Between '80' And '89'
                    And Cd.Zipcode = Ad.Zipcode
               Then
                  'Y'
               Else
                  'N'
            End
               Mta
     From                  Gkdw.Order_Fact F
                        Inner Join
                           Gkdw.Time_Dim Td
                        On F.Book_Date = Td.Dim_Date
                     Inner Join
                        Gkdw.Cust_Dim Cd
                     On F.Cust_Id = Cd.Cust_Id
                  Inner Join
                     Gkdw.Account_Dim Ad
                  On Cd.Acct_Id = Ad.Acct_Id
               Inner Join
                  Gkdw.Gk_Territory Gt
               On Gt.Territory_Type = 'Ob'
                  And F.Zip_Code Between Gt.Zip_Start And Gt.Zip_End
            Left Outer Join
               Gkdw.Gk_Channel_Partner Cp
            On F.Reg_Code = Cp.Partner_Key_Code
    Where   Td.Dim_Year >= 2008 And Cd.Country = 'Usa';



