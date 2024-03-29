


Create Or Alter View Hold.Gk_Instructor_Event_Rates_V
(
   Ret_Cat,
   Instructor_Id,
   First_Name,
   Last_Name,
   Acct_Id,
   Acct_Name,
   Product_Line,
   Tech_Type,
   Tech_Sub_Type,
   Daily_Rate,
   Boot_Camp_Rate,
   Course_Code,
   Course_Pl,
   Course_Type,
   Course_Subtype,
   Event_Id,
   Start_Date,
   End_Date,
   Status,
   Connected_C,
   Connected_V_To_C,
   Feecode,
   Start_Time,
   End_Time
)
As
   Select   0 Ret_Cat,
            L.Instructor_Id,
            Upper (L.First_Name) First_Name,
            Upper (L.Last_Name) Last_Name,
            L.Acct_Id,
            L.Acct_Name,
            Upper (L.Product_Line) Product_Line,
            Upper (L.Tech_Type) Tech_Type,
            Upper (L.Tech_Sub_Type) Tech_Sub_Type,
            To_Number (Daily_Rate) Daily_Rate,
            To_Number (Boot_Camp_Rate) Boot_Camp_Rate,
            Cd.Course_Code,
            Cd.Course_Pl,
            Upper (Cd.Course_Type) Course_Type,
            Upper (Cd.Subtech_Type1) Course_Subtype,
            Ed.Event_Id,
            Ed.Start_Date,
            Ed.End_Date,
            Ed.Status,
            Ed.Connected_C,
            Ed.Connected_V_To_C,
            Ie.Feecode,
            Ed.Start_Time,
            Ed.End_Time
     From            Gkdw.Instructor_Master_Rates_Load L
                  Inner Join
                     Gkdw.Instructor_Event_V Ie
                  On L.Instructor_Id = Ie.Contactid
               Inner Join
                  Gkdw.Event_Dim Ed
               On Ie.Evxeventid = Ed.Event_Id
            Inner Join
               Gkdw.Course_Dim Cd
            On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
    Where   Ed.Status != 'Cancelled' And L.Course_Code = Cd.Course_Code
   Union
   Select   1 Ret_Cat,
            L.Instructor_Id,
            Upper (L.First_Name) First_Name,
            Upper (L.Last_Name) Last_Name,
            L.Acct_Id,
            L.Acct_Name,
            Upper (L.Product_Line) Product_Line,
            Upper (L.Tech_Type) Tech_Type,
            Upper (L.Tech_Sub_Type) Tech_Sub_Type,
            To_Number (Daily_Rate) Daily_Rate,
            To_Number (Boot_Camp_Rate) Boot_Camp_Rate,
            Cd.Course_Code,
            Cd.Course_Pl,
            Upper (Cd.Course_Type) Course_Type,
            Upper (Cd.Subtech_Type1) Course_Subtype,
            Ed.Event_Id,
            Ed.Start_Date,
            Ed.End_Date,
            Ed.Status,
            Ed.Connected_C,
            Ed.Connected_V_To_C,
            Ie.Feecode,
            Ed.Start_Time,
            Ed.End_Time
     From            Gkdw.Instructor_Master_Rates_Load L
                  Inner Join
                     Gkdw.Instructor_Event_V Ie
                  On L.Instructor_Id = Ie.Contactid
               Inner Join
                  Gkdw.Event_Dim Ed
               On Ie.Evxeventid = Ed.Event_Id
            Inner Join
               Gkdw.Course_Dim Cd
            On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
    Where       Ed.Status != 'Cancelled'
            And Upper (L.Product_Line) = Upper (Cd.Course_Pl)
            And Upper (L.Tech_Type) = Upper (Cd.Course_Type)
            And Upper (L.Tech_Sub_Type) = Upper (Cd.Subtech_Type1)
   Union
   Select   2 Ret_Cat,
            L.Instructor_Id,
            Upper (L.First_Name) First_Name,
            Upper (L.Last_Name) Last_Name,
            L.Acct_Id,
            L.Acct_Name,
            Upper (L.Product_Line) Product_Line,
            Upper (L.Tech_Type) Tech_Type,
            Upper (L.Tech_Sub_Type) Tech_Sub_Type,
            To_Number (Daily_Rate) Daily_Rate,
            To_Number (Boot_Camp_Rate) Boot_Camp_Rate,
            Cd.Course_Code,
            Cd.Course_Pl,
            Upper (Cd.Course_Type) Course_Type,
            Upper (Cd.Subtech_Type1) Course_Subtype,
            Ed.Event_Id,
            Ed.Start_Date,
            Ed.End_Date,
            Ed.Status,
            Ed.Connected_C,
            Ed.Connected_V_To_C,
            Ie.Feecode,
            Ed.Start_Time,
            Ed.End_Time
     From            Gkdw.Instructor_Master_Rates_Load L
                  Inner Join
                     Gkdw.Instructor_Event_V Ie
                  On L.Instructor_Id = Ie.Contactid
               Inner Join
                  Gkdw.Event_Dim Ed
               On Ie.Evxeventid = Ed.Event_Id
            Inner Join
               Gkdw.Course_Dim Cd
            On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
    Where       Ed.Status != 'Cancelled'
            And Upper (L.Product_Line) = Upper (Cd.Course_Pl)
            And Upper (L.Tech_Type) = Upper (Cd.Course_Type)
   Union
   Select   3 Ret_Cat,
            L.Instructor_Id,
            Upper (L.First_Name) First_Name,
            Upper (L.Last_Name) Last_Name,
            L.Acct_Id,
            L.Acct_Name,
            Upper (L.Product_Line) Product_Line,
            Upper (L.Tech_Type) Tech_Type,
            Upper (L.Tech_Sub_Type) Tech_Sub_Type,
            To_Number (Daily_Rate) Daily_Rate,
            To_Number (Boot_Camp_Rate) Boot_Camp_Rate,
            Cd.Course_Code,
            Cd.Course_Pl,
            Upper (Cd.Course_Type) Course_Type,
            Upper (Cd.Subtech_Type1) Course_Subtype,
            Ed.Event_Id,
            Ed.Start_Date,
            Ed.End_Date,
            Ed.Status,
            Ed.Connected_C,
            Ed.Connected_V_To_C,
            Ie.Feecode,
            Ed.Start_Time,
            Ed.End_Time
     From            Gkdw.Instructor_Master_Rates_Load L
                  Inner Join
                     Gkdw.Instructor_Event_V Ie
                  On L.Instructor_Id = Ie.Contactid
               Inner Join
                  Gkdw.Event_Dim Ed
               On Ie.Evxeventid = Ed.Event_Id
            Inner Join
               Gkdw.Course_Dim Cd
            On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
    Where   Ed.Status != 'Cancelled'
            And Upper (L.Product_Line) = Upper (Cd.Course_Pl);



