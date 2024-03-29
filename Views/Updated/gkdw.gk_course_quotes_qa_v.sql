


Create Or Alter View Hold.Gk_Course_Quotes_Qa_V
(
   Createdate,
   Opportunityid,
   Evxcourseid,
   Coursecode,
   Shortname,
   Numattendees,
   Listprice,
   Stage,
   Description,
   Cust_Id,
   Cust_Name,
   Acct_Name,
   Accountmanagerid,
   Username,
   Title,
   Department,
   Deliverycountry
)
As
   Select   Qo.Createdate,
            Qo.Opportunityid,
            Qo.Evxcourseid,
            C.Course_Code Coursecode,
            C.Short_Name Shortname,
            Qo.Numattendees,
            Qo.Listprice,
            O.Stage,
            O.Description,
            Cd.Cust_Id,
            Cd.Cust_Name,
            Cd.Acct_Name,
            O.Accountmanagerid,
            Ui.Username,
            Ui.Title,
            Ui.Department,
            Upper (Qo.Deliverycountry) Deliverycountry
     From   Base.Qg_Oppcoursesqa Qo,
            Base.Opportunityqa O,
            Base.Opportunity_Contactqa Oc,
            Cust_Dim Cd,
            Course_Dim C,
            Base.Userinfoqa Ui
    Where       Qo.Opportunityid = O.Opportunityid
            And O.Opportunityid = Oc.Opportunityid
            And Oc.Contactid = Cd.Cust_Id
            And Qo.Evxcourseid = C.Course_Id
            And Upper (Qo.Deliverycountry) = C.Country
            And O.Accountmanagerid = Ui.Userid
            And Qo.Createdate >= Cast(Getutcdate() As Date) - 60
            And O.Status = 'Open'
            And C.Ch_Num = '10';



