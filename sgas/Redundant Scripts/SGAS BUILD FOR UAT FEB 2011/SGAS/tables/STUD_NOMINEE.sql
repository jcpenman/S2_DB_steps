-- STUD_NOMINEE.sql
-- Description: Table holding all STUD_NOMINEEs for SGAS
-- Author J.Penman.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      28.08.09    J.Penman (SAAS)         Initial Version.
-- 1.1      02.09.09    J.Penman (SAAS)         Added sequence and public synonym
-- 1.2      03.09.09    J.Penman (SAAS)         Added IUD and LUB triggers 
-- 1.3      18.09.09    A.Bowman (SAAS)         Updated LUB trigger which was callling wrong proc on PK_STEPS_AUD
-- 1.4      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 1.5      30.04.10    A.Bowman (SAAS)         Added foreign key references
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $ 

/* Formatted on 2009/09/08 12:32 (Formatter Plus v4.8.8) */
ALTER TABLE sgas.stud_nominee
 DROP PRIMARY KEY CASCADE;
DROP TABLE sgas.stud_nominee CASCADE CONSTRAINTS PURGE;

CREATE TABLE sgas.stud_nominee
(
  stud_nom_id      NUMBER(10)                   NOT NULL,
  stud_ref_no      NUMBER(10)                   NOT NULL,
  nominee_id       NUMBER(10)                   NOT NULL,
  last_updated_by  VARCHAR2(15 BYTE)            DEFAULT USER                  NOT NULL,
  last_updated_on  DATE                         DEFAULT SYSDATE               NOT NULL
)
TABLESPACE users
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
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

COMMENT ON COLUMN sgas.stud_nominee.stud_nom_id IS 'Primary key for this table';

COMMENT ON COLUMN sgas.stud_nominee.stud_ref_no IS 'Unique reference number for a student';

COMMENT ON COLUMN sgas.stud_nominee.nominee_id IS 'Unique reference number for a nominee';


CREATE UNIQUE INDEX sgas.stud_nominee_pk ON sgas.stud_nominee
(stud_nom_id)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE OR REPLACE TRIGGER SGAS.stud_nom_iud
   AFTER INSERT OR DELETE OR UPDATE OF stud_nom_id, stud_ref_no, nominee_id, last_updated_by
   ON SGAS.STUD_NOMINEE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                 := SYSDATE;
   p_column_name    stud_nominee_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_nominee_aud.table_pkey1%TYPE    := :OLD.stud_nom_id;
   p_table_pkey2    stud_nominee_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_nominee_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_nominee_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_nominee_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_nominee_aud.OLD%TYPE            := NULL;
   p_new            stud_nominee_aud.NEW%TYPE            := NULL;
   p_action         stud_nominee_aud.action%TYPE         := NULL;
   p_username       stud_nominee_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    stud_nominee_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_nominee_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_nominee_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_nom_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.stud_nom_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'STUD_NOM_ID';
   p_old := :OLD.stud_nom_id;
   p_new := :NEW.stud_nom_id;
   pk_steps_aud.ins_stud_nom_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_table_pkey2,
                                  p_table_pkey3,
                                  p_table_pkey4,
                                  p_table_pkey5,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username,
                                  p_stud_ref_no,
                                  p_inst_code,
                                  p_session_code
                                 );
   p_column_name := 'STUD_REF_NO';
   p_old := TO_CHAR (:OLD.stud_ref_no);
   p_new := TO_CHAR (:NEW.stud_ref_no);
   pk_steps_aud.ins_stud_nom_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_table_pkey2,
                                  p_table_pkey3,
                                  p_table_pkey4,
                                  p_table_pkey5,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username,
                                  p_stud_ref_no,
                                  p_inst_code,
                                  p_session_code
                                 );
   p_column_name := 'NOMINEE_ID';
   p_old := TO_CHAR (:OLD.nominee_id);
   p_new := TO_CHAR (:NEW.nominee_id);
   pk_steps_aud.ins_stud_nom_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_table_pkey2,
                                  p_table_pkey3,
                                  p_table_pkey4,
                                  p_table_pkey5,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username,
                                  p_stud_ref_no,
                                  p_inst_code,
                                  p_session_code
                                 );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.LAST_UPDATED_BY;
   p_new := :NEW.LAST_UPDATED_BY;
   pk_steps_aud.ins_stud_nom_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_table_pkey2,
                                  p_table_pkey3,
                                  p_table_pkey4,
                                  p_table_pkey5,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username,
                                  p_stud_ref_no,
                                  p_inst_code,
                                  p_session_code
                                 );
END stud_nom_iud;
/

DROP SEQUENCE SGAS.STUD_NOMINEE_ID_SEQ;

CREATE SEQUENCE SGAS.STUD_NOMINEE_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


GRANT SELECT ON  SGAS.STUD_NOMINEE_ID_SEQ TO PUBLIC;

CREATE OR REPLACE TRIGGER sgas.trig_stud_nom_seq
   BEFORE INSERT
   ON sgas.stud_nominee
   FOR EACH ROW
BEGIN
   SELECT stud_nominee_id_seq.NEXTVAL
     INTO :NEW.stud_nom_id
     FROM DUAL;
END;
/

DROP PUBLIC SYNONYM stud_nominee;

CREATE PUBLIC SYNONYM stud_nominee FOR sgas.stud_nominee;


ALTER TABLE sgas.stud_nominee ADD (
  CONSTRAINT stud_nominee_pk
 PRIMARY KEY
 (stud_nom_id)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64 k
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE SGAS.STUD_NOMINEE ADD (
  CONSTRAINT F1_STN
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));

ALTER TABLE SGAS.STUD_NOMINEE ADD (
  CONSTRAINT F2_STN
 FOREIGN KEY (NOMINEE_ID) 
 REFERENCES SGAS.NOMINEE (NOMINEE_ID));

COMMIT ;