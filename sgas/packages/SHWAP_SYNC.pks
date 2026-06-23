CREATE OR REPLACE PACKAGE SGAS.SHWAP_SYNC
IS
   --
   TYPE cwa_type IS RECORD
   (
      app_id          applications_made.application_id@web%TYPE,
      app_type        complete_web_applications.application_type@web%TYPE,
      object_id       complete_web_applications.object_id@web%TYPE,
      stud_ref_no     shwap.stud_ref_no%TYPE,
      web_user_id     shwap.stud_web_user_id%TYPE,
      title           shwap.stud_title%TYPE,
      forenames       shwap.stud_forenames%TYPE,
      surname         shwap.stud_surname%TYPE,
      email_addr      shwap.stud_email_addr%TYPE,
      house_no_name   shwap.stud_house_no_name%TYPE,
      addr_l1         shwap.stud_addr_l1%TYPE,
      sub_date        complete_web_applications.web_submitted@web%TYPE,
      session_code    complete_web_applications.session_code@web%TYPE,
      sex             stud.sex%TYPE,
      dob             stud.dob%TYPE,
      error_mess      VARCHAR2 (1),
      error_status    VARCHAR2 (1024)
   );

   --

   PROCEDURE initialise_records (p_cwa_rec IN OUT cwa_type);

   --
   FUNCTION insert_shwap_error (p_cwa_rec IN cwa_type)
      RETURN BOOLEAN;

   --
   FUNCTION deleteCWA (p_app_id IN applications_made.application_id@web%TYPE)
      RETURN BOOLEAN;

   --
   FUNCTION update_Apps_Made (
      p_app_id   IN applications_made.application_id@web%TYPE,
      p_status   IN applications_made.status@web%TYPE)
      RETURN BOOLEAN;

   --
   FUNCTION data_transfer (p_app_type       IN VARCHAR2,
                           p_session_code   IN VARCHAR2)
      RETURN VARCHAR2;

   --
   FUNCTION get_cwa (
      p_cwa_rec   IN OUT cwa_type,
      p_app_id    IN     complete_web_applications.application_id@web%TYPE)
      RETURN BOOLEAN;

   --
   FUNCTION insert_cs (p_cwa_rec IN OUT cwa_type)
      RETURN VARCHAR2;
--
END;                                                -- SHWAP_SYNC Package spec
/