-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
-- 001      28.02.08   S Durkin (Sopra UK)         Initial Version.
-- 002      11.03.08   R Hunter (SAAS)             Primary key constraint on stud ref removed
-- 003      15.10.09   A.Bowman (SAAS)             Added materialized view log script
-- 004      30.04.10   A.Bowman (SAAS)             Added foreign key references
-- 005      06.10.10   A.Bowman (SAAS)             Amended data synch trigger
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_CONT_DETAILS.sql $
-- $Author: $
-- $Date: 2010-10-06 11:30:47 +0100 (Wed, 06 Oct 2010) $
-- $Revision: 5713 $
--
DROP TABLE SGAS.STUD_CONT_DETAILS CASCADE CONSTRAINTS
/

--
-- STUD_CONT_DETAILS  (Table) 
--
CREATE TABLE SGAS.STUD_CONT_DETAILS
(
  STUD_REF_NO    NUMBER(10)                     NOT NULL,
  CONTACT_IND    NUMBER(1)                      NOT NULL,
  CONT_NAME      VARCHAR2(60 BYTE),
  CONT_POSTCODE  VARCHAR2(8 BYTE),
  CONT_ADDR1     VARCHAR2(60 BYTE),
  CONT_ADDR2     VARCHAR2(60 BYTE),
  CONT_ADDR3     VARCHAR2(60 BYTE),
  CONT_TEL_NO    VARCHAR2(14 BYTE),
  CONT_REL_CODE  VARCHAR2(1 BYTE),
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_STCD_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_STCD_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
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
-- S1_STCD  (Index) 
--
CREATE INDEX S1_STCD ON SGAS.STUD_CONT_DETAILS
 (STUD_REF_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
             INITIAL          500K
            NEXT             512K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

CREATE OR REPLACE TRIGGER sgas.scd_aiu
   AFTER INSERT OR UPDATE OF cont_name,
                             cont_postcode,
                             cont_addr1,
                             cont_addr2,
                             cont_addr3,
                             cont_tel_no,
                             cont_rel_code
   ON sgas.stud_cont_details
   FOR EACH ROW
DECLARE
   p_stud_ref_no     stud_cont_details.stud_ref_no%TYPE   := :OLD.stud_ref_no;
   p_contact_ind     stud_cont_details.contact_ind%TYPE   := :OLD.contact_ind;
   p_cont_name       stud_cont_details.cont_name%TYPE;
   p_cont_postcode   stud_cont_details.cont_postcode%TYPE;
   p_cont_addr1      stud_cont_details.cont_addr1%TYPE;
   p_cont_addr2      stud_cont_details.cont_addr2%TYPE;
   p_cont_addr3      stud_cont_details.cont_addr3%TYPE;
   p_cont_tel_no     stud_cont_details.cont_tel_no%TYPE;
   p_cont_rel_code   stud_cont_details.cont_rel_code%TYPE;
   p_action          VARCHAR2 (1)                           := NULL;

BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_stud_ref_no := :OLD.stud_ref_no;
   END IF;

   IF p_action = 'I'                               
   THEN
      pk_steps_to_grass.update_scd_in_grass (:NEW.stud_ref_no,
                                             :NEW.contact_ind,
                                             :NEW.cont_name,
                                             :NEW.cont_postcode,
                                             :NEW.cont_addr1,
                                             :NEW.cont_addr2,
                                             :NEW.cont_addr3,
                                             :NEW.cont_tel_no,
                                             :NEW.cont_rel_code
                                            );
   ELSIF p_action = 'U'                             
   THEN
      pk_steps_to_grass.update_scd_in_grass (:OLD.stud_ref_no,
                                             :OLD.contact_ind,
                                             :NEW.cont_name,
                                             :NEW.cont_postcode,
                                             :NEW.cont_addr1,
                                             :NEW.cont_addr2,
                                             :NEW.cont_addr3,
                                             :NEW.cont_tel_no,
                                             :NEW.cont_rel_code
                                            );
   END IF;
END scd_aiu;
/

SHOW ERRORS;

ALTER TABLE SGAS.STUD_CONT_DETAILS ADD (
  CONSTRAINT F1_STCD
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));

--
-- STUD_CONT_DETAILS  (Materialized View Log)
--
DROP SNAPSHOT LOG ON STUD_CONT_DETAILS
/
--
-- STUD_CONT_DETAILS  (Materialized View Log) 
--
CREATE MATERIALIZED VIEW LOG ON STUD_CONT_DETAILS
TABLESPACE USERS
PCTUSED    0
PCTFREE    60
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOPARALLEL
WITH ROWID, SEQUENCE
INCLUDING NEW VALUES
/