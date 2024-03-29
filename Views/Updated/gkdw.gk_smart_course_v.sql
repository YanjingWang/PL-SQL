


Create Or Alter View Hold.Gk_Smart_Course_V
(
   Course_Code,
   Course_Id,
   Course_Pl,
   Course_Type,
   Next_Course,
   Short_Name,
   Course_Name,
   Course_Rank
)
As
     Select   Course_Code,
              Q.Course_Id,
              Q.Course_Pl,
              Q.Course_Type,
              Q.Next_Course,
              Q.Short_Name,
              Q.Course_Name,
              Course_Rank
       From   (  Select   Cd.Course_Code,
                          Cd1.Course_Id,
                          Cd1.Course_Pl,
                          Cd1.Course_Type,
                          Cd1.Course_Code Next_Course,
                          Cd1.Short_Name,
                          Cd1.Course_Name,
                          Count ( * ) Course_Cnt,
                          Rank ()
                             Over (Partition By Cd.Course_Code
                                   Order By Count ( * ) Desc)
                             Course_Rank
                   From                        Gkdw.Course_Dim Cd
                                            Inner Join
                                               Gkdw.Event_Dim Ed
                                            On Cd.Course_Id = Ed.Course_Id
                                               And Cd.Country = Ed.Ops_Country
                                         Inner Join
                                            Gkdw.Order_Fact F
                                         On Ed.Event_Id = F.Event_Id
                                            And F.Enroll_Status In
                                                     ('Confirmed', 'Attended')
                                      Inner Join
                                         Gkdw.Time_Dim Td
                                      On Td.Dim_Date = F.Book_Date
                                   Inner Join
                                      Gkdw.Order_Fact F1
                                   On F.Cust_Id = F1.Cust_Id
                                      And F1.Enroll_Status In
                                               ('Confirmed', 'Attended')
                                Inner Join
                                   Gkdw.Event_Dim Ed1
                                On F1.Event_Id = Ed1.Event_Id
                             Inner Join
                                Gkdw.Course_Dim Cd1
                             On     Ed1.Course_Id = Cd1.Course_Id
                                And Ed1.Ops_Country = Cd1.Country
                                And Cd.Course_Id != Cd1.Course_Id
                                And Cd1.Course_Ch = 'Individual/Public'
                                And Cd1.Course_Pl != 'Allocation Pool/Overhead'
                          Inner Join
                             Gkdw.Time_Dim Td1
                          On Td1.Dim_Date = F1.Book_Date
                  Where   Td1.Dim_Year >= Td.Dim_Year - 2
                          And Exists
                                (Select   1
                                   From   Gkdw.Event_Dim Ed2
                                  Where       Cd1.Course_Id = Ed2.Course_Id
                                          And Ed2.Status = 'Open'
                                          And Ed2.Start_Date >= Cast(Getutcdate() As Date))
               Group By   Cd.Course_Code,
                          Cd1.Course_Id,
                          Cd1.Course_Pl,
                          Cd1.Course_Type,
                          Cd1.Course_Code,
                          Cd1.Short_Name,
                          Cd1.Course_Name) Q
      Where   Course_Rank <= 10
   ;



