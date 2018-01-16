CREATE OR REPLACE PACKAGE BODY BANINST1.z_popsel
AS
   /******************************************************************************
      REVISIONS:
      Date        Author           Description
      ----------  ---------------  ------------------------------------
      20150505    Carl Ellsworth   created this package
      20150505    Carl Ellsworth   created p_insert_glbslct, s_purge_popsel,
                                   p_load_popsel_from_file
      20150506    Carl Ellsworth   created f_verify_popsel added this
                                   functionality to p_load_popsel_from_file
      20150506    Carl Ellsworth   significantly changed up parameter order for
                                   consistency and added ZGPPSEL and ZGPPURG

      NOTES:
      desc glbextr;
      desc glbslct;
      POPSELs are defined in INB on GLBSLCT
   ******************************************************************************/

   FUNCTION MyFunction (Param1 IN NUMBER)
      RETURN NUMBER
   AS
   BEGIN
      NULL;
   END;

   FUNCTION f_verify_popsel (p_application    VARCHAR2,
                             p_selection      VARCHAR2,
                             p_creator_id     VARCHAR2)
      RETURN BOOLEAN
   AS
      v_exists   VARCHAR2 (1) := NULL;
   BEGIN
      SELECT 'X'
        INTO v_exists
        FROM glbslct
       WHERE     glbslct_application = UPPER (P_APPLICATION)
             AND glbslct_selection = UPPER (P_SELECTION)
             AND glbslct_creator_id = UPPER (p_creator_id);

      RETURN TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'EXCEPTION: This POPSEL has not yet been defined.');
         DBMS_OUTPUT.PUT_LINE (
            'In INB go to GLRSLCT to define a new POPSEL or verify that you have the correct combination of parameters.');
         RETURN FALSE;
   END;

   PROCEDURE p_purge_popsel (p_application    VARCHAR2,
                             p_selection      VARCHAR2,
                             p_creator_id     VARCHAR2,
                             p_user_id        VARCHAR2)
   AS
   BEGIN
      DELETE FROM glbextr
            WHERE     glbextr_application = UPPER (p_application)
                  AND glbextr_selection = UPPER (p_selection)
                  AND glbextr_creator_id = UPPER (p_creator_id)
                  AND glbextr_user_id = UPPER (p_user_id);

      DBMS_OUTPUT.PUT_LINE (
         'COMPLETION: ' || SQL%ROWCOUNT || ' rows purged from GLBEXTR');
   END;

   PROCEDURE p_insert_glbextr (p_application       VARCHAR2,
                               p_selection         VARCHAR2,
                               p_creator_id        VARCHAR2,
                               p_user_id           VARCHAR2,
                               p_key               VARCHAR2,
                               p_date              DATE,
                               p_flag_error    OUT BOOLEAN)
   AS
   BEGIN
      INSERT INTO glbextr (glbextr_application,
                           glbextr_selection,
                           glbextr_creator_id,
                           glbextr_user_id,
                           glbextr_key,
                           glbextr_activity_date,
                           glbextr_sys_ind,
                           glbextr_slct_ind,
                           glbextr_data_origin)
           VALUES (UPPER (p_application),
                   UPPER (p_selection),
                   UPPER (p_creator_id),
                   UPPER (p_user_id),
                   p_key,                                               --pidm
                   p_date,                                   --should be const
                   'M',                             --'M' for manually entered
                   NULL,                                                --NULL
                   'IMPORT'               --'IMPORT' field to describe process
                           );

      p_flag_error := FALSE;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         DBMS_OUTPUT.PUT_LINE (
               'EXCEPTION: PIDM '
            || p_key
            || ' already exists in this specific POPSEL');
         p_flag_error := TRUE;
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE ('EXCEPTION: ' || SUBSTR (SQLERRM, 1, 265));
         p_flag_error := TRUE;
   END;

   PROCEDURE p_load_popsel_from_file (p_application    VARCHAR2,
                                      p_selection      VARCHAR2,
                                      p_creator_id     VARCHAR2,
                                      p_user_id        VARCHAR2,
                                      p_folder_name    VARCHAR2,
                                      p_file_name      VARCHAR2)
   AS
      vin             UTL_FILE.file_type;
      v_date          DATE := SYSDATE;
      v_pidm          saturn.spriden.spriden_pidm%TYPE;
      --v_folder_name         VARCHAR2 (32) := 'POPSEL';
      --v_dest_folder_name   VARCHAR2 (32) := p_folder_name || 'POPSEL_ARCHIVE';
      --v_file_name           VARCHAR2 (32) := 'popsel_load.txt';
      v_filedata      VARCHAR2 (2048) := NULL;
      v_newfilename   VARCHAR2 (32) := NULL;
      v_newline       VARCHAR2 (2048) := NULL;
      v_counter       NUMBER (16) := 0;
      v_rec_count     NUMBER (16) := 0;
      v_flag_error    BOOLEAN := FALSE;
   BEGIN
      vin :=
         UTL_FILE.fopen (p_folder_name,
                         p_file_name,
                         'R',
                         2048);

      -- Verify that the file is open and that the POPSEL is Defined
      IF     UTL_FILE.is_open (vin)
         AND f_verify_popsel (P_APPLICATION, P_SELECTION, p_creator_id)
      THEN
         LOOP
            BEGIN
               UTL_FILE.get_line (vin, v_filedata);
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  GOTO finish_process;
            END;

            v_newline := v_filedata;

            -- Stop if v_newline is null
            IF v_newline IS NULL
            THEN
               GOTO finish_process;
            END IF;

            -- Remove possible line feed from end of v_newline
            --v_newline := TRIM (CHR ( 13 ) FROM v_newline);
            v_newline := REPLACE (v_newline, CHR (13), NULL);

            -- Remove possible spaces and correct case
            v_newline := TRIM (UPPER (v_newline));

            -- Attempt to insert record
            BEGIN
               v_flag_error := FALSE;

               SELECT spriden_pidm
                 INTO v_pidm
                 FROM spriden
                WHERE spriden_id = v_newline AND spriden_change_ind IS NULL;

               p_insert_glbextr (p_application,
                                 p_selection,
                                 p_creator_id,
                                 p_user_id,
                                 v_pidm,
                                 v_date,
                                 v_flag_error);

               IF (NOT v_flag_error)
               --only increment counter if no errors are found
               THEN
                  v_rec_count := v_rec_count + 1;
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               -- When ID from file does not match A-number in Banner
               THEN
                  DBMS_OUTPUT.PUT_LINE (
                        'EXCEPTION: ID '
                     || v_newline
                     || ' was not found in Banner');
            END;
         END LOOP;
      END IF;

     <<finish_process>>
      DBMS_OUTPUT.PUT_LINE (
            'COMPLETION: '
         || v_rec_count
         || ' records loaded to POPSEL successfully');
      UTL_FILE.fclose (vin);
   EXCEPTION
      WHEN UTL_FILE.INVALID_PATH
      THEN
         DBMS_OUTPUT.PUT_LINE ('EXCEPTION: Specified folder does not exist.');
         DBMS_OUTPUT.PUT_LINE (
            'Verify that the directory exists and if nessesary, verify directory access privileges');
      WHEN UTL_FILE.INVALID_OPERATION
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'EXCEPTION: File not found at specified path or with specified name');
         DBMS_OUTPUT.PUT_LINE (
            'Verify that the file exists and if nessesary, verify file and directory access privileges');
   END;

   PROCEDURE ZGPPSEL (one_up_no IN NUMBER)
   IS
      --this porocedure is just a wrapper to allow the p_load_from_file procedure
      --  to gather parameters from the JOBSUB entries
      v_application   VARCHAR2 (32);
      v_selection     VARCHAR2 (32);
      v_creator_id    VARCHAR2 (32);
      v_user_id       VARCHAR2 (32);
      v_folder_name   VARCHAR2 (32);
      v_file_name     VARCHAR2 (32);
   BEGIN
      BEGIN
         SELECT gjbprun_value
           INTO v_application
           FROM gjbprun
          WHERE     gjbprun_one_up_no = one_up_no
                AND gjbprun_job = 'ZGPPSEL'
                AND gjbprun_number = '01';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_application := NULL;
      END;

      BEGIN
         SELECT gjbprun_value
           INTO v_selection
           FROM gjbprun
          WHERE     gjbprun_one_up_no = one_up_no
                AND gjbprun_job = 'ZGPPSEL'
                AND gjbprun_number = '02';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_creator_id := NULL;
      END;

      BEGIN
         SELECT gjbprun_value
           INTO v_creator_id
           FROM gjbprun
          WHERE     gjbprun_one_up_no = one_up_no
                AND gjbprun_job = 'ZGPPSEL'
                AND gjbprun_number = '03';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_creator_id := NULL;
      END;


      BEGIN
         SELECT gjbprun_value
           INTO v_user_id
           FROM gjbprun
          WHERE     gjbprun_one_up_no = one_up_no
                AND gjbprun_job = 'ZGPPSEL'
                AND gjbprun_number = '04';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_user_id := NULL;
      END;

      BEGIN
         SELECT gjbprun_value
           INTO v_folder_name
           FROM gjbprun
          WHERE     gjbprun_one_up_no = one_up_no
                AND gjbprun_job = 'ZGPPSEL'
                AND gjbprun_number = '05';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_folder_name := NULL;
      END;

      BEGIN
         SELECT gjbprun_value
           INTO v_file_name
           FROM gjbprun
          WHERE     gjbprun_one_up_no = one_up_no
                AND gjbprun_job = 'ZGPPSEL'
                AND gjbprun_number = '06';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_file_name := NULL;
      END;


      p_load_popsel_from_file (v_application,
                               v_selection,
                               v_creator_id,
                               v_user_id,
                               v_folder_name,
                               v_file_name);
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   PROCEDURE ZGPPURG (one_up_no IN NUMBER)
   IS
      --this porocedure is just a wrapper to allow the p_purge_popsel procedure
      --  to gather parameters from the JOBSUB entries
      v_application   VARCHAR2 (32);
      v_selection     VARCHAR2 (32);
      v_creator_id    VARCHAR2 (32);
      v_user_id       VARCHAR2 (32);
   BEGIN
      BEGIN
         SELECT gjbprun_value
           INTO v_application
           FROM gjbprun
          WHERE     gjbprun_one_up_no = one_up_no
                AND gjbprun_job = 'ZGPPURG'
                AND gjbprun_number = '01';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_application := NULL;
      END;

      BEGIN
         SELECT gjbprun_value
           INTO v_selection
           FROM gjbprun
          WHERE     gjbprun_one_up_no = one_up_no
                AND gjbprun_job = 'ZGPPURG'
                AND gjbprun_number = '02';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_creator_id := NULL;
      END;

      BEGIN
         SELECT gjbprun_value
           INTO v_creator_id
           FROM gjbprun
          WHERE     gjbprun_one_up_no = one_up_no
                AND gjbprun_job = 'ZGPPURG'
                AND gjbprun_number = '03';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_creator_id := NULL;
      END;


      BEGIN
         SELECT gjbprun_value
           INTO v_user_id
           FROM gjbprun
          WHERE     gjbprun_one_up_no = one_up_no
                AND gjbprun_job = 'ZGPPURG'
                AND gjbprun_number = '04';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_user_id := NULL;
      END;

      p_purge_popsel (v_application,
                      v_selection,
                      v_creator_id,
                      v_user_id);
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;
END z_popsel;
/