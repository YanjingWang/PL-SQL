


Create Or Alter View Hold.Gk_Open_Event_Courses
(
   Course_Code,
   Code,
   Country,
   Course_Name,
   List_Price,
   Duration_Days,
   Course_Pl,
   Course_Type,
   Course_Mod
)
As
     Select   Distinct Cd.Course_Code,
                       Substring(Cd.Course_Code, 1,  4) Code,
                       Cd.Country,
                       Cd.Course_Name,
                       Cd.List_Price,
                       Cd.Duration_Days,
                       Cd.Course_Pl,
                       Cd.Course_Type,
                       Cd.Course_Mod
       --Chr(9)||'<Course>'||Chr(10)||
       --Chr(9)||Chr(9)||'<Code>'||Cd.Course_Code||'</Code>'||Chr(10)||
       --Chr(9)||Chr(9)||'<Title>'||Cd.Course_Name||'</Title>'||Chr(10)||
       --Chr(9)||Chr(9)||'<Listprice>'||Cd.List_Price||'</Listprice>'||Chr(10)||
       --Chr(9)||Chr(9)||'<Durationdays>'||Cd.Duration_Days||'</Durationdays>'||Chr(10)||
       --Chr(9)||'</Course>'||Chr(10) Xml_Line
       From      Gkdw.Course_Dim Cd
              Inner Join
                 Gkdw.Event_Dim Ed
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where       Ed.Start_Date >= Cast(Getutcdate() As Date)
              And Ed.Status <> 'Cancelled'
              And Cd.Ch_Num <> 20
   ;



