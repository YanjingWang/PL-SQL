


Create Or Alter View Hold.Readonly_Obj_V
(
   Owner,
   Name,
   Type,
   Line,
   Text
)
As
   Select   [Owner],
            [Name],
            [Type],
            [Line],
            [Text]
     From   Gkdw.All_Source
    Where   Type In ('Package', 'Package Body', 'Procedure')
            And Owner In ('Gkdw', 'Slxdw');







