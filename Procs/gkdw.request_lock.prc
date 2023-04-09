DROP PROCEDURE GKDW.REQUEST_LOCK;

CREATE OR REPLACE PROCEDURE GKDW.request_lock (lock_name IN VARCHAR2) IS
  lock_status NUMBER;
BEGIN
  lock_status := DBMS_LOCK.REQUEST(
    lockhandle => get_handle(lock_name),
    lockmode => DBMS_LOCK.X_MODE, -- eXclusive
    timeout => DBMS_LOCK.MAXWAIT, -- wait forever
    release_on_commit => FALSE);
  CASE lock_status
    WHEN 0 THEN NULL;
    WHEN 2 THEN RAISE_APPLICATION_ERROR(-20000,'deadlock detected');
    WHEN 4 THEN RAISE_APPLICATION_ERROR(-20000,'lock already obtained');
    ELSE RAISE_APPLICATION_ERROR(-20000,'request lock failed: ' || lock_status);
  END CASE;
END request_lock;
/


