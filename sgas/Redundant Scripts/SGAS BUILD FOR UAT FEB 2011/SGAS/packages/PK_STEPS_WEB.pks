CREATE OR REPLACE PACKAGE SGAS.pk_steps_web
IS
-- DESCRIPTION
-- ===========
-- Package contains any StePS/WEB related procedures
--
-- Modification History
-- Date                 Author      Ref    Desc
-- 09.07.2009          A.Bowman    001    Initial Creation of Package
-- 04.03.2010          A.Bowman    002    Proc Update_Web_Indicator no longer req'd this is now handled by pk_web_steps.auth_steps_students
--
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $
--
   PROCEDURE authenticate_student (
      p_stud_ref_no                NUMBER,
      p_web_user_id                VARCHAR2,
      error_message   OUT          VARCHAR2
   );
   PROCEDURE dla_requests (error_message OUT VARCHAR2);
   PROCEDURE password_letter_requests (error_message OUT VARCHAR2);
END pk_steps_web;
/