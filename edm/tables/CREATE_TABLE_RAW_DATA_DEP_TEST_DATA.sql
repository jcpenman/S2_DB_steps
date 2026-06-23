

CREATE TABLE EDM.RAW_DATA_DEP$TEST_DATA
(
  AUD_ACTION                 VARCHAR2(30),
  AUD_TIMESTAMP              DATE,
  AUD_USER                   VARCHAR2(30),
  OBJECT_ID                  VARCHAR2(44 BYTE)  NOT NULL,
  STUD_REF_NO                NUMBER(10),
  STUD_DEP_ID                NUMBER(10),
  FORENAMES                  VARCHAR2(25 BYTE),
  SURNAME                    VARCHAR2(25 BYTE),
  DOB                        VARCHAR2(10 BYTE),
  DEPENDANT_RELATIONSHIP_ID  NUMBER(4),
  TOTAL_INCOME               NUMBER(9,2),
  EMAIL_ADDR                 VARCHAR2(80 BYTE),
  POST_CODE                  VARCHAR2(8 BYTE),
  HOUSE_NO_NAME              VARCHAR2(32 BYTE),
  ADDR_L1                    VARCHAR2(65 BYTE),
  ADDR_L2                    VARCHAR2(65 BYTE),
  ADDR_L3                    VARCHAR2(65 BYTE),
  ADDR_L4                    VARCHAR2(65 BYTE),
  LPG                        VARCHAR2(1 BYTE)
);

GRANT DELETE, INSERT, SELECT, UPDATE ON EDM.RAW_DATA_DEP$TEST_DATA TO SGAS;

