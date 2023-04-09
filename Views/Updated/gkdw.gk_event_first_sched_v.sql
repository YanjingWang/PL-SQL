


Create Or Alter View Hold.Gk_Event_First_Sched_V
(
   Ops_Country,
   Course_Id,
   Course_Code,
   First_Sched_Date
)
As
     Select   Ops_Country,
              Course_Id,
              Course_Code,
              Min (Start_Date) First_Sched_Date
       From   Gkdw.Event_Dim Ed
      Where   Gkdw_Source = 'Slxdw'
   Group By   Ops_Country, Course_Id, Course_Code;



