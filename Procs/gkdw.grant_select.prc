DROP PROCEDURE GKDW.GRANT_SELECT;

CREATE OR REPLACE PROCEDURE GKDW.grant_select(
    username VARCHAR2, 
    grantee VARCHAR2)
AS   
BEGIN
    FOR r IN (
       
SELECT owner, name 
FROM all_source where OWNER='GKDW'
    )
    LOOP
        EXECUTE IMMEDIATE 
            'GRANT SELECT ON '||r.owner||'.'||r.table_name||' to ' || grantee;
    END LOOP;
END;
/


