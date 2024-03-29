


Create Or Alter View Hold.Gk_Outbound_Mod_Pl_V
(
   Opportunityid,
   Opportunity_Name,
   Price,
   Quantity,
   Discountpct,
   Discount,
   Coursecode,
   Productline,
   Modality,
   Salesrep,
   Acct_Mgr,
   Manager_Name,
   Status,
   Stage,
   Department,
   Salesrep_Region,
   Createdate,
   Coursename,
   Shortname,
   Vendorcode,
   Accounting_Week,
   Accounting_Month,
   Accounting_Year,
   Accountid,
   Account,
   Address1,
   Address2,
   City,
   State,
   Zip,
   Country,
   Salespotential,
   Estimatedclose,
   Closeprobability,
   Deliverydate,
   Contactid,
   Contact_Firstname,
   Contact_Lastname,
   Email,
   Phone,
   Reg_90Days,
   Reg_60Days,
   Reg_180Days,
   Est_Close_Mth,
   Est_Close_Yr,
   Ob_Territory_Num
)
As
   Select   O.Opportunityid,
            O.Description,
            Oc.Nettprice Price,
            Numattendees Quantity,
            (Oc.Assallowpercent * .01) Discountpct,
            ( (Oc.Listprice * Oc.Numattendees) - Oc.Nettprice) Discount,
            C.Coursecode,
            Cd.Course_Pl Productline,
            Cd.Course_Mod Modality,
            U.Username Salesrep,
            U2.Username,
            Us.Manager_Name,
            O.Status,
            O.Stage,
            U.Department,
            U.Region,
            O.Createdate,
            C.Coursename,
            C.Shortname,
            Vendorcode,
            Td.Dim_Week,
            Td.Dim_Month,
            Td.Dim_Year,
            A.Accountid,
            A.Account,
            Ad.Address1,
            Ad.Address2,
            Ad.City,
            Ad.State,
            Ad.Postalcode,
            Ad.Country,
            O.Salespotential,
            O.Estimatedclose,
            O.Closeprobability,
            Oc.Reqdeliverydate,
            Con.Contactid,
            Con.Firstname,
            Con.Lastname,
            Con.Email,
            Con.Workphone,
            Case
               When Tx.Coursecode = C.Coursecode
                    And Tx.Createdate Between O.Createdate
                                          And  O.Createdate + 90
               Then
                  1
               Else
                  0
            End
               Reg_90Days,
            Case
               When Tx.Coursecode = C.Coursecode
                    And Tx.Createdate Between O.Createdate
                                          And  O.Createdate + 60
               Then
                  1
               Else
                  0
            End
               Reg_60Days,
            Case
               When Tx.Coursecode = C.Coursecode
                    And Tx.Createdate Between O.Createdate
                                          And  O.Createdate + 180
               Then
                  1
               Else
                  0
            End
               Reg_180Days,
            Td2.Dim_Month,
            Td2.Dim_Year,
            Qcon.Ob_Terr_Num
     From                                                Base.Opportunity O
                                                      Inner Join
                                                         Base.Qg_Oppcourses Oc
                                                      On O.Opportunityid =
                                                            Oc.Opportunityid
                                                   Inner Join
                                                      Base.Opportunity_Contact Oppc
                                                   On O.Opportunityid =
                                                         Oppc.Opportunityid
                                                Inner Join
                                                   Base.Contact Con
                                                On Oppc.Contactid =
                                                      Con.Contactid
                                             Inner Join
                                                Base.Qg_Contact Qcon
                                             On Con.Contactid =
                                                   Qcon.Contactid
                                          Inner Join
                                             Base.Userinfo U
                                          On O.Createuser = U.Userid
                                       Inner Join
                                          Base.Userinfo U2
                                       On O.Accountmanagerid = U2.Userid
                                    Inner Join
                                       Base.Usersecurity Us
                                    On U.Userid = Us.Userid
                                 Inner Join
                                    Base.Account A
                                 On O.Accountid = A.Accountid
                              Inner Join
                                 Base.Address Ad
                              On A.Addressid = Ad.Addressid
                           Inner Join
                              Base.Evxcourse C
                           On Oc.Evxcourseid = C.Evxcourseid
                        Inner Join
                           Base.Qg_Course Qc
                        On C.Evxcourseid = Qc.Evxcourseid
                     Inner Join
                        Gkdw.Time_Dim Td
                     On Trunc (O.Createdate) = Td.Dim_Date
                  Left Outer Join
                     Gkdw.Course_Dim Cd
                  On C.Evxcourseid = Cd.Course_Id
               Left Outer Join
                  Base.Oracletx_History Tx
               On     Oppc.Contactid = Tx.Attendeecontactid
                  And Tx.Coursecode = C.Coursecode
                  And Tx.Createdate >= O.Createdate
            Left Outer Join
               Gkdw.Time_Dim Td2
            On Trunc (O.Estimatedclose) = Td2.Dim_Date
    Where   Oppc.Isprimary = 'T'
   --And Cd.Country = 'Usa' -- Commented Out On 4/13/11
   Union All
   Select   O.Opportunityid,
            O.Description,
            Op.Extendedprice,
            Quantity,
            Op.Discount Discountpct,
            Op.Price * Op.Discount Discount,
            Actualid Coursecode,
            Pd.Prod_Line,
            Pd.Prod_Modality,
            U.Username Salesrep,
            U2.Username,
            Us.Manager_Name,
            O.Status,
            O.Stage,
            U.Department,
            U.Region,
            O.Createdate,
            P.Product_Name Coursename,
            P.Product_Name Shortname,
            Null,
            Td.Dim_Week,
            Td.Dim_Month,
            Td.Dim_Year,
            A.Accountid,
            A.Account,
            Ad.Address1,
            Ad.Address2,
            Ad.City,
            Ad.State,
            Ad.Postalcode,
            Ad.Country,
            O.Salespotential,
            O.Estimatedclose,
            O.Closeprobability,
            Null,
            Con.Contactid,
            Con.Firstname,
            Con.Lastname,
            Con.Email,
            Con.Workphone,
            Null,
            Null,
            Null,
            Td2.Dim_Month,
            Td2.Dim_Year,
            Qcon.Ob_Terr_Num
     From                                          Base.Opportunity O
                                                Inner Join
                                                   Base.Opportunity_Contact Oppc
                                                On O.Opportunityid =
                                                      Oppc.Opportunityid
                                             Inner Join
                                                Base.Contact Con
                                             On Oppc.Contactid =
                                                   Con.Contactid
                                          Inner Join
                                             Base.Qg_Contact Qcon
                                          On Con.Contactid = Qcon.Contactid
                                       Inner Join
                                          Base.Opportunity_Product Op
                                       On O.Opportunityid = Op.Opportunityid
                                    Inner Join
                                       Base.Product P
                                    On Op.Productid = P.Productid
                                 Left Outer Join
                                    Gkdw.Product_Dim Pd
                                 On P.Productid = Pd.Product_Id
                              Inner Join
                                 Base.Userinfo U
                              On O.Createuser = U.Userid
                           Inner Join
                              Base.Userinfo U2
                           On O.Accountmanagerid = U2.Userid
                        Inner Join
                           Base.Usersecurity Us
                        On U.Userid = Us.Userid
                     Inner Join
                        Base.Account A
                     On O.Accountid = A.Accountid
                  Inner Join
                     Base.Address Ad
                  On A.Addressid = Ad.Addressid
               Inner Join
                  Gkdw.Time_Dim Td
               On Trunc (O.Createdate) = Td.Dim_Date
            Left Outer Join
               Gkdw.Time_Dim Td2
            On Trunc (O.Estimatedclose) = Td2.Dim_Date
    Where   Oppc.Isprimary = 'T'
   Union
   Select   O.Opportunityid,
            O.Description,
            Opp.Nettprice,
            Opp.Quantity Quantity,
            Opp.Discountpercent Discountpct,
            (Opp.Nettprice * Opp.Discountpercent) Discount,
            Pd.Prod_Num Coursecode,
            Pd.Prod_Line,
            Pd.Prod_Modality,
            U.Username Salesrep,
            U2.Username,
            Us.Manager_Name,
            O.Status,
            --Tp.Evxtppcardid,
            O.Stage,
            U.Department,
            U.Region,
            O.Createdate,
            Pd.Prod_Name Coursename,
            Pd.Prod_Name Shortname,
            Null,
            Td.Dim_Week,
            Td.Dim_Month,
            Td.Dim_Year,
            A.Accountid,
            A.Account,
            Ad.Address1,
            Ad.Address2,
            Ad.City,
            Ad.State,
            Ad.Postalcode,
            Ad.Country,
            O.Salespotential,
            O.Estimatedclose,
            O.Closeprobability,
            Null,
            Con.Contactid,
            Con.Firstname,
            Con.Lastname,
            Con.Email,
            Con.Workphone,
            Null,
            Null,
            Null,
            Td2.Dim_Month,
            Td2.Dim_Year,
            Qcon.Ob_Terr_Num
     From                                             Base.Opportunity O
                                                   Inner Join
                                                      Base.Opportunity_Contact Oppc
                                                   On O.Opportunityid =
                                                         Oppc.Opportunityid
                                                Inner Join
                                                   Base.Contact Con
                                                On Oppc.Contactid =
                                                      Con.Contactid
                                             Inner Join
                                                Base.Qg_Contact Qcon
                                             On Con.Contactid =
                                                   Qcon.Contactid
                                          Inner Join
                                             Base.Qg_Oppprepay Opp
                                          On O.Opportunityid =
                                                Opp.Opportunityid
                                       Inner Join
                                          Base.Evxtppcard Tp
                                       On Opp.Evxtppcardid = Tp.Evxtppcardid
                                    Left Join
                                       Base.Evxtppcard_Tx Tpptx
                                    On Tp.Evxtppcardid = Tpptx.Evxtppcardid
                                 Left Join
                                    Gkdw.Product_Dim Pd
                                 On Tpptx.Soproductid = Pd.Product_Id
                              Inner Join
                                 Base.Userinfo U
                              On O.Createuser = U.Userid
                           Inner Join
                              Base.Userinfo U2
                           On O.Accountmanagerid = U2.Userid
                        Inner Join
                           Base.Usersecurity Us
                        On U.Userid = Us.Userid
                     Inner Join
                        Base.Account A
                     On O.Accountid = A.Accountid
                  Inner Join
                     Base.Address Ad
                  On A.Addressid = Ad.Addressid
               Inner Join
                  Gkdw.Time_Dim Td
               On Trunc (O.Createdate) = Td.Dim_Date
            Left Outer Join
               Gkdw.Time_Dim Td2
            On Trunc (O.Estimatedclose) = Td2.Dim_Date
    Where   Oppc.Isprimary = 'T'
   ;



