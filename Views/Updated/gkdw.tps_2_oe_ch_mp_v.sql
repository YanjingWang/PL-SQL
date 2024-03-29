


Create Or Alter View Hold.Tps_2_Oe_Ch_Mp_V
(
   Enroll_Id,
   Keycode,
   Book_Date,
   Start_Date,
   Enroll_Date,
   Event_Id,
   Book_Amt,
   Curr_Code,
   Oracle_Trx_Num,
   Acct_Name,
   Enroll_Status,
   Partner_Name,
   Channel_Manager,
   Course_Mod,
   Territory_Type,
   Pl_Num,
   Course_Code,
   Course_Name,
   Ppcard_Id,
   Zipcode,
   Province,
   Ops_Country
)
As
     Select   F.Enroll_Id,
              F.Keycode,
              F.Book_Date,
              Ed.Start_Date,
              F.Enroll_Date,
              F.Event_Id,
              F.Book_Amt,
              F.Curr_Code,
              F.Oracle_Trx_Num,
              A.Acct_Name,
              F.Enroll_Status,
              Cp.Partner_Name,
              Cp.Channel_Manager,
              Cd.Course_Mod,
              Gt.Territory_Type,
              Cd.Pl_Num,
              Cd.Course_Code,
              Cd.Course_Name,
              F.Ppcard_Id,
              C.Zipcode,
              C.Province,
              Ed.Ops_Country
       From                     Gkdw.Order_Fact F
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On F.Event_Id = Ed.Event_Id
                          Inner Join
                             Gkdw.Course_Dim Cd
                          On Ed.Course_Id = Cd.Course_Id
                             And Ed.Ops_Country = Cd.Country
                       Inner Join
                          Gkdw.Cust_Dim C
                       On F.Cust_Id = C.Cust_Id
                    Inner Join
                       Gkdw.Account_Dim A
                    On C.Acct_Id = A.Acct_Id
                 Left Outer Join
                    Gkdw.Gk_Territory Gt
                 On C.Zipcode Between Gt.Zip_Start And Gt.Zip_End
                    And (Gt.Territory_Type = 'Ob' Or Gt.Territory_Type Is Null)
              Inner Join
                 Gkdw.Gk_Channel_Partner Cp
              On F.Keycode = Cp.Partner_Key_Code
      Where   Cd.Ch_Num = '10'
              And (   Substring(F.Keycode, 1,  2) In ('C0', 'C1', 'Mp')
                   Or F.Keycode = 'Bmjp09'
                   Or F.Keycode = 'C099025')
              And Book_Date >= '01-Jan-2014'
   ;



