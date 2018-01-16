/* Formatted on 5/6/2015 10:45:52 AM (QP5 v5.267.14150.38573) */
--testing load

DECLARE
   P_FOLDER_NAME   VARCHAR2 (32);
   P_FILE_NAME     VARCHAR2 (32);
   P_APPLICATION   VARCHAR2 (32);
   P_SELECTION     VARCHAR2 (32);
   P_CREATOR       VARCHAR2 (32);
   P_USER_ID       VARCHAR2 (32);
BEGIN
   P_FOLDER_NAME := 'STUDENT';
   P_FILE_NAME := 'popsel_test.csv';
   P_APPLICATION := 'STUDENT';
   P_SELECTION := 'POPSEL_TEST';
   P_CREATOR := 'A00350677';
   P_USER_ID := 'A00350677';

   Z_CARL_ELLSWORTH.Z_POPSEL.P_LOAD_POPSEL_FROM_FILE (P_FOLDER_NAME,
                                                      P_FILE_NAME,
                                                      P_APPLICATION,
                                                      P_SELECTION,
                                                      P_CREATOR,
                                                      P_USER_ID);
   COMMIT;
END;

--testing purge

SELECT *
  FROM glbextr
 WHERE glbextr_application = 'STUDENT' AND glbextr_selection = 'POPSEL_TEST' and glbextr_user_id <> 'A00350677';

DECLARE
   P_APPLICATION   VARCHAR2 (32);
   P_SELECTION     VARCHAR2 (32);
   P_CREATOR       VARCHAR2 (32);
   P_USER_ID       VARCHAR2 (32);
BEGIN
   P_APPLICATION := 'STUDENT';
   P_SELECTION := 'POPSEL_TEST';
   P_CREATOR := 'A00350677';
   P_USER_ID := 'A00350677';

   Z_CARL_ELLSWORTH.Z_POPSEL.P_PURGE_POPSEL (P_APPLICATION,
                                             P_SELECTION,
                                             P_CREATOR,
                                             P_USER_ID);
   COMMIT;
END;

--testing popsel verification

DECLARE
   P_APPLICATION   VARCHAR2 (32);
   P_SELECTION     VARCHAR2 (32);
   P_CREATOR       VARCHAR2 (32);
BEGIN
   P_APPLICATION := 'STUDENT';
   P_SELECTION := 'POPSEL_TEST';
   P_CREATOR := 'A00350677';

   IF (Z_CARL_ELLSWORTH.Z_POPSEL.f_verify_POPSEL (P_APPLICATION,
                                                  P_SELECTION,
                                                  P_CREATOR))
   THEN
      DBMS_OUTPUT.put_line ('TRUE');
   ELSE
      DBMS_OUTPUT.put_line ('FALSE');
   END IF;
END;