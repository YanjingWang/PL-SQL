


Create Or Alter View Hold.Gk_Cbsa_Emp_V
(
   Dim_Year,
   Cbsa_Name,
   Cbsa_Code,
   It_Category,
   Emp_Cnt
)
As
     Select   2006 Dim_Year,
              Area_Name Cbsa_Name,
              Area_Number Cbsa_Code,
              It_Category,
              Sum (Occ_Emp_Cnt) Emp_Cnt
       From   Gkdw.Gk_Occ_Mv M
      Where   Occ_Year = 2006
   Group By   Area_Name, Area_Number, It_Category
   Union All
     Select   2007,
              Area_Name,
              Area_Number,
              It_Category,
              Sum (Occ_Emp_Cnt)
       From   Gkdw.Gk_Occ_Mv M
      Where   Occ_Year = 2007
   Group By   Area_Name, Area_Number, It_Category
   Union All
     Select   2008,
              Area_Name,
              Area_Number,
              It_Category,
              Sum (Occ_Emp_Cnt)
       From   Gkdw.Gk_Occ_Mv M
      Where   Occ_Year = 2008
   Group By   Area_Name, Area_Number, It_Category
   Union All
     Select   2009,
              Area_Name,
              Area_Number,
              It_Category,
              Sum (Occ_Emp_Cnt)
       From   Gkdw.Gk_Occ_Mv M
      Where   Occ_Year = 2009
   Group By   Area_Name, Area_Number, It_Category
   Union All
     Select   2010,
              Area_Name,
              Area_Number,
              It_Category,
              Sum (Occ_Emp_Cnt)
       From   Gkdw.Gk_Occ_Mv M
      Where   Occ_Year = 2010
   Group By   Area_Name, Area_Number, It_Category
   Union All
     Select   2011,
              Area_Name,
              Area_Number,
              It_Category,
              Sum (Occ_Emp_Cnt)
       From   Gkdw.Gk_Occ_Mv M
      Where   Occ_Year = 2010
   Group By   Area_Name, Area_Number, It_Category;



