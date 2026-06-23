-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CR-OLS-203
-- Mapping Table to link Student Enquiry Task data in SAG DB to the Student Enquiry messages stored in the STEPS DB
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--ALTER TABLE SGAS.STUD_ENQUIRY_TASK_MAP DROP PRIMARY KEY CASCADE;
--DROP TABLE SGAS.STUD_ENQUIRY_TASK_MAP CASCADE CONSTRAINTS;

CREATE TABLE SGAS.STUD_ENQUIRY_TASK_MAP
(
  TASK_ID      NUMBER(10)                       NOT NULL,
  ENQUIRY_ID   NUMBER                           NOT NULL,
  PROCESS_ID   VARCHAR2(64 BYTE)                NOT NULL,
  STUD_REF_NO  NUMBER(10)                       NOT NULL
)
TABLESPACE USERS
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE INDEX SGAS.IDX_STUD_ENQ_TASK_MAP_SRN ON SGAS.STUD_ENQUIRY_TASK_MAP
(STUD_REF_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


CREATE INDEX SGAS.IDX_STUD_ENQ_TASK_MAP_TASK_ID ON SGAS.STUD_ENQUIRY_TASK_MAP
(TASK_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


ALTER TABLE SGAS.STUD_ENQUIRY_TASK_MAP ADD (
  CONSTRAINT STUD_ENQUIRY_TASK_MAP_PK
  PRIMARY KEY
  (TASK_ID)
  USING INDEX SGAS.IDX_STUD_ENQ_TASK_MAP_TASK_ID
  ENABLE VALIDATE);

ALTER TABLE SGAS.STUD_ENQUIRY_TASK_MAP ADD (
  CONSTRAINT STUD_ENQUIRY_TASK_MAP__R01 
  FOREIGN KEY (ENQUIRY_ID) 
  REFERENCES SGAS.STUD_ENQUIRY (ENQUIRY_ID)
  ENABLE VALIDATE,
  CONSTRAINT STUD_ENQUIRY_TASK_MAP__R02 
  FOREIGN KEY (STUD_REF_NO) 
  REFERENCES SGAS.STUD (STUD_REF_NO)
  ENABLE VALIDATE);
