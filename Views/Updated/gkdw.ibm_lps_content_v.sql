


Create Or Alter View Hold.Ibm_Lps_Content_V
(
   Course_Name,
   Short_Title,
   Priority,
   Status,
   Assigned_To,
   Rollout_Date,
   Vcel_Upload,
   Course_Code
)
As
     Select   Course_Name,
              Short_Title,
              Priority,
              Status,
              Assigned_To,
              Rollout_Date,
              Vcel_Upload,
              Course_Code
       From   Gkdw.Ibm_Course_Submittal C
      Where   C.R_Id = (Select   Max (C2.R_Id)
                          From   Gkdw.Ibm_Course_Submittal C2
                         Where   C.Short_Title = C2.Short_Title)
   ;



