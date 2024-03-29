


Create Or Alter View Hold.Gk_Mtm_Survey_Data_V
(
   Eval_Submitted_Id,
   External_Student_Id,
   Student_Email,
   External_Class_Id,
   Class_End_Date,
   External_Instructor_Id,
   Instructor_Name,
   External_Course_Id,
   Course_Name,
   External_Vendor_Id,
   Channel,
   Vendor,
   Vendor_Location,
   Learning_Method,
   Form_Name,
   Question,
   Question_Category,
   Answer,
   Entered_Date,
   Answer_Type,
   Entry_Method,
   Mtm_Event_Id,
   Question_Id,
   Connected_C,
   Connected_V_To_C
)
As
   Select   Eval_Submitted_Id,
            External_Student_Id,
            Student_Email,
            External_Class_Id,
            Class_End_Date,
            External_Instructor_Id,
            Instructor_Name,
            External_Course_Id,
            Course_Name,
            External_Vendor_Id,
            Channel,
            Vendor,
            Vendor_Location,
            Learning_Method,
            Form_Name,
            Question,
            Question_Category,
            Answer,
            Entered_Date,
            Answer_Type,
            Entry_Method,
            Mtm_Event_Id,
            Question_Id,
            Ed.Connected_C,
            Ed.Connected_V_To_C
     From      Gkdw.Mtm_Survey_Data Mtm
            Left Join
               Gkdw.Event_Dim Ed
            On Mtm.External_Class_Id = Ed.Event_Id;



