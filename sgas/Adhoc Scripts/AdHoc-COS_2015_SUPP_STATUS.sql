-------------------------------COS 2015 SUPP STATUS----------------------------------------------
-----This should be run first to set up the columns on all existing rows
ALTER TABLE STUD_CRSE_YEAR ADD SUPP_STATUS_ID NUMBER (3);
ALTER TABLE STUD_CRSE_YEAR ADD SUPP_LAST_UPDATE DATE;

-----Then run these to set the default values for any new insert
ALTER TABLE STUD_CRSE_YEAR MODIFY SUPP_STATUS_ID DEFAULT '1';
ALTER TABLE STUD_CRSE_YEAR MODIFY SUPP_LAST_UPDATE DEFAULT SYSDATE;

----------CREATE NEW TABLE SUPPLEMENTARY_STATUS---------------

CREATE TABLE SGAS.SUPPLEMENTARY_STATUS
(
  SUPP_STATUS_ID          NUMBER(3)             NOT NULL,
  APPLICATION_STATUS      VARCHAR2(20),
  SUPP_STATUS_MSG         VARCHAR2(150)
)
TABLESPACE STEPS_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX SGAS.SUPP_STATUS_PK ON SGAS.SUPPLEMENTARY_STATUS
(SUPP_STATUS_ID)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE SEQUENCE SGAS.SUPP_STATUS_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

CREATE OR REPLACE TRIGGER SGAS.TRIG_SUPP_STATUS_SEQ
   BEFORE INSERT
   ON SGAS.SUPPLEMENTARY_STATUS    FOR EACH ROW
BEGIN
   SELECT SUPP_STATUS_ID_SEQ.NEXTVAL
     INTO :NEW.SUPP_STATUS_ID
     FROM DUAL;
END;

ALTER TABLE SGAS.SUPPLEMENTARY_STATUS ADD (
  CONSTRAINT SUPP_STATUS_PK
  PRIMARY KEY
  (SUPP_STATUS_ID)
  USING INDEX SGAS.SUPP_STATUS_PK
  ENABLE VALIDATE);

INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS, SUPP_STATUS_MSG)
VALUES
    ('New Application', 'We have received your application.');
    
INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS, SUPP_STATUS_MSG)
VALUES
    ('Calculated', 'We have assessed your entitlement and you will be notified shortly.');
    
INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS, SUPP_STATUS_MSG)
VALUES
    ('Calculated', 'We have assessed your entitlement and we have requested further information.');
    
INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS, SUPP_STATUS_MSG)
VALUES
    ('Calculated', 'Your DSA letter is on its way.');

INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS)
VALUES
    ('Calculated');
    
INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS, SUPP_STATUS_MSG)
VALUES
    ('Withdrawn', 'Your college or university has told us you have withdrawn, if you are still attending please contact us on 0300 555 0505.');

INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS)
VALUES
    ('Withdrawn');
    
INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS, SUPP_STATUS_MSG)
VALUES
    ('Non-Attendance', 'Your college or university has told us you did not attend your course, if you are still attending please contact us on 0300 555 0505.');

INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS)
VALUES
    ('Non-Attendance');
    
INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS, SUPP_STATUS_MSG)
VALUES
    ('Returned Application', 'We need you to send us details of your education/employment history.');
    
INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS, SUPP_STATUS_MSG)
VALUES
    ('Returned Application', 'We need you to send us a copy of your course offer letter.');

INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    (APPLICATION_STATUS, SUPP_STATUS_MSG)
VALUES
    ('Returned Application', 'We need you to send us further residence information.');
    
INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    ( APPLICATION_STATUS, SUPP_STATUS_MSG)
VALUES
    ('Returned Application', 'We have asked SLC/your college or university for further information.');

INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    ( APPLICATION_STATUS)
VALUES
    ('Returned Application');

INSERT INTO SGAS.SUPPLEMENTARY_STATUS
    ( APPLICATION_STATUS)
VALUES
    ( 'Rejected Application');