/* Formatted on 22/10/2014 11:20:49 (QP5 v5.215.12089.38647) */
DROP TRIGGER SGAS.TRIG_SUSPEND_SS;

CREATE OR REPLACE TRIGGER SGAS.TRIG_SUSPEND_SS
   AFTER UPDATE OF session_suspend
   ON SGAS.STUD_SESSION
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   p_title          stud.title%TYPE;
   p_forenames      stud.forenames%TYPE;
   p_surname        stud.surname%TYPE;
   p_session_code   stud_crse_year.session_code%TYPE;
   p_scheme_type    stud_crse_year.scheme_type%TYPE;
   p_inst_name      stud_crse_year.inst_name%TYPE;
   p_crse_name      stud_crse_year.crse_name%TYPE;
BEGIN
   IF UPDATING
   THEN
      IF (:new.session_suspend = 'Y')
      THEN
         SELECT s.title, s.forenames, s.surname
           INTO p_title, p_forenames, p_surname
           FROM stud s
          WHERE s.stud_ref_no = :old.stud_ref_no;

         SELECT scy.session_code,
                scy.scheme_type,
                scy.inst_name,
                scy.crse_name
           INTO p_session_code,
                p_scheme_type,
                p_inst_name,
                p_crse_name
           FROM stud_crse_year scy
          WHERE     scy.stud_ref_no = :old.stud_ref_no
                AND SCY.SESSION_CODE = :old.session_code
                AND SCY.LATEST_CRSE_IND = 'Y';

         INSERT INTO SUSPEND
              VALUES (suspend_seq.NEXTVAL,
                      :OLD.stud_ref_no,
                      :NEW.last_updated_by,
                      :OLD.session_code,
                      SYSDATE,
                      'E',
                      :NEW.last_updated_on,
                      p_inst_name,
                      p_crse_name,
                      p_scheme_type,
                      p_title,
                      p_forenames,
                      p_surname);
      END IF;

      IF (:new.session_suspend = 'N')
      THEN
         DELETE FROM SUSPEND s
               WHERE     s.STUD_REF_NO = :old.stud_ref_no
                     AND s.suspend_level = 'E';
      END IF;
   END IF;
END;
/