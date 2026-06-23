CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_maintaindsaallow
AS
/******************************************************************************
   NAME:       pk_steps_ui_MAINTAINDSAALLOWANCES
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
   )
   IS
   BEGIN
      INSERT INTO stud_rate
                  (stud_award_type_id, session_code, last_updated_by,
                   last_updated_on
                  )
           VALUES (stud_award_type_id_in, session_code_in, employee_in,
                   SYSDATE
                  );

      SELECT stud_rate_id_seq.CURRVAL
        INTO stud_rate_id_out
        FROM DUAL;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertnewlimitrecord;
   PROCEDURE insertnewstudratesession (
      employee_in             IN              VARCHAR2,
      current_year_in         IN              VARCHAR2,   
      new_session_code        OUT NOCOPY      VARCHAR2,   
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   )
   IS
        max_session_code number(4);        
        CURSOR award_types IS 
            SELECT SAT.STUD_AWARD_TYPE_ID, SAT.STUD_AWARD_TYPE FROM 
            STUD_AWARD_TYPE SAT
            WHERE SAT.STUD_AWARD_TYPE IN ('UGDSA', 'SNBDSA', 'PSDSA', 'DSATE', 'PGDSATE');            
        awardType  award_types%ROWTYPE;          
   
   BEGIN
   
      error_boolean := 'false';
      ERROR_TEXT := 'none';             
   
      SELECT max(sra.session_code) 
      INTO max_session_code  
      FROM stud_rate sra, STUD_AWARD_TYPE sat      
      WHERE sra.stud_award_type_id = sat.stud_award_type_id
      AND SAT.STUD_AWARD_TYPE IN ('UGDSA', 'SNBDSA', 'PSDSA', 'DSATE', 'PGDSATE');          
      
      IF current_year_in > max_session_code THEN      
          OPEN award_types;
          LOOP 
            FETCH award_types INTO awardType;
            EXIT WHEN award_types%NOTFOUND;
            IF awardType.STUD_AWARD_TYPE IN ('UGDSA', 'SNBDSA', 'PSDSA') THEN
                INSERT INTO stud_rate
                       (stud_award_type_id, session_code, disab_basic_max, DISAB_NON_MED_MAX, DISAB_EQUIP_MAX, DISAB_TRAV_MAX,  last_updated_by,
                          last_updated_on
                          )
                VALUES (awardType.STUD_AWARD_TYPE_ID, max_session_code + 1, 0, 0, 0, 0, UPPER(employee_in),
                          SYSDATE
                        );
            ELSE 
                INSERT INTO stud_rate
                       (stud_award_type_id, session_code, disab_basic_max, DISAB_NON_MED_MAX, DISAB_EQUIP_MAX, DISAB_TRAV_MAX,  last_updated_by,
                          last_updated_on
                          )
                VALUES (awardType.STUD_AWARD_TYPE_ID, max_session_code + 1, 0, 0, 0, 0, UPPER(employee_in),
                          SYSDATE
                        );        
            END IF;       
          END LOOP;      
          CLOSE award_types;
           
          new_session_code := max_session_code;
          
      ELSE
          
          new_session_code := 'none'; 
          error_boolean := 'true';
          ERROR_TEXT := 'Can only create a new allowance session a year ahead of the current session'; 
                 
      END IF;
          
                         

   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertnewstudratesession;   
   PROCEDURE getconfigdata (
      item_name_in            IN              VARCHAR2,
      item_name_out           OUT NOCOPY      VARCHAR2,      
      cval_out                OUT NOCOPY      VARCHAR2,
      nval_out                OUT NOCOPY      VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
    
      SELECT cfd.item_name, cfd.cval, cfd.nval 
      INTO  item_name_out, cval_out, nval_out
      FROM config_data cfd
      WHERE cfd.item_name = UPPER(item_name_in);
       
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getconfigdata;
   PROCEDURE getStudRateMaxSession (
      max_session_code        OUT NOCOPY      VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
    
      SELECT max(sra.session_code)
      INTO max_session_code  
      FROM STUD_RATE sra, STUD_AWARD_TYPE sat      
      WHERE sra.stud_award_type_id = sat.stud_award_type_id
      AND SAT.STUD_AWARD_TYPE IN ('UGDSA', 'SNBDSA', 'PSDSA', 'DSATE', 'PGDSATE'); 
       
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getStudRateMaxSession;  
   PROCEDURE setothermaximums (
      disab_basic_max_in       IN       VARCHAR2,
      disab_non_med_max_in     IN       VARCHAR2,
      disab_equip_max_in       IN       VARCHAR2,
      disab_trav_max_in        IN       VARCHAR2,
      stud_rate_id_in          IN       VARCHAR2,
      user_in                  IN       VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   )
   IS      
   BEGIN
    
      UPDATE stud_rate 
         SET  DISAB_BASIC_MAX = disab_basic_max_in,
              DISAB_NON_MED_MAX = disab_non_med_max_in,
              DISAB_EQUIP_MAX = disab_equip_max_in,
              DISAB_TRAV_MAX = disab_trav_max_in,
              last_updated_by = UPPER (user_in),
              last_updated_on = SYSDATE
       WHERE STUD_RATE_ID = stud_rate_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setothermaximums;             
END pk_steps_ui_maintaindsaallow;
/
