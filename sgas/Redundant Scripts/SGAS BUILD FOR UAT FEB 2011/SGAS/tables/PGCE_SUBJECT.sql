-- PGCE_SUBJECT.sql
-- Description: Table holding all PGCE_SUBJECTs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      14.06.09    R Hunter (SAAS)         Initial Version.
-- 1.1      30.06.09    A.Bowman (SAAS)         Amended audit triggers.
-- 1.2      28.01.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.pgce_subject
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.pgce_subject CASCADE CONSTRAINTS
/
--
-- PGCE_SUBJECT  (Table) 
--
CREATE TABLE sgas.pgce_subject
(
  pgce_subject_id      NUMBER(10)       NOT NULL,
  legacy_id                   NUMBER(4) NOT NULL,
  legacy_code                 VARCHAR2(40 BYTE) NOT NULL,
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

COMMENT ON COLUMN sgas.pgce_subject.pgce_subject_id IS 'Unique PGCE_SUBJECT reference number';

COMMENT ON COLUMN sgas.pgce_subject.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.pgce_subject.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.pgce_subject.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.pgce_subject.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX pgce_subject_pk ON sgas.pgce_subject
(pgce_subject_id)
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



CREATE OR REPLACE TRIGGER SGAS.pgce_sub_iud
   AFTER INSERT OR DELETE OR UPDATE OF PGCE_SUBJECT_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.PGCE_SUBJECT    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    PGCE_SUBJECT_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PGCE_SUBJECT_aud.table_pkey1%TYPE
                                               := :OLD.PGCE_SUBJECT_id;
   p_table_pkey2    PGCE_SUBJECT_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PGCE_SUBJECT_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PGCE_SUBJECT_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PGCE_SUBJECT_aud.table_pkey5%TYPE    := NULL;
   p_old            PGCE_SUBJECT_aud.OLD%TYPE            := NULL;
   p_new            PGCE_SUBJECT_aud.NEW%TYPE            := NULL;
   p_action         PGCE_SUBJECT_aud.action%TYPE         := NULL;
   p_username       PGCE_SUBJECT_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PGCE_SUBJECT_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PGCE_SUBJECT_aud.inst_code%TYPE      := NULL;
   p_session_code   PGCE_SUBJECT_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.PGCE_SUBJECT_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.PGCE_SUBJECT_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'PGCE_SUBJECT_ID';
   p_old := :OLD.PGCE_SUBJECT_id;
   p_new := :NEW.PGCE_SUBJECT_id;
   pk_steps_aud.ins_pgce_sub_aud (p_aud_date,
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
   pk_steps_aud.ins_pgce_sub_aud (p_aud_date,
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
   pk_steps_aud.ins_pgce_sub_aud (p_aud_date,
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
   pk_steps_aud.ins_pgce_sub_aud (p_aud_date,
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
   pk_steps_aud.ins_pgce_sub_aud (p_aud_date,
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
END pgce_sub_iud;
SHOW ERRORS;

ALTER TABLE sgas.pgce_subject ADD (
  CONSTRAINT pgce_subject_pk
 PRIMARY KEY
 (pgce_subject_id)
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
DROP PUBLIC SYNONYM pgce_subject
/
CREATE PUBLIC SYNONYM pgce_subject FOR sgas.pgce_subject
/
DROP SEQUENCE sgas.pgce_subject_id_seq
/
--
-- PGCE_SUBJECT_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.pgce_subject_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_pgce_subject_seq
   BEFORE INSERT
   ON sgas.pgce_subject
   FOR EACH ROW
BEGIN
   SELECT pgce_subject_id_seq.NEXTVAL
     INTO :NEW.pgce_subject_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'ENGLISH', 'ENGLISH'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'HISTORY', 'HISTORY'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'LAW', 'LAW'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'PHILOSOPHY', 'PHILOSOPHY'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'LITERATURE', 'LITERATURE'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'LINGUISTICS', 'LINGUISTICS'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'FILM AND THEATRE', 'FILM AND THEATRE'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'ART HISTORY', 'ART HISTORY'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'ARCHAEOLOGY', 'ARCHAEOLOGY'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'CLASSICS', 'CLASSICS'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'THEOLOGY', 'THEOLOGY'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'MUSIC', 'MUSIC'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'PUBLISHING STUDIES', 'PUBLISHING STUDIES'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'FRENCH', 'FRENCH'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'GERMAN', 'GERMAN'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'ITALIAN', 'ITALIAN'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'HISPANIC STUDIES', 'HISPANIC STUDIES'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'JAPANESE', 'JAPANESE'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'EUROPEAN STUDIES', 'EUROPEAN STUDIES'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'ART AND DESIGN', 'ART AND DESIGN'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'CELTIC/IRISH', 'CELTIC/IRISH'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'RUSSIAN', 'RUSSIAN'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'SCOTTISH STUDIES', 'SCOTTISH STUDIES'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'HUMAN RIGHTS', 'HUMAN RIGHTS'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'ORIENTAL STUDIES', 'ORIENTAL STUDIES'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'ARCHITECTURE', 'ARCHITECTURE'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'SLAVONIC', 'SLAVONIC'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'SPANISH', 'SPANISH'
            );
INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'AGRICULTURE', 'AGRICULTURE'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'ALLIED TO MEDICINE', 'ALLIED TO MEDICINE'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code,
             descript
            )
     VALUES (0, 'ARCHITECTURE,BUILDING AND PLANNING',
             'ARCHITECTURE,BUILDING AND PLANNING'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'BIOLOGICAL SCIENCES', 'BIOLOGICAL SCIENCES'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code,
             descript
            )
     VALUES (0, 'BUSINESS AND ADMINISTRATIVE STUDIES',
             'BUSINESS AND ADMINISTRATIVE STUDIES'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'CATERING', 'CATERING'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'COMBINED OR GENERAL', 'COMBINED OR GENERAL'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'CREATIVE ARTS', 'CREATIVE ARTS'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'DENTISTRY', 'DENTISTRY'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'EDUCATION', 'EDUCATION'
            );


INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'ENGINEERING AND TECHNOLOGY', 'ENGINEERING AND TECHNOLOGY'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'HUMANITIES', 'HUMANITIES'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'LANGUAGES', 'LANGUAGES'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'LEISURE', 'LEISURE'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code,
             descript
            )
     VALUES (0, 'MASS COMMUNICATIONS AND DOCUMENTATION',
             'MASS COMMUNICATIONS AND DOCUMENTATION'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code,
             descript
            )
     VALUES (0, 'MATHEMATICAL SCIENCES AND INFORMATICS',
             'MATHEMATICAL SCIENCES AND INFORMATICS'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'MEDICINE', 'MEDICINE'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'PHYSICAL SCIENCES', 'PHYSICAL SCIENCES'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'SOCIAL STUDIES', 'SOCIAL STUDIES'
            );

INSERT INTO pgce_subject
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'OTHER', 'OTHER'
            );



COMMIT ;