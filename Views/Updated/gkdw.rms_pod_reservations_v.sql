


Create Or Alter View Hold.Rms_Pod_Reservations_V
(
   Pod_Name,
   Pod_Reservation_Type,
   Eventstart,
   Eventend,
   Country,
   Event_Status,
   Pod_Count,
   Event_Comment,
   Due_Date
)
As
     Select   Pod_Name,
              Case Lab_Date_Type
                 When 1 Then 'Lab Maintenance Work'
                 When 2 Then 'Instructor Preparation'
                 When 3 Then 'Third Party Booking'
                 When 4 Then 'Reservation'
                 Else 'N/A'
              End
                 Pod_Reservation_Type,
              Eventstart,
              Eventend,
              Country,
              Event_Status,
              Count (Distinct Pod_Id) Pod_Count,
              Event_Comment,
              Due_Date
       From   Gkdw.Rms_Pod_Labs_Mv
   Group By   Pod_Name,
              Lab_Date_Type,
              Eventstart,
              Eventend,
              Country,
              Event_Status,
              Event_Comment,
              Due_Date;









