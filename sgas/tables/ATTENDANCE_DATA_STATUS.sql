-- ATTENDANCE_DATA_STATUS.sql
-- Description: This table is used to store the status codes which will be populated by Institutions in the Attendance Data files
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      02.06.11    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.ATTENDANCE_DATA_STATUS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.ATTENDANCE_DATA_STATUS CASCADE CONSTRAINTS PURGE
/
--
-- ATTENDANCE_DATA_STATUS  (Table) 
--
CREATE TABLE sgas.ATTENDANCE_DATA_STATUS
(
  status_code                 VARCHAR2(1 BYTE) NOT NULL,
  status_description           VARCHAR2(200 BYTE) NOT NULL,
  last_updated_by             VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on             DATE                     DEFAULT SYSDATE               NOT NULL
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


CREATE UNIQUE INDEX ATTENDANCE_DATA_STATUS_PK ON sgas.ATTENDANCE_DATA_STATUS
(STATUS_CODE)
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

ALTER TABLE sgas.ATTENDANCE_DATA_STATUS ADD (
  CONSTRAINT ATTENDANCE_DATA_STATUS_PK
 PRIMARY KEY
 (STATUS_CODE)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64 k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));



-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM ATTENDANCE_DATA_STATUS
/
CREATE PUBLIC SYNONYM ATTENDANCE_DATA_STATUS FOR sgas.ATTENDANCE_DATA_STATUS
/
                                                                        
--
-- INSERT DATA
--

INSERT INTO ATTENDANCE_DATA_STATUS
            (status_code, status_description 
            )
     VALUES ('E', 'Enrolment Confirmation'  
            );
INSERT INTO ATTENDANCE_DATA_STATUS
            (status_code, status_description 
            )
     VALUES ('A', 'Ongoing Attendance Confirmation'  
            );
INSERT INTO ATTENDANCE_DATA_STATUS
            (status_code, status_description 
            )
     VALUES ('W', 'Withdrawal notification'  
            );
INSERT INTO ATTENDANCE_DATA_STATUS
            (status_code, status_description 
            )
     VALUES ('N', 'Non Attendance notification'  
            );
INSERT INTO ATTENDANCE_DATA_STATUS
            (status_code, status_description 
            )
     VALUES ('R', 'Repeat Year notification'  
            );
INSERT INTO ATTENDANCE_DATA_STATUS
            (status_code, status_description 
            )
     VALUES ('C', 'Change of Course notification'  
            );
INSERT INTO ATTENDANCE_DATA_STATUS
            (status_code, status_description 
            )
     VALUES ('P', 'Placement Year notification'  
            );
INSERT INTO ATTENDANCE_DATA_STATUS
            (status_code, status_description 
            )
     VALUES ('X', 'Exchange/Study Abroad Year notification'  
            );
INSERT INTO ATTENDANCE_DATA_STATUS
            (status_code, status_description 
            )
     VALUES ('O', 'Other notifications'  
            );

COMMIT ;