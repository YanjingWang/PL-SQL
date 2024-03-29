


Create Or Alter View Hold.Gk_Ibm_Course_Load_V
(
   Evxcourseid,
   Coursecode,
   Coursename,
   Pl_Num,
   Course_Num,
   Coursecategory,
   Feetype,
   Us_Primary_Fee,
   Ca_Primary_Fee
)
As
     Select   Evxcourseid,
              Coursecode,
              Coursename,
              Pl_Num,
              Lpad (Course_Num, 6, '0') Course_Num,
              Coursecategory,
              Feetype,
              Sum (Us_Primary_Fee) Us_Primary_Fee,
              Sum (Ca_Primary_Fee) Ca_Primary_Fee
       From   (Select   C.Evxcourseid,
                        C.Coursecode,
                        C.Coursename,
                        Pd.Pl_Value Pl_Num,
                        Case
                           When Substring(Coursecode, Len(Coursecode), 1) Between 'A' And 'Z'
                           Then
                              Lpad (
                                 Substr (Coursecode,
                                         1,
                                         Length (Coursecode) - 1),
                                 6,
                                 '0'
                              )
                           Else
                              Lpad (Coursecode, 6, '0')
                        End
                           Course_Num,
                        Coursecategory,
                        Cf.Feetype,
                        Cf.Amount Us_Primary_Fee,
                        0 Ca_Primary_Fee
                 From         Base.Evxcourse C
                           Inner Join
                              Base.Evxcoursefee Cf
                           On C.Evxcourseid = Cf.Evxcourseid
                        --     Inner Join Gkdw.Event_Dim Ed On C.Evxcourseid = Ed.Course_Id
                        Inner Join
                           Gkdw.Pl_Dim Pd
                        On C.Coursecategory = Pd.Pl_Desc
                Where   Trim (Inactivedate) Is Null
                        And Not Exists
                              (Select   1
                                 From   Mtl_System_Items_B@R12prd M
                                Where   C.Coursecode = M.Attribute1
                                        And Invoiceable_Item_Flag = 'Y')
                        And Cf.Pricelist = 'Usa'
                        And Cf.Feetype In ('Ons - Base', 'Primary')
               Union
               Select   C.Evxcourseid,
                        C.Coursecode,
                        C.Coursename,
                        Pd.Pl_Value Pl_Num,
                        Case
                           When Substring(Coursecode, Len(Coursecode), 1) Between 'A' And 'Z'
                           Then
                              Lpad (
                                 Substr (Coursecode,
                                         1,
                                         Length (Coursecode) - 1),
                                 6,
                                 '0'
                              )
                           Else
                              Lpad (Coursecode, 6, '0')
                        End
                           Course_Num,
                        Coursecategory,
                        Cf.Feetype,
                        0 Us_Primary_Fee,
                        Cf.Amount Ca_Primary_Fee
                 From         Base.Evxcourse C
                           Inner Join
                              Base.Evxcoursefee Cf
                           On C.Evxcourseid = Cf.Evxcourseid
                        Inner Join
                           Gkdw.Pl_Dim Pd
                        On C.Coursecategory = Pd.Pl_Desc
                --     Inner Join Gkdw.Event_Dim Ed On C.Evxcourseid = Ed.Course_Id
                Where   Trim (Inactivedate) Is Null
                        And Not Exists
                              (Select   1
                                 From   Mtl_System_Items_B@R12prd M
                                Where   C.Coursecode = M.Attribute1
                                        And Invoiceable_Item_Flag = 'Y')
                        And Cf.Pricelist = 'Canada'
                        And Cf.Feetype In ('Ons - Base', 'Primary')) a1
      Where   Course_Num Is Not Null
   Group By   Evxcourseid,
              Coursecode,
              Coursename,
              Pl_Num,
              Course_Num,
              Coursecategory,
              Feetype
   ;



