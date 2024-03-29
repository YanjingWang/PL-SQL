


Create Or Alter View Hold.Gk_Promo_Confirm_Email_V
(
   Enroll_Id,
   Email_Addr,
   Email_Date,
   Email_Type,
   Step_Num,
   Step_Status
)
As
   Select   S.Evxevenrollid Enroll_Id,
            'Email Sent To: ' + Format(Trim ([Email])) Email_Addr,
            Format([Datesent], 'Yyyy-Mm-Dd') Email_Date,
            Format([Email_Type]) Email_Type,
            Step_Num,
            'Email Sent' Step_Status
     From      Promo_Emails_Sent@Mkt_Catalog Pe
            Inner Join
               Base.Gk_Promo_Status S
            On Pe.[Evxenrollid] = S.Evxevenrollid And S.Step_Num = 2
    Where   Pe.[Email_Type] = 'Confirm'
            And Not Exists
                  (Select   1
                     From   Base.Gk_Promo_Status S2
                    Where       S.Evxevenrollid = S2.Evxevenrollid
                            And S.Step_Num = S2.Step_Num
                            And S.Additional_Info = S2.Additional_Info);



