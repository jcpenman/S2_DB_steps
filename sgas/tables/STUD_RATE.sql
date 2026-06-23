-- STUD_RATE.sql
-- Description: Table holding all STUD Rates for SGAS
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      11.11.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      30.04.10    A.Bowman (SAAS)         Added foreign key references
-- 1.2      02.11.10    A.Bowman (SAAS)         Added unique constraint for stud_award_type_id and session_code
--
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.STUD_RATE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.STUD_RATE CASCADE CONSTRAINTS PURGE
/
--
-- STUD_RATE  (Table) 
--
CREATE TABLE sgas.STUD_RATE (

STUD_RATE_ID              NUMBER(10) NOT NULL,
STUD_AWARD_TYPE_ID         NUMBER(10) NOT NULL,
SESSION_CODE               NUMBER(4) NOT NULL,
disab_basic_max            NUMBER(15,2)             DEFAULT 0,
disab_non_med_max          NUMBER(15,2)             DEFAULT 0,
disab_equip_max            NUMBER(15,2)             DEFAULT 0,
disab_trav_max             NUMBER(15,2)             DEFAULT 0,
last_updated_by            VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
last_updated_on            DATE                     DEFAULT SYSDATE               NOT NULL
)
/
CREATE UNIQUE INDEX STUD_RATE_pk ON sgas.STUD_RATE
(STUD_RATE_id)
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

CREATE UNIQUE INDEX SGAS.STUD_RATE_U01 ON SGAS.STUD_RATE
(STUD_AWARD_TYPE_ID, SESSION_CODE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE sgas.STUD_RATE ADD (
  CONSTRAINT STUD_RATE_pk
 PRIMARY KEY
 (STUD_RATE_id)
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

ALTER TABLE SGAS.STUD_RATE ADD (
  CONSTRAINT STUD_RATE_U01
 UNIQUE (STUD_AWARD_TYPE_ID, SESSION_CODE)
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

ALTER TABLE SGAS.STUD_RATE ADD (
  CONSTRAINT F1_STR
 FOREIGN KEY (STUD_AWARD_TYPE_ID) 
 REFERENCES SGAS.STUD_AWARD_TYPE (STUD_AWARD_TYPE_ID));

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM STUD_RATE
/
CREATE PUBLIC SYNONYM STUD_RATE FOR sgas.STUD_RATE
/
DROP SEQUENCE sgas.STUD_RATE_id_seq
/
--
-- STUD_RATE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.STUD_RATE_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_STUD_RATE_seq
   BEFORE INSERT
   ON SGAS.STUD_RATE
   FOR EACH ROW
BEGIN
   SELECT STUD_RATE_id_seq.NEXTVAL
     INTO :NEW.STUD_RATE_id
     FROM DUAL;
END;                                                            

--
-- INSERT DATA
--

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (32, 2009 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (34, 2009 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (37, 2009 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (43, 2009 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (32, 2010 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (34, 2010 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (37, 2010 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (43, 2010 
            );

COMMIT;
