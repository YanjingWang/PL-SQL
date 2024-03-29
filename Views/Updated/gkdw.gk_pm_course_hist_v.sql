


Create Or Alter View Hold.Gk_Pm_Course_Hist_V
(
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
   Sched_07,
   Ev_07,
   En_07,
   Sched_08,
   Ev_08,
   En_08,
   Sched_09,
   Ev_09,
   En_09,
   Sched_10,
   Ev_10,
   En_10
)
As
     Select   Country,
              Course_Ch,
              Course_Mod,
              Course_Pl,
              Course_Type,
              Root_Code,
              Course_Id,
              Course_Code,
              Short_Name,
              Duration_Days,
              Sum (Sched_2007) Sched_07,
              Sum (Ev_2007) Ev_07,
              Sum (En_2007) En_07,
              Sum (Sched_2008) Sched_08,
              Sum (Ev_2008) Ev_08,
              Sum (En_2008) En_08,
              Sum (Sched_2009) Sched_09,
              Sum (Ev_2009) Ev_09,
              Sum (En_2009) En_09,
              Sum (Sched_2010) Sched_10,
              Sum (Ev_2010) Ev_10,
              Sum (En_2010) En_10
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
                          Count (Distinct Ed.Event_Id) Ev_2007,
                          Count (F.Enroll_Id) En_2007,
                          0 Ev_2008,
                          0 En_2008,
                          0 Ev_2009,
                          0 En_2009,
                          0 Ev_2010,
                          0 En_2010,
                          0 Sched_2007,
                          0 Sched_2008,
                          0 Sched_2009,
                          0 Sched_2010
                   From            Gkdw.Course_Dim Cd
                                Inner Join
                                   Gkdw.Event_Dim Ed
                                On Cd.Course_Id = Ed.Course_Id
                                   And Cd.Country = Ed.Ops_Country
                             Inner Join
                                Gkdw.Time_Dim Td
                             On Ed.Start_Date = Td.Dim_Date
                          Inner Join
                             Gkdw.Order_Fact F
                          On     Ed.Event_Id = F.Event_Id
                             And F.Enroll_Status = 'Attended'
                             And F.Book_Amt > 0
                  Where       Td.Dim_Year = 2007
                          And Ch_Num = '10'
                          And Md_Num = '10'
                          And Ed.Status In ('Verified')
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
               Union
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
                          0,
                          0,
                          Count (Distinct Ed.Event_Id),
                          Count (F.Enroll_Id),
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0
                   From            Gkdw.Course_Dim Cd
                                Inner Join
                                   Gkdw.Event_Dim Ed
                                On Cd.Course_Id = Ed.Course_Id
                                   And Cd.Country = Ed.Ops_Country
                             Inner Join
                                Gkdw.Time_Dim Td
                             On Ed.Start_Date = Td.Dim_Date
                          Inner Join
                             Gkdw.Order_Fact F
                          On     Ed.Event_Id = F.Event_Id
                             And F.Enroll_Status = 'Attended'
                             And F.Book_Amt > 0
                  Where       Td.Dim_Year = 2008
                          And Ch_Num = '10'
                          And Md_Num = '10'
                          And Ed.Status In ('Verified')
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
               Union
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
                          0,
                          0,
                          0,
                          0,
                          Count (Distinct Ed.Event_Id),
                          Count (F.Enroll_Id),
                          0,
                          0,
                          0,
                          0,
                          0,
                          0
                   From            Gkdw.Course_Dim Cd
                                Inner Join
                                   Gkdw.Event_Dim Ed
                                On Cd.Course_Id = Ed.Course_Id
                                   And Cd.Country = Ed.Ops_Country
                             Inner Join
                                Gkdw.Time_Dim Td
                             On Ed.Start_Date = Td.Dim_Date
                          Inner Join
                             Gkdw.Order_Fact F
                          On     Ed.Event_Id = F.Event_Id
                             And F.Enroll_Status = 'Attended'
                             And F.Book_Amt > 0
                  Where       Td.Dim_Year = 2009
                          And Ch_Num = '10'
                          And Md_Num = '10'
                          And Ed.Status In ('Verified')
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
               Union
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
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          Count (Distinct Ed.Event_Id),
                          Count (F.Enroll_Id),
                          0,
                          0,
                          0,
                          0
                   From            Gkdw.Course_Dim Cd
                                Inner Join
                                   Gkdw.Event_Dim Ed
                                On Cd.Course_Id = Ed.Course_Id
                                   And Cd.Country = Ed.Ops_Country
                             Inner Join
                                Gkdw.Time_Dim Td
                             On Ed.Start_Date = Td.Dim_Date
                          Inner Join
                             Gkdw.Order_Fact F
                          On     Ed.Event_Id = F.Event_Id
                             And F.Enroll_Status = 'Attended'
                             And F.Book_Amt > 0
                  Where       Td.Dim_Year = 2010
                          And Ch_Num = '10'
                          And Md_Num = '10'
                          And Ed.Status In ('Verified')
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
               Union
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
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          Count (Ed.Event_Id),
                          0,
                          0,
                          0
                   From         Gkdw.Course_Dim Cd
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On Cd.Course_Id = Ed.Course_Id
                                And Cd.Country = Ed.Ops_Country
                          Inner Join
                             Gkdw.Time_Dim Td
                          On Ed.Start_Date = Td.Dim_Date
                  Where   Td.Dim_Year = 2007 And Ch_Num = '10' And Md_Num = '10'
                          And (Ed.Status In ('Open', 'Verified')
                               Or (Ed.Status = 'Cancelled'
                                   And Ed.Cancel_Reason = 'Low Enrollment'))
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
               Union
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
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          Count (Ed.Event_Id),
                          0,
                          0
                   From         Gkdw.Course_Dim Cd
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On Cd.Course_Id = Ed.Course_Id
                                And Cd.Country = Ed.Ops_Country
                          Inner Join
                             Gkdw.Time_Dim Td
                          On Ed.Start_Date = Td.Dim_Date
                  Where   Td.Dim_Year = 2008 And Ch_Num = '10' And Md_Num = '10'
                          And (Ed.Status In ('Open', 'Verified')
                               Or (Ed.Status = 'Cancelled'
                                   And Ed.Cancel_Reason = 'Low Enrollment'))
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
               Union
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
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          Count (Ed.Event_Id),
                          0
                   From         Gkdw.Course_Dim Cd
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On Cd.Course_Id = Ed.Course_Id
                                And Cd.Country = Ed.Ops_Country
                          Inner Join
                             Gkdw.Time_Dim Td
                          On Ed.Start_Date = Td.Dim_Date
                  Where   Td.Dim_Year = 2009 And Ch_Num = '10' And Md_Num = '10'
                          And (Ed.Status In ('Open', 'Verified')
                               Or (Ed.Status = 'Cancelled'
                                   And Ed.Cancel_Reason = 'Low Enrollment'))
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
               Union
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
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          Count (Ed.Event_Id)
                   From         Gkdw.Course_Dim Cd
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On Cd.Course_Id = Ed.Course_Id
                                And Cd.Country = Ed.Ops_Country
                          Inner Join
                             Gkdw.Time_Dim Td
                          On Ed.Start_Date = Td.Dim_Date
                  Where   Td.Dim_Year = 2010 And Ch_Num = '10' And Md_Num = '10'
                          And (Ed.Status In ('Open', 'Verified')
                               Or (Ed.Status = 'Cancelled'
                                   And Ed.Cancel_Reason = 'Low Enrollment'))
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
      Where   Substring(Course_Code, 5,  1) = 'C'
   Group By   Country,
              Course_Ch,
              Course_Mod,
              Course_Pl,
              Course_Type,
              Root_Code,
              Course_Id,
              Course_Code,
              Short_Name,
              Duration_Days;



