CREATE OR REPLACE PACKAGE SGAS.EDM_INDEX
IS
--
ILA500_LAPP	   		CONSTANT EDM_BATCH_WF.batch_type_code%TYPE := 70;  -- JM RFC 233
ILA500_LCOR	   		CONSTANT EDM_BATCH_WF.batch_type_code%TYPE := 71;  -- JM RFC 233
ILA500_PCOR	   		CONSTANT EDM_BATCH_WF.batch_type_code%TYPE := 72;  -- JM RFC 233

FUNCTION AddEDMDocumentIndex
(
  p_object_id		  IN	EDM_TEMP.object_id%TYPE,
  p_session_code	  IN	EDM_TEMP.session_code%TYPE,
  p_document_type_code	  IN	EDM_TEMP.document_type_code%TYPE,
  p_document_name	  IN	EDM_TEMP.document_name%TYPE,
  p_document_type_count   IN	EDM_TEMP.document_type_count%TYPE,
  p_attachment_type_code  IN	EDM_TEMP.attachment_type_code%TYPE,
  p_rescan_request_id	  IN	EDM_TEMP.rescan_request_id%TYPE
) RETURN INTEGER;

FUNCTION EDMIndexComplete
(
  p_object_id		IN    VARCHAR2,
  p_raw_data_id 	IN    NUMBER,
  p_batch_type_code	IN    NUMBER,
  p_stud_ref_no 	IN    varchar2,  -- JM RFC 233
  p_batch_id		IN    NUMBER,
  p_envelope_id 	IN    NUMBER,
  p_scan_date		IN	  DATE,
  p_urgent			in    vaRCHAR2
) RETURN INTEGER;

FUNCTION EDMCheckIndexComplete
(
  p_object_id		IN    EDM_COMPLETE.object_id%TYPE
) RETURN INTEGER;
--
EDM_SUCCESS CONSTANT INTEGER := 0;
EDM_FAILURE CONSTANT INTEGER := 1;
--
end;
/

