


Create Or Alter View Hold.Qg_Eventinstructors
(
   Qg_Eventinstructorsid,
   Evxeventid,
   Createuser,
   Createdate,
   Modifyuser,
   Modifydate,
   Contactid,
   Feecode,
   Notes,
   Rms_Code
)
As
   Select   [Qg_Eventinstructorsid],
            [Evxeventid],
            [Createuser],
            [Createdate],
            [Modifyuser],
            [Modifydate],
            [Contactid],
            [Feecode],
            [Notes],
            [Rms_Code]
     From   Base.Qg_Eventinstructors;



