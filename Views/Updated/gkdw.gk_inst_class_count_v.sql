


Create Or Alter View Hold.Gk_Inst_Class_Count_V
(
   Dim_Year,
   Dim_Week,
   Contactid,
   Metro_Level,
   Class_Week_Cnt
)
As
     Select   Dim_Year,
              Dim_Week,
              Ie.Contactid,
              Max (Im.Metro_Level) Metro_Level,
              1 Class_Week_Cnt
       From               Gkdw.Instructor_Event_V Ie
                       Inner Join
                          Gkdw.Event_Dim Ed
                       On Ie.Evxeventid = Ed.Event_Id
                    Inner Join
                       Gkdw.Time_Dim Td1
                    On Ed.Start_Date = Td1.Dim_Date
                 Left Outer Join
                    Rmsdw.Rms_Instructor Ri
                 On Ie.Contactid = Ri.Slx_Contact_Id
              Left Outer Join
                 Rmsdw.Rms_Instructor_Metro Im
              On Ri.Rms_Instructor_Id = Im.Rms_Instructor_Id
                 And Ed.Facility_Region_Metro = Im.Metro_Code
      Where   Ie.Feecode = 'Ins'
   Group By   Dim_Year, Dim_Week, Ie.Contactid;



