CREATE OR REPLACE PACKAGE BODY SGAS.SHORTENED_APPLICATION_WEB_ST
IS
--
FUNCTION get_eistream_record(p_object_id IN EDM_IMAGES.object_id%TYPE, edm_rec IN OUT edm_rec_type)
RETURN BOOLEAN IS
BEGIN
SELECT object_id, batchid, nvl(envelopeid,'1'), to_date(scandate,'yyyy-mm-dd:hh24:mi:ss') INTO edm_rec.rd_object_id, edm_rec.rd_batch_id, edm_rec.rd_envelope_id , edm_rec.ec_scan_date FROM attributes@EDM_REF.world
        WHERE object_id = p_object_id;

RETURN TRUE;
EXCEPTION
        WHEN OTHERS THEN
        edm_rec.error_status := 'E';
        edm_rec.error_mess := 'Student ' || edm_rec.rd_stud_ref_no ||
            ' - An error has occurred retreiving the EISTREAM RECORD. The error is as follows: '||  SQLERRM(SQLCODE);
            dbms_output.put_line(edm_rec.error_mess);

    RETURN FALSE;
END; --get_eistream_record ;
--
FUNCTION insert_edm_recs(edm_rec IN OUT edm_rec_type)
RETURN BOOLEAN IS
      v_attachment_type_code_pdf edm_temp.ATTACHMENT_TYPE_CODE%TYPE := 'PDF';
      v_attachment_type_code_xml edm_temp.ATTACHMENT_TYPE_CODE%TYPE := 'XML';
BEGIN
-- construct the fake records for EDM monitor to pick up
-- if any one of the inserts fail then we want to rollback all three statements and report the error
-- design note : have to commit raw_data due to referential integrity
            insert into raw_data (object_id,
                                         raw_data_id,
                                 batch_id,
                                 envelope_id,
                                 stud_ref_no,
                                 date_applic_received,
                                 app_form_sig_date,
                                 app_form_sig,
                 web_user_id)
                                values(edm_rec.rd_object_id,
                                         edm_rec.rd_raw_data_id,
                                 edm_rec.rd_batch_id,
                                 edm_rec.rd_envelope_id,
                                 edm_rec.rd_stud_ref_no,
                                 edm_rec.rd_date_applic_received,
                                 edm_rec.rd_app_form_sig_date,
                                 edm_rec.rd_app_form_sig,
                 edm_rec.rd_web_user_id);
            commit;

            insert into edm_temp (object_id,
                                         session_code,
                                 document_type_code,
                                 document_name,
                                 document_type_count,
                                 attachment_type_code)
                                values(edm_rec.rd_object_id,
                                         edm_rec.et_session_code,
                                 edm_rec.et_document_type_code,
                                 edm_rec.et_document_name,
                                 edm_rec.et_document_type_count,
                                 v_attachment_type_code_pdf);
            insert into edm_temp (object_id,
                                         session_code,
                                 document_type_code,
                                 document_name,
                                 document_type_count,
                                 attachment_type_code)
                         values (edm_rec.rd_object_id,
                                         edm_rec.et_session_code,
                                 v_attachment_type_code_xml,
                                 v_attachment_type_code_xml,
                                 edm_rec.et_document_type_count,
                                 v_attachment_type_code_xml);

       insert into edm_complete (object_id,
                                         raw_data_id,
                                 batch_type_code,
                                 stud_ref_no,
                                 batch_id,
                                 envelope_id,
                                 scan_date,
                                 proc_error,
                                 urgent)
                                values(edm_rec.rd_object_id,
                                         edm_rec.rd_raw_data_id,
                                 edm_rec.ec_batch_type_code,
                                 edm_rec.rd_stud_ref_no,
                                 edm_rec.rd_batch_id,
                                 edm_rec.rd_envelope_id,
                                 edm_rec.ec_scan_date,
                                 edm_rec.ec_proc_error,
                                 edm_rec.ec_urgent);


            commit;
RETURN TRUE;
EXCEPTION
        WHEN OTHERS THEN
             rollback;

             delete from raw_data
               WHERE object_id = edm_rec.rd_object_id
                    and stud_ref_no = edm_rec.rd_stud_ref_no;
             commit;
        edm_rec.error_status := 'E';
        edm_rec.error_mess := 'Student ' || edm_rec.rd_stud_ref_no ||
            ' - An error has occurred inserting the EDM record. The error is as follows: '||  SQLERRM(SQLCODE);
            dbms_output.put_line(edm_rec.error_mess);
    RETURN FALSE;
END; -- insert_edm_recs ;
--
function insert_shwap_error(edm_rec IN edm_rec_type)
return boolean IS
v_error_mess varchar2(1024) := null ;
BEGIN
       update completed_shwap
                 set status = edm_rec.error_status,
                     error_message = edm_rec.error_mess
                   where stud_ref_no = edm_rec.rd_stud_ref_no ;

        commit;

