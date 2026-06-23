CREATE OR REPLACE PACKAGE SGAS.pk_AWARD_LETTER_SAVE_PDF
AS

   PROCEDURE Load_BLOB_From_File (l_file_name           IN VARCHAR2,
                                  l_stud_crse_year_id   IN   NUMBER,
                                  l_learner_application_id   IN   NUMBER,
                                  l_DIRECTORY_NAME       IN  VARCHAR2,
                                  error_boolean    OUT      VARCHAR2,
                                  ERROR_TEXT       OUT      VARCHAR2);

PROCEDURE CREATE_NULL_BLOB (stud_crse_year_id NUMBER);

PROCEDURE PTFG_CREATE_NULL_BLOB (learner_application_id IN NUMBER);

END pk_AWARD_LETTER_SAVE_PDF;
/