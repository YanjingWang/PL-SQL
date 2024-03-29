


Create Or Alter View Hold.Mtm_Survey_Connected_C_V
(
   Dim_Year,
   Dim_Month_Num,
   Country,
   Course_Pl,
   Course_Mod,
   Root_Course_Code,
   Course_Code,
   Short_Name,
   Event_Id,
   Facility_Region_Metro,
   Connected_Flag,
   Connected_V_To_C,
   End_Date,
   Instructor,
   Eval_Submitted_Id,
   Question,
   Question_Id,
   Question_Category,
   Answer,
   Answer_Type
)
As
   Select   Distinct
            Td.Dim_Year,
            Td.Dim_Month_Num,
            Ed.Country,
            Cd.Course_Pl,
            Cd.Course_Mod,
            Substring(Cd.Course_Code, 1,  4) Root_Course_Code,
            Cd.Course_Code,
            Cd.Short_Name,
            Ed.Event_Id,
            Ed.Facility_Region_Metro,
            Case
               When Cd.Course_Mod = 'C-Learning'
               Then
                  Case
                     When Ed.Connected_C = 'Y' Then 'Connected_C'
                     Else 'Non_Connected_C'
                  End
               When Cd.Course_Mod = 'V-Learning'
               Then
                  Case
                     When Ed.Connected_V_To_C Is Not Null Then 'Connected_V'
                     Else 'Non_Connected_V'
                  End
               Else
                  'Na'
            End
               Connected_Flag,
            Ed.Connected_V_To_C,
            Ed.End_Date,
            Ie.Lastname + ' ' + Ie.Firstname Instructor,
            /* Floor(Count( Distinct Mtm.Eval_Submitted_Id )
                        Over (
                           Partition By Cd.Country,
                                        Mtmx.Mtm_Category,
                                        Mtm.Answer
                          -- Order By Mtm.Answer
                        )
                     / Count (
                          Distinct Mtmx.Mtm_Question
                       )
                          Over (
                             Partition By Cd.Country,
                                          Mtm.External_Course_Id,
                                          Mtm.Answer,
                                          Mtmx.Mtm_Category
                              ))
                  Stu_Cnt,
                  */
            Mtm.Eval_Submitted_Id,
            Mtm.Question,
            Mtm.Question_Id,
            Mtm.Question_Category,
            --Mtmx.Variable_Name,
            Mtm.Answer,
            Mtm.Answer_Type
     From                  Gkdw.Mtm_Survey_Data Mtm
                        Left Join
                           Gkdw.Event_Dim Ed
                        On Mtm.External_Class_Id = Ed.Event_Id
                     Left Join
                        Gkdw.Course_Dim Cd
                     On Ed.Course_Id = Cd.Course_Id
                        And Ed.Country = Cd.Country
                  Join
                     Gkdw.Mtm_Category_Xref Mtmx
                  On Mtm.Question_Id = Mtmx.Question_Id
                     And Cd.Course_Pl = Upper (Mtmx.Product_Line)
               Left Join
                  Gkdw.Instructor_Event_V Ie
               On Ed.Event_Id = Ie.Evxeventid And Ie.Feecode = 'Ins'
            Join
               Gkdw.Time_Dim Td
            On Ed.End_Date = Td.Dim_Date
    Where --  (Cd.Course_Pl Like 'Microsoft%' Or Cd.Course_Pl Like 'Ibm')    And
         Mtm.Answer_Type = 'Likert' And Ed.End_Date > '01-Sep-2013' --And '31-Aug-2013';
--;



