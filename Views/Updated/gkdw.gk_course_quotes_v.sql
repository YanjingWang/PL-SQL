


Create Or Alter View Hold.Gk_Course_Quotes_V
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
            C.Coursecode,
            C.Shortname,
            Qo.Numattendees,
            Qo.Listprice,
            O.Stage,
            O.Description,
            Cd.Cust_Name,
            Cd.Acct_Name,
            O.Accountmanagerid,
            Ui.Username,
            Ui.Title,
            Ui.Department,
            Upper (Qo.Deliverycountry) Deliverycountry
     From                  Base.Qg_Oppcourses Qo
                        Inner Join
                           Base.Opportunity O
                        On Qo.Opportunityid = O.Opportunityid
                     Inner Join
                        Base.Opportunity_Contact Oc
                     On O.Opportunityid = Oc.Opportunityid
                  Inner Join
                     Base.Evxcourse C
                  On Qo.Evxcourseid = C.Evxcourseid
               Inner Join
                  Gkdw.Cust_Dim Cd
               On Oc.Contactid = Cd.Cust_Id
            Inner Join
               Base.Userinfo Ui
            On O.Accountmanagerid = Ui.Userid
    Where   Qo.Createdate >= Cast(Getutcdate() As Date) - 60 And O.Status = 'Open';



