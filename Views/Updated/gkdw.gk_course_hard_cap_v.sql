


Create Or Alter View Hold.Gk_Course_Hard_Cap_V
(
   Gk_Course_Code,
   Hard_Cap
)
As
     Select   Distinct Gk_Course_Code, Hard_Cap
       From   Gkdw.Lab_Course_Lookup_Mv_Qa
   ;



