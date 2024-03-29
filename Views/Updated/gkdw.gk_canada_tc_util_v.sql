


Create Or Alter View Hold.Gk_Canada_Tc_Util_V
(
   Dim_Year,
   Dim_Week,
   Facilityname,
   Facilitycode,
   Roomname,
   Mon_Rm,
   Tue_Rm,
   Wed_Rm,
   Thu_Rm,
   Fri_Rm
)
As
   Select   Td1.Dim_Year,
            Td1.Dim_Week,
            Gc.Facilityname,
            Gc.Facilitycode,
            Lr.[Name] Roomname,
            Case
               When '2' Between Format(Gc.Startdate, 'D')
                            And  Format(Gc.Enddate, 'D')
               Then
                     Gc.Coursecode
                  + '-'
                  + Gc.Shortname
                  + '('
                  + Gc.Evxeventid
                  + ') En: '
                  + Gc.Enroll_Cnt
               Else
                  Null
            End
               Mon_Rm,
            Case
               When '3' Between Format(Gc.Startdate, 'D')
                            And  Format(Gc.Enddate, 'D')
               Then
                     Gc.Coursecode
                  + '-'
                  + Gc.Shortname
                  + '('
                  + Gc.Evxeventid
                  + ') En: '
                  + Gc.Enroll_Cnt
               Else
                  Null
            End
               Tue_Rm,
            Case
               When '4' Between Format(Gc.Startdate, 'D')
                            And  Format(Gc.Enddate, 'D')
               Then
                     Gc.Coursecode
                  + '-'
                  + Gc.Shortname
                  + '('
                  + Gc.Evxeventid
                  + ') En: '
                  + Gc.Enroll_Cnt
               Else
                  Null
            End
               Wed_Rm,
            Case
               When '5' Between Format(Gc.Startdate, 'D')
                            And  Format(Gc.Enddate, 'D')
               Then
                     Gc.Coursecode
                  + '-'
                  + Gc.Shortname
                  + '('
                  + Gc.Evxeventid
                  + ') En: '
                  + Gc.Enroll_Cnt
               Else
                  Null
            End
               Thu_Rm,
            Case
               When '6' Between Format(Gc.Startdate, 'D')
                            And  Format(Gc.Enddate, 'D')
               Then
                     Gc.Coursecode
                  + '-'
                  + Gc.Shortname
                  + '('
                  + Gc.Evxeventid
                  + ') En: '
                  + Gc.Enroll_Cnt
               Else
                  Null
            End
               Fri_Rm
     From            Base.Gk_Canada_Tc_V Gc
                  Inner Join
                     Gkdw.Time_Dim Td1
                  On Gc.Startdate = Td1.Dim_Date
               Inner Join
                  Base.Rms_Schedule S
               On Gc.Evxeventid = S.[Slx_Id]
            Inner Join
               Base.Rms_Location_Rooms Lr
            On S.[Location_Rooms] = Lr.[Id]
    Where   Gc.Eventstatus = 'Open'
   Union
   Select   Td1.Dim_Year,
            Td1.Dim_Week,
            Gc.Facilityname,
            Gc.Facilitycode,
            Null Room_Name,
            Case
               When '2' Between Format(Gc.Startdate, 'D')
                            And  Format(Gc.Enddate, 'D')
               Then
                     Gc.Coursecode
                  + '-'
                  + Gc.Shortname
                  + '('
                  + Gc.Evxeventid
                  + ') En: '
                  + Gc.Enroll_Cnt
               Else
                  Null
            End
               Mon_Rm,
            Case
               When '3' Between Format(Gc.Startdate, 'D')
                            And  Format(Gc.Enddate, 'D')
               Then
                     Gc.Coursecode
                  + '-'
                  + Gc.Shortname
                  + '('
                  + Gc.Evxeventid
                  + ') En: '
                  + Gc.Enroll_Cnt
               Else
                  Null
            End
               Tue_Rm,
            Case
               When '4' Between Format(Gc.Startdate, 'D')
                            And  Format(Gc.Enddate, 'D')
               Then
                     Gc.Coursecode
                  + '-'
                  + Gc.Shortname
                  + '('
                  + Gc.Evxeventid
                  + ') En: '
                  + Gc.Enroll_Cnt
               Else
                  Null
            End
               Wed_Rm,
            Case
               When '5' Between Format(Gc.Startdate, 'D')
                            And  Format(Gc.Enddate, 'D')
               Then
                     Gc.Coursecode
                  + '-'
                  + Gc.Shortname
                  + '('
                  + Gc.Evxeventid
                  + ') En: '
                  + Gc.Enroll_Cnt
               Else
                  Null
            End
               Thu_Rm,
            Case
               When '6' Between Format(Gc.Startdate, 'D')
                            And  Format(Gc.Enddate, 'D')
               Then
                     Gc.Coursecode
                  + '-'
                  + Gc.Shortname
                  + '('
                  + Gc.Evxeventid
                  + ') En: '
                  + Gc.Enroll_Cnt
               Else
                  Null
            End
               Fri_Rm
     From         Base.Gk_Canada_Tc_V Gc
               Inner Join
                  Gkdw.Time_Dim Td1
               On Gc.Startdate = Td1.Dim_Date
            Inner Join
               Base.Rms_Schedule S
            On Gc.Evxeventid = S.[Slx_Id]
    Where   S.[Location_Rooms] Is Null And Gc.Eventstatus = 'Open'
   ;



