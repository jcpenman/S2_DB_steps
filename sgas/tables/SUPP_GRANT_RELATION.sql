-- SUPP_GRANT_RELATION.sql
-- Description: Table holding all SUPP_GRANT_RELATIONs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      14.06.09    R Hunter (SAAS)         Initial Version.
-- 1.1      30.06.09    A.Bowman (SAAS)         Amended audit triggers.
-- 1.2      29.07.09    R.Hunter (SAAS)         Amended data list at script end
-- 1.3      28.01.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.supp_grant_relation
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.supp_grant_relation CASCADE CONSTRAINTS PURGE
/
--
-- SUPP_GRANT_RELATION  (Table) 
--
CREATE TABLE sgas.supp_grant_relation
(
  supp_grant_relation_id      NUMBER(10)       NOT NULL,
  legacy_id                   NUMBER(4) NOT NULL,
  legacy_code                 VARCHAR2(4 BYTE) NOT NULL,
  descript                    VARCHAR2(1000 BYTE) NOT NULL,
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

COMMENT ON COLUMN sgas.supp_grant_relation.supp_grant_relation_id IS 'Unique SUPP_GRANT_RELATION reference number';

COMMENT ON COLUMN sgas.supp_grant_relation.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.supp_grant_relation.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.supp_grant_relation.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.supp_grant_relation.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX supp_grant_relation_pk ON sgas.supp_grant_relation
(supp_grant_relation_id)
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


CREATE OR REPLACE TRIGGER SGAS.supp_grant_rel_iud
   AFTER INSERT OR DELETE OR UPDATE OF supp_grant_relation_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.SUPP_GRANT_RELATION    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    supp_grant_relation_aud.column_name%TYPE    := NULL;
   p_table_pkey1    supp_grant_relation_aud.table_pkey1%TYPE
                                               := :OLD.supp_grant_relation_id;
   p_table_pkey2    supp_grant_relation_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    supp_grant_relation_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    supp_grant_relation_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    supp_grant_relation_aud.table_pkey5%TYPE    := NULL;
   p_old            supp_grant_relation_aud.OLD%TYPE            := NULL;
   p_new            supp_grant_relation_aud.NEW%TYPE            := NULL;
   p_action         supp_grant_relation_aud.action%TYPE         := NULL;
   p_username       supp_grant_relation_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    supp_grant_relation_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      supp_grant_relation_aud.inst_code%TYPE      := NULL;
   p_session_code   supp_grant_relation_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.supp_grant_relation_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.supp_grant_relation_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'SUPP_GRANT_RELATION_ID';
   p_old := :OLD.supp_grant_relation_id;
   p_new := :NEW.supp_grant_relation_id;
   pk_steps_aud.ins_sup_gra_rel_aud (p_aud_date,
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
   p_column_name := 'LEGACY_ID';
   p_old := TO_CHAR (:OLD.legacy_id);
   p_new := TO_CHAR (:NEW.legacy_id);
   pk_steps_aud.ins_sup_gra_rel_aud (p_aud_date,
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
   p_column_name := 'LEGACY_CODE';
   p_old := TO_CHAR (:OLD.legacy_code);
   p_new := TO_CHAR (:NEW.legacy_code);
   pk_steps_aud.ins_sup_gra_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_sup_gra_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_sup_gra_rel_aud (p_aud_date,
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
END supp_grant_rel_iud;
SHOW ERRORS;

ALTER TABLE sgas.supp_grant_relation ADD (
  CONSTRAINT supp_grant_relation_pk
 PRIMARY KEY
 (supp_grant_relation_id)
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
DROP PUBLIC SYNONYM supp_grant_relation
/
CREATE PUBLIC SYNONYM supp_grant_relation FOR sgas.supp_grant_relation
/
DROP SEQUENCE sgas.supp_grant_relation_id_seq
/
--
-- SUPP_GRANT_RELATION_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.supp_grant_relation_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_supp_grant_relation_seq
   BEFORE INSERT
   ON sgas.supp_grant_relation
   FOR EACH ROW
BEGIN
   SELECT supp_grant_relation_id_seq.NEXTVAL
     INTO :NEW.supp_grant_relation_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--


INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (46, 'H', 'SON'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (47, 'H', 'DAUGHTER'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (510, 'H', 'STEPSON'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (511, 'H', 'STEPDAUGHTER'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (600, 'H', 'BROTHER(CHILD)'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (601, 'H', 'SISTER(CHILD)'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (602, 'H', 'NEPHEW(CHILD)'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (603, 'H', 'NIECE(CHILD)'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (705, 'H', 'OTHER'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (34, 'U', 'BROTHER(ADULT)'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (35, 'U', 'SISTER(ADULT)'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (36, 'U', 'FATHER'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (37, 'U', 'MOTHER'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (38, 'U', 'AUNT'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (39, 'U', 'UNCLE'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (40, 'U', 'GRANDFATHER'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (41, 'U', 'GRANDMOTHER'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (42, 'U', 'STEPFATHER'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (43, 'U', 'STEPMOTHER'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (48, 'U', 'SPOUSE'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (49, 'U', 'OTHER(ADULT)'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (508, 'U', 'NIECE(ADULT)'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (509, 'U', 'NEPHEW(ADULT)'
            );
INSERT INTO supp_grant_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (650, 'U', 'STEP UNCLE'
            );



COMMIT ;