-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- Modification History
-- 010 26.08.10    A.Bowman (SAAS) Added new column overpayment_recorded in line with new requirments
-- 009 17.06.10    A.Bowman (SAAS) Renamed DSA_ARRANGEMENT_ID to DSA_ALLOWANCE_ID 
-- 008 05.05.10    A.Bowman (SAAS) Added foreign key references
-- 007 28.01.10    A.Bowman (SAAS) Amended audit triggers
-- 006 27.08.09    A.Bowman (SAAS) Added new auditable column to trigger aw_iud to meet audit requirements
-- 005 22.06.09    A.Bowman (SAAS) Added audit triggers
-- 004 05.09.08    Steve Durkin   Reinstate non_tuition_fee_id - dependant adapter services - TODO: Schedule for deletion post-production.
-- 003 08.05.08    Steve Durkin   Confirm removal of the non-tuition_fee_id field.
-- 002 26.02.08    Steve Durkin    Add FK to dsa_arrangements
-- 001  18.02.08    Steve Durkin    Add Audit cols
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/AWARD.sql $
-- $Author: $
-- $Date: 2011-01-27 14:11:48 +0000 (Thu, 27 Jan 2011) $
-- $Revision: 6356 $

ALTER TABLE SGAS.award
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.award CASCADE CONSTRAINTS
/

