CREATE OR REPLACE PACKAGE SGAS.pk_steps_utils
/*
 * Package code required for STEPS Utilities
 *
 *
 * Modification history:
 * 01.10.08 Add datediff() - Steve Durkin.
 * 30.09.2008 Add procedure set_steps_lock - Steve Durkin.
 * 18.12.2007 Initial Version   Robert Hunter
 *
 */
IS
   FUNCTION f_study_gap_exists (p_stud_ref IN NUMBER, p_session_code NUMBER)
      RETURN NUMBER;
      
   FUNCTION f_get_comm_yr (p_stud_ref IN NUMBER,p_session_code NUMBER)
      RETURN NUMBER;

   FUNCTION datediff( p_what IN VARCHAR2, 
                      p_d1   IN DATE, 
                      p_d2   IN DATE )
      RETURN NUMBER;

   PROCEDURE set_steps_lock (p_object_id varchar2, p_batch_id varchar2 
         ,p_lock_type1 IN steps_locks.lock_type%TYPE := NULL
         ,p_lock_combination1 IN steps_locks.combination%TYPE := NULL
         ,p_lock_type2 IN steps_locks.lock_type%TYPE := NULL
         ,p_lock_combination2 IN steps_locks.combination%TYPE := NULL
         ,p_lock_type3 IN steps_locks.lock_type%TYPE := NULL
         ,p_lock_combination3 IN steps_locks.combination%TYPE := NULL
         ,p_lock_type4 IN steps_locks.lock_type%TYPE := NULL
         ,p_lock_combination4 IN steps_locks.combination%TYPE := NULL
         ,p_lock_type5 IN steps_locks.lock_type%TYPE := NULL
         ,p_lock_combination5 IN steps_locks.combination%TYPE := NULL
         ,p_lock_type6 IN steps_locks.lock_type%TYPE := NULL
         ,p_lock_combination6 IN steps_locks.combination%TYPE := NULL
         ,p_lock_type7 IN steps_locks.lock_type%TYPE := NULL
         ,p_lock_combination7 IN steps_locks.combination%TYPE := NULL
         ,p_lock_type8 IN steps_locks.lock_type%TYPE := NULL
         ,p_lock_combination8 IN steps_locks.combination%TYPE := NULL
         
      ,p_msg OUT VARCHAR2
      ,p_lock_age OUT NUMBER
      ,p_status OUT VARCHAR2
   );

END pk_steps_utils;
/