RETURN true;
EXCEPTION
        WHEN OTHERS THEN
         rollback;
         v_error_mess :=  edm_rec.error_mess + 'A further error has occurred updating the completed SHWAP record. The error is as follows: '||    SQLERRM(SQLCODE);
            dbms_output.put_line(v_error_mess);
    RETURN false;
END; -- insert_shwap_error;
--
FUNCTION get_raw_data_id(edm_rec IN OUT edm_rec_type)
RETURN BOOLEAN IS
v_error_mess VARCHAR2(1024);
BEGIN
--      'retrieving the next RAW_DATA_ID_SEQ sequence value';
 SELECT RAW_DATA_ID_SEQ.NEXTVAL
   INTO edm_rec.rd_raw_data_id
   FROM DUAL;
-- insufficient priviledges
   commit;
RETURN TRUE;
EXCEPTION
        WHEN OTHERS THEN
        edm_rec.error_status := 'E';
        edm_rec.error_mess := 'Student ' || edm_rec.rd_stud_ref_no ||
            ' - An error has occurred retreiving the RAW_DATA_ID sequence. The error is as follows: '||  SQLERRM(SQLCODE);
            dbms_output.put_line(edm_rec.error_mess);
         rollback;
    RETURN FALSE;
END; -- get_raw_data_id;
--
PROCEDURE init_shwap_records(edm_rec IN OUT edm_rec_type)
is
begin
  edm_rec.rd_object_id := NULL;
  edm_rec.rd_raw_data_id := NULL;
  edm_rec.rd_batch_id := NULL;
  edm_rec.rd_envelope_id := NULL;
  edm_rec.rd_stud_ref_no := NULL;
  edm_rec.rd_date_applic_received := NULL;
  edm_rec.rd_app_form_sig_date := NULL;
  edm_rec.rd_web_user_id := NULL; -- RFC 248 JM
  edm_rec.et_session_code := NULL;
  edm_rec.error_mess := null;
  edm_rec.error_status := null;
--  edm_rec.et_document_type_code := NULL;
  edm_rec.et_document_name := NULL ;
--  edm_rec.et_document_type_count := NULL;
  edm_rec.et_attachment_type_code := NULL;
--  edm_rec.ec_batch_type_code := NULL;
  edm_rec.ec_scan_date := sysdate;
--  edm_rec.ec_proc_error := NULL;
--  edm_rec.ec_urgent := NULL;
--shwap values currently fixed
    edm_rec.et_document_type_code := 'SHORT_APP';
    edm_rec.et_document_type_count := 1 ;
    edm_rec.ec_batch_type_code := '54';
    edm_rec.ec_proc_error := 'N';
    edm_rec.ec_urgent := 'N' ;
    edm_rec.rd_app_form_sig := 'Y';
--
RETURN;
--
EXCEPTION
    WHEN OTHERS THEN
        RETURN;
END; -- Init_shwap_records
--
function  delete_from_completed_shwap(edm_rec IN OUT edm_rec_type)
return boolean IS
BEGIN
    -- Delete the record from the completed_shwap table
    DELETE FROM COMPLETED_shwap
    WHERE  stud_ref_no = edm_rec.rd_stud_ref_no;
    commit;
    RETURN true;
EXCEPTION
        WHEN OTHERS THEN
        edm_rec.error_status := 'E';
        edm_rec.error_mess := 'Student ' || edm_rec.rd_stud_ref_no ||
            ' - An error has occurred deleting the completed_shwap record The error is as follows: '||    SQLERRM(SQLCODE);
              dbms_output.put_line(edm_rec.error_mess);
        rollback;
    RETURN false;

END delete_from_completed_shwap ;
--
FUNCTION get_shwap(p_object_id IN EDM_IMAGES.object_id%TYPE,
                     p_stud_ref_no IN STUD.stud_ref_no%TYPE,
                    p_web_submitted in EDM_IMAGES.upload_date%type,
                    p_session_code in EDM_IMAGES.session_code%type,
            p_web_user_id IN COMPLETED_SHWAP.web_user_id%TYPE) -- JM RFC 248
RETURN varchar2 IS
    m_edm_rec edm_rec_type;
    v_error_mess VARCHAR2(1024);
    v_process BOOLEAN := TRUE;
    v_date VARCHAR2(10);
BEGIN
-- add passed parameters to edm_rec
SELECT TO_CHAR(SYSDATE,'ddmmyyyy')INTO v_date FROM dual;
--  null recs
    init_shwap_records(m_edm_rec);
    m_edm_rec.rd_stud_ref_no := p_stud_ref_no ;
    m_edm_rec.et_session_code := p_session_code ;
    m_edm_rec.rd_app_form_sig_date := TO_CHAR(p_web_submitted,'ddmmyyyy');
    m_edm_rec.rd_web_user_id := p_web_user_id;    -- JM RFC 248
    --create document name
    m_edm_rec.et_document_name := 'S'||p_stud_ref_no||'_'||to_char(p_session_code)||':1' ;

    v_process := TRUE;
