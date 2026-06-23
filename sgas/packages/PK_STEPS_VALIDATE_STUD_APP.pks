CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_VALIDATE_STUD_APP AS

/******************************************************************************
   NAME:      PK_STEPS_VALIDATE_STUD_APP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02/02/2022      U446646       1. Created this package for COS2022.
******************************************************************************/

  PROCEDURE validatePlacementMsg (
      crse_code_in                IN   VARCHAR2,
      inst_code_in                IN   VARCHAR2,
      isPlacementMsgShown         OUT  VARCHAR2,
      error_boolean               OUT  VARCHAR2,
      ERROR_TEXT                  OUT  VARCHAR2);

END PK_STEPS_VALIDATE_STUD_APP;
/