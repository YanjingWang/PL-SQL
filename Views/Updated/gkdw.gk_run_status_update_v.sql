


Create Or Alter View Hold.Gk_Run_Status_Update_V
(
   Event_Id,
   Course_Code,
   Enroll_Id,
   Enroll_Status,
   Start_Date,
   Enroll_Date,
   Cancel_Date,
   Enroll_Days,
   Cancel_Days
)
As
   Select   F.Event_Id,
            Ed.Course_Code,
            F.Enroll_Id,
            F.Enroll_Status,
            Ed.Start_Date,
            F.Book_Date Enroll_Date,
            Null Cancel_Date,
            Trunc (Ed.Start_Date - Book_Date) Enroll_Days,
            0 Cancel_Days
     From      Gkdw.Order_Fact F
            Inner Join
               Gkdw.Event_Dim Ed
            On F.Event_Id = Ed.Event_Id
    Where   Enroll_Status != 'Cancelled'
            And Ed.Event_Id In
                     (Select   Event_Id
                        From   Gkdw.Gk_Go_Nogo
                       Where   (   Run_Status Is Null
                                Or Run_Status_3 Is Null
                                Or Run_Status_6 Is Null
                                Or Run_Status_8 Is Null
                                Or Run_Status_10 Is Null)
                               And Start_Date <= Cast(Getutcdate() As Date) + 70
                               And Nested_With Is Null
                               And Ch_Num = 10
                               And Md_Num = 10)
   Union
   Select   F.Event_Id,
            Ed.Course_Code,
            F.Enroll_Id,
            F.Enroll_Status,
            Ed.Start_Date,
            F.Enroll_Date,
            F.Book_Date Cancel_Date,
            Trunc (Ed.Start_Date - Enroll_Date) Enroll_Days,
            Case
               When F.Bill_Status = 'Cancelled'
               Then
                  Trunc (Ed.Start_Date - Book_Date)
               Else
                  0
            End
               Cancel_Days
     From      Gkdw.Order_Fact F
            Inner Join
               Gkdw.Event_Dim Ed
            On F.Event_Id = Ed.Event_Id
    Where   F.Bill_Status = 'Cancelled'
            And Ed.Event_Id In
                     (Select   Event_Id
                        From   Gkdw.Gk_Go_Nogo
                       Where   (   Run_Status Is Null
                                Or Run_Status_3 Is Null
                                Or Run_Status_6 Is Null
                                Or Run_Status_8 Is Null
                                Or Run_Status_10 Is Null)
                               And Start_Date <= Cast(Getutcdate() As Date) + 70
                               And Nested_With Is Null
                               And Ch_Num = 10
                               And Md_Num = 10)
   ;



