


Create Or Alter View Hold.Gk_Gtr_Daily_Pull_V
(
   Ops_Country,
   Start_Week,
   Start_Date,
   Event_Id,
   Metro,
   Facility_Code,
   Course_Code,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Course_Type,
   Inst_Type,
   Inst_Name,
   Revenue,
   Total_Cost,
   Enroll_Cnt,
   Margin,
   Gtr_Create_Date,
   Gtr_Level
)
As
   Select   Ug.Ops_Country,
            Ug.Start_Week,
            Ug.Start_Date,
            Ug.Event_Id,
            Ug.Metro,
            Ug.Facility_Code,
            Ug.Course_Code,
            Ug.Course_Ch,
            Ug.Course_Mod,
            Ug.Course_Pl,
            Ug.Course_Type,
            Ug.Inst_Type,
            Ug.Inst_Name,
            Ug.Revenue,
            Ug.Total_Cost,
            Ug.Enroll_Cnt,
            Ug.Margin,
            Getutcdate() Gtr_Create_Date,
            Ug.Gtr_Level
     From      Gkdw.Gk_Us_Gtr_V Ug
            Inner Join
               Gkdw.Event_Dim Ed
            On Ug.Event_Id = Ed.Event_Id
    Where   Not Exists (Select   1
                          From   Gkdw.Gk_Gtr_Events E
                         Where   Ug.Event_Id = E.Event_Id)
            And Ed.Event_Id Not In
                     ('Q6uj9apxyiy2',
                      'Q6uj9apxyh9h',
                      'Q6uj9apxyh9g',
                      'Q6uj9apxyh9e',
                      'Q6uj9apxyh9d',
                      'Q6uj9apxyh9b',
                      'Q6uj9apxyh99',
                      'Q6uj9apxyh97',
                      'Q6uj9apxyh90',
                      'Q6uj9apxyh8z',
                      'Q6uj9apxyh8x',
                      'Q6uj9apxyh8w',
                      'Q6uj9apxyh8u',
                      'Q6uj9apxyhho',
                      'Q6uj9apxyh8p',
                      'Q6uj9apxyh8m',
                      'Q6uj9apxyh8k',
                      'Q6uj9apxyh8i',
                      'Q6uj9apxyh8h',
                      'Q6uj9apxyh8c',
                      'Q6uj9apxyh8b',
                      'Q6uj9apxyk7d',
                      'Q6uj9apxyk7c')
   Union
   Select   Ed1.Ops_Country,
            G.Start_Week,
            Ed1.Start_Date,
            Ed1.Event_Id,
            G.Metro,
            G.Facility_Code,
            G.Course_Code,
            G.Course_Ch,
            G.Course_Mod,
            G.Course_Pl,
            G.Course_Type,
            G.Inst_Type,
            G.Inst_Name,
            G.Revenue,
            G.Total_Cost,
            G.Enroll_Cnt,
            G.Margin,
            Getutcdate(),
            G.Gtr_Level
     From      Gkdw.Gk_Us_Gtr_V G
            Inner Join
               Gkdw.Event_Dim Ed1
            On     G.Course_Code = Ed1.Course_Code
               And G.Start_Date = Ed1.Start_Date
               And G.Metro = Ed1.Facility_Region_Metro
               And Ed1.Ops_Country = 'Canada'
    Where   Not Exists (Select   1
                          From   Gkdw.Gk_Gtr_Events E
                         Where   Ed1.Event_Id = E.Event_Id)
   --Union
   --Select Ed2.Ops_Country,Td.Dim_Year||'-'||Lpad(Td.Dim_Week,2,0) Start_Week,Ed2.Start_Date,Ed2.Event_Id,Ed2.Facility_Region_Metro,Ed2.Facility_Code,Ed2.Course_Code,
   --       Cd.Course_Ch,Cd.Course_Mod,Cd.Course_Pl,Cd.Course_Type,Null,Null,Book_Amt,Null,Enroll_Cnt,Null,Getutcdate()
   --  From Gkdw.Event_Dim Ed2
   --       Inner Join Gkdw.Course_Dim Cd On Ed2.Course_Id = Cd.Course_Id And Ed2.Ops_Country = Cd.Country
   --       Inner Join Gkdw.Gk_Us_Gtr_Phase_3 P On Ed2.Event_Id = P.Event_Id
   --       Inner Join Gkdw.Time_Dim Td On Ed2.Start_Date = Td.Dim_Date
   -- Where Not Exists (Select 1 From Gkdw.Gk_Us_Gtr_V Ug Where Ed2.Event_Id = Ug.Event_Id)
   --   And Not Exists (Select 1 From Gkdw.Gk_Gtr_Events E Where Ed2.Event_Id = E.Event_Id)
   ;



