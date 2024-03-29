


Create Or Alter View Hold.Gk_Canada_Order_History_V
(
   Cust_Id,
   Source_Contactid,
   Enroll_Id,
   Enroll_Status,
   Enroll_Date,
   Event_Name,
   Course_Code,
   Course_Pl,
   Course_Type,
   Start_Date,
   Book_Amt
)
As
   Select   Cust_Id,
            Source_Contactid,
            Enroll_Id,
            Enroll_Status,
            Enroll_Date,
            Event_Name,
            Course_Code,
            Course_Pl,
            Course_Type,
            Start_Date,
            Book_Amt
     From            Gkdw.Order_Fact O
                  Inner Join
                     Gkdw.Event_Dim E
                  On O.Event_Id = E.Event_Id
               Inner Join
                  Gkdw.Course_Dim C
               On E.Course_Id = C.Course_Id
            Inner Join
               Base.Gk_Enrollment G
            On O.Cust_Id = G.Attendeecontactid
    Where   C.Country = 'Canada'
   Union
   Select   Attendeecontactid,
            Student_No,
            Enroll_No,
            Status,
            Orderdate,
            Coursename,
            Custshortcode,
            Custproductline,
            Custproductline,
            Startdate,
            Amount
     From      Nexdw.Tp_Enrollments E
            Inner Join
               Base.Gk_Enrollment G
            On E.Student_No = G.Source_Contactid
   ;



