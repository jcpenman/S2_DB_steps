/* Formatted on 22/10/2014 11:18:03 (QP5 v5.215.12089.38647) */
CREATE OR REPLACE TRIGGER SGAS.TRIG_SUSPEND_SCY
   AFTER UPDATE OF CRSE_SUSPEND
   ON SGAS.STUD_CRSE_YEAR
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   p_title          stud.title%TYPE;
   p_forenames      stud.forenames%TYPE;
   p_surname        stud.surname%TYPE;
   p_session_code   stud_crse_year.session_code%TYPE;
BEGIN
   IF UPDATING
   THEN
      IF (:new.crse_suspend = 'Y')
      THEN
         -- get the caseworker's name
         SELECT cd.cval
           INTO p_session_code
           FROM config_data cd
          WHERE cd.item_name = 'CURRENT_SESSION';


         SELECT s.title, s.forenames, s.surname
           INTO p_title, p_forenames, p_surname
           FROM stud s
          WHERE s.stud_ref_no = :old.stud_ref_no;


         INSERT INTO SUSPEND
              VALUES (suspend_seq.NEXTVAL,
                      :OLD.stud_ref_no,
                      :NEW.last_updated_by,
                      :OLD.session_code,
                      SYSDATE,
                      'C',
                      :NEW.last_updated_on,
                      :OLD.inst_name,
                      :OLD.crse_name,
                      :OLD.scheme_type,
                      p_title,
                      p_forenames,
                      p_surname);
      END IF;

      IF (:new.crse_suspend = 'N')
      THEN
         DELETE FROM SUSPEND s
               WHERE     s.STUD_REF_NO = :old.stud_ref_no
                     AND s.suspend_level = 'C';
      END IF;
   END IF;
END;
/