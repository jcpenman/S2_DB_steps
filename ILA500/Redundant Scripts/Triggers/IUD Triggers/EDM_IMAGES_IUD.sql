/* Formatted on 2008/07/29 14:12 (Formatter Plus v4.8.8) */
-- TRIGGER: EDM_IMAGES_IUD
-- TABLE: ILA500_EDM_IMAGES
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      29.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/EDM_IMAGES_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.edm_images_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_id,
                                       scan_date,
                                       session_year,
                                       batch_id,
                                       batch_type_code,
                                       object_id,
                                       document_type_code,
                                       document_name,
                                       document_type_count,
                                       attachment_type_code,
                                       envelope_id,
                                       rescan,
                                       rescan_req,
                                       req_original,
                                       rescan_request_id,
                                       annot,
                                       raw_data_id,
                                       viewed_doc,
                                       upload_date
   ON ila500.ila500_edm_images
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   ila500_edm_images_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_edm_images_aud.primary_key%TYPE  := :OLD.learner_id;
   p_old           ila500_edm_images_aud.OLD%TYPE           := NULL;
   p_new           ila500_edm_images_aud.NEW%TYPE           := NULL;
   p_action        ila500_edm_images_aud.action%TYPE        := NULL;
   p_username      ila500_edm_images_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_ID';
   p_old := :OLD.learner_id;
   p_new := :NEW.learner_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'SCAN_DATE';
   p_old := :OLD.scan_date;
   p_new := :NEW.scan_date;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'SESSION_YEAR';
   p_old := :OLD.session_year;
   p_new := :NEW.session_year;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'BATCH_ID';
   p_old := :OLD.batch_id;
   p_new := :NEW.batch_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'BATCH_TYPE_CODE';
   p_old := :OLD.batch_type_code;
   p_new := :NEW.batch_type_code;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'OBJECT_ID';
   p_old := :OLD.object_id;
   p_new := :NEW.object_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'DOCUMENT_TYPE_CODE';
   p_old := :OLD.document_type_code;
   p_new := :NEW.document_type_code;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'DOCUMENT_NAME';
   p_old := :OLD.document_name;
   p_new := :NEW.document_name;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'DOCUMENT_TYPE_COUNT';
   p_old := :OLD.document_type_count;
   p_new := :NEW.document_type_count;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'ATTACHMENT_TYPE_CODE';
   p_old := :OLD.attachment_type_code;
   p_new := :NEW.attachment_type_code;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'ENVELOPE_ID';
   p_old := :OLD.envelope_id;
   p_new := :NEW.envelope_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESCAN';
   p_old := :OLD.rescan;
   p_new := :NEW.rescan;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESCAN_REQ';
   p_old := :OLD.rescan_req;
   p_new := :NEW.rescan_req;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'REQ_ORIGINAL';
   p_old := :OLD.req_original;
   p_new := :NEW.req_original;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESCAN_REQUEST_ID';
   p_old := :OLD.rescan_request_id;
   p_new := :NEW.rescan_request_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'ANNOT';
   p_old := :OLD.annot;
   p_new := :NEW.annot;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RAW_DATA_ID';
   p_old := :OLD.raw_data_id;
   p_new := :NEW.raw_data_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'VIEWED_DOC';
   p_old := :OLD.viewed_doc;
   p_new := :NEW.viewed_doc;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'UPLOAD_DATE';
   p_old := :OLD.upload_date;
   p_new := :NEW.upload_date;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END edm_images_iud;
/