CREATE OR REPLACE PACKAGE SGAS.CRSE_ROLLOVER
IS
   /********************************************
   *  New version updated and moved to StEPS   *
   *  06/08/2020 M.Tolmie                      *
   *********************************************/

   v_sql_message     VARCHAR2 (2000);
   v_sql_code        NUMBER;
   v_activity        VARCHAR2 (100);
   v_inst_code       CRSE_YEAR.INST_CODE%TYPE;
   v_crse_code       CRSE.CRSE_CODE%TYPE;
   v_session_count   NUMBER (10) := 0;
   v_year_count      NUMBER (10) := 0;

   FUNCTION crse_rollover (new_session_code IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION find_crse_rollover (new_session_code IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION do_crse_rollover (new_session_code    IN NUMBER,
                              p_crse_session_id   IN NUMBER)
      RETURN VARCHAR2;
END;
/