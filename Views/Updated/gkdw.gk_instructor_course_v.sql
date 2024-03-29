


Create Or Alter View Hold.Gk_Instructor_Course_V
(
   Ops_Country,
   Contactid,
   Course_Id,
   Course_Code,
   Event_Modality,
   Short_Name,
   Event_Prod_Line,
   Course_Cnt,
   Connected_Cnt,
   Min_Event_Date
)
As
     Select   Ed.Ops_Country,
              Ie.Contactid,
              Ed.Course_Id,
              Ed.Course_Code,
              Ed.Event_Modality,
              Cd.Short_Name,
              Ed.Event_Prod_Line,
              Count ( * ) Course_Cnt,
              Sum (Case When Ed.Connected_C = 'Y' Then 1 Else 0 End)
                 Connected_Cnt,
              Min (Ed.Start_Date) Min_Event_Date
       From         Gkdw.Instructor_Event_V Ie
                 Inner Join
                    Gkdw.Event_Dim Ed
                 On Ie.Evxeventid = Ed.Event_Id
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Ed.Status != 'Cancelled' And Substring(Ie.Feecode, 1,  3) = 'Ins'
   Group By   Ed.Ops_Country,
              Ie.Contactid,
              Ed.Course_Id,
              Ed.Course_Code,
              Ed.Event_Prod_Line,
              Ed.Event_Modality,
              Cd.Short_Name
   ;



