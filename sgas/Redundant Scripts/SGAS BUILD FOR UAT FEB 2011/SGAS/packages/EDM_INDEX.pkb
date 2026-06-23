CREATE OR REPLACE PACKAGE BODY SGAS.EDM_INDEX
IS
--
--
FUNCTION AddEDMDocumentIndex
(
  p_object_id		  IN		EDM_TEMP.object_id%TYPE,
  p_session_code	  IN		EDM_TEMP.session_code%TYPE,
  p_document_type_code	  IN	EDM_TEMP.document_type_code%TYPE,
  p_document_name	  IN		EDM_TEMP.document_name%TYPE,
  p_document_type_count   IN	EDM_TEMP.document_type_count%TYPE,
  p_attachment_type_code  IN	EDM_TEMP.attachment_type_code%TYPE,
  p_rescan_request_id	  IN	EDM_TEMP.rescan_request_id%TYPE
) RETURN INTEGER IS
--
    ret_val INTEGER;
    func_ret_val BOOLEAN;
    s_ora_err VARCHAR2(512);
	v_session_code edm_temp.session_code%TYPE;
	v_century edm_temp.session_code%TYPE;
	s_session_code VARCHAR2(4);
--
BEGIN
--
ret_val := Edm_index.EDM_SUCCESS;
--
  --v_century := SUBSTR(TO_CHAR(SYSDATE, 'yyyy/mm/dd'), 1, 2);
  --s_session_code := TO_CHAR(p_session_code);
  --v_session_code := v_century || SUBSTR(s_session_code, 3, 2);
  --
  -- JM RFC 233 set sessioN-code to null for provider batches
  --

  IF p_session_code < 2001 AND p_document_type_code like '%ILA500%' THEN
    INSERT INTO EDM_TEMP
	(
	object_id,
	session_code,
	document_type_code,
	document_name,
	document_type_count,
	attachment_type_code,
	rescan_request_id
	)
	VALUES
	(
	rtrim(ltrim(p_object_id)),
	null,
	rtrim(ltrim(p_document_type_code)),
	rtrim(ltrim(p_document_name)),
	p_document_type_count,
	rtrim(ltrim(p_attachment_type_code)),
	p_rescan_request_id
	);
ELSE
    INSERT INTO EDM_TEMP
	(
	object_id,
	session_code,
	document_type_code,
	document_name,
	document_type_count,
	attachment_type_code,
	rescan_request_id
	)
	VALUES
	(
	rtrim(ltrim(p_object_id)),
	p_session_code,
	rtrim(ltrim(p_document_type_code)),
	rtrim(ltrim(p_document_name)),
	p_document_type_count,
	rtrim(ltrim(p_attachment_type_code)),
	p_rescan_request_id
	);
    END IF;
--
-- JM end of RFC 233
--
    RETURN ret_val;
--
END;
--
FUNCTION EDMIndexComplete
(
  p_object_id		IN    VARCHAR2,
  p_raw_data_id 	IN    NUMBER,
  p_batch_type_code	IN    NUMBER,
  p_stud_ref_no 	IN    varchar2, -- JM RFC 233
  p_batch_id		IN    NUMBER,
  p_envelope_id 	IN    NUMBER,
  p_scan_date		IN	  DATE,
  p_urgent			in	  varchar2
) RETURN INTEGER
IS
--
    ret_val INTEGER;
    func_ret_val BOOLEAN;
    s_ora_err VARCHAR2(512);
    v_raw_data_reqd edm_batch_wf.raw_data_reqd%TYPE := 'N';
--
    NoRawDataId exception;
--
BEGIN
--
ret_val := Edm_index.edm_success;
--
-- JM RFC 233
--
IF p_batch_type_code in(EDM_INDEX.ILA500_LAPP, EDM_INDEX.ILA500_LCOR) THEN
--
INSERT INTO EDM_COMPLETE
  (
    object_id,
    raw_data_id,
    batch_type_code,
    stud_ref_no,
    batch_id,
    envelope_id,
    scan_date,
    urgent,
    provider_id,
    learner_id
  )
  VALUES
  (
    rtrim(ltrim(p_object_id)),
    p_raw_data_id,
    p_batch_type_code,
    null,
    p_batch_id,
    p_envelope_id,
    p_scan_date,
    p_urgent,
    null,
    p_stud_ref_no -- use stud_ref_no for learner_id
  );
ELSIF p_batch_type_code in(EDM_INDEX.ILA500_PCOR) THEN
--
INSERT INTO EDM_COMPLETE
  (
    object_id,
    raw_data_id,
    batch_type_code,
    stud_ref_no,
    batch_id,
    envelope_id,
    scan_date,
    urgent,
    provider_id,
    learner_id
  )
  VALUES
  (
    rtrim(ltrim(p_object_id)),
    p_raw_data_id,
    p_batch_type_code,
    null,
    p_batch_id,
    p_envelope_id,
    p_scan_date,
    p_urgent,
    to_number(p_stud_ref_no), -- use stud_ref_no for provider_id
    null
  );
ELSE
INSERT INTO EDM_COMPLETE
  (
    object_id,
    raw_data_id,
    batch_type_code,
    stud_ref_no,
    batch_id,
    envelope_id,
    scan_date,
    urgent,
    provider_id,
    learner_id
  )
  VALUES
  (
    rtrim(ltrim(p_object_id)),
    p_raw_data_id,
    p_batch_type_code,
    to_number(p_stud_ref_no),  -- JM RFC 233
    p_batch_id,
    p_envelope_id,
    p_scan_date,
    p_urgent,
    null,
    null
  );
END IF;
--
-- JM end of RFC 233 changes
--

--TR 407 fix
	 SELECT raw_data_reqd
     INTO v_raw_data_reqd
     FROM EDM_BATCH_WF
     WHERE batch_type_code = p_batch_type_code;

--
  IF  v_raw_data_reqd = 'Y' THEN
--
      UPDATE raw_data
      SET object_id = rtrim(ltrim(p_object_id))
      WHERE raw_data_id = p_raw_data_id;
--
   END IF;
--
   RETURN ret_val;
--
  EXCEPTION
  WHEN OTHERS THEN
  NULL;
--
END;
--
FUNCTION EDMCheckIndexComplete
(
  p_object_id		IN    EDM_COMPLETE.object_id%TYPE
) RETURN INTEGER
IS
--
    ret_val INTEGER;
    func_ret_val BOOLEAN;
    s_ora_err VARCHAR2(512);
    numRecs INTEGER;
--
BEGIN
--
 SELECT COUNT(*) INTO numRecs FROM EDM_COMPLETE WHERE object_id = p_object_id;
--
 RETURN numRecs;
--
END;
--
END;
/