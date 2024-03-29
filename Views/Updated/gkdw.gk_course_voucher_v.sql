


Create Or Alter View Hold.Gk_Course_Voucher_V
(
   Evxcourseid,
   Course_Code,
   Voucher_Cost
)
As
   Select   Evxcourseid,
            Course_Code,
            (Max_Unit_Price * Voucher_Num) * Isnull(Redeem_Pct_Pad, .2)
               Voucher_Cost
     From         Course_Voucher@Gkprod V
               Inner Join
                  Gk_Voucher_Unit_Price_Mv@Gkprod P
               On V.Voucher_Type = P.Voucher_Type
            Left Outer Join
               Gkdw.Gk_Voucher_Redeem_V Vr
            On V.Course_Code = Vr.Coursecode;



