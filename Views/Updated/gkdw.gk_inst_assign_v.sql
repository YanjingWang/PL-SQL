


Create Or Alter View Hold.Gk_Inst_Assign_V
(
   Event_Id,
   Course_Id,
   Location_Id,
   Start_Date,
   Event_City,
   Event_State,
   Event_Zipcode,
   Facility_Region_Metro,
   Facility_Code,
   Ops_Country,
   Course_Code,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Ch_Num,
   Md_Num,
   Pl_Num,
   Contactid1,
   Feecode1,
   Inst1,
   Account1,
   Inst1_City,
   Inst1_State,
   Inst1_Zipcode,
   Travel_Level1,
   Contactid2,
   Feecode2,
   Inst2,
   Account2,
   Inst2_City,
   Inst2_State,
   Inst2_Zipcode,
   Travel_Level2,
   Contactid3,
   Feecode3,
   Inst3,
   Account3,
   Inst3_City,
   Inst3_State,
   Inst3_Zipcode,
   Travel_Level3
)
As
     Select   Ed.Event_Id,
              Ed.Course_Id,
              Ed.Location_Id,
              Ed.Start_Date,
              Ed.City Event_City,
              Ed.State Event_State,
              Ed.Zipcode Event_Zipcode,
              Ed.Facility_Region_Metro,
              Ed.Facility_Code,
              Ed.Ops_Country,
              Cd.Course_Code,
              Cd.Course_Ch,
              Cd.Course_Mod,
              Cd.Course_Pl,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Ei.Contactid1,
              Ei.Feecode1,
              Ei.Firstname1 + ' ' + Ei.Lastname1 Inst1,
              Ei.Account1,
              Ct1.City Inst1_City,
              Ct1.State Inst1_State,
              Ct1.Zipcode Inst1_Zipcode,
              Case
                 When Rm1.Metro_Level Is Null And Ei.Contactid1 Is Not Null
                 Then
                    'No Level'
                 When Rm1.Metro_Level = 1
                 Then
                    'Full Local'
                 When Rm1.Metro_Level = 2
                 Then
                    'Limited Local'
                 When Rm1.Metro_Level = 3
                 Then
                    'Full Travel'
              End
                 Travel_Level1,
              Ei.Contactid2,
              Ei.Feecode2,
              Ei.Firstname2 + ' ' + Ei.Lastname2 Inst2,
              Ei.Account2,
              Ct2.City Inst2_City,
              Ct2.State Inst2_State,
              Ct2.Zipcode Inst2_Zipcode,
              Case
                 When Rm2.Metro_Level Is Null And Ei.Contactid2 Is Not Null
                 Then
                    'No Level'
                 When Rm2.Metro_Level = 1
                 Then
                    'Full Local'
                 When Rm2.Metro_Level = 2
                 Then
                    'Limited Local'
                 When Rm2.Metro_Level = 3
                 Then
                    'Full Travel'
              End
                 Travel_Level2,
              Ei.Contactid3,
              Ei.Feecode3,
              Ei.Firstname3 + ' ' + Ei.Lastname3 Inst3,
              Ei.Account3,
              Ct3.City Inst3_City,
              Ct3.State Inst3_State,
              Ct3.Zipcode Inst3_Zipcode,
              Case
                 When Rm3.Metro_Level Is Null And Ei.Contactid3 Is Not Null
                 Then
                    'No Level'
                 When Rm3.Metro_Level = 1
                 Then
                    'Full Local'
                 When Rm3.Metro_Level = 2
                 Then
                    'Limited Local'
                 When Rm3.Metro_Level = 3
                 Then
                    'Full Travel'
              End
                 Travel_Level3
       From                                       Gkdw.Event_Dim Ed
                                               Inner Join
                                                  Gkdw.Course_Dim Cd
                                               On Ed.Course_Id = Cd.Course_Id
                                                  And Ed.Ops_Country =
                                                        Cd.Country
                                            Inner Join
                                               Gkdw.Time_Dim Td
                                            On Ed.Start_Date = Td.Dim_Date
                                         Inner Join
                                            Gkdw.Gk_All_Event_Instr_V Ei
                                         On Ed.Event_Id = Ei.Event_Id
                                      Inner Join
                                         Rmsdw.Rms_Instructor R1
                                      On Ei.Contactid1 = R1.Slx_Contact_Id
                                   Inner Join
                                      Gkdw.Cust_Dim Ct1
                                   On Ei.Contactid1 = Ct1.Cust_Id
                                Left Outer Join
                                   Rmsdw.Rms_Instructor_Metro Rm1
                                On R1.Rms_Instructor_Id = Rm1.Rms_Instructor_Id
                                   And Ed.Facility_Region_Metro =
                                         Rm1.Metro_Code
                             Left Outer Join
                                Rmsdw.Rms_Instructor R2
                             On Ei.Contactid2 = R2.Slx_Contact_Id
                          Left Outer Join
                             Gkdw.Cust_Dim Ct2
                          On Ei.Contactid2 = Ct2.Cust_Id
                       Left Outer Join
                          Rmsdw.Rms_Instructor_Metro Rm2
                       On R2.Rms_Instructor_Id = Rm2.Rms_Instructor_Id
                          And Ed.Facility_Region_Metro = Rm2.Metro_Code
                    Left Outer Join
                       Rmsdw.Rms_Instructor R3
                    On Ei.Contactid3 = R3.Slx_Contact_Id
                 Left Outer Join
                    Gkdw.Cust_Dim Ct3
                 On Ei.Contactid3 = Ct3.Cust_Id
              Left Outer Join
                 Rmsdw.Rms_Instructor_Metro Rm3
              On R3.Rms_Instructor_Id = Rm3.Rms_Instructor_Id
                 And Ed.Facility_Region_Metro = Rm3.Metro_Code
      Where       Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0') = '2008-20'
              And Ed.Status != 'Cancelled'
              And Cd.Md_Num = '10'
   ;



