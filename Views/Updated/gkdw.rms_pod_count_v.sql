


Create Or Alter View Hold.Rms_Pod_Count_V
(
   Slx_Event_Id,
   Pod_Name,
   Event_Comment,
   Pod_Count
)
As
     Select   Slx_Event_Id,
              Pod_Name,
              Event_Comment,
              Count (Distinct Pod_Id) Pod_Count
       From   Gkdw.Rms_Event_Pod_Mv
   Group By   Slx_Event_Id, Pod_Name, Event_Comment;









