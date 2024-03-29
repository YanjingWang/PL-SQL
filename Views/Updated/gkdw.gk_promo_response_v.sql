


Create Or Alter View Hold.Gk_Promo_Response_V
(
   Enroll_Id,
   Step_Num,
   Step_Status,
   Status_Date,
   Addl_Info,
   Promo_Item
)
As
   Select   S.Evxevenrollid Enroll_Id,
            S.Step_Num,
            Case
               When Ps.[Shipping_Accept] = 'True' Then 'Accepted'
               Else 'Declined'
            End
               Step_Status,
            Format(Ps.[Date_Received], 'Yyyy-Mm-Dd') Status_Date,
            Case
               When Ps.[Shipping_Accept] = 'True'
                    And S.Promo_Code In ('Hello', 'Hello10')
               Then
                  Format(Ps.[Email])
               When Ps.[Shipping_Accept] = 'True'
               Then
                  Format(   Trim (Ps.[Address1])
                          + ','
                          + Trim (Ps.[Address2])
                          + ','
                          + Trim (Ps.[City])
                          + ','
                          + Trim (Ps.[State])
                          + ','
                          + Trim (Ps.[Zip]))
               Else
                  'N/A'
            End
               Addl_Info,
            Ps.[Item] Promo_Item
     From      Promo_Shipping@Mkt_Catalog Ps
            Inner Join
               Base.Gk_Promo_Status S
            On Ps.[Evxenrollid] = S.Evxevenrollid And S.Step_Num = 4
    Where   Ps.[Currententry] = 1
            And Not Exists
                  (Select   1
                     From   Base.Gk_Promo_Status S2
                    Where       S.Evxevenrollid = S2.Evxevenrollid
                            And S.Step_Num = S2.Step_Num
                            And S.Additional_Info = S2.Additional_Info)
   Union
   Select   S.Evxevenrollid Enroll_Id,
            S.Step_Num,
            Case
               When Ps.[Shipping_Accept] = 'True' Then 'Accepted'
               Else 'Declined'
            End
               Step_Status,
            Format(Ps.[Date_Received], 'Yyyy-Mm-Dd') Status_Date,
            Case
               When Ps.[Shipping_Accept] = 'True'
               Then
                  Format(   Trim (Ps.[Address1])
                          + ','
                          + Trim (Ps.[Address2])
                          + ','
                          + Trim (Ps.[City])
                          + ','
                          + Trim (Ps.[State])
                          + ','
                          + Trim (Ps.[Zip]))
               Else
                  'N/A'
            End
               Addl_Info,
            Ps.[Item] Promo_Item
     From      Promo_Shipping@Mkt_Catalog Ps
            Inner Join
               Base.Gk_Promo_Status S
            On Ps.[Evxenrollid] = S.Evxevenrollid And S.Step_Num = 4
    Where       Ps.[Currententry] = 1
            And Ps.[Item] Is Not Null
            And S.Step_Num = 7
            And Not Exists
                  (Select   1
                     From   Base.Gk_Promo_Status S3
                    Where       S.Evxevenrollid = S3.Evxevenrollid
                            And Trim (Ps.[Item]) = Trim (S3.Additional_Info)
                            And S3.Step_Num = 7);



