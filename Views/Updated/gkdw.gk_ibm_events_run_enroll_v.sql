


Create Or Alter View Hold.Gk_Ibm_Events_Run_Enroll_V
(
   Ibm_Ww_Course_Code,
   Gk_Course_Code,
   Course_Type,
   Course_Mod,
   Course_Ch,
   Region,
   Country,
   Event_Status,
   Event_Week,
   Event_Month_Num,
   Event_Month,
   Event_Year,
   Dim_Period_Name,
   Event_Id,
   Enroll_Id
)
As
   Select   Cd.Short_Name Ibm_Ww_Course_Code,
            Substring(Cd.Course_Code, 1,  4) Gk_Course_Code,
            Cd.Course_Type,
            Cd.Course_Mod,
            Cd.Course_Ch,
            Case
               When Cd.Country In ('Usa', 'Canada') Then 'Us/Ca'
               Else Cd.Country
            End
               Region,
            Cd.Country,
            Ed.Status Event_Status,
            Td.Dim_Week Event_Week,
            Td.Dim_Month_Num Event_Month_Num,
            Td.Dim_Month Event_Month,
            Td.Dim_Year Event_Year,
            Td.Dim_Period_Name,
            Ed.Event_Id,
            O.Enroll_Id
     --    Count (Distinct Ed.Event_Id) Sessions_Run
     -- Count(Distinct O.Enroll_Id) Student_Cnt
     From            Gkdw.Event_Dim Ed
                  Join
                     Gkdw.Course_Dim Cd
                  On Ed.Country = Cd.Country And Ed.Course_Id = Cd.Course_Id
               Left Join
                  Gkdw.Gk_All_Orders_Mv O
               On Ed.Event_Id = O.Event_Id
                  And (O.Enroll_Status Not In ('Cancelled', 'Did Not Attend')
                       And O.Fee_Type <> 'Ons - Base')
            Join
               Gkdw.Time_Dim Td
            On Td.Dim_Date = Ed.Start_Date
    Where       Cd.Course_Pl = 'Ibm'
            And Ed.Status Not In ('Cancelled')
            And Substring(Cd.Course_Code, 1,  4) Not Like '3639%'
   /*Group By Td.Dim_Year,
         Td.Dim_Period_Name,
         Td.Dim_Month_Num,
         Td.Dim_Month,
         Td.Dim_Week,
         Cd.Short_Name,
         Substring(Cd.Course_Code, 1,  4),
         Cd.Course_Type,
         Cd.Course_Mod,
         Cd.Course_Ch,
         Cd.Country,
         Ed.Status,
         Ed.Event_Id
--            O.Enroll_Id*/
   Union
   /***************Emea Events *************************/
   Select   Ibm_Ww_Course_Code,
            Gk_Course_Code,
            Course_Brand,
            Modality,
            Null,
            'Emea',
            Country,
            Null,
            Td.Dim_Week,
            Td.Dim_Month_Num Event_Month_Mm,
            Td.Dim_Month Event_Month_Mon,
            Td.Dim_Year Event_Year,
            Td.Dim_Period_Name,
            Null,
            Null
     From      Gkdw.Gk_Ibm_Events_Run_Emea_Load Er
            Join
               Gkdw.Time_Dim Td
            On Trunc (Er.Event_Start_Date) = Td.Dim_Date
   ;



