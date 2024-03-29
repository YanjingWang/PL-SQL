


Create Or Alter View Hold.Gk_Course_To_Watch_V
(
   Start_Week,
   Start_Date,
   Event_Id,
   Metro,
   Facility_Code,
   Course_Code,
   Short_Name,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Enroll_Cnt,
   Revenue,
   Total_Cost,
   Margin,
   Margin_Pct,
   Enroll_Id,
   Book_Amt,
   Book_Date,
   Cust_Name,
   Email,
   Acct_Name,
   Sales_Rep,
   Territory,
   Region,
   Region_Rep
)
As
     Select   W.Start_Week,
              W.Start_Date,
              W.Event_Id,
              W.Metro,
              W.Facility_Code,
              W.Course_Code,
              W.Short_Name,
              W.Course_Ch,
              W.Course_Mod,
              W.Course_Pl,
              W.Enroll_Cnt,
              W.Revenue,
              W.Total_Cost,
              W.Revenue - W.Total_Cost Margin,
              W.Margin Margin_Pct,
              F.Enroll_Id,
              F.Book_Amt,
              F.Book_Date,
              Cd.Cust_Name,
              Cd.Email,
              Cd.Acct_Name,
              F.Sales_Rep,
              F.Territory,
              F.Region,
              F.Region_Rep
       From         Gkdw.Gk_Low_Margin_Event_V W
                 Left Outer Join
                    Gkdw.Order_Fact F
                 On W.Event_Id = F.Event_Id And F.Enroll_Status != 'Cancelled'
              Left Outer Join
                 Gkdw.Cust_Dim Cd
              On F.Cust_Id = Cd.Cust_Id
   ;