--
-- AWARD  (Table) 
--
CREATE TABLE SGAS.award
(
  award_id                        NUMBER(10) CONSTRAINT NN_AW_AWARD_ID NOT NULL,
  stud_crse_year_id               NUMBER(9) CONSTRAINT NN_AW_STUD_CRSE_YEAR_ID NOT NULL,
  award_src                       VARCHAR2(1 BYTE) CONSTRAINT NN_AW_AWARD_SRC NOT NULL,
  -- 002
  dsa_allowance_id              NUMBER(10),
  -- 004
  non_tuition_fee_id              NUMBER(9),
  tuition_fee_type_code           NUMBER(4),
  stud_award_type                 VARCHAR2(6 BYTE),
  award_type_descript             VARCHAR2(51 BYTE) CONSTRAINT NN_AW_AWARD_TYPE_DESCRIPT NOT NULL,
  inst_code                       VARCHAR2(5 BYTE) CONSTRAINT NN_AW_INST_CODE NOT NULL,
  crse_id                         NUMBER(9) CONSTRAINT NN_AW_CRSE_ID NOT NULL,
  stud_ref_no                     NUMBER(10) CONSTRAINT NN_AW_STUD_REF_NO NOT NULL,
  session_code                    NUMBER(4) CONSTRAINT NN_AW_SESSION_CODE NOT NULL,
  crse_year_no                    NUMBER(2) CONSTRAINT NN_AW_CRSE_YEAR_NO NOT NULL,
  assessment_date                 DATE CONSTRAINT NN_AW_ASSESSMENT_DATE NOT NULL,
  assess_reason_code              VARCHAR2(1 BYTE) CONSTRAINT NN_AW_ASSESS_REASON_CODE NOT NULL,
  amount                          NUMBER(9,2) CONSTRAINT NN_AW_AMOUNT NOT NULL,
  net_amount                      NUMBER(9,2) CONSTRAINT NN_AW_NET_AMOUNT NOT NULL,
  contrib_amount                  NUMBER(9,2) CONSTRAINT NN_AW_CONTRIB_AMOUNT NOT NULL,
  recovered_amount                NUMBER(9,2) CONSTRAINT NN_AW_RECOVERED_AMOUNT NOT NULL,
  overpayment_amount              NUMBER(9,2) CONSTRAINT NN_AW_OVERPAYMENT_AMOUNT NOT NULL,
  auto_travel_amount              NUMBER(9,2),
  trav_amount                     NUMBER(9,2),
  hold                            VARCHAR2(1 BYTE) DEFAULT 'N',
  overpaid_contrib                NUMBER(9,2)   DEFAULT 0,
  zero_da                         VARCHAR2(1 BYTE),
  unclaimed_loan                  NUMBER(9,2),
  online_award_payment_hold_flag  VARCHAR2(1 BYTE),
  paid_as_claimed_fg              VARCHAR2(1 BYTE),
  travel_award_type               VARCHAR2(1 BYTE),
  unclaimed_fee_loan              NUMBER(9,2),
  overpayment_recorded            NUMBER(9,2)   DEFAULT 0, 
  -- 001 - Add Audit Columns
  last_updated_by          VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_AW_LAST_UPDATED_BY NOT NULL,
  last_updated_on          DATE DEFAULT Sysdate CONSTRAINT NN_AW_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1400K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       249
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
-- S7_AW  (Index) 
--
CREATE INDEX s7_aw ON SGAS.award
(tuition_fee_type_code)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S5_AW  (Index) 
--
CREATE INDEX s5_aw ON SGAS.award
(stud_ref_no)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S2_AW  (Index) 
--
CREATE INDEX s2_aw ON SGAS.award
(stud_award_type)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          300K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S3_AW  (Index) 
--
CREATE INDEX s3_aw ON SGAS.award
(INST_CODE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- P_AW  (Index) 
--
CREATE UNIQUE INDEX P_AW ON SGAS.AWARD
(AWARD_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          300K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S1_AW  (Index) 
--
CREATE INDEX S1_AW ON SGAS.AWARD
(STUD_CRSE_YEAR_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S4_AW  (Index) 
--
CREATE INDEX S4_AW ON SGAS.AWARD
(CRSE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

CREATE OR REPLACE TRIGGER SGAS.aw_iud
   AFTER INSERT OR DELETE OR UPDATE OF non_tuition_fee_id,
                                       amount,
                                       net_amount,
                                       contrib_amount,
                                       recovered_amount,
                                       travel_award_type,
                                       unclaimed_fee_loan,
                                       award_type_descript,
                                       last_updated_by
   ON SGAS.AWARD    FOR EACH ROW
DECLARE
   p_aud_date            DATE                           := SYSDATE;
   p_column_name         award_aud.column_name%TYPE     := NULL;
   p_table_pkey1         award_aud.table_pkey1%TYPE     := :OLD.award_id;
   p_table_pkey2         award_aud.table_pkey2%TYPE     := NULL;
   p_table_pkey3         award_aud.table_pkey3%TYPE     := NULL;
   p_table_pkey4         award_aud.table_pkey4%TYPE     := NULL;
   p_table_pkey5         award_aud.table_pkey5%TYPE     := NULL;
   p_old                 award_aud.OLD%TYPE             := NULL;
   p_new                 award_aud.NEW%TYPE             := NULL;
   p_action              award_aud.action%TYPE          := NULL;
   p_username            award_aud.username%TYPE        := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no         award_aud.stud_ref_no%TYPE     := NULL;
   p_inst_code           award_aud.inst_code%TYPE       := NULL;
   p_session_code        award_aud.session_code%TYPE    := NULL;
   p_stud_crse_year_id   award.stud_crse_year_id%TYPE
                                                    := :OLD.stud_crse_year_id;
   p_src                 award.award_src%TYPE           := :NEW.award_src;
   p_stud_award_type     award.stud_award_type%TYPE;
   v_temp                VARCHAR2 (1)                   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.award_id;
      p_stud_ref_no := :NEW.stud_ref_no;
      p_stud_crse_year_id := :NEW.stud_crse_year_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.award_id;
      p_src := :OLD.award_src;
      p_username := :OLD.last_updated_by;
   END IF;

   SELECT session_code
     INTO p_session_code
     FROM stud_crse_year
    WHERE stud_crse_year_id = p_stud_crse_year_id;

      p_column_name := 'NON_TUITION_FEE_ID';
      p_old := TO_CHAR (:OLD.non_tuition_fee_id);
      p_new := TO_CHAR (:NEW.non_tuition_fee_id);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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
      p_column_name := 'AMOUNT';
      p_old := TO_CHAR (:OLD.amount);
      p_new := TO_CHAR (:NEW.amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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

      IF p_src = 'T'
      THEN
         pk_steps_changes.award_net_change (p_old, p_new, p_stud_crse_year_id);
      END IF;

      p_column_name := 'NET_AMOUNT';
      p_old := TO_CHAR (:OLD.net_amount);
      p_new := TO_CHAR (:NEW.net_amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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

      IF p_src = 'T'
      THEN
         pk_steps_changes.award_net_change (p_old, p_new, p_stud_crse_year_id);
      END IF;

      p_column_name := 'CONTRIB_AMOUNT';
      p_old := TO_CHAR (:OLD.contrib_amount);
      p_new := TO_CHAR (:NEW.contrib_amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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

      IF p_src = 'T'
      THEN
         pk_steps_changes.award_contrib_change (p_old, p_new, p_stud_crse_year_id);
      END IF;

      p_column_name := 'RECOVERED_AMOUNT';
      p_old := TO_CHAR (:OLD.recovered_amount);
      p_new := TO_CHAR (:NEW.recovered_amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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
      p_column_name := 'TRAVEL_AWARD_TYPE';
      p_old := TO_CHAR (:OLD.travel_award_type);
      p_new := TO_CHAR (:NEW.travel_award_type);
      p_stud_award_type := TO_CHAR (:OLD.stud_award_type);

      IF p_stud_award_type IN ('UGTE', 'UGLTE', 'PSTE', 'PSLTE')
      THEN
         pk_steps_aud.ins_aw_aud (p_aud_date,
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
      END IF;

      p_column_name := 'UNCLAIMED_FEE_LOAN';
      p_old := TO_CHAR (:OLD.unclaimed_fee_loan);
      p_new := TO_CHAR (:NEW.unclaimed_fee_loan);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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
      p_column_name := 'AWARD_TYPE_DESCRIPT';
      p_old := :OLD.award_type_descript;
      p_new := :NEW.award_type_descript;
      pk_steps_aud.ins_aw_aud (p_aud_date,
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
      p_old := :OLD.last_updated_by;
      p_new := :NEW.last_updated_by;
      pk_steps_aud.ins_aw_aud (p_aud_date,
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
EXCEPTION
   WHEN OTHERS
   THEN
      v_temp := 'N';
      
END aw_iud;

SHOW ERRORS;

-- 
-- Constraints
-- 

ALTER TABLE SGAS.AWARD ADD (
  CONSTRAINT AW_AWARD_SRC
 CHECK ( AWARD_SRC IN('A','I','C','T')))
/


ALTER TABLE SGAS.AWARD ADD (
  CONSTRAINT P_AW
 PRIMARY KEY
 (AWARD_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          300K
                NEXT             100K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ))
/

ALTER TABLE SGAS.AWARD ADD (
  CONSTRAINT F1_AWA
 FOREIGN KEY (STUD_CRSE_YEAR_ID) 
 REFERENCES SGAS.STUD_CRSE_YEAR (STUD_CRSE_YEAR_ID));

ALTER TABLE SGAS.AWARD ADD (
  CONSTRAINT F2_AWA
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));


ALTER TABLE SGAS.AWARD ADD (
  CONSTRAINT F3_AWA
 FOREIGN KEY (DSA_ALLOWANCE_ID) 
 REFERENCES SGAS.DSA_ALLOWANCE (ID));

DROP SEQUENCE sgas.aw_award_id_seq;

CREATE SEQUENCE sgas.aw_award_id_seq
  START WITH 7000000
  MAXVALUE 999999999999
  MINVALUE 7000000
  NOCYCLE
  NOCACHE
  NOORDER;

DROP PUBLIC SYNONYM aw_award_id_seq;

CREATE PUBLIC SYNONYM aw_award_id_seq 
FOR sgas.aw_award_id_seq;

GRANT SELECT ON sgas.aw_award_id_seq
TO PUBLIC;
