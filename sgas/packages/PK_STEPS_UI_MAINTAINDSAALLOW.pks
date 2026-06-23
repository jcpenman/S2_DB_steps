CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_maintaindsaallow
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
   PROCEDURE insertnewstudratesession (
      employee_in             IN              VARCHAR2,
      current_year_in         IN              VARCHAR2,   
      new_session_code        OUT NOCOPY      VARCHAR2,   
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   );   
  PROCEDURE getconfigdata (
      item_name_in            IN              VARCHAR2,
      item_name_out           OUT NOCOPY      VARCHAR2,      
      cval_out                OUT NOCOPY      VARCHAR2,
      nval_out                OUT NOCOPY      VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   );   
   PROCEDURE getStudRateMaxSession (
      max_session_code        OUT NOCOPY      VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   );   
   PROCEDURE setothermaximums (
      disab_basic_max_in       IN       VARCHAR2,
      disab_non_med_max_in     IN       VARCHAR2,
      disab_equip_max_in       IN       VARCHAR2,
      disab_trav_max_in        IN       VARCHAR2,
      stud_rate_id_in          IN       VARCHAR2,
      user_in                  IN       VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   );
END pk_steps_ui_maintaindsaallow;
/
