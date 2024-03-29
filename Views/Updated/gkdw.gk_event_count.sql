


Create Or Alter View Hold.Gk_Event_Count
(
   Metro_Area,
   Start_Date,
   Tc_Rooms,
   Tc_Rooms_W_Pcs,
   Event_Cnt
)
As
     Select   Metro_Area,
              Start_Date,
              Ff.Tc_Rooms,
              Ff.Tc_Rooms_W_Pcs,
              Count (Rf.Event_Id) Event_Cnt
       From         Gkdw.Gk_Revenue_Forecast Rf
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Rf.Start_Date = Td.Dim_Date
              Left Outer Join
                 Fcdw.Fc_Facility Ff
              On Rf.Metro_Area = Ff.Metro_Area
      Where   Metro_Area Is Not Null
   Group By   Metro_Area,
              Start_Date,
              Ff.Tc_Rooms,
              Ff.Tc_Rooms_W_Pcs;



