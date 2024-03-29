


Create Or Alter View Hold.Gk_Dup_Events_V
(
   Event_Id,
   Event_Desc,
   Location_Name,
   Start_Date,
   Course_Code,
   Creation_Date,
   Status,
   Dup_Flag,
   Enroll_Ct,
   Cancel_Ct,
   Contactid1,
   Contactid2,
   Contactid3,
   Name1,
   Name2,
   Name3,
   Dup_Event_Id,
   Dup_Event_Desc,
   Dup_Location_Name,
   Dup_Start_Date,
   Dup_Course_Code,
   Dup_Creation_Date,
   Dup_Status,
   Dup_Flag2,
   Dup_Enroll_Ct,
   Dup_Cancel_Ct,
   Dup_Contactid1,
   Dup_Contactid2,
   Dup_Contactid3,
   Dup_Name1,
   Dup_Name2,
   Dup_Name3
)
As
     Select   Ed1.Event_Id,
              Replace (Replace (Ed1.Event_Desc, Chr (13)), Chr (10)) Event_Desc,
              Ed1.Location_Name,
              Ed1.Start_Date,
              Ed1.Course_Code,
              Ed1.Creation_Date,
              Ed1.Status,
              Isnull(Ed1.Dup_Event_Flag, 'F') Dup_Flag,
              (Select   Count ( * )
                 From   Gkdw.Order_Fact Of1
                Where   Of1.Event_Id = Ed1.Event_Id
                        And Of1.Enroll_Status <> 'Cancelled')
                 Enroll_Ct,
              (Select   Count ( * )
                 From   Gkdw.Order_Fact Of1
                Where   Of1.Event_Id = Ed1.Event_Id
                        And Of1.Enroll_Status = 'Cancelled')
                 Cancel_Ct,
              Ei1.Contactid1,
              Ei1.Contactid2,
              Ei1.Contactid3,
              Ei1.Firstname1 + ' ' + Ei1.Lastname1 Name1,
              Ei1.Firstname2 + ' ' + Ei1.Lastname2 Name2,
              Ei1.Firstname3 + ' ' + Ei1.Lastname3 Name3,
              Ed2.Event_Id Dup_Event_Id,
              Replace (Replace (Ed2.Event_Desc, Chr (13)), Chr (10))
                 Dup_Event_Desc,
              Ed2.Location_Name Dup_Location_Name,
              Ed2.Start_Date Dup_Start_Date,
              Ed2.Course_Code Dup_Course_Code,
              Ed2.Creation_Date Dup_Creation_Date,
              Ed2.Status Dup_Status,
              Isnull(Ed2.Dup_Event_Flag, 'F') Dup_Flag2,
              (Select   Count ( * )
                 From   Gkdw.Order_Fact Of1
                Where   Of1.Event_Id = Ed2.Event_Id
                        And Of1.Enroll_Status <> 'Cancelled')
                 Dup_Enroll_Ct,
              (Select   Count ( * )
                 From   Gkdw.Order_Fact Of1
                Where   Of1.Event_Id = Ed2.Event_Id
                        And Of1.Enroll_Status = 'Cancelled')
                 Dup_Cancel_Ct,
              Ei2.Contactid1 Dup_Contactid1,
              Ei2.Contactid2 Dup_Contactid2,
              Ei2.Contactid3 Dup_Contactid3,
              Ei2.Firstname1 + ' ' + Ei2.Lastname1 Dup_Name1,
              Ei2.Firstname2 + ' ' + Ei2.Lastname2 Dup_Name2,
              Ei2.Firstname3 + ' ' + Ei2.Lastname3 Dup_Name3
       From            Gkdw.Event_Dim Ed1
                    Inner Join
                       Gkdw.Event_Dim Ed2
                    On Ed1.Course_Code = Ed2.Course_Code
                       And Upper (Isnull(Trim(Ed1.Location_Name), ' ')) =
                             Upper (Isnull(Trim (Ed2.Location_Name), ' '))
                       And Ed1.Start_Date = Ed2.Start_Date
                       And Ed1.Facility_Region_Metro =
                             Ed2.Facility_Region_Metro
                 Join
                    Gkdw.Gk_All_Event_Instr_V Ei1
                 On Ei1.Event_Id = Ed1.Event_Id
              Join
                 Gkdw.Gk_All_Event_Instr_V Ei2
              On Ei2.Event_Id = Ed2.Event_Id
      Where       Ed1.Event_Id < Ed2.Event_Id
              And Ed1.Event_Id Like 'Q%'
              And Substring(Ed1.Course_Code, 5,  1) In ('C')
              And Ed1.Ops_Country = 'Usa'
              And (Ed1.Status != 'Cancelled' And Ed2.Status != 'Cancelled')
   ;



