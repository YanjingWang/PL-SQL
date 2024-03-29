


Create Or Alter View Hold.Gk_Instructor_Off_Podium_V
(
   Rms_Instructor_Id,
   Instructor_Id,
   Rms_Schedule_Id,
   Inst_Status,
   Inst_Comment,
   Start_Date,
   End_Date
)
As
     Select   [Instructor] Rms_Instructor_Id,
              F.[Slx_Contact_Id] Instructor_Id,
              [Schedule] Rms_Schedule_Id,
              Vt.[Art] Inst_Status,
              V.[Comment] Inst_Comment,
              Min ([Day_Value]) Start_Date,
              Max ([Day_Value]) End_Date
       From         Base.Rms_Date_Value V
                 Inner Join
                    Base.Rms_Date_Value_Type Vt
                 On V.[Art] = Vt.[Id]
              Inner Join
                 Base.Rms_Instructor_Func F
              On V.[Instructor] = F.[Id]
      --Where V.[Art] In (2,3,4,5,6,7,8,9,10,11,13,14,15)
      Where   [Day_Value] >= '2012-01-01'
   Group By   [Instructor],
              F.[Slx_Contact_Id],
              [Schedule],
              Vt.[Art],
              V.[Comment]
   ;



