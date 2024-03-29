


Create Or Alter View Hold.Gk_Cancelled_Events_V
(
   Event_Id,
   Course_Code,
   Start_Date,
   End_Date,
   Facility_Region_Metro,
   City,
   State,
   Cancel_Date,
   Cancel_Reason,
   Enroll_Ct
)
As
     Select   E.Event_Id,
              Course_Code,
              Start_Date,
              End_Date,
              Facility_Region_Metro,
              City,
              State,
              Cancel_Date,
              Cancel_Reason,
              O.Enroll_Ct
       From      Gkdw.Event_Dim E
              Left Outer Join
                 (  Select   Event_Id, Count (Distinct Enroll_Id) Enroll_Ct
                      From   Gkdw.Order_Fact
                     Where   Book_Amt >= 0
                  Group By   Event_Id) O
              On E.Event_Id = O.Event_Id
      Where   Status = 'Cancelled'
   ;



