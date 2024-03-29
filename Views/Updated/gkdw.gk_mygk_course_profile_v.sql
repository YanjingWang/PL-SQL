


Create Or Alter View Hold.Gk_Mygk_Course_Profile_V
(
   Course_Id,
   Course_Code,
   Short_Name,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Mygk_Profile,
   Dmoc,
   Adobe_Connect
)
As
   Select   Distinct
            Cp.Evxcourseid Course_Id,
            Cd.Course_Code,
            Cd.Short_Name,
            Cd.Course_Ch,
            Cd.Course_Mod,
            Cd.Course_Pl,
            Dp.Code Mygk_Profile,
            Case When Sp.Template = 'Custom' Then 'Y' Else 'N' End Dmoc,
            Case When Cp.Modality In ('V', 'L') Then 'Y' Else 'N' End
               Adobe_Connect
     From               Dvxcourseprofile@Gkhub Cp
                     Inner Join
                        Dvxprofile@Gkhub Dp
                     On Cp.Dvxprofileid = Dp.Dvxprofileid
                  Inner Join
                     Dvxprofilemember@Gkhub Pm
                  On Dp.Dvxprofileid = Pm.Dvxprofileid
               Inner Join
                  Dvxsystemprofile@Gkhub Sp
               On Pm.Dvxsystemprofileid = Sp.Dvxsystemprofileid
                  And Sp.Type = 'Courseware'
            Inner Join
               Gkdw.Course_Dim Cd
            On Cp.Evxcourseid = Cd.Course_Id And Cd.Gkdw_Source = 'Slxdw'
    Where   Cp.Terminationdate Is Null
   Union
   Select   Distinct
            Cp.Evxcourseid Course_Id,
            Cd.Course_Code,
            Cd.Short_Name,
            Cd.Course_Ch,
            Cd.Course_Mod,
            Cd.Course_Pl,
            Dp.Code Mygk_Profile,
            'N' Dmoc,
            Case When Cp.Modality In ('V', 'L') Then 'Y' Else 'N' End
               Adobe_Connect
     From         Dvxcourseprofile@Gkhub Cp
               Inner Join
                  Dvxprofile@Gkhub Dp
               On Cp.Dvxprofileid = Dp.Dvxprofileid
            Inner Join
               Gkdw.Course_Dim Cd
            On Cp.Evxcourseid = Cd.Course_Id And Cd.Gkdw_Source = 'Slxdw'
    Where   Cp.Terminationdate Is Null
            And Not Exists
                  (Select   1
                     From      Dvxprofilemember@Gkhub Pm
                            Inner Join
                               Dvxsystemprofile@Gkhub Sp
                            On Pm.Dvxsystemprofileid = Sp.Dvxsystemprofileid
                    Where   Dp.Dvxprofileid = Pm.Dvxprofileid
                            And Sp.Type = 'Courseware');



