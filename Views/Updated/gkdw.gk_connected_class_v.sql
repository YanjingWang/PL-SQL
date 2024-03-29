


Create Or Alter View Hold.Gk_Connected_Class_V
(
   Course_Pl,
   Short_Name,
   Dim_Year,
   Dim_Week,
   Course_Code,
   Course_Id,
   Facility_Region_Metro,
   Ops_Country,
   Event_Id,
   Event_Desc,
   Start_Date,
   End_Date,
   Status,
   Location_Name,
   Enroll_Cnt,
   Book_Amt,
   Capacity,
   Start_Time,
   End_Time,
   Ins_Name,
   Connected_C,
   Connected_V_To_C,
   Feecode
)
As
     Select   Q.Course_Pl,
              Q.Short_Name,
              Q.Dim_Year,
              Q.Dim_Week,
              Q.Course_Code,
              Q.Course_Id,
              Q.Facility_Region_Metro,
              Q.Ops_Country,
              Q.Event_Id,
              Q.Event_Desc,
              Q.Start_Date,
              Q.End_Date,
              Q.Status,
              Q.Location_Name,
              Count (Distinct F.Enroll_Id) Enroll_Cnt,
              Sum (Isnull(F.Book_Amt, 0)) Book_Amt,
              Q.Capacity,
              Q.Start_Time,
              Q.End_Time,
              Ie.Firstname1 + ' ' + Ie.Lastname1 Ins_Name,
              'Y' Connected_C,
              Null Connected_V_To_C,
              Ie.Feecode1 Feecode
       From         (  Select   Cd.Course_Pl,
                                Cd.Short_Name,
                                Td.Dim_Year,
                                Td.Dim_Week,
                                Cd.Course_Code,
                                Cd.Course_Id,
                                Ed1.Facility_Region_Metro,
                                Ed1.Ops_Country,
                                Ed1.Event_Id,
                                Ed1.Event_Desc,
                                Ed1.Start_Date,
                                Ed1.End_Date,
                                Ed1.Status,
                                Ed1.Location_Name,
                                Ed1.Capacity,
                                Ed1.Start_Time,
                                Ed1.End_Time
                         From               Base.Rms_Connected_Events C
                                         Inner Join
                                            Gkdw.Event_Dim Ed1
                                         On C.[Parent_Evxeventid] = Ed1.Event_Id
                                            And Ed1.Status != 'Cancelled'
                                      Inner Join
                                         Gkdw.Course_Dim Cd
                                      On Ed1.Course_Id = Cd.Course_Id
                                         And Ed1.Ops_Country = Cd.Country
                                   Inner Join
                                      Gkdw.Time_Dim Td
                                   On Ed1.Start_Date = Td.Dim_Date
                                Left Outer Join
                                   Gkdw.Order_Fact F
                                On Ed1.Event_Id = F.Event_Id
                     Group By   Cd.Course_Pl,
                                Cd.Short_Name,
                                Td.Dim_Year,
                                Td.Dim_Week,
                                Cd.Course_Code,
                                Cd.Course_Id,
                                Ed1.Facility_Region_Metro,
                                Ed1.Ops_Country,
                                Ed1.Event_Id,
                                Ed1.Event_Desc,
                                Ed1.Start_Date,
                                Ed1.End_Date,
                                Ed1.Status,
                                Ed1.Location_Name,
                                Ed1.Capacity,
                                Ed1.Start_Time,
                                Ed1.End_Time) Q
                 Left Outer Join
                    Gkdw.Order_Fact F
                 On Q.Event_Id = F.Event_Id And F.Enroll_Status != 'Cancelled'
              Left Outer Join
                 Gkdw.Gk_All_Event_Instr_V Ie
              On Q.Event_Id = Ie.Event_Id
   Group By   Q.Course_Pl,
              Q.Short_Name,
              Q.Dim_Year,
              Q.Dim_Week,
              Q.Course_Code,
              Q.Course_Id,
              Q.Facility_Region_Metro,
              Q.Ops_Country,
              Q.Event_Id,
              Q.Event_Desc,
              Q.Start_Date,
              Q.End_Date,
              Q.Status,
              Q.Location_Name,
              Q.Capacity,
              Q.Start_Time,
              Q.End_Time,
              Ie.Firstname1 + ' ' + Ie.Lastname1,
              Ie.Feecode1
   Union
     Select   Cd.Course_Pl,
              Cd.Short_Name,
              Td.Dim_Year,
              Td.Dim_Week,
              Cd.Course_Code,
              Cd.Course_Id,
              Ed1.Facility_Region_Metro,
              Ed1.Ops_Country,
              Ed1.Event_Id,
              Ed1.Event_Desc,
              Ed1.Start_Date,
              Ed1.End_Date,
              Ed1.Status,
              Ed1.Location_Name,
              Count (Distinct F.Enroll_Id),
              Sum (Isnull(F.Book_Amt, 0)) Book_Amt,
              Ed1.Capacity,
              Ed1.Start_Time,
              Ed1.End_Time,
              Ie.Firstname1 + ' ' + Ie.Lastname1 Ins_Name,
              Null,
              C.[Parent_Evxeventid] Connected_V_To_C,
              Ie.Feecode1
       From                     Base.Rms_Connected_Events C
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On C.[Parent_Evxeventid] = Ed.Event_Id
                                And Ed.Status != 'Cancelled'
                          Inner Join
                             Gkdw.Event_Dim Ed1
                          On C.[Child_Evxeventid] = Ed1.Event_Id
                             And Ed1.Status != 'Cancelled'
                       Inner Join
                          Gkdw.Course_Dim Cd
                       On Ed1.Course_Id = Cd.Course_Id
                          And Ed1.Ops_Country = Cd.Country
                    Inner Join
                       Gkdw.Time_Dim Td
                    On Ed1.Start_Date = Td.Dim_Date
                 Left Outer Join
                    Gkdw.Order_Fact F
                 On Ed1.Event_Id = F.Event_Id
                    And F.Enroll_Status != 'Cancelled'
              Left Outer Join
                 Gkdw.Gk_All_Event_Instr_V Ie
              On Ed1.Event_Id = Ie.Event_Id
   Group By   Cd.Course_Pl,
              Cd.Short_Name,
              Td.Dim_Year,
              Td.Dim_Week,
              Cd.Course_Code,
              Cd.Course_Id,
              Ed1.Facility_Region_Metro,
              Ed1.Ops_Country,
              Ed1.Event_Id,
              Ed1.Event_Desc,
              Ed1.Start_Date,
              Ed1.End_Date,
              Ed1.Status,
              Ed1.Location_Name,
              Ed1.Capacity,
              Ed1.Start_Time,
              Ed1.End_Time,
              Ie.Firstname1 + ' ' + Ie.Lastname1,
              C.[Parent_Evxeventid],
              Ie.Feecode1
   ;



