


Create Or Alter View Hold.Gk_Event_Schedule_V
(
   Evxeventid,
   Startdate,
   Enddate,
   Coursecode,
   Eventstatus,
   Status,
   Schedule_Id
)
As
   Select   Ev.Evxeventid,
            Ev.Startdate,
            Ev.Enddate,
            Ev.Coursecode,
            Ev.Eventstatus,
            S.[Status] Status,
            S.[Id] Schedule_Id
     From      Base.Evxevent Ev
            Inner Join
               Base.Rms_Schedule S
            On Ev.Evxeventid = S.[Slx_Id]
    Where   Ev.Eventstatus <> S.[Status] And Ev.Startdate > Cast(Getutcdate() As Date);



