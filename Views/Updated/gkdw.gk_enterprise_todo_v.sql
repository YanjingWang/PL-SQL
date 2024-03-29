


Create Or Alter View Hold.Gk_Enterprise_Todo_V
(
   Create_Year,
   Create_Quarter,
   Create_Month_Num,
   Create_Period_Name,
   Create_Week,
   Department,
   Sales_Group,
   Sales_Team,
   User_Manager,
   Username,
   Activityid,
   Activity_Desc,
   Acct_Name,
   Cust_Name,
   Acct_Id,
   Cust_Id,
   Priority,
   Category,
   Result,
   Start_Date,
   Close_Date,
   Create_Date,
   Current_Todo_Cnt,
   Past_Due_Todo_Cnt,
   Completed_Todo_Cnt
)
As
   Select   Td.Dim_Year Create_Year,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Quarter, 2, '0')
               Create_Quarter,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0')
               Create_Month_Num,
            Td.Dim_Period_Name Create_Period_Name,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0') Create_Week,
            Ui1.Department,
            Ui1.Region Sales_Group,
            Ui1.Division Sales_Team,
            Um.Username User_Manager,
            Ui1.Username,
            H.Activityid,
            T.Activity_Desc,
            Cd.Acct_Name,
            Cd.Cust_Name,
            Cd.Acct_Id,
            Cd.Cust_Id,
            H.Priority,
            H.Category,
            H.Result,
            Trunc (H.Startdate) Start_Date,
            Trunc (H.Completeddate) Close_Date,
            Trunc (H.Createdate) Create_Date,
            0 Current_Todo_Cnt,
            0 Past_Due_Todo_Cnt,
            1 Completed_Todo_Cnt
     From                     Base.History H
                           Inner Join
                              Base.Activity_Types T
                           On H.History_Type = T.Activity_Code
                        Inner Join
                           Base.Userinfo Ui1
                        On H.Userid = Ui1.Userid
                     Inner Join
                        Base.Usersecurity Us
                     On Ui1.Userid = Us.Userid
                  Inner Join
                     Base.Userinfo Um
                  On Us.Managerid = Um.Userid
               Inner Join
                  Gkdw.Time_Dim Td
               On Trunc (H.Createdate) = Td.Dim_Date
            Inner Join
               Gkdw.Cust_Dim Cd
            On H.Contactid = Cd.Cust_Id
    Where       History_Type = 262147
            And Upper (Ui1.Department) Like '%Enterprise%' --And Upper(Ui1.Region) Like '%Commercial%' And Ui1.Division = 'Commercial Team 1'
            And Td.Dim_Year >= 2011
   Union
   Select   Td.Dim_Year Create_Year,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Quarter, 2, '0')
               Create_Quarter,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0')
               Create_Month_Num,
            Td.Dim_Period_Name Create_Period_Name,
            Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0') Create_Week,
            Ui1.Department,
            Ui1.Region Sales_Group,
            Ui1.Division Sales_Team,
            Um.Username User_Manager,
            Ui1.Username,
            A.Activityid,
            T.Activity_Desc,
            Cd.Acct_Name,
            Cd.Cust_Name,
            Cd.Acct_Id,
            Cd.Cust_Id,
            A.Priority,
            A.Category,
            ' Open' Result,
            Trunc (A.Startdate) Start_Date,
            Null Close_Date,
            Trunc (A.Createdate) Create_Date,
            Case
               When Trunc (A.Startdate) >= Cast(Getutcdate() As Date) Then 1
               Else 0
            End
               Current_Todo_Cnt,
            Case When Trunc (A.Startdate) < Cast(Getutcdate() As Date) Then 1 Else 0 End
               Past_Due_Todo_Cnt,
            0 Completed_Todo_Cnt
     From                     Base.Activity A
                           Inner Join
                              Base.Activity_Types T
                           On A.Activitytype = T.Activity_Code
                        Inner Join
                           Base.Userinfo Ui1
                        On A.Userid = Ui1.Userid
                     Inner Join
                        Base.Usersecurity Us
                     On Ui1.Userid = Us.Userid
                  Inner Join
                     Base.Userinfo Um
                  On Us.Managerid = Um.Userid
               Inner Join
                  Gkdw.Time_Dim Td
               On Trunc (A.Createdate) = Td.Dim_Date
            Inner Join
               Gkdw.Cust_Dim Cd
            On A.Contactid = Cd.Cust_Id
    Where       A.Activitytype = 262147
            And Upper (Ui1.Department) Like '%Enterprise%'
            --And Upper(Ui1.Region) Like '%Commercial%' And Ui1.Division = 'Commercial Team 1'
            And Td.Dim_Year >= 2011;



