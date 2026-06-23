-- ILA500_EDM_IMAGES.sql
-- Description: Table holding all EDM IMAGE data for learners who have applied for ILA500
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      29.07.08    R Hunter (SAAS)         Initial Version.
-- 1.1      06.04.09    A Anchev (Ext)          Removed the NOT NULL constraint on SESSION_YEAR column as per error # 396 
-- 1.2      19.10.09    A.Bowman (SAAS)         Added triggers
-- 1.3      15.02.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_EDM_IMAGES.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

DROP TABLE ILA500_EDM_IMAGES CASCADE CONSTRAINTS PURGE
/

--
-- ILA500_EDM_IMAGES  (Table) 
--
CREATE TABLE ILA500_EDM_IMAGES
(
  LEARNER_ID            VARCHAR2(10 BYTE)        NOT NULL,
  SCAN_DATE             DATE                     NOT NULL,
  SESSION_YEAR          VARCHAR2(4 BYTE),
  BATCH_ID              NUMBER(16),
  BATCH_TYPE_CODE       NUMBER(2),
  OBJECT_ID             VARCHAR2(44 BYTE)       NOT NULL,
  DOCUMENT_TYPE_CODE    VARCHAR2(16 BYTE)       NOT NULL,
  DOCUMENT_NAME         VARCHAR2(40 BYTE)       NOT NULL,
  DOCUMENT_TYPE_COUNT   NUMBER(3)               NOT NULL,
  ATTACHMENT_TYPE_CODE  VARCHAR2(10 BYTE),
  ENVELOPE_ID           NUMBER(4),
  RESCAN                VARCHAR2(1 BYTE)        DEFAULT 'N',
  RESCAN_REQ            VARCHAR2(1 BYTE)        DEFAULT 'N',
  REQ_ORIGINAL          VARCHAR2(1 BYTE)        DEFAULT 'N',
  RESCAN_REQUEST_ID     NUMBER(10),
  ANNOT                 VARCHAR2(1 BYTE)        DEFAULT 'N',
  RAW_DATA_ID           NUMBER(10),
  VIEWED_DOC            VARCHAR2(1 BYTE)        DEFAULT 'N',
  UPLOAD_DATE           DATE,
  LAST_UPDATED_BY  VARCHAR2(15 BYTE)            DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON  DATE                         DEFAULT SYSDATE               NOT NULL

)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/


--
-- ILA500_EDM_IMAGES_UK01  (Index) 
--
CREATE UNIQUE INDEX ILA500_EDM_IMAGES_UK01 ON ILA500_EDM_IMAGES
(RESCAN_REQUEST_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          504K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- ILA500_EDM_IMAGES_IDX01  (Index) 
--
CREATE INDEX ILA500_EDM_IMAGES_IDX01 ON ILA500_EDM_IMAGES
(LEARNER_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          504K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


-- 
-- Non Foreign Key Constraints for Table ILA500_EDM_IMAGES 
-- 
ALTER TABLE ILA500_EDM_IMAGES ADD (
  CONSTRAINT ILA500_EDM_IMAGES_CC01
 CHECK (rescan in ('Y', 'N', null)))
/

ALTER TABLE ILA500_EDM_IMAGES ADD (
  CONSTRAINT ILA500_EDM_IMAGES_CC02
 CHECK (rescan_req in ('Y', 'N', null)))
/

ALTER TABLE ILA500_EDM_IMAGES ADD (
  CONSTRAINT ILA500_EDM_IMAGES_CC03
 CHECK (req_original in ('Y', 'N', null)))
/

ALTER TABLE ILA500_EDM_IMAGES ADD (
  CONSTRAINT ILA500_EDM_IMAGES_CC04
 CHECK (annot in ('Y', 'N', null)))
/

ALTER TABLE ILA500_EDM_IMAGES ADD (
  CONSTRAINT ILA500_EDM_IMAGES_CC05
 CHECK (viewed_doc in ('Y', 'N', null)))
/

ALTER TABLE ILA500_EDM_IMAGES ADD (
  CONSTRAINT ILA500_EDM_IMAGES_UK01
 UNIQUE (RESCAN_REQUEST_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          504K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))
/




GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  ILA500_EDM_IMAGES TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM ILA500_EDM_IMAGES
/

CREATE PUBLIC SYNONYM ILA500_EDM_IMAGES FOR ILA500.ILA500_EDM_IMAGES
/

/* Formatted on 2008/07/29 14:12 (Formatter Plus v4.8.8) */
-- TRIGGER: EDM_IMAGES_IUD
-- TABLE: ILA500_EDM_IMAGES
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      29.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_EDM_IMAGES.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
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
                                       upload_date,
                                       last_updated_by
   ON ila500.ila500_edm_images
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   ila500_edm_images_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_edm_images_aud.primary_key%TYPE  := :OLD.learner_id;
   p_old           ila500_edm_images_aud.OLD%TYPE           := NULL;
   p_new           ila500_edm_images_aud.NEW%TYPE           := NULL;
   p_action        ila500_edm_images_aud.action%TYPE        := NULL;
   p_username      ila500_edm_images_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
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
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END edm_images_iud;

SHOW ERRORS;

/* Formatted on 2008/07/29 14:17 (Formatter Plus v4.8.8) */
-- TRIGGER: EDM_IMAGES_LUB
-- TABLE: ILA500_EDM_IMAGES
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      29.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_EDM_IMAGES.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.edm_images_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
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
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.learner_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END edm_images_lub;
/
SHOW ERRORS;*/