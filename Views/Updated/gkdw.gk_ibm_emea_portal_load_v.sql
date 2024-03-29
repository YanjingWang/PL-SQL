


Create Or Alter View Hold.Gk_Ibm_Emea_Portal_Load_V
(
   Event_Schedule_Id,
   Course_Code,
   Event_Id,
   Course_Name,
   Ibm_Course_Code,
   Ibm_Ww_Course_Code,
   Start_Date,
   End_Date,
   Start_Time,
   End_Time,
   Timezone,
   City,
   State_Id,
   Country_Id,
   Course_Url,
   Class_Language,
   Delivery_Method,
   Event_Type,
   Partner_Id,
   Active,
   Status,
   Student_Cnt,
   Region_Id
)
As
     Select   S.Classnum + '_' + S.Isoctry Event_Schedule_Id,
              S.Coursecode Course_Code,
              S.Classnum Event_Id,
              Tx.Title Course_Name,
              Tx.Coursecode Ibm_Course_Code,
              Tx.Coursecode Ibm_Ww_Course_Code,
              To_Date (S.Classstartdate, 'Yyyy-Mm-Dd') Start_Date,
              To_Date (S.Classenddate, 'Yyyy-Mm-Dd') End_Date,
              Format(To_Date (S.Classstarttime, 'Hh24:Mi'), 'Hh:Mi:Ss Am')
                 Start_Time,
              Format(To_Date (S.Classendtime, 'Hh24:Mi'), 'Hh:Mi:Ss Am')
                 End_Time,
              S.Timezone,
              Initcap (S.City) City,
              Initcap (S.State) State_Id,
              C.Country_Id,
              S.Courseurl Course_Url,
              Initcap (S.Classlanguage) Class_Language,
              S.Modality Delivery_Method,
              Initcap (S.Eventtype) Event_Type,
              'Par2014051211052205932780' Partner_Id,
              'T' Active,
              Case
                 When Status = 1 Then 'Open'
                 When Status = 2 Then 'Update'
                 When Status = 3 Then 'Complete'
                 When Status = 4 Then 'Cancelled'
              End
                 Status,
              0 Student_Cnt,
              C.Region_Id
       From         Gkdw.Gk_Emea_Ibm_Sched_V S
                 Inner Join
                    Gkdw.Ibm_Tier_Xml Tx
                 On S.Coursecode = Tx.Coursecode
              Inner Join
                 Countries@Part_Portals C
              On Upper (S.Isoctry) = C.Iso_Code
   ;



