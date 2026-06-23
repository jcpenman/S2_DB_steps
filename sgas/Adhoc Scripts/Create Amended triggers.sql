-- Create amended triggers
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      18.05.10    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

--BE_AU
--STH_AIU

CREATE OR REPLACE TRIGGER SGAS.BE_AU
after  update of TITLE, INITIALS, FORENAMES, SURNAME, HOUSE_NO_NAME, ADDR_L1, ADDR_L2,
                 ADDR_L3, ADDR_L4, POST_CODE, TELE_NO
        ON SGAS.BENEFACTOR for each row
declare
    P_BEN_ID          BENEFACTOR.BEN_ID%TYPE := :OLD.BEN_ID;
    P_TITLE           BENEFACTOR.TITLE%TYPE;
    P_INITIALS        BENEFACTOR.INITIALS%TYPE;
    P_FORENAMES       BENEFACTOR.FORENAMES%TYPE;
    P_SURNAME         BENEFACTOR.SURNAME%TYPE;
    P_HOUSE_NO_NAME   BENEFACTOR.HOUSE_NO_NAME%TYPE;
    P_ADDR_L1         BENEFACTOR.ADDR_L1%TYPE;
    P_ADDR_L2         BENEFACTOR.ADDR_L2%TYPE;
    P_ADDR_L3         BENEFACTOR.ADDR_L3%TYPE;
    P_ADDR_L4         BENEFACTOR.ADDR_L4%TYPE;
    P_POST_CODE       BENEFACTOR.POST_CODE%TYPE;
    P_TELE_NO         BENEFACTOR.TELE_NO%TYPE;
    P_ACTION          BENEFACTOR_AUD.ACTION%TYPE         := NULL;
    UPDATE_GRASS      VARCHAR2(1):= 'N';
        
begin
    if updating then
            P_ACTION      := 'U';
         IF (NVL(:OLD.TITLE,' ')  <> NVL(:NEW.TITLE,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.INITIALS,' ') <> NVL(:NEW.INITIALS,' ')) THEN
            UPDATE_GRASS := 'Y'; 
        ELSIF (NVL(:OLD.FORENAMES,' ') <> NVL(:NEW.FORENAMES,' ')) THEN
            UPDATE_GRASS := 'Y';   
        ELSIF (NVL(:OLD.SURNAME,' ') <> NVL(:NEW.SURNAME,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.HOUSE_NO_NAME,' ') <> NVL(:NEW.HOUSE_NO_NAME,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.ADDR_L1,' ') <> NVL(:NEW.ADDR_L1,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.ADDR_L2,' ') <> NVL(:NEW.ADDR_L2,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.ADDR_L3,' ') <> NVL(:NEW.ADDR_L3,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.ADDR_L4,' ') <> NVL(:NEW.ADDR_L4,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.POST_CODE,' ') <> NVL(:NEW.POST_CODE,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.TELE_NO,' ') <> NVL(:NEW.TELE_NO,' ')) THEN
            UPDATE_GRASS := 'Y';
        END IF;
         IF UPDATE_GRASS = 'Y' THEN
            PK_STEPS_TO_GRASS.UPDATE_BEN_IN_GRASS(:OLD.BEN_ID, :NEW.TITLE, :NEW.INITIALS, :NEW.FORENAMES,
                :NEW.SURNAME, :NEW.HOUSE_NO_NAME, :NEW.ADDR_L1, :NEW.ADDR_L2, :NEW.ADDR_L3,
                :NEW.ADDR_L4, :NEW.POST_CODE, :NEW.TELE_NO);
         END IF; 
            END IF;

    
end BE_AU;
/


CREATE OR REPLACE TRIGGER SGAS.sth_aiu
   AFTER INSERT
   ON SGAS.STUD_HOME_ADDR    FOR EACH ROW
