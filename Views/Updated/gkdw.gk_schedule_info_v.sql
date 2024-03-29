


Create Or Alter View Hold.Gk_Schedule_Info_V
(
   Schedule_Id,
   Course_Pl,
   Course_Type,
   Course_Code,
   Short_Name,
   Course_Name,
   Dim_Year,
   Dim_Month_Num,
   Dim_Week,
   Event_Id,
   Start_Date,
   End_Date,
   Meeting_Days,
   Adj_Meeting_Days,
   Acct_Name,
   Location_Name,
   Facility_Region_Metro,
   Event_Country,
   Instructor_Id,
   Firstname,
   Lastname,
   Account,
   City,
   State,
   Instructor_Country,
   Connected_V_To_C,
   Zipcode,
   Start_Time,
   End_Time
)
As
     Select   S.[Id] Schedule_Id,
              T1.Course_Pl,
              T1.Course_Type,
              T1.Course_Code,
              T1.Short_Name,
              T1.Course_Name,
              T2.Dim_Year,
              T2.Dim_Month_Num,
              T2.Dim_Week,
              T3.Event_Id,
              T3.Start_Date,
              T3.End_Date,
              T3.Meeting_Days,
              T3.Adj_Meeting_Days,
              T4.Acct_Name,
              T3.Location_Name,
              T3.Facility_Region_Metro,
              T3.Country Event_Country,
              I.[Id] Instructor_Id,
              T5.Firstname,
              T5.Lastname,
              T5.Account,
              T3.City,
              T3.State,
              T6.Country Instructor_Country,
              T3.Connected_V_To_C,
              T3.Zipcode,
              T3.Start_Time,
              T3.End_Time
       From   Gkdw.Course_Dim T1,
              Gkdw.Time_Dim T2,
                                Gkdw.Event_Dim T3
                             Left Outer Join
                                Gkdw.Opportunity_Dim T7
                             On T3.Opportunity_Id = T7.Opportunity_Id
                          Left Outer Join
                             Gkdw.Account_Dim T4
                          On T7.Account_Id = T4.Acct_Id
                       Left Outer Join
                          Gkdw.Instructor_Event_V T5
                       On T3.Event_Id = T5.Evxeventid
                    Left Outer Join
                       Gkdw.Instructor_Dim T6
                    On T5.Contactid = T6.Cust_Id
                 Inner Join
                    Base.Rms_Schedule S
                 On S.[Slx_Id] = T3.Event_Id
              Left Outer Join
                 Base.Rms_Instructor_Func I
              On I.[Slx_Contact_Id] = T5.Contactid
      Where       T3.Course_Id = T1.Course_Id
              And T3.Ops_Country = T1.Country
              And T3.Start_Date = T2.Dim_Date
              And 1 = 1
              And T3.End_Date >= Cast(Getutcdate() As Date)
              --         Between To_Date ('2017-04-20 00:00:00',
              --                                              'Yyyy-Mm-Dd Hh24:Mi:Ss')
              --                                 And To_Date ('2017-04-20 00:00:00',
              --                                              'Yyyy-Mm-Dd Hh24:Mi:Ss')
              And T3.Status <> 'Cancelled'
              And T3.Event_Type <> 'Reseller'
   ;



