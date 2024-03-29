


Create Or Alter View Hold.Gk_Mtm_Msft_Course_V
(
   Msft_Type,
   Course_Id,
   Course_Code,
   Course_Name,
   Short_Name
)
As
   Select   'Moc' Msft_Type,
            Course_Id,
            Course_Code,
            Course_Name,
            Short_Name
     From   Gkdw.Course_Dim
    Where   Pl_Num = '02' And Substring(Short_Name, 1,  2) Between 'M0' And 'M9'
   Union
   Select   'Moc-Gk',
            Course_Id,
            Course_Code,
            Course_Name,
            Short_Name
     From   Gkdw.Course_Dim
    Where   Pl_Num = '02' And Short_Name Like '%7055%'
   Union
   Select   'Gk',
            Course_Id,
            Course_Code,
            Course_Name,
            Short_Name
     From   Gkdw.Course_Dim
    Where       Pl_Num = '02'
            And Substring(Short_Name, 1,  2) Not Between 'M0' And 'M9'
            And Short_Name Not Like '%7055%';



