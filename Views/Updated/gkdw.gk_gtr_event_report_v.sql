


Create Or Alter View Hold.Gk_Gtr_Event_Report_V
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
   Gtr_Revenue,
   Gtr_Enroll_Cnt,
   Gtr_Create_Date,
   Gtr_Level,
   Revenue,
   Rev_Growth,
   Enroll_Cnt,
   Enroll_Growth
)
As
     Select   Ge.Ops_Country,
              Ge.Start_Week,
              Ge.Start_Date,
              Ge.Event_Id,
              Ge.Metro,
              Ge.Facility_Code,
              Ge.Course_Code,
              Ge.Course_Ch,
              Ge.Course_Mod,
              Ge.Course_Pl,
              Ge.Course_Type,
              Ge.Revenue Gtr_Revenue,
              Ge.Enroll_Cnt Gtr_Enroll_Cnt,
              Gtr_Create_Date,
              Gtr_Level,
              Sum (F.Book_Amt) Revenue,
              Case
                 When Ge.Revenue = 0 Then 0
                 Else ( (Sum (F.Book_Amt) / Ge.Revenue) - 1)
              End
                 Rev_Growth,
              Count (F.Enroll_Id) Enroll_Cnt,
              Case
                 When Ge.Enroll_Cnt = 0 Then 0
                 Else ( (Count (F.Enroll_Id) / Ge.Enroll_Cnt) - 1)
              End
                 Enroll_Growth
       From      Gkdw.Gk_Gtr_Events Ge
              Inner Join
                 Gkdw.Order_Fact F
              On Ge.Event_Id = F.Event_Id And F.Enroll_Status != 'Cancelled'
   -- Where Ge.Start_Date <= Cast(Getutcdate() As Date)
   Group By   Ge.Ops_Country,
              Ge.Start_Week,
              Ge.Start_Date,
              Ge.Event_Id,
              Ge.Metro,
              Ge.Facility_Code,
              Ge.Course_Code,
              Ge.Course_Ch,
              Ge.Course_Mod,
              Ge.Course_Pl,
              Ge.Course_Type,
              Ge.Revenue,
              Ge.Enroll_Cnt,
              Gtr_Create_Date,
              Gtr_Level
   ;



