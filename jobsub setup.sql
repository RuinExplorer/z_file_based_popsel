/* Formatted on 1/16/2018 10:17:01 AM (QP5 v5.313) */
--z_secured_procs entry

/*
PROCEDURE ZGPPSEL (one_up_no IN NUMBER)
AS
BEGIN
    verify_access ('ZGPPSEL');                                -- call security
    baninst1.z_popsel.ZGPPSEL (one_up_no);
    revoke_access;
EXCEPTION
    WHEN OTHERS
    THEN
        NULL;
END;

PROCEDURE ZGPPURG (one_up_no IN NUMBER)
AS
BEGIN
    verify_access ('ZGPPURG');                                -- call security
    baninst1.z_popsel.ZGPPURG (one_up_no);
    revoke_access;
EXCEPTION
    WHEN OTHERS
    THEN
        NULL;
END;
*/

--JOBSUB Entries

--create banner object and set current version

INSERT INTO bansecr.guraobj (GURAOBJ_OBJECT,
                             GURAOBJ_DEFAULT_ROLE,
                             GURAOBJ_CURRENT_VERSION,
                             GURAOBJ_SYSI_CODE,
                             GURAOBJ_ACTIVITY_DATE,
                             GURAOBJ_CHECKSUM,
                             GURAOBJ_USER_ID)
     VALUES ('ZGPPSEL',
             'BAN_DEFAULT_M',
             '8.7',                                                  --version
             'G',                                                     --module
             SYSDATE,
             NULL,
             'Z_CARL_ELLSWORTH');

INSERT INTO bansecr.guraobj (GURAOBJ_OBJECT,
                             GURAOBJ_DEFAULT_ROLE,
                             GURAOBJ_CURRENT_VERSION,
                             GURAOBJ_SYSI_CODE,
                             GURAOBJ_ACTIVITY_DATE,
                             GURAOBJ_CHECKSUM,
                             GURAOBJ_USER_ID)
     VALUES ('ZGPPURG',
             'BAN_DEFAULT_M',
             '8.7',                                                  --version
             'G',                                                     --module
             SYSDATE,
             NULL,
             'Z_CARL_ELLSWORTH');

--create GENERAL object base table entry

INSERT INTO GUBOBJS (GUBOBJS_NAME,
                     GUBOBJS_DESC,
                     GUBOBJS_OBJT_CODE,
                     GUBOBJS_SYSI_CODE,
                     GUBOBJS_USER_ID,
                     GUBOBJS_ACTIVITY_DATE,
                     GUBOBJS_HELP_IND,
                     GUBOBJS_EXTRACT_ENABLED_IND)
     VALUES ('ZGPPSEL',
             'POPSEL Load from File Process',
             'JOBS',
             'G',                                                     --module
             'LOCAL',
             SYSDATE,
             'N',
             'B');

INSERT INTO GUBOBJS (GUBOBJS_NAME,
                     GUBOBJS_DESC,
                     GUBOBJS_OBJT_CODE,
                     GUBOBJS_SYSI_CODE,
                     GUBOBJS_USER_ID,
                     GUBOBJS_ACTIVITY_DATE,
                     GUBOBJS_HELP_IND,
                     GUBOBJS_EXTRACT_ENABLED_IND)
     VALUES ('ZGPPURG',
             'POPSEL Purge Process',
             'JOBS',
             'G',                                                     --module
             'LOCAL',
             SYSDATE,
             'N',
             'B');

--create job definition

INSERT INTO gjbjobs (GJBJOBS_NAME,
                     GJBJOBS_TITLE,
                     GJBJOBS_ACTIVITY_DATE,
                     GJBJOBS_SYSI_CODE,
                     GJBJOBS_JOB_TYPE_IND,
                     GJBJOBS_DESC,
                     GJBJOBS_COMMAND_NAME,
                     GJBJOBS_PRNT_FORM,
                     GJBJOBS_PRNT_CODE,
                     GJBJOBS_LINE_COUNT,
                     GJBJOBS_VALIDATION)
         VALUES (
                    'ZGPPSEL',
                    'POPSEL Load from File Process',
                    SYSDATE,
                    'G',                                              --module
                    'P',                                            --job type
                    'Loads Banner IDs from a flat file directly to a POPSEL. The file must be plain text (.txt or .csv) and contain only the IDs.',
                    NULL,
                    NULL,
                    'DATABASE',
                    NULL,
                    NULL);

