


Create Or Alter View Hold.Lmsgk2tp_Course_Fee_V
(
   Course_Code,
   Country,
   Oe_Fees,
   Ons_Addl
)
As
     Select   Substring(Cd.Course_Code, 1,  4) Course_Code,
              Cd.Country,
              Max (Case When Cf.Feetype = 'Primary' Then Cf.Amount Else Null End) As Oe_Fees,
              Max(Case
                     When Replace (Cf.Feetype, ' ') In
                                ('Ons-Additional', 'Ons-Individual')
                     Then
                        Cf.Amount
                     Else
                        Null
                  End)
                 As Ons_Addl
       From      Gkdw.Course_Dim Cd
              Join
                 Base.Evxcoursefee Cf
              On Cd.Course_Id = Cf.Evxcourseid
                 And Cd.Country = Upper (Cf.Pricelist)
      Where       Cd.Inactive_Flag = 'F'
              And Cf.Feeallowuse = 'T'
              And Cf.[Feeavailable] = 'T'
              And Replace (Cf.Feetype, ' ') In
                       ('Ons-Additional', 'Primary', 'Ons-Individual')
              And Cd.Country In ('Usa', 'Canada')
              And Substring(Cd.Course_Code, Len(Cd.Course_Code),  1) In ('N', 'H', 'G', 'C')
   Group By   Substring(Cd.Course_Code, 1,  4), Cd.Country
   ;



