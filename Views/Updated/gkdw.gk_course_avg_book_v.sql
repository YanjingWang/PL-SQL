


Create Or Alter View Hold.Gk_Course_Avg_Book_V
(
   Ops_Country,
   Metro,
   Course_Id,
   Avg_Book_Amt
)
As
     Select   Ed.Ops_Country,
              Ed.Facility_Region_Metro Metro,
              Cd.Course_Id,
              Avg (Book_Amt) Avg_Book_Amt
       From               Gkdw.Event_Dim Ed
                       Inner Join
                          Gkdw.Course_Dim Cd
                       On Ed.Course_Id = Cd.Course_Id
                          And Ed.Ops_Country = Cd.Country
                    Inner Join
                       Gkdw.Time_Dim Td
                    On Ed.Start_Date = Td.Dim_Date
                 Inner Join
                    Gkdw.Time_Dim Td1
                 On Td1.Dim_Date = Cast(Getutcdate() As Date)
              Inner Join
                 Gkdw.Order_Fact F
              On     Ed.Event_Id = F.Event_Id
                 And F.Enroll_Status = 'Attended'
                 And Book_Amt > 0
      Where   Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Between Dim_Year
                                                                            - 3
                                                                            + '-'
                                                                            + Lpad (
                                                                                  Dim_Month_Num,
                                                                                  2,
                                                                                  '0'
                                                                               )
                                                                        And  Dim_Year
                                                                             + '-'
                                                                             + Lpad (
                                                                                   Dim_Month_Num
                                                                                   - 1,
                                                                                   2,
                                                                                   '0'
                                                                                )
              And Ch_Num = '10'
              And Md_Num = '10'
              And Ed.Status = 'Verified'
   Group By   Ed.Ops_Country, Ed.Facility_Region_Metro, Cd.Course_Id;