DECLARE
   p_start_date    stud_home_addr.start_date%TYPE    := SYSDATE;
   p_action        stud_home_addr_aud.action%TYPE    := NULL;
   p_stud_ref_no   stud_home_addr.stud_ref_no%TYPE   := :NEW.stud_ref_no;
   update_grass    VARCHAR2 (1)                      := 'N';
   v_ben1          VARCHAR2 (1)                      := NULL;
   v_ben2          VARCHAR2 (1)                      := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';

      -- DBMS_OUTPUT.put_line ('*******TRIGGER SGAS.sth_aiu HAS FIRED*******');
      IF (NVL (:OLD.tele_no, ' ') <> NVL (:NEW.tele_no, ' '))
      THEN
         update_grass := 'Y';
      ELSIF (NVL (:OLD.house_no_name, ' ') <> NVL (:NEW.house_no_name, ' '))
      THEN
         update_grass := 'Y';
      ELSIF (NVL (:OLD.addr_l1, ' ') <> NVL (:NEW.addr_l1, ' '))
      THEN
         update_grass := 'Y';
      ELSIF (NVL (:OLD.addr_l2, ' ') <> NVL (:NEW.addr_l2, ' '))
      THEN
         update_grass := 'Y';
      ELSIF (NVL (:OLD.addr_l3, ' ') <> NVL (:NEW.addr_l3, ' '))
      THEN
         update_grass := 'Y';
      ELSIF (NVL (:OLD.addr_l4, ' ') <> NVL (:NEW.addr_l4, ' '))
      THEN
         update_grass := 'Y';
      ELSIF (NVL (:OLD.post_code, ' ') <> NVL (:NEW.post_code, ' '))
      THEN
         update_grass := 'Y';
      END IF;
   END IF;

    /*DBMS_OUTPUT.put_line
            (   '*******TRIGGER CALLING PK_STEPS_TO_GRASS.INSERT_SHA_IN_GRASS..UPDATE_GRASS='
             || update_grass
            ); */
   IF update_grass = 'Y'
   THEN
      pk_steps_to_grass.insert_sha_in_grass (p_stud_ref_no,
                                :NEW.tele_no,
                                :NEW.house_no_name,
                                :NEW.addr_l1,
                                :NEW.addr_l2,
                                :NEW.addr_l3,
                                :NEW.addr_l4,
                                :NEW.post_code,
                                p_start_date,
                                p_action
                               );
   END IF;

  -- dbms_output.put_line('*******TRIGGER3 HAS FIRED*******');
     /* Re-send student to the SLC */
   UPDATE stud_crse_year
      SET slc1_sent = 'N',
          slc2_sent = 'N'
    WHERE stud_crse_year_id =
             (SELECT MAX (stud_crse_year_id)
                FROM stud_crse_year
               WHERE stud_ref_no = :NEW.stud_ref_no
                 AND latest_crse_ind = 'Y'
                 AND first_slc1_sent_date IS NOT NULL);

 --   dbms_output.put_line('*******TRIGGER4 HAS FIRED*******');
   /* issue a new award letter */
   UPDATE stud_crse_year
      SET sal_sent = 'N',
          req_dup = 'Y'
    WHERE stud_crse_year_id =
             (SELECT MAX (stud_crse_year_id)
                FROM stud_crse_year
               WHERE stud_ref_no = :NEW.stud_ref_no
                 AND latest_crse_ind = 'Y'
                 AND sal_sent_date IS NOT NULL);

   --dbms_output.put_line('*******TRIGGER0 HAS FIRED*******');
   SELECT apply_to_ben_1, apply_to_ben_2
     INTO v_ben1, v_ben2
     FROM home_addr_change@web x
    WHERE stud_ref_no = :NEW.stud_ref_no
      AND TRUNC (change_date) = TRUNC (SYSDATE)
      AND change_date = (SELECT MAX (change_date)
                           FROM home_addr_change@web
                          WHERE stud_ref_no = :NEW.stud_ref_no);

   --dbms_output.put_line('*******TRIGGER5 HAS FIRED*******');
   IF v_ben1 = 'Y'
   THEN
      UPDATE benefactor
         SET house_no_name = :NEW.house_no_name,
             addr_l1 = :NEW.addr_l1,
             addr_l2 = :NEW.addr_l2,
             addr_l3 = :NEW.addr_l3,
             addr_l4 = :NEW.addr_l4,
             post_code = :NEW.post_code,
             mailsort = :NEW.mailsort
       WHERE ben_id = (SELECT MAX (ben1_id)
                         FROM stud_session
                        WHERE stud_ref_no = :NEW.stud_ref_no);
   END IF;

   --dbms_output.put_line('*******TRIGGER6 HAS FIRED*******');
   IF v_ben2 = 'Y'
   THEN
      UPDATE benefactor
         SET house_no_name = :NEW.house_no_name,
             addr_l1 = :NEW.addr_l1,
             addr_l2 = :NEW.addr_l2,
             addr_l3 = :NEW.addr_l3,
             addr_l4 = :NEW.addr_l4,
             post_code = :NEW.post_code,
             mailsort = :NEW.mailsort
       WHERE ben_id = (SELECT MAX (ben2_id)
                         FROM stud_session
                        WHERE stud_ref_no = :NEW.stud_ref_no);
   END IF;
--dbms_output.put_line('*******TRIGGER7 HAS FIRED*******');
EXCEPTION
   WHEN OTHERS
   THEN
      v_ben1 := 'N';
      v_ben2 := 'N';
-- dbms_output.put_line('*******TRIGGER8 HAS FIRED*******');
END sth_aiu;
/