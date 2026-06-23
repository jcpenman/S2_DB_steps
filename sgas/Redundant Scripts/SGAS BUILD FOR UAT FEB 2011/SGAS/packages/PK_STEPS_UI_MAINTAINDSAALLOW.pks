/* Formatted on 2010/11/01 16:34 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_maintaindsaallow
AS
/******************************************************************************
   NAME:       pk_steps_ui_MAINTAINDSAALLOW
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/11/2010      PADDY GRACE Created this package.
******************************************************************************/
   PROCEDURE insertnewlimitrecord (
      stud_award_type_id_in   IN              VARCHAR2,
      session_code_in         IN              VARCHAR2,
      employee_in             IN              VARCHAR2,
      stud_rate_id_out        OUT NOCOPY      VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_maintaindsaallow;
/