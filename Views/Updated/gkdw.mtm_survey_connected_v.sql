


Create Or Alter View Hold.Mtm_Survey_Connected_V
(
   Course_Pl,
   Course_Code,
   Event_Id,
   Connected_C,
   Connected_V_To_C,
   End_Date,
   Eval_Submitted_Id,
   Question_Category,
   Variable_Name,
   Answer,
   Answer_Type
)
As
   Select   Cd.Course_Pl,
            Cd.Course_Code,
            Ed.Event_Id,
            Ed.Connected_C,
            Ed.Connected_V_To_C,
            Ed.End_Date,
            Mtm.Eval_Submitted_Id,
            Mtm.Question_Category,
            Mtmx.Variable_Name,
            Mtm.Answer,
            Mtm.Answer_Type
     --Mtm.*, Mtmx.Variable_Name, Mtmx.Question_Id, Mtmx.Mtm_Category, Mtmx.Mtm_Question
     From            Gkdw.Mtm_Survey_Data Mtm
                  Left Join
                     Gkdw.Event_Dim Ed
                  On Mtm.External_Class_Id = Ed.Event_Id
               Left Join
                  Gkdw.Course_Dim Cd
               On Ed.Course_Id = Cd.Course_Id And Ed.Country = Cd.Country
            Join
               Gkdw.Mtm_Category_Xref Mtmx
            On Mtm.Question_Id = Mtmx.Question_Id
               And Cd.Course_Pl = Upper (Mtmx.Product_Line)
    Where   (Cd.Course_Pl Like 'Microsoft%' Or Cd.Course_Pl Like 'Ibm')
            And Ed.End_Date Between '01-Aug-2013' And '31-Aug-2013';



