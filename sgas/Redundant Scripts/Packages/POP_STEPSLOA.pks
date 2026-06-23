CREATE OR REPLACE PACKAGE SGAS.pop_stepsloa
AS
   FUNCTION pop_stepsloa (p_stud_crse_year_id NUMBER, p_post_type VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE clear_temp_tab;
END pop_stepsloa; 
/

