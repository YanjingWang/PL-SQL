


Create Or Alter View Hold.Gk_Enterprise_Pipeline_V
(
   Opportunityid,
   Createdate,
   Username,
   User_Manager,
   Sales_Group,
   Description,
   Account,
   Estimatedclose,
   Salespotential,
   Closeprobability,
   Opp_Status,
   Opp_Create_Date,
   Modifydate,
   Salesprocess_Type,
   Stage,
   Coursetype,
   Coursecode,
   Coursename,
   Numattendees,
   Nettprice,
   Potentialclosedate,
   Curr_Idr_Status,
   Program_Manager,
   Managed_Prog_Id,
   Curr_Fdc_Status,
   Reqdeliverydate,
   Submitdate,
   Evxeventid,
   Eventname,
   Eventstatus,
   Eventtype,
   Event_Coursecode,
   Startdate,
   Enddate,
   Eventlocationdesc,
   Event_Rev_Amt
)
As
     Select   A1.Opportunityid,
              A1.Createdate,
              Ui1.Username,
              Um.Username User_Manager,
              Ui1.Department Sales_Group,
              A1.Description,
              A2.Account,
              A1.Estimatedclose,
              A1.Salespotential,
              Isnull(A1.Closeprobability, 0) / 100 Closeprobability,
              A1.Status Opp_Status,
              A1.Createdate Opp_Create_Date,
              A1.Modifydate,
              A4.Name Salesprocess_Type,
              A1.Stage,
              So.Coursetype,
              Case
                 When Ec.Coursecode Is Null
                 Then
                    So.Product_Line + ' ' + So.Ns_Course_Desc_Disp
                 Else
                    Ec.Coursecode
              End
                 Coursecode,
              Case
                 When Ec.Coursename Is Null And A5.Nettprice Is Not Null
                 Then
                    So.Description
                 Else
                    Ec.Coursename
              End
                 Coursename,
              So.Numattendees,
              So.Nettprice Nettprice,
              A5.Potentialclosedate,
              So.Curr_Idr_Status,
              Idr.Program_Manager,
              Idr.Managed_Prog_Id,
              Idr.Curr_Fdc_Status,
              A5.Reqdeliverydate Reqdeliverydate,
              Fdc.Submitdate,
              Ev.Evxeventid,
              Ev.Eventname,
              Ev.Eventstatus,
              Ev.Eventtype,
              Ev.Coursecode Event_Coursecode,
              Ev.Startdate,
              Ev.Enddate,
              Ev.Eventlocationdesc,
              Sum (F.Book_Amt) Event_Rev_Amt
       From                                          Base.Opportunity A1
                                                  Inner Join
                                                     Base.Userinfo Ui1
                                                  On A1.Accountmanagerid =
                                                        Ui1.Userid
                                               Inner Join
                                                  Base.Usersecurity Us
                                               On Ui1.Userid = Us.Userid
                                            Inner Join
                                               Base.Userinfo Um
                                            On Us.Managerid = Um.Userid
                                         Inner Join
                                            Base.Account A2
                                         On A1.Accountid = A2.Accountid
                                      Left Outer Join
                                         Base.Qg_Account A3
                                      On A2.Accountid = A3.Accountid
                                   Left Outer Join
                                      Base.Qg_Oppcourses A5
                                   On A1.Opportunityid = A5.Opportunityid
                                Left Outer Join
                                   Base.Gk_Sales_Opportunity So
                                On A5.Gk_Sales_Opportunityid =
                                      So.Gk_Sales_Opportunityid
                             Left Outer Join
                                Base.Evxcourse Ec
                             On So.Evxcourseid = Ec.Evxcourseid
                          Left Outer Join
                             Base.Gk_Onsitereq_Idr Idr
                          On So.Current_Idr = Idr.Gk_Onsitereq_Idrid
                       Left Outer Join
                          Base.Gk_Onsitereq_Fdc Fdc
                       On Idr.Current_Fdc = Fdc.Gk_Onsitereq_Fdcid
                    Left Outer Join
                       Base.Evxevent Ev
                    On So.Gk_Sales_Opportunityid = Ev.Opportunityid
                 Left Outer Join
                    Base.Salesprocesses A4
                 On A1.Opportunityid = A4.Entityid
              Left Outer Join
                 Gkdw.Order_Fact F
              On Ev.Evxeventid = F.Event_Id
      Where   A1.Createdate >= '03-Aug-2009'
              And Upper (Ui1.Department) Like '%Enterprise%'
   --   And A1.Status = 'Open'
   --   And A1.Accountmanagerid = 'U6uj9a00002y'
   Group By   A1.Opportunityid,
              Ui1.Username,
              Um.Username,
              Ui1.Department,
              A1.Description,
              A2.Account,
              A1.Estimatedclose,
              A1.Salespotential,
              Isnull(A1.Closeprobability, 0) / 100,
              A1.Status,
              A1.Createdate,
              A1.Modifydate,
              A4.Name,
              A1.Stage,
              So.Coursetype,
              Case
                 When Ec.Coursecode Is Null
                 Then
                    So.Product_Line + ' ' + So.Ns_Course_Desc_Disp
                 Else
                    Ec.Coursecode
              End,
              Case
                 When Ec.Coursename Is Null And A5.Nettprice Is Not Null
                 Then
                    So.Description
                 Else
                    Ec.Coursename
              End,
              So.Numattendees,
              So.Nettprice,
              A5.Potentialclosedate,
              So.Curr_Idr_Status,
              Idr.Program_Manager,
              Idr.Managed_Prog_Id,
              Idr.Curr_Fdc_Status,
              A5.Reqdeliverydate,
              Fdc.Submitdate,
              Ev.Evxeventid,
              Ev.Eventname,
              Ev.Eventstatus,
              Ev.Eventtype,
              Ev.Coursecode,
              Ev.Startdate,
              Ev.Enddate,
              Ev.Eventlocationdesc
   Union
     Select   A1.Opportunityid,
              A1.Createdate,
              Ui1.Username,
              Um.Username User_Manager,
              Ui1.Department Sales_Group,
              A1.Description,
              A2.Account,
              A1.Estimatedclose,
              A1.Salespotential,
              Isnull(A1.Closeprobability, 0) / 100 Closeprobability,
              A1.Status Opp_Status,
              A1.Createdate,
              A1.Modifydate,
              Null Salesprocess_Type,
              A1.Stage,
              Cd.Course_Type,
              Cd.Course_Code,
              Cd.Course_Name,
              Null Numattendeees,
              Null Nettprice,
              Null Potentialclosedate,
              Null Curr_Idr_Status,
              Null Program_Manager,
              Null Managed_Prog_Id,
              Null Curr_Fdc_Status,
              Null Reqdeliverydate,
              Null Submitdate,
              Ed.Event_Id Evxeventid,
              Ed.Event_Name Eventname,
              Ed.Status Eventstatus,
              Ed.Event_Type Eventtype,
              Ed.Course_Code Coursecode,
              Ed.Start_Date Startdate,
              Ed.End_Date Enddate,
              Ed.Location_Name Eventlocationdesc,
              Sum (F.Book_Amt) Event_Rev_Amt
       From                        Base.Opportunity A1
                                Inner Join
                                   Base.Userinfo Ui1
                                On A1.Accountmanagerid = Ui1.Userid
                             Inner Join
                                Base.Usersecurity Us
                             On Ui1.Userid = Us.Userid
                          Inner Join
                             Base.Userinfo Um
                          On Us.Managerid = Um.Userid
                       Inner Join
                          Base.Account A2
                       On A1.Accountid = A2.Accountid
                    Inner Join
                       Gkdw.Order_Fact F
                    On A1.Opportunityid = F.Opportunity_Id
                 Inner Join
                    Gkdw.Event_Dim Ed
                 On F.Event_Id = Ed.Event_Id
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   A1.Createdate >= '03-Aug-2009'       --   And A1.Status = 'Open'
                                        --   And Fee_Type In ('Primary','Gsa')
              And Upper (Ui1.Department) Like '%Enterprise%'
   Group By   A1.Opportunityid,
              Ui1.Username,
              Um.Username,
              Ui1.Department,
              A1.Description,
              A2.Account,
              A1.Estimatedclose,
              A1.Salespotential,
              Isnull(A1.Closeprobability, 0) / 100,
              A1.Status,
              A1.Createdate,
              A1.Modifydate,
              A1.Stage,
              Cd.Course_Type,
              Cd.Course_Code,
              Cd.Course_Name,
              Ed.Event_Id,
              Ed.Event_Name,
              Ed.Status,
              Ed.Event_Type,
              Ed.Course_Code,
              Ed.Start_Date,
              Ed.End_Date,
              Ed.Location_Name
   Union
     Select   A1.Opportunityid,
              A1.Createdate,
              Ui1.Username,
              Um.Username User_Manager,
              Ui1.Department Sales_Group,
              A1.Description,
              A2.Account,
              A1.Estimatedclose,
              A1.Salespotential,
              Isnull(A1.Closeprobability, 0) / 100 Closeprobability,
              A1.Status Opp_Status,
              A1.Createdate,
              A1.Modifydate,
              Null Salesprocess_Type,
              A1.Stage,
              F.Record_Type,
              Pd.Prod_Num,
              Pd.Prod_Name,
              Null Numattendeees,
              Null Nettprice,
              Null Potentialclosedate,
              Null Curr_Idr_Status,
              Null Program_Manager,
              Null Managed_Prog_Id,
              Null Curr_Fdc_Status,
              Null Reqdeliverydate,
              Null Submitdate,
              F.Product_Id,
              Pd.Prod_Name,
              F.So_Status,
              F.Record_Type,
              Pd.Prod_Num,
              Trunc (F.Creation_Date),
              Trunc (F.Creation_Date),
              'Product',
              Sum (F.Book_Amt) Event_Rev_Amt
       From                     Base.Opportunity A1
                             Inner Join
                                Base.Userinfo Ui1
                             On A1.Accountmanagerid = Ui1.Userid
                          Inner Join
                             Base.Usersecurity Us
                          On Ui1.Userid = Us.Userid
                       Inner Join
                          Base.Userinfo Um
                       On Us.Managerid = Um.Userid
                    Inner Join
                       Base.Account A2
                    On A1.Accountid = A2.Accountid
                 Inner Join
                    Gkdw.Sales_Order_Fact F
                 On A1.Opportunityid = F.Opportunity_Id
              Inner Join
                 Gkdw.Product_Dim Pd
              On F.Product_Id = Pd.Product_Id
      Where   A1.Createdate >= '03-Aug-2009'       --   And A1.Status = 'Open'
              And Upper (Ui1.Department) Like '%Enterprise%'
   Group By   A1.Opportunityid,
              Ui1.Username,
              Um.Username,
              Ui1.Department,
              A1.Description,
              A2.Account,
              A1.Estimatedclose,
              A1.Salespotential,
              Isnull(A1.Closeprobability, 0) / 100,
              A1.Status,
              A1.Createdate,
              A1.Modifydate,
              A1.Stage,
              F.Product_Id,
              Pd.Prod_Name,
              F.So_Status,
              F.Record_Type,
              Pd.Prod_Num,
              Trunc (F.Creation_Date)
   ;



