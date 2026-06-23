CREATE OR REPLACE PACKAGE SGAS.pk_change_details
/*
 * Package code required for STEPS Change of Details processing
 *
 * Modification history:
 * 06.02.2007 Initial Version   Robert Hunter
 *
 */
IS
   PROCEDURE pull_web_changes;
   
   PROCEDURE steps_change_of_details (
      p_stud_ref        IN       NUMBER,
      p_user_id         IN       VARCHAR2,
      p_change_date     IN       DATE,
      p_change_type     IN       VARCHAR2,
      p_return_string   OUT      VARCHAR2
   );

   PROCEDURE steps_bank_change (p_stud_ref IN NUMBER, p_change_date IN DATE);
   
   PROCEDURE steps_mail_change (p_stud_ref IN NUMBER, p_change_date IN DATE, p_user_id VARCHAR2);
   
   PROCEDURE steps_phone_change (p_stud_ref IN NUMBER, p_change_date IN DATE, p_user_id VARCHAR2);

   PROCEDURE steps_home_change (p_stud_ref IN NUMBER, p_change_date IN DATE, p_user_id VARCHAR2);

   PROCEDURE steps_loan_change (p_stud_ref IN NUMBER, p_change_date IN DATE);

   PROCEDURE steps_personal_change (p_stud_ref IN NUMBER, p_change_date IN DATE);

   PROCEDURE steps_term_change (p_stud_ref IN NUMBER, p_change_date IN DATE);

   PROCEDURE steps_course_change (p_stud_ref IN NUMBER, p_change_date IN DATE);

   FUNCTION f_cont1_exists (p_stud_ref IN NUMBER)
      RETURN BOOLEAN;

   FUNCTION f_cont2_exists (p_stud_ref IN NUMBER)
      RETURN BOOLEAN;
   FUNCTION part_time_and_full_time(p_web_user_id IN VARCHAR2)
     RETURN BOOLEAN;  
     
   FUNCTION part_time_or_full_time(p_web_user_id IN VARCHAR2)
     RETURN VARCHAR2; 

   PROCEDURE addr_fix (
      p_house_no_name   IN              VARCHAR2,
      p_addr_l1         IN              VARCHAR2,
      p_addr_l2         IN              VARCHAR2,
      p_addr_l3         IN              VARCHAR2,
      p_addr_l4         IN              VARCHAR2,
      v_house_no_name_updated   OUT NOCOPY      VARCHAR2,
      v_addr_l1_updated         OUT NOCOPY      VARCHAR2,
      v_addr_l2_updated         OUT NOCOPY      VARCHAR2,
      v_addr_l3_updated         OUT NOCOPY      VARCHAR2,
      v_addr_l4_updated         OUT NOCOPY      VARCHAR2
   );


END pk_change_details;
/
