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

CREATE OR REPLACE TRIGGER SGAS.stcy_iud
 AFTER INSERT OR DELETE OR UPDATE OF sal_sent, application_status, inst_change, parent_contrib_exempt,
             award, start_date, withdraw_date, vacation, crse_chg,study_country, snb_grad, award_letter_date, 
             award_letter_no, batch_recalc, dearing, resid_par_cont, 
             resid_spouse_cont,resid_stud_cont, parent_cont, spouse_cont, stud_cont,resid_trav_allow, sml_equip_rqst, 
             sml_equip_approve,lge_equip_descript,lge_equip_approve, lge_equip_rqst, diet_need_descript,disablement_code,
             end_date_abroad,erasmus, diet_need_req,diet_need_approve, non_med_req, 
             non_med_approve,provisional_case,provisional_date,repeat_year, req_dup, session_code, crse_year_no, inst_code, crse_id,
             unconditional, slc1_status, slc2_status,loan_given,latest_crse_ind,auto_calc_date,dsa_fee_descript,dsa_fee_rqst,
             dsa_fee_approve,attend_reqd, attend_confirmed,hei_date_attended, non_att_actioned, non_att_actioned_date, 
             trav_submitted_date,sal_sent_date, sal_dest, variable_fee_override_amount, fee_loan_given, fee_loan_eligibility_only,
             pgce, self_funding, independent, due_ysb_yso_ind, household_resid_income, ben1_total_income, ben2_total_income,
             snb_single_rate, nmsb_session_calc,start_date_abroad, study_abroad, unpaid_sandwich, paid_sandwich, calc_fee, calc_bursary,
             calc_loan, calc_dep_grant, calc_lpg, calc_lpcg, pay_ysb, pgce_edu_level, pgce_subject, first_calc_date, psas_pt, crse_suspend,crse_code,crse_name,last_updated_by
   ON SGAS.STUD_CRSE_YEAR    FOR EACH ROW
DECLARE
   p_aud_date            DATE                                    := SYSDATE;
   p_column_name         stud_crse_year_aud.column_name%TYPE     := NULL;
   p_table_pkey1         stud_crse_year_aud.table_pkey1%TYPE
                                          := TO_CHAR (:OLD.stud_crse_year_id);
   p_table_pkey2         stud_crse_year_aud.table_pkey2%TYPE     := NULL;
   p_table_pkey3         stud_crse_year_aud.table_pkey3%TYPE     := NULL;
   p_table_pkey4         stud_crse_year_aud.table_pkey4%TYPE     := NULL;
   p_table_pkey5         stud_crse_year_aud.table_pkey5%TYPE     := NULL;
   p_old                 stud_crse_year_aud.OLD%TYPE             := NULL;
   p_new                 stud_crse_year_aud.NEW%TYPE             := NULL;
   p_action              stud_crse_year_aud.action%TYPE          := NULL;
   p_username            stud_crse_year_aud.username%TYPE
                                                      := :NEW.last_updated_by;
   p_stud_ref_no         stud_crse_year_aud.stud_ref_no%TYPE     := NULL;
   p_inst_code           stud_crse_year_aud.inst_code%TYPE       := NULL;
   p_table_name          VARCHAR2 (32)                    := 'STUD_CRSE_YEAR';
   will_update           VARCHAR2 (1)                            := 'N';
   p_session_code        stud_crse_year.session_code%TYPE
                                                         := :NEW.session_code;
   p_dob                 stud.dob%TYPE                           := NULL;
   p_initials            stud.initials%TYPE                      := NULL;
   p_forenames           stud.forenames%TYPE                     := NULL;
   p_surname             stud.surname%TYPE                       := NULL;
   p_ni_no               stud.ni_no%TYPE                         := NULL;
   p_mobile              stud.mobile_tel_no%TYPE                 := NULL;
   p_email               stud.email_addr%TYPE                    := NULL;
   p_calc                DATE;
   p_sent                DATE;
   p_stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE   := NULL;
   v_updated             VARCHAR2 (1)                            := 'N';
   v_chngd               VARCHAR2 (1)                            := 'N';
--
-----------------------------------------------------------------------------------------------------------------------------
--
   v_result              VARCHAR2 (1);
   v_default_date        DATE       := TO_DATE ('01/JAN/2000', 'DD/MON/YYYY');
    --
-----------------------------------------------------------------------------------------------------------------------------
--
--
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
      --
      -- TR 190 fix.
      -- Set P_SESSION_CODE to :OLD.SESSION_CODE as :NEW.SESSION_CODE will not
      -- exist.
      --
      p_session_code := :OLD.session_code;

      --
      -- End of TR 190 fix.
      --
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
      p_table_pkey1 := :NEW.stud_crse_year_id;
      p_dob := NULL;
      p_initials := NULL;
      p_forenames := NULL;
      p_surname := NULL;
      p_ni_no := NULL;
      p_mobile := NULL;
      p_email := NULL;
      p_calc := :NEW.auto_calc_date;
      p_sent := :NEW.sal_sent_date;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   
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
      ELSIF (NVL (:OLD.withdraw_date, '01/JAN/1900') <> NVL (:NEW.withdraw_date, '01/JAN/1900'))
      THEN
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.study_abroad, ' ') <> NVL (:NEW.study_abroad, ' '))
      THEN
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.paid_sandwich, ' ') <> NVL (:NEW.paid_sandwich, ' '))
      THEN
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.unpaid_sandwich, ' ') <> NVL (:NEW.unpaid_sandwich, ' '))
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

   p_column_name := 'SAL_SENT';
   p_old := :OLD.sal_sent;
   p_new := :NEW.sal_sent;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'APPLICATION_STATUS';
   p_old := :OLD.application_status;
   p_new := :NEW.application_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'INST_CHANGE';
   p_old := :OLD.inst_change;
   p_new := :NEW.inst_change;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PARENT_CONTRIB_EXEMPT';
   p_old := :OLD.parent_contrib_exempt;
   p_new := :NEW.parent_contrib_exempt;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AWARD';
   p_old := :OLD.award;
   p_new := :NEW.award;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'START_DATE';
   p_old := TO_CHAR (:OLD.start_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.start_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'WITHDRAW_DATE';
   p_old := TO_CHAR (:OLD.withdraw_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.withdraw_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'VACATION';
   p_old := TO_CHAR (:OLD.vacation);
   p_new := TO_CHAR (:NEW.vacation);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_CHG';
   p_old := TO_CHAR (:OLD.crse_chg, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.crse_chg, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'STUDY_COUNTRY';
   p_old := TO_CHAR (:OLD.study_country);
   p_new := TO_CHAR (:NEW.study_country);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SNB_GRAD';
   p_old := :OLD.snb_grad;
   p_new := :NEW.snb_grad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AWARD_LETTER_DATE';
   p_old := :OLD.award_letter_date;
   p_new := :NEW.award_letter_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AWARD_LETTER_NO';
   p_old := :OLD.award_letter_no;
   p_new := :NEW.award_letter_no;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'BATCH_RECALC';
   p_old := :OLD.batch_recalc;
   p_new := :NEW.batch_recalc;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DEARING';
   p_old := :OLD.dearing;
   p_new := :NEW.dearing;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_PAR_CONT';
   p_old := TO_CHAR (:OLD.resid_par_cont);
   p_new := TO_CHAR (:NEW.resid_par_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_SPOUSE_CONT';
   p_old := TO_CHAR (:OLD.resid_spouse_cont);
   p_new := TO_CHAR (:NEW.resid_spouse_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_STUD_CONT';
   p_old := TO_CHAR (:OLD.resid_stud_cont);
   p_new := TO_CHAR (:NEW.resid_stud_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PARENT_CONT';
   p_old := TO_CHAR (:OLD.parent_cont);
   p_new := TO_CHAR (:NEW.parent_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SPOUSE_CONT';
   p_old := TO_CHAR (:OLD.spouse_cont);
   p_new := TO_CHAR (:NEW.spouse_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'STUD_CONT';
   p_old := TO_CHAR (:OLD.stud_cont);
   p_new := TO_CHAR (:NEW.stud_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_TRAV_ALLOW';
   p_old := TO_CHAR (:OLD.resid_trav_allow);
   p_new := TO_CHAR (:NEW.resid_trav_allow);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SML_EQUIP_RQST';
   p_old := TO_CHAR (:OLD.sml_equip_rqst);
   p_new := TO_CHAR (:NEW.sml_equip_rqst);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SML_EQUIP_APPROVE';
   p_old := TO_CHAR (:OLD.sml_equip_approve);
   p_new := TO_CHAR (:NEW.sml_equip_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LGE_EQUIP_DESCRIPT';
   p_old := TO_CHAR (:OLD.lge_equip_descript);
   p_new := TO_CHAR (:NEW.lge_equip_descript);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LGE_EQUIP_APPROVE';
   p_old := TO_CHAR (:OLD.lge_equip_approve);
   p_new := TO_CHAR (:NEW.lge_equip_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LGE_EQUIP_RQST';
   p_old := TO_CHAR (:OLD.lge_equip_rqst);
   p_new := TO_CHAR (:NEW.lge_equip_rqst);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DIET_NEED_DESCRIPT';
   p_old := TO_CHAR (:OLD.diet_need_descript);
   p_new := TO_CHAR (:NEW.diet_need_descript);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DISABLEMENT_CODE';
   p_old := TO_CHAR (:OLD.disablement_code);
   p_new := TO_CHAR (:NEW.disablement_code);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'END_DATE_ABROAD';
   p_old := :OLD.end_date_abroad;
   p_new := :NEW.end_date_abroad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'ERASMUS';
   p_old := :OLD.erasmus;
   p_new := :NEW.erasmus;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DIET_NEED_REQ';
   p_old := TO_CHAR (:OLD.diet_need_req);
   p_new := TO_CHAR (:NEW.diet_need_req);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DIET_NEED_APPROVE';
   p_old := TO_CHAR (:OLD.diet_need_approve);
   p_new := TO_CHAR (:NEW.diet_need_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'NON_MED_REQ';
   p_old := TO_CHAR (:OLD.non_med_req);
   p_new := TO_CHAR (:NEW.non_med_req);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'NON_MED_APPROVE';
   p_old := TO_CHAR (:OLD.non_med_approve);
   p_new := TO_CHAR (:NEW.non_med_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PROVISIONAL_CASE';
   p_old := :OLD.provisional_case;
   p_new := :NEW.provisional_case;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PROVISIONAL_DATE';
   p_old := :OLD.provisional_date;
   p_new := :NEW.provisional_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'REPEAT_YEAR';
   p_old := :OLD.repeat_year;
   p_new := :NEW.repeat_year;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'REQ_DUP';
   p_old := :OLD.req_dup;
   p_new := :NEW.req_dup;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SESSION_CODE';
   p_old := :OLD.session_code;
   p_new := :NEW.session_code;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_YEAR_NO';
   p_old := :OLD.crse_year_no;
   p_new := :NEW.crse_year_no;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'INST_CODE';
   p_old := :OLD.inst_code;
   p_new := :NEW.inst_code;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_ID';
   p_old := :OLD.crse_id;
   p_new := :NEW.crse_id;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'UNCONDITIONAL';
   p_old := :OLD.unconditional;
   p_new := :NEW.unconditional;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SLC1_STATUS';
   p_old := :OLD.slc1_status;
   p_new := :NEW.slc1_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SLC2_STATUS';
   p_old := :OLD.slc2_status;
   p_new := :NEW.slc2_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LOAN_GIVEN';
   p_old := :OLD.loan_given;
   p_new := :NEW.loan_given;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LATEST_CRSE_IND';
   p_old := :OLD.latest_crse_ind;
   p_new := :NEW.latest_crse_ind;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AUTO_CALC_DATE';
   p_old := :OLD.auto_calc_date;
   p_new := :NEW.auto_calc_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   -- RFC 112 addition
   --
   p_column_name := 'DSA_FEE_DESCRIPT';
   p_old := :OLD.dsa_fee_descript;
   p_new := :NEW.dsa_fee_descript;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DSA_FEE_RQST';
   p_old := :OLD.dsa_fee_rqst;
   p_new := :NEW.dsa_fee_rqst;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DSA_FEE_APPROVE';
   p_old := :OLD.dsa_fee_approve;
   p_new := :NEW.dsa_fee_approve;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   -- END OF RFC 112 addition
   --
   -- RFC 113b Janis 28/06/04
   --
   p_column_name := 'ATTEND_REQD';
   p_old := :OLD.attend_reqd;
   p_new := :NEW.attend_reqd;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   -- End rfc 113b
   --
   -- RFC 113c MT 05/07/04
   --
   p_column_name := 'ATTEND_CONFIRMED';
   p_old := :OLD.attend_confirmed;
   p_new := :NEW.attend_confirmed;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'HEI_DATE_ATTENDED';
   p_old := :OLD.hei_date_attended;
   p_new := :NEW.hei_date_attended;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'NON_ATT_ACTIONED';
   p_old := :OLD.non_att_actioned;
   p_new := :NEW.non_att_actioned;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'NON_ATT_ACTIONED_DATE';
   p_old := :OLD.non_att_actioned_date;
   p_new := :NEW.non_att_actioned_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'TRAV_SUBMITTED_DATE';
   p_old := :OLD.trav_submitted_date;
   p_new := :NEW.trav_submitted_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SAL_SENT_DATE';
   p_old := :OLD.sal_sent_date;
   p_new := :NEW.sal_sent_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SAL_DEST';
   p_old := :OLD.sal_dest;
   p_new := :NEW.sal_dest;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
--- RFC188
   p_column_name := 'VARIABLE_FEE_OVERRIDE_AMOUNT';
   p_old := :OLD.variable_fee_override_amount;
   p_new := :NEW.variable_fee_override_amount;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'FEE_LOAN_GIVEN';
   p_old := :OLD.fee_loan_given;
   p_new := :NEW.fee_loan_given;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'FEE_LOAN_ELIGIBILITY_ONLY';
   p_old := :OLD.fee_loan_eligibility_only;
   p_new := :NEW.fee_loan_eligibility_only;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'PGCE';
   p_old := :OLD.pgce;
   p_new := :NEW.pgce;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'SELF_FUNDING';
   p_old := :OLD.self_funding;
   p_new := :NEW.self_funding;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'INDEPENDENT';
   p_old := :OLD.independent;
   p_new := :NEW.independent;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'DUE_YSB_YSO_IND';
   p_old := :OLD.due_ysb_yso_ind;
   p_new := :NEW.due_ysb_yso_ind;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
--END OF RFC188
-- RFC204
   p_column_name := 'HOUSEHOLD_RESID_INCOME';
   p_old := :OLD.household_resid_income;
   p_new := :NEW.household_resid_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'BEN1_TOTAL_INCOME';
   p_old := :OLD.ben1_total_income;
   p_new := :NEW.ben1_total_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'BEN2_TOTAL_INCOME';
   p_old := :OLD.ben2_total_income;
   p_new := :NEW.ben2_total_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
-- RFC204

   --RFC 222
   p_column_name := 'SNB_SINGLE_RATE';
   p_old := :OLD.snb_single_rate;
   p_new := :NEW.snb_single_rate;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
--RFC 222
   p_column_name := 'NMSB_SESSION_CALC';
   p_old := :OLD.nmsb_session_calc;
   p_new := :NEW.nmsb_session_calc;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'START_DATE_ABROAD';
   p_old := TO_CHAR (:OLD.start_date_abroad, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.start_date_abroad, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'STUDY_ABROAD';
   p_old := :OLD.study_abroad;
   p_new := :NEW.study_abroad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'UNPAID_SANDWICH';
   p_old := :OLD.unpaid_sandwich;
   p_new := :NEW.unpaid_sandwich;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PAID_SANDWICH';
   p_old := :OLD.paid_sandwich;
   p_new := :NEW.paid_sandwich;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_FEE';
   p_old := :OLD.calc_fee;
   p_new := :NEW.calc_fee;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_BURSARY';
   p_old := :OLD.calc_bursary;
   p_new := :NEW.calc_bursary;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_LOAN';
   p_old := :OLD.calc_loan;
   p_new := :NEW.calc_loan;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_DEP_GRANT';
   p_old := :OLD.calc_dep_grant;
   p_new := :NEW.calc_dep_grant;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_LPG';
   p_old := :OLD.calc_lpg;
   p_new := :NEW.calc_lpg;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_LPCG';
   p_old := :OLD.calc_lpcg;
   p_new := :NEW.calc_lpcg;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PAY_YSB';
   p_old := :OLD.pay_ysb;
   p_new := :NEW.pay_ysb;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PGCE_EDU_LEVEL';
   p_old := :OLD.pgce_edu_level;
   p_new := :NEW.pgce_edu_level;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PGCE_SUBJECT';
   p_old := :OLD.pgce_subject;
   p_new := :NEW.pgce_subject;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'FIRST_CALC_DATE';
   p_old := :OLD.first_calc_date;
   p_new := :NEW.first_calc_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PSAS_PT';
   p_old := :OLD.psas_pt;
   p_new := :NEW.psas_pt;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_SUSPEND';
   p_old := :OLD.crse_suspend;
   p_new := :NEW.crse_suspend;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_CODE';
   p_old := :OLD.crse_code;
   p_new := :NEW.crse_code;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_NAME';
   p_old := :OLD.crse_name;
   p_new := :NEW.crse_name;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   /*p_column_name := 'REG_CONFIRMED';
   p_old := :OLD.reg_confirmed;
   p_new := :NEW.reg_confirmed;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'ONGOING_ATTEND';
   p_old := :OLD.ongoing_attend;
   p_new := :NEW.ongoing_attend;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );*/
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
    --
/* Telephony Auditing PB Feb 2005*/
    --
   p_column_name := 'DATE_LAST_CALCULATED';
   p_old := :OLD.auto_calc_date;
   p_new := :NEW.auto_calc_date;

   IF NVL (:OLD.auto_calc_date, '01/JAN/1900') <>
                                      NVL (:NEW.auto_calc_date, '01/JAN/1900')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'DATE_LAST_AWARD_LETTER_ISSUED';
   p_old := :OLD.sal_sent_date;
   p_new := :NEW.sal_sent_date;

   IF NVL (:OLD.sal_sent_date, '01/JAN/1900') <>
                                       NVL (:NEW.sal_sent_date, '01/JAN/1900')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'SAL_DEST';
   p_old := :OLD.sal_dest;
   p_new := :NEW.sal_dest;

   IF NVL (:OLD.sal_dest, 'X') <> NVL (:NEW.sal_dest, 'X')
   THEN
      v_updated := 'Y';
   END IF;

   --
   IF v_updated = 'Y'
   THEN
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   END IF;
END stcy_iud;
SHOW ERRORS;

