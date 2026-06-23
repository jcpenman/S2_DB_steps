ALTER TABLE SGAS.attendance_data
 ADD ATTENDANCE_OVERRIDE varchar2(1) Default 'N';

ALTER TABLE SGAS.attendance_data
 ADD NO_TRACE varchar2(1) Default 'N';

ALTER TABLE SGAS.attendance_data_received DROP CONSTRAINT ATT_DATA_REC;

ALTER TABLE SGAS.attendance_data_received ADD (
  CONSTRAINT ATT_DATA_REC
 CHECK (status in ('T','E','A','W','N','R','C','P','X','O')));

INSERT INTO ATTENDANCE_DATA_STATUS ( STATUS_CODE, STATUS_DESCRIPTION, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'T', 'Non Attendance No Trace Notification', 'SGAS',  sysdate); 
COMMIT;

/* Formatted on 2012/06/26 15:02 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER sgas.stcy_aiu
   AFTER INSERT OR DELETE OR UPDATE OF auto_calc_date,
                                       sal_sent_date,
                                       session_code,
                                       crse_year_no,
                                       inst_code,
                                       crse_id,
                                       crse_code,
                                       crse_name,
                                       crse_suspend,
                                       repeat_year,
                                       application_status,
                                       sal_sent,
                                       withdraw_date,
                                       latest_crse_ind,
                                       slc2_status,
                                       slc2_sent,
                                       slc2_sent_date,
                                       entered_date,
                                       study_abroad,
                                       paid_sandwich,
                                       unpaid_sandwich
   ON sgas.stud_crse_year
   FOR EACH ROW
DECLARE
   p_action              audit_staging.action%TYPE               := NULL;
   p_username            audit_staging.username%TYPE  := :NEW.last_updated_by;
   p_stud_ref_no         stud_crse_year.stud_ref_no%TYPE         := NULL;
   p_inst_code           stud_crse_year.inst_code%TYPE           := NULL;
   p_session_code        stud_crse_year.session_code%TYPE
                                                         := :NEW.session_code;
   p_stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE   := NULL;
   will_update           VARCHAR2 (1)                            := 'N';
   v_chngd               VARCHAR2 (1)                            := 'N';
   v_result              VARCHAR2 (1);
   v_default_date        DATE       := TO_DATE ('01/JAN/2000', 'DD/MON/YYYY');
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
      p_session_code := :OLD.session_code;

      IF maintain_repository.latest_stud_crse_year (:OLD.stud_ref_no,
                                                    :OLD.session_code,
                                                    :OLD.latest_crse_ind
                                                   ) = 'Y'
      THEN
         v_result :=
            maintain_repository.record_app_status (:OLD.stud_ref_no,
                                                   'D',
                                                   :OLD.stud_crse_year_id,
                                                   SYSDATE
                                                  );
      END IF;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
      p_stud_crse_year_id := :NEW.stud_crse_year_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';

      IF :OLD.session_code <> :NEW.session_code
      THEN
         will_update := 'Y';
      ELSIF (NVL (:OLD.crse_year_no, '0') <> NVL (:NEW.crse_year_no, '0'))
      THEN
         will_update := 'Y';
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.inst_code, ' ') <> NVL (:NEW.inst_code, ' '))
      THEN
         will_update := 'Y';
      ELSIF :OLD.crse_id <> :NEW.crse_id
      THEN
         will_update := 'Y';
         v_chngd := 'Y';
      ELSIF :OLD.crse_code <> :NEW.crse_code
      THEN
         v_chngd := 'Y';
      ELSIF :OLD.crse_name <> :NEW.crse_name
      THEN
         v_chngd := 'Y';
      ELSIF :OLD.crse_suspend <> :NEW.crse_suspend
      THEN
         v_chngd := 'Y';
      ELSIF :OLD.repeat_year <> :NEW.repeat_year
      THEN
         v_chngd := 'Y';
      ELSIF :OLD.application_status <> :NEW.application_status
      THEN
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.withdraw_date, '01/JAN/1900') <>
                                       NVL (:NEW.withdraw_date, '01/JAN/1900')
            )
      THEN
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.study_abroad, ' ') <> NVL (:NEW.study_abroad, ' '))
      THEN
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.paid_sandwich, ' ') <> NVL (:NEW.paid_sandwich, ' '))
      THEN
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.unpaid_sandwich, ' ') <>
                                               NVL (:NEW.unpaid_sandwich, ' ')
            )
      THEN
         v_chngd := 'Y';
      END IF;

      IF v_chngd = 'Y'
      THEN
         p_stud_crse_year_id := :OLD.stud_crse_year_id;

         UPDATE attendance_data
            SET chngd_since_last_report = 'Y'
          WHERE stud_crse_year_id = p_stud_crse_year_id;
      END IF;

      IF will_update = 'Y'
      THEN
         pk_steps_changes.stud_crse_year_rep (:OLD.stud_crse_year_id,
                                              :NEW.session_code,
                                              :NEW.crse_year_no,
                                              :NEW.inst_code,
                                              :NEW.crse_id
                                             );
      END IF;

      /* check if a calculation has just been performed */
      IF NVL (:OLD.auto_calc_date, v_default_date) <>
                                     NVL (:NEW.auto_calc_date, v_default_date)
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be calculated */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'C',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.auto_calc_date
                                                     );
         END IF;
      END IF;

      /* check if the award letter has just been sent */
      IF NVL (:NEW.sal_sent, 'Y') = 'Y' AND NVL (:OLD.sal_sent, 'Y') = 'N'
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be letter issued */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'L',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.sal_sent_date
                                                     );
         END IF;
      END IF;

      /* check if the slc status (file 2) has been updated to sent */
      /* RAM SIR7 16/03/2004 */
      IF (   (    NVL (:OLD.slc2_status, 'A') <> NVL (:NEW.slc2_status, 'A')
              AND NVL (:NEW.slc2_status, 'A') = 'S'
             )
          OR (    NVL (:OLD.slc2_sent, 'A') <> NVL (:NEW.slc2_sent, 'A')
              AND NVL (:NEW.slc2_sent, 'A') = 'Y'
              AND NVL (:NEW.slc2_status, 'A') = 'S'
             )
         )
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be slc data sent */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'S',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.slc2_sent_date
                                                     );
         END IF;
      END IF;

      /* TR 1537 - check if the latest_crse_ind has been updated to 'Y' */
      IF :OLD.latest_crse_ind = 'N' AND :NEW.latest_crse_ind = 'Y'
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* create a new record as previous one has been deleted */
            v_result :=
               maintain_repository.create_app_status (:NEW.stud_ref_no,
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.session_code,
                                                      :NEW.entered_date,
                                                      :NEW.auto_calc_date,
                                                      :NEW.sal_sent_date,
                                                      :NEW.slc2_sent_date
                                                     );
         END IF;
      END IF;
   END IF;
END stcy_aiu;
SHOW ERRORS;

