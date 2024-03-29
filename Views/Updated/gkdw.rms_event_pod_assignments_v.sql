


Create Or Alter View Hold.Rms_Event_Pod_Assignments_V
(
   Event_Id,
   Course_Code,
   Shortname,
   Start_Date,
   Start_Time,
   End_Date,
   End_Time,
   Timezone,
   Meeting_Days,
   Country,
   Facility_Region_Metro,
   Location_Name,
   Facility_Code,
   Status,
   Pod_Details,
   Currenrollment,
   Maxenrollment,
   Feecode1,
   Instructor1,
   Feecode2,
   Instructor2,
   Feecode3,
   Instructor3,
   Event_Comment
)
As
   Select   E.Event_Id,
            E.Course_Code,
            Shortname,
            Start_Date,
            Start_Time,
            End_Date,
            End_Time,
            'Utc ' + Format(Offset_From_Utc) Timezone,
            Meeting_Days,
            Country,
            Facility_Region_Metro,
            Location_Name,
            Facility_Code,
            Status,
            Pd.Pod_Name + ' : ' + Pd.Pod_Count + 'Pods' Pod_Details,
            Currenrollment,
            Maxenrollment,
            Feecode1,
            Firstname1 + ' ' + Lastname1 Instructor1,
            Feecode2,
            Firstname2 + ' ' + Lastname2 Instructor2,
            Feecode3,
            Firstname3 + ' ' + Lastname3 Instructor3,
            Pd.Event_Comment
     From               Gkdw.Event_Dim E
                     Inner Join
                        Base.Evxevent Se
                     On E.Event_Id = Se.Evxeventid
                  Inner Join
                     Base.Evxcourse C
                  On E.Course_Id = C.Evxcourseid
               Left Join
                  Gkdw.Gk_All_Event_Instr_Mv I
               On E.Event_Id = I.Event_Id
            Inner Join
               Gkdw.Rms_Pod_Count_V Pd
            On E.Event_Id = Pd.Slx_Event_Id;



