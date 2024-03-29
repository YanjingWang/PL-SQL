


Create Or Alter View Hold.Gk_Occ_V
(
   Occ_Year,
   It_Category,
   Primary_State,
   Area_Number,
   Area_Name,
   Msa_Name,
   Reporting_Msa,
   Occ_Code,
   Occ_Title,
   Occ_Emp_Cnt
)
As
     Select   O.Occ_Year,
              Case
                 When O.Occ_Code In
                            ('15-1021', '15-1031', '15-1032', '15-1061')
                 Then
                    'Developer'
                 When O.Occ_Code In
                            ('15-1041', '15-1051', '15-1071', '15-1081')
                 Then
                    'Network'
                 When O.Occ_Code In ('15-1011', '15-1099', '17-2061')
                 Then
                    'It-Other'
                 When O.Occ_Code In
                            ('11-1011', '11-1021', '11-3021', '11-3042')
                 Then
                    'Executive/Manager'
                 When O.Occ_Code In ('13-1073', '13-1079')
                 Then
                    'Training'
              End
                 It_Category,
              O.Primary_State,
              O.Area_Number,
              O.Area_Name,
              Substr (O.Area_Name, 1, Instr (O.Area_Name, ',') - 1) Msa_Name,
              Case
                 When Area_Name =
                         'New York-White Plains-Wayne, Ny-Nj Metropolitan Division'
                 Then
                    'New York-Northern New Jersey-Long Island-Ny'
                 When Area_Name = 'Philadelphia, Pa Metropolitan Division'
                 Then
                    'Philadelphia-Camden-Wilmington-Pa'
                 When Area_Name =
                         'Miami-Miami Beach-Kendall, Fl Metropolitan Division'
                 Then
                    'Miami-Fort Lauderdale-Pompano Beach-Fl'
                 When Area_Name =
                         'Detroit-Livonia-Dearborn, Mi Metropolitan Division'
                 Then
                    'Detroit-Livonia-Dearborn-Warren-Mi'
                 When Area_Name = 'Nashville-Davidson--Murfreesboro, Tn'
                 Then
                    'Nashville-Davidson-Murfreesboro-Franklin-Tn'
                 When Area_Name =
                         'Dallas-Plano-Irving, Tx Metropolitan Division'
                 Then
                    'Dallas-Fort Worth-Arlington-Tx'
                 Else
                    Isnull(
                       C.Consolidated_Msa,
                       Substr (O.Area_Name, 1, Instr (O.Area_Name, ',') - 1)
                       + '-'
                       + Substr (O.Area_Name,
                                  Instr (O.Area_Name, ', ') + 2,
                                  2)
                    )
              End
                 Reporting_Msa,
              O.Occ_Code,
              O.Occ_Title,
              Sum (Isnull(Tot_Emp, 0)) Occ_Emp_Cnt
       From      Gkdw.Gk_Msa_Occ O
              Left Outer Join
                 Gkdw.Gk_Consolidated_Msa_V C
              On    Substr (O.Area_Name, 1, Instr (O.Area_Name, ',') - 1)
                 + '-'
                 + Substr (O.Area_Name, Instr (O.Area_Name, ', ') + 2, 2) =
                    C.Msa_Desc
      Where   Occ_Code In
                    ('15-1011',
                     '15-1021',
                     '15-1031',
                     '15-1032',
                     '15-1041',
                     '15-1051',
                     '15-1061',
                     '15-1071',
                     '15-1081',
                     '15-1099',
                     '11-1011',
                     '11-1021',
                     '11-3021',
                     '11-3042',
                     '13-073',
                     '13-1079',
                     '17-2061')
              And Case
                    When Area_Name =
                            'New York-White Plains-Wayne, Ny-Nj Metropolitan Division'
                    Then
                       'New York-Northern New Jersey-Long Island-Ny'
                    When Area_Name = 'Philadelphia, Pa Metropolitan Division'
                    Then
                       'Philadelphia-Camden-Wilmington-Pa'
                    When Area_Name =
                            'Miami-Miami Beach-Kendall, Fl Metropolitan Division'
                    Then
                       'Miami-Fort Lauderdale-Pompano Beach-Fl'
                    When Area_Name =
                            'Detroit-Livonia-Dearborn, Mi Metropolitan Division'
                    Then
                       'Detroit-Livonia-Dearborn-Warren-Mi'
                    When Area_Name = 'Nashville-Davidson--Murfreesboro, Tn'
                    Then
                       'Nashville-Davidson-Murfreesboro-Franklin-Tn'
                    When Area_Name =
                            'Dallas-Plano-Irving, Tx Metropolitan Division'
                    Then
                       'Dallas-Fort Worth-Arlington-Tx'
                    Else
                       Isnull(
                          C.Consolidated_Msa,
                          Substr (O.Area_Name, 1, Instr (O.Area_Name, ',') - 1)
                          + '-'
                          + Substr (O.Area_Name,
                                     Instr (O.Area_Name, ', ') + 2,
                                     2)
                       )
                 End In
                       (  Select   Reporting_Msa From Gkdw.Gk_Top_Msa_V)
   Group By   O.Occ_Year,
              O.Primary_State,
              O.Area_Number,
              O.Area_Name,
              C.Consolidated_Msa,
              O.Occ_Code,
              O.Occ_Title
   ;



