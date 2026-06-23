/* EDM_IMAGES.sql
 *
 * Generated from SGAS schema in gv36eda.test2 database using TOAD.
 *
 * All objects into USERS tablespace.
 * Init storage now 100K
 *
 * Modification history: 
 * 30.11.2007 Initial Version   Robert Hunter
 *
 */
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/EDM_IMAGES.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $
--

 
DROP TABLE SGAS.EDM_IMAGES CASCADE CONSTRAINTS
/

--
-- EDM_IMAGES  (Table) 
--
CREATE TABLE SGAS.EDM_IMAGES
(
  STUD_REF_NO           NUMBER(10)              NOT NULL,
  SCAN_DATE             DATE                    NOT NULL,
  SESSION_CODE          NUMBER(4)               NOT NULL,
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
  UPLOAD_DATE           DATE
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

--
-- EDM_IMAGES_UK01  (Index) 
--
CREATE UNIQUE INDEX EDM_IMAGES_UK01 ON SGAS.EDM_IMAGES
(RESCAN_REQUEST_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             500K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

--
-- EDM_IMAGES_IDX01  (Index) 
--
CREATE INDEX EDM_IMAGES_IDX01 ON SGAS.EDM_IMAGES
(STUD_REF_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             506K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

-- 
-- Non Foreign Key Constraints for Table EDM_IMAGES 
-- 
ALTER TABLE SGAS.EDM_IMAGES ADD (
  CONSTRAINT EDM_IMAGES_CC05
 CHECK (viewed_doc in ('Y', 'N', null)))
/

ALTER TABLE SGAS.EDM_IMAGES ADD (
  CONSTRAINT EDM_IMAGES_CC04
 CHECK (annot in ('Y', 'N', null)))
/

ALTER TABLE SGAS.EDM_IMAGES ADD (
  CONSTRAINT EDM_IMAGES_CC03
 CHECK (req_original in ('Y', 'N', null)))
/

ALTER TABLE SGAS.EDM_IMAGES ADD (
  CONSTRAINT EDM_IMAGES_CC02
 CHECK (rescan_req in ('Y', 'N', null)))
/

ALTER TABLE SGAS.EDM_IMAGES ADD (
  CONSTRAINT EDM_IMAGES_CC01
 CHECK (rescan in ('Y', 'N', null)))
/

ALTER TABLE SGAS.EDM_IMAGES ADD (
  CONSTRAINT EDM_IMAGES_UK01
 UNIQUE (RESCAN_REQUEST_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          500K
                NEXT             500K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ))
/


