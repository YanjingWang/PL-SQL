


Create Or Alter View Hold.Gk_Ext_Virtual_Web_V
(
   Event_Id,
   Instructor_Id,
   Instructor_Name,
   Course_Code,
   Delivery_Method,
   Class_Start_Time,
   Class_End_Time,
   Class_Day1,
   Class_Day2,
   Class_Day3,
   Class_Day4,
   Class_Day5,
   Class_Day6,
   Class_Day7,
   Class_Day8,
   Office_Start_Time,
   Office_End_Time,
   Office_Day1,
   Office_Day2,
   Office_Day3,
   Office_Day4
)
As
     Select   S1.Event_Id,
              S1.Instructor_Id,
              S1.Instructor_Name,
              S1.Course_Code,
              'Virtual Classroom' Delivery_Method,
              S1.Start_Time Class_Start_Time,
              S1.End_Time Class_End_Time,
              S1.Day1 Class_Day1,
              S1.Day2 Class_Day2,
              S1.Day3 Class_Day3,
              S1.Day4 Class_Day4,
              S1.Day5 Class_Day5,
              S1.Day6 Class_Day6,
              S1.Day7 Class_Day7,
              S1.Day8 Class_Day8,
              Case When Ed2.Status = 'Open' Then S2.Start_Time Else Null End
                 Office_Start_Time,
              Case When Ed2.Status = 'Open' Then S2.End_Time Else Null End
                 Office_End_Time,
              Case When Ed2.Status = 'Open' Then S2.Day1 Else Null End
                 Office_Day1,
              Case When Ed2.Status = 'Open' Then S2.Day2 Else Null End
                 Office_Day2,
              Case When Ed2.Status = 'Open' Then S2.Day3 Else Null End
                 Office_Day3,
              Case When Ed2.Status = 'Open' Then S2.Day4 Else Null End
                 Office_Day4
       From            Gkdw.Gk_Ext_Virtual_Schedule S1
                    Inner Join
                       Gkdw.Event_Dim Ed1
                    On S1.Event_Id = Ed1.Event_Id And Ed1.Status = 'Open'
                 Left Outer Join
                    Gkdw.Gk_Ext_Virtual_Schedule S2
                 On S1.Instructor_Id = S2.Instructor_Id
                    And Format(S1.Day1, 'Yyyy-Iw') =
                          Format(S2.Day1, 'Yyyy-Iw')
                    And Format(S1.Lastday, 'Yyyy-Iw') =
                          Format(S2.Lastday, 'Yyyy-Iw')
                    And S2.Office_Hour_Flag = 'Y'
              Left Outer Join
                 Gkdw.Event_Dim Ed2
              On S2.Event_Id = Ed2.Event_Id
      Where   S1.Office_Hour_Flag = 'N'
   ;



