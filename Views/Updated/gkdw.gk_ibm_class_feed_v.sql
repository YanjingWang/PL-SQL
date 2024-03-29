


Create Or Alter View Hold.Gk_Ibm_Class_Feed_V
(
   [Providermonthlyclassfeedv2],
   [6],
   Version,
   Year4digit,
   Month2digit,
   [Countryiso2enrollment],
   [Coursecodeprovider],
   [Derivativework],
   Course_Mod,
   Course_Code_Mod,
   [Modality],
   [Durationhours],
   Duration_Hours,
   [Coursecodeibmpri],
   Short_Name,
   [Coursecodeibmsec],
   [Studentscustomer],
   [Studentsibm],
   [Studentsibmpartner],
   [Functionflag],
   Enroll_Id,
   Payment_Method,
   Email_Id
)
As
   Select   Distinct
            'Providermonthlyclassfeedv2' [Providermonthlyclassfeedv2],
            '6' [6],
            1 Version,
            Case Substring(O.Course_Code, Len(O.Course_Code),  1)
               When 'W' Then Format(O.Rev_Date, 'Yyyy')
               Else Format(O.Event_End_Date, 'Yyyy')
            End
               Year4digit,
            Case Substring(O.Course_Code, Len(O.Course_Code),  1)
               When 'W' Then Format(O.Rev_Date, 'Mm')
               Else Format(O.Event_End_Date, 'Mm')
            End
               Month2digit,
            Case
               When Trim (Upper (O.Cust_Country)) In
                          ('United State',
                           'United States',
                           'Unites States',
                           'United States Of America',
                           'Unites States Of America',
                           'Us',
                           'U.S.A.',
                           'U.S.A',
                           'Usa',
                           'America')
               Then
                  'Us'
               When    O.Cust_Country Is Null
                    Or Upper (O.Cust_Country) = 'Virtual'
                    Or O.Cust_Country = '0'
                    Or O.Cust_Country = 'N/A'
               Then
                  Case
                     When Trim (Upper (O.Country)) In
                                ('United State',
                                 'United States',
                                 'Unites States',
                                 'United States Of America',
                                 'Unites States Of America',
                                 'Us',
                                 'U.S.A.',
                                 'U.S.A',
                                 'Usa',
                                 'America')
                     Then
                        'Us'
                     Else
                        O.Country
                  End
               Else
                  O.Cust_Country
            End
               [Countryiso2enrollment], --,  O.Cust_Country                                             ,
            O.Course_Code [Coursecodeprovider],
            Case
               When Cd.Short_Name Like 'Sl%' Or Cd.Course_Code Like '7196%'
               Then
                  'Y'
               Else
                  'N'
            End
               [Derivativework],
            O.Course_Mod,
            Substring(O.Course_Code, Len(O.Course_Code),  1) Course_Code_Mod,
            Case Substring(O.Course_Code, Len(O.Course_Code),  1)
               When 'C' Then 'Cr'
               When 'N' Then 'Cr'
               When 'D' Then 'Cr'
               When 'L' Then 'Ilo'
               When 'V' Then 'Ilo'
               When 'Z' Then 'Ilo'
               When 'W' Then 'Dl'
               Else 'Na'
            End
               [Modality],
            (Cd.Duration_Days * 8) [Durationhours],
            Qc.Duration_Hours,
            Cd.Mfg_Course_Code [Coursecodeibmpri],
            Case
               When Cd.Short_Name Like 'Sl Design%' Then 'U60748g'
               When Cd.Short_Name Like 'Sl Fund%' Then 'U60741g'
               When Cd.Short_Name Like 'Sl - Iaas Roadshow%' Then 'U61459g'
               Else Cd.Short_Name
            End,                                   -- Ibmc.Ibm_Ww_Course_Code,
            Null [Coursecodeibmsec],
            Case
               When (O.Payment_Method Not In
                           ('Talent At Ibm',
                            'Talent At Ibm',
                            'Ibm Partner Rewards',
                            'Ibm Storage Systems',
                            'Ibm System I Voucher')
                     Or O.Payment_Method Is Null)
                    And Upper (Isnull(C.Email, 'X')) Not Like '%Ibm.Com'
               Then
                  1
               Else
                  0
            End
               [Studentscustomer],
            Case
               When Upper (Isnull(C.Email, 'X')) Like '%Ibm.Com' Then 1
               Else 0
            End
               [Studentsibm],
            Case
               When O.Payment_Method In
                          ('Ibm Partner Rewards',
                           'Ibm Storage Systems',
                           'Ibm System I Voucher')
                    And Upper (Isnull(C.Email, 'X')) Not Like '%Ibm.Com'
               Then
                  1
               Else
                  0
            End
               [Studentsibmpartner],
            'A' [Functionflag],
            O.Enroll_Id,
            O.Payment_Method,
            C.Email
     From               Gkdw.Gk_All_Orders_Mv O
                     Join
                        Gkdw.Event_Dim Ed
                     On O.Event_Id = Ed.Event_Id
                  Join
                     Gkdw.Course_Dim Cd
                  On Ed.Course_Id = Cd.Course_Id
                     And Ed.Ops_Country = Cd.Country
               Join
                  Gkdw.Qg_Course Qc
               On Cd.Course_Id = Qc.Evxcourseid
            Join
               Gkdw.Cust_Dim C
            On O.Cust_Id = C.Cust_Id
    Where       O.Enroll_Status Not In ('Cancelled', 'Did Not Attend')
            And O.Course_Pl = 'Ibm'
            And O.Fee_Type <> 'Ons - Base';



