DROP PROCEDURE GKDW.RELEASE_LOCK;

CREATE OR REPLACE PROCEDURE GKDW.release_lock (lock_name IN VARCHAR2) IS
  lock_status NUMBER;
BEGIN
  lock_status := DBMS_LOCK.RELEASE(
    lockhandle => get_handle(lock_name));
  IF lock_status > 0 THEN
    RAISE_APPLICATION_ERROR(-20000,'release lock failed: ' || lock_status);
  END IF;
END release_lock;
/


