CREATE OR REPLACE PACKAGE BODY SGAS.PK_AWARD_LETTER_TRANSFER
AS
   /******************************************************************************
      NAME:       PK_AWARD_LETTER_TRANSFER
      PURPOSE:	  Transfer award letters to web

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        11/11/2015  E. Watson       1. Created this package body.
   ******************************************************************************/

   PROCEDURE push_award_letter_data (error_boolean            OUT VARCHAR2,
                                     ERROR_TEXT               OUT VARCHAR2)
   IS
   BEGIN

         INSERT /*+ APPEND */
               INTO  award_letter@web
            SELECT * FROM award_letter;
            
      EXCEPTION
         WHEN OTHERS
         THEN
			error_boolean := 'true';
            ERROR_TEXT :=
                  'Unhandled exception '
               || TO_CHAR (SQLCODE)
               || ' while updating award_letter table @web';
            ROLLBACK;
      

   END push_award_letter_data;
END PK_AWARD_LETTER_TRANSFER;
/
