


Create Or Alter View Hold.Gk_Promo_Qualify_Email_V
(
   Enroll_Id,
   Addl_Info,
   Email_Date,
   Email_Type,
   Step_Num,
   Step_Status
)
As
   Select   S.Evxevenrollid Enroll_Id,
            Case
               When Pe.[Promo_Code] = 'Ipadmini2013'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Ipadmini2013.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Caipadmini2013'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Caipadmini2013.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Ipad4'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Ipad4.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Caipad42013'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Caipad42013.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Tablet'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Tablet.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Tabletca'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Tabletca.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Screensize'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Screensize.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Ipadair'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Ipadair.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Ipadairca'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Ipadairca.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Game'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Game.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Game15'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Game15.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Giftcardca'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Giftcardca.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Pro'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Pro.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Cagopro'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Cagopro.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Hello'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Hello.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Hello10'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Hello10.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Shape'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Shape.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Shape500'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Shape500.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Coolstuff'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Coolstuff.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Coolstuff500'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Coolstuff500.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Coolstuff2pack'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Coolstuff2pack.Aspx?Evid='
                  + S.Evxevenrollid
               When Pe.[Promo_Code] = 'Casuperpowersvcl'
               Then
                  'Https://Secure.Globalknowledge.Com/Promo/Casuperpowersvcl.Aspx?Evid='
                  + S.Evxevenrollid
            End
               Addl_Info,
            Format([Datesent], 'Yyyy-Mm-Dd') Email_Date,
            Format([Email_Type]) Email_Type,
            Step_Num,
            'Email Sent' Step_Status
     From      Promo_Emails_Sent@Mkt_Catalog Pe
            Inner Join
               Base.Gk_Promo_Status S
            On Pe.[Evxenrollid] = S.Evxevenrollid And S.Step_Num = 3
    Where   Pe.[Email_Type] = 'Qualify'
            And Not Exists
                  (Select   1
                     From   Base.Gk_Promo_Status S2
                    Where       S.Evxevenrollid = S2.Evxevenrollid
                            And S.Step_Num = S2.Step_Num
                            And S.Additional_Info = S2.Additional_Info);



