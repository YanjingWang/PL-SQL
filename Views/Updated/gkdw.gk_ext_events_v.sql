


Create Or Alter View Hold.Gk_Ext_Events_V
(
   Event_Id,
   Sessions,
   Start_Date,
   End_Date,
   Session_Days,
   Ext_Event
)
As
     Select   Event_Id,
              Count ( * ) Sessions,
              Min (Session_Date) Start_Date,
              Max (Session_Date) End_Date,
              Max (Session_Date) - Min (Session_Date) + 1 Session_Days,
              Case
                 When Max (Session_Date) - Min (Session_Date) + 1 > Count ( * )
                 Then
                    'Y'
                 Else
                    'N'
              End
                 Ext_Event
       From   Gkdw.Gk_Event_Days_Mv
   Group By   Event_Id
     Having   Max (Session_Date) - Min (Session_Date) + 1 > Count ( * );



