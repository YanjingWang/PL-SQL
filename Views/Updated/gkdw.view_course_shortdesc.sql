


Create Or Alter View Hold.View_Course_Shortdesc
(
   Course_Id,
   [Country],
   [Short_Desc]
)
As
   Select   [Course_Id], [Country], [Short_Desc]
     From   View_Course_Shortdesc@Mkt_Catalog;



