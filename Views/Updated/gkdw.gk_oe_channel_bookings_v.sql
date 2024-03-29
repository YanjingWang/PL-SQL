


Create Or Alter View Hold.Gk_Oe_Channel_Bookings_V
(
   Enroll_Id,
   Cust_Id,
   Book_Amt,
   List_Price,
   Sales_Rep,
   Account_Name,
   Partner_Key_Code,
   Event_Id,
   Start_Date,
   End_Date,
   Course_Code,
   Dim_Year,
   Dim_Period_Name,
   Course_Ch,
   Onsite_Attended,
   Attend_Enrollments,
   Num_Students,
   Base_Students
)
As
   Select   F.Enroll_Id,
            F.Cust_Id,
            F.Book_Amt,
            Cd.List_Price,
            Channel_Manager Sales_Rep,
            Partner_Name Account_Name,
            Cp.Partner_Key_Code,
            Ed.Event_Id,
            Ed.Start_Date,
            Ed.End_Date,
            Cd.Course_Code,
            Td.Dim_Year,
            Td.Dim_Period_Name,
            Cd.Course_Ch,
            Ed.Onsite_Attended,
            Attend_Enrollments,
            Case
               When Ed.Onsite_Attended Is Null
               Then
                  Ed.Attend_Enrollments
               Else
                  Case
                     When Ed.Onsite_Attended > Ed.Attend_Enrollments
                     Then
                        Ed.Onsite_Attended
                     Else
                        Ed.Attend_Enrollments
                  End
            End
               Num_Students,
            Capacity
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
            On Upper (F.Keycode) = Upper (Cp.Partner_Key_Code)
    Where   F.Enroll_Status In ('Confirmed', 'Attended')
   --And Ed.Start_Date Between '01-Jan-2011' And '29-Apr-2011'
   --And Channel_Manager In ('Brendan Duffy','Buck Milliken','Chuck Hernandez','Joe  Buonocore','Matthew Rosenblum')
   Union
   Select   F.Enroll_Id,
            F.Cust_Id,
            F.Book_Amt,
            Cd.List_Price,
            F.Salesperson,
            C.Acct_Name,
            '',
            Ed.Event_Id,
            Ed.Start_Date,
            Ed.End_Date,
            Cd.Course_Code,
            Td.Dim_Year,
            Td.Dim_Period_Name,
            Cd.Course_Ch,
            Ed.Onsite_Attended,
            Attend_Enrollments,
            Case
               When Ed.Onsite_Attended Is Null
               Then
                  Ed.Attend_Enrollments
               Else
                  Case
                     When Ed.Onsite_Attended > Ed.Attend_Enrollments
                     Then
                        Ed.Onsite_Attended
                     Else
                        Ed.Attend_Enrollments
                  End
            End
               Num_Students,
            Case When Pricing_Cap Is Null Then 0 Else Pricing_Cap End
               Base_Students
     From                  Gkdw.Order_Fact F
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
            Left Outer Join
               Base.Evxcoursefee Cf
            On     Cd.Course_Id = Cf.Evxcourseid
               And Cd.Country = Upper (Cf.Pricelist)
               And Feetype = 'Ons - Base'
               And Feeallowuse = 'T'
    Where   F.Enroll_Status In ('Confirmed', 'Attended')
            --And Ed.Start_Date Between '01-Jan-2011' And '29-Apr-2011'
            And (Cd.Ch_Num = '20'
                 Or (Cd.Ch_Num Is Null And Ed.Event_Type = 'Onsite'))
            And F.Book_Amt > 0
   --And F.Salesperson In ('Brendan Duffy','Buck Milliken','Chuck Hernandez','Joe  Bounocore','Matthew Rosenblum')
   ;



