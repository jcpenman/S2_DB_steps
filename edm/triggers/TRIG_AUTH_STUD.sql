CREATE OR REPLACE TRIGGER EDM.trig_auth_stud
   AFTER INSERT
   ON EDM.RAW_DATA    REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   p_web_user_id   raw_data.web_user_id%TYPE   := :NEW.web_user_id;
   p_stud_ref_no   raw_data.stud_ref_no%TYPE   := :NEW.stud_ref_no;
   error_message   VARCHAR2 (512);
/******************************************************************************
NAME: TRIG_AUTH_STUD
PURPOSE: After Insert trigger on EDM.RAW_DATA to authenticate student

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        14.07.2009  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $
$Author:  $
$Date:  $
$Revision:  $

*******************************************************************************/
BEGIN


   IF p_stud_ref_no IS NOT NULL AND p_web_user_id IS NOT NULL
   THEN
      pk_steps_web.authenticate_student (:NEW.stud_ref_no,
                                         :NEW.web_user_id,
                                         error_message
                                        );

      IF (error_message IS NOT NULL)
      THEN
         raise_application_error
                              (-20000,
                                  'pk_steps_web.authenticate_student error: '
                               || error_message
                              );
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20000,
                               'TRIG_AUTH_STUD error: ' || SQLERRM || SQLCODE
                              );
END trig_auth_stud;
/
