CREATE OR REPLACE PACKAGE BANINST1.z_popsel
AS
   /******************************************************************************
      NAME:       z_popsel
      PURPOSE:    Procedures to allow creation and population of a Banner POPSEL
                  from an externally loaded spreadsheet.
   ******************************************************************************/

   FUNCTION MyFunction (Param1 IN NUMBER)
      RETURN NUMBER;

   FUNCTION f_verify_popsel (p_application    VARCHAR2,
                             p_selection      VARCHAR2,
                             p_creator_id     VARCHAR2)
      RETURN BOOLEAN;

   PROCEDURE p_purge_popsel (p_application    VARCHAR2,
                             p_selection      VARCHAR2,
                             p_creator_id     VARCHAR2,
                             p_user_id        VARCHAR2);

   PROCEDURE p_insert_glbextr (p_application       VARCHAR2,
                               p_selection         VARCHAR2,
                               p_creator_id        VARCHAR2,
                               p_user_id           VARCHAR2,
                               p_key               VARCHAR2,
                               p_date              DATE,
                               p_flag_error    OUT BOOLEAN);

   PROCEDURE p_load_popsel_from_file (p_application    VARCHAR2,
                                      p_selection      VARCHAR2,
                                      p_creator_id     VARCHAR2,
                                      p_user_id        VARCHAR2,
                                      p_folder_name    VARCHAR2,
                                      p_file_name      VARCHAR2);

   PROCEDURE ZGPPSEL (one_up_no IN NUMBER);

   PROCEDURE ZGPPURG (one_up_no IN NUMBER);
END z_popsel;
/