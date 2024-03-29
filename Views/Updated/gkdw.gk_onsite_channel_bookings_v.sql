


Create Or Alter View Hold.Gk_Onsite_Channel_Bookings_V
(
   Enroll_Id,
   Cust_Id,
   Book_Amt,
   Sales_Rep,
   Account_Name,
   Partner_Key_Code,
   Event_Id,
   Start_Date,
   End_Date,
   Course_Code,
   Dim_Year,
   Dim_Period_Name,
   Course_Ch
)
As
   Select   F.Enroll_Id,
            F.Cust_Id,
            F.Book_Amt,
            Channel_Manager Sales_Rep,
            Partner_Name Account_Name,
            Cp.Partner_Key_Code,
            Ed.Event_Id,
            Ed.Start_Date,
            Ed.End_Date,
            Cd.Course_Code,
            Td.Dim_Year,
            Td.Dim_Period_Name,
            Cd.Course_Ch
     From               Gkdw.Order_Fact F
                     Inner Join
                        Gkdw.Event_Dim Ed
                     On F.Event_Id = Ed.Event_Id
                  Inner Join
                     Gkdw.Time_Dim Td
                  On Ed.Start_Date = Td.Dim_Date
               Inner Join
                  Gkdw.Course_Dim Cd
               On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
            Inner Join
               Gkdw.Gk_Channel_Partner Cp
            On F.Keycode = Cp.Partner_Key_Code
    Where   F.Enroll_Status In ('Confirmed', 'Attended')
   --And Ed.Start_Date Between '01-Jan-2011' And '29-Apr-2011'
   Union
   Select   F.Enroll_Id,
            F.Cust_Id,
            F.Book_Amt,
            F.Salesperson,
            C.Acct_Name,
            '',
            Ed.Event_Id,
            Ed.Start_Date,
            Ed.End_Date,
            Cd.Course_Code,
            Td.Dim_Year,
            Td.Dim_Period_Name,
            Cd.Course_Ch
     From               Gkdw.Order_Fact F
                     Inner Join
                        Gkdw.Cust_Dim C
                     On F.Cust_Id = C.Cust_Id
                  Inner Join
                     Gkdw.Event_Dim Ed
                  On F.Event_Id = Ed.Event_Id
               Inner Join
                  Gkdw.Time_Dim Td
               On Ed.Start_Date = Td.Dim_Date
            Inner Join
               Gkdw.Course_Dim Cd
            On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
    Where   F.Enroll_Status In ('Confirmed', 'Attended')
            --And Ed.Start_Date Between '01-Jan-2011' And '29-Apr-2011'
            And (Cd.Ch_Num = '20'
                 Or (Cd.Ch_Num Is Null And Ed.Event_Type = 'Onsite'))
            And F.Book_Amt > 0;



