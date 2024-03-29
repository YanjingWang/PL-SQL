Select
  [Evxevent].[Evxeventid] AS [Evxeventid],
  [Evxevent].[Description] AS [Description],
  [Evxevent].[Evxcourseid] AS [Evxcourseid],
  [Evxevent].[Evxfacilityid] AS [Evxfacilityid],
  [Evxevent].[Startdate] AS [Startdate],
  To_Char( [Evxevent].[Starttime], 'Hh:Mi:Ss Am' ) AS [Starttime],
  [Evxevent].[Enddate] AS [Enddate],
  To_Char( [Evxevent].[Endtime] , 'Hh:Mi:Ss Am' ) AS [Endtime],
  [Evxevent].[Eventstatus] AS [Eventstatus],
  [Evxevent].[Facilityname] AS [Facilityname],
  [Evxevent].[Facilityaddress1] AS [Facilityaddress1],
  [Evxevent].[Facilityaddress2] AS [Facilityaddress2],
  [Evxevent].[Facilitycity] AS [Facilitycity],
  Case Upper(Trim( [Evxevent].[Facilitycountry]  ))
When 'Canada' 
Then Null 
When 'Can' 
Then Null 
Else   Upper(Trim([Evxevent].[Facilitystate]))
End [State],
  [Evxevent].[Facilitypostal] AS [Facilitypostal],
  Case Upper(Trim( [Evxevent].[Facilitycountry]  ))
When 'Canada' 
Then Upper(Trim([Evxevent].[Facilitystate]))
When 'Can' 
Then Upper(Trim([Evxevent].[Facilitystate]))
Else   Null
End [Province],
  Upper( Trim( [Evxevent].[Facilitycountry] ) ) AS [Country],
  [Evxevent].[Canceldate] AS [Canceldate],
  Upper( [Evxevent].[Opportunityid] ) AS [Opportunity_Id],
  [Evxevent].[Createdate] AS [Createdate],
  [Evxevent].[Modifydate] AS [Modifydate],
  Isnull([Course_Dim].[Course_Ch], Null) AS [Course_Ch],
  Isnull([Course_Dim].[Course_Mod], Null) AS [Course_Mod],
  Isnull([Course_Dim].[Course_Pl], Null) AS [Course_Pl],
  Isnull([Course_Dim].[Oracle_Item_Id], Null) AS [Oracle_Item_Id],
  Isnull([Course_Dim].[Oracle_Item_Num], Null) AS [Oracle_Item_Num],
  [Evxevent].[Coursecode] AS [Coursecode],
  [Evxevent].[Eventtype] AS [Eventtype],
  [Evxevent].[Cancelreason] AS [Cancelreason],
  [Evxevent].[Maxenrollment] AS [Maxenrollment],
  [Evxevent].[Facilitycode] AS [Facilitycode],
  [Evxevent].[Facilityregionmetro] AS [Facilityregionmetro],
  [Evxevent].[Meetingdescription] AS [Meetingdescription],
  [Qg_Event].[Resellereventid] AS [Resellereventid],
  [Evxevent].[Confirmedenrollment] AS [Confirmedenrollment],
  [Evxevent].[Waitenrollment] AS [Waitenrollment],
  [Evxevent].[Attendedenrollment] AS [Attendedenrollment],
  [Evxevent].[Eventname] AS [Eventname],
  Upper( Trim( [Qg_Event].[Eventcountry]  ) ) AS [Ops_Country],
  [Qg_Event].[Internalfacility] AS [Internalfacility],
  [Evxevent].[Spokenlanguage] AS [Spokenlanguage],
  [Qg_Event].[Plantype] AS [Plantype],
  [Evxevent].[Createuser] AS [Createuser],
  [Evxevent].[Instoolstudattend] AS [Instoolstudattend],
  [Evxevent].[Meetingdays] AS [Meetingdays],
  [Qg_Event].[Managedprogramid] AS [Managedprogramid]
From
    [Base].[Evxevent]  [Evxevent]   
 Left Outer Join   [Base].[Qg_Event]  [Qg_Event] On ( ( ( [Qg_Event].[Evxeventid] = [Evxevent].[Evxeventid] ) ) )
 Left Outer Join   [Course_Dim]  [Course_Dim] On ( ( ( [Course_Dim].[Country] = (Upper( Trim( [Evxevent].[Facilitycountry] ) )) ) ) And ( ( [Course_Dim].[Course_Id] = [Evxevent].[Evxcourseid] ) ) );

