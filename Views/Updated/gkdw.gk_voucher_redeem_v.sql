


Create Or Alter View Hold.Gk_Voucher_Redeem_V
(
   Coursecode,
   Voucher_Type,
   Redeem_Pct,
   Redeem_Pct_Pad
)
As
     Select   E.Coursecode,
              C.Voucher_Type,
              Sum (Case When Redeem_Date Is Not Null Then 1 Else 0 End)
              / Count (C.Gk_Coupon_Num)
                 Redeem_Pct,
              Round (
                 Sum (Case When Redeem_Date Is Not Null Then 1 Else 0 End)
                 / Count (C.Gk_Coupon_Num),
                 2
              )
              + .20
                 Redeem_Pct_Pad
       From         Gk_Coupon@Evp C
                 Inner Join
                    Event@Evp E
                 On C.Evxeventid = E.Evxeventid
              Inner Join
                 Course_Voucher@Evp Cv
              On E.Evxcourseid = Cv.Evxcourseid
      Where   Cv.In_Class_Test = 'N'
   Group By   E.Coursecode, C.Voucher_Type
   Union
     Select   E.Coursecode,
              Cv.Voucher_Type,
              1,
              1
       From      Event@Evp E
              Inner Join
                 Course_Voucher@Evp Cv
              On E.Evxcourseid = Cv.Evxcourseid
      Where   Cv.In_Class_Test = 'Y'
   Group By   E.Coursecode, Cv.Voucher_Type;