--
   IF v_process = TRUE THEN
--   Get details from eistream
      IF NOT get_eistream_record (p_object_id, m_edm_rec) THEN
           v_process := FALSE;
      END IF;
   END IF;
--
    IF v_process = TRUE THEN
--   Get raw_data_id
      IF NOT get_raw_data_id (m_edm_rec) THEN
           v_process := FALSE;
      END IF;
   END IF;
--
--
   IF v_process = TRUE THEN
--   Get insert edm recoords
      IF NOT insert_edm_recs (m_edm_rec) THEN
           v_process := FALSE;
      END IF;
   END IF;
--
--
   IF v_process = TRUE THEN
--   Delete the record from the completed_shwap table
     IF NOT delete_from_completed_shwap(m_edm_rec) THEN
       v_process := FALSE;
     END IF;
   END IF;
--
     IF v_process = TRUE THEN
       RETURN 'OK';
    end if;
--
   IF v_process = FALSE THEN
--   write the failure back to completed_shwap note: both return fail to control script
      IF NOT insert_shwap_error(m_edm_rec) then
          RETURN 'FAIL';
      END IF;
      RETURN 'FAIL';
   END IF;
--
END; -- get_shwap;
--

function shwap_loop
return varchar2 is
v_return        VARCHAR2(20);
v_count         NUMBER := 0;
v_stud_ref_no     stud.stud_ref_no%type := null;
--Get transferred records
-- JM RFc 248 add web_user_id
--
CURSOR    fetch_rec IS
SELECT    stud_ref_no, session_code, object_id, web_submitted_date,web_user_id
FROM    Completed_shwap
WHERE    status is null
AND    object_id IS NOT NULL;
--
--
BEGIN
for rec in fetch_rec
loop

IF rec.stud_ref_no is not null AND rec.object_id IS NOT NULL THEN
   v_stud_ref_no := rec.stud_ref_no ;
--
   v_return := get_shwap(rec.object_id, rec.stud_ref_no, rec.web_submitted_date, rec.session_code, rec.web_user_id);
    -- Send status of record to output
    IF v_return = 'FAIL' THEN
    DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE(to_char(rec.stud_ref_no) || ' FAIL');
    ELSIF v_return =  'OK' THEN
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE(to_char(rec.stud_ref_no) || ' OK');
    END IF;
    --
    --TR822 count fix 15/05/2006
    v_count := v_count +1;
    COMMIT;
END IF;
END LOOP;
--
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT_LINE(' SHWAP Processing Completed Successfully');
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT_LINE(v_count || ' records processed');
RETURN v_return;
--
EXCEPTION
    WHEN OTHERS THEN
            DBMS_OUTPUT.NEW_LINE;
            DBMS_OUTPUT.PUT_LINE('Fatal Error in SHWAP_LOOP while processing student ' || to_char(v_stud_ref_no));
            DBMS_OUTPUT.NEW_LINE;
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(sqlcode));
            ROLLBACK;
        RETURN v_return;
end; -- shwap loop
--
function update_edm_images_loop
return varchar2 is
v_count         NUMBER := 0;
v_stud_ref_no     stud.stud_ref_no%type := null;
--Get transferred records
CURSOR    fetch_rec IS
        SELECT    stud_ref_no, object_id
            FROM sgas.edm_images
                where substr(to_char(batch_id),9,2) = '98'
                    and attachment_type_code = 'PDF'
                        and document_type_code = 'SHORT_APP';

--
BEGIN
for rec in fetch_rec
loop

IF rec.stud_ref_no is not null and rec.object_id is not null THEN
 v_stud_ref_no := rec.stud_ref_no ;

               update sgas.edm_images
               set document_type_code = 'WEB_SHORT_APP'
                  where object_id = rec.object_id
                       and attachment_type_code = 'PDF';
--
--TR822 count fix 15/05/2006
    v_count := v_count +1;
    COMMIT;
END IF;
END LOOP;
--
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT_LINE(' EDM_IMAGES Updated Successfully');
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT_LINE(v_count || ' records processed');
RETURN 'OK';
--
EXCEPTION
    WHEN OTHERS THEN
            DBMS_OUTPUT.NEW_LINE;
            DBMS_OUTPUT.PUT_LINE('Fatal Error in UPDATE_EDM_IMAGES_LOOP while processing student ' || to_char(v_stud_ref_no));
            DBMS_OUTPUT.NEW_LINE;
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(sqlcode));
            ROLLBACK;
            RETURN 'FAIL';
end; -- update_edm_images_loop
--
END; -- SHORTENED_APPLICATION_WEB Package
/
