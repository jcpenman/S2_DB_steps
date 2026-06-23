-- NMSB_SPEC_ARR.sql
-- Description: Table holding all NMSB special arrangement details
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      11.11.08    R Hunter (SAAS)         Initial Version.
-- 1.1      02.03.10    A.Bowman (SAAS)         Added constraint nmsb_spec_arr_uk
-- 1.2      06.05.10    A.Bowman (SAAS)         Added foreign key constraints
-- 1.3      27.10.10    A.Bowman (SAAS)         Removed constraint nmsb_spec_arr_uk
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author:   $
-- $Date:     $
-- $Revision: $

ALTER TABLE SGAS.nmsb_spec_arr
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.nmsb_spec_arr CASCADE CONSTRAINTS
/
--
-- NMSB_SPEC_ARR  (Table) 
--
CREATE TABLE SGAS.nmsb_spec_arr
(
  nmsb_spec_arr_id            NUMBER(9)        NOT NULL,
  stud_ref_no                 NUMBER(10)       NOT NULL,
  session_code          NUMBER(4),
  nmsb_spec_arr_type          VARCHAR2 (1),
  start_date         DATE,
  end_date        DATE,
  recommence_date    DATE,
  length_of_spec_arr    NUMBER(2),
  reason_code        NUMBER(1),
  last_updated_by          VARCHAR2(15)        DEFAULT USER                  NOT NULL,
  last_updated_on          DATE

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

COMMENT ON COLUMN SGAS.nmsb_spec_arr.nmsb_spec_arr_id IS 'Unique identifier for the NMSB_SPEC_ARR record – system generated.';


COMMENT ON COLUMN SGAS.nmsb_spec_arr.stud_ref_no IS 'The student’s reference number, taken from the STUD table, and used to link the records to a student.';

COMMENT ON COLUMN SGAS.nmsb_spec_arr.session_code IS 'The session in which the record was created.';

COMMENT ON COLUMN SGAS.nmsb_spec_arr.nmsb_spec_arr_type IS 'The type of special arrangement to which the record relates. Can be: M – Maternity Bursary C – Continuation; E – Extension.';

COMMENT ON COLUMN SGAS.nmsb_spec_arr.start_date IS 'The start date for the period of special arrangements, as entered by the user.';

COMMENT ON COLUMN SGAS.nmsb_spec_arr.end_date IS 'The end date for the period of special arrangements, as entered by the user.';

COMMENT ON COLUMN SGAS.nmsb_spec_arr.recommence_date IS 'The Recommencement Date for the student after the period of special arrangements, as entered by the user. Is likely to be null for initial record. A new record cannot be entered until the existing record has a recommencement date.';

COMMENT ON COLUMN SGAS.nmsb_spec_arr.length_of_spec_arr IS 'Holds the length of the period of special arrangements, derived from the start and end dates. The figure should be in weeks. The figure should be rounded down to the nearest week.';

COMMENT ON COLUMN SGAS.nmsb_spec_arr.reason_code IS 'Holds the reason code for continuations. This must be present for records with a type of C Continuations, but is not required for other types.';




CREATE UNIQUE INDEX nmsb_spec_arr_pk ON SGAS.nmsb_spec_arr
(nmsb_spec_arr_id)
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


ALTER TABLE SGAS.nmsb_spec_arr ADD (
  CONSTRAINT nmsb_spec_arr_pk
 PRIMARY KEY
 (nmsb_spec_arr_id)
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

ALTER TABLE SGAS.NMSB_SPEC_ARR ADD (
  CONSTRAINT F1_NSA
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));

ALTER TABLE SGAS.NMSB_SPEC_ARR ADD (
  CONSTRAINT F2_NSA
 FOREIGN KEY (REASON_CODE) 
 REFERENCES SGAS.NMSB_CONTINUATION_REASON (NMSB_CONT_ID));

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM nmsb_spec_arr
/
CREATE PUBLIC SYNONYM nmsb_spec_arr FOR sgas.nmsb_spec_arr
/
DROP SEQUENCE SGAS.nmsb_spec_arr_id_seq
/
--
-- NMSB_SPEC_ARR_ID_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.nmsb_spec_arr_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER SGAS.trig_nmsb_spec_arr_seq
   BEFORE INSERT
   ON SGAS.nmsb_spec_arr
   FOR EACH ROW
BEGIN
   SELECT nmsb_spec_arr_id_seq.NEXTVAL
     INTO :NEW.nmsb_spec_arr_id
     FROM DUAL;
END;