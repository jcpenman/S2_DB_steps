/* Formatted on 22/10/2014 11:21:50 (QP5 v5.215.12089.38647) */
DROP TRIGGER SGAS.TRIG_SUSPEND_STUD;

CREATE OR REPLACE TRIGGER SGAS.TRIG_SUSPEND_STUD
   AFTER UPDATE OF stud_suspend
   ON SGAS.STUD
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   p_stud_ref_no    stud.stud_ref_no%TYPE := :OLD.stud_ref_no;
   p_session_code   stud_crse_year.session_code%TYPE;
   p_scheme_type    stud_crse_year.scheme_type%TYPE;
   p_inst_name      stud_crse_year.inst_name%TYPE;
   p_crse_name      stud_crse_year.crse_name%TYPE;
BEGIN
   IF UPDATING
   THEN
      IF (:new.stud_suspend = 'Y')
      THEN
         SELECT MAX (session_code)
           INTO p_session_code
           FROM stud_crse_year
          WHERE stud_ref_no = :old.stud_ref_no AND latest_crse_ind = 'Y';

         SELECT scy.scheme_type, scy.inst_name, scy.crse_name
           INTO p_scheme_type, p_inst_name, p_crse_name
           FROM stud_crse_year scy
          WHERE     scy.stud_ref_no = p_stud_ref_no
                AND SCY.SESSION_CODE = p_session_code
                AND SCY.LATEST_CRSE_IND = 'Y';

         INSERT INTO SUSPEND
              VALUES (suspend_seq.NEXTVAL,
                      :OLD.stud_ref_no,
                      :NEW.last_updated_by,
                      p_session_code,
                      SYSDATE,
                      'S',
                      :NEW.last_updated_on,
                      p_inst_name,
                      p_crse_name,
                      p_scheme_type,
                      :old.title,
                      :old.forenames,
                      :old.surname);
      END IF;

      IF (:new.stud_suspend = 'N')
      THEN
         DELETE FROM SUSPEND s
               WHERE     s.STUD_REF_NO = :old.stud_ref_no
                     AND s.suspend_level = 'S';
      END IF;
   END IF;
END;
/