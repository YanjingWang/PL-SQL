


Create Or Alter View Hold.Gk_Smart_V
(
   Cust_Id,
   Course_Id,
   Course_Pl,
   Course_Type,
   Next_Course,
   Short_Name,
   Course_Name,
   Course_Rank
)
As
     Select   Cust_Id,
              Q.Course_Id,
              Q.Course_Pl,
              Q.Course_Type,
              Q.Next_Course,
              Q.Short_Name,
              Q.Course_Name,
              Course_Rank
       From   (  Select   F.Cust_Id,
                          Cd3.Course_Id,
                          Cd3.Course_Pl,
                          Cd3.Course_Type,
                          Cd3.Course_Code Next_Course,
                          Cd3.Short_Name,
                          Cd3.Course_Name,
                          Count ( * ) Course_Cnt,
                          Rank ()
                             Over (Partition By F.Cust_Id
                                   Order By Count ( * ) Desc)
                             Course_Rank
                   From                                    Gkdw.Order_Fact F
                                                        Inner Join
                                                           Gkdw.Time_Dim Td
                                                        On Td.Dim_Date =
                                                              F.Book_Date
                                                     Inner Join
                                                        Gkdw.Event_Dim Ed
                                                     On F.Event_Id = Ed.Event_Id
                                                  Inner Join
                                                     Gkdw.Course_Dim Cd
                                                  On Ed.Course_Id = Cd.Course_Id
                                                     And Ed.Ops_Country =
                                                           Cd.Country
                                               --And Cd.Course_Ch = 'Individual/Public'
                                               Inner Join
                                                  Gkdw.Event_Dim Ed2
                                               On Cd.Course_Id = Ed2.Course_Id
                                            Inner Join
                                               Gkdw.Order_Fact F2
                                            On Ed2.Event_Id = F2.Event_Id
                                               And F2.Enroll_Status In
                                                        ('Confirmed', 'Attended')
                                         Inner Join
                                            Gkdw.Time_Dim Td2
                                         On Td2.Dim_Date = F2.Book_Date
                                      Inner Join
                                         Gkdw.Cust_Dim C2
                                      On F2.Cust_Id = C2.Cust_Id
                                   Inner Join
                                      Gkdw.Order_Fact F3
                                   On C2.Cust_Id = F3.Cust_Id
                                      And F3.Enroll_Status In
                                               ('Confirmed', 'Attended')
                                Inner Join
                                   Gkdw.Time_Dim Td3
                                On Td3.Dim_Date = F2.Book_Date
                             Inner Join
                                Gkdw.Event_Dim Ed3
                             On F3.Event_Id = Ed3.Event_Id
                          Inner Join
                             Gkdw.Course_Dim Cd3
                          On     Ed3.Course_Id = Cd3.Course_Id
                             And Ed3.Ops_Country = Cd3.Country
                             And Cd.Course_Code != Cd3.Course_Code
                             And Cd3.Course_Ch = 'Individual/Public'
                             And Cd3.Course_Pl != 'Allocation Pool/Overhead'
                  Where       F.Enroll_Status In ('Confirmed', 'Attended')
                          And Td2.Dim_Year >= Td.Dim_Year - 2
                          And Td3.Dim_Year >= Td.Dim_Year - 2
                          And Not Exists
                                (Select   1
                                   From         Gkdw.Order_Fact F4
                                             Inner Join
                                                Gkdw.Event_Dim Ed4
                                             On F4.Event_Id = Ed4.Event_Id
                                          Inner Join
                                             Gkdw.Course_Dim Cd4
                                          On Ed4.Course_Id = Cd4.Course_Id
                                             And Ed4.Ops_Country = Cd4.Country
                                  Where   F4.Cust_Id = F.Cust_Id
                                          And Substring(Cd3.Course_Code, 1,  4) =
                                                Substring(Cd4.Course_Code, 1,  4))
                          And Exists
                                (Select   1
                                   From   Gkdw.Event_Dim Ed5
                                  Where   Cd3.Course_Id = Ed5.Course_Id
                                          And Ed5.Status = 'Open')
               Group By   F.Cust_Id,
                          Cd3.Course_Id,
                          Cd3.Course_Pl,
                          Cd3.Course_Type,
                          Cd3.Course_Code,
                          Cd3.Short_Name,
                          Cd3.Course_Name) Q
      Where   Course_Rank <= 10
   ;



