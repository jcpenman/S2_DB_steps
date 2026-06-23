-- CONTACT_RELATIONSHIP.sql
-- Description: Table holding all CONTACT_RELATIONSHIPs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      09.06.09    R Hunter (SAAS)         Initial Version.
-- 1.1      09.06.09    A.Bowman (SAAS)         Added audit triggers
-- 1.2      25.06.09    A.Bowman (SAAS)         Removed seq trigger as it had been added twice
-- 1.3      28.01.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE SGAS.CONTACT_RELATIONSHIP
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.CONTACT_RELATIONSHIP CASCADE CONSTRAINTS PURGE
/
--
-- CONTACT_RELATIONSHIP  (Table) 
--
CREATE TABLE SGAS.CONTACT_RELATIONSHIP
(
  contact_relationship_id      NUMBER(10)       NOT NULL,
  reltype                      VARCHAR2(1 BYTE) NOT NULL,
  descript                     VARCHAR2(1000 BYTE) NOT NULL,
  last_updated_by              VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on              DATE                     DEFAULT SYSDATE               NOT NULL
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

COMMENT ON COLUMN SGAS.CONTACT_RELATIONSHIP.CONTACT_RELATIONSHIP_id IS 'Unique CONTACT_RELATIONSHIP reference number';

COMMENT ON COLUMN SGAS.CONTACT_RELATIONSHIP.reltype IS 'Relationship type character';

COMMENT ON COLUMN SGAS.CONTACT_RELATIONSHIP.descript IS 'Description of relationship type';

COMMENT ON COLUMN SGAS.CONTACT_RELATIONSHIP.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN SGAS.CONTACT_RELATIONSHIP.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX CONTACT_RELATIONSHIP_pk ON SGAS.CONTACT_RELATIONSHIP
(CONTACT_RELATIONSHIP_id)
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

CREATE OR REPLACE TRIGGER SGAS.con_rel_iud
   AFTER INSERT OR DELETE OR UPDATE OF contact_relationship_id,
                                       reltype,
                                       descript,
                                       last_updated_by
   ON SGAS.CONTACT_RELATIONSHIP    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                         := SYSDATE;
   p_column_name    contact_relationship_aud.column_name%TYPE    := NULL;
   p_table_pkey1    contact_relationship_aud.table_pkey1%TYPE
                                              := :OLD.contact_relationship_id;
   p_table_pkey2    contact_relationship_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    contact_relationship_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    contact_relationship_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    contact_relationship_aud.table_pkey5%TYPE    := NULL;
   p_old            contact_relationship_aud.OLD%TYPE            := NULL;
   p_new            contact_relationship_aud.NEW%TYPE            := NULL;
   p_action         contact_relationship_aud.action%TYPE         := NULL;
   p_username       contact_relationship_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    contact_relationship_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      contact_relationship_aud.inst_code%TYPE      := NULL;
   p_session_code   contact_relationship_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.contact_relationship_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.contact_relationship_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'CONTACT_RELATIONSHIP_ID';
   p_old := :OLD.contact_relationship_id;
   p_new := :NEW.contact_relationship_id;
   pk_steps_aud.ins_con_rel_aud (p_aud_date,
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
   p_column_name := 'RELTYPE';
   p_old := TO_CHAR (:OLD.reltype);
   p_new := TO_CHAR (:NEW.reltype);
   pk_steps_aud.ins_con_rel_aud (p_aud_date,
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
   p_column_name := 'DESCRIPT';
   p_old := TO_CHAR (:OLD.descript);
   p_new := TO_CHAR (:NEW.descript);
   pk_steps_aud.ins_con_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_con_rel_aud (p_aud_date,
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
END con_rel_iud;
SHOW ERRORS;

ALTER TABLE SGAS.CONTACT_RELATIONSHIP ADD (
  CONSTRAINT CONTACT_RELATIONSHIP_pk
 PRIMARY KEY
 (CONTACT_RELATIONSHIP_id)
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
DROP PUBLIC SYNONYM CONTACT_RELATIONSHIP
/
CREATE PUBLIC SYNONYM CONTACT_RELATIONSHIP FOR sgas.CONTACT_RELATIONSHIP
/
DROP SEQUENCE SGAS.CONTACT_RELATIONSHIP_id_seq
/
--
-- CONTACT_RELATIONSHIP_ID_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.CONTACT_RELATIONSHIP_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER SGAS.trig_CONTACT_RELATIONSHIP_seq
   BEFORE INSERT
   ON sgas.CONTACT_RELATIONSHIP
   FOR EACH ROW
BEGIN
   SELECT CONTACT_RELATIONSHIP_id_seq.NEXTVAL
     INTO :NEW.CONTACT_RELATIONSHIP_id
     FROM DUAL;
END;                                                                     

--
-- INSERT DATA
--

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('F', 'FATHER'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('M', 'MOTHER'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('P', 'PARENT'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('G', 'GUARDIAN'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('H', 'HUSBAND'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('W', 'WIFE'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('O', 'OTHER'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('K', 'UNKNOWN'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('T', 'STEPFATHER'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('E', 'STEPMOTHER'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('R', 'GRANDPARENT'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('B', 'BROTHER'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('S', 'SISTER'
            );

INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('U', 'UNCLE'
            );


INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('A', 'AUNT'
            );


INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('N', 'SON'
            );


INSERT INTO CONTACT_RELATIONSHIP
            (reltype, descript
            )
     VALUES ('D', 'DAUGHTER'
            );



COMMIT ;