CREATE OR REPLACE PACKAGE SGAS.SHORTENED_APPLICATION_WEB_ST
  IS
--
TYPE edm_rec_type IS RECORD
( rd_object_id raw_data.OBJECT_ID%TYPE,
  rd_raw_data_id raw_data.RAW_DATA_ID%TYPE,
  rd_batch_id raw_data.BATCH_ID%TYPE,
  rd_envelope_id raw_data.ENVELOPE_ID%TYPE,
  rd_stud_ref_no raw_data.STUD_REF_NO%TYPE,
  rd_date_applic_received raw_data.DATE_APPLIC_RECEIVED%TYPE,
  rd_app_form_sig_date raw_data.APP_FORM_SIG_DATE%TYPE,
  rd_app_form_sig raw_data.APP_FORM_SIG%TYPE,
  rd_web_user_id raw_data.web_user_id%TYPE, -- RFC 248 JM
  et_session_code edm_temp.SESSION_CODE%TYPE,
  et_document_type_code edm_temp.DOCUMENT_TYPE_CODE%TYPE,
  et_document_name edm_temp.DOCUMENT_NAME%TYPE,
  et_document_type_count edm_temp.DOCUMENT_TYPE_COUNT%TYPE,
  et_attachment_type_code edm_temp.ATTACHMENT_TYPE_CODE%TYPE,
  ec_batch_type_code edm_complete.BATCH_TYPE_CODE%TYPE,
  ec_scan_date edm_complete.SCAN_DATE%TYPE,
  ec_proc_error edm_complete.PROC_ERROR%TYPE,
  ec_urgent edm_complete.URGENT%TYPE,
  error_mess varchar2(1024),
  error_status varchar2(1));
--
g_file_handle    utl_file.file_type;
g_filename  VARCHAR2(200);
g_file_dirname VARCHAR2(200);
g_file_path VARCHAR2(200);
---
g_file_handle2    utl_file.file_type;
g_filename2  VARCHAR2(200);
g_file_dirname2 VARCHAR2(200);
g_file_path2 VARCHAR2(200);

--
g_bad_handle   utl_file.file_type;
g_bad_filename    VARCHAR2(200);
g_bad_path VARCHAR2(200);
--
g_pad_char CONSTANT  VARCHAR2(1) := NULL;
g_first_contact CONSTANT NUMBER(1) := 1;
g_second_contact CONSTANT NUMBER(1) := 2;
g_error BOOLEAN;

FUNCTION get_eistream_record(p_object_id IN EDM_IMAGES.object_id%TYPE, edm_rec IN OUT edm_rec_type) RETURN BOOLEAN ;
--
FUNCTION insert_edm_recs(edm_rec IN OUT edm_rec_type) RETURN BOOLEAN ;
--
function insert_shwap_error(edm_rec IN edm_rec_type) return boolean;
--
function delete_from_completed_shwap(edm_rec IN OUT edm_rec_type) return boolean ;
--
FUNCTION get_shwap(p_object_id IN EDM_IMAGES.object_id%TYPE,
                     p_stud_ref_no IN STUD.stud_ref_no%TYPE,
                    p_web_submitted in EDM_IMAGES.upload_date%type,
                    p_session_code in EDM_IMAGES.session_code%type,
            p_web_user_id IN COMPLETED_SHWAP.web_user_id%TYPE) RETURN varchar2 ;
--
FUNCTION get_raw_data_id(edm_rec IN OUT edm_rec_type) RETURN BOOLEAN ;
--
PROCEDURE init_shwap_records(edm_rec IN OUT edm_rec_type);
--
FUNCTION shwap_loop RETURN VARCHAR2 ;
--
function update_edm_images_loop return varchar2;
--
END; -- SHORTENED_APPLICATION_WEB Package spec
/
