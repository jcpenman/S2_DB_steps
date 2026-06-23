-- ATTENDANCE_DATA_MESSAGE.sql
-- Description: This table is used to store the messages generated when an ATTENDANCE_DATA record fails a validation check 
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      02.06.11    A.Bowman  (SAAS)        Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE SGAS.ATTENDANCE_DATA_MESSAGE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.ATTENDANCE_DATA_MESSAGE CASCADE CONSTRAINTS PURGE
/
--
-- ATTENDANCE_DATA_MESSAGE  (Table) 
--
CREATE TABLE SGAS.ATTENDANCE_DATA_MESSAGE
(
  attendance_data_message_id             NUMBER(10)       NOT NULL,
  attendance_data_received_id              NUMBER(10)          NOT NULL,
  message                              VARCHAR2(200),
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

CREATE UNIQUE INDEX ATTENDANCE_DATA_MESSAGE_PK ON SGAS.ATTENDANCE_DATA_MESSAGE
(ATTENDANCE_DATA_MESSAGE_ID)
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

ALTER TABLE SGAS.ATTENDANCE_DATA_MESSAGE ADD (
  CONSTRAINT ATTENDANCE_DATA_MESSAGE_PK
 PRIMARY KEY
 (ATTENDANCE_DATA_MESSAGE_ID)
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

ALTER TABLE SGAS.ATTENDANCE_DATA_MESSAGE ADD (
  CONSTRAINT F1_ATTDM
 FOREIGN KEY (ATTENDANCE_DATA_RECEIVED_ID) 
 REFERENCES SGAS.ATTENDANCE_DATA_RECEIVED (ATTENDANCE_DATA_RECEIVED_ID));



-- 
-- Create public synonym: 
-- 

DROP PUBLIC SYNONYM ATTENDANCE_DATA_MESSAGE
/

CREATE PUBLIC SYNONYM ATTENDANCE_DATA_MESSAGE FOR sgas.ATTENDANCE_DATA_MESSAGE
/

DROP SEQUENCE SGAS.ATT_DATA_MESS_ID_SEQ
/

--
-- ATT_DATA_MESS_ID_SEQ  (Sequence) 
--
CREATE SEQUENCE SGAS.ATT_DATA_MESS_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
                                                                        

CREATE OR REPLACE TRIGGER SGAS.trig_att_dat_mess_seq
   BEFORE INSERT
   ON SGAS.ATTENDANCE_DATA_MESSAGE    FOR EACH ROW
BEGIN
   SELECT att_data_mess_id_seq.NEXTVAL
     INTO :NEW.attendance_data_message_id
     FROM DUAL;
END;
/