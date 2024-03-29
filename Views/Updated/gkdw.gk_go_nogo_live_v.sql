


Create Or Alter View Hold.Gk_Go_Nogo_Live_V
(
   Start_Week,
   Ops_Country,
   Start_Date,
   Event_Id,
   Facility_Region_Metro,
   Facility_Code,
   Course_Code,
   Short_Name,
   Course_Mod,
   Course_Pl,
   Enroll_Cnt,
   Enroll_Amt,
   Go_Nogo_Cnt,
   Go_Nogo_Rev
)
As
     Select   Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0') Start_Week,
              Ed.Ops_Country,
              Ed.Start_Date,
              Ed.Event_Id,
              Ed.Facility_Region_Metro,
              Ed.Facility_Code,
              Cd.Course_Code,
              Cd.Short_Name,
              Cd.Course_Mod,
              Cd.Course_Pl,
              Ec.Enroll_Cnt,
              Ec.Enroll_Amt,
              L.Enroll_Cnt Go_Nogo_Cnt,
              L.Rev_Amt Go_Nogo_Rev
       From   Base.Gk_Event_Enroll_Cnt_V Ec,
                       Event_Dim Ed
                    Inner Join
                       Gkdw.Time_Dim Td
                    On Ed.Start_Date = Td.Dim_Date
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Inner Join
                 Gkdw.Gk_Go_Nogo L
              On Ed.Event_Id = L.Event_Id
      Where       Ec.Event_Id = Ed.Event_Id
              And Ec.Enroll_Cnt <> L.Enroll_Cnt
              And Cd.Ch_Num = '10'
   ;



