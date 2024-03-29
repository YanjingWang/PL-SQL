


Create Or Alter View Hold.Gk_Mkt_Promo_Cancelled_V
(
   Enroll_Id,
   Status_Date,
   Addl_Info
)
As
     Select   Distinct
              F.Enroll_Id [Enroll_Id],
              F.Creation_Date [Status_Date],
              'This Promotion Expired On '
              + Format(F.Creation_Date, 'Yyyy-Mm-Dd')
                 [Addl_Info]
       From         Base.Gk_Promo_Status S
                 Inner Join
                    Gkdw.Order_Fact F
                 On S.Evxevenrollid = F.Enroll_Id
              Inner Join
                 Gkdw.Cust_Dim C
              On F.Cust_Id = C.Cust_Id
      Where       Upper (C.Acct_Name) Like '%Wells%Fargo%'
              And S.Step = 'Promo Status'
              And S.Step_Status Is Null
   ;



