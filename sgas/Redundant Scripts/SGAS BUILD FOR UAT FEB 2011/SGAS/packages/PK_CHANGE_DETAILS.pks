CREATE OR REPLACE PACKAGE sgas.pk_change_details
/*
 * Package code required for STEPS Change of Details processing
 *
 * Modification history:
 * 06.02.2007 Initial Version   Robert Hunter
 *
 */
IS
   PROCEDURE pull_web_changes;

   PROCEDURE steps_bank_change (p_stud_ref IN NUMBER, p_change_date IN DATE);

   PROCEDURE steps_home_change (p_stud_ref IN NUMBER, p_change_date IN DATE);

   PROCEDURE steps_loan_change (p_stud_ref IN NUMBER, p_change_date IN DATE);

   PROCEDURE steps_mail_change (p_stud_ref IN NUMBER, p_change_date IN DATE);

   PROCEDURE steps_name_change (p_stud_ref IN NUMBER, p_change_date IN DATE);

   PROCEDURE steps_other_change (p_stud_ref IN NUMBER, p_change_date IN DATE);

   PROCEDURE steps_term_change (p_stud_ref IN NUMBER, p_change_date IN DATE);

   FUNCTION f_which_database (p_stud_ref IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION f_cont1_exists (p_stud_ref IN NUMBER)
      RETURN BOOLEAN;

   FUNCTION f_cont2_exists (p_stud_ref IN NUMBER)
      RETURN BOOLEAN;

   PROCEDURE steps_change_of_details (
      p_stud_ref        IN       NUMBER,
      p_change_date     IN       DATE,
      p_change_type     IN       VARCHAR2,
      p_return_string   OUT      VARCHAR2
   );

   FUNCTION grass_change_of_details (
      p_stud_ref      IN   NUMBER,
      p_change_date   IN   DATE
   )
      RETURN VARCHAR2;

-- direct copy of
-- change_of_details_copy
-- contained within
-- transform package on Web
-- database (taken from
-- EBUST1 06-02-08)
--
-- RH 19/02/08
-- added input parameters
-- (p_stud_ref, p_change_date) to
-- parameterise function,
   PROCEDURE delete_web_change;
END pk_change_details;
/