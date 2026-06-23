--DROP TABLE SGAS.ESTRANGED_STUD_REPORT CASCADE CONSTRAINTS;

CREATE TABLE SGAS.ESTRANGED_STUD_REPORT
(
  STUD_REF_NO                NUMBER(10),
  SESSION_CODE               NUMBER(4),
  DOB                        DATE,
  DATE_APPLICATION_RECEIVED  DATE,
  INST_CODE                  VARCHAR2(5 BYTE),
  INST_NAME                  VARCHAR2(50 BYTE),
  CRSE_CODE                  VARCHAR2(4 BYTE),
  CRSE_NAME                  VARCHAR2(50 BYTE),
  CRSE_YEAR_NO               NUMBER(2),
  NATION_COUNTRY_CODE        NUMBER(3),
  NATION_COUNTRY             VARCHAR2(25 BYTE),
  BIRTH_COUNTRY_CODE         NUMBER(3),
  BIRTH_COUNTRY              VARCHAR2(25 BYTE),
  APPLICATION_STATUS         VARCHAR2(100 BYTE),
  CREATED_DATE               DATE               DEFAULT SYSDATE,
  FEES                       NUMBER(5),
  CESB                       NUMBER(5),
  ISB                        NUMBER(5),
  YSB                        NUMBER(5),
  UGLOAN                     NUMBER(5),
  UGOA                       NUMBER(5),
  UGDA                       NUMBER(5),
  UGDSA                      NUMBER(5),
  PGLOAN                     NUMBER(5),
  SNB                        NUMBER(5),
  SNCAP                      NUMBER(5),
  SNDA                       NUMBER(5),
  SNIE                       NUMBER(5),
  SNSPA                      NUMBER(5),
  TFEL                       NUMBER(5),
  OTHER_AWARD_TYPE           VARCHAR2(4000 BYTE)
)
TABLESPACE STEPS_DATA
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


CREATE INDEX SGAS.S1_ESTR ON SGAS.ESTRANGED_STUD_REPORT
(STUD_REF_NO, SESSION_CODE)
LOGGING
TABLESPACE STEPS_INDEX
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


CREATE INDEX SGAS.S2_ESTR ON SGAS.ESTRANGED_STUD_REPORT
(CRSE_NAME)
LOGGING
TABLESPACE STEPS_INDEX
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


CREATE INDEX SGAS.S3_ESTR ON SGAS.ESTRANGED_STUD_REPORT
(INST_NAME)
LOGGING
TABLESPACE STEPS_INDEX
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


CREATE INDEX SGAS.S4_ESTR ON SGAS.ESTRANGED_STUD_REPORT
(SESSION_CODE)
LOGGING
TABLESPACE STEPS_INDEX
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


CREATE INDEX SGAS.S5_ESTR ON SGAS.ESTRANGED_STUD_REPORT
(APPLICATION_STATUS)
LOGGING
TABLESPACE STEPS_INDEX
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
