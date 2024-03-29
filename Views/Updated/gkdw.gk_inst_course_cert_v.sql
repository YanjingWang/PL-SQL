


Create Or Alter View Hold.Gk_Inst_Course_Cert_V
(
   Instructor_Id,
   Course_Code,
   Status
)
As
   Select   Slx_Contact_Id Instructor_Id,
            Ric.Coursecode + 'C' Course_Code,
            Ric.Status
     From      Rmsdw.Rms_Instructor Ri
            Inner Join
               Rmsdw.Rms_Instructor_Cert Ric
            On Ri.Rms_Instructor_Id = Ric.Rms_Instructor_Id
    Where   Modality_Group = 'C-Learning'
   Union
   Select   Slx_Contact_Id Instructor_Id,
            Ric.Coursecode + 'N' Course_Code,
            Ric.Status
     From      Rmsdw.Rms_Instructor Ri
            Inner Join
               Rmsdw.Rms_Instructor_Cert Ric
            On Ri.Rms_Instructor_Id = Ric.Rms_Instructor_Id
    Where   Modality_Group = 'C-Learning'
   Union
   Select   Slx_Contact_Id Instructor_Id,
            Ric.Coursecode + 'L' Course_Code,
            Ric.Status
     From      Rmsdw.Rms_Instructor Ri
            Inner Join
               Rmsdw.Rms_Instructor_Cert Ric
            On Ri.Rms_Instructor_Id = Ric.Rms_Instructor_Id
    Where   Modality_Group = 'V-Learning'
   Union
   Select   Slx_Contact_Id Instructor_Id,
            Ric.Coursecode + 'V' Course_Code,
            Ric.Status
     From      Rmsdw.Rms_Instructor Ri
            Inner Join
               Rmsdw.Rms_Instructor_Cert Ric
            On Ri.Rms_Instructor_Id = Ric.Rms_Instructor_Id
    Where   Modality_Group = 'V-Learning'
   ;



