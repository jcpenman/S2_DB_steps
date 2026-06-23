-- ATTENDANCE_DATA_RECEIVED.sql
-- Description: Table holds details of all return file records received from Institutions 
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      31.05.11    A.Bowman  (SAAS)        Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE SGAS.ATTENDANCE_DATA_RECEIVED
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.ATTENDANCE_DATA_RECEIVED CASCADE CONSTRAINTS PURGE
/
--
-- ATTENDANCE_DATA_RECEIVED  (Table) 
--
CREATE TABLE SGAS.ATTENDANCE_DATA_RECEIVED
(
  attendance_data_received_id            NUMBER(10)       NOT NULL,
  file_creation_date                     DATE             NOT NULL,
  institution                            VARCHAR2(50)     NOT NULL,
  session_code                           NUMBER(4)        NOT NULL,
  stud_ref_no                            NUMBER(10)       NOT NULL,
  status                                 VARCHAR2(1)      NOT NULL,
  effective_date_withdrawn               DATE,
  repeat_year_reason                     VARCHAR2(4),
  loa_reason                             VARCHAR2(4),
  course_code                            VARCHAR2(12),
  course_title                           VARCHAR2(50), 
  confirmed_crse_year                    NUMBER(2),
  date_course_changed                    DATE,
  additional_info                        VARCHAR2(250),
  date_rec_created                       DATE,
  duplicate                              VARCHAR2(1),
  processed                              VARCHAR2(1),   
  last_updated_by                        VARCHAR2(15 BYTE)        DEFAULT 'System'              NOT NULL,
  last_updated_on                        DATE                     DEFAULT SYSDATE               NOT NULL
)
TABLESPACE users
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX ATTENDANCE_DATA_RECEIVED_PK ON SGAS.ATTENDANCE_DATA_RECEIVED
(ATTENDANCE_DATA_RECEIVED_ID)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE SGAS.ATTENDANCE_DATA_RECEIVED ADD (
  CONSTRAINT ATTENDANCE_DATA_RECEIVED_PK
 PRIMARY KEY
 (ATTENDANCE_DATA_RECEIVED_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

ALTER TABLE SGAS.ATTENDANCE_DATA_RECEIVED ADD (
  CONSTRAINT F1_ATT_RECD 
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));
 
ALTER TABLE SGAS.ATTENDANCE_DATA_RECEIVED ADD (
  CONSTRAINT F2_ATT_RECD 
 FOREIGN KEY (STATUS) 
 REFERENCES SGAS.ATTENDANCE_DATA_STATUS (STATUS_CODE));
 
ALTER TABLE SGAS.ATTENDANCE_DATA_RECEIVED ADD (
  CONSTRAINT F3_ATT_RECD 
 FOREIGN KEY (REPEAT_YEAR_REASON) 
 REFERENCES SGAS.REPEAT_YEAR_REASON_CODE (REASON_CODE));
 
ALTER TABLE SGAS.ATTENDANCE_DATA_RECEIVED ADD (
  CONSTRAINT F4_ATT_RECD 
 FOREIGN KEY (LOA_REASON) 
 REFERENCES SGAS.LOA_REASON_CODE (LOA_REASON_CODE));

ALTER TABLE SGAS.attendance_data_received ADD (
  CONSTRAINT ATT_DATA_REC
 CHECK (status in ('E','A','W','N','R','C','P','X','O')));

ALTER TABLE SGAS.attendance_data_received ADD (
  CONSTRAINT ATT_DATA_REC1
 CHECK (repeat_year_reason in ('MED','COMP','ACAD','RWA','PART','OTHR', NULL)));

ALTER TABLE SGAS.attendance_data_received ADD (
  CONSTRAINT ATT_DATA_REC2
 CHECK (loa_reason in ('MLOA','CARE')));

-- 
-- Create public synonym: 
-- 

DROP PUBLIC SYNONYM ATTENDANCE_DATA_RECEIVED
/

CREATE PUBLIC SYNONYM ATTENDANCE_DATA_RECEIVED FOR sgas.ATTENDANCE_DATA_RECEIVED
/

DROP SEQUENCE SGAS.ATT_DATA_RECD_ID_SEQ
/

--
-- ATT_DATA_RECD_ID_SEQ  (Sequence) 
--
CREATE SEQUENCE SGAS.ATT_DATA_RECD_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
                                                                        

CREATE OR REPLACE TRIGGER SGAS.trig_att_data_recd_seq
   BEFORE INSERT
   ON SGAS.ATTENDANCE_DATA_RECEIVED    FOR EACH ROW
BEGIN
   SELECT att_data_recd_id_seq.NEXTVAL
     INTO :NEW.attendance_data_received_id
     FROM DUAL;
END;
/