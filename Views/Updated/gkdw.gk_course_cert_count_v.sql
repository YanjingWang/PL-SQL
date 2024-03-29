


Create Or Alter View Hold.Gk_Course_Cert_Count_V
(
   Country,
   Course_Code,
   Course_Id,
   Cert_Cnt
)
As
     Select   Cd.Country,
              Cd.Course_Code,
              Cd.Course_Id,
              Count (Distinct Ri.Slx_Contact_Id) Cert_Cnt
       From         Rmsdw.Rms_Instructor Ri
                 Inner Join
                    Rmsdw.Rms_Instructor_Cert Ic
                 On Ri.Rms_Instructor_Id = Ic.Rms_Instructor_Id
              Inner Join
                 Gkdw.Course_Dim Cd
              On     Ic.Coursecode = Substring(Cd.Course_Code, 1,  4)
                 And Ic.Modality_Group = Cd.Course_Mod
                 And Ri.Instr_Country = Substring(Cd.Country, 1,  2)
                 And Cd.Ch_Num In ('10', '20')
      Where   Ri.Status = 'Yes' And Ic.Status = 'Certready'
   Group By   Cd.Country, Cd.Course_Code, Cd.Course_Id
   ;



