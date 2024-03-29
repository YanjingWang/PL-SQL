


Create Or Alter View Hold.Gk_Instructor_Rate_Pl_V
(
   Cust_Id,
   Cust_Name,
   Acct_Name,
   Country,
   Course_Pl,
   Rate_Plan,
   Rate,
   Var_Exempt,
   Third_Party_Vendor,
   Pay_Curr_Code,
   First_Name,
   Last_Name,
   Spec_Inst
)
As
     Select   I.Cust_Id,
              I.Cust_Name,
              I.Acct_Name,
              Upper (I.Country) Country,
              Cd.Course_Pl,
              C.Rate_Plan,
              C.Rate,
              Ii.Var_Exempt,
              Ii.Third_Party_Vendor,
              Ii.Pay_Curr_Code,
              C.First_Name,
              C.Last_Name,
              Ii.Spec_Inst
       From                        Gkdw.Event_Dim Ed
                                Inner Join
                                   Gkdw.Course_Dim Cd
                                On Ed.Course_Id = Cd.Course_Id
                                   And Ed.Ops_Country = Cd.Country
                             Inner Join
                                Gkdw.Instructor_Event_V Ie
                             On Ed.Event_Id = Ie.Evxeventid
                          Inner Join
                             Gkdw.Instructor_Dim I
                          On Ie.Contactid = I.Cust_Id
                       Inner Join
                          Gkdw.Cust_Dim C
                       On Ie.Contactid = C.Cust_Id
                    Inner Join
                       Gkdw.Gk_Inst_Course_Rate_Mv C
                    On I.Cust_Id = C.Instructor_Id
                       And Cd.Course_Id = C.Evxcourseid
                 Inner Join
                    Rmsdw.Rms_Instructor Ri
                 On I.Cust_Id = Ri.Slx_Contact_Id And Ri.Status = 'Yes'
              Inner Join
                 Inst_Instructor@Gkprod Ii
              On Ie.Contactid = Ii.Instructor_Id
      Where   C.End_Date >= Cast(Getutcdate() As Date)
   Group By   I.Cust_Id,
              I.Cust_Name,
              I.Acct_Name,
              Cd.Course_Pl,
              C.Rate_Plan,
              C.Rate,
              Upper (I.Country),
              Ii.Var_Exempt,
              Ii.Third_Party_Vendor,
              Ii.Pay_Curr_Code,
              C.First_Name,
              C.Last_Name,
              Ii.Spec_Inst
   ;



