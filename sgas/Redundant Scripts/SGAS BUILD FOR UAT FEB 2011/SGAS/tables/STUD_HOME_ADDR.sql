-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                      Desc.
-- 001      28.02.08    S.Durkin (Sopra UK)         Initial Version.
-- 002      22.06.09    A.Bowman (SAAS)             Added audit triggers.
-- 003      17.08.09    A.Bowman (SAAS)             Amended trigger sgas.sth_aiu
-- 004      15.10.09    A.Bowman (SAAS)             Added materialized view log script
-- 005      28.01.10    A.Bowman (SAAS)             Amended audit triggers
-- 006      24.03.10    A.Bowman (SAAS)             Amended audit trigger STH_AIU
-- 007      30.04.10    A.Bowman (SAAS)             Added foreign key references
-- 008      06.10.10    A.Bowman (SAAS)             Amended data synch trigger
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_HOME_ADDR.sql $
-- $Author: $
-- $Date: 2011-03-09 11:19:52 +0000 (Wed, 09 Mar 2011) $
-- $Revision: 6619 $


ALTER TABLE SGAS.STUD_HOME_ADDR
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STUD_HOME_ADDR CASCADE CONSTRAINTS
/

--
-- STUD_HOME_ADDR  (Table) 
--
CREATE TABLE SGAS.STUD_HOME_ADDR
(
  STUD_REF_NO    NUMBER(10) CONSTRAINT NN_STH_STUD_REF_NO NOT NULL,
  START_DATE     DATE CONSTRAINT NN_STH_START_DATE NOT NULL,
  OUT_UK         VARCHAR2(1 BYTE),
  HOUSE_NO_NAME  VARCHAR2(32 BYTE) CONSTRAINT NN_STH_HOUSE_NO_NAME NOT NULL,
  ADDR_L1        VARCHAR2(65 BYTE) CONSTRAINT NN_STH_ADDR_L1 NOT NULL,
  ADDR_L2        VARCHAR2(65 BYTE),
  ADDR_L3        VARCHAR2(32 BYTE),
  ADDR_L4        VARCHAR2(32 BYTE),
  POST_CODE      VARCHAR2(8 BYTE),
  ADDR_EASTING   VARCHAR2(6 BYTE),
  ADDR_NORTHING  VARCHAR2(6 BYTE),
  TELE_NO        VARCHAR2(15 BYTE),
  END_DATE       DATE,
  MAILSORT       NUMBER(5),
  LAST_UPDATED_BY    VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_STH_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON    DATE DEFAULT Sysdate CONSTRAINT NN_STH_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
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
-- P_STH  (Index) 
--
CREATE UNIQUE INDEX P_STH ON SGAS.STUD_HOME_ADDR
(STUD_REF_NO, START_DATE)
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

CREATE OR REPLACE TRIGGER SGAS.sth_aiu
   AFTER INSERT OR UPDATE OF out_uk,
                             house_no_name,
                             addr_l1,
                             addr_l2,
                             addr_l3,
                             addr_l4,
                             post_code,
                             addr_easting,
                             addr_northing,
                             tele_no,
                             mailsort
   ON SGAS.STUD_HOME_ADDR    FOR EACH ROW
DECLARE
   p_stud_ref_no     stud_home_addr.stud_ref_no%TYPE     := :OLD.stud_ref_no;
   p_start_date      stud_home_addr.start_date%TYPE      := SYSDATE;
   p_out_uk          stud_home_addr.out_uk%TYPE;
   p_house_no_name   stud_home_addr.house_no_name%TYPE;
   p_addr_l1         stud_home_addr.addr_l1%TYPE;
   p_addr_l2         stud_home_addr.addr_l2%TYPE;
   p_addr_l3         stud_home_addr.addr_l3%TYPE;
   p_addr_l4         stud_home_addr.addr_l4%TYPE;
   p_post_code       stud_home_addr.post_code%TYPE;
   p_addr_easting    stud_home_addr.addr_easting%TYPE;
   p_addr_northing   stud_home_addr.addr_northing%TYPE;
   p_tele_no         stud_home_addr.tele_no%TYPE;
   p_end_date        stud_home_addr.end_date%TYPE        := NULL;
   p_mailsort        stud_home_addr.mailsort%TYPE;
   p_action          VARCHAR2 (1)                        := NULL;
   v_ben1            VARCHAR2 (1)                        := NULL;
   v_ben2            VARCHAR2 (1)                        := NULL;
BEGIN
   -- dbms_output.put_line('*******TRIGGER1 HAS FIRED*******');
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
      pk_steps_to_grass.update_sha_in_grass (:NEW.stud_ref_no,
                                             :NEW.start_date,
                                             :NEW.out_uk,
                                             :NEW.house_no_name,
                                             :NEW.addr_l1,
                                             :NEW.addr_l2,
                                             :NEW.addr_l3,
                                             :NEW.addr_l4,
                                             :NEW.post_code,
                                             :NEW.addr_easting,
                                             :NEW.addr_northing,
                                             :NEW.tele_no,
                                             :NEW.end_date,
                                             :NEW.mailsort
                                            );
   END IF;

--    dbms_output.put_line('*******TRIGGER2 HAS FIRED*******');

   /* Re-send student to the SLC */
   UPDATE stud_crse_year
      SET slc1_sent = 'N',
          slc2_sent = 'N'
    WHERE stud_crse_year_id =
             (SELECT MAX (stud_crse_year_id)
                FROM stud_crse_year
               WHERE stud_ref_no = :NEW.stud_ref_no
                 AND latest_crse_ind = 'Y'
                 AND first_slc1_sent_date IS NOT NULL);

   /* issue a new award letter */
   UPDATE stud_crse_year
      SET sal_sent = 'N',
          req_dup = 'Y'
    WHERE stud_crse_year_id =
             (SELECT MAX (stud_crse_year_id)
                FROM stud_crse_year
               WHERE stud_ref_no = :NEW.stud_ref_no
                 AND latest_crse_ind = 'Y'
                 AND sal_sent_date IS NOT NULL);

--   dbms_output.put_line('*******TRIGGER3 HAS FIRED*******');
   SELECT apply_to_ben_1, apply_to_ben_2
     INTO v_ben1, v_ben2
     FROM home_addr_change@web x
    WHERE stud_ref_no = :NEW.stud_ref_no
      AND TRUNC (change_date) = TRUNC (SYSDATE)
      AND change_date = (SELECT MAX (change_date)
                           FROM home_addr_change@web
                          WHERE stud_ref_no = :NEW.stud_ref_no);

   IF v_ben1 = 'Y'
   THEN
      UPDATE benefactor
         SET house_no_name = :NEW.house_no_name,
             addr_l1 = :NEW.addr_l1,
             addr_l2 = :NEW.addr_l2,
             addr_l3 = :NEW.addr_l3,
             addr_l4 = :NEW.addr_l4,
             post_code = :NEW.post_code,
             mailsort = :NEW.mailsort
       WHERE ben_id = (SELECT MAX (ben1_id)
                         FROM stud_session
                        WHERE stud_ref_no = :NEW.stud_ref_no);
   END IF;

   IF v_ben2 = 'Y'
   THEN
      UPDATE benefactor
         SET house_no_name = :NEW.house_no_name,
             addr_l1 = :NEW.addr_l1,
             addr_l2 = :NEW.addr_l2,
             addr_l3 = :NEW.addr_l3,
             addr_l4 = :NEW.addr_l4,
             post_code = :NEW.post_code,
             mailsort = :NEW.mailsort
       WHERE ben_id = (SELECT MAX (ben2_id)
                         FROM stud_session
                        WHERE stud_ref_no = :NEW.stud_ref_no);
   END IF;
--   dbms_output.put_line('*******TRIGGER4 HAS FIRED*******');
EXCEPTION
   WHEN OTHERS
   THEN
      v_ben1 := 'N';
      v_ben2 := 'N';
END sth_aiu;

SHOW ERRORS;

CREATE OR REPLACE TRIGGER SGAS.sthome_iud
   AFTER INSERT OR DELETE OR UPDATE OF addr_l1,
                                       addr_l2,
                                       addr_l3,
                                       addr_l4,
                                       house_no_name,
                                       post_code,
                                       tele_no,
                                       last_updated_by
   ON SGAS.STUD_HOME_ADDR    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                                   := SYSDATE;
   p_column_name    stud_home_addr_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_home_addr_aud.table_pkey1%TYPE   := :OLD.stud_ref_no;
   p_table_pkey2    stud_home_addr_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_home_addr_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_home_addr_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_home_addr_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_home_addr_aud.OLD%TYPE            := NULL;
   p_new            stud_home_addr_aud.NEW%TYPE            := NULL;
   p_action         stud_home_addr_aud.action%TYPE         := NULL;
   p_username       stud_home_addr_aud.username%TYPE       := :NEW.last_updated_by;
   p_stud_ref_no    stud_home_addr_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_home_addr_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_home_addr_aud.session_code%TYPE   := NULL;
   p_table_name     VARCHAR2 (32)                         := 'STUD_HOME_ADDR';
   v_updated        VARCHAR2 (1)                           := 'N';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_ref_no;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'HOUSE_NO_NAME';
   p_old := :OLD.house_no_name;
   p_new := :NEW.house_no_name;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.house_no_name, 'BLANK') <> NVL (:NEW.house_no_name, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_ADDR_L1';
   p_old := :OLD.addr_l1;
   p_new := :NEW.addr_l1;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.addr_l1, 'BLANK') <> NVL (:NEW.addr_l1, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_ADDR_L2';
   p_old := :OLD.addr_l2;
   p_new := :NEW.addr_l2;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.addr_l2, 'BLANK') <> NVL (:NEW.addr_l2, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_ADDR_L3';
   p_old := :OLD.addr_l3;
   p_new := :NEW.addr_l3;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.addr_l3, 'BLANK') <> NVL (:NEW.addr_l3, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_ADDR_L4';
   p_old := :OLD.addr_l4;
   p_new := :NEW.addr_l4;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.addr_l4, 'BLANK') <> NVL (:NEW.addr_l4, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_POST_CODE';
   p_old := :OLD.post_code;
   p_new := :NEW.post_code;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.post_code, 'BLANK') <> NVL (:NEW.post_code, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_TELE_NO';
   p_old := :OLD.tele_no;
   p_new := :NEW.tele_no;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.tele_no, 0) <> NVL (:NEW.tele_no, 0)
   THEN
      v_updated := 'Y';
   END IF;

   IF v_updated = 'Y'
   THEN
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   END IF;
END sthome_iud;
SHOW ERRORS;

-- 
-- Non Foreign Key Constraints for Table STUD_HOME_ADDR 
-- 

ALTER TABLE SGAS.STUD_HOME_ADDR ADD (
  CONSTRAINT STH_OUT_UK
 CHECK ( OUT_UK IN('Y','N')))
/

ALTER TABLE SGAS.STUD_HOME_ADDR ADD (
  CONSTRAINT P_STH
 PRIMARY KEY
 (STUD_REF_NO, START_DATE)
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

--
-- Foreign Key Constraint for STUD_HOME_ADDR Table
--

ALTER TABLE SGAS.STUD_HOME_ADDR ADD (
  CONSTRAINT F1_STHA
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));

--
-- STUD_HOME_ADDR  (Materialized View Log)
--
DROP SNAPSHOT LOG ON STUD_HOME_ADDR
/
--
-- STUD_HOME_ADDR  (Materialized View Log) 
--
CREATE MATERIALIZED VIEW LOG ON STUD_HOME_ADDR
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