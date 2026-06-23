CREATE OR REPLACE PACKAGE SGAS.PK_AWARD_LETTER_TRANSFER
AS
   PROCEDURE push_award_letter_data (error_boolean            OUT VARCHAR2,
                                     ERROR_TEXT               OUT VARCHAR2);
END PK_AWARD_LETTER_TRANSFER;