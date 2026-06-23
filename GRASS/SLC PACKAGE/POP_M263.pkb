CREATE OR REPLACE PACKAGE BODY SGAS.POP_M263 IS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- %Z%%Y% %M% %G% %U% %I%%Z%
--
-- DESCRIPTION
-- ===========
/* CHANGE HISTORY
Version Date         Author         Change 
1.3?    16/01/2008    R Hunter    Changes to SQL to include STEPS data in the production of SLC 1 and SLC 2 files
                    Changes marked /* RH 16/01/2008 START */ /* RH 16/01/2008 END */

function UpdFile1Flags (p_rep in varchar2, p_fname in varchar2, p_fdate in date)
      return integer is
---
  CURSOR csr_stcy_stud (p_fname in varchar2) IS
    SELECT stud_crse_year_id
    FROM   slc_data, config_data
    WHERE  slc_filename = p_fname
    and    form_type = 'SN'    --- File 1
    and    record_type = 'S'   --- student loan
    AND       config_data.item_name = 'SLC_MAX_FILESIZE'
    AND       rownum < config_data.nval + 1;
  --
    CURSOR csr_stcy_fee (p_fname in varchar2) IS
        SELECT sd.academic_year, s.stud_ref_no
        FROM   slc_data sd, stud s
        WHERE  slc_filename = p_fname
        and    form_type = 'SN'    --- File 1
        and    record_type = 'F'   --- fee loan
        and       sd.slc_ref_no = s.scottish_cand
        /* RH 16/01/2008 START */
        UNION
        SELECT sd.academic_year, s.stud_ref_no
        FROM   slc_data sd, steps_stud s
        WHERE  slc_filename = p_fname
        and    form_type = 'SN'    --- File 1
        and    record_type = 'F'   --- fee loan
        and    sd.slc_ref_no = s.scottish_cand;
        /* RH 16/01/2008 END */
  --
  l_stcy_id slc_data.stud_crse_year_id%TYPE;
  l_academic_year slc_data.academic_year%type;
  l_stud_ref_no stud.stud_ref_no%type;
  --
BEGIN
   ---DBMS_OUTPUT.PUT_LINE('Start of UpdFile1Flags... ' || sqlerrm);
    --- Update all student loan records in slc_data for this file 1.
   if not csr_stcy_stud%isopen then
      OPEN csr_stcy_stud (p_fname);
   end if;
---
  LOOP
    FETCH csr_stcy_stud INTO l_stcy_id;
    EXIT WHEN csr_stcy_stud%NOTFOUND;
    --
    UPDATE stud_crse_year
    SET    slc1_sent = 'Y',
       slc1_sent_date = sysdate,
       slc1_status = 'S'
    WHERE  stud_crse_year_id = l_stcy_id;
    --
    UPDATE stud_crse_year
    SET    first_slc1_sent_date = slc1_sent_date
    WHERE  stud_crse_year_id = l_stcy_id
    AND    first_slc1_sent_date IS NULL;
    --
    /* RH 16/01/2008 START */
    UPDATE steps_stud_crse_year
       SET slc1_sent = 'Y',
           slc1_sent_date = SYSDATE,
           slc1_status = 'S'
     WHERE stud_crse_year_id = l_stcy_id;
        --
    UPDATE steps_stud_crse_year
       SET first_slc1_sent_date = slc1_sent_date
     WHERE stud_crse_year_id = l_stcy_id AND first_slc1_sent_date IS NULL;
    /* RH 16/01/2008 END */ 
  END LOOP;
---
   if csr_stcy_stud%isopen then
      CLOSE csr_stcy_stud;
   end if;
--
    --- Update all fee loan records in slc_data for this file 1.
   if not csr_stcy_fee%isopen then
      OPEN csr_stcy_fee (p_fname);
   end if;
---
  LOOP
    FETCH csr_stcy_fee INTO l_academic_year, l_stud_ref_no;
    EXIT WHEN csr_stcy_fee%NOTFOUND;
    --
    UPDATE stud_session
    SET    slc1_fl_sent = 'Y',
       slc1_fl_sent_date = sysdate
    WHERE  stud_ref_no = l_stud_ref_no
    and session_code = l_academic_year;
    --
    /* RH 16/01/2008 START */
    UPDATE steps_stud_session
       SET slc1_fl_sent = 'Y',
           slc1_fl_sent_date = SYSDATE
     WHERE stud_ref_no = l_stud_ref_no AND session_code = l_academic_year;
    /* RH 16/01/2008 END */
  END LOOP;
---
   if csr_stcy_fee%isopen then
      CLOSE csr_stcy_fee;
   end if;
--
  --
  RETURN (SUCCESS);
---
EXCEPTION
  WHEN others THEN
   if csr_stcy_fee%isopen then
      CLOSE csr_stcy_fee;
   end if;
---
   if csr_stcy_stud%isopen then
      CLOSE csr_stcy_stud;
   end if;
---
    ---srw.message(9999,'The following fatal error occured in the After Report trigger of M263A.rdf: '||SQLERRM);
    DBMS_OUTPUT.PUT_LINE('UpdFile1Flags failed. ' || sqlerrm);
    ROLLBACK;
    RETURN(FAILURE);
END;

---
--
function UpdFile2Flags (p_rep in varchar2, p_fname in varchar2, p_fdate in date) return integer is
---
  CURSOR csr_stcy_stud (p_fname in varchar2) IS
    SELECT stud_crse_year_id
    FROM   slc_data, config_data
    WHERE  slc_filename = p_fname
    and    form_type = 'SA' --- file 2
    and    record_type = 'S' --- student loan
    AND       config_data.item_name = 'SLC_MAX_FILESIZE'
    AND       rownum < config_data.nval + 1;
  --
    CURSOR csr_stcy_fee (p_fname in varchar2) IS
        SELECT s.stud_ref_no, sd.academic_year, slc_filename, slc_file_date, sd.interest_accrual_date
        FROM   slc_data sd, stud s
        WHERE  slc_filename = p_fname
        and    form_type = 'SA'    --- File 2
        and    record_type = 'F'   --- fee loan
        and       sd.slc_ref_no = s.scottish_cand
        /* RH 16/01/2008 START */
        UNION
        SELECT s.stud_ref_no, sd.academic_year, slc_filename, slc_file_date, sd.interest_accrual_date
        FROM   slc_data sd, steps_stud s
        WHERE  slc_filename = p_fname
        and    form_type = 'SA'    --- File 2
        and    record_type = 'F'   --- fee loan
        and    sd.slc_ref_no = s.scottish_cand;
        /* RH 16/01/2008 END */
  --
  l_stcy_id slc_data.stud_crse_year_id%TYPE;
  l_academic_year slc_data.academic_year%type;
  l_stud_ref_no stud.stud_ref_no%type;
  l_int_acc_date slc_data.interest_accrual_date%type;
  l_slc_filename slc_data.slc_filename%type;
  l_slc_file_date slc_data.slc_file_date%type;
  ---
  l_tmp_msg varchar2(255);
BEGIN
    l_tmp_msg := null;
    ---
    --- Update scy flags for student loans.
    ---------------------------------------
   if not csr_stcy_stud%isopen then
      OPEN csr_stcy_stud (p_fname);
   end if;
---
 -- l_tmp_msg := 'csr_stcy_stud opened ok ';
  LOOP
    FETCH csr_stcy_stud INTO l_stcy_id;
    EXIT WHEN csr_stcy_stud%NOTFOUND;
    --
    UPDATE stud_crse_year
    SET    slc2_sent = 'Y',
                   slc2_sent_date = sysdate,
                   slc2_status = 'S'
    WHERE  stud_crse_year_id = l_stcy_id;
    --
    UPDATE stud_crse_year
    SET    first_slc2_sent_date = slc2_sent_date
    WHERE  stud_crse_year_id = l_stcy_id
    AND    first_slc2_sent_date IS NULL;
    --
    /* RH 16/01/2008 START */
    UPDATE steps_stud_crse_year
       SET slc2_sent = 'Y',
           slc2_sent_date = SYSDATE,
           slc2_status = 'S'
     WHERE stud_crse_year_id = l_stcy_id;
        --
    UPDATE steps_stud_crse_year
       SET first_slc2_sent_date = slc2_sent_date
     WHERE stud_crse_year_id = l_stcy_id AND first_slc2_sent_date IS NULL;
    /* RH 16/01/2008 END */
  END LOOP;
---
   if csr_stcy_stud%isopen then
      CLOSE csr_stcy_stud;
   end if;
  ---
  ---
  --- Update flt flags.
  ---------------------
   if not csr_stcy_fee%isopen then
      OPEN csr_stcy_fee (p_fname);
   end if;
---
  LOOP
    FETCH csr_stcy_fee INTO l_stud_ref_no, l_academic_year, l_slc_filename, l_slc_file_date, l_int_acc_date;
    EXIT WHEN csr_stcy_fee%NOTFOUND;
    --
    --- For this student, archive off fee loan txns previously sent to slc.
      -----------------------------------------------------------------------
   INSERT into FEE_LOAN_TRANSACTION_HISTORY
    SELECT trans_id, session_code, stud_ref_no, stud_crse_year_id,
     txn_amount, txn_dc_flg, txn_type, txn_date, txn_due_date,
     txn_payment_date, txn_interest_accrual_date, payment_method,
     inst_code, inst_bank_sort_code, inst_account_no, campus_id,
     batch_ref, payment_id, slc2_filename, slc2_file_date,
     status, status_changed_date
    from FEE_LOAN_TRANSACTION
    WHERE    stud_ref_no = l_stud_ref_no
    AND session_code = l_academic_year
    and txn_interest_accrual_date = l_int_acc_date -- archive off only those txns selected in main flt cursors.
    AND nvl (status, 'Z') = ('C') -- record has been corrected after a SLC rejection and is awaiting re-submission and is not set to cancelled
    AND slc2_filename is not null    -- file 2 has not been sent to the SLC before
    AND slc2_file_date is not null;  -- file 2 has not been sent to the SLC before
    --
--    l_tmp_msg := 'inserted into flth ok ';
    UPDATE FEE_LOAN_TRANSACTION
    SET status = 'S',
       status_changed_date = sysdate,
       slc2_filename = l_slc_filename,
       slc2_file_date =  l_slc_file_date
    WHERE    stud_ref_no = l_stud_ref_no --student selected from flt table.
    AND session_code = l_academic_year -- session selected from flt table.
    and txn_interest_accrual_date = l_int_acc_date --- same interest accrual date as selected.
    AND nvl (status, 'Z') IN ('Z','C');  --- update new and corrected flts.

    --
  END LOOP;
  ---
   if csr_stcy_fee%isopen then
      CLOSE csr_stcy_fee;
   end if;
  --
  --
  RETURN (SUCCESS);
---
EXCEPTION
  WHEN others THEN
---
   if csr_stcy_stud%isopen then
      CLOSE csr_stcy_stud;
   end if;
---
   if not csr_stcy_fee%isopen then
      CLOSE csr_stcy_fee;
   end if;

    ---srw.message(9999,l_tmp_msg || 'The following fatal error occured in the After Report trigger of M263B.rdf: '||SQLERRM);
   DBMS_OUTPUT.PUT_LINE('UpdFile2Flags failed. ' || sqlerrm);
    ROLLBACK;
    RETURN(FAILURE);
END;
---
function ChkDebugOn (p_debug_filename in varchar2, p_debug_dirname in out varchar2,
             p_debug_on in out config_data.cval%type, p_error_message in out varchar)
           return boolean is
---
fatal_error exception;
--
ret_val boolean;
dummy_nval config_data.nval%type;
s_db_name config_data.cval%type;
--
BEGIN
--
   ret_val := TRUE;
---
   p_debug_on := DEFAULT_M263_DEBUG;
   IF NOT Edm_Lib.ReadConfigData (M263_DEBUG, p_debug_on, dummy_nval) THEN
      p_debug_on := DEFAULT_M263_DEBUG;
   elsif (p_debug_on = 'Y') then
      --- Find database name to append to debug file.
      s_db_name := NULL;
      IF NOT Edm_Lib.ReadConfigData (DB_NAME, s_db_name, dummy_nval) THEN
     p_error_message := 'Failed to find ' || DB_NAME || ' in config_data.';
     raise fatal_error;
      else
     p_debug_dirname := (p_debug_dirname || '/' || s_db_name);
      end if;
   END IF;
--
    return ret_val;
--
EXCEPTION
--
   when fatal_error then
      ret_val := false;
      return ret_val;
---
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.ChkDebugOn '|| sqlcode || ' ' ||SQLERRM;
        RETURN ret_val;
--
end;
---
function UpdLoanFlags  ( p_stud_ref_no in slc_errors.stud_ref_no%type,
            p_session_code in stud_session.session_code%type,
            p_scy_id in stud_crse_year.stud_crse_year_id%type,
            p_txn_interest_accrual_date in fee_loan_transaction.txn_interest_accrual_date%type,
            p_filename in slc_data.slc_filename%type,
            p_filedate in slc_data.slc_file_date%type,
            p_loan_type in slc_errors.record_type_error%type,
            p_filetype in SLC_ERRORS.SLC_FILE_TYPE%TYPE,
            p_debug_file_handle in out utl_file.file_type,
            p_error_message in out VARCHAR2)return boolean is
--
ret_val boolean;
num_slc_data_recs number;
--
BEGIN
--
   ret_val := TRUE;
--
   if ((p_filetype = 1) and (p_loan_type = FEE_LOAN)) then
--    update the students file 1 status to be in error so as not to be picked
--    on the next select of fee loan txns by pop_m263a.
--    Note: these records are updated in the run_m263 shell script to reset all
--    ss.slc1_fl_sent flags set to E to be N at the end of processing.
      update stud_session
      set slc1_fl_sent = 'E'
      where stud_ref_no = p_stud_ref_no
      and session_code = p_session_code;
      /* RH 16/01/2008 START */
      update steps_stud_session
      set slc1_fl_sent = 'E'
      where stud_ref_no = p_stud_ref_no
      and session_code = p_session_code;      
      /* RH 16/01/2008 END */
--
   elsif ((p_filetype = 1) and (p_loan_type = STUD_LOAN)) then
      UPDATE STUD_CRSE_YEAR
       SET slc1_status = 'E'
      WHERE stud_crse_year_id = p_scy_id;
      /* RH 16/01/2008 START */
      UPDATE STEPS_STUD_CRSE_YEAR
       SET slc1_status = 'E'
      WHERE stud_crse_year_id = p_scy_id;
      /* RH 16/01/2008 END */      
--
   elsif (p_filetype = 2) and (p_loan_type = FEE_LOAN) then
      -- update flt.status for failed flts that have not been sent of corrected.
      update fee_loan_transaction
     set status = 'E',
     status_changed_date = sysdate
     where stud_ref_no = p_stud_ref_no
     and session_code = p_session_code
     and txn_interest_accrual_date = p_txn_interest_accrual_date
     and nvl(status, 'Z') in ('Z', 'C');
--
   elsif (p_filetype = 2) and (p_loan_type = STUD_LOAN) then
      UPDATE STUD_CRSE_YEAR
     SET slc2_status = 'E'
     WHERE stud_crse_year_id = p_scy_id;
      /* RH 16/01/2008 START */
      UPDATE STEPS_STUD_CRSE_YEAR
           SET slc2_status = 'E'
     WHERE stud_crse_year_id = p_scy_id;
      /* RH 16/01/2008 END */     
--
   end if;
--
   WriteToLog (p_debug_file_handle, 'UpdLoanFlags ok for ' || p_stud_ref_no || ' ' ||
               p_session_code || ' ' || p_filename || ' ' || p_filedate);
    return ret_val;
--
EXCEPTION
--
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.UpdLoanFlags '|| sqlcode || ' ' ||SQLERRM ||
             ' for ' || p_stud_ref_no || ' ' || p_session_code || ' ' || p_filename || ' ' || p_filedate;
        RETURN ret_val;
--
end;
---
function ChkStudNotInBatch (p_fl_only_rec in flt_for_slc_struct,
               p_filename in slc_data.slc_filename%type,
               p_filedate in slc_data.slc_file_date%type,
               p_latest_loan_elig_scy_id in slc_data.stud_crse_year_id%type,
               p_rec_type in slc_data.record_type%type,
               p_sd_recs_exist in out boolean,
               p_debug_file_handle in out utl_file.file_type,
               p_error_message in out VARCHAR2)return boolean is
--
ret_val boolean;
num_slc_data_recs number;
--
BEGIN
--
   ret_val := TRUE;
   num_slc_data_recs := 0;
   p_sd_recs_exist := false;
--
   select count (*)
   into num_slc_data_recs
   from slc_data
   WHERE slc_filename = p_filename
   AND slc_file_date = p_filedate
   and stud_crse_year_id = p_latest_loan_elig_scy_id
   and record_type = p_rec_type;
---
   if (num_slc_data_recs > 0) then
      p_sd_recs_exist := true;
   end if;
--
   WriteToLog (p_debug_file_handle, 'ChkStudNotInBatch ok for ' || p_filename || ' ' || p_filedate);
    return ret_val;
--
EXCEPTION
--
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.ChkStudNotInBatch '|| sqlcode || ' ' ||SQLERRM ||
     ' Student ' || p_fl_only_rec.stud_ref_no || ' stud_crse_year_id ' || p_latest_loan_elig_scy_id;
        RETURN ret_val;
--
end;
---
function DelSlcBatch ( p_slc_filename in slc_batches.slc_filename%type,
            p_slc_file_date in slc_batches.slc_file_date%type,
            p_debug_file_handle in out utl_file.file_type,
            p_error_message in out VARCHAR2)return boolean is
--
ret_val boolean;
--
BEGIN
--
   ret_val := TRUE;
--
   DELETE FROM slc_batches
   WHERE slc_filename = p_slc_filename
   AND slc_file_date = p_slc_file_date;
--
   WriteToLog (p_debug_file_handle, 'DelSlcBatch ok for ' || p_slc_filename || ' ' || p_slc_file_date);
    return ret_val;
--
EXCEPTION
--
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.DelSlcBatch '|| sqlcode || ' ' ||SQLERRM;
        RETURN ret_val;
--
end;
---
function WriteSummaryData (p_debug_file_handle    in out utl_file.file_type,
               p_file_type in number,
               p_filename in slc_data.slc_filename%type,
               p_tot_rec_ctr in number, p_num_filtered in number,
               p_num_in_err in number, p_num_stud in number, p_num_flt in number,
               p_num_fl_only in number, p_number_of_records in number,
               p_sum_dr in number, p_sum_cr in number, p_error_message in out varchar2)
          return boolean is
--
ret_val boolean;
--
BEGIN
--
   ret_val := TRUE;
--
-- have we created any fee records for today?
   if ret_val then
      WriteToLog (p_debug_file_handle, '-----');
      WriteToLog (p_debug_file_handle, 'Cursor summary for file ' || p_file_type ||' ' || p_filename || ' completed - ' ||
                         ' loan records read  ' || p_tot_rec_ctr ||
                         ' recs filtered ' || p_num_filtered ||
                         ' recs in error ' || p_num_in_err);
      WriteToLog (p_debug_file_handle, '-----');
      WriteToLog (p_debug_file_handle, 'Batch summary for file ' || p_file_type ||' ' || p_filename || ' completed - ' ||
                         ' stud loans so far ' || p_num_stud ||
                         ' fee loan so far ' || p_num_flt ||
                         ' fee loan only so far ' || p_num_fl_only);
      WriteToLog (p_debug_file_handle, '-----');
      WriteToLog (p_debug_file_handle, 'Total slc_data recs so far ' || p_number_of_records);
      WriteToLog (p_debug_file_handle, '-----');
      WriteToLog (p_debug_file_handle, 'Total DR ' || p_sum_dr || ' Total CR ' || p_sum_cr);
      WriteToLog (p_debug_file_handle, '' );

   end if;
--
    return ret_val;
--
EXCEPTION
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.WriteSummaryData '|| SQLCODE || ' ' || SQLERRM;
--
        RETURN ret_val;
--
end;
--
function ChkProcStudLoans (p_slc_filename in slc_data.slc_filename%type,
        p_slc_file_date in slc_data.slc_file_date%type,
               p_form_type in slc_data.form_type%type,
               p_proc_stud_loan in out boolean,
               p_debug_file_handle in out utl_file.file_type,
               p_error_message in out VARCHAR2) return boolean is
ret_val boolean;
num_recs number;
--
BEGIN
--
   ret_val := TRUE;
   num_recs := 0;
   p_proc_stud_loan := true;
--
-- have we created any fee records for today?
   if ret_val then
      num_recs := 0;
---   Are there any slc_data records for fee loan txns or for fee loan only students?
---   If so then we have processed all student loans and can miss them out from now on
---   in this run.
      select count (*)
      into num_recs
      from slc_data
      where slc_filename = p_slc_filename
      and slc_file_date = p_slc_file_date
      and record_type = FEE_LOAN
      and form_type = p_form_type;
--
      if (num_recs > 0) then
     -- if slc_data records exist for fee data then all stud loans have been procd.
     -- miss out student loans cursor.
     p_proc_stud_loan := false;
     WriteToLog (p_debug_file_handle, '*** Missing student loan processing for file type ' || p_form_type
                       || ' for ' || p_slc_filename || ' ' || to_char(p_slc_file_date, 'dd/mm/yyyy')
                       || ' as we have processed > 0 fee loan records.');
      end if;
   end if;
--
    return ret_val;
--
EXCEPTION
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.ChkLoantoProc '|| SQLCODE || ' ' || SQLERRM;
--
        RETURN ret_val;
--
end;
--
function FindStudLoc (p_scy_id in stud_crse_year.stud_crse_year_id%type,
             p_stud_ref_no in stud_crse_year.stud_ref_no%type,
             p_session_code in stud_crse_year.session_code%type,
             p_stud_loc_ind in out inst.location_ind%type,
             p_error_message in out varchar2)return boolean is
--
ret_val boolean;
n_sqlcode NUMBER;
v_sqlerrm VARCHAR2(2000);
--
BEGIN
--
   ret_val := TRUE;
   p_stud_loc_ind := null;
--
/* RH 16/01/2008 START */
SELECT iv1.location_ind
  INTO p_stud_loc_ind
  FROM (SELECT i.location_ind
          FROM inst i, stud_crse_year scy
         WHERE scy.stud_crse_year_id = p_scy_id
               AND scy.inst_code = i.inst_code
        UNION
        SELECT i.location_ind
          FROM inst i, steps_stud_crse_year scy
         WHERE scy.stud_crse_year_id = p_scy_id
               AND scy.inst_code = i.inst_code) iv1;
/* RH 16/01/2008 END */
--
    return ret_val;
--
EXCEPTION
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        n_sqlcode := SQLCODE;
        v_sqlerrm := SQLERRM;
        p_error_message := 'The following fatal error occured in POP_M263.FindStudLoc '||n_sqlcode||' '||SQLERRM ||
               ' for student: ' || p_stud_ref_no || ' session: ' ||
               p_session_code || ' stud_crse_year_id: ' || p_scy_id;
        RETURN ret_val;
--
end;
--
function CreateFile2(p_f2_flt_rec in flt_for_f2_slc_struct,
             p_r1 in out c_f2_stud_loans%ROWTYPE,
             p_r2 in out c_f2_sha%ROWTYPE,
             p_r3 in out c_f2_sta%rowtype,
             p_r4 in out c_f2_scd_1%rowtype,
             p_r5 in out c_f2_scd_2%rowtype,
             p_sd in out slc_data%rowtype,
             p_filename IN VARCHAR2,
             p_filedate IN DATE,
             p_b_record_valid in out boolean,
             p_loan_type in slc_errors.record_type_error%type,
             p_error_message in out VARCHAR2)
    return boolean is
--
    ret_val boolean;
--
   v_error_description    VARCHAR2(2000);
   --v_inst_code        HEI_INST.hei_inst_code%TYPE;
   --v_inst_name        HEI_INST.hei_inst_name%TYPE;
   --v_crse_code        HEI_CRSE.hei_crse_code%TYPE;
   --v_crse_name        HEI_CRSE.hei_crse_name%TYPE;
   --
   n_return_no        NUMBER; -- returned from func.
--
   n_loan_amount        NUMBER;
   --n_loan_request        NUMBER;
--
   v_home_post_code        VARCHAR(8);
   v_term_post_code        VARCHAR(8);
--
   --v_addr_corr_flag        STUD.addr_corr_flag%TYPE;
   --v_cont1_post_code        VARCHAR(8);
   --v_cont2_post_code        VARCHAR(8);
--
   r4_temp            c_f2_scd_1%ROWTYPE;
   r5_temp            c_f2_scd_2%ROWTYPE;
   n_dummy_number number;
   b_number boolean;
--
   n_sqlcode            NUMBER;
   v_sqlerrm            VARCHAR2(2000);
--
   stud_loc_ind INST.location_ind%TYPE;
   tmp_scy_rec stud_crse_year%rowtype;
--
CreateFile2Err exception;
--
begin
--
    ret_val := true;
   r4_temp := null;
   r5_temp := null;
   p_r2 := null; -- stud home address.
   tmp_scy_rec := null;
--
   -- Find home address details;
   if not c_f2_sha%isopen then
      OPEN  c_f2_sha (p_r1.stud_ref_no);
   end if;
--
   FETCH c_f2_sha INTO p_r2;
   CLOSE c_f2_sha;
--
   if (p_loan_type = STUD_LOAN) then
       IF p_r1.sal_sent_date IS NULL THEN
          -- SAL sent date cannot be null
          v_error_description := 'Issue date is missing';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 2,
                 p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
                 p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
                 SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
          p_b_record_valid := FALSE;
       END IF;
   else
      p_r1.sal_sent_date := sysdate;
   end if;
--
    IF p_r1.scottish_cand IS NULL THEN
       -- Student SLC Reference Number is a mandatory field
       v_error_description := 'Student SLC reference number is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2,
              p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
              p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
              SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
-- Find term address details.
-----------------------------
   OPEN  c_f2_sta (p_r1.stud_ref_no);
   p_r3 := null;
   FETCH c_f2_sta INTO p_r3;
--
   if c_f2_sta%isopen then
      CLOSE c_f2_sta;
   end if;
--
-- Toal student Loan claimed.
-----------------------------
   if (p_loan_type = STUD_LOAN) then
      -- find net_amount from student loan award (n_loan_amount).
       n_return_no := Slc_Util.assessed_as_loan(p_r1.stud_crse_year_id, n_loan_amount);
       
       
       
      -- check to see if loan request is greater than the total loan available.
--    n_loan_request := p_r1.loan_request;
      p_sd.total_loan_claimed := p_r1.loan_request; -- set total to ss.loan_request
       IF p_sd.total_loan_claimed > n_loan_amount THEN
     -- requested amount > award net amount, limit it to net_amount calculated.
          p_sd.total_loan_claimed := n_loan_amount;
       END IF;
--
       IF p_sd.total_loan_claimed IS NULL AND (p_r1.max_loan_requested = 'N' OR p_r1.max_loan_requested IS NULL) THEN
          -- Total loan claimed is a mandatory field
          v_error_description := 'The total loan claimed cannot be null when the max loan requested checkbox is not checked';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 2,
                 p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
                 p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
                 SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
          p_b_record_valid := FALSE;
       END IF;
--
       IF p_r1.max_loan_requested = 'Y' THEN
          -- student requested maximum loan
          p_sd.total_loan_claimed := n_loan_amount;
       END IF;
   else -- fee loan records, set living cost loan to 0.
      p_sd.total_loan_claimed := LPAD('0.00',7,0);
   end if;
--
-- Home Post Code.
------------------
    v_home_post_code := NULL;
    IF p_r2.post_code IS NOT NULL THEN
       -- home post code is optional. Only validate if supplied.
       IF NOT pop_m263_postcode(p_r2.post_code, v_home_post_code) THEN
          -- postcode is in an invalid format
          v_error_description := 'The format of home post code '||p_r2.post_code||' is incorrect';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
            p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
            p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
            p_r1.dearing, p_loan_type);
          p_b_record_valid := FALSE;
       END IF;
    END IF;
--
-- Term Post code.
------------------
    v_term_post_code := NULL;
    IF p_r3.post_code IS NOT NULL THEN
       -- term post code is optional. Only validate if supplied.
       IF NOT pop_m263_postcode(p_r3.post_code, v_term_post_code) THEN
          -- postcode is in an invalid format
          v_error_description := 'The format of term post code '||p_r3.post_code||' is incorrect';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
            p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
            p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
            p_r1.dearing, p_loan_type);
          p_b_record_valid := FALSE;
       END IF;
    END IF;
--
-- Correspondence Address.
--------------------------
    --v_addr_corr_flag := NULL;
   p_sd.corres_ind := NULL;
    IF p_r1.addr_corr_flag IS NULL THEN
       IF p_r1.corres_dest = 'H' THEN
          p_sd.corres_ind := 'H';
       ELSIF p_r1.corres_dest = 'T' THEN
          p_sd.corres_ind := 'T';
       END IF;
       IF p_r1.corres_dest = 'T' OR p_r1.corres_dest IS NULL THEN
          IF p_r3.addr_l1 IS NULL THEN
        -- no term address.  Default to home address
        p_sd.corres_ind := 'H';
          END IF;
       END IF;
    ELSE
       p_sd.corres_ind := p_r1.addr_corr_flag;
    END IF;
--
-- Find 1st contact address details;
------------------------------------
   if not c_f2_scd_1%isopen then
      OPEN  c_f2_scd_1 (p_r1.stud_ref_no);
   end if;
--
   p_r4 := null;
--
    FETCH c_f2_scd_1 INTO p_r4;
--
-- Contact 1 Name.
------------------
    IF p_r4.cont_name IS NULL THEN
       -- Contact name is a mandatory field
       v_error_description := 'First contact name is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id,
             p_r1.stud_ref_no, p_r1.inst_code, p_r1.crse_code, p_r1.crse_id,
             p_r1.session_code, p_r1.scottish_cand,  SUBSTR(v_error_description,1,255),
             p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
-- Contact 1 Relationship code.
-------------------------------
    IF p_r4.cont_rel_code IS NULL THEN
       -- Contact rel is a mandatory field
       v_error_description := 'First contact relationship is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id,
             p_r1.stud_ref_no, p_r1.inst_code, p_r1.crse_code, p_r1.crse_id,
             p_r1.session_code, p_r1.scottish_cand, SUBSTR(v_error_description,1,255),
             p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
-- First Contact Address line 1.
--------------------------------
    IF p_r4.cont_addr1 IS NULL THEN
       -- Contact address line 1 is a mandatory field
       v_error_description := 'First contact address line 1 is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
             p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
             p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
             p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
-- First Contact Address line 2 and 3.
--------------------------------------
    IF p_r4.cont_addr2 IS NULL AND p_r4.cont_addr3 IS NULL THEN
       -- Both Contact address line 2 and 3 cannot be null
       v_error_description := 'First contact address lines 2 and 3 are missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
             p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
             p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
             p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
-- First Contact Post code.
---------------------------
    --v_cont1_post_code := NULL;
   p_sd.first_cont_postcode := NULL;
    IF p_r4.cont_postcode IS NOT NULL THEN
       -- first contact post code is optional. Only validate if supplied.
       IF NOT pop_m263_postcode(p_r4.cont_postcode, p_sd.first_cont_postcode) THEN
          -- postcode is in an invalid format
          v_error_description := 'The format of first contact post code '||p_r4.cont_postcode||' is incorrect';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
            p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
            p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
            p_r1.dearing, p_loan_type);
          p_b_record_valid := FALSE;
       END IF;
    END IF;
--
-- Check if duplicate first contact exists
------------------------------------------
    FETCH c_f2_scd_1 INTO r4_temp;
    IF c_f2_scd_1%FOUND THEN
       -- Duplicate first contacts exist
       v_error_description := 'Duplicate First Contact Details Exist - Contact B.S.U';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
             p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
             p_r1.scottish_cand,  SUBSTR(v_error_description,1,255), p_r1.scheme_type,
             p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
   if c_f2_scd_1%isopen then
      CLOSE c_f2_scd_1;
   end if;
--
-- Find 2nd contact address details;
------------------------------------
   if not c_f2_scd_2%isopen then
      OPEN    c_f2_scd_2 (p_r1.stud_ref_no);
   end if;
   p_r5 := null;
--
    FETCH c_f2_scd_2 INTO p_r5;
    IF p_r5.cont_name IS NULL THEN
       -- Contact name is a mandatory field
       v_error_description := 'Second contact name is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
             p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
             p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
             p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
-- Check second contact address line 1.
---------------------------------------
    IF p_r5.cont_addr1 IS NULL THEN
       -- Second contact address line 1 is a mandatory field
       v_error_description := 'Second contact address line 1 is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
             p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
             p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
             p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
-- Check second contact address lines 2 and 3.
----------------------------------------------
    IF p_r5.cont_addr2 IS NULL AND p_r5.cont_addr3 IS NULL THEN
       -- Both Second contact address line 2 and 3 cannot be null
       v_error_description := 'Second contact address lines 2 and 3 are missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
                 p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
                 p_r1.scottish_cand,  SUBSTR(v_error_description,1,255),
                 p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
-- check contact 2 post code.
-----------------------------
    --v_cont2_post_code := NULL;
    p_sd.second_cont_postcode := NULL;
    IF p_r5.cont_postcode IS NOT NULL THEN
       -- second contact post code is optional. Only validate if supplied.
       IF NOT pop_m263_postcode(p_r5.cont_postcode, p_sd.second_cont_postcode) THEN
          -- postcode is in an invalid format
          v_error_description := 'The format of second contact post code '|| p_r5.cont_postcode || ' is incorrect';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
            p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
            p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
            p_r1.dearing, p_loan_type);
          p_b_record_valid := FALSE;
       END IF;
    END IF;
--
-- Check if duplicate second contact exists.
--------------------------------------------
    FETCH c_f2_scd_2 INTO r5_temp;
    IF c_f2_scd_2%FOUND THEN
       -- Duplicate second contacts exist
       v_error_description := 'Duplicate Second Contact Details Exist - Contact B.S.U';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
             p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
             p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
             p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
   if c_f2_scd_2%isopen then
      CLOSE c_f2_scd_2;
   end if;
--
-- Check sort code, account / building society number.
------------------------------------------------------
   if (p_loan_type = STUD_LOAN) then
      IF p_r1.sort_code IS NOT NULL THEN
     IF LENGTH(p_r1.sort_code) != 6 THEN
        v_error_description := 'The sort code '||p_r1.sort_code||' is incorrect. It must consist of 6 numerics';
        -- Validation failed. Insert error into slc_errors
        pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
               p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
               p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
               p_r1.dearing, p_loan_type);
        p_b_record_valid := FALSE;
     ELSE
        BEGIN
           n_dummy_number := p_r1.sort_code;
           b_number := TRUE;
        EXCEPTION
           WHEN OTHERS THEN
          b_number := FALSE;
           END;
        IF NOT b_number THEN
           v_error_description := 'The sort code '||p_r1.sort_code||' is incorrect. It must consist of 6 numerics';
           -- Validation failed. Insert error into slc_errors
           pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
                  p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
                  p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
                  p_r1.dearing, p_loan_type);
           p_b_record_valid := FALSE;
        END IF;
     END IF;
     -- Whenever sort code is supplied either account no or building society roll no must be supplied.
     IF p_r1.account_no IS NULL AND p_r1.build_soc_no IS NULL THEN
        v_error_description := 'A sort code has been supplied without either a account code or a building society roll number';
        -- Validation failed. Insert error into slc_errors
        pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
            p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
            p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
            p_r1.dearing, p_loan_type);
        p_b_record_valid := FALSE;
     END IF;
      END IF;
   else
      p_r1.sort_code := null;
      p_r1.account_no := null;
      p_r1.build_soc_no := null;
   end if;
--
-- Check loan declaration date.
-------------------------------
   if (p_loan_type = STUD_LOAN) then
       IF p_r1.loan_declaration_date IS NULL THEN
          -- loan declaration date must be supplied.
          v_error_description := 'Loan Declaration date is missing';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
            p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
            p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
            p_r1.dearing, p_loan_type);
          p_b_record_valid := FALSE;
       END IF;
   else -- fee loan
       IF p_r1.fee_loan_declaration_date IS NULL THEN
          -- fee loan declaration date must be supplied.
          v_error_description := 'Fee Loan Declaration date is missing';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
            p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
            p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
            p_r1.dearing, p_loan_type);
          p_b_record_valid := FALSE;
      else -- send fee loan declaration date to slc.
     p_r1.loan_declaration_date := p_r1.fee_loan_declaration_date;
       END IF;
   end if;
--
-- Check telephone number.
--------------------------
    IF LENGTH(p_r2.tele_no) > 14 THEN
       v_error_description := 'The number of characters contained in the home telephone number exceeds the maximum of 14';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
             p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
             p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
             p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
    IF LENGTH(p_r3.tele_no) > 14 THEN
       v_error_description := 'The number of characters contained in the term telephone number exceeds the maximum of 14';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
             p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
             p_r1.scottish_cand, SUBSTR(v_error_description,1,255), p_r1.scheme_type,
             p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
-- Set loan type, stud or fee.
   p_sd.record_type := p_loan_type;
--
-- Interest Accrual date.
   if (p_loan_type = STUD_LOAN) then
      p_sd.interest_accrual_date := null;
   else
      p_sd.interest_accrual_date := p_f2_flt_rec.txn_interest_accrual_date;
   end if;
--
-- Debit / credit flag and
-- Payment/adjustment amount.
   if (p_loan_type = STUD_LOAN) then
      p_sd.fee_loan_amount := null;
      p_sd.dc_flag := null;
   elsif (p_f2_flt_rec.sum_txns > 0) then -- fee loan amount is a debit and increases fee loan.
      p_sd.dc_flag := 'DR';
      p_sd.fee_loan_amount := p_f2_flt_rec.sum_txns;
   else -- student is owed fee loan, make the amount +ve and CR.
      p_sd.dc_flag := 'CR';
      p_sd.fee_loan_amount := (p_f2_flt_rec.sum_txns * -1);
   end if;
--
-- Total fee loan session amount.
   if (p_loan_type = STUD_LOAN) then
      p_sd.total_fee_loan_amount := null;
   else -- set up total fee loan.
      if not TotalSessFeeLoanDebt (p_f2_flt_rec, p_sd, p_error_message) then
     raise CreateFile2Err;
      end if;
   end if;
--
-- Reason no nino is populated if stud.nino is missing and ss.reason_no_nino
-- has been supplied.
   p_sd.reason_no_nino := null;
   if (p_r1.ni_no is null) and (p_r1.reason_no_nino is not null) then
      p_sd.reason_no_nino := p_r1.reason_no_nino;
   end if;
--
-- Student payment indicator.
   p_sd.loan_payment_method := null;
   stud_loc_ind := null;
   -- Set up scy record for call to slc_util.EligibleForFlexi.
   tmp_scy_rec.stud_crse_year_id := p_r1.stud_crse_year_id;
   tmp_scy_rec.scheme_type := p_r1.scheme_type;
   tmp_scy_rec.dearing := p_r1.dearing;
   tmp_scy_rec.session_code := p_r1.session_code;
--
   if (p_loan_type = STUD_LOAN) then -- stud may get monthly payments.
/*
      -- check payment scheme, either monthly or termly.
      if not FindStudLoc (p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.session_code,
                  stud_loc_ind, p_error_message) then
          -- Validation failed. Insert error into slc_errors
          pop_m263_error (p_filename, p_filedate, 2, p_r1.stud_crse_year_id, p_r1.stud_ref_no,
                      p_r1.inst_code, p_r1.crse_code, p_r1.crse_id, p_r1.session_code,
                      p_r1.scottish_cand, SUBSTR(p_error_message,1,255), p_r1.scheme_type,
                      p_r1.dearing, p_loan_type);
          p_b_record_valid := FALSE;
      elsif ((stud_loc_ind <> INST_IN_SCOTLAND) -- not in scotland
     or (p_r1.session_code < flexi_payments.FLEXI_PAY_START_SESSION) -- < 2007

     or not*/
      --- Call slc_util.EligibleForFlexi() as flexi payments code may not be in database.
      if not slc_util.EligibleForFlexi (tmp_scy_rec) -- not flexi
     then --- student outside scotland are paid termly.
     p_sd.loan_payment_method := 'T'; --  student gets termly awards.
      else
     -- student gets monthly payments.
     p_sd.loan_payment_method := 'M';
      end if;
   end if;
--
    return ret_val;
--
exception
--
   when CreateFile2Err then
      ret_val := false;
      n_sqlcode := SQLCODE;
      v_sqlerrm := SQLERRM;
      p_error_message := 'The following fatal Error occured IN Pop_M263.POP_M263B '||n_sqlcode||' '||SQLERRM;
      return ret_val;
--
    WHEN OTHERS THEN -- fatal error, stop processing.
        ret_val := false;
        n_sqlcode := SQLCODE;
        v_sqlerrm := SQLERRM;
        p_error_message := 'The following fatal error occured in pop_m263.CreateFile2 '||n_sqlcode||' '||SQLERRM;
--
    if c_f2_sha%isopen then
        CLOSE c_f1_sha;
    end if;
--
    if c_f2_sta%isopen then
        CLOSE c_f2_sta;
    end if;
--
    if c_f2_scd_1%isopen then
        CLOSE c_f2_scd_1;
    end if;
--
    if c_f2_scd_2%isopen then
        CLOSE c_f2_scd_2;
    end if;
--
    RETURN ret_val;
--
end;
--
function ChkFlOnly (fl_only_rec in flt_for_slc_struct,
            p_fee_loan_only in out boolean,
            p_error_message in out varchar2,
            p_debug_file_handle in out utl_file.file_type) return boolean is
--
fatal_error exception;
ret_val boolean;
--
stud_has_fee_loan boolean;
stud_has_stud_loan boolean;
--
BEGIN
--
   ret_val := TRUE;
    p_fee_loan_only := false;
--
   stud_has_stud_loan := false;
   stud_has_stud_loan := false;
--
-- Check if fee loan only exists.
---------------------------------
   if not slc_util.StudHasStudLoan (fl_only_rec.stud_crse_year_id, stud_has_stud_loan, p_error_message, p_debug_file_handle) then
      raise fatal_error;
   elsif not stud_has_stud_loan then -- stud does not have stud loan.
      if not slc_util.StudHasFeeLoan (fl_only_rec.stud_crse_year_id, stud_has_fee_loan, p_error_message, p_debug_file_handle) then
          raise fatal_error;
      elsif stud_has_fee_loan then --- fee loan exists.
     p_fee_loan_only := true;
     writetolog (p_debug_file_handle, '+++ Student does not have stud loan but does have fee loan.');
      else
     writetolog (p_debug_file_handle, '--- Student does not have stud or fee loan.');
      end if;
   else
      writetolog (p_debug_file_handle, '--- Student has stud loan. No need to check if fee loan exists.');
   end if;
--
   return ret_val;
--
EXCEPTION
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in pop_m263.ChkFlOnly '||SQLCODE||' '||SQLERRM ||
             ' Student: ' || fl_only_rec.stud_ref_no || ' Session: ' || fl_only_rec.session_code;
        RETURN ret_val;
--
end;
--
function FindMaxFltScyId (p_flt_for_slc_rec in out flt_for_slc_struct, p_error_message in out varchar2) return boolean is
--
ret_val boolean;
n_sqlcode NUMBER;
v_sqlerrm VARCHAR2(2000);
--
BEGIN
--
   ret_val := TRUE;
--
    select max(stud_crse_year_id)
    into p_flt_for_slc_rec.stud_crse_year_id
   from fee_loan_transaction
    where stud_ref_no = p_flt_for_slc_rec.stud_ref_no
    and session_code = p_flt_for_slc_rec.session_code;
--
    return ret_val;
--
EXCEPTION
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        n_sqlcode := SQLCODE;
        v_sqlerrm := SQLERRM;
        p_error_message := 'The following fatal error occured in pop_m263.FindMaxFltScyId '||n_sqlcode||' '||SQLERRM ||
               ' for student: ' || p_flt_for_slc_rec.stud_ref_no || ' session: ' ||
               p_flt_for_slc_rec.session_code;
        RETURN ret_val;
--
end;
--
function UpdScyFlags (p_scy_id in stud_crse_year.stud_crse_year_id%type,
             p_file_id in number,
             p_error_message in out varchar2,
             p_debug_file_handle in out utl_file.file_type) return boolean is
--
ret_val boolean;
--
BEGIN
--
   ret_val := TRUE;
--
    if ret_val then
      if (p_file_id = SLC_FILE_1_ID) then
     UPDATE stud_crse_year
     SET slc1_sent = 'Y',
     slc1_sent_date = sysdate,
     slc1_status = 'S'
     WHERE stud_crse_year_id = p_scy_id;
     /* RH 16/01/2008 START */
     UPDATE steps_stud_crse_year
     SET slc1_sent = 'Y',
     slc1_sent_date = sysdate,
     slc1_status = 'S'
     WHERE stud_crse_year_id = p_scy_id;
     /* RH 16/01/2008 END */
--
     UPDATE stud_crse_year
     SET    first_slc1_sent_date = slc1_sent_date
     WHERE    stud_crse_year_id = p_scy_id
     AND    first_slc1_sent_date IS NULL;
     /* RH 16/01/2008 START */
     UPDATE steps_stud_crse_year
     SET    first_slc1_sent_date = slc1_sent_date
     WHERE    stud_crse_year_id = p_scy_id
     AND    first_slc1_sent_date IS NULL;
     /* RH 16/01/2008 END */     
--
      elsif (p_file_id = SLC_FILE_2_ID) then
     UPDATE stud_crse_year
     SET slc2_sent = 'Y',
     slc2_sent_date = sysdate,
     slc2_status = 'S'
     WHERE stud_crse_year_id = p_scy_id;
     /* RH 16/01/2008 START */
     UPDATE steps_stud_crse_year
     SET slc2_sent = 'Y',
     slc2_sent_date = sysdate,
     slc2_status = 'S'
     WHERE stud_crse_year_id = p_scy_id;
     /* RH 16/01/2008 END */
--
     UPDATE stud_crse_year
     SET    first_slc2_sent_date = slc2_sent_date
     WHERE    stud_crse_year_id = p_scy_id
     AND    first_slc2_sent_date IS NULL;
     /* RH 16/01/2008 START */
     UPDATE steps_stud_crse_year
     SET    first_slc2_sent_date = slc2_sent_date
     WHERE    stud_crse_year_id = p_scy_id
     AND    first_slc2_sent_date IS NULL;
     /* RH 16/01/2008 END */
      end if;
   end if;
--
   WriteToLog (p_debug_file_handle, 'UpdScyFlags ok');
    return ret_val;
--
EXCEPTION
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.UpdScyFlags '|| SQLCODE || ' ' || SQLERRM;
--
        RETURN ret_val;
--
end;
--
--
function UpdSSFlSentFlagToN (p_stud_ref_no in fee_loan_transaction.stud_ref_no%type,
                         p_session_code in fee_loan_transaction.session_code%type,
                         p_error_message in out varchar2)
          return boolean is
--
ret_val boolean;
n_sqlcode NUMBER;
v_sqlerrm VARCHAR2(2000);
v_error_description    VARCHAR2(2000);
--
BEGIN
--
   update stud_session
   set slc1_fl_sent = 'N',
   slc1_fl_sent_date = sysdate
   where stud_ref_no = p_stud_ref_no
   and session_code = p_session_code;
   /* RH 16/01/2008 START */
   update steps_stud_session
   set slc1_fl_sent = 'N',
   slc1_fl_sent_date = sysdate
   where stud_ref_no = p_stud_ref_no
   and session_code = p_session_code;   
   /* RH 16/01/2008 END */
--
    return ret_val;
--
EXCEPTION
--
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        n_sqlcode := SQLCODE;
        v_sqlerrm := SQLERRM;
        p_error_message := 'The following fatal error occured in POP_M263.UpdSSFlSentFlagToN '||n_sqlcode||' '||SQLERRM;
        RETURN ret_val;
--
end;
--
  FUNCTION  Pop_M263 (p_filetype    IN NUMBER, p_error_message OUT VARCHAR2) RETURN NUMBER IS
--
    n_no_of_records           NUMBER;
    n_sqlcode               NUMBER;
    v_sqlerrm               VARCHAR2(2000);
    v_no_of_records       NUMBER;
--
   flt_ctr number;
   flt_for_slc_rec flt_for_slc_struct;
   exit_loop boolean;
   s_debug_filename VARCHAR2 (64) := 'pop_m263.debug';
   fatal_error exception;
   n_maxrows number;
   debug_on config_data.cval%type;
   s_debug_path varchar2 (128);
--
  BEGIN
--
    COMMIT;
    SET TRANSACTION USE ROLLBACK SEGMENT RBS1;
---
   debug_on := DEFAULT_M263_DEBUG;
   if not ChkDebugOn (s_debug_filename, gs_debug_dirname, debug_on, p_error_message) then
      raise fatal_error;
   elsIF (debug_on = 'Y') THEN --- open debug file.
      s_debug_path := gs_debug_dirname || '/' || s_debug_filename;
      pop_m263_debug_file_handle := utl_file.fopen(gs_debug_dirname, s_debug_filename, 'a');
   END IF;
---
   flt_ctr := 0;
   p_error_message := null;
   n_no_of_records := 0;
--
   writetolog (pop_m263_debug_file_handle, 'Calling pop_263.pop_m263.');
-- ------------------------------------------------------------------------------------
-- Cancel out any fee_loan_transaction records where the sum of debits and credits = 0;
-- ------------------------------------------------------------------------------------
   if not SetFeeLoanTxnToCancel (p_error_message, flt_ctr) then
--    Fatal error ocurred, stop processing all records.
      raise fatal_error;
   else
      commit; -- all updated flt records.
      writetolog (pop_m263_debug_file_handle, flt_ctr || ' student(s) have had their Fee Loan Transactions cancelled.');
   end if;
--
/*
-- -----------------------------------------------------
-- find max number of records allowed in the batch file.
--------------------------------------------------------
   n_maxrows := 0;
   if not c_f1_2_max_size%isopen then
      OPEN  c_f1_2_max_size;
   end if;
--
   FETCH c_f1_2_max_size INTO n_maxrows;
--
   IF c_f1_2_max_size%NOTFOUND THEN
      if c_f1_2_max_size%isopen then
     CLOSE c_f1_2_max_size;
      end if;
      p_error_message := 'The following error occured in POP_M263.POP_M263_ERROR : No row found in CONFIG_DATA for ITEM_NAME = ''SLC_MAX_FILESIZE''';
      RAISE e_max_filesize_not_found;
   END IF;
--
   if c_f1_2_max_size%isopen then
      CLOSE c_f1_2_max_size;
   end if;
--
yyy
--
*/
   --altered all counts to do distinct SIp_r1399 KL
   IF p_filetype = 1 THEN
/*
      select slc_filename
      into last_filename
      from slc_data
      where form_type = 'SN'
      and
--
      select count(*)
      into num_recs
      from slc_data
      where slc_filename = last_filename
--
      if (num_recs = n_maxrows) then -- more recs to process.
     n_no_of_records := 1;
      end if;
--
*/
      n_no_of_records := 1;
/*
       SELECT COUNT(DISTINCT scy.stud_crse_year_id)
         INTO n_no_of_records
         FROM STUD_CRSE_YEAR scy,
          STUD_SESSION ss,
          AWARD a,
          STUD s
       WHERE ss.stud_ref_no = s.stud_ref_no
         AND scy.stud_session_id = ss.stud_session_id
         AND a.stud_crse_year_id = scy.stud_crse_year_id
         AND Award_Types.loan_award(a.stud_award_type) = 'Y'
         AND Slc_Util.loan_bearing(scy.stud_crse_year_id) = 'Y'
         AND scy.sal_sent = 'Y'
         AND scy.slc1_sent = 'N'
         AND scy.sal_dest IN ('1','R','A','M')
         AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
         AND scy.latest_crse_ind = 'Y'
         AND (scy.slc1_status NOT IN ('E','R') OR scy.slc1_status IS NULL);
--
     --rfc116 count of non-attendance students
     SELECT COUNT(DISTINCT scy.stud_crse_year_id)
     INTO v_no_of_records
     FROM STUD_CRSE_YEAR scy,
          STUD_SESSION ss,
          STUD s
     WHERE ss.stud_ref_no = s.stud_ref_no
     AND   scy.stud_session_id = ss.stud_session_id
     AND   Slc_Util.loan_bearing(scy.stud_crse_year_id) = 'Y'
     AND   scy.sal_sent = 'Y'
     AND   scy.slc1_sent = 'N'
     AND   scy.sal_dest IN ('1','R','A','M')
     AND   (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
     AND   scy.latest_crse_ind = 'Y'
     AND   (scy.slc1_status NOT IN ('E','R') OR scy.slc1_status IS NULL)
     AND   (scy.application_status = 'A' AND scy.first_slc1_sent_date IS NOT NULL);
--
     n_no_of_records := n_no_of_records + v_no_of_records;
     writetolog (debug_file_handle, n_no_of_records || 'student loan records to be processed for file 1.');
--
--     add number of studs having fee loan txns to be processed.
--     ---------------------------------------------------------
     v_no_of_records := 0;
     exit_loop := false;
          if not c_flt_for_slc%isopen then
              OPEN c_flt_for_slc;
          end if;
--
     while not exit_loop loop
        flt_for_slc_rec := null;
--        Check all flt records not in error and not rejected waiting to go to slc.
        FETCH c_flt_for_slc INTO flt_for_slc_rec.stud_ref_no, flt_for_slc_rec.session_code;
--
        if c_flt_for_slc%notfound then -- all records processed.
                  exit_loop := true;
        else
           v_no_of_records := (v_no_of_records + 1);
           WriteToLog (debug_file_handle, 'another flt found, total so far: ' || v_no_of_records);
        end if;
     end loop;
--
          if c_flt_for_slc%isopen then
              close c_flt_for_slc;
          end if;
--
     n_no_of_records := n_no_of_records + v_no_of_records;
     writetolog (debug_file_handle, n_no_of_records || ' student and fee loan records to be processed for file 1.');
--
*/
    ELSIF p_filetype = 2 THEN -- find number of student loans to pay.
--    Since removal of count for file 1 below set to > 0 to allow pop_m263b to run.
      n_no_of_records := 1;
/*
      SELECT COUNT(DISTINCT scy.stud_crse_year_id)
           INTO n_no_of_records
           FROM STUD_CRSE_YEAR scy,
                STUD_SESSION ss,
                AWARD a,
                STUD s
          WHERE ss.stud_ref_no = s.stud_ref_no
            AND scy.stud_session_id = ss.stud_session_id
            AND a.stud_crse_year_id = scy.stud_crse_year_id
            AND Award_Types.loan_award(a.stud_award_type) = 'Y'
            AND Slc_Util.loan_bearing(scy.stud_crse_year_id) = 'Y'
            AND scy.withdraw_date IS NULL
            AND scy.slc2_sent = 'N'
            AND scy.sal_sent = 'Y'
            AND scy.slc1_sent = 'Y'
            AND scy.sal_dest IN ('1','R','A','M')
                AND scy.dearing != 'O'
            AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
            AND scy.latest_crse_ind = 'Y'
            AND (scy.slc2_status NOT IN ('E','R') OR scy.slc2_status IS NULL)
            AND (((ss.loan_request != 0 OR ss.loan_request IS NULL) AND
                 a.net_amount != 0) OR
                (ss.loan_request = 0 AND
                 a.net_amount != 0));
*/
-- RFC 71 addition
    ELSIF p_filetype = 3 THEN
      SELECT COUNT(DISTINCT scy.stud_crse_year_id)
           INTO n_no_of_records
           FROM STUD_CRSE_YEAR scy,
                STUD_SESSION ss,
                AWARD a,
                STUD s
          WHERE ss.stud_ref_no = s.stud_ref_no
            AND scy.stud_session_id = ss.stud_session_id
            AND a.stud_crse_year_id = scy.stud_crse_year_id
            AND Award_Types.loan_award(a.stud_award_type) = 'Y'
            AND Slc_Util.loan_bearing(scy.stud_crse_year_id) = 'Y'
            AND scy.slc2_sent = 'N'
            AND scy.sal_sent = 'Y'
            AND scy.slc1_sent = 'Y'
            AND scy.sal_dest IN ('1','R','A','M')
                AND scy.dearing = 'O'
            AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
            AND scy.latest_crse_ind = 'Y'
            AND (scy.slc2_status NOT IN ('E','R') OR scy.slc2_status IS NULL)
            AND (a.net_amount != 0 AND
                    a.stud_award_type = 'PTL');
-- end rFC 71 addition
    ELSIF p_filetype = 4 THEN
      --left at start as can only ever be 1 record in GE KL
      SELECT COUNT(*)
      INTO n_no_of_records
      FROM GRAD_ENDOW
      WHERE slc_file4_status = 'A';

   ELSE
         p_error_message := 'The filetype must be 1, 2, 3 or 4';
     RETURN(-1);
   END IF;
--
   CloseLogFile(pop_m263_debug_file_handle);

--
   RETURN (n_no_of_records);
--
  EXCEPTION
   WHEN fatal_error THEN -- fatal error in called function, stop processing.
      ROLLBACK;
      RETURN -1; -- return failure.
--
  --  Write file management errors to DBMS output.
    WHEN utl_file.invalid_operation THEN
        CloseLogFile(pop_m263_debug_file_handle);
        p_error_message := (' Debug file - File could not be opened ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
    WHEN utl_file.invalid_path THEN
        CloseLogFile(pop_m263_debug_file_handle);
        p_error_message := (' Debug file - Invalid file path ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
    WHEN utl_file.invalid_mode THEN
        CloseLogFile(pop_m263_debug_file_handle);
        p_error_message := (' Debug file - Invalid file mode specified ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
    WHEN utl_file.invalid_filehandle THEN
        CloseLogFile(pop_m263_debug_file_handle);
        p_error_message := (' Debug file - file specified is not open ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
    WHEN utl_file.write_error THEN
        CloseLogFile(pop_m263_debug_file_handle);
        p_error_message := (' Debug file - Error writing to debug file ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
   WHEN OTHERS THEN
      n_sqlcode := SQLCODE;
      v_sqlerrm := SQLERRM;
      p_error_message := 'The following fatal error occured in POP_M263.POP_M263 '||n_sqlcode||' '||SQLERRM;
      RETURN -1;
  END Pop_M263;
--
--
PROCEDURE WriteToLog (p_file_handle IN out utl_file.file_type, p_msg IN VARCHAR2) IS
-- Write string to log file pointed to by file_handle.
--
s_date VARCHAR2 (64);
s_tmp_msg VARCHAR2 (10000);
s_spaces VARCHAR2 (100) := '            ';
s_separator VARCHAR2 (100) := '---------------------------------------------------------------------------';
s_small_separator VARCHAR2 (100) := '----------------------------------------';
s_v_small_separator VARCHAR2 (100) := '---';
s_proc_env VARCHAR2(5);
--
BEGIN
--
    IF utl_file.is_open (p_file_handle) THEN
    /*---------------------------------------
    file opened, output any message required.
    ----------------------------------------*/
    SELECT TO_CHAR (SYSDATE, 'hh24:mi:ss dd mon yyyy')
        INTO s_date
        FROM dual;
--
    utl_file.fflush(p_file_handle);
    --utl_file.put_line(p_file_handle, s_v_small_separator);

    s_tmp_msg := s_date || ' ' || p_msg;
    utl_file.put_line(p_file_handle, s_tmp_msg);
    utl_file.fflush(p_file_handle);
    END IF;
--
   RETURN;
--
   EXCEPTION
   WHEN OTHERS THEN
        CloseLogFile(p_file_handle);
    RETURN;
END WriteTolog;
--
PROCEDURE CloseLogFile(p_file_handle IN out utl_file.file_type) IS
--
BEGIN
--
    IF (utl_file.is_open (p_file_handle)) THEN
        utl_file.fclose (p_file_handle);
    END IF;
--
    RETURN;
--
EXCEPTION
    WHEN OTHERS THEN
        RETURN;
END;
--
-- Loan Interface File Production
function ReadStudScyRec (p_flt_for_slc_rec in out flt_for_slc_struct,
                                p_stud_scy_rec in out stud_scy_struct,
                                p_error_message in out varchar2)return boolean is
--

ret_val boolean;
n_sqlcode NUMBER;
v_sqlerrm VARCHAR2(2000);
FindMaxFltScyId_Err exception;
--
BEGIN
--
   ret_val := TRUE;
    p_stud_scy_rec := null;
--
   if not FindMaxFltScyId (p_flt_for_slc_rec, p_error_message) then
      raise FindMaxFltScyId_Err;
   else -- remaining scy details found.
       select scy.stud_crse_year_id, scy.stud_ref_no, scy.dearing, scy.inst_code,
               scy.crse_code, scy.crse_id, scy.session_code, scy.scheme_type, s.scottish_cand
       into p_stud_scy_rec.stud_crse_year_id, p_stud_scy_rec.stud_ref_no, p_stud_scy_rec.dearing,
               p_stud_scy_rec.inst_code, p_stud_scy_rec.crse_code, p_stud_scy_rec.crse_id,
               p_stud_scy_rec.session_code, p_stud_scy_rec.scheme_type, p_stud_scy_rec.scottish_cand
       from stud s, stud_crse_year scy
       where scy.stud_crse_year_id = p_flt_for_slc_rec.stud_crse_year_id
       and s.stud_ref_no = scy.stud_ref_no;
   end if;
--
    return ret_val;
--
EXCEPTION
   when FindMaxFltScyId_Err then
      ret_val := false;
      return ret_val;
--
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        n_sqlcode := SQLCODE;
        v_sqlerrm := SQLERRM;
        p_error_message := 'The following fatal error occured in POP_M263.ReadStudScyRec '||n_sqlcode||' '||SQLERRM ||
               ' for student: ' || p_flt_for_slc_rec.stud_ref_no || ' session: ' ||
               p_flt_for_slc_rec.session_code || ' stud_crse_year_id: ' || p_flt_for_slc_rec.stud_crse_year_id;
        RETURN ret_val;
--
end;
--
--
FUNCTION FindFile1StudSessScyDetails (p_scy_id IN stud_crse_year.stud_crse_year_id%type,
                                         p_r1 in out c_f1_stud_loans%ROWTYPE,
                                         p_error_message in out varchar2,
                    p_debug_file_handle in out utl_file.file_type) RETURN BOOLEAN IS
--
ret_val BOOLEAN;
--
BEGIN
--
   ret_val := TRUE;
   p_r1 := NULL;
--
---------------------------------------
-- SCY details for students for file 1.
---------------------------------------

/* RH 16/01/2008 START */
SELECT iv1.stud_ref_no, iv1.stud_crse_year_id, iv1.session_code,
       iv1.sal_sent_date, iv1.scottish_cand, iv1.title, iv1.surname,
       iv1.forenames, iv1.loan_request, iv1.prev_loan_acc_no,
       iv1.provisional_case, iv1.inst_code, iv1.crse_code, iv1.ucas_no,
       iv1.crse_year_id, iv1.sex, iv1.dob, iv1.birth_surname,
       iv1.birth_forenames, iv1.district_birth_cert_issued, iv1.crse_year_no,
       iv1.birth_country_code, iv1.max_loan_requested, iv1.hei_payment_route,
       iv1.scheme_type, iv1.dearing, iv1.crse_id, iv1.withdraw_date,
       iv1.application_status, iv1.first_slc1_sent_date,
       iv1.stud_hei_bursary_consent, iv1.repeat_year,
       iv1.parent_contrib_exempt, iv1.ben1_id, iv1.ben2_id, iv1.no_ben,
       iv1.stud_session_id, iv1.award, iv1.household_resid_income,
       iv1.ben1_total_income, iv1.ben2_total_income, iv1.stud_loan_amount,
       iv1.sosb_amount
  INTO p_r1.stud_ref_no, p_r1.stud_crse_year_id, p_r1.session_code,
       p_r1.sal_sent_date, p_r1.scottish_cand, p_r1.title, p_r1.surname,
       p_r1.forenames, p_r1.loan_request, p_r1.prev_loan_acc_no,
       p_r1.provisional_case, p_r1.inst_code, p_r1.crse_code, p_r1.ucas_no,
       p_r1.crse_year_id, p_r1.sex, p_r1.dob, p_r1.birth_surname,
       p_r1.birth_forenames, p_r1.district_birth_cert_issued,
       p_r1.crse_year_no, p_r1.birth_country_code, p_r1.max_loan_requested,
       p_r1.hei_payment_route, p_r1.scheme_type, p_r1.dearing, p_r1.crse_id,
       p_r1.withdraw_date, p_r1.application_status,
       p_r1.first_slc1_sent_date, p_r1.stud_hei_bursary_consent,
       p_r1.repeat_year, p_r1.parent_contrib_exempt, p_r1.ben1_id,
       p_r1.ben2_id, p_r1.no_ben, p_r1.stud_session_id, p_r1.award,
       p_r1.household_resid_income, p_r1.ben1_total_income,
       p_r1.ben2_total_income, p_r1.stud_loan_amount, p_r1.sosb_amount    
  FROM (SELECT DISTINCT s.stud_ref_no, scy.stud_crse_year_id, ss.session_code,
                        scy.sal_sent_date, s.scottish_cand, s.title,
                        s.surname, s.forenames, ss.loan_request,
                        s.prev_loan_acc_no, scy.provisional_case,
                        scy.inst_code, scy.crse_code, s.ucas_no,
                        scy.crse_year_id, s.sex, s.dob, s.birth_surname,
                        s.birth_forenames, s.district_birth_cert_issued,
                        scy.crse_year_no, s.birth_country_code,
                        ss.max_loan_requested, scy.hei_payment_route,
                        scy.scheme_type, scy.dearing, scy.crse_id,
                        scy.withdraw_date, scy.application_status,
                        scy.first_slc1_sent_date,
                                                 --rfc204
                                                 ss.stud_hei_bursary_consent,
                        scy.repeat_year, scy.parent_contrib_exempt, ben1_id,
                        ben2_id,
                        DECODE (ss.ben2_id,
                                NULL, DECODE (ss.ben1_id, NULL, 0, 1),
                                DECODE (ss.ben1_id, NULL, 1, 2)
                               ) no_ben,
                        ss.stud_session_id,
                        DECODE (scy.award, 'E', 'N', 'Y') award,
                        scy.household_resid_income, scy.ben1_total_income,
                        scy.ben2_total_income
                                               --rfc204
                                             --rfc226
                        , NULL stud_loan_amount, NULL sosb_amount
                   --rfc226
        FROM            stud_crse_year scy, stud_session ss, stud s
                  WHERE scy.stud_crse_year_id = p_scy_id
                    AND ss.stud_ref_no = s.stud_ref_no
                    AND scy.stud_session_id = ss.stud_session_id
        UNION
        SELECT DISTINCT s.stud_ref_no, scy.stud_crse_year_id, ss.session_code,
                        scy.sal_sent_date, s.scottish_cand, s.title,
                        s.surname, s.forenames, ss.loan_request,
                        s.prev_loan_acc_no, scy.provisional_case,
                        scy.inst_code, scy.crse_code, s.ucas_no,
                        scy.crse_year_id, s.sex, s.dob, s.birth_surname,
                        s.birth_forenames, s.district_birth_cert_issued,
                        scy.crse_year_no, s.birth_country_code,
                        ss.max_loan_requested, scy.hei_payment_route,
                        scy.scheme_type, scy.dearing, scy.crse_id,
                        scy.withdraw_date, scy.application_status,
                        scy.first_slc1_sent_date, ss.stud_hei_bursary_consent,
                        scy.repeat_year, scy.parent_contrib_exempt, ben1_id,
                        ben2_id,
                        DECODE (ss.ben2_id,
                                NULL, DECODE (ss.ben1_id, NULL, 0, 1),
                                DECODE (ss.ben1_id, NULL, 1, 2)
                               ) no_ben,
                        ss.stud_session_id,
                        DECODE (scy.award, 'E', 'N', 'Y') award,
                        scy.household_resid_income, scy.ben1_total_income,
                        scy.ben2_total_income, NULL stud_loan_amount,
                        NULL sosb_amount
                   FROM steps_stud_crse_year scy,
                        steps_stud_session ss,
                        steps_stud s
                  WHERE scy.stud_crse_year_id = p_scy_id
                    AND ss.stud_ref_no = s.stud_ref_no
                    AND scy.stud_session_id = ss.stud_session_id) iv1;
/* RH 16/01/2008 END */
--
   RETURN ret_val;
--
EXCEPTION
--
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.FindFile1StudSessScyDetails '||SQLCODE||' '||SQLERRM;
        RETURN ret_val;
END;
--
FUNCTION FindFile2StudSessScyDetails (p_f2_flt_rec IN flt_for_f2_slc_struct,
                       p_r1 in out c_f2_stud_loans%ROWTYPE,
                       p_error_message in out varchar2) RETURN BOOLEAN IS
--
ret_val BOOLEAN;
scy_id stud_crse_year.stud_crse_year_id%type;
--
BEGIN
--
   ret_val := TRUE;
   scy_id := null;
   p_r1 := NULL;
--
   select max(stud_crse_year_id)
   into scy_id
   from fee_loan_transaction
   where stud_ref_no = p_f2_flt_rec.stud_ref_no
   and session_code = p_f2_flt_rec.session_code;
   --and txn_interest_accrual_date = p_f2_flt_rec.txn_interest_accrual_date;
--
   if (scy_id is not null) then
      ---------------------------------------
      -- SCY details for students for file 2.
      ---------------------------------------
      SELECT DISTINCT s.stud_ref_no, scy.stud_crse_year_id,
             ss.session_code, scy.sal_sent_date,
             s.scottish_cand, s.title, s.surname, s.forenames,
             ss.loan_request, scy.crse_code, scy.inst_code,
             s.addr_corr_flag, s.prev_loan_acc_no,
             s.sort_code, s.account_no, s.build_soc_no,
             s.bankrupt_flag, s.ni_no, ss.loan_declaration_date,
             scy.corres_dest, ss.max_loan_requested, scy.scheme_type,
             scy.dearing, scy.crse_id, ss.fee_loan_declaration_date,
             ss.reason_no_nino
          into
             p_r1.stud_ref_no, p_r1.stud_crse_year_id,
             p_r1.session_code, p_r1.sal_sent_date, p_r1.scottish_cand,
             p_r1.title, p_r1.surname, p_r1.forenames,
             p_r1.loan_request, p_r1.crse_code, p_r1.inst_code,
             p_r1.addr_corr_flag, p_r1.prev_loan_acc_no,
             p_r1.sort_code, p_r1.account_no, p_r1.build_soc_no,
             p_r1.bankrupt_flag, p_r1.ni_no, p_r1.loan_declaration_date,
             p_r1.corres_dest, p_r1.max_loan_requested, p_r1.scheme_type,
             p_r1.dearing, p_r1.crse_id, p_r1.fee_loan_declaration_date,
             p_r1.reason_no_nino
       FROM STUD_CRSE_YEAR scy,
            STUD_SESSION ss,
            STUD s
       WHERE scy.stud_crse_year_id = scy_id
               and ss.stud_ref_no = s.stud_ref_no
                AND scy.stud_session_id = ss.stud_session_id;
--
   else
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'Failed to find stud_crse_year_id in POP_M263.FindFile2StudSessScyDetails '||SQLCODE||' '||SQLERRM;
   end if;
--
   RETURN ret_val;
--
EXCEPTION
--
WHEN OTHERS THEN
    -- report error to logfile and stop processing.
    ret_val := false;
    p_error_message := 'The following fatal error occured in POP_M263.FindFile2StudSessScyDetails '||SQLCODE||' '||SQLERRM;
    RETURN ret_val;
--
END;
--
--
function TotalSessFeeLoanDebt (p_f2_flt_rec in flt_for_f2_slc_struct,
                  p_sd in out slc_data%rowtype,
                  p_error_message in out varchar2)return boolean is
--
ret_val boolean;
n_sqlcode NUMBER;
v_sqlerrm VARCHAR2(2000);
sum_session_txns fee_loan_transaction.txn_amount%type;
--
BEGIN
--
   ret_val := TRUE;
    p_sd.total_fee_loan_amount := 0;
--
   SELECT    (SUM(DECODE(txn_dc_flg,'D',txn_amount,0)) -
        SUM(DECODE(txn_dc_flg,'C',txn_amount,0)))
   INTO        p_sd.total_fee_loan_amount
   FROM         FEE_LOAN_TRANSACTION
   WHERE     stud_ref_no = p_f2_flt_rec.stud_ref_no
   AND        session_code = p_f2_flt_rec.session_code
   AND        nvl (status, 'Z') <> 'X'; -- fee loan transaction record has not been cancelled
--
    return ret_val;
--
EXCEPTION
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        n_sqlcode := SQLCODE;
        v_sqlerrm := SQLERRM;
        p_error_message := 'The following fatal error occured in POP_M263.FindTotalFeeLoanForSess '||n_sqlcode||' '||SQLERRM ||
               ' for student: ' || p_f2_flt_rec.stud_ref_no || ' session: ' ||  p_f2_flt_rec.session_code;
        RETURN ret_val;
--
end;
--
function ChkOkToSendFlt (flt_for_slc_rec in flt_for_slc_struct,
            p_latest_loan_elig_scy_id in out stud_crse_year.stud_crse_year_id%type,
            p_error_message in out varchar2)return boolean is
--
fatal_error exception;
ret_val boolean;
scy_rec stud_crse_year%rowtype;
aw_rec award%rowtype;
exit_loop boolean;
stud_has_fee_loan boolean;
stud_has_stud_loan boolean;
--
cursor c_stud_scy (p_stud_ref_no stud_crse_year.stud_ref_no%type,
                            p_session_code stud_crse_year.session_code%type) is
/* RH 16/01/2008 START */
SELECT   iv1.stud_crse_year_id, iv1.slc1_status, iv1.sal_sent, iv1.sal_sent_date
    FROM (SELECT scy.stud_crse_year_id, scy.slc1_status, scy.sal_sent,
                 scy.sal_sent_date
            FROM stud_crse_year scy
           WHERE scy.stud_ref_no = p_stud_ref_no
             AND scy.session_code = p_session_code
          UNION
          SELECT scy.stud_crse_year_id, scy.slc1_status, scy.sal_sent,
                 scy.sal_sent_date
            FROM steps_stud_crse_year scy
           WHERE scy.stud_ref_no = p_stud_ref_no
             AND scy.session_code = p_session_code) iv1
ORDER BY iv1.stud_crse_year_id DESC;            -- process newest scy_id first.
/* RH 16/01/2008 END */
--
BEGIN
--
   ret_val := TRUE;
    exit_loop := false;
    p_latest_loan_elig_scy_id := null;
    stud_has_fee_loan := false;
   stud_has_stud_loan := false;
   p_error_message := null;
--
    if not c_stud_scy%isopen then
        OPEN c_stud_scy (flt_for_slc_rec.stud_ref_no, flt_for_slc_rec.session_code);
    end if;
--
    while not exit_loop loop
        scy_rec := null;
        aw_rec := null;
      stud_has_fee_loan := false;
      stud_has_stud_loan := false;
---
        FETCH c_stud_scy INTO scy_rec.stud_crse_year_id, scy_rec.slc1_status, scy_rec.sal_sent, scy_rec.sal_sent_date;
--
      WriteToLog (pop_m263a_debug_file_handle, '... Processing ' || scy_rec.stud_crse_year_id || ' ' ||
                    scy_rec.slc1_status || ' ' || scy_rec.sal_sent || ' ' ||
                    scy_rec.sal_sent_date);

        IF c_stud_scy%NOTFOUND THEN -- loan bearing scy was not found.
            p_latest_loan_elig_scy_id := null;
            --stud_has_fee_loan := false;
            exit_loop := true;
     p_error_message := 'Failed to send a file 1 fee loan record to the SLC. ' ||
                'Either the Letter of Award has not been sent or the file 1 student loan status is in error or rejected, please check.';
        else
     if (nvl(scy_rec.slc1_status, 'Z') not in ('E', 'R')) --- file 1 status not in error.
        and (scy_rec.sal_sent_date is not null) then --- loa sent ok
---
        if not exit_loop then
           if not slc_util.StudHasStudLoan (scy_rec.stud_crse_year_id, stud_has_stud_loan, p_error_message, pop_m263a_debug_file_handle) then
               raise fatal_error; --- does a student loan exist?
           elsif stud_has_stud_loan then
                       p_latest_loan_elig_scy_id := scy_rec.stud_crse_year_id;
                       exit_loop := true; -- exit loop and function as stud loan rec found.
           end if;
        end if;
---
        if not exit_loop then
           --- check for fee or stud loan in this scy.
           if not slc_util.StudHasFeeLoan (scy_rec.stud_crse_year_id, stud_has_fee_loan, p_error_message, pop_m263a_debug_file_handle) then
               raise fatal_error;
           elsif stud_has_fee_loan then --- fee loan exists.
                       p_latest_loan_elig_scy_id := scy_rec.stud_crse_year_id;
                       exit_loop := true; -- exit loop and function as fee loan rec found.
           end if;
        end if;
---
        if (stud_has_fee_loan or stud_has_stud_loan) then
                  p_latest_loan_elig_scy_id := scy_rec.stud_crse_year_id;
                  exit_loop := true; -- exit loop and function as valid scy rec found.
           WriteToLog (pop_m263a_debug_file_handle, '+++ Sending scy data to SLC for scy_id ' || p_latest_loan_elig_scy_id);
        else
           WriteToLog (pop_m263a_debug_file_handle, '--- Student does not have fee or stud loan. Checking earlier scy.');
        end if;
     else
        WriteToLog (pop_m263a_debug_file_handle, '--- File 1 status in error or loa not sent for ' || scy_rec.stud_crse_year_id || ' Checking earlier scy.');
     end if;
      end if;
--
    end loop;
--
    if c_stud_scy%isopen then
        CLOSE c_stud_scy;
    end if;
--
    return ret_val;
--
EXCEPTION
    when fatal_error then
        if c_stud_scy%isopen then
            CLOSE c_stud_scy;
        end if;
--
        ret_val := false;
        RETURN ret_val;
--
    WHEN OTHERS THEN
        if c_stud_scy%isopen then
            CLOSE c_stud_scy;
        end if;
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.ChkOkToSendFlt '||SQLCODE||' '||SQLERRM ||
             ' Student: ' || flt_for_slc_rec.stud_ref_no || ' Session: ' || flt_for_slc_rec.session_code;
        RETURN ret_val;
--
end;
--
function UpdSlcBatches (p_filename in varchar2, p_filedate in date,
            p_number_of_records in number,
            p_num_stud_loans in slc_batches.student_loan_record_count%type,
            p_num_fee_loans in slc_batches.fee_loan_record_count%type,
            p_sum_dr in slc_batches.total_fee_loan_dr%type,
            p_sum_cr in slc_batches.total_fee_loan_cr%type,
            p_error_message in out varchar2,
            p_debug_file_handle in out utl_file.file_type) return boolean is
--
ret_val boolean;
--
BEGIN
--
   ret_val := TRUE;
--
    if ret_val then
      UPDATE SLC_BATCHES
      SET record_count = p_number_of_records,
      student_loan_record_count = p_num_stud_loans,
      fee_loan_record_count = p_num_fee_loans,
      total_fee_loan_cr = p_sum_cr,
      total_fee_loan_dr = p_sum_dr
      WHERE slc_filename  = p_filename
      AND slc_file_date = p_filedate;
    end if;
--
   WriteToLog (p_debug_file_handle, 'UpdSlcBatches ok for ' || p_filename || ' ' || p_filedate ||
                    ' ' || p_number_of_records || ' ' || p_num_stud_loans ||
                    ' ' ||  p_num_fee_loans || ' ' || p_sum_cr ||
                    ' ' || p_sum_dr);
    return ret_val;
--
EXCEPTION
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.UpdSlcBatches '|| SQLCODE || ' ' || SQLERRM;
--
        RETURN ret_val;
--
end;
--
function SetFeeLoanTxnToCancel (p_error_message in out VARCHAR2, p_flt_ctr in out number) return boolean is
--
--
cursor c_flt_to_cancel is
SELECT stud_ref_no, session_code, txn_interest_accrual_date,
    SUM(DECODE(txn_dc_flg,'D',txn_amount,0)) - SUM(DECODE(txn_dc_flg,'C',txn_amount,0)) sum_txns
    FROM FEE_LOAN_TRANSACTION
    WHERE nvl (status, 'Z') IN ('Z',FEE_LOAN_TXN_CORRECTED) -- record has not been sent before or has been corrected after a failure and awaiting re-submission
    GROUP BY stud_ref_no, session_code, txn_interest_accrual_date;
--
ret_val boolean;
n_sqlcode NUMBER;
v_sqlerrm VARCHAR2(2000);
v_error_description    VARCHAR2(2000);
c_flt_to_cancel_rec c_flt_to_cancel%rowtype;
exit_loop boolean;
--
BEGIN
--
   ret_val := TRUE;
    c_flt_to_cancel_rec := null;
    exit_loop := false;
    p_flt_ctr := 0;
--
    if not c_flt_to_cancel%isopen then
        open c_flt_to_cancel;
    end if;
--
--    For each student having flt debits and credits summing to 0, set status to X (cancelled).
    while not exit_loop loop
        c_flt_to_cancel_rec := null;
        FETCH c_flt_to_cancel into c_flt_to_cancel_rec;
--
        if c_flt_to_cancel%notfound then
            exit_loop := true;
        else
            if (c_flt_to_cancel_rec.sum_txns = 0) then
                update fee_loan_transaction
                set status = FEE_LOAN_TXN_CANCELLED,
           status_changed_date = sysdate
                where stud_ref_no = c_flt_to_cancel_rec.stud_ref_no
                and session_code = c_flt_to_cancel_rec.session_code
                and txn_interest_accrual_date = c_flt_to_cancel_rec.txn_interest_accrual_date
        and nvl (status, 'Z') IN ('Z',FEE_LOAN_TXN_CORRECTED);
--
                p_flt_ctr := (p_flt_ctr + 1);
            end if;
        end if;
--
    end loop;
--
    if c_flt_to_cancel%isopen then
        close c_flt_to_cancel;
    end if;
--
    return ret_val;
--
EXCEPTION
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        n_sqlcode := SQLCODE;
        v_sqlerrm := SQLERRM;
        p_error_message := 'The following fatal error occured in POP_M263.SetFeeLoanTxnToCancel '||n_sqlcode||' '||SQLERRM ||
                                ' stud_ref_no: ' || c_flt_to_cancel_rec.stud_ref_no || ' session: ' || c_flt_to_cancel_rec.session_code;
--
        if c_flt_to_cancel%isopen then
            close c_flt_to_cancel;
        end if;
--
        RETURN ret_val;
--
end;
--
function InsFile2SlcData (    p_r1 in out c_f2_stud_loans%ROWTYPE,
               p_r2 in out c_f2_sha%ROWTYPE,
               p_r3 in out c_f2_sta%ROWTYPE,
               p_r4 in out c_f2_scd_1%ROWTYPE,
               p_r5 in out c_f2_scd_2%ROWTYPE,
               p_sd in out slc_data%rowtype,
               p_form_type in slc_data.form_type%type,
        p_ins_ok in out boolean,
               p_error_message in out VARCHAR2,
               p_debug_file_handle in out utl_file.file_type)return boolean is
--
ret_val boolean;
n_sqlcode NUMBER;
v_sqlerrm VARCHAR2(2000);
v_error_description    VARCHAR2(2000);
--
BEGIN
--
   ret_val := TRUE;
--
   WriteToLog (p_debug_file_handle, 'InsFile2SlcData for ' || p_sd.slc_filename || ' ' ||
           p_sd.slc_file_date || ' ' || p_r1.stud_crse_year_id || ' ' ||
           p_sd.record_type || ' ' || p_sd.interest_accrual_date);
--
   INSERT INTO SLC_DATA
      (slc_filename, slc_file_date, stud_crse_year_id,
      form_type, VALIDATION, academic_year,
      issue_date, slc_ref_no, title,
      surname, forenames, total_loan_claimed,
      home_addr_l1, home_addr_l2, home_addr_l3,
      home_addr_l4, home_post_code, home_tele_no, term_addr_l1,
      term_addr_l2, term_addr_l3, term_addr_l4,
      term_post_code, term_tele_no, corres_ind,
      prev_loan_acc_no, first_cont_name, first_cont_rel_code,
      first_cont_addr1, first_cont_addr2, first_cont_addr3,
      first_cont_postcode, first_cont_tel_no, second_cont_name,
      second_cont_addr1, second_cont_addr2, second_cont_addr3,
      second_cont_postcode, second_cont_tel_no, sort_code,
      account_no, build_soc_no, bankrupt_flag,
      ni_number, declaration_date, record_type,
      interest_accrual_date, fee_loan_amount, dc_flag, total_fee_loan_amount,
      reason_no_nino, loan_payment_method, file2_rec_status, rec_status_changed_date)
   VALUES
      (p_sd.slc_filename, p_sd.slc_file_date, p_r1.stud_crse_year_id,
      p_form_type, 'V', p_r1.session_code,
      p_r1.sal_sent_date, p_r1.scottish_cand, SUBSTR(p_r1.title,1,4),
      p_r1.surname, p_r1.forenames, p_sd.total_loan_claimed,
      SUBSTR(p_r2.addr_l1,1,60), SUBSTR(p_r2.addr_l2,1,60), p_r2.addr_l3,
      p_r2.addr_l4, p_r2.post_code, p_r2.tele_no, SUBSTR(p_r3.addr_l1,1,60),
      SUBSTR(p_r3.addr_l2,1,60), p_r3.addr_l3, p_r3.addr_l4,
      p_r3.post_code, p_r3.tele_no, p_sd.corres_ind,
      p_r1.prev_loan_acc_no, p_r4.cont_name, p_r4.cont_rel_code,
      p_r4.cont_addr1, p_r4.cont_addr2, p_r4.cont_addr3,
      p_sd.first_cont_postcode, p_r4.cont_tel_no, p_r5.cont_name,
      p_r5.cont_addr1, p_r5.cont_addr2, p_r5.cont_addr3,
      p_sd.second_cont_postcode, p_r5.cont_tel_no, p_r1.sort_code,
      p_r1.account_no, p_r1.build_soc_no, nvl(p_r1.bankrupt_flag, 'N'),
      p_r1.ni_no, p_r1.loan_declaration_date, p_sd.record_type,
      p_sd.interest_accrual_date, p_sd.fee_loan_amount, p_sd.dc_flag, p_sd.total_fee_loan_amount,
      p_sd.reason_no_nino, p_sd.loan_payment_method, 'S' /*p_sd.file2_rec_status*/, p_sd.rec_status_changed_date);
--
      WriteToLog (p_debug_file_handle, 'InsFile2SlcData ok');
    return ret_val;
--
EXCEPTION
--
    WHEN OTHERS THEN
   n_sqlcode := SQLCODE;
   v_sqlerrm := SQLERRM;
   if (n_sqlcode = -1) then -- constraint error, miss out this record until next batch / file.
      p_ins_ok := false;
      WriteToLog (pop_m263b_debug_file_handle, '--- The following fatal error occured in InsFile2SlsData for filename ' || p_sd.slc_filename ||
             ' file date ' || p_sd.slc_file_date || ' scy_id ' || p_r1.stud_crse_year_id ||
             ' and record type ' || p_sd.record_type || ' when inserting into to slc_data. ' ||
        SQLERRM || ' Updating stud_session.slc1_fl_sent to N. Leaving and will insert into next file.' );
---
      if not UpdSSFlSentFlagToN (p_r1.stud_ref_no, p_r1.session_code, p_error_message) then
     ret_val := false;
      end if;
---
      return ret_val;
   else
      -- report error to logfile and stop processing.
      ret_val := false;
      n_sqlcode := SQLCODE;
      v_sqlerrm := SQLERRM;
      p_error_message := 'The following fatal error occured for ' || p_sd.slc_filename ||
      p_sd.slc_file_date || ' student ' || p_r1.stud_ref_no || 'stud_crse_year_id ' ||
      p_r1.stud_crse_year_id || ' in POP_M263.InsFile2SlcData '|| n_sqlcode || ' ' || SQLERRM;
        RETURN ret_val;
   end if;
--
end;
--
function InsFile1SlcData (    p_r1 in out c_f1_stud_loans%ROWTYPE,
                                  p_r2 in out c_f1_sha%ROWTYPE,
                                  p_r5 in out c_f1_country%ROWTYPE,
                                  p_sd in out slc_data%rowtype,
               p_form_type in slc_data.form_type%type,
                                  p_error_message in out VARCHAR2,
               p_debug_file_handle in out utl_file.file_type)return boolean is
--
ret_val boolean;
n_sqlcode NUMBER;
v_sqlerrm VARCHAR2(2000);
v_error_description    VARCHAR2(2000);
--
BEGIN
--
   ret_val := TRUE;
--
    INSERT INTO SLC_DATA
           (slc_filename, slc_file_date, stud_crse_year_id,
                form_type, VALIDATION, academic_year,
                issue_date, status, hei_payment_route,
                slc_ref_no,
                ucas_no, prev_loan_acc_no, hei_inst_name,
                hei_inst_code, hei_crse_code, crse_year_no,
                hei_crse_name, title, surname,
                forenames, home_addr_l1, home_addr_l2,
                home_addr_l3, home_addr_l4, home_post_code,
                home_tele_no, sex, dob,
                end_date, birth_surname, birth_forenames,
                district_birth_cert_issued, birth_country, fee_support_avail,
                da, living_cost_loan, da1,
                da2, da3, total_assessed_cont
                ,student_consent ,benefactor1_consent ,benefactor2_consent
                ,repeat_year,number_of_benefactors  ,non_means_tested
                ,number_of_dependants ,household_resid_income ,ben1_total_income
                ,ben2_total_income, record_type,
    TOTAL_SOSB_ENTITLEMENT,TOTAL_FEE_LOAN_AVAILABLE)
          VALUES
           (p_sd.slc_filename, p_sd.slc_file_date, p_r1.stud_crse_year_id,
                p_form_type, 'V', p_r1.session_code,
                p_r1.sal_sent_date, p_sd.status, p_r1.hei_payment_route,
                p_r1.scottish_cand,
                p_r1.ucas_no, p_r1.prev_loan_acc_no, p_sd.hei_inst_name,
                p_sd.hei_inst_code, p_sd.hei_crse_code, p_r1.crse_year_no,
                p_sd.hei_crse_name, SUBSTR(p_r1.title,1,4), p_r1.surname,
                p_r1.forenames, p_r2.addr_l1, p_r2.addr_l2,
                p_r2.addr_l3, p_r2.addr_l4, p_r2.post_code,
                p_r2.tele_no, p_r1.sex, p_r1.dob,
                p_sd.end_date, p_sd.birth_surname, p_sd.birth_forenames,
                p_r1.district_birth_cert_issued, p_r5.birth_country, 0,
                0, p_sd.living_cost_loan, 0,
                0, 0, 0
                ,p_sd.student_consent ,p_sd.benefactor1_consent ,p_sd.benefactor2_consent
                ,p_sd.repeat_year,p_sd.number_of_benefactors, p_sd.non_means_tested
                ,p_sd.number_of_dependants ,p_sd.household_resid_income ,p_sd.ben1_total_income
                ,p_sd.ben2_total_income, p_sd.record_type
    ,p_sd.total_sosb_entitlement,p_sd.total_fee_loan_available);
--
      WriteToLog (p_debug_file_handle, 'InsSlcData ok');
    return ret_val;
--
EXCEPTION
--
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        n_sqlcode := SQLCODE;
        v_sqlerrm := SQLERRM;
        p_error_message := 'The following fatal error occured in POP_M263.InsSlcData '||n_sqlcode||' '||SQLERRM;
        RETURN ret_val;
--
end;
--
--
function CreateFile1(p_r1 in out c_f1_stud_loans%ROWTYPE,
             p_r2 in out c_f1_sha%ROWTYPE,
             p_r5 in out c_f1_country%ROWTYPE, p_sd in out slc_data%rowtype,
             p_filename IN VARCHAR2, p_filedate IN DATE,
             p_b_record_valid in out boolean,
             p_loan_type in slc_errors.record_type_error%type,
             p_error_message in out VARCHAR2)
    return boolean is
--
    ret_val boolean;
--
     v_error_description    VARCHAR2(2000);
     v_inst_code        HEI_INST.hei_inst_code%TYPE;
     v_inst_name        HEI_INST.hei_inst_name%TYPE;
     v_crse_code        HEI_CRSE.hei_crse_code%TYPE;
     v_crse_name        HEI_CRSE.hei_crse_name%TYPE;
--
     n_return_no        NUMBER;
     n_sqlcode            NUMBER;
     v_sqlerrm            VARCHAR2(2000);
--
begin
--
    ret_val := true;
--
-- Find stud_home_address
    if not c_f1_sha%isopen then
        OPEN  c_f1_sha (p_r1.stud_ref_no);
    end if;
--
    p_r2 := null;
    FETCH c_f1_sha INTO p_r2;
--
    if c_f1_sha%isopen then
        CLOSE c_f1_sha;
    end if;
--
    v_inst_code := NULL;
    v_inst_name := NULL;
    v_crse_code := NULL;
    v_crse_name := NULL;
--
-- Check for valid inst_code.
    n_return_no :=    Slc_Util.slc_inst_code(p_r1.stud_crse_year_id,
                                                        v_inst_code,
                                                        v_inst_name);
--
    IF n_return_no != 0  AND (v_inst_code IS NULL OR v_inst_name IS NULL) THEN
       IF n_return_no = 1 AND v_inst_code IS NULL THEN
          v_error_description := 'HEI institution code is missing';
       ELSIF n_return_no = 2 AND v_inst_name IS NULL THEN
          v_error_description := 'HEI institution name is missing';
       ELSIF n_return_no = 3 THEN
          v_error_description := 'Runtime error occurred in SLC_UTIL.SLC_INST_CODE - Inform B.S.U';
       ELSIF n_return_no !=1 AND n_return_no != 2 AND n_return_no != 3 THEN
          v_error_description := 'Unrecognised code returned from SLC_UTIL.SLC_INST_CODE - Inform B.S.U';
       END IF;
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 1,
              p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
              p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
              SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
-- Check for valid crse_code.
    n_return_no :=    Slc_Util.slc_crse_code(p_r1.stud_crse_year_id,
                                                       v_inst_code,
                                                       v_crse_code,
                                                       v_crse_name);
--
    IF n_return_no != 0 AND (v_crse_code IS NULL OR v_crse_name IS NULL) THEN
       IF n_return_no = 1 AND v_crse_code IS NULL THEN
          v_error_description := 'HEI course code is missing';
       ELSIF n_return_no = 2 AND v_crse_name IS NULL THEN
          v_error_description := 'HEI course name is missing';
       ELSIF n_return_no = 3 THEN
          v_error_description := v_error_description || ' Runtime error occurred in SLC_UTIL.SLC_CRSE_CODE - Inform B.S.U';
       ELSIF n_return_no !=1 AND n_return_no != 2 AND n_return_no != 3 THEN
          v_error_description := 'Unrecognised code returned from SLC_UTIL.SLC_CRSE_CODE - Inform B.S.U';
       END IF;
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 1,
              p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
              p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
              SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
    p_sd.hei_inst_name := substr(v_inst_name, 1, 25);
    p_sd.hei_inst_code := v_inst_code;
    p_sd.hei_crse_name := substr(v_crse_name, 1, 25);
    p_sd.hei_crse_code := v_crse_code;
--
-- Read country table.
    if not c_f1_country%isopen then
        OPEN  c_f1_country (p_r1.birth_country_code);
    end if;
--
    p_r5.birth_country := NULL;
    FETCH c_f1_country INTO p_r5;
--
    if c_f1_country%isopen then
        CLOSE c_f1_country;
    end if;
--
-- Issue Date / sal_sent_date.
------------------------------
   if (p_loan_type = STUD_LOAN) then
       IF p_r1.sal_sent_date IS NULL THEN
          -- SAL sent date cannot be null
          v_error_description := 'The sal_sent date cannot be null';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 1,
                 p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
                 p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
                 SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
          p_b_record_valid := FALSE;
       END IF;
   else -- processing a fee loan.
      p_r1.sal_sent_date := sysdate;
   end if;
--
    IF p_r1.scottish_cand IS NULL THEN
       -- Student SLC Reference Number is a mandatory field
       v_error_description := 'Student SLC reference number is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 1,
              p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
              p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
              SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
      writetolog (pop_m263a_debug_file_handle, 'Student SLC reference number is missing');
    END IF;
    IF p_r1.crse_year_no IS NULL THEN
       v_error_description := 'Corresponding crse_year_no is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 1,
              p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
              p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
              SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
    IF p_r1.crse_year_no > 9 OR p_r1.crse_year_no < 1 THEN
       v_error_description := 'The crse_year_no must be between 1 and 9';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 1,
              p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
              p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
              SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
-- Find Student loan amount (living cost loan) if in attendance and not withdrawn.
----------------------------------------------------------------------------------
   p_sd.living_cost_loan := LPAD('0.00',7,0);
   if (p_loan_type = STUD_LOAN) then
      IF (p_r1.application_status <> 'A' and --- stud is in attendance.
     (p_r1.withdraw_date is null)) then --- stud has not withdrawn.
        --- derive the loan available for living costs.
        n_return_no := Slc_Util.available_as_loan(p_r1.stud_crse_year_id,
                               p_sd.living_cost_loan);
        IF n_return_no != 0 THEN
            IF n_return_no = 1 THEN
               v_error_description := 'The awards record is missing';
            ELSIF n_return_no = 2 THEN
               v_error_description := 'The available_as_loan function failed';
            ELSE
               v_error_description := 'Unrecognised code returned from SLC_UTIL.AVAILABLE_AS_LOAN - Inform B.S.U';
            END IF;
            pop_m263_error(p_filename, p_filedate, 1,
                   p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
                   p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
                   SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
            p_b_record_valid := FALSE;
            END IF;
      END IF;
   end if;
--
-- Home Address.
----------------
    -- check to see if loan request is greater than the total loan available.
    IF p_r2.addr_l1 IS NULL THEN
       -- Home address line 1 is mandatory
       v_error_description := 'Student home address line 1 is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 1,
              p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
              p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
              SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
    IF p_r2.addr_l2 IS NULL AND p_r2.addr_l3 IS NULL AND p_r2.addr_l4 IS NULL THEN
       -- At least one of the above must be supplied.
       v_error_description := 'Student home address line 2, 3 and 4 are missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 1,
              p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
              p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
              SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
    p_sd.home_post_code := NULL;
    IF p_r2.post_code IS NOT NULL THEN
       -- home post code is optional. Only validate if supplied.
       IF NOT pop_m263_postcode(p_r2.post_code,
                    p_sd.home_post_code) THEN
          -- postcode is in an invalid format
          v_error_description := 'The format of post code '||p_r2.post_code||' is incorrect';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 1,
                 p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
                 p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
                 SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
          p_b_record_valid := FALSE;
       END IF;
    END IF;
--
-- Course End Date
------------------
   n_return_no := Slc_Util.course_end_date(p_r1.inst_code,
                           p_r1.crse_code,
                           p_r1.session_code,
                           p_r1.crse_year_no,
                           p_sd.end_date);
   IF n_return_no != 0 THEN
      IF n_return_no = 1 THEN
     v_error_description := 'The Course End Date is missing';
      ELSE
     v_error_description := 'Unrecognised code returned from SLC_UTIL.COURSE_END_DATE - Inform B.S.U';
      END IF;
      -- Validation failed. Insert error into slc_errors
      pop_m263_error(p_filename, p_filedate, 1,
                 p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
                 p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
                 SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
      p_b_record_valid := FALSE;
   END IF;
-- Check on withdrawal and non attendance.
   IF p_r1.withdraw_date IS NOT NULL THEN -- fee loan withdrawal.
--    Reset course end date as stud has withdrawn.
      p_sd.end_date := TO_CHAR(p_r1.withdraw_date,'MMYYYY');
   ELSIF p_r1.application_status = 'A' THEN -- fee loan non attendance.
--    Reset course end date as stud has not attended.
      p_sd.end_date := NULL;
   ELSE -- stud has attended.
      null; -- normal course end date selected above.
   END IF;
--
-- Birth Surname, Forename.
---------------------------
    IF p_r1.district_birth_cert_issued IS NULL THEN
       v_error_description := 'District or sub-district where birth certificate was issued is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 1,
              p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
              p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
              SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
    p_sd.birth_surname := NULL;
    IF p_r1.birth_surname IS NOT NULL THEN
       IF p_r1.birth_surname != p_r1.surname THEN
          p_sd.birth_surname := p_r1.birth_surname;
       END IF;
    END IF;
    p_sd.birth_forenames := NULL;
    IF p_r1.birth_forenames IS NOT NULL THEN
       IF p_r1.birth_forenames != p_r1.forenames THEN
          p_sd.birth_forenames := p_r1.birth_forenames;
       END IF;
    END IF;
--
    IF p_r5.birth_country IS NULL THEN
       v_error_description := 'Birth Country is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 1,
              p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
              p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
              SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
    IF LENGTH(p_r2.tele_no) > 14 THEN
       v_error_description := 'The number of characters contained in the home telephone number exceeds the maximum of 14';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 1,
              p_r1.stud_crse_year_id, p_r1.stud_ref_no, p_r1.inst_code,
              p_r1.crse_code, p_r1.crse_id, p_r1.session_code, p_r1.scottish_cand,
              SUBSTR(v_error_description,1,255), p_r1.scheme_type, p_r1.dearing, p_loan_type);
       p_b_record_valid := FALSE;
    END IF;
--
--
-- Set up status
----------------
   if (p_loan_type = STUD_LOAN) then
       IF p_r1.withdraw_date IS NOT NULL THEN -- stud has withdrawn.
           p_sd.status := 'W';
       ELSIF p_r1.application_status = 'A' THEN -- stud has not attended.
           p_sd.status := 'A';
       ELSE -- stud has attended, set up status.
          IF p_r1.provisional_case = 'Y' THEN
              p_sd.status := 'P';
          ELSE
              p_sd.status := 'F';
          END IF;
       END IF;
   else -- Fee loan
       IF p_r1.withdraw_date IS NOT NULL THEN -- fee loan withdrawal.
           p_sd.status := 'X';
       ELSIF p_r1.application_status = 'A' THEN -- fee loan non attendance.
           p_sd.status := 'C';
       ELSE -- stud has attended.
           p_sd.status := 'E';
       END IF;
   end if;
--
-- Set record type.
-------------------
   p_sd.record_type := p_loan_type;
--
--rfc226
       BEGIN
     OPEN cur_get_award_amount(p_r1.stud_crse_year_id,'T',NULL);
     FETCH cur_get_award_amount INTO p_r1.stud_loan_amount;
     IF cur_get_award_amount%NOTFOUND OR p_r1.stud_loan_amount IS NULL THEN
        p_r1.stud_loan_amount := 0;
      END IF;
     CLOSE cur_get_award_amount;
     EXCEPTION
     WHEN OTHERS THEN
          p_r1.stud_loan_amount := 0;
      END;
      BEGIN
     OPEN cur_get_award_amount(p_r1.stud_crse_year_id,'A','SOSB');
     FETCH cur_get_award_amount INTO p_r1.sosb_amount;
     IF cur_get_award_amount%NOTFOUND OR p_r1.sosb_amount IS NULL THEN
        p_r1.sosb_amount := 0;
     END IF;
     CLOSE cur_get_award_amount;
      EXCEPTION
     WHEN OTHERS THEN
     p_r1.sosb_amount := 0;
      END;
 --end rfc226
        --rfc204
       IF p_r1.dearing = 'G' and p_r1.session_code >= 2006 THEN  --IF 1
    --   dbms_output.put_line('consent check :'||p_r1.stud_ref_no||'-'||p_r1.stud_hei_bursary_consent);
           IF p_r1.stud_hei_bursary_consent = 'Y' THEN --STUDENT HAS CONSENTED FOR INFO TO BE SHARED IF2
        --COUNT NUMBER OF DEPENDENTS
            /* RH 16/01/2008 START */
            SELECT iv1.grass_count + iv2.steps_count
              INTO p_sd.number_of_dependants
              FROM (SELECT COUNT (*) grass_count
                  FROM stud_dependant
                 WHERE stud_session_id = p_r1.stud_session_id
                   AND session_code = p_r1.session_code
                   AND stud_ref_no = p_r1.stud_ref_no
                   AND relation_id = '48') iv1,
                   (SELECT COUNT (*) steps_count
                  FROM steps_stud_dependant
                 WHERE stud_session_id = p_r1.stud_session_id
                   AND session_code = p_r1.session_code
                   AND stud_ref_no = p_r1.stud_ref_no
                   AND relation_id = '48') iv2;
            /* RH 16/01/2008 END */
             IF p_r1.no_ben = 0 THEN
                IF p_r1.parent_contrib_exempt = 'Y' THEN -- STUDENT IS BENEFACTOR EXEMPT IF4
                     p_sd.student_consent                     := 'Y';
                     p_sd.benefactor1_consent          := NULL;
                     p_sd.benefactor2_consent    := NULL;
                     p_sd.repeat_year                        := p_r1.repeat_year;
                     p_sd.number_of_benefactors  := 0;
                     p_sd.non_means_tested               := p_r1.award;
                     p_sd.number_of_dependants   := p_sd.number_of_dependants;
                     p_sd.household_resid_income := 0;
                     p_sd.ben1_total_income               := NULL;
                     p_sd.ben2_total_income        := NULL;
          p_sd.total_fee_loan_available := p_r1.stud_loan_amount;
          p_sd.total_sosb_entitlement := p_r1.sosb_amount;
     ELSE    --STUDENT HAS NO BENEFACTORS  IF3
           p_sd.student_consent                     := 'Y';
                 p_sd.benefactor1_consent          := NULL;
                 p_sd.benefactor2_consent     := NULL;
                 p_sd.repeat_year                         := p_r1.repeat_year;
                 p_sd.number_of_benefactors  := 0;
                 p_sd.non_means_tested                := p_r1.award;
                 p_sd.number_of_dependants   := p_sd.number_of_dependants;
                 p_sd.household_resid_income := NULL;
                 p_sd.ben1_total_income             := NULL;
                 p_sd.ben2_total_income      := NULL;
             p_sd.total_fee_loan_available := p_r1.stud_loan_amount;
             p_sd.total_sosb_entitlement := p_r1.sosb_amount;
     END IF;
           ELSIF p_r1.no_ben = 1 THEN--STUDENT HAS 1 BENEFACTORS    IF3
           --CHECK IF BENEFACTOR HAS CONSENTED TO SHARE INFO WITH THE SLC
                if not cur_get_ben_con%isopen then
                    OPEN cur_get_ben_con(p_r1.ben1_id, p_r1.session_code);
                end if;
--
                FETCH cur_get_ben_con INTO  p_sd.benefactor1_consent;
--
                if cur_get_ben_con%isopen then
                     CLOSE cur_get_ben_con;
                end if;
--
            IF p_sd.benefactor1_consent = 'Y' THEN  --IF5
                p_sd.student_consent                     := 'Y';
                   p_sd.benefactor1_consent            := 'Y';
                   p_sd.benefactor2_consent          := NULL;
                   p_sd.repeat_year                          := p_r1.repeat_year;
                   p_sd.number_of_benefactors  := 1;
                   p_sd.non_means_tested             := p_r1.award;
                   p_sd.number_of_dependants   := p_sd.number_of_dependants;
                p_sd.household_resid_income := p_r1.household_resid_income;
                p_sd.ben1_total_income           := p_r1.ben1_total_income;
                   p_sd.ben2_total_income          := NULL;
      p_sd.total_fee_loan_available := p_r1.stud_loan_amount;
      p_sd.total_sosb_entitlement := p_r1.sosb_amount;
            ELSE  --IF 5
                  p_sd.student_consent                     := 'Y';
                   p_sd.benefactor1_consent            := 'N';
                   p_sd.benefactor2_consent          := NULL;
                   p_sd.repeat_year                          := p_r1.repeat_year;
                   p_sd.number_of_benefactors  := 1;
                   p_sd.non_means_tested             := p_r1.award;
                   p_sd.number_of_dependants   := p_sd.number_of_dependants;
                   p_sd.household_resid_income := NULL;
                p_sd.ben1_total_income           := NULL;
                   p_sd.ben2_total_income          := NULL;
      p_sd.total_fee_loan_available := p_r1.stud_loan_amount;
      p_sd.total_sosb_entitlement := p_r1.sosb_amount;
            END IF; --IF 5

           ELSE -- 2 benefactors IF3
            --check to see if the benefactors have consent to share information with the SLC
            if not cur_get_ben_con%isopen then
                OPEN cur_get_ben_con(p_r1.ben1_id,p_r1.session_code);
            end if;
--
             FETCH cur_get_ben_con INTO  p_sd.benefactor1_consent;
--
             if cur_get_ben_con%isopen then
                 CLOSE cur_get_ben_con;
             end if;
--
            if not cur_get_ben_con%isopen then
              OPEN cur_get_ben_con(p_r1.ben2_id,p_r1.session_code);
            end if;
--
             FETCH cur_get_ben_con INTO  p_sd.benefactor2_consent;
--
             if cur_get_ben_con%isopen then
                 CLOSE cur_get_ben_con;
             end if;
--
                   IF p_sd.benefactor1_consent = 'Y' THEN --IF 6
              IF p_sd.benefactor2_consent = 'Y' THEN --IF 7
                   p_sd.student_consent                     := 'Y';
                        p_sd.benefactor1_consent          := 'Y';
                        p_sd.benefactor2_consent     := 'Y';
                        p_sd.repeat_year                        := p_r1.repeat_year;
                        p_sd.number_of_benefactors  := 2;
                        p_sd.non_means_tested              := p_r1.award;
                        p_sd.number_of_dependants   := p_sd.number_of_dependants;
                     p_sd.household_resid_income := p_r1.household_resid_income;
                     p_sd.ben1_total_income              := p_r1.ben1_total_income;
                        p_sd.ben2_total_income           := p_r1.ben2_total_income;
         p_sd.total_fee_loan_available := p_r1.stud_loan_amount;
         p_sd.total_sosb_entitlement := p_r1.sosb_amount;
                 ELSE --BENEFACTOR 1 CONSENTED BENEFACTOR 2 HAS NOT IF7
                       p_sd.student_consent                     := 'Y';
                        p_sd.benefactor1_consent          := 'Y';
                        p_sd.benefactor2_consent     := 'N';
                        p_sd.repeat_year                        := p_r1.repeat_year;
                        p_sd.number_of_benefactors  := 2;
                        p_sd.non_means_tested              := p_r1.award;
                        p_sd.number_of_dependants   := p_sd.number_of_dependants;
                     p_sd.household_resid_income := NULL;
                     p_sd.ben1_total_income              := p_r1.ben1_total_income;
                        p_sd.ben2_total_income           := NULL;
         p_sd.total_fee_loan_available := p_r1.stud_loan_amount;
         p_sd.total_sosb_entitlement := p_r1.sosb_amount;
                 END IF; -- IF 7
                ELSE -- IF6
                 IF p_sd.benefactor2_consent = 'Y' THEN -- IF 8
                   p_sd.student_consent                     := 'Y';
                        p_sd.benefactor1_consent          := 'N';
                        p_sd.benefactor2_consent     := 'Y';
                        p_sd.repeat_year                        := p_r1.repeat_year;
                        p_sd.number_of_benefactors  := 2;
                        p_sd.non_means_tested              := p_r1.award;
                        p_sd.number_of_dependants   := p_sd.number_of_dependants;
                     p_sd.household_resid_income := NULL;
                     p_sd.ben1_total_income              := NULL;
                        p_sd.ben2_total_income           := p_r1.ben2_total_income;
         p_sd.total_fee_loan_available := p_r1.stud_loan_amount;
         p_sd.total_sosb_entitlement := p_r1.sosb_amount;
                 ELSE --BENEFACTOR 1 CONSENTED BENEFACTOR 2 HAS NOT  IF 8
                       p_sd.student_consent                     := 'Y';
                        p_sd.benefactor1_consent          := 'N';
                        p_sd.benefactor2_consent     := 'N';
                        p_sd.repeat_year                        := p_r1.repeat_year;
                        p_sd.number_of_benefactors  := 2;
                        p_sd.non_means_tested              := p_r1.award;
                        p_sd.number_of_dependants   := p_sd.number_of_dependants;
                     p_sd.household_resid_income := NULL;
                     p_sd.ben1_total_income              := NULL;
                        p_sd.ben2_total_income           := NULL;
         p_sd.total_fee_loan_available := p_r1.stud_loan_amount;
         p_sd.total_sosb_entitlement := p_r1.sosb_amount;
                 END IF;  -- IF 8
                END IF; -- IF 6

           END IF; -- IF3

         ELSE --STUDENT HAS NOT CONSENTED FOR INFO TO BE SHARED IF2
              p_sd.student_consent                     := 'N';
             p_sd.benefactor1_consent          := NULL;
             p_sd.benefactor2_consent     := NULL;
             p_sd.repeat_year                        := NULL;
             p_sd.number_of_benefactors  := NULL;
             p_sd.non_means_tested              := NULL;
             p_sd.number_of_dependants   := NULL;
             p_sd.household_resid_income := NULL;
             p_sd.ben1_total_income              := NULL;
             p_sd.ben2_total_income           := NULL;
       p_sd.total_fee_loan_available := NULL;
       p_sd.total_sosb_entitlement := NULL;
       END IF; --IF2
      ELSE --IF1
          p_sd.student_consent                     := NULL;
          p_sd.benefactor1_consent          := NULL;
          p_sd.benefactor2_consent    := NULL;
          p_sd.repeat_year                        := NULL;
          p_sd.number_of_benefactors  := NULL;
            p_sd.non_means_tested              := NULL;
            p_sd.number_of_dependants   := NULL;
            p_sd.household_resid_income := NULL;
            p_sd.ben1_total_income              := NULL;
            p_sd.ben2_total_income           := NULL;
      p_sd.total_fee_loan_available := NULL;
      p_sd.total_sosb_entitlement := NULL;
      END IF; --IF1
--
    if c_f1_sha%isopen then
        CLOSE c_f1_sha;
    end if;
--
    if c_f1_country%isopen then
        CLOSE c_f1_country;
    end if;
--
    if cur_get_ben_con%isopen then
        CLOSE cur_get_ben_con;
    end if;
--
    return ret_val;
--
exception
--
    WHEN OTHERS THEN -- fatal error, stop processing.
        ret_val := false;
        n_sqlcode := SQLCODE;
        v_sqlerrm := SQLERRM;
        p_error_message := 'The following fatal error occured in POP_M263.CreateFile1 '||n_sqlcode||' '||SQLERRM;
--
    if c_f1_sha%isopen then
        CLOSE c_f1_sha;
    end if;
--
    if c_f1_country%isopen then
        CLOSE c_f1_country;
    end if;
--
    if cur_get_ben_con%isopen then
        CLOSE cur_get_ben_con;
    end if;
--
    RETURN ret_val;
--
end;
--
--
  FUNCTION pop_m263a (p_filename       IN VARCHAR2,
              p_filedate       IN DATE,
              p_repeat          OUT BOOLEAN,
              p_error_message OUT VARCHAR2) RETURN NUMBER IS
  -- produce loan file 1
  -- altered to union SIp_r1399 KL
--
   sd      slc_data%rowtype;
   r1    c_f1_stud_loans%ROWTYPE;
   r2    c_f1_sha%ROWTYPE;
   r5    c_f1_country%ROWTYPE;
   b_record_valid        BOOLEAN;
   v_error_description    VARCHAR2(2000);
--
   n_number_of_records    slc_batches.record_count%type;
   num_in_err number;
   num_filtered number;
   tot_rec_ctr number;
   num_flt slc_batches.fee_loan_record_count%type;
   num_stud slc_batches.student_loan_record_count%type;
   num_fl_only slc_batches.fee_loan_record_count%type;
--
   sum_dr slc_batches.total_fee_loan_dr%type;
   sum_cr slc_batches.total_fee_loan_cr%type;
--
   n_return_no        NUMBER;
   n_maxrows            NUMBER;
   e_max_filesize_not_found        EXCEPTION;
   e_maxrows_reached        EXCEPTION;
   fatal_error exception;
   n_sqlcode            NUMBER;
   v_sqlerrm            VARCHAR2(2000);
--
   exit_loop boolean;
--
   flt_for_slc_rec flt_for_slc_struct;
   latest_loan_elig_scy_id stud_crse_year.stud_crse_year_id%type;
   fl_only_rec flt_for_slc_struct;
--
   stud_scy_rec stud_scy_struct;
--
   fee_loan_only boolean;
--
   s_debug_filename VARCHAR2 (64) := 'pop_m263a.debug';
   tmp_num number;
   proc_stud_loan boolean;
   sd_recs_exist boolean;
   debug_on config_data.cval%type;
   s_debug_path varchar2 (128);
--
   BEGIN
---
   debug_on := DEFAULT_M263_DEBUG;
   if not ChkDebugOn (s_debug_filename, gs_debug_dirname, debug_on, p_error_message) then
      raise fatal_error;
   elsIF (debug_on = 'Y') THEN --- open debug file.
      s_debug_path := gs_debug_dirname || '/' || s_debug_filename;
      pop_m263a_debug_file_handle := utl_file.fopen(gs_debug_dirname, s_debug_filename, 'a');
   END IF;
---
--
   WriteToLog (pop_m263a_debug_file_handle, '' );
   writetolog (pop_m263a_debug_file_handle, 'Calling pop_263a for file: ' ||  p_filename || ' ' ||
                           'file date: ' || to_char(p_filedate, 'dd/mm/yyyy'));
   WriteToLog (pop_m263a_debug_file_handle, '*********************************************************************' );
--
   p_error_message := NULL;
   n_number_of_records := 0;
   num_flt := 0;
   num_stud := 0;
   num_fl_only := 0;
   num_filtered := 0;
   num_in_err := 0;
   tot_rec_ctr := 0;
--
   sum_cr := null;
   sum_dr := null;
-- --------------------------------------------------------
-- find max number of records allowed in the batch file 1.
--------------------------------------------------------
   if not c_f1_2_max_size%isopen then
      OPEN  c_f1_2_max_size;
   end if;
--
   FETCH c_f1_2_max_size INTO n_maxrows;
--
   IF c_f1_2_max_size%NOTFOUND THEN
      if c_f1_2_max_size%isopen then
     CLOSE c_f1_2_max_size;
      end if;
      p_error_message := 'The following error occured in POP_M263.POP_M263_ERROR : No row found in CONFIG_DATA for ITEM_NAME = ''SLC_MAX_FILESIZE''';
      RAISE e_max_filesize_not_found;
   END IF;
--
   if c_f1_2_max_size%isopen then
      CLOSE c_f1_2_max_size;
   end if;
--
   writetolog (pop_m263a_debug_file_handle, 'max number of records allowed in file 1 is: ' || n_maxrows);
--
   -- Create slc_batches record which is the parent of all slc_data records created here.
   -- Note that this record is updated at the end of the procedure with the number of
   -- records created.
   --------------------------------------------------------------------------------------
--
   INSERT INTO SLC_BATCHES
             (slc_filename, slc_file_date, slc_file_type, last_reprint_date, record_count, fee_loan_record_count,
                student_loan_record_count, total_fee_loan_cr, total_fee_loan_dr)
   VALUES (p_filename, p_filedate, '1', null, 0, 0, 0, sum_cr, sum_dr);
--
   WriteToLog (pop_m263a_debug_file_handle, '' );
   writetolog (pop_m263a_debug_file_handle, 'Inserted new SLC_BATCHES record for: ' ||
                 ' ' || p_filename || ' ' ||  to_char(p_filedate, 'dd/mm/yyyy') || ' ' ||  '1');
--
   WriteToLog (pop_m263a_debug_file_handle, '' );
   writetolog (pop_m263a_debug_file_handle, 'Processing File 1 Student loans....');
   writetolog (pop_m263a_debug_file_handle, '-----------------------------------');
    r1 := null; -- student loan details.
--
   proc_stud_loan := true;
   if not ChkProcStudLoans (p_filename, p_filedate, SLC_FILE_1_FORM_TYPE, proc_stud_loan, pop_m263a_debug_file_handle, p_error_message) then
      raise fatal_error;
   end if;
--
   if proc_stud_loan then
      --*****************
       --*****************
       -- STUDENT LOANS --
       --*****************
      --*****************
      FOR r1 IN c_f1_stud_loans LOOP
     tot_rec_ctr := (tot_rec_ctr + 1);
     WriteToLog (pop_m263a_debug_file_handle, '' );
     writetolog (pop_m263a_debug_file_handle, 'Record -> ' || tot_rec_ctr || ' ' || r1.stud_ref_no || ' ' || r1.session_code || ' ' || r1.stud_crse_year_id);
           r2 := null; -- stud home address.
           r5 := null; -- country.
           sd := null; -- slc_data.
           b_record_valid := TRUE;
           p_error_message := null;
--
---     Build slc_data structure....
           if not CreateFile1 (r1, r2, r5, sd, p_filename, p_filedate, b_record_valid, STUD_LOAN, p_error_message) then
---        Fatal error ocurred, stop processing all records.
               raise fatal_error;
           end if;
---
---     Only insert the record if all the validation checks are passed
           IF b_record_valid THEN
        WriteToLog (pop_m263a_debug_file_handle, 'Built file 1 student loan data for ' || r1.stud_ref_no);
             IF (n_number_of_records = n_maxrows) THEN
---           WriteToLog (pop_m263a_debug_file_handle, 'Max records written to slc_data. Closing batch for ' || p_filename);
---           The maximum number of rows to be processed has been reached for this file.
                   if not UpdSlcBatches (p_filename, trunc(p_filedate), n_number_of_records, num_stud,
                    (num_flt + num_fl_only), sum_cr, sum_dr,
                    p_error_message, pop_m263a_debug_file_handle) then
                       raise fatal_error;
                   else -- exit the loop, do not insert this record into slc_data, start new file.
---          the current record will be picked up next time this cursor is opened.
                       RAISE e_maxrows_reached; -- repeat this cursor as not complete.
                   end if;
               END IF;
---
---        Create new slc_data record and increment the n_number_of_records counter.
               -------------------------------------------------------------------------
        sd.slc_filename := p_filename;
        sd.slc_file_date := p_filedate;
               if not InsFile1SlcData (r1, r2, r5, sd, SLC_FILE_1_FORM_TYPE, p_error_message, pop_m263a_debug_file_handle) then
---           Fatal error ocurred, stop processing all records.
                   raise fatal_error;
        ---elsif not UpdScyFlags (r1.stud_crse_year_id, SLC_FILE_1_ID, p_error_message,
           ---pop_m263a_debug_file_handle) then
---           update scy flags to say file 1 sent.
           ---raise fatal_error;
        else
           n_number_of_records := (n_number_of_records + 1);
           num_stud := (num_stud + 1);
        end if;
     else
        num_in_err := (num_in_err + 1);
        WriteToLog (pop_m263a_debug_file_handle, '--- Invalid file 1 student loan data. num_in_err ' || num_in_err);
--
        if not UpdLoanFlags (r1.stud_ref_no,
                 r1.session_code,
                 r1.stud_crse_year_id,
                 null,
                 p_filename,
                 p_filedate,
                 STUD_LOAN,
                 SLC_FILE_1_ID,
                 pop_m263a_debug_file_handle,
                 p_error_message) then
           raise fatal_error;
        end if;
           END IF; -- record valid.
--
           r1 := null; -- finished with this student, init student loan details.
--
     WriteToLog (pop_m263a_debug_file_handle, '' );
        END LOOP;
--
       if c_f1_stud_loans%isopen then
           close c_f1_stud_loans;
       end if;
--
      if not WriteSummaryData (pop_m263a_debug_file_handle, SLC_FILE_1_ID, p_filename, tot_rec_ctr, num_filtered,
                    num_in_err, num_stud, num_flt, num_fl_only, n_number_of_records,
                    sum_dr, sum_cr, p_error_message)  then
     raise fatal_error;
      end if;
--
   end if;
--
 --************************************************
    --************************************************
    -- FEE_LOAN_TRANSACTIONS REQUIRING FILE1 RECORD --
    --************************************************
   --************************************************
   WriteToLog (pop_m263a_debug_file_handle, '' );
   WriteToLog (pop_m263a_debug_file_handle, 'Processing File 1 Students with Fee Loan Transactions...');
   writetolog (pop_m263a_debug_file_handle, '--------------------------------------------------------');
     if not c_flt_for_slc%isopen then
        OPEN c_flt_for_slc;
    end if;
--
    exit_loop := false;
   num_filtered := 0;
   num_in_err := 0;
   tot_rec_ctr := 0;
--
--    For each student having flt to go to slc (per session), find latest loan eligible scy.
--    --------------------------------------------------------------------------------------
    while not exit_loop loop
        flt_for_slc_rec := null;
        p_error_message := null;
--
--        Check all flt records not in error and not rejected waiting to go to slc.
        FETCH c_flt_for_slc INTO flt_for_slc_rec.stud_ref_no, flt_for_slc_rec.session_code;
--
        if c_flt_for_slc%notfound then -- all records processed.
            exit_loop := true;
        else
     tot_rec_ctr := (tot_rec_ctr + 1);
     WriteToLog (pop_m263a_debug_file_handle, '' );
     WriteToLog (pop_m263a_debug_file_handle, 'Record -> ' || tot_rec_ctr ||
                 ' flt.stud_ref_no: ' || flt_for_slc_rec.stud_ref_no ||
                 ' flt.status: ' || flt_for_slc_rec.session_code);
            latest_loan_elig_scy_id := null;
--
---     Check student meets loan eligibility criteria and find latest loan
---     eligible scy details to send in file 1.
---     ------------------------------------------------------------------
     if not ChkOkToSendFlt (flt_for_slc_rec, latest_loan_elig_scy_id, p_error_message) then
---        Fatal error ocurred, stop processing all records.
        raise fatal_error;
     elsif latest_loan_elig_scy_id is null then
---        ************************************************************
---        FAULT, no valid loan eligible scy record found, flag error.
---        ************************************************************
---        Find the latest fee loan transaction to include in the slc_errors.
---        ------------------------------------------------------------------
        stud_scy_rec := null;
        if not ReadStudScyRec (flt_for_slc_rec, stud_scy_rec, p_error_message) then
                 -- Fatal error ocurred, stop processing all records.
                 raise fatal_error;
              else
           num_in_err := (num_in_err + 1);
           WriteToLog (pop_m263a_debug_file_handle, '--- student has no fee loan and is not loan elig. num_in_err ' || num_in_err);
---
           if not UpdLoanFlags (stud_scy_rec.stud_ref_no, stud_scy_rec.session_code,
                    stud_scy_rec.stud_crse_year_id, null, p_filename,
                    p_filedate, FEE_LOAN, SLC_FILE_1_ID,
                    pop_m263a_debug_file_handle, p_error_message) then
         raise fatal_error;
           end if;
---
                 WriteToLog(pop_m263a_debug_file_handle, p_error_message);
                 pop_m263_error(p_filename, trunc(p_filedate), 1,
                 stud_scy_rec.stud_crse_year_id, stud_scy_rec.stud_ref_no, stud_scy_rec.inst_code,
                 stud_scy_rec.crse_code, stud_scy_rec.crse_id, stud_scy_rec.session_code, stud_scy_rec.scottish_cand,
                 SUBSTR(p_error_message,1,255), stud_scy_rec.scheme_type, stud_scy_rec.dearing, FEE_LOAN);
              end if;
     else -- stud meets loan eligibility criteria and latest scy_id found.
---        **************************************************************************************
---        OK, latest loan elig scy details found, use to select student details to build file 1.
---        **************************************************************************************
        r1 := null;
        if not FindFile1StudSessScyDetails (latest_loan_elig_scy_id, r1,
           p_error_message, pop_m263a_debug_file_handle) then
           --- Fatal error ocurred, stop processing all records.
           raise fatal_error;
        else
---           create slc_data record.
---           -----------------------
                   r2 := null; -- stud home address.
                   r5 := null; -- conntry.
                   sd := null; -- slc_data.
                   b_record_valid := TRUE;
                   p_error_message := null;
---           Build slc_data structure.
---           -------------------------
---           Use latest loan eligible scy_id when selecting data for file 1. do this by
---           replacing the original scy_id in the fee_loan_transaction record.
           r1.stud_crse_year_id := latest_loan_elig_scy_id;
           if not CreateFile1 (r1, r2, r5, sd, p_filename, p_filedate, b_record_valid, FEE_LOAN, p_error_message) then
---          Fatal error ocurred, stop processing all records.
          raise fatal_error;
                    end if;
---
---           Only insert the record if all the validation checks are passed
---           and we have reached the max file size.
---           ---------------------------------------------------------------
           IF b_record_valid THEN
          WriteToLog (pop_m263a_debug_file_handle, 'Built file 1 FLT data.');
          IF n_number_of_records = n_maxrows THEN
             -- The maximum number of rows to be processed has been reached for this file.
             if not UpdSlcBatches (p_filename, p_filedate, n_number_of_records, num_stud,
                    (num_flt + num_fl_only), sum_cr, sum_dr,
                    p_error_message, pop_m263a_debug_file_handle) then
            raise fatal_error;
             else -- exit the loop, do not insert this record into slc_data, start new file.
            -- the current record will be picked up next time th sursor is opened.
            RAISE e_maxrows_reached; -- repeat this cursor as not complete.
             end if;
          END IF;
          --- Create new slc_data record and increment the n_number_of_records counter.
          ---------------------------------------------------------------------------
          sd.slc_filename := p_filename;
          sd.slc_file_date := p_filedate;
          if not InsFile1SlcData (r1, r2, r5, sd, SLC_FILE_1_FORM_TYPE, p_error_message, pop_m263a_debug_file_handle) then
             ---             Fatal error ocurred, stop processing all records.
             raise fatal_error;
          else
             ---             Update stud_session.slc1_fl_sent flag and slc1_fl_sent_date.
             ---if not UpdSSFlSentFlag (flt_for_slc_rec.stud_ref_no, flt_for_slc_rec.session_code,
             ---p_error_message) then
             --                               Fatal error ocurred, stop processing all records.
             ---raise fatal_error;
             ---else -- flt records processed ok, inc counter and read next record.
             n_number_of_records := (n_number_of_records + 1);
             num_flt := (num_flt + 1);
             WriteToLog (pop_m263a_debug_file_handle, 'Inserted slc_data and updated flt records.');
          end if;
           --end if;
           else
          num_in_err := (num_in_err + 1);
          WriteToLog (pop_m263a_debug_file_handle, '--- Invalid file 1 fee loan data. num_in_err ' || num_in_err);
--
          if not UpdLoanFlags (r1.stud_ref_no, r1.session_code, r1.stud_crse_year_id,
                 null, p_filename, p_filedate, FEE_LOAN, SLC_FILE_1_ID,
                 pop_m263a_debug_file_handle, p_error_message) then
            raise fatal_error;
          end if;
           END IF; -- b_record_valid.
        end if; -- FindFile1StudSessScyDetails
     end if; -- ChkOkToSendFlt
      end if; -- c_flt_for_slc%notfound
--
   WriteToLog (pop_m263a_debug_file_handle, '' );
    end loop; -- c_flt_for_slc
--
    if c_flt_for_slc%isopen then
        CLOSE c_flt_for_slc;
    end if;
--
   if not WriteSummaryData (pop_m263a_debug_file_handle, SLC_FILE_1_ID, p_filename, tot_rec_ctr, num_filtered,
                 num_in_err, num_stud, num_flt, num_fl_only, n_number_of_records,
                 sum_dr, sum_cr, p_error_message) then
      raise fatal_error;
   end if;
--
--***************************
-- **************************
-- FEE LOAN ASSESSED ONLY --
-- **************************
-- **************************
   WriteToLog (pop_m263a_debug_file_handle, '' );
   WriteToLog (pop_m263a_debug_file_handle, 'Processing File 1 Fee Loan Only Students...');
   writetolog (pop_m263a_debug_file_handle, '-------------------------------------------');
--
    if not c_fee_loan_only%isopen then
        OPEN c_fee_loan_only;
    end if;
--
    exit_loop := false;
   num_filtered := 0;
   num_in_err := 0;
   tot_rec_ctr := 0;
--
--    For each fee loan only student.
--    -------------------------------
    while not exit_loop loop
        fl_only_rec := null; -- use same structure as for flt cursor.
        p_error_message := null;
--
--        Check all flt records not in error and not rejected waiting to go to slc.
        FETCH c_fee_loan_only INTO fl_only_rec.stud_ref_no, fl_only_rec.session_code,
                 fl_only_rec.stud_crse_year_id;
--
      if c_fee_loan_only%notfound then -- all records processed.
            exit_loop := true;
        else
     tot_rec_ctr := (tot_rec_ctr + 1);
     WriteToLog (pop_m263a_debug_file_handle, '' );
     writetolog (pop_m263a_debug_file_handle, ' record -> ' || tot_rec_ctr || ' ' || fl_only_rec.stud_ref_no || ' ' || fl_only_rec.session_code ||
         ' ' || fl_only_rec.stud_crse_year_id);
     latest_loan_elig_scy_id := null;
---
---     Check student meets loan eligibility criteria and find latest loan
---     eligible scy details to send in file 1.
---     ------------------------------------------------------------------
     if not ChkFlOnly (fl_only_rec, fee_loan_only, p_error_message, pop_m263a_debug_file_handle) then
---        Fatal error ocurred, stop processing all records.
        raise fatal_error;
     elsif fee_loan_only then -- student is fee loan only.
---        scy_id is for latest scy record.
        latest_loan_elig_scy_id := fl_only_rec.stud_crse_year_id;
        r1 := null;
        if not FindFile1StudSessScyDetails (latest_loan_elig_scy_id, r1, p_error_message,
                       pop_m263a_debug_file_handle) then
---           Fatal error ocurred, stop processing all records.
           raise fatal_error;
        else
---           Check student / crse year has not already been written to this batch file
---           in the fee loan txn loop above. If it has filter it out here.
---           It will not get picked up on the next run as the flt flags will have
---           been updated at the end of this run.
           sd_recs_exist := false;
           if not ChkStudNotInBatch (fl_only_rec, p_filename, p_filedate, latest_loan_elig_scy_id,
                      FEE_LOAN, sd_recs_exist, pop_m263a_debug_file_handle,
                      p_error_message) then
---          Fatal error ocurred, stop processing all records.
          raise fatal_error;
           elsif (not sd_recs_exist) then
          --- create slc_data record.
          --------------------------
          r2 := null; -- stud home address.
          r5 := null; -- conntry.
          sd := null; -- slc_data.
          b_record_valid := TRUE;
          p_error_message := null;
          ---
          --- Build slc_data structure.
          -----------------------------
          --- Use latest loan eligible scy_id when selecting data for file 1. do this by
          --- replacing the original scy_id.
          r1.stud_crse_year_id := latest_loan_elig_scy_id;
          if not CreateFile1 (r1, r2, r5, sd, p_filename, p_filedate, b_record_valid, FEE_LOAN, p_error_message) then
             --- Fatal error ocurred, stop processing all records.
             raise fatal_error;
          end if;
           else
          --- slc_data rec exists, ignore this student.
          num_filtered := (num_filtered + 1);
          WriteToLog (pop_m263a_debug_file_handle, '... Filtered student. slc_data rec exists for file ' ||
            p_filename || ' date ' || p_filedate || ' scy_id '  || latest_loan_elig_scy_id ||
            ' and record type ' || FEE_LOAN || ' num_filtered ' || num_filtered);
           end if;
---
           if (not sd_recs_exist) then -- create file 1 record.
                       IF b_record_valid THEN
             WriteToLog (pop_m263a_debug_file_handle, 'Built file 1 FLAO data.');
                         IF n_number_of_records = n_maxrows THEN
                                -- The maximum number of rows to be processed has been reached for this file.
                               if not UpdSlcBatches (p_filename, p_filedate, n_number_of_records, num_stud,
                                  (num_flt + num_fl_only), sum_cr, sum_dr, p_error_message,
               pop_m263a_debug_file_handle) then
                                   raise fatal_error;
                               else -- exit the loop, do not insert this record into slc_data, start new file.
                                   -- the current record will be picked up next time th sursor is opened.
                                   RAISE e_maxrows_reached; -- repeat this cursor as not complete.
                               end if;
                           END IF;
             ---
             --- Create new slc_data record and increment the n_number_of_records counter.
             --- ------------------------------------------------------------------------
             sd.slc_filename := p_filename;
             sd.slc_file_date := p_filedate;
             if not InsFile1SlcData (r1, r2, r5, sd, SLC_FILE_1_FORM_TYPE, p_error_message, pop_m263a_debug_file_handle) then
            --- Fatal error ocurred, stop processing all records.
            raise fatal_error;
             else
            -- Update stud_session.slc1_fl_sent flag and slc1_fl_sent_date.
            ---if not UpdSSFlSentFlag (fl_only_rec.stud_ref_no, fl_only_rec.session_code,
                    ---p_error_message) then
            -- Fatal error ocurred, stop processing all records.
            ---raise fatal_error;
            ---else -- flt records processed ok, inc counter and read next record.
            n_number_of_records := (n_number_of_records + 1);
            num_fl_only := (num_fl_only + 1);
            WriteToLog (pop_m263a_debug_file_handle, 'Inserted slc_data.');
             end if;
          else
             num_in_err := (num_in_err + 1);
             WriteToLog (pop_m263a_debug_file_handle, '--- Invalid file 1 fee loan only data. num_in_err ' || num_in_err);
--
             if not UpdLoanFlags (r1.stud_ref_no,
                      r1.session_code,
                      r1.stud_crse_year_id,
                      null,
                      p_filename,
                      p_filedate,
                      FEE_LOAN,
                      SLC_FILE_1_ID,
                      pop_m263a_debug_file_handle,
                      p_error_message) then
            raise fatal_error;
             end if;
          END IF; -- record valid.
           end if;
        end if;
     else -- filtered out.
        num_filtered := (num_filtered + 1);
        WriteToLog (pop_m263a_debug_file_handle, '... Filtered student. num_filtered ' || num_filtered);
     end if;
      end if;
--
   WriteToLog (pop_m263a_debug_file_handle, '' );
    end loop; -- c_flt_for_slc
--
    if c_flt_for_slc%isopen then
        CLOSE c_flt_for_slc;
    end if;
---
   if not WriteSummaryData (pop_m263a_debug_file_handle, SLC_FILE_1_ID, p_filename, tot_rec_ctr, num_filtered,
                 num_in_err, num_stud, num_flt, num_fl_only, n_number_of_records,
                 sum_dr, sum_cr, p_error_message) then
      raise fatal_error;
   end if;
   writetolog (pop_m263a_debug_file_handle, '--------------------------------------------------------------------');
--
-- All records have been processed before the end (max number of recs reached)
--    of the current file.
-- ***************************************************************************
   if (n_number_of_records = 0) then
      -- nothing inserted into slc_data, delete the slc_batches record.
      if not DelSlcBatch (p_filename, p_filedate, pop_m263a_debug_file_handle, p_error_message) then
     raise fatal_error;
      end if;
   else
       if not UpdSlcBatches (p_filename, p_filedate, n_number_of_records, num_stud,
               (num_flt + num_fl_only), sum_cr, sum_dr, p_error_message,
               pop_m263a_debug_file_handle) then
           raise fatal_error;
       else -- all students processed, stop processing.
           p_repeat := FALSE;
      end if;
   end if;
--
   CloseLogFile(pop_m263a_debug_file_handle);
--
    RETURN (n_number_of_records);
--
    EXCEPTION
        WHEN e_max_filesize_not_found THEN
            ROLLBACK;
            p_repeat := FALSE; -- stop procesing.
--
            RETURN -1; -- return failure.
--
        WHEN e_maxrows_reached THEN -- current file is full.
     p_repeat := TRUE; -- continue processsing.
     WriteToLog (pop_m263a_debug_file_handle, 'max records reached for file: ' || p_filename);
     if not WriteSummaryData (pop_m263a_debug_file_handle, SLC_FILE_1_ID, p_filename, tot_rec_ctr, num_filtered,
                       num_in_err, num_stud, num_flt, num_fl_only, n_number_of_records,
                       sum_dr, sum_cr, p_error_message) then
        raise fatal_error;
     end if;
     writetolog (pop_m263a_debug_file_handle, '--------------------------------------------------------------------');
---
     if c_f1_stud_loans%isopen then
              close c_f1_stud_loans;
          end if;
---
          if not c_fee_loan_only%isopen then
              OPEN c_fee_loan_only;
          end if;
       RETURN (n_number_of_records); -- return number of records processed.
--
        WHEN fatal_error THEN -- fatal error in called function, stop processing.
            ROLLBACK;
            p_repeat := FALSE;
--
            if c_f1_stud_loans%isopen then
                close c_f1_stud_loans;
            end if;
--
     WriteToLog(pop_m263a_debug_file_handle, 'fatal error in pop_m263a' ||n_sqlcode || ' ' || v_sqlerrm);
            RETURN -1; -- return failure.
--
  --  Write file management errors to DBMS output.
    WHEN utl_file.invalid_operation THEN
        CloseLogFile(pop_m263a_debug_file_handle);
        p_error_message := (' Debug file - File could not be opened ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
    WHEN utl_file.invalid_path THEN
        CloseLogFile(pop_m263a_debug_file_handle);
        p_error_message := (' Debug file - Invalid file path ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
    WHEN utl_file.invalid_mode THEN
        CloseLogFile(pop_m263a_debug_file_handle);
        p_error_message := (' Debug file - Invalid file mode specified ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
    WHEN utl_file.invalid_filehandle THEN
        CloseLogFile(pop_m263a_debug_file_handle);
        p_error_message := (' Debug file - file specified is not open ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
    WHEN utl_file.write_error THEN
        CloseLogFile(pop_m263a_debug_file_handle);
        p_error_message := (' Debug file - Error writing to debug file ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
        --
        WHEN OTHERS THEN -- fatal error in this function, stop processing.
            n_sqlcode := SQLCODE;
            v_sqlerrm := SQLERRM;
            p_error_message := p_error_message || ' The following others fatal error occured in POP_M263.POP_M263A '||n_sqlcode||' '||SQLERRM;
            ROLLBACK;
            p_repeat := FALSE;
--
            if c_f1_2_max_size%isopen then
                CLOSE c_f1_2_max_size;
            end if;
--
            if c_f1_stud_loans%isopen then
                close c_f1_stud_loans;
            end if;
--
            RETURN -1; -- return failure.
--
  END pop_m263a;
--
  FUNCTION pop_m263b (p_filename       IN VARCHAR2,
                   p_filedate       IN DATE,
                   p_repeat          OUT BOOLEAN,
                   p_error_message OUT VARCHAR2) RETURN NUMBER IS

--
   r1 c_f2_stud_loans%ROWTYPE;
   r2 c_f2_sha%ROWTYPE;
   r3 c_f2_sta%ROWTYPE;
   r4 c_f2_scd_1%ROWTYPE;
   r5 c_f2_scd_2%ROWTYPE;
   sd slc_data%rowtype;
--
   fatal_error exception;
--
   r4_temp            c_f2_scd_1%ROWTYPE;
   r5_temp            c_f2_scd_2%ROWTYPE;
   b_record_valid        BOOLEAN;
   --b_number            BOOLEAN;
   --v_home_post_code        VARCHAR(8);
   --v_term_post_code        VARCHAR(8);
   --v_cont1_post_code        VARCHAR(8);
   --v_cont2_post_code        VfARCHAR(8);
   v_error_description    VARCHAR2(2000);
   --v_addr_corr_flag        STUD.addr_corr_flag%TYPE;
   --v_award_type        VARCHAR2(2000);
   --n_dummy_number        NUMBER;
--
   n_number_of_records    slc_batches.record_count%type;
   num_in_err number;
   num_filtered number;
   tot_rec_ctr number;
   num_flt slc_batches.fee_loan_record_count%type;
   num_stud slc_batches.student_loan_record_count%type;
   num_fl_only slc_batches.fee_loan_record_count%type;
--
   sum_dr slc_batches.total_fee_loan_dr%type;
   sum_cr slc_batches.total_fee_loan_cr%type;
--
   f2_flt_rec flt_for_f2_slc_struct;
--
   --n_loan_amount        NUMBER;
   --n_loan_request        NUMBER;
   --n_return_no        NUMBER;
   n_maxrows            NUMBER;
   e_max_filesize_not_found    EXCEPTION;
   e_maxrows_reached        EXCEPTION;
   n_sqlcode            NUMBER;
   v_sqlerrm            VARCHAR2(2000);
   exit_loop boolean;
   ins_ok boolean;
--
   s_debug_filename VARCHAR2 (64) := 'pop_m263b.debug';
--
   proc_stud_loan boolean;
---
   debug_on config_data.cval%type;
   s_debug_path varchar2 (128);
--
   BEGIN
   p_error_message := NULL;
   n_number_of_records := 0;
   num_stud := 0;
   num_flt := 0;
   num_fl_only := 0;
   num_in_err := 0;
   num_filtered :=0;
   tot_rec_ctr := 0;
--
   sum_dr := 0;
   sum_cr := 0;
--
   debug_on := DEFAULT_M263_DEBUG;
   if not ChkDebugOn (s_debug_filename, gs_debug_dirname, debug_on, p_error_message) then
      raise fatal_error;
   elsIF (debug_on = 'Y') THEN --- open debug file.
      s_debug_path := gs_debug_dirname || '/' || s_debug_filename;
      pop_m263b_debug_file_handle := utl_file.fopen(gs_debug_dirname, s_debug_filename, 'a');
   END IF;
---
   WriteToLog (pop_m263b_debug_file_handle, '' );
   writetolog (pop_m263b_debug_file_handle, 'Calling pop_263b for file: ' ||  p_filename || ' ' || 'file date: ' ||
                    to_char(p_filedate, 'dd/mm/yyyy'));
   WriteToLog (pop_m263b_debug_file_handle, '*********************************************************************' );
--
   if not c_f1_2_max_size%isopen then
      OPEN c_f1_2_max_size;
   end if;
--
-- Find max size of file 2.
-- ------------------------
   FETCH c_f1_2_max_size INTO n_maxrows;
   IF c_f1_2_max_size%NOTFOUND THEN
      if c_f1_2_max_size%isopen then
     CLOSE c_f1_2_max_size;
      end if;
      p_error_message := 'The following Error occured in pop_m263.pop_m263 : No ROW FOUND IN CONFIG_DATA FOR ITEM_NAME = ''SLC_MAX_FILESIZE''';
      RAISE e_max_filesize_not_found;
   END IF;
--
   if c_f1_2_max_size%isopen then
      CLOSE c_f1_2_max_size;
   end if;
--
   writetolog (pop_m263b_debug_file_handle, 'max number of records allowed in file 2 is: ' || n_maxrows);

-- Create slc_batches record which is the parent of all slc_data records created here.
-- Note that this record is updated at the end of the procedure with the number of
-- reecords created.
   INSERT INTO SLC_BATCHES
             (slc_filename, slc_file_date, slc_file_type, last_reprint_date, record_count, fee_loan_record_count,
                student_loan_record_count, total_fee_loan_cr, total_fee_loan_dr)
   VALUES (p_filename, p_filedate, '2', null, 0, 0, 0, 0, 0);
--
   WriteToLog (pop_m263b_debug_file_handle, '' );
   writetolog (pop_m263b_debug_file_handle, 'Inserted new initialised SLC_BATCHES record with for: ' ||
                 ' ' || p_filename || ' ' ||  to_char(p_filedate, 'dd/mm/yyyy') || ' ' ||  '2');
--
   WriteToLog (pop_m263b_debug_file_handle, '' );
   writetolog (pop_m263b_debug_file_handle, 'Processing File 2 Student loans....');
   writetolog (pop_m263b_debug_file_handle, '-----------------------------------');
--
   proc_stud_loan := true;
   if not ChkProcStudLoans (p_filename, p_filedate, SLC_FILE_2_FORM_TYPE, proc_stud_loan, pop_m263b_debug_file_handle, p_error_message) then
      raise fatal_error;
   end if;
--
   if proc_stud_loan then
      --*****************
       --*****************
       -- STUDENT LOANS --
       --*****************
      --*****************
      r1:= null; -- student details.
      num_in_err := 0;
      num_filtered :=0;
      tot_rec_ctr := 0;
--
      FOR r1 IN c_f2_stud_loans LOOP
     tot_rec_ctr := (tot_rec_ctr + 1);
     writetolog (pop_m263b_debug_file_handle, '');
     writetolog (pop_m263b_debug_file_handle, ' record -> '|| ' ' || tot_rec_ctr || ' ' || r1.stud_ref_no || ' ' || r1.session_code || ' ' || r1.stud_crse_year_id);
     --
     b_record_valid := TRUE;
     --
     r2 := null; -- stud home address.
     r3 := null; -- stud term address.
     r4 := null; -- stud cont details 1
     r5 := null; -- stud cont details 2
     sd := null; -- slc_data.
--
           p_error_message := null;
--
     --    Build slc_data structure....
           if not CreateFile2 (f2_flt_rec, r1, r2, r3, r4, r5, sd, p_filename, p_filedate, b_record_valid, STUD_LOAN, p_error_message) then
        --    Fatal error ocurred, stop processing all records.
               raise fatal_error;
           end if;
--
     IF b_record_valid THEN
        WriteToLog (pop_m263b_debug_file_handle, 'Built file 2 student data.');
           IF n_number_of_records = n_maxrows THEN
          --- The maximum number of rows to be processed has been reached for this file.
          if not UpdSlcBatches (p_filename, p_filedate, n_number_of_records, num_stud,
                                  (num_flt + num_fl_only), sum_dr, sum_cr, p_error_message,
             pop_m263b_debug_file_handle) then
             raise fatal_error;
          else -- exit the loop, do not insert this record into slc_data, start new file.
             --- the current record will be picked up next time th sursor is opened.
             RAISE e_maxrows_reached; -- repeat this cursor as not complete.
          end if;
           end if;
---
           --- Create new slc_data record and increment the n_number_of_records counter.
           -------------------------------------------------------------------------
           sd.slc_filename := p_filename;
           sd.slc_file_date := p_filedate;
           ins_ok := true;
           if not InsFile2SlcData (r1, r2, r3, r4, r5, sd, SLC_FILE_2_FORM_TYPE, ins_ok, p_error_message, pop_m263b_debug_file_handle) then
        --- Fatal error ocurred, stop processing all records.
        raise fatal_error;
     elsif ins_ok then
        ---if not UpdScyFlags (r1.stud_crse_year_id, SLC_FILE_2_ID, p_error_message,
                     ---pop_m263b_debug_file_handle) then
        --- update scy flags to say file 1 sent.
        ---raise fatal_error;
        n_number_of_records := (n_number_of_records + 1);
        num_stud := (num_stud + 1);
           end if;
        else
           num_in_err := (num_in_err + 1);
           WriteToLog (pop_m263b_debug_file_handle, '--- Invalid file 2 student loan data. num_in_err ' || num_in_err);
--
           if not UpdLoanFlags (r1.stud_ref_no,
                    r1.session_code,
                    r1.stud_crse_year_id,
                    null,
                    p_filename,
                    p_filedate,
                    STUD_LOAN,
                    SLC_FILE_2_ID,
                    pop_m263b_debug_file_handle,
                    p_error_message) then
          raise fatal_error;
           end if;
        END IF; -- record valid.
---
        WriteToLog (pop_m263b_debug_file_handle, '' );
     END LOOP;
--
     if c_f2_stud_loans%isopen then
        CLOSE c_f2_stud_loans;
     end if;
--
     if not WriteSummaryData (pop_m263b_debug_file_handle, SLC_FILE_2_ID, p_filename, tot_rec_ctr, num_filtered,
                    num_in_err, num_stud, num_flt, num_fl_only, n_number_of_records,
                    sum_dr, sum_cr, p_error_message) then
        raise fatal_error;
     end if;
      end if;
--
   --**************************
    --**************************
    -- FEE LOAN TRANSACTIONS --
    --**************************
   --**************************
   WriteToLog (pop_m263b_debug_file_handle, '' );
   writetolog (pop_m263b_debug_file_handle, 'Processing File 2 Fee Loan Transactions....');
   writetolog (pop_m263b_debug_file_handle, '-------------------------------------------');
--
    if not c_f2_flt%isopen then
        OPEN c_f2_flt;
    end if;
--
    exit_loop := false;
   num_in_err := 0;
   num_filtered :=0;
   tot_rec_ctr := 0;
--
--    For each fee loan txn student.
--    -------------------------------
    while not exit_loop loop
        f2_flt_rec := null; -- use same structure as for flt cursor.
        p_error_message := null;
--
--        Check all flt records not in error and not rejected waiting to go to slc.
        FETCH c_f2_flt INTO f2_flt_rec.stud_ref_no,
               f2_flt_rec.session_code,
               f2_flt_rec.txn_interest_accrual_date,
               f2_flt_rec.sum_txns;
               --f2_flt_rec.total_fee_loan_dr,
               --f2_flt_rec.total_fee_loan_cr;

--
        if c_f2_flt%notfound then -- all records processed.
            exit_loop := true;
        else
     tot_rec_ctr := (tot_rec_ctr + 1);
     WriteToLog (pop_m263b_debug_file_handle, '' );
     writetolog (pop_m263b_debug_file_handle, ' record -> ' || ' ' || tot_rec_ctr ||
             ' ' || f2_flt_rec.stud_ref_no ||
                               ' ' || f2_flt_rec.session_code ||
                               ' ' || f2_flt_rec.txn_interest_accrual_date ||
                               ' ' || f2_flt_rec.sum_txns);
--
     b_record_valid := TRUE;
     r2 := null; -- stud home address.
     r3 := null; -- stud term address.
     r4 := null; -- stud cont details 1
     r5 := null; -- stud cont details 2
     sd := null; -- slc_data.
--
     p_error_message := null;
     r1 := null;
--
/*
     if (f2_flt_rec.sum_txns = 0) then -- sum of all flts = 0, flag problem.
        -- write to error table with flt scy details.
        -- find scy details for the flt record being processed.
        if not FindFile2StudSessScyDetails (f2_flt_rec, r1, FIND_SCY_DETAILS, p_error_message) then
           -- Fatal error ocurred, stop processing all records.
           -- Use scy details for flt currently being procd.
                  raise fatal_error;
        else
           --v_error_description := 'The fee loan transaction payment/adjustment amount to be passed to the SLC = 0';
           WriteToLog (pop_m263b_debug_file_handle, v_error_description);
           pop_m263_error (p_filename, trunc(p_filedate), 2, r1.stud_crse_year_id, r1.stud_ref_no,
                 r1.inst_code, r1.crse_code, r1.crse_id, r1.session_code,
                 r1.scottish_cand, SUBSTR(v_error_description,1,255), r1.scheme_type,
                 r1.dearing, FEE_LOAN);
           b_record_valid := false;
        end if;
*/
     --- Find the latest scy details in flt table to send to slc.
     if not FindFile2StudSessScyDetails (f2_flt_rec, r1, p_error_message) then
        --- Fatal error ocurred, stop processing all records.
        raise fatal_error;
           --- use latest scy details for file 2 production.
     elsif not CreateFile2 (f2_flt_rec, r1, r2, r3, r4, r5, sd, p_filename, p_filedate, b_record_valid, FEE_LOAN, p_error_message) then
        ---    Fatal error ocurred, stop processing all records.
        raise fatal_error;
     end if;
--
     ---     Only insert the record if all the validation checks are passed
     ---     and we have reached the max file size.
     ---     ---------------------------------------------------------------
     IF b_record_valid THEN
        WriteToLog (pop_m263b_debug_file_handle, 'Built file 2 FLT data.');
        IF n_number_of_records = n_maxrows THEN
           --- The maximum number of rows to be processed has been reached for this file.
           if not UpdSlcBatches (p_filename, p_filedate, n_number_of_records, num_stud,
             (num_flt + num_fl_only), sum_dr, sum_cr, p_error_message,
             pop_m263b_debug_file_handle) then
          raise fatal_error;
           else -- exit the loop, do not insert this record into slc_data, start new file.
          --- the current record will be picked up next time this cursor is opened.
          RAISE e_maxrows_reached; -- repeat this cursor as not complete.
           end if;
        END IF;
--
        ---     check tidying up funcs to call when max reached for this file.
        ---     Create new slc_data record and increment the n_number_of_records counter.
        -------------------------------------------------------------------------
        sd.slc_filename := p_filename;
        sd.slc_file_date := p_filedate;
        ins_ok := true;
        if not InsFile2SlcData (r1, r2, r3, r4, r5, sd, SLC_FILE_2_FORM_TYPE, ins_ok, p_error_message, pop_m263b_debug_file_handle) then
           --- Fatal error ocurred, stop processing all records.
           raise fatal_error;
        elsif ins_ok then
           ---if not UpdArcFeeLoanTxn (f2_flt_rec, sd, p_error_message, pop_m263b_debug_file_handle) then
           ---raise fatal_error;
           ---else
           --- student processed ok, add number of flts processed to totals.
           n_number_of_records := (n_number_of_records + 1);
           num_flt := (num_flt + 1);
---
           --- if sum of DR - CR is +ve then stud owes fee loan.
           if (f2_flt_rec.sum_txns > 0) then
         --- fee loan amount is a debit DR.
         sum_dr := (sum_dr + f2_flt_rec.sum_txns);
           else --- student is owed fee loan, make the CR amount +ve.
         sum_cr := (sum_cr + (f2_flt_rec.sum_txns * -1));
           end if;
---
           WriteToLog (pop_m263b_debug_file_handle, 'sum_dr: ' || sum_dr ||
                      ' sum_cr: ' || sum_cr);
        end if;
     else
        num_in_err := (num_in_err + 1);
        WriteToLog (pop_m263b_debug_file_handle, '--- Invalid file 2 fee loan data. num_in_err ' || num_in_err);
--
        if not UpdLoanFlags (r1.stud_ref_no,
                 r1.session_code,
                 r1.stud_crse_year_id,
                 f2_flt_rec.txn_interest_accrual_date,
                 p_filename,
                 p_filedate,
                 FEE_LOAN,
                 SLC_FILE_2_ID,
                 pop_m263b_debug_file_handle,
                 p_error_message) then
           raise fatal_error;
        end if;
     end if;
      end if;
      WriteToLog (pop_m263a_debug_file_handle, '' );
   end loop; -- f2_flt_rec
--
    if c_f2_flt%isopen then
        CLOSE c_f2_flt;
    end if;
--
   if not WriteSummaryData (pop_m263b_debug_file_handle, SLC_FILE_2_ID, p_filename, tot_rec_ctr, num_filtered,
                 num_in_err, num_stud, num_flt, num_fl_only, n_number_of_records,
                 sum_dr, sum_cr, p_error_message) then
      raise fatal_error;
   end if;
   writetolog (pop_m263b_debug_file_handle, '--------------------------------------------------------------------');

-- All records have been processed before the end (max number of recs reached)
--    of the current file.
-- ***************************************************************************
   if (n_number_of_records = 0) then
      -- nothing inserted into slc_data, delete the slc_batches record.
      if not DelSlcBatch (p_filename, p_filedate, pop_m263b_debug_file_handle, p_error_message) then
     raise fatal_error;
      end if;
   else
       if not UpdSlcBatches (p_filename, p_filedate, n_number_of_records, num_stud,
               (num_flt + num_fl_only), sum_dr, sum_cr, p_error_message,
               pop_m263b_debug_file_handle) then
           raise fatal_error;
       else -- all students processed, stop processing.
           p_repeat := FALSE;
      end if;
   end if;
--
   CloseLogFile(pop_m263b_debug_file_handle);
--
   p_repeat := FALSE;
   RETURN (n_number_of_records);
--
EXCEPTION
   WHEN fatal_error THEN -- fatal error in called function, stop processing.
       if c_f2_stud_loans%isopen then
           CLOSE c_f2_stud_loans;
       end if;
--
       if c_f2_flt%isopen then
           CLOSE c_f2_flt;
       end if;
--
--
       ROLLBACK;
       p_repeat := FALSE;
      WriteToLog(pop_m263b_debug_file_handle, 'fatal error in pop_m263b' ||n_sqlcode || ' ' || v_sqlerrm);
      RETURN -1;
--
   WHEN e_max_filesize_not_found THEN
      ROLLBACK;
      p_repeat := FALSE;
      RETURN -1;
   WHEN e_maxrows_reached THEN
      p_repeat := TRUE;
      WriteToLog (pop_m263b_debug_file_handle, 'max records reached for file: ' || p_filename);
      if not WriteSummaryData (pop_m263a_debug_file_handle, SLC_FILE_1_ID, p_filename, tot_rec_ctr, num_filtered,
                    num_in_err, num_stud, num_flt, num_fl_only, n_number_of_records,
                    sum_dr, sum_cr, p_error_message) then
     raise fatal_error;
      end if;
      writetolog (pop_m263b_debug_file_handle, '--------------------------------------------------------------------');
      RETURN (n_number_of_records);
--
  --  Write file management errors to DBMS output.
    WHEN utl_file.invalid_operation THEN
      CloseLogFile(pop_m263b_debug_file_handle);
      p_error_message := (' Debug file - File could not be opened ' || s_debug_path);
      ROLLBACK;
      RETURN -1;
--
    WHEN utl_file.invalid_path THEN
        CloseLogFile(pop_m263b_debug_file_handle);
        p_error_message := (' Debug file - Invalid file path ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
    WHEN utl_file.invalid_mode THEN
        CloseLogFile(pop_m263b_debug_file_handle);
        p_error_message := (' Debug file - Invalid file mode specified ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
    WHEN utl_file.invalid_filehandle THEN
        CloseLogFile(pop_m263b_debug_file_handle);
        p_error_message := (' Debug file - file specified is not open ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
    WHEN utl_file.write_error THEN
        CloseLogFile(pop_m263b_debug_file_handle);
        p_error_message := (' Debug file - Error writing to debug file ' || s_debug_path);
        ROLLBACK;
        RETURN -1;
--
     WHEN OTHERS THEN
     n_sqlcode := SQLCODE;
     v_sqlerrm := SQLERRM;
     p_error_message := 'The following fatal Error occured IN Pop_M263.POP_M263B '||n_sqlcode||' '||SQLERRM;
     ROLLBACK;
     p_repeat := FALSE;
     RETURN -1;
  END pop_m263b;
--
  -- addition for RFC 71 add a new file 3 for part time students
  FUNCTION pop_m263c (p_filename       IN VARCHAR2,
              p_filedate       IN DATE,
              p_repeat          OUT BOOLEAN,
              p_error_message OUT VARCHAR2) RETURN NUMBER IS
  -- produce loan file 3
     CURSOR c1 IS
      SELECT DISTINCT s.stud_ref_no, scy.stud_crse_year_id,
         ss.session_code, s.scottish_cand,
         s.surname, s.forenames,
         scy.crse_code, scy.inst_code,
         s.prev_loan_acc_no,
         s.sort_code, s.account_no, s.build_soc_no,
         s.bankrupt_flag, s.ni_no, ss.loan_declaration_date,
         scy.corres_dest,
         ss.pt_loan_check, ss.pt_loan_claimed,
         scy.scheme_type,
         scy.dearing, scy.crse_id
    FROM STUD_CRSE_YEAR scy,
         STUD_SESSION ss,
         AWARD a,
         STUD s
       WHERE ss.stud_ref_no = s.stud_ref_no
     AND scy.stud_session_id = ss.stud_session_id
     AND a.stud_crse_year_id = scy.stud_crse_year_id
     AND Award_Types.loan_award(a.stud_award_type) = 'Y'
     AND Slc_Util.loan_bearing(scy.stud_crse_year_id) = 'Y'
         AND scy.dearing = 'O'
     AND scy.slc2_sent = 'N'
     AND scy.sal_sent = 'Y'
     AND scy.slc1_sent = 'Y'
     AND scy.sal_dest IN ('1','R','A','M')
     AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
     AND scy.latest_crse_ind = 'Y'
     AND (scy.slc2_status NOT IN ('E','R') OR slc2_status IS NULL)
     AND (a.net_amount != 0 AND
              a.stud_award_type = 'PTL');
     CURSOR c2 (param_stud_ref_no STUD_HOME_ADDR.stud_ref_no%TYPE) IS
      SELECT house_no_name||' '||addr_l1 addr_l1, addr_l2, addr_l3,
         addr_l4, post_code, tele_no
    FROM STUD_HOME_ADDR
       WHERE stud_ref_no = param_stud_ref_no
     AND end_date IS NULL;
     CURSOR c4 (param_stud_ref_no STUD_CONT_DETAILS.stud_ref_no%TYPE) IS
      SELECT cont_name, cont_postcode, cont_addr1,
         cont_addr2, cont_addr3, cont_tel_no,
         cont_rel_code
    FROM STUD_CONT_DETAILS
       WHERE stud_ref_no = param_stud_ref_no
     AND contact_ind = 1;
     CURSOR c5 (param_stud_ref_no STUD_CONT_DETAILS.stud_ref_no%TYPE) IS
      SELECT cont_name, cont_postcode, cont_addr1,
         cont_addr2, cont_addr3, cont_tel_no
    FROM STUD_CONT_DETAILS
       WHERE stud_ref_no = param_stud_ref_no
     AND contact_ind = 2;
     CURSOR c6 IS
      SELECT nval
    FROM CONFIG_DATA
       WHERE item_name = 'SLC_MAX_FILESIZE';
     r1             c1%ROWTYPE;
     r2             c2%ROWTYPE;
     r4             c4%ROWTYPE;
     r5             c5%ROWTYPE;
     r4_temp            c4%ROWTYPE;
     r5_temp            c5%ROWTYPE;
     b_record_valid        BOOLEAN;
     b_number            BOOLEAN;
     v_home_post_code        VARCHAR(8);
     v_term_post_code        VARCHAR(8);
     v_cont1_post_code        VARCHAR(8);
     v_cont2_post_code        VARCHAR(8);
     v_error_description    VARCHAR2(2000);
     v_addr_corr_flag        STUD.addr_corr_flag%TYPE;
     v_award_type        VARCHAR2(2000);
     n_dummy_number        NUMBER;
     n_number_of_records    NUMBER;
     n_loan_amount        NUMBER;
     n_loan_request        NUMBER;
     n_return_no        NUMBER;
     n_maxrows            NUMBER;
     e_max_filesize_not_found    EXCEPTION;
     e_maxrows_reached        EXCEPTION;
     n_sqlcode            NUMBER;
     v_sqlerrm            VARCHAR2(2000);
  BEGIN
     p_error_message := NULL;
     n_number_of_records := 0;
     OPEN  c6;
     FETCH c6 INTO n_maxrows;
     IF c6%NOTFOUND THEN
    CLOSE c6;
    p_error_message := 'The following Error occured IN Pop_M263.POP_M263_ERROR : No ROW FOUND IN CONFIG_DATA FOR ITEM_NAME = SLC_MAX_FILESIZE';
    RAISE e_max_filesize_not_found;
     END IF;
     CLOSE c6;
     -- Create slc_batches record which is the parent of all slc_data records created here.
     -- Note that this record is updated at the end of the procedure with the number of
     -- reecords created.
     INSERT INTO SLC_BATCHES
     (slc_filename, slc_file_date,
      slc_file_type, record_count)
     VALUES
     (p_filename, p_filedate,
      '3', 0);
     -- produce details for all records on the stud_crse_year table
     FOR r1 IN c1 LOOP
    -- Find home address details;
    b_record_valid := TRUE;
    OPEN  c2 (r1.stud_ref_no);
    r2.addr_l1 := NULL;
    r2.addr_l2 := NULL;
    r2.addr_l3 := NULL;
    r2.addr_l4 := NULL;
    r2.post_code := NULL;
    r2.tele_no := NULL;
    FETCH c2 INTO r2;
    CLOSE c2;
    IF r1.scottish_cand IS NULL THEN
       -- Student SLC Reference Number is a mandatory field
       v_error_description := 'Student SLC reference number is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    n_return_no := Slc_Util.assessed_as_loan(r1.stud_crse_year_id,
                         n_loan_amount);
    IF r1.pt_loan_check = 'N' OR r1.pt_loan_check IS NULL THEN
       -- Total loan claimed is a mandatory field
       v_error_description := 'The part time loan checkbox is not checked';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    IF r1.pt_loan_check = 'Y' AND r1.pt_loan_claimed = 'Y' THEN
           -- student requested maximum loan
       n_loan_request := n_loan_amount;
    END IF;
    v_home_post_code := NULL;
    IF r2.post_code IS NOT NULL THEN
       -- home post code is optional. Only validate if supplied.
       IF NOT pop_m263_postcode(r2.post_code,
                    v_home_post_code) THEN
          -- postcode is in an invalid format
          v_error_description := 'The format of home post code '||r2.post_code||' is incorrect';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 3,
                 r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
                 r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
                 SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
          b_record_valid := FALSE;
       END IF;
    END IF;
    -- Find 1st contact address details;
    OPEN  c4 (r1.stud_ref_no);
    r4.cont_name     := NULL;
    r4.cont_postcode := NULL;
    r4.cont_addr1     := NULL;
    r4.cont_addr2     := NULL;
    r4.cont_addr3     := NULL;
    r4.cont_tel_no     := NULL;
    r4.cont_rel_code := NULL;
    FETCH c4 INTO r4;
    IF r4.cont_name IS NULL THEN
       -- Contact name is a mandatory field
       v_error_description := 'First contact name is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    IF r4.cont_rel_code IS NULL THEN
       -- Contact rel is a mandatory field
       v_error_description := 'First contact relationship is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    IF r4.cont_addr1 IS NULL THEN
       -- Contact address line 1 is a mandatory field
       v_error_description := 'First contact address line 1 is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    IF r4.cont_addr2 IS NULL AND r4.cont_addr3 IS NULL THEN
       -- Both Contact address line 2 and 3 cannot be null
       v_error_description := 'First contact address lines 2 and 3 are missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    v_cont1_post_code := NULL;
    IF r4.cont_postcode IS NOT NULL THEN
       -- first contact post code is optional. Only validate if supplied.
       IF NOT pop_m263_postcode(r4.cont_postcode,
                    v_cont1_post_code) THEN
          -- postcode is in an invalid format
          v_error_description := 'The format OF first contact post code '||r4.cont_postcode||' IS incorrect';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 3,
                 r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
                 r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
                 SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
          b_record_valid := FALSE;
       END IF;
    END IF;
    -- Check if duplicate first contact exists
    FETCH c4 INTO r4_temp;
    IF c4%FOUND THEN
       -- Duplicate first contacts exist
       v_error_description := 'Duplicate First Contact Details Exist - Contact B.S.U';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    CLOSE c4;
    -- Find 2nd contact address details;
    OPEN  c5 (r1.stud_ref_no);
    r5.cont_name     := NULL;
    r5.cont_postcode := NULL;
    r5.cont_addr1     := NULL;
    r5.cont_addr2     := NULL;
    r5.cont_addr3     := NULL;
    r5.cont_tel_no     := NULL;
    FETCH c5 INTO r5;
    IF r5.cont_name IS NULL THEN
       -- Contact name is a mandatory field
       v_error_description := 'Second contact name is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    IF r5.cont_addr1 IS NULL THEN
       -- Second contact address line 1 is a mandatory field
       v_error_description := 'Second contact address line 1 is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    IF r5.cont_addr2 IS NULL AND r5.cont_addr3 IS NULL THEN
       -- Both Second contact address line 2 and 3 cannot be null
       v_error_description := 'Second contact address lines 2 and 3 are missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    v_cont2_post_code := NULL;
    IF r5.cont_postcode IS NOT NULL THEN
       -- second contact post code is optional. Only validate if supplied.
       IF NOT pop_m263_postcode(r5.cont_postcode,
                    v_cont2_post_code) THEN
          -- postcode is in an invalid format
          v_error_description := 'The format of second contact post code '||r5.cont_postcode||' IS incorrect';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 3,
                 r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
                 r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
                 SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
          b_record_valid := FALSE;
       END IF;
    END IF;
    -- Check if duplicate second contact exists
    FETCH c5 INTO r5_temp;
    IF c5%FOUND THEN
       -- Duplicate second contacts exist
       v_error_description := 'Duplicate Second Contact Details Exist - Contact B.S.U';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    CLOSE c5;
    IF r1.sort_code IS NOT NULL THEN
       IF LENGTH(r1.sort_code) != 6 THEN
          v_error_description := 'The sort code '||r1.sort_code||' is incorrect. It must consist of 6 numerics';
          -- Validation failed. Insert error into slc_errors
          pop_m263_error(p_filename, p_filedate, 3,
                 r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
                 r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
                 SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
          b_record_valid := FALSE;
       ELSE
          BEGIN
         n_dummy_number := r1.sort_code;
         b_number := TRUE;
          EXCEPTION
         WHEN OTHERS THEN
            b_number := FALSE;
          END;
          IF NOT b_number THEN
         v_error_description := 'The sort code '||r1.sort_code||' is incorrect. It must consist of 6 numerics';
         -- Validation failed. Insert error into slc_errors
         pop_m263_error(p_filename, p_filedate, 3,
                r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
                r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
                SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
         b_record_valid := FALSE;
          END IF;
       END IF;
       -- Whenever sort code is supplied either account no or building society roll no must be supplied.
       IF r1.account_no IS NULL AND
          r1.build_soc_no IS NULL THEN
         v_error_description := 'A sort code has been supplied without either a account code or a building society roll number';
         -- Validation failed. Insert error into slc_errors
         pop_m263_error(p_filename, p_filedate, 3,
                r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
                r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
                SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
         b_record_valid := FALSE;
       END IF;
    END IF;
    IF r1.loan_declaration_date IS NULL THEN
       -- loan declaration date must be supplied.
       v_error_description := 'Loan Declaration date is missing';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    IF LENGTH(r2.tele_no) > 14 THEN
       v_error_description := 'The number of characters contained in the home telephone number exceeds the maximum of 14';
       -- Validation failed. Insert error into slc_errors
       pop_m263_error(p_filename, p_filedate, 3,
              r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
              r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
              SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       b_record_valid := FALSE;
    END IF;
    IF b_record_valid THEN
       -- Only insert the record if all the validation checks are passed
       BEGIN
          IF n_number_of_records = n_maxrows THEN
         -- The maximum number of rows to be processed has been reached
         UPDATE SLC_BATCHES
            SET record_count = n_number_of_records
          WHERE slc_filename  = p_filename
            AND slc_file_date = p_filedate;
         COMMIT;
     SET TRANSACTION USE ROLLBACK SEGMENT RBS1;
         RAISE e_maxrows_reached;
          END IF;
          INSERT INTO SLC_DATA
           (slc_filename, slc_file_date, stud_crse_year_id,
        form_type, VALIDATION, academic_year,
        slc_ref_no,
        surname, forenames, total_loan_claimed,
        home_addr_l1, home_addr_l2, home_addr_l3,
        home_addr_l4, home_post_code, home_tele_no,
        prev_loan_acc_no, first_cont_name, first_cont_rel_code,
        first_cont_addr1, first_cont_addr2, first_cont_addr3,
        first_cont_postcode, first_cont_tel_no, second_cont_name,
        second_cont_addr1, second_cont_addr2, second_cont_addr3,
        second_cont_postcode, second_cont_tel_no, sort_code,
        account_no, build_soc_no, bankrupt_flag,
        ni_number, declaration_date, record_type)
          VALUES
           (p_filename, p_filedate, r1.stud_crse_year_id,
        'SP', 'V', r1.session_code,
        r1.scottish_cand,
        r1.surname, r1.forenames, n_loan_request,
        SUBSTR(r2.addr_l1,1,60), SUBSTR(r2.addr_l2,1,60), r2.addr_l3,
        r2.addr_l4, r2.post_code, r2.tele_no,
        r1.prev_loan_acc_no, r4.cont_name, r4.cont_rel_code,
        r4.cont_addr1, r4.cont_addr2, r4.cont_addr3,
        v_cont1_post_code, r4.cont_tel_no, r5.cont_name,
        r5.cont_addr1, r5.cont_addr2, r5.cont_addr3,
        v_cont2_post_code, r5.cont_tel_no, r1.sort_code,
        r1.account_no, r1.build_soc_no, nvl(r1.bankrupt_flag, 'N'),
        r1.ni_no, r1.loan_declaration_date, STUD_LOAN);
        n_number_of_records := n_number_of_records + 1;
       EXCEPTION
          WHEN VALUE_ERROR THEN
         -- report error and continue processing
         n_sqlcode := SQLCODE;
         v_sqlerrm := SQLERRM;
         v_error_description := 'The following oracle Error occurred '||n_sqlcode||' '||v_sqlerrm;
         -- Validation failed. Insert error into slc_errors
         pop_m263_error(p_filename, p_filedate, 3,
                r1.stud_crse_year_id, r1.stud_ref_no, r1.inst_code,
                r1.crse_code, r1.crse_id, r1.session_code, r1.scottish_cand,
                SUBSTR(v_error_description,1,255), r1.scheme_type, r1.dearing, null);
       END;
    END IF;
     END LOOP;
     UPDATE SLC_BATCHES
    SET record_count = n_number_of_records
      WHERE slc_filename  = p_filename
    AND slc_file_date = p_filedate;
     p_repeat := FALSE;
     RETURN (n_number_of_records);
  EXCEPTION
     WHEN e_max_filesize_not_found THEN
    ROLLBACK;
    p_repeat := FALSE;
    RETURN -1;
     WHEN e_maxrows_reached THEN
    p_repeat := TRUE;
    RETURN (n_number_of_records);
     WHEN OTHERS THEN
    n_sqlcode := SQLCODE;
    v_sqlerrm := SQLERRM;
    p_error_message := 'The following fatal Error occured IN Pop_M263.POP_M263C '||n_sqlcode||' '||SQLERRM;
    ROLLBACK;
    p_repeat := FALSE;
    RETURN -1;
  END pop_m263c;
-- end of rfc 71 addition
--
--
--
FUNCTION POP_M263D (p_filename         IN VARCHAR2,
                  p_filedate     IN DATE,
                  p_repeat           OUT BOOLEAN,
                  p_error_message  OUT VARCHAR2,
                  p_total_loan_amount OUT NUMBER) RETURN NUMBER IS
--
CURSOR cu_grad_endow IS
SELECT stud_ref_no, appeal_status, ge_session, signature_date
FROM GRAD_ENDOW
WHERE slc_file4_status = 'A';

rec_grad_endow cu_grad_endow%ROWTYPE;
--
CURSOR cu_alter_session(cp_stud_ref_no IN NUMBER)  IS
SELECT ge_session
FROM GE_STATUS_HISTORY
WHERE stud_ref_no = cp_stud_ref_no
AND ge_session <> 'Non-Liable'
AND status_date = (SELECT MAX(status_date)
             FROM GE_STATUS_HISTORY
             WHERE stud_ref_no = cp_stud_ref_no
             AND ge_session <>  'Non-Liable');

rec_alter_session cu_alter_session%ROWTYPE;
--
CURSOR cu_payment_sum(cp_stud_ref_no IN NUMBER) IS
SELECT SUM(amount) total
FROM GE_PAYMENTS
WHERE stud_ref_no = cp_stud_ref_no
AND reason IN ('B','D','F')
AND void = 'N';

rec_payment_sum cu_payment_sum%ROWTYPE;
--
CURSOR cu_crse_term IS
SELECT end_date
FROM CRSE_TERM;

rec_crse_term cu_crse_term%ROWTYPE;
--
/*CURSOR cu_letter_history(cp_stud_ref_no IN NUMBER) IS
SELECT MAX(letter_date) letter_date
FROM GE_LETTER_HISTORY
WHERE stud_ref_no = cp_stud_ref_no
AND letter_type = 2; */
-- RFC172 - ge_payments used
CURSOR cu_letter_history(cp_stud_ref_no IN NUMBER) IS
SELECT MAX(pmt_date) letter_date
FROM ge_payments
WHERE stud_ref_no = cp_stud_ref_no
AND NVL(ge_payments.reason,'X') IN ('B','F')
AND NVL(ge_payments.void,'Y') = 'N';
-- RFC172 End
rec_letter_history cu_letter_history%ROWTYPE;
--
CURSOR cu_stud_session(cp_stud_ref_no IN NUMBER) IS
SELECT MAX(ss.session_code) session_code
FROM STUD_SESSION ss, STUD_CRSE_YEAR scy, crse_year cy, crse c
WHERE ss.stud_ref_no = cp_stud_ref_no
and ss.stud_session_id = scy.stud_session_id
and cy.crse_year_id = scy.crse_year_id
and c.crse_id = cy.crse_id
and scy.application_status IN ('C', 'W')
and (scy.scheme_type = 'U'
    OR (scy.scheme_type = 'P' AND c.qual_type = 'PGCE'));

rec_stud_session cu_stud_session%ROWTYPE;
--
CURSOR cu_stud_crse_year(cp_stud_ref_no IN NUMBER) IS
SELECT scy.stud_crse_year_id, scy.inst_code, scy.crse_code, scy.crse_year_no, scy.scheme_type, scy.dearing, scy.crse_id, scy.session_code, scy.crse_year_id
FROM STUD_SESSION ss, STUD_CRSE_YEAR scy, crse_year cy, crse c
WHERE ss.stud_ref_no = cp_stud_ref_no
and ss.stud_session_id = scy.stud_session_id
and cy.crse_year_id = scy.crse_year_id
and c.crse_id = cy.crse_id
and scy.application_status IN ('C', 'W')
and (scy.scheme_type = 'U'
            OR (scy.scheme_type = 'P' AND c.qual_type = 'PGCE'))
AND scy.session_code = (SELECT MAX(ss.session_code) session_code
            FROM STUD_SESSION ss, STUD_CRSE_YEAR scy, crse_year cy, crse c
            WHERE ss.stud_ref_no = cp_stud_ref_no
            and ss.stud_session_id = scy.stud_session_id
            and cy.crse_year_id = scy.crse_year_id
            and c.crse_id = cy.crse_id
            and scy.application_status IN ('C', 'W')
            and (scy.scheme_type = 'U'
            OR (scy.scheme_type = 'P' AND c.qual_type = 'PGCE')));
--
-- End of SIR 55 fix.
--
rec_stud_crse_year cu_stud_crse_year%ROWTYPE;
--
CURSOR cu_stud(cp_stud_ref_no IN NUMBER) IS
SELECT title, surname, forenames, sex, dob, birth_surname, birth_forenames, district_birth_cert_issued,
                birth_country_code, bankrupt_flag, ni_no, scottish_cand
FROM STUD
WHERE stud_ref_no = cp_stud_ref_no;

rec_stud cu_stud%ROWTYPE;
--
CURSOR cu_birth_country(cp_country_code IN NUMBER) IS
SELECT SUBSTR(long_name,1,25) birth_country
FROM COUNTRY
WHERE country_code = cp_country_code;

rec_birth_country cu_birth_country%ROWTYPE;
--
CURSOR cu_stud_home_addr(cp_stud_ref_no IN NUMBER) IS
SELECT SUBSTR(house_no_name||' '||addr_l1,1,60)  addr_l1, SUBSTR(addr_l2,1,60) addr_l2, addr_l3, addr_l4, post_code, tele_no
FROM STUD_HOME_ADDR
WHERE stud_ref_no = cp_stud_ref_no
AND end_date IS NULL;

rec_stud_home_addr cu_stud_home_addr%ROWTYPE;
--
CURSOR cu_ge_payments(cp_stud_ref_no IN NUMBER) IS
SELECT SUM(amount) amount
FROM GE_PAYMENTS
WHERE stud_ref_no = cp_stud_ref_no
AND void = 'N';

rec_ge_payments cu_ge_payments%ROWTYPE;
--
CURSOR cu_stud_cont_detailsI(cp_stud_ref_no IN NUMBER) IS
SELECT cont_name, cont_rel_code, cont_addr1, cont_addr2, cont_addr3, cont_postcode, cont_tel_no
FROM STUD_CONT_DETAILS
WHERE stud_ref_no = cp_stud_ref_no
AND contact_ind = 1;

rec_stud_cont_detailsI cu_stud_cont_detailsI%ROWTYPE;
--
CURSOR cu_stud_cont_detailsII(cp_stud_ref_no IN NUMBER) IS
SELECT cont_name, cont_addr1, cont_addr2, cont_addr3, cont_postcode, cont_tel_no
FROM STUD_CONT_DETAILS
WHERE stud_ref_no = cp_stud_ref_no
AND contact_ind = 2;

rec_stud_cont_detailsII cu_stud_cont_detailsII%ROWTYPE;
--
CURSOR cu_max_filesize IS
SELECT nval
FROM CONFIG_DATA
WHERE item_name = 'SLC_MAX_FILESIZE';
--
CURSOR cu_relation_type(cp_rel_code VARCHAR2) IS
SELECT cval result
FROM VALIDATION
WHERE TYPE = 'SLC_REL'
AND CVAL = cp_rel_code ;
rec_relation_type cu_relation_type%ROWTYPE;
--
     v_error_description VARCHAR2(255);
     n_sqlcode            NUMBER;
     v_sqlerrm            VARCHAR2(2000);
     v_home_post_code        VARCHAR(8);
     b_record_valid        BOOLEAN;
     n_number_of_records NUMBER;
     n_maxrows            NUMBER;
     v_appeal_status VARCHAR2(1);
     v_inst_code VARCHAR2(6);
     vi_inst_code VARCHAR2(6);
     v_inst_name VARCHAR2(50);
     v_crse_code VARCHAR2(6);
     v_crse_name VARCHAR2(50);
     v_crse_end_date VARCHAR(6);
     v_success NUMBER;
     e_max_filesize_not_found    EXCEPTION;
     e_maxrows_reached        EXCEPTION;
     v_ge_session NUMBER(4);
     v_slc_ref_no VARCHAR2(13);
     v_eu_flag VARCHAR2(1);
--
BEGIN
p_error_message := NULL;
n_number_of_records := 0;
p_total_loan_amount := 0;
--
OPEN  cu_max_filesize;
FETCH cu_max_filesize INTO n_maxrows;
IF cu_max_filesize%NOTFOUND THEN
    CLOSE cu_max_filesize;
    p_error_message := 'The following Error occured IN Pop_M263.POP_M263_ERROR : No ROW FOUND IN CONFIG_DATA FOR ITEM_NAME = SLC_MAX_FILESIZE';
    RAISE e_max_filesize_not_found;
END IF;
CLOSE cu_max_filesize;
--
-- Create slc_batches record which is the parent of all slc_data records created here.
-- Note that this record is updated at the end of the procedure with the number of
-- reecords created.
INSERT INTO SLC_BATCHES
(slc_filename, slc_file_date,slc_file_type, record_count)
VALUES
(p_filename, p_filedate,'4', 0);
--
FOR rec_grad_endow IN cu_grad_endow LOOP
  b_record_valid := TRUE;
  v_home_post_code := NULL;
  v_appeal_status := NULL;
  v_inst_code := NULL;
  vi_inst_code := NULL;
  v_inst_name := NULL;
  v_crse_code := NULL;
  v_crse_name := NULL;
  v_crse_end_date := NULL;
  v_ge_session := NULL;
  v_slc_ref_no := NULL;
        --
        OPEN cu_payment_sum(rec_grad_endow.stud_ref_no);
        FETCH cu_payment_sum INTO rec_payment_sum;
        CLOSE cu_payment_sum;
        --
        OPEN cu_stud_session(rec_grad_endow.stud_ref_no);
--        LOOP
        FETCH cu_stud_session INTO rec_stud_session;
        EXIT WHEN cu_stud_session%NOTFOUND;
        CLOSE cu_stud_session;
        --
        --
        OPEN cu_letter_history(rec_grad_endow.stud_ref_no);
        FETCH cu_letter_history INTO rec_letter_history;
        CLOSE cu_letter_history;
        --
        OPEN cu_stud_crse_year(rec_grad_endow.stud_ref_no);
        FETCH cu_stud_crse_year INTO rec_stud_crse_year;
        CLOSE cu_stud_crse_year;
        --
        OPEN cu_stud(rec_grad_endow.stud_ref_no);
        FETCH cu_stud INTO rec_stud;
        CLOSE cu_stud;
        --
        OPEN cu_birth_country(rec_stud.birth_country_code);
        FETCH cu_birth_country INTO rec_birth_country;
        CLOSE cu_birth_country;
        --
        OPEN cu_stud_home_addr(rec_grad_endow.stud_ref_no);
        FETCH cu_stud_home_addr INTO rec_stud_home_addr;
        CLOSE cu_stud_home_addr;
        --
        OPEN cu_ge_payments(rec_grad_endow.stud_ref_no);
        FETCH cu_ge_payments INTO rec_ge_payments;
        CLOSE cu_ge_payments;
        --
        OPEN cu_stud_cont_detailsI(rec_grad_endow.stud_ref_no);
        FETCH cu_stud_cont_detailsI INTO rec_stud_cont_detailsI;
        CLOSE cu_stud_cont_detailsI;
        --
        OPEN cu_stud_cont_detailsII(rec_grad_endow.stud_ref_no);
        FETCH cu_stud_cont_detailsII INTO rec_stud_cont_detailsII;
        CLOSE cu_stud_cont_detailsII;
        --
        OPEN cu_relation_type(rec_stud_cont_detailsI.cont_rel_code);
        FETCH cu_relation_type INTO rec_relation_type;
        CLOSE cu_relation_type;
        --
        IF rec_grad_endow.ge_session = 'Non-Liable' THEN
            OPEN cu_alter_session(rec_grad_endow.stud_ref_no);
            FETCH cu_alter_session INTO v_ge_session;
            CLOSE cu_alter_session;
        ELSE
            v_ge_session := rec_grad_endow.ge_session;
        END IF;
        --
        IF v_ge_session IS NULL THEN
            v_error_description := 'GE session is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                        rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                        rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                        b_record_valid := FALSE;
        END IF;
        --
        IF rec_grad_endow.appeal_status IS NULL THEN
            v_error_description := 'Appeal Status is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                        rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                        rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                        b_record_valid := FALSE;
        END IF;
        --
--        v_slc_ref_no := 'SAAS'||rec_stud.scottish_cand; ****replaced with below line SJ SIR1445 23/10/2003
        v_slc_ref_no := rec_stud.scottish_cand;
        v_inst_code := rec_stud_crse_year.inst_code;
        v_success := Slc_Util.slc_inst_code(rec_stud_crse_year.stud_crse_year_id, v_inst_code, v_inst_name);

        vi_inst_code := rec_stud_crse_year.inst_code;
        v_success := Slc_Util.slc_crse_code(rec_stud_crse_year.stud_crse_year_id, vi_inst_code, v_crse_code,v_crse_name);
--   RFC172
          v_success := Slc_util.slc4_course_end_date(rec_stud_crse_year.stud_crse_year_id,
            rec_stud_crse_year.inst_code,
                    rec_stud_crse_year.crse_code,
                    rec_stud_session.session_code,
                    rec_stud_crse_year.crse_year_no,
                    v_crse_end_date);
/*          v_success := Slc_Util.course_end_date(rec_stud_crse_year.inst_code, rec_stud_crse_year.crse_code, rec_stud_session.session_code,
                                rec_stud_crse_year.crse_year_no, v_crse_end_date);*/
--  END RFC172
        --
        IF (rec_grad_endow.appeal_status = 'C') OR (rec_payment_sum.total = 0) THEN
            v_appeal_status := 'C';
        ELSE
            v_appeal_status := 'A';
        END IF;
        --
        IF rec_grad_endow.signature_date IS NULL THEN
            v_error_description := 'Signature date is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;
        --
        IF rec_letter_history.letter_date IS NULL THEN
            v_error_description := 'Issue date is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;
        --
        IF rec_stud_session.session_code IS NULL THEN
            v_error_description := 'Session code is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;
        --
        IF v_crse_end_date IS NULL THEN
            v_error_description := 'Course end date is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;
        --
        IF v_inst_code IS NULL THEN
            v_error_description := 'Institution Code is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF v_crse_code IS NULL THEN
            v_error_description := 'Course Code is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF rec_stud_crse_year.crse_year_no IS NULL THEN
            v_error_description := 'Course Year number is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;
        --
        IF rec_stud.title IS NULL THEN
            v_error_description := 'Student Title is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF rec_stud.surname IS NULL THEN
            v_error_description := 'Student Surname is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF rec_stud.forenames IS NULL THEN
            v_error_description := 'Student Forenames are missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF rec_stud.sex IS NULL THEN
            v_error_description := 'Student Gender is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF rec_stud.dob IS NULL THEN
            v_error_description := 'Student date of birth is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF rec_stud.district_birth_cert_issued IS NULL THEN
            v_error_description := 'Student District of birth is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF rec_stud.birth_country_code IS NULL THEN
            v_error_description := 'Student country of birth is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;
        --
        IF rec_stud_home_addr.tele_no IS NULL THEN
            rec_stud_home_addr.tele_no := '88888888888888';
        END IF;

    -- SIR588 - Add code to validate tel nos are 14 chars long
        IF LENGTH(rec_stud_home_addr.tele_no) > 14 THEN
          v_error_description := 'The number of characters contained in the home telephone number exceeds the maximum of 14';
       -- Validation failed. Insert error into slc_errors
           pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
           b_record_valid := FALSE;
       END IF;


        IF rec_stud_home_addr.addr_l1 IS NULL THEN
            v_error_description := 'Student Address Details Are Missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF (rec_stud_home_addr.addr_l3 IS NULL) AND (rec_stud_home_addr.addr_l4 IS NULL) THEN
            IF rec_stud_home_addr.addr_l2 IS NULL THEN
                v_error_description := 'Student Address Details Are Missing.  Line 2 Must Be Present if lines 3 and 4 are missing';
                pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                                rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                                rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                                b_record_valid := FALSE;
            END IF;
        END IF;

        IF (rec_stud_home_addr.addr_l2 IS NULL) AND (rec_stud_home_addr.addr_l4 IS NULL) THEN
            IF rec_stud_home_addr.addr_l3 IS NULL THEN
                v_error_description := 'Student Address Details Are Missing.  Line 3 Must Be Present if lines 2 and 4 are missing';
                pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                                rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                                rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                                b_record_valid := FALSE;
            END IF;
        END IF;

        IF (rec_stud_home_addr.addr_l2 IS NULL) AND (rec_stud_home_addr.addr_l3 IS NULL) THEN
            IF rec_stud_home_addr.addr_l4 IS NULL THEN
                v_error_description := 'Student Address Details Are Missing.  Line 4 Must Be Present if lines 2 and 3 are missing';
                pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                                rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                                rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                                b_record_valid := FALSE;
            END IF;
        END IF;
        --
        IF rec_stud_home_addr.post_code IS NOT NULL THEN
            v_home_post_code := NULL;
            -- home post code is optional. Only validate if supplied.
       IF NOT pop_m263_postcode(rec_stud_home_addr.post_code,v_home_post_code) THEN
          -- postcode is in an invalid format

          v_error_description := 'The format of home post code '||rec_stud_home_addr.post_code||' IS incorrect';
          pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
              -- Validation failed. Insert error into slc_errors
         END IF;
        END IF;
        --
        IF rec_ge_payments.amount IS NULL THEN
            v_error_description := 'Student GE Loan Amount is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        --
        IF rec_stud_cont_detailsI.cont_name IS NULL THEN
            v_error_description := 'First Student Contact Name is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;

        END IF;

        IF rec_stud_cont_detailsI.cont_addr1 IS NULL THEN
            v_error_description := 'First Student Contact Details are Incomplete';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF rec_stud_cont_detailsI.cont_addr2 IS NULL THEN
            IF rec_stud_cont_detailsI.cont_addr3 IS NULL THEN
                v_error_description := 'First Student Contact Details are Incomplete';
                pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                                rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                                rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                                b_record_valid := FALSE;
            END IF;
        END IF;

        IF rec_stud_cont_detailsI.cont_addr3 IS NULL THEN
            IF rec_stud_cont_detailsI.cont_addr2 IS NULL THEN
                v_error_description := 'First Student Contact Details are Incomplete';
                pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                                rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                                rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
            END IF;
        END IF;

        IF rec_stud_cont_detailsI.cont_rel_code IS NULL THEN
            v_error_description := 'First Student Contact Relationship is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        ELSE
            IF rec_relation_type.result IS NULL THEN
                v_error_description := 'Student Contact Relationship is invalid';
                pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                            b_record_valid := FALSE;
            END IF;
        END IF;
        --
        IF rec_stud_cont_detailsI.cont_tel_no IS NULL THEN
            rec_stud_cont_detailsI.cont_tel_no := '88888888888888';
        END IF;
        --
        IF rec_stud_cont_detailsII.cont_tel_no IS NULL THEN
            rec_stud_cont_detailsII.cont_tel_no := '88888888888888';
        END IF;
        --
        IF rec_stud_cont_detailsI.cont_postcode IS NOT NULL THEN
            v_home_post_code := NULL;

            -- home post code is optional. Only validate if supplied.
               IF NOT pop_m263_postcode(rec_stud_cont_detailsI.cont_postcode,v_home_post_code) THEN
                  -- postcode is in an invalid format
                  v_error_description := 'The format OF first contact post code '||rec_stud_cont_detailsI.cont_postcode||' IS incorrect';
                  pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                            b_record_valid := FALSE;
                  -- Validation failed. Insert error into slc_errors
             END IF;
        END IF;
        --
        IF rec_stud_cont_detailsII.cont_name IS NULL THEN
            v_error_description := 'Second Student Contact Name is missing';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF rec_stud_cont_detailsII.cont_addr1 IS NULL THEN
            v_error_description := 'Second Student Contact Details are Incomplete';
            pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                            b_record_valid := FALSE;
        END IF;

        IF rec_stud_cont_detailsII.cont_addr2 IS NULL THEN
            IF rec_stud_cont_detailsII.cont_addr3 IS NULL THEN
                v_error_description := 'Second Student Contact Details are Incomplete';
                pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                                rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                                rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                                b_record_valid := FALSE;
            END IF;
        END IF;

        IF rec_stud_cont_detailsII.cont_addr3 IS NULL THEN
            IF rec_stud_cont_detailsII.cont_addr2 IS NULL THEN
                v_error_description := 'Second Student Contact Details are Incomplete';
                pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                                                rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                                                rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                                                b_record_valid := FALSE;
            END IF;
        END IF;

        IF rec_stud_cont_detailsII.cont_postcode IS NOT NULL THEN
            v_home_post_code := NULL;
            -- home post code is optional. Only validate if supplied.
               IF NOT pop_m263_postcode(rec_stud_cont_detailsII.cont_postcode,v_home_post_code) THEN
                  -- postcode is in an invalid format
                  v_error_description := 'The format of second contact post code '||rec_stud_cont_detailsII.cont_postcode||' IS incorrect';
                  pop_m263_error(p_filename,p_filedate,4,rec_stud_crse_year.stud_crse_year_id,rec_grad_endow.stud_ref_no,rec_stud_crse_year.inst_code,
                            rec_stud_crse_year.crse_code,rec_stud_crse_year.crse_id,rec_stud_session.session_code,
                            rec_stud.scottish_cand,v_error_description,rec_stud_crse_year.scheme_type,rec_stud_crse_year.dearing, null);
                            b_record_valid := FALSE;
              -- Validation failed. Insert error into slc_errors
             END IF;
        END IF;
        --
        IF b_record_valid THEN
            --
            IF n_number_of_records = n_maxrows THEN
                -- The maximum number of rows to be processed has been reached
                UPDATE SLC_BATCHES
                SET record_count = n_number_of_records
                WHERE slc_filename  = p_filename
                AND slc_file_date = p_filedate;
                COMMIT;
        SET TRANSACTION USE ROLLBACK SEGMENT RBS1;
                RAISE e_maxrows_reached;
            END IF;
            --

        SELECT  NVL(eu_flag,'N')
             INTO    v_eu_flag
             FROM CRSE_YEAR
             WHERE crse_year_id = rec_stud_crse_year.crse_year_id;
            --
            -- SIR 55 fix.
            -- Add the new GE_SESS_CODE field and populate this
            -- with the REC_STUD_CRSE_YEAR.SESSION_CODE value.
            --
            INSERT INTO SLC_DATA (SLC_FILENAME,SLC_FILE_DATE,STUD_CRSE_YEAR_ID,FORM_TYPE,ACADEMIC_YEAR,ISSUE_DATE,SLC_REF_NO,STATUS,
                                                        HEI_INST_CODE,HEI_CRSE_CODE,CRSE_YEAR_NO,TITLE,SURNAME,FORENAMES,HOME_ADDR_L1,HOME_ADDR_L2,
                                                        HOME_ADDR_L3,HOME_ADDR_L4,HOME_POST_CODE,SEX,DOB,END_DATE,BIRTH_SURNAME,BIRTH_FORENAMES,
                                                        HOME_TELE_NO,DISTRICT_BIRTH_CERT_ISSUED,BIRTH_COUNTRY,TOTAL_LOAN_CLAIMED,FIRST_CONT_NAME,FIRST_CONT_REL_CODE,
                                                        FIRST_CONT_ADDR1,FIRST_CONT_ADDR2,FIRST_CONT_ADDR3,FIRST_CONT_POSTCODE,FIRST_CONT_TEL_NO,SECOND_CONT_NAME,
                                                        SECOND_CONT_ADDR1,SECOND_CONT_ADDR2,SECOND_CONT_ADDR3,SECOND_CONT_POSTCODE,SECOND_CONT_TEL_NO,BANKRUPT_FLAG,
                                                        NI_NUMBER,DECLARATION_DATE, GE_SESS_CODE, EU_FLAG, record_type) VALUES
                                                                 (p_filename,
                                                                    p_filedate,
                                                                    rec_stud_crse_year.stud_crse_year_id,
                                                                    'SL',
                                                                    v_ge_session,
                                                                    rec_letter_history.letter_date,
                                                                    v_slc_ref_no ,
                                                                    v_appeal_status,
                                                                    v_inst_code,
                                                                    v_crse_code,
                                                                    rec_stud_crse_year.crse_year_no,
                                                                    SUBSTR(rec_stud.title,1,4),
                                                                    rec_stud.surname,
                                                                    rec_stud.forenames,
                                                                    rec_stud_home_addr.addr_l1,
                                                                    rec_stud_home_addr.addr_l2,
                                                                    rec_stud_home_addr.addr_l3,
                                                                    rec_stud_home_addr.addr_l4,
                                                                    rec_stud_home_addr.post_code,
                                                                    rec_stud.sex,
                                                                    rec_stud.dob,
                                                                    v_crse_end_date,
                                                                    rec_stud.birth_surname,
                                                                    rec_stud.birth_forenames,
                                                                    rec_stud_home_addr.tele_no,
                                                                    rec_stud.district_birth_cert_issued,
                                                                    rec_birth_country.birth_country,
                                                                    rec_payment_sum.total,
                                                                    rec_stud_cont_detailsi.cont_name,
                                                                    rec_stud_cont_detailsi.cont_rel_code,
                                                                    rec_stud_cont_detailsi.cont_addr1,
                                                                    rec_stud_cont_detailsi.cont_addr2,
                                                                    rec_stud_cont_detailsi.cont_addr3,
                                                                    rec_stud_cont_detailsi.cont_postcode,
                                                                    rec_stud_cont_detailsi.cont_tel_no,
                                                                    rec_stud_cont_detailsii.cont_name,
                                                                    rec_stud_cont_detailsii.cont_addr1,
                                                                    rec_stud_cont_detailsii.cont_addr2,
                                                                    rec_stud_cont_detailsii.cont_addr3,
                                                                    rec_stud_cont_detailsii.cont_postcode,
                                                                    rec_stud_cont_detailsii.cont_tel_no,
                                                                    nvl(rec_stud.bankrupt_flag, 'N'),
                                                                    rec_stud.ni_no,
                                                                    rec_grad_endow.signature_date,
                                                                    rec_stud_crse_year.session_code,
                                                v_eu_flag, STUD_LOAN);
            --
            -- End of SIR 55 fix.
            --
            n_number_of_records := n_number_of_records + 1;
            p_total_loan_amount := p_total_loan_amount + rec_payment_sum.total;
        ELSE
                UPDATE GRAD_ENDOW
                SET slc_file4_status = 'E',
                        slc_status ='C'
                WHERE stud_ref_no = rec_grad_endow.stud_ref_no;
        END IF;
    END LOOP;
--
UPDATE SLC_BATCHES
SET record_count = n_number_of_records
WHERE slc_filename  = p_filename
AND slc_file_date = TRUNC(p_filedate);
p_repeat := FALSE;
COMMIT;
SET TRANSACTION USE ROLLBACK SEGMENT RBS1;
RETURN (n_number_of_records);
--
EXCEPTION
    WHEN e_max_filesize_not_found THEN
        ROLLBACK;
        p_repeat := FALSE;
        RETURN -1;
  WHEN e_maxrows_reached THEN
        p_repeat := TRUE;
        RETURN (n_number_of_records);
  WHEN OTHERS THEN
        n_sqlcode := SQLCODE;
        v_sqlerrm := SQLERRM;
        p_error_message := 'The following fatal Error occured IN Pop_M263.POP_M263D '||n_sqlcode||' '||SQLERRM;
        ROLLBACK;
        p_repeat := FALSE;
        RETURN -1;
END;-- FUNCTION POP_M263D
--
PROCEDURE POP_M263_ERROR (p_filename        SLC_ERRORS.SLC_FILENAME%TYPE,
                p_filedate        SLC_ERRORS.SLC_FILE_DATE%TYPE,
                p_filetype        SLC_ERRORS.SLC_FILE_TYPE%TYPE,
                p_stud_crse_year_id SLC_ERRORS.STUD_CRSE_YEAR_ID%TYPE,
                p_stud_ref_no    SLC_ERRORS.STUD_REF_NO%TYPE,
                p_inst_code     SLC_ERRORS.INST_CODE%TYPE,
                p_crse_code     SLC_ERRORS.CRSE_CODE%TYPE,
                p_crse_id        CRSE.CRSE_ID%TYPE,
                p_session_code    SLC_ERRORS.SESSION_CODE%TYPE,
                p_slc_ref_no    SLC_ERRORS.SLC_REF_NO%TYPE,
                p_error_description SLC_ERRORS.ERROR_DESCRIPTION%TYPE,
                p_scheme_type    STUD_CRSE_YEAR.SCHEME_TYPE%TYPE,
                p_dearing        STUD_CRSE_YEAR.DEARING%TYPE,
        p_loan_type in slc_errors.record_type_error%type) IS
--
   CURSOR c1 IS
      SELECT qual_type
      FROM CRSE
      WHERE crse_id = p_crse_id;
--
   n_session_id    NUMBER;
   v_team_name       TEAM.name%TYPE;
   v_qual_type       CRSE.qual_type%TYPE;
--
  BEGIN
     OPEN  c1;
--
-- JM add SCOT F no RUK G pams
--
     FETCH c1 INTO v_qual_type;
     CLOSE c1;
     IF p_scheme_type = 'P' THEN
         v_team_name := 'PSAS';
     ELSIF p_scheme_type = 'B' THEN
         v_team_name := 'SNB';
     ELSIF p_scheme_type = 'S' THEN
         v_team_name := 'SSS';
     ELSIF v_qual_type = 'HEALTH' AND
       (p_dearing IN ('B','C','D', 'F')) THEN
         v_team_name := 'SAS_VII';
     ELSE
          SELECT t.name
            INTO v_team_name
             FROM TEAM t, INST_TEAM it
        WHERE it.inst_code    = p_inst_code
             AND it.session_code    = p_session_code
             AND t.team_id    = it.team_id;
     END IF;
--
   if (p_loan_type = STUD_LOAN) then -- write to pop_m263a log.
      WriteToLog (pop_m263a_debug_file_handle, 'In pop_m263_error for Student loan. p_filetype ' || p_filetype);
      WriteToLog (pop_m263b_debug_file_handle, 'In pop_m263_error for Student loan. p_filetype ' || p_filetype);
   else -- write to pop_m263b log.
      WriteToLog (pop_m263a_debug_file_handle, 'In pop_m263_error for fee loan. p_filetype ' || p_filetype);
      WriteToLog (pop_m263b_debug_file_handle, 'In pop_m263_error for fee loan. p_filetype ' || p_filetype);
    end if;
--
     INSERT INTO SLC_ERRORS (slc_filename, slc_file_date, slc_file_type,
                 stud_crse_year_id, stud_ref_no, inst_code,
                 crse_code, session_code, slc_ref_no,
                 error_description, team_name, record_type_error)
            VALUES (p_filename, p_filedate, p_filetype,
                p_stud_crse_year_id, p_stud_ref_no, p_inst_code,
                p_crse_code, p_session_code, p_slc_ref_no,
                p_error_description, v_team_name, p_loan_type);

--
/*
   if ((p_filetype = 1) and (p_loan_type = FEE_LOAN)) then
--    update the students file 1 status to be in error so as not to be picked
--    on the next select of fee loan txns by pop_m263a.
--    Note: these records are updated in the run_m263 shell script to reset all
--    ss.slc1_fl_sent flags set to E to be N at the end of processing.
      update stud_session
      set slc1_fl_sent = 'E'
      where stud_ref_no = p_stud_ref_no
      and session_code = p_session_code;

--
   elsif ((p_filetype = 1) and (p_loan_type = STUD_LOAN)) then
      UPDATE STUD_CRSE_YEAR
       SET slc1_status = 'E'
      WHERE stud_crse_year_id = p_stud_crse_year_id;

--
   elsif (p_filetype = 2) and (p_loan_type = FEE_LOAN) then
      -- update flt.status for failed flts that have not been sent of corrected.
      update fee_loan_transaction
      set status = 'E',
      status_changed_date = sysdate
      where stud_ref_no = p_stud_ref_no
      and session_code = p_session_code
      and nvl(status, 'Z') in ('Z', 'C');
--
   elsif (p_filetype = 2) and (p_loan_type = STUD_LOAN) then
      UPDATE STUD_CRSE_YEAR
       SET slc2_status = 'E'
      WHERE stud_crse_year_id = p_stud_crse_year_id;

--
   els
*/
   if p_filetype = 3 THEN
      UPDATE STUD_CRSE_YEAR
       SET slc2_status = 'E'
      WHERE stud_crse_year_id = p_stud_crse_year_id;
--
   END IF;
--
   WriteToLog (pop_m263a_debug_file_handle, 'Error: ' || p_error_description);
   WriteToLog (pop_m263b_debug_file_handle, 'Error: ' || p_error_description);
--
END POP_M263_ERROR;
--
  FUNCTION  POP_M263_POSTCODE (p_in_postcode    IN  VARCHAR2,
                   p_out_postcode  OUT VARCHAR2) RETURN BOOLEAN IS
     -- Validate that postcode is valid and return a formatted version to the calling module.
     -- Return true if the
     v_postcode      VARCHAR2(8);
     e_postcode_valid     EXCEPTION;
  BEGIN
     -- Valid formats are :-
     --      'AN NAA'
     --      'ANN NAA'
     --      'AAN NAA'
     --      'AANN NAA'
     --      'ANA NAA'
     --      'AANA NAA'
     --      'BFPO NNN'
     v_postcode := UPPER(p_in_postcode);
     -- validate format 1 'AN NAA'
     IF LENGTH(RTRIM(v_postcode,' ')) = 6 THEN
    -- the length of postcode format 1 must be 6
    IF ASCII(SUBSTR(v_postcode,1,1)) BETWEEN 65 AND 90 THEN
       -- 1st character must be alpha.
       IF ASCII(SUBSTR(v_postcode,2,1)) BETWEEN 48 AND 57 THEN
          -- 2nd character must be numeric.
          IF SUBSTR(v_postcode,3,1) = ' ' THEN
         -- 3rd character must be a space.
         IF ASCII(SUBSTR(v_postcode,4,1)) BETWEEN 48 AND 57 THEN
            -- 4th character must be a numeric.
            IF ASCII(SUBSTR(v_postcode,5,1)) BETWEEN 65 AND 90 THEN
               -- 5th character must be alpha.
               IF ASCII(SUBSTR(v_postcode,6,1)) BETWEEN 65 AND 90 THEN
              -- 6th character must be alpha.
              -- if the code reaches here then the postcode is valid for format 1
              RAISE e_postcode_valid;
               END IF;
            END IF;
         END IF;
          END IF;
       END IF;
    END IF;
     END IF;
     -- validate format 2 'ANN NAA'
     IF LENGTH(RTRIM(v_postcode,' ')) = 7 THEN
    -- the length of postcode format 2 must be 7
    IF ASCII(SUBSTR(v_postcode,1,1)) BETWEEN 65 AND 90 THEN
       -- 1st character must be alpha.
       IF ASCII(SUBSTR(v_postcode,2,1)) BETWEEN 48 AND 57 THEN
          -- 2nd character must be numeric.
          IF ASCII(SUBSTR(v_postcode,3,1)) BETWEEN 48 AND 57 THEN
         -- 3rd character must be numeric.
         IF SUBSTR(v_postcode,4,1) = ' ' THEN
            -- 4th character must be a space.
            IF ASCII(SUBSTR(v_postcode,5,1)) BETWEEN 48 AND 57 THEN
               -- 5th character must be numeric.
               IF ASCII(SUBSTR(v_postcode,6,1)) BETWEEN 65 AND 90 THEN
              -- 6th character must be alpha.
              IF ASCII(SUBSTR(v_postcode,7,1)) BETWEEN 65 AND 90 THEN
                 -- 7th character must be alpha.
                 -- if the code reaches here then the postcode is valid for format 2
                 RAISE e_postcode_valid;
              END IF;
               END IF;
            END IF;
         END IF;
          END IF;
       END IF;
    END IF;
     END IF;
     -- validate format 3 'AAN NAA'
     IF LENGTH(RTRIM(v_postcode,' ')) = 7 THEN
    -- the length of postcode format 3 must be 7
    IF ASCII(SUBSTR(v_postcode,1,1)) BETWEEN 65 AND 90 THEN
       -- 1st character must be alpha.
       IF ASCII(SUBSTR(v_postcode,2,1)) BETWEEN 65 AND 90 THEN
          -- 2nd character must be alpha.
          IF ASCII(SUBSTR(v_postcode,3,1)) BETWEEN 48 AND 57 THEN
         -- 3rd character must be numeric.
         IF SUBSTR(v_postcode,4,1) = ' ' THEN
            -- 4th character must be a space.
            IF ASCII(SUBSTR(v_postcode,5,1)) BETWEEN 48 AND 57 THEN
               -- 5th character must be numeric.
               IF ASCII(SUBSTR(v_postcode,6,1)) BETWEEN 65 AND 90 THEN
              -- 6th character must be alpha.
              IF ASCII(SUBSTR(v_postcode,7,1)) BETWEEN 65 AND 90 THEN
                 -- 7th character must be alpha.
                 -- if the code reaches here then the postcode is valid for format 3
                 RAISE e_postcode_valid;
              END IF;
               END IF;
            END IF;
         END IF;
          END IF;
       END IF;
    END IF;
     END IF;
     -- validate format 4 'AANN NAA'
     IF LENGTH(RTRIM(v_postcode,' ')) = 8 THEN
    -- the length of postcode format 4 must be 8
    IF ASCII(SUBSTR(v_postcode,1,1)) BETWEEN 65 AND 90 THEN
       -- 1st character must be alpha.
       IF ASCII(SUBSTR(v_postcode,2,1)) BETWEEN 65 AND 90 THEN
          -- 2nd character must be alpha.
          IF ASCII(SUBSTR(v_postcode,3,1)) BETWEEN 48 AND 57 THEN
         -- 3rd character must be numeric.
         IF ASCII(SUBSTR(v_postcode,4,1)) BETWEEN 48 AND 57 THEN
            -- 4th character must be numeric.
            IF SUBSTR(v_postcode,5,1) = ' ' THEN
               -- 5th character must be a space.
               IF ASCII(SUBSTR(v_postcode,6,1)) BETWEEN 48 AND 57 THEN
              -- 6th character must be numeric.
              IF ASCII(SUBSTR(v_postcode,7,1)) BETWEEN 65 AND 90 THEN
                 -- 7th character must be alpha.
                 IF ASCII(SUBSTR(v_postcode,8,1)) BETWEEN 65 AND 90 THEN
                -- 8th character must be alpha.
                -- if the code reaches here then the postcode is valid for format 4
                RAISE e_postcode_valid;
                 END IF;
              END IF;
               END IF;
            END IF;
         END IF;
          END IF;
       END IF;
    END IF;
     END IF;
     -- validate format 5 'ANA NAA'
     IF LENGTH(RTRIM(v_postcode,' ')) = 7 THEN
    -- the length of postcode format 5 must be 7
    IF ASCII(SUBSTR(v_postcode,1,1)) BETWEEN 65 AND 90 THEN
       -- 1st character must be alpha.
       IF ASCII(SUBSTR(v_postcode,2,1)) BETWEEN 48 AND 57 THEN
          -- 2nd character must be numeric.
          IF ASCII(SUBSTR(v_postcode,3,1)) BETWEEN 65 AND 90 THEN
         -- 3rd character must be alpha.
         IF SUBSTR(v_postcode,4,1) = ' ' THEN
            -- 4th character must be a space.
            IF ASCII(SUBSTR(v_postcode,5,1)) BETWEEN 48 AND 57 THEN
               -- 5th character must be numeric.
               IF ASCII(SUBSTR(v_postcode,6,1)) BETWEEN 65 AND 90 THEN
              -- 6th character must be alpha.
              IF ASCII(SUBSTR(v_postcode,7,1)) BETWEEN 65 AND 90 THEN
                 -- 7th character must be alpha.
                 -- if the code reaches here then the postcode is valid for format 5
                 RAISE e_postcode_valid;
              END IF;
               END IF;
            END IF;
         END IF;
          END IF;
       END IF;
    END IF;
     END IF;
     -- validate format 6 'AANA NAA'
     IF LENGTH(RTRIM(v_postcode,' ')) = 8 THEN
    -- the length of postcode format 6 must be 8
    IF ASCII(SUBSTR(v_postcode,1,1)) BETWEEN 65 AND 90 THEN
       -- 1st character must be alpha.
       IF ASCII(SUBSTR(v_postcode,2,1)) BETWEEN 65 AND 90 THEN
          -- 2nd character must be alpha.
          IF ASCII(SUBSTR(v_postcode,3,1)) BETWEEN 48 AND 57 THEN
         -- 3rd character must be numeric.
         IF ASCII(SUBSTR(v_postcode,4,1)) BETWEEN 65 AND 90 THEN
            -- 4th character must be alpha.
            IF SUBSTR(v_postcode,5,1) = ' ' THEN
               -- 5th character must be a space.
               IF ASCII(SUBSTR(v_postcode,6,1)) BETWEEN 48 AND 57 THEN
              -- 6th character must be numeric.
              IF ASCII(SUBSTR(v_postcode,7,1)) BETWEEN 65 AND 90 THEN
                 -- 7th character must be alpha.
                 IF ASCII(SUBSTR(v_postcode,8,1)) BETWEEN 65 AND 90 THEN
                -- 8th character must be alpha.
                -- if the code reaches here then the postcode is valid for format 6
                RAISE e_postcode_valid;
                 END IF;
              END IF;
               END IF;
            END IF;
         END IF;
          END IF;
       END IF;
    END IF;
     END IF;
     -- validate format 7 'BFPO NNN'
     IF LENGTH(RTRIM(v_postcode,' ')) = 8 THEN
    -- the length of postcode format 7 must be 8
    IF SUBSTR(v_postcode,1,4) = 'BFPO' THEN
       -- the first 4 characters of postcode format 7 must = 'BFPO'
       IF SUBSTR(v_postcode,5,1) = ' ' THEN
          -- 5th character must be a space.
          IF ASCII(SUBSTR(v_postcode,6,1)) BETWEEN 48 AND 57 THEN
         -- 6th character must be numeric.
         IF ASCII(SUBSTR(v_postcode,7,1)) BETWEEN 48 AND 57 THEN
            -- 7th character must be numeric.
            IF ASCII(SUBSTR(v_postcode,8,1)) BETWEEN 48 AND 57 THEN
               -- 8th character must be numeric.
               -- if the code reaches here then the postcode is valid for format 7
               RAISE e_postcode_valid;
            END IF;
         END IF;
          END IF;
       END IF;
    END IF;
     END IF;
     -- If the code reaches here then the postcode format is invalid
     p_out_postcode := NULL;
     RETURN(FALSE);
  EXCEPTION
     WHEN e_postcode_valid THEN
    p_out_postcode := RPAD(p_in_postcode,8,' ');
    RETURN (TRUE);
  END POP_M263_POSTCODE;
END;
/
