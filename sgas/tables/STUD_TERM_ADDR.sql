-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                      Desc.
-- 001      28.02.08   S Durkin (Sopra UK)         Initial Version.
-- 002      27.08.09   A.Bowman (SAAS)             Added new triggers stt_iud and stt_lub to meet History requirements
-- 003      15.10.09   A.Bowman (SAAS)             Added materialized view log script
-- 004      28.01.10   A.Bowman (SAAS)             Amended audit triggers
-- 005      30.04.10   A.Bowman (SAAS)             Added foreign key references
-- 006      12.10.10   A.Bowman (SAAS)             Amended data synch trigger
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_TERM_ADDR.sql $
-- $Author: $
-- $Date: 2011-07-19 13:05:27 +0100 (Tue, 19 Jul 2011) $
-- $Revision: 7177 $


ALTER TABLE SGAS.STUD_TERM_ADDR
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STUD_TERM_ADDR CASCADE CONSTRAINTS
/

--
-- STUD_TERM_ADDR  (Table) 
--
CREATE TABLE SGAS.STUD_TERM_ADDR
(
  STUD_REF_NO    NUMBER(10) CONSTRAINT NN_STT_STUD_REF_NO NOT NULL,
  START_DATE     DATE CONSTRAINT NN_STT_START_DATE NOT NULL,
  LOCATION_IND   VARCHAR2(1 BYTE) CONSTRAINT NN_STT_LOCATION_IND NOT NULL,
  RESIDENCE_IND  VARCHAR2(1 BYTE) CONSTRAINT NN_STT_RESIDENCE_IND NOT NULL,
  HOUSE_NO_NAME  VARCHAR2(32 BYTE) CONSTRAINT NN_STT_HOUSE_NO_NAME NOT NULL,
  ADDR_L1        VARCHAR2(65 BYTE) CONSTRAINT NN_STT_ADDR_L1 NOT NULL,
  ADDR_L2        VARCHAR2(65 BYTE),
  ADDR_L3        VARCHAR2(32 BYTE),
  ADDR_L4        VARCHAR2(32 BYTE),
  POST_CODE      VARCHAR2(8 BYTE),
  ADDR_EASTING   VARCHAR2(6 BYTE),
  ADDR_NORTHING  VARCHAR2(6 BYTE),
  TELE_NO        VARCHAR2(15 BYTE),
  END_DATE       DATE,
  MAILSORT       NUMBER(5),
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_STT_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_STT_LAST_UPDATED_ON NOT NULL
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
-- P_STT  (Index) 
--
CREATE UNIQUE INDEX P_STT ON SGAS.STUD_TERM_ADDR
(STUD_REF_NO, START_DATE)
LOGGING
TABLESPACE USERS
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
NOPARALLEL
/


-- 
-- Non Foreign Key Constraints for Table STUD_TERM_ADDR 
-- 
ALTER TABLE SGAS.STUD_TERM_ADDR ADD (
  CONSTRAINT STT_RESIDENCE_IND
 CHECK ( RESIDENCE_IND IN('P','H','O','R','X')))
/

ALTER TABLE SGAS.STUD_TERM_ADDR ADD (
  CONSTRAINT STT_LOCATION_IND
 CHECK (location_ind in ('H','E','L','O','W')))
/

ALTER TABLE SGAS.STUD_TERM_ADDR ADD (
  CONSTRAINT P_STT
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
-- Foreign Key Constraints for Table STUD_TERM_ADDR 
--

ALTER TABLE SGAS.STUD_TERM_ADDR ADD (
  CONSTRAINT F1_STTA
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));

/* Formatted on 2011/06/07 10:30 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER sgas.stt_iud
   AFTER INSERT OR DELETE OR UPDATE OF location_ind,
                                       house_no_name,
                                       addr_l1,
                                       addr_l2,
                                       addr_l3,
                                       addr_l4,
                                       post_code,
                                       tele_no,
                                       end_date,
                                       mailsort,
                                       last_updated_by
   ON sgas.stud_term_addr
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                                   := SYSDATE;
   p_column_name    stud_term_addr_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_term_addr_aud.table_pkey1%TYPE
                                                := TO_CHAR (:OLD.stud_ref_no);
   p_table_pkey2    stud_term_addr_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_term_addr_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_term_addr_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_term_addr_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_term_addr_aud.OLD%TYPE            := NULL;
   p_new            stud_term_addr_aud.NEW%TYPE            := NULL;
   p_action         stud_term_addr_aud.action%TYPE         := NULL;
   p_username       stud_term_addr_aud.username%TYPE  := :NEW.last_updated_by;
   p_stud_ref_no    stud_term_addr_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_term_addr_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_term_addr_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.stud_ref_no;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'LOCATION_IND';
   p_old := :OLD.location_ind;
   p_new := :NEW.location_ind;
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
   p_column_name := 'HOUSE_NO_NAME';
   p_old := :OLD.house_no_name;
   p_new := :NEW.house_no_name;
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
   p_column_name := 'ADDR_L1';
   p_old := :OLD.addr_l1;
   p_new := :NEW.addr_l1;
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
   p_column_name := 'ADDR_L2';
   p_old := :OLD.addr_l2;
   p_new := :NEW.addr_l2;
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
   p_column_name := 'ADDR_L3';
   p_old := :OLD.addr_l3;
   p_new := :NEW.addr_l3;
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
   p_column_name := 'ADDR_L4';
   p_old := :OLD.addr_l4;
   p_new := :NEW.addr_l4;
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
   p_column_name := 'POST_CODE';
   p_old := :OLD.post_code;
   p_new := :NEW.post_code;
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
   p_column_name := 'TELE_NO';
   p_old := :OLD.tele_no;
   p_new := :NEW.tele_no;
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
   p_column_name := 'END_DATE';
   p_old := :OLD.end_date;
   p_new := :NEW.end_date;
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
   p_column_name := 'MAILSORT';
   p_old := :OLD.mailsort;
   p_new := :NEW.mailsort;
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
END stt_iud;
SHOW ERRORS;

CREATE OR REPLACE TRIGGER SGAS.stt_aiu
   AFTER INSERT OR UPDATE OF location_ind,
                             residence_ind,
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
   ON SGAS.STUD_TERM_ADDR    FOR EACH ROW
DECLARE
   p_stud_ref_no     stud_term_addr.stud_ref_no%TYPE     := :OLD.stud_ref_no;
   p_start_date      stud_term_addr.start_date%TYPE      := SYSDATE;
   p_location_ind    stud_term_addr.location_ind%TYPE;
   p_residence_ind   stud_term_addr.residence_ind%TYPE;
   p_house_no_name   stud_term_addr.house_no_name%TYPE;
   p_addr_l1         stud_term_addr.addr_l1%TYPE;
   p_addr_l2         stud_term_addr.addr_l2%TYPE;
   p_addr_l3         stud_term_addr.addr_l3%TYPE;
   p_addr_l4         stud_term_addr.addr_l4%TYPE;
   p_post_code       stud_term_addr.post_code%TYPE;
   p_addr_easting    stud_term_addr.addr_easting%TYPE;
   p_addr_northing   stud_term_addr.addr_northing%TYPE;
   p_tele_no         stud_term_addr.tele_no%TYPE;
   p_end_date        stud_term_addr.end_date%TYPE        := NULL;
   p_mailsort        stud_term_addr.mailsort%TYPE;
   p_action          VARCHAR2 (1)                        := NULL;
   v_to_from_pfg     VARCHAR2 (1)                        := NULL;
   v_session_code    stud_crse_year.session_code%TYPE;
 
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
      pk_steps_to_grass.update_stt_in_grass (:NEW.stud_ref_no,
                                             :NEW.start_date,
                                             :NEW.location_ind,
                                             :NEW.residence_ind,
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
   ELSIF p_action = 'U'
   THEN
      pk_steps_to_grass.update_stt_in_grass (:OLD.stud_ref_no,
                                             :NEW.start_date,
                                             :NEW.location_ind,
                                             :NEW.residence_ind,
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
   

   --  dbms_output.put_line('*******TRIGGER0 HAS FIRED*******');
    /* Get session_code for Awards_Recalc */
    /*This functionality is no longer required*/
   /*SELECT MAX (session_code)
     INTO v_session_code
     FROM stud_crse_year
    WHERE stud_crse_year_id =
             (SELECT MAX (stud_crse_year_id)
                FROM stud_crse_year
               WHERE stud_ref_no = :NEW.stud_ref_no
                 AND latest_crse_ind = 'Y'
                 AND first_slc1_sent_date IS NOT NULL);*/

   --   dbms_output.put_line('*******TRIGGER1 HAS FIRED*******');

   /*Check web change to see if move is from parents address*/
   SELECT to_from_parents_fg
     INTO v_to_from_pfg
     FROM term_addr_change@web x
    WHERE stud_ref_no = :NEW.stud_ref_no
      AND TRUNC (change_date) = TRUNC (SYSDATE)
      AND change_date = (SELECT MAX (change_date)
                           FROM term_addr_change@web
                          WHERE stud_ref_no = :NEW.stud_ref_no);

   --   dbms_output.put_line('*******TRIGGER2 HAS FIRED*******');
   IF v_to_from_pfg = 'Y'
   THEN
      --     dbms_output.put_line('*******TRIGGER3 HAS FIRED*******');
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

      --          dbms_output.put_line('*******TRIGGER4 HAS FIRED*******');

      /*001 - Recalculate award */
      /* This functionality is no longer required 
      IF v_session_code <> 0
      THEN
         --     dbms_output.put_line('*******TRIGGER5 HAS FIRED*******');
         INSERT INTO awards_recalc
                     (awards_recalc_id, stud_ref_no,
                      session_code, processed_flag, created_date, user_id
                     )
              VALUES (awards_recalc_id_seq.NEXTVAL, :NEW.stud_ref_no,
                      v_session_code, 'N', SYSDATE, USER
                     );
      END IF;*/

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
   --    dbms_output.put_line('*******TRIGGER6 HAS FIRED*******');
   ELSIF v_to_from_pfg = 'N'
   THEN
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
   --    dbms_output.put_line('*******TRIGGER7 HAS FIRED*******');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      v_to_from_pfg := 'N';
END stt_aiu;
SHOW ERRORS;

CREATE OR REPLACE TRIGGER SGAS.STTERM_UD
 AFTER
 INSERT OR DELETE OR UPDATE OF ADDR_L1, ADDR_L2, ADDR_L3, ADDR_L4, HOUSE_NO_NAME, POST_CODE
 ON SGAS.STUD_TERM_ADDR  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
    P_TABLE_NAME         VARCHAR2(32)         := 'STUD_TERM_ADDR';
    P_COLUMN_NAME       VARCHAR2(32)        := NULL;
    P_OLD            STUD_AUD.OLD%TYPE        := NULL;
    P_ACTION        STUD_AUD.ACTION%TYPE        := NULL;
    P_NEW            STUD_AUD.NEW%TYPE        := NULL;
    P_STUD_REF_NO        STUD_AUD.STUD_REF_NO%TYPE    := :OLD.STUD_REF_NO;
    v_updated VARCHAR2(1) := 'N';
BEGIN
P_ACTION    := 'U';
IF INSERTING THEN
    P_STUD_REF_NO := :NEW.STUD_REF_NO;
    Telephony_Support.UPDATE_TELE(P_STUD_REF_NO, P_ACTION, P_TABLE_NAME);
ELSIF UPDATING THEN
    --
    P_COLUMN_NAME     := 'TERM_HOUSE_NO';
    P_OLD        := :OLD.HOUSE_NO_NAME;
    p_NEW        := :NEW.HOUSE_NO_NAME;
    IF :OLD.HOUSE_NO_NAME <> :NEW.HOUSE_NO_NAME THEN
        v_updated := 'Y';
    END IF;
    --
    P_COLUMN_NAME     := 'TERM_ADDR_L1';
    P_OLD        := :OLD.ADDR_L1;
    p_NEW        := :NEW.ADDR_L1;
    IF :OLD.ADDR_L1 <> :NEW.ADDR_L1 THEN
        v_updated := 'Y';
    END IF;
    --
    P_COLUMN_NAME     := 'TERM_ADDR_L2';
    P_OLD        := :OLD.ADDR_L2;
    p_NEW        := :NEW.ADDR_L2;
    IF NVL(:OLD.ADDR_L2,'BLANK') <> NVL(:NEW.ADDR_L2,'BLANK') THEN
        v_updated := 'Y';
    END IF;
    --
    P_COLUMN_NAME     := 'TERM_ADDR_L3';
    P_OLD        := :OLD.ADDR_L3;
    p_NEW        := :NEW.ADDR_L3;
    IF NVL(:OLD.ADDR_L3,'BLANK') <> NVL(:NEW.ADDR_L3,'BLANK') THEN
        v_updated := 'Y';
    END IF;
    --
    P_COLUMN_NAME     := 'TERM_ADDR_L4';
    P_OLD        := :OLD.ADDR_L4;
    p_NEW        := :NEW.ADDR_L4;
    IF NVL(:OLD.ADDR_L4,'BLANK') <> NVL(:NEW.ADDR_L4,'BLANK') THEN
        v_updated := 'Y';
    END IF;
    --
    P_COLUMN_NAME     := 'TERM_POST_CODE';
    P_OLD        := :OLD.POST_CODE;
    p_NEW        := :NEW.POST_CODE;
    IF NVL(:OLD.POST_CODE,'BLANK') <> NVL(:NEW.POST_CODE,'BLANK') THEN
        v_updated := 'Y';
    END IF;
    --
    IF v_updated = 'Y' THEN
     Telephony_Support.UPDATE_TELE(P_STUD_REF_NO, P_ACTION, P_TABLE_NAME);
    END IF;
END IF;
END STTERM_UD;
/
SHOW ERRORS;

/*--
-- STUD_TERM_ADDR  (Materialized View Log)
--
DROP SNAPSHOT LOG ON STUD_TERM_ADDR
/
--
-- STUD_TERM_ADDR  (Materialized View Log) 
--
CREATE MATERIALIZED VIEW LOG ON STUD_TERM_ADDR
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
/*