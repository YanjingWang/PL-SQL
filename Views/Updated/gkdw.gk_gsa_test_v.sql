


Create Or Alter View Hold.Gk_Gsa_Test_V
(
   Acct_Name,
   Group_Acct_Name,
   Acct_Id,
   Email,
   Course_Code,
   Short_Name,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Ppcard_Id,
   Enroll_Id,
   Book_Amt,
   Book_Date,
   Fee_Type,
   Payment_Method,
   Event_Id,
   Start_Date,
   Facility_Region_Metro,
   City,
   State,
   Ob_Rep_Name
)
As
   Select   Acct_Name,
            Group_Acct_Name,
            Acct_Id,
            Email,
            Course_Code,
            Short_Name,
            Course_Ch,
            Course_Mod,
            Course_Pl,
            Ppcard_Id,
            Enroll_Id,
            Book_Amt,
            Book_Date,
            Fee_Type,
            Payment_Method,
            Event_Id,
            Start_Date,
            Facility_Region_Metro,
            City,
            State,
            Ob_Rep_Name
     From   (Select   Cd1.Acct_Name,
                      Isnull(N.Group_Acct_Name, Cd1.Acct_Name) Group_Acct_Name,
                      Cd1.Acct_Id,
                      Cd1.Email,
                      C.Course_Code,
                      C.Short_Name,
                      C.Course_Ch,
                      C.Course_Mod,
                      C.Course_Pl,
                      F.Ppcard_Id,
                      F.Enroll_Id,
                      F.Book_Amt,
                      F.Book_Date,
                      F.Fee_Type,
                      F.Payment_Method,
                      Ed.Event_Id,
                      Ed.Start_Date,
                      Ed.Facility_Region_Metro,
                      Cd1.City,
                      Cd1.State,
                      F.Ob_Rep_Name
               From                  Gkdw.Cust_Dim Cd1
                                  Inner Join
                                     Gkdw.Order_Fact F
                                  On Cd1.Cust_Id = F.Cust_Id
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
                      Left Outer Join
                         Gkdw.Gk_Account_Groups_Naics N
                      On Cd1.Acct_Id = N.Acct_Id
              Where   Td.Dim_Year >= 2009 --   And Td.Dim_Month_Num Between 8 And 12
                      And F.Enroll_Status In ('Confirmed', 'Attended')
                      And Exists
                            (Select   1
                               From   Gkdw.Cust_Dim Cd2
                              Where   Cd1.Acct_Id = Cd2.Acct_Id
                                      And (   Upper (Cd2.Email) Like '%.Gov'
                                           Or Upper (Cd2.Email) Like '%.Mil'
                                           Or Upper (Cd2.Email) Like '%.Us'))
             Union
             Select   Cd1.Acct_Name,
                      Isnull(N.Group_Acct_Name, Cd1.Acct_Name) Group_Acct_Name,
                      Cd1.Acct_Id,
                      Cd1.Email,
                      Pd.Prod_Num,
                      Pd.Prod_Name,
                      Pd.Prod_Channel,
                      Pd.Prod_Modality,
                      Pd.Prod_Line,
                      F.Ppcard_Id,
                      F.Sales_Order_Id,
                      F.Book_Amt,
                      F.Book_Date,
                      Null,
                      F.Payment_Method,
                      Null,
                      Null,
                      F.Record_Type,
                      Cd1.City,
                      Cd1.State,
                      F.Sales_Rep
               From               Gkdw.Cust_Dim Cd1
                               Inner Join
                                  Gkdw.Sales_Order_Fact F
                               On Cd1.Cust_Id = F.Cust_Id
                            Inner Join
                               Gkdw.Product_Dim Pd
                            On F.Product_Id = Pd.Product_Id
                         Inner Join
                            Gkdw.Time_Dim Td
                         On Trunc (F.Creation_Date) = Td.Dim_Date
                      Left Outer Join
                         Gkdw.Gk_Account_Groups_Naics N
                      On Cd1.Acct_Id = N.Acct_Id
              Where   Td.Dim_Year >= 2009 --   And Td.Dim_Month_Num Between 8 And 12
                                         And F.So_Status != 'Cancelled'
                      And Exists
                            (Select   1
                               From   Gkdw.Cust_Dim Cd2
                              Where   Cd1.Acct_Id = Cd2.Acct_Id
                                      And (   Upper (Cd2.Email) Like '%.Gov'
                                           Or Upper (Cd2.Email) Like '%.Mil'
                                           Or Upper (Cd2.Email) Like '%.Us'))) a1;



