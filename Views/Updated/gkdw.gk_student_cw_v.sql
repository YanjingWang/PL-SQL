


Create Or Alter View Hold.Gk_Student_Cw_V
(
   Coursecode,
   Country,
   Cw_Per_Stud
)
As
     Select   Coursecode,
              Country,
              Round (
                 Sum(Case
                        When Quantity = 0 Then 0
                        Else Cb.Kit_Price / Quantity
                     End),
                 2
              )
                 Cw_Per_Stud
       From      Cw_Course_Part@Gkprod Cp
              Inner Join
                 Cw_Bom@Gkprod Cb
              On Cp.Part_Num = Cb.Kit_Num
   Group By   Coursecode, Country;



