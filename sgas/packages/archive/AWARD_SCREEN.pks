CREATE OR REPLACE PACKAGE SGAS.AWARD_SCREEN AS
/******************************************************************************
   NAME:       AWARD_SCREEN
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/04/2011   CB          1. Created this package.
******************************************************************************/


 -- CURSOR DEFINITIONS
  TYPE awardscreen_type_cursor         IS REF CURSOR;

  
  FUNCTION does_stud_dep_exist (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION is_there_a_spouse (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION benefactor_with_income (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION lpcg_mandatory_fields (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION does_spouse_have_child (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION NMT_only (p_stud_crse_year_id IN NUMBER) RETURN CHAR;

   PROCEDURE awardscreenvalues_doc (
      p_stud_crse_year_id   IN       NUMBER,
      p_awardscreen_type    IN OUT   awardscreen_type_cursor);


END AWARD_SCREEN;
/
