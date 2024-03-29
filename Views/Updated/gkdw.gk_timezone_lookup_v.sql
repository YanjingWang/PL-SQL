


Create Or Alter View Hold.Gk_Timezone_Lookup_V (Zipcode, Timezone)
As
   Select   Lpad (Zipcode, 5, '0') Zipcode, Timezone
     From   Gkdw.Gk_Zipcode_Lat_Long
    Where   Zipcode Is Not Null
   Union
   Select   Distinct Upper (A.Postalcode) Zipcode, Tz.Offsetfromutc
     From      Base.Address A
            Inner Join
               Base.Evxtimezone Tz
            On Case
                  When A.Postalcode Like 'A%' Then 'Nft'
                  When A.Postalcode Like 'B%' Then 'Ast'
                  When A.Postalcode Like 'C%' Then 'Ast'
                  When A.Postalcode Like 'E%' Then 'Ast'
                  When A.Postalcode Like 'G%' Then 'Est'
                  When A.Postalcode Like 'H%' Then 'Est'
                  When A.Postalcode Like 'J%' Then 'Est'
                  When A.Postalcode Like 'K%' Then 'Est'
                  When A.Postalcode Like 'L%' Then 'Est'
                  When A.Postalcode Like 'M%' Then 'Est'
                  When A.Postalcode Like 'N%' Then 'Est'
                  When A.Postalcode Like 'P%' Then 'Est'
                  When A.Postalcode Like 'R%' Then 'Cst'
                  When A.Postalcode Like 'Spv%' Then 'Mst'
                  When A.Postalcode Like 'S%' Then 'Cst'
                  When A.Postalcode Like 'T%' Then 'Mst'
                  When A.Postalcode Like 'V%' Then 'Pst'
                  When A.Postalcode Like 'X%' Then 'Est'
                  When A.Postalcode Like 'Y%' Then 'Pst'
               End = Tz.Tzabbreviation
    Where   Upper (A.Country) In ('Canada') And A.Postalcode Is Not Null
   ;



