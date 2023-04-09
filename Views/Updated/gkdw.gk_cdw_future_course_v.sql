


Create Or Alter View Hold.Gk_Cdw_Future_Course_V
(
   Cdw_Group,
   Short_Name,
   Course_Code,
   Ch_Num,
   Md_Num
)
As
     Select   'Ex-Future_Courses_No_Master' Cdw_Group,
              Short_Name,
              Course_Code,
              Ch_Num,
              Md_Num
       From   Gkdw.Gk_Cdw_Course_Except_V
      Where   Start_Date >= Cast(Getutcdate() As Date)
   Group By   Short_Name,
              Course_Code,
              Ch_Num,
              Md_Num;



