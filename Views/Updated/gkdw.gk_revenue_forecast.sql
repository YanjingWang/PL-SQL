


Create Or Alter View Hold.Gk_Revenue_Forecast
(
   Event_Id,
   Event_Desc,
   Course_Id,
   Course_Code,
   Start_Date,
   End_Date,
   Facility_Code,
   Metro_Area,
   Zipcode,
   Ops_Country,
   Internalfacility,
   Capacity,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Le_Num,
   Fe_Num,
   Ch_Num,
   Md_Num,
   Pl_Num,
   Act_Num,
   Enroll_Status,
   Enroll_Cnt,
   Book_Amt
)
As
     Select   Ed.Event_Id,
                 Ed.Course_Id
              + '-'
              + Facility_Region_Metro
              + '-'
              + Format(Start_Date, 'Yymmdd')
                 Event_Desc,
              Ed.Course_Id,
              Ed.Course_Code,
              Start_Date,
              End_Date,
              Facility_Code,
              Facility_Region_Metro Metro_Area,
              Ed.Zipcode,
              Ops_Country,
              Internalfacility,
              Ed.Capacity,
              Cd.Course_Ch,
              Cd.Course_Mod,
              Cd.Course_Pl,
              Le_Num,
              Fe_Num,
              Ch_Num,
              Md_Num,
              Pl_Num,
              Act_Num,
              F.Enroll_Status,
              Count (Enroll_Id) Enroll_Cnt,
              Sum (Book_Amt) Book_Amt
       From         Gkdw.Event_Dim Ed
                 Left Outer Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Left Outer Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Ed.Status != 'Cancelled'
              And F.Enroll_Status != 'Cancelled'
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '10'
   Group By   Ed.Event_Id,
                 Ed.Course_Id
              + '-'
              + Facility_Region_Metro
              + '-'
              + Format(Start_Date, 'Yymmdd'),
              Ed.Course_Id,
              Ed.Course_Code,
              Start_Date,
              End_Date,
              Facility_Code,
              Facility_Region_Metro,
              Ed.Zipcode,
              Ops_Country,
              Internalfacility,
              Ed.Capacity,
              Cd.Course_Ch,
              Cd.Course_Mod,
              Cd.Course_Pl,
              Le_Num,
              Fe_Num,
              Ch_Num,
              Md_Num,
              Pl_Num,
              Act_Num,
              F.Enroll_Status;



