


Create Or Alter View Hold.Gk_Event_Consolidation_V
(
   Event_Id,
   Course_Id,
   Course_Code,
   Short_Name,
   Start_Date,
   End_Date,
   Status,
   Facility_Code,
   Facility_Region_Metro,
   City,
   State,
   Zipcode,
   Enroll_Cnt,
   Enroll_Id,
   Book_Date,
   Keycode,
   Book_Amt,
   Fee_Type,
   Source,
   List_Price,
   Po_Number,
   Payment_Method,
   Cust_Id,
   First_Name,
   Last_Name,
   Acct_Name,
   Email,
   Cust_City,
   Cust_State,
   Cust_Zipcode,
   Cust_Lat,
   Cust_Long,
   Distance_Mi
)
As
     Select   Q.*,
              F.Enroll_Id,
              F.Book_Date,
              F.Keycode,
              F.Book_Amt,
              F.Fee_Type,
              F.Source,
              F.List_Price,
              F.Po_Number,
              F.Payment_Method,
              Cd.Cust_Id,
              Cd.First_Name,
              Cd.Last_Name,
              Cd.Acct_Name,
              Cd.Email,
              Cd.City Cust_City,
              Cd.State Cust_State,
              Substring(Cd.Zipcode, 1,  5) Cust_Zipcode,
              L2.Latitude Cust_Lat,
              L2.Longitude Cust_Long,
              Round (Get_Distance (L1.Latitude,
                                   L1.Longitude,
                                   L2.Latitude,
                                   L2.Longitude))
                 Distance_Mi
       From               (  Select   Ed.Event_Id,
                                      Ed.Course_Id,
                                      Cd.Course_Code,
                                      Cd.Short_Name,
                                      Ed.Start_Date,
                                      Ed.End_Date,
                                      Ed.Status,
                                      Ed.Facility_Code,
                                      Ed.Facility_Region_Metro,
                                      Ed.City,
                                      Ed.State,
                                      Ed.Zipcode,
                                      Sum(Case
                                             When F.Enroll_Status = 'Confirmed'
                                                  And F.Book_Amt > 0
                                             Then
                                                1
                                             Else
                                                0
                                          End)
                                         Enroll_Cnt
                               From               Gkdw.Event_Dim Ed
                                               Inner Join
                                                  Gkdw.Course_Dim Cd
                                               On Ed.Course_Id = Cd.Course_Id
                                                  And Ed.Ops_Country = Cd.Country
                                            Inner Join
                                               Gkdw.Order_Fact F
                                            On Ed.Event_Id = F.Event_Id
                                         Inner Join
                                            Gkdw.Time_Dim Td1
                                         On Ed.Start_Date = Td1.Dim_Date
                                      Inner Join
                                         Gkdw.Time_Dim Td2
                                      On Td2.Dim_Date = Cast(Getutcdate() As Date)
                              Where   Td1.Dim_Year = Td2.Dim_Year
                                      And Td1.Dim_Week Between Td2.Dim_Week + 4
                                                           And  Td2.Dim_Week + 8
                                      And Not Exists
                                            (Select   1
                                               From   Gkdw.Gk_Nested_Courses N
                                              Where   N.Nested_Course_Code =
                                                         Cd.Course_Code)
                                      And Ed.Ops_Country = 'Usa'
                                      And Cd.Ch_Num = '10'
                                      And Cd.Md_Num = '10'
                                      And Ed.Status = 'Open'
                           Group By   Ed.Event_Id,
                                      Ed.Course_Id,
                                      Cd.Course_Code,
                                      Cd.Short_Name,
                                      Ed.Start_Date,
                                      Ed.End_Date,
                                      Ed.Status,
                                      Ed.Facility_Code,
                                      Ed.Facility_Region_Metro,
                                      Ed.City,
                                      Ed.State,
                                      Ed.Zipcode
                             Having   Sum(Case
                                             When F.Enroll_Status = 'Confirmed'
                                                  And F.Book_Amt > 0
                                             Then
                                                1
                                             Else
                                                0
                                          End) <= 3) Q
                       Inner Join
                          Gkdw.Order_Fact F
                       On Q.Event_Id = F.Event_Id
                    Inner Join
                       Gkdw.Cust_Dim Cd
                    On F.Cust_Id = Cd.Cust_Id
                 Left Outer Join
                    Gkdw.Gk_Zipcode_Lat_Long L1
                 On Q.Zipcode = Lpad (L1.Zipcode, 5, '0')
              Left Outer Join
                 Gkdw.Gk_Zipcode_Lat_Long L2
              On Substring(Cd.Zipcode, 1,  5) = Lpad (L2.Zipcode, 5, '0')
      Where   F.Enroll_Status = 'Confirmed' And F.Book_Amt > 0
   ;



