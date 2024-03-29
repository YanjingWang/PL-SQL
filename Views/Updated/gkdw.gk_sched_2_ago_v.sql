


Create Or Alter View Hold.Gk_Sched_2_Ago_V
(
   Dim_Year,
   Country,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Course_Type,
   Root_Code,
   Course_Id,
   Course_Code,
   Short_Name,
   Duration_Days,
   Sched_Cnt,
   Ev_Cnt,
   En_Cnt,
   Book_Amt
)
As
     Select   Format(Getutcdate(), 'Yyyy') - 2 Dim_Year,
              Country,
              Course_Ch,
              Course_Mod,
              Course_Pl,
              Course_Type,
              Root_Code,
              Course_Id,
              Course_Code,
              Short_Name,
              Duration_Days,
              Sum (Sched_Cnt) Sched_Cnt,
              Sum (Ev_Cnt) Ev_Cnt,
              Sum (En_Cnt) En_Cnt,
              Sum (Book_Amt) Book_Amt
       From   (  Select   Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days,
                          0 Sched_Cnt,
                          Count (Distinct Ed.Event_Id) Ev_Cnt,
                          Count (F.Enroll_Id) En_Cnt,
                          Sum (Isnull(U.Book_Amt, F.Book_Amt)) Book_Amt
                   From               Gkdw.Course_Dim Cd
                                   Inner Join
                                      Gkdw.Event_Dim Ed
                                   On Cd.Course_Id = Ed.Course_Id
                                      And Cd.Country = Ed.Ops_Country
                                Inner Join
                                   Gkdw.Time_Dim Td
                                On Ed.Start_Date = Td.Dim_Date
                             Inner Join
                                Gkdw.Order_Fact F
                             On Ed.Event_Id = F.Event_Id
                          Left Outer Join
                             Gkdw.Gk_Unlimited_Avg_Book_V U
                          On F.Cust_Id = U.Cust_Id
                  Where       Td.Dim_Year = Format(Getutcdate(), 'Yyyy') - 2
                          And Ch_Num = '10'
                          And Md_Num In ('10', '20')
                          And Ed.Status In ('Verified', 'Open')
                          And F.Enroll_Status != 'Cancelled'
                          And (F.Book_Amt > 0 Or F.Attendee_Type = 'Unlimited')
               Group By   Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days
               Union All
                 Select   Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days,
                          Count ( * ) Sched_Cnt,
                          0 Ev_Cnt,
                          0 En_Cnt,
                          0 Book_Amt
                   From         Gkdw.Course_Dim Cd
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On Cd.Course_Id = Ed.Course_Id
                                And Cd.Country = Ed.Ops_Country
                          Inner Join
                             Gkdw.Time_Dim Td
                          On Ed.Start_Date = Td.Dim_Date
                  Where       Td.Dim_Year = Format(Getutcdate(), 'Yyyy') - 2
                          And Ch_Num = '10'
                          And Md_Num In ('10', '20')
               Group By   Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days) a1
   Group By   Format(Getutcdate(), 'Yyyy') - 2,
              Country,
              Course_Ch,
              Course_Mod,
              Course_Pl,
              Course_Type,
              Root_Code,
              Course_Id,
              Course_Code,
              Short_Name,
              Duration_Days;



