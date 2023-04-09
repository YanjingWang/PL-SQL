


Create Or Alter View Hold.Gk_Co_Group_Lookup_V (Acct_Id, Co_Group)
As
     Select   C.Acct_Id, C.Co_Group
       From   Gkdw.Gk_Co_Group_Load C
      Where   C.Acct_Id In (  Select   C1.Acct_Id
                                From   Gkdw.Gk_Co_Group_Load C1
                            Group By   C1.Acct_Id
                              Having   Count ( * ) > 1)
   --And C.Acct_Id = 'A6uj9a016614'
   Group By   C.Acct_Id, C.Co_Group
   ;



