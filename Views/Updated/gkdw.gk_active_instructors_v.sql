


Create Or Alter View Hold.Gk_Active_Instructors_V
(
   Instructor_Id,
   Acct_Type
)
As
   Select   F.[Slx_Contact_Id] Instructor_Id, 'Internal' Acct_Type
     From   Base.Rms_Employee_Func Ef,
            Base.Rms_Instructor_Func F,
            Base.Rms_Person Pr
    Where       Ef.[Person] = F.[Person]
            And Ef.[Person] = Pr.[Id]
            And Pr.[Activ] = 'Yes'
   Union
   Select   F.[Slx_Contact_Id], 'External'
     From   Base.Rms_Instructor_Func Ef,
            Base.Rms_Instructor_Func F,
            Base.Rms_Person Pr
    Where       Ef.[Person] = F.[Person]
            And Ef.[Person] = Pr.[Id]
            And Pr.[Activ] = 'Yes';