INSERT INTO gjbjobs (GJBJOBS_NAME,
                     GJBJOBS_TITLE,
                     GJBJOBS_ACTIVITY_DATE,
                     GJBJOBS_SYSI_CODE,
                     GJBJOBS_JOB_TYPE_IND,
                     GJBJOBS_DESC,
                     GJBJOBS_COMMAND_NAME,
                     GJBJOBS_PRNT_FORM,
                     GJBJOBS_PRNT_CODE,
                     GJBJOBS_LINE_COUNT,
                     GJBJOBS_VALIDATION)
         VALUES (
                    'ZGPPURG',
                    'POPSEL Purge Process',
                    SYSDATE,
                    'G',                                              --module
                    'P',                                            --job type
                    'Removes all entries in a specific POPSEL. Only the specific POPSEL and only those entries associated to the specified user are removed.',
                    NULL,
                    NULL,
                    'DATABASE',
                    NULL,
                    NULL);

--create job parameter definition

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
     VALUES ('ZGPPSEL',
             '01',                                          --parameter number
             'POPSEL Application',                     --parameter description
             32,                                                      --length
             'C',                           --Character, Integer, Date, Number
             'R',                                          --Optional/Required
             'S',                                            --Single/Multiple
             SYSDATE,
             NULL,                                                 --low range
             NULL,                                                --high range
             'Enter the name of the POPSEL Application (functional area)', --help text
             NULL,
             NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
     VALUES ('ZGPPSEL',
             '02',                                          --parameter number
             'POPSEL Selection',                       --parameter description
             32,                                                      --length
             'C',                           --Character, Integer, Date, Number
             'R',                                          --Optional/Required
             'S',                                            --Single/Multiple
             SYSDATE,
             NULL,                                                 --low range
             NULL,                                                --high range
             'Enter the name of the POPSEL Selection (POPSEL name)', --help text
             NULL,
             NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
     VALUES ('ZGPPSEL',
             '03',                                          --parameter number
             'POPSEL Creator ID',                      --parameter description
             32,                                                      --length
             'C',                           --Character, Integer, Date, Number
             'R',                                          --Optional/Required
             'S',                                            --Single/Multiple
             SYSDATE,
             NULL,                                                 --low range
             NULL,                                                --high range
             'Enter the Banner ID of the POPSEL Creator',          --help text
             NULL,
             NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
         VALUES (
                    'ZGPPSEL',
                    '04',                                   --parameter number
                    'POPSEL User ID',                  --parameter description
                    32,                                               --length
                    'C',                    --Character, Integer, Date, Number
                    'R',                                   --Optional/Required
                    'S',                                     --Single/Multiple
                    SYSDATE,
                    NULL,                                          --low range
                    NULL,                                         --high range
                    'Enter the Banner ID of the POPSEL User under which to load these entries', --help text
                    NULL,
                    NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
         VALUES (
                    'ZGPPSEL',
                    '05',                                   --parameter number
                    'Folder Name',                     --parameter description
                    32,                                               --length
                    'C',                    --Character, Integer, Date, Number
                    'R',                                   --Optional/Required
                    'S',                                     --Single/Multiple
                    SYSDATE,
                    NULL,                                          --low range
                    NULL,                                         --high range
                    'Enter the name of the data folder where the file you wish to load is located', --help text
                    NULL,
                    NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
         VALUES (
                    'ZGPPSEL',
                    '06',                                   --parameter number
                    'File Name',                       --parameter description
                    32,                                               --length
                    'C',                    --Character, Integer, Date, Number
                    'R',                                   --Optional/Required
                    'S',                                     --Single/Multiple
                    SYSDATE,
                    NULL,                                          --low range
                    NULL,                                         --high range
                    'Enter the name of the file you wish to load including its extension', --help text
                    NULL,
                    NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
         VALUES (
                    'ZGPPURG',
                    '01',                                   --parameter number
                    'POPSEL Application',              --parameter description
                    32,                                               --length
                    'C',                    --Character, Integer, Date, Number
                    'R',                                   --Optional/Required
                    'S',                                     --Single/Multiple
                    SYSDATE,
                    NULL,                                          --low range
                    NULL,                                         --high range
                    'Enter the name of the POPSEL Application (functional area) to be purged', --help text
                    NULL,
                    NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
         VALUES (
                    'ZGPPURG',
                    '02',                                   --parameter number
                    'POPSEL Selection',                --parameter description
                    32,                                               --length
                    'C',                    --Character, Integer, Date, Number
                    'R',                                   --Optional/Required
                    'S',                                     --Single/Multiple
                    SYSDATE,
                    NULL,                                          --low range
                    NULL,                                         --high range
                    'Enter the name of the POPSEL Selection (POPSEL name) to be purged', --help text
                    NULL,
                    NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
     VALUES ('ZGPPURG',
             '03',                                          --parameter number
             'POPSEL Creator ID',                      --parameter description
             32,                                                      --length
             'C',                           --Character, Integer, Date, Number
             'R',                                          --Optional/Required
             'S',                                            --Single/Multiple
             SYSDATE,
             NULL,                                                 --low range
             NULL,                                                --high range
             'Enter the Banner ID of the POPSEL Creator to be purged', --help text
             NULL,
             NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
         VALUES (
                    'ZGPPURG',
                    '04',                                   --parameter number
                    'POPSEL User ID',                  --parameter description
                    32,                                               --length
                    'C',                    --Character, Integer, Date, Number
                    'R',                                   --Optional/Required
                    'S',                                     --Single/Multiple
                    SYSDATE,
                    NULL,                                          --low range
                    NULL,                                         --high range
                    'Enter the Banner ID associated with the records of the POPSEL to be purged', --help text
                    NULL,
                    NULL);

--create default parameter values

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZGPPSEL',
             '01',
             SYSDATE,
             NULL,
             '',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZGPPSEL',
             '02',
             SYSDATE,
             NULL,
             '',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZGPPSEL',
             '03',
             SYSDATE,
             NULL,
             '',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZGPPSEL',
             '04',
             SYSDATE,
             NULL,
             '',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZGPPSEL',
             '05',
             SYSDATE,
             NULL,
             '',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZGPPSEL',
             '06',
             SYSDATE,
             NULL,
             '',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZGPPURG',
             '01',
             SYSDATE,
             NULL,
             '',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZGPPURG',
             '02',
             SYSDATE,
             NULL,
             '',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZGPPURG',
             '03',
             SYSDATE,
             NULL,
             '',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZGPPURG',
             '04',
             SYSDATE,
             NULL,
             '',
             NULL);

--create security grants to specific users

INSERT INTO bansecr.guruobj (GURUOBJ_OBJECT,
                             GURUOBJ_ROLE,
                             GURUOBJ_USERID,
                             GURUOBJ_ACTIVITY_DATE,
                             GURUOBJ_USER_ID,
                             GURUOBJ_COMMENTS,
                             GURUOBJ_DATA_ORIGIN)
     VALUES ('ZGPPSEL',
             'BAN_DEFAULT_M',
             'BAN_STUDENT_C',
             SYSDATE,
             'Z_CARL_ELLSWORTH',
             NULL,
             NULL);


INSERT INTO bansecr.guruobj (GURUOBJ_OBJECT,
                             GURUOBJ_ROLE,
                             GURUOBJ_USERID,
                             GURUOBJ_ACTIVITY_DATE,
                             GURUOBJ_USER_ID,
                             GURUOBJ_COMMENTS,
                             GURUOBJ_DATA_ORIGIN)
     VALUES ('ZGPPSEL',
             'BAN_DEFAULT_M',
             'S_REG_ADMIN_M',
             SYSDATE,
             'Z_CARL_ELLSWORTH',
             NULL,
             NULL);

INSERT INTO bansecr.guruobj (GURUOBJ_OBJECT,
                             GURUOBJ_ROLE,
                             GURUOBJ_USERID,
                             GURUOBJ_ACTIVITY_DATE,
                             GURUOBJ_USER_ID,
                             GURUOBJ_COMMENTS,
                             GURUOBJ_DATA_ORIGIN)
     VALUES ('ZGPPURG',
             'BAN_DEFAULT_M',
             'BAN_STUDENT_C',
             SYSDATE,
             'Z_CARL_ELLSWORTH',
             NULL,
             NULL);

INSERT INTO bansecr.guruobj (GURUOBJ_OBJECT,
                             GURUOBJ_ROLE,
                             GURUOBJ_USERID,
                             GURUOBJ_ACTIVITY_DATE,
                             GURUOBJ_USER_ID,
                             GURUOBJ_COMMENTS,
                             GURUOBJ_DATA_ORIGIN)
     VALUES ('ZGPPURG',
             'BAN_DEFAULT_M',
             'S_REG_ADMIN_M',
             SYSDATE,
             'Z_CARL_ELLSWORTH',
             NULL,
             NULL);