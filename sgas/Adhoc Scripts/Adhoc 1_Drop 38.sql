CREATE OR REPLACE TRIGGER SGAS.sthome_iud
   AFTER INSERT OR DELETE OR UPDATE OF addr_l1,
                                       addr_l2,
                                       addr_l3,
                                       addr_l4,
                                       house_no_name,
                                       post_code,
                                       tele_no,
                                       end_date,
                                       mailsort,
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
   p_column_name := 'END_DATE';
   p_old := :OLD.end_date;
   p_new := :NEW.end_date;
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
   p_column_name := 'MAILSORT';
   p_old := :OLD.mailsort;
   p_new := :NEW.mailsort;
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

DROP TABLE SGAS.BANK_CHANGE_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.BANK_CHANGE_EXC
(
  STUD_REF_NO       NUMBER(10)                  NOT NULL,
  CHANGE_DATE       DATE                        NOT NULL,
  NAME              VARCHAR2(25 BYTE),
  BUILDING_NO_NAME  VARCHAR2(32 BYTE),
  ADDR_L1           VARCHAR2(65 BYTE),
  ADDR_L2           VARCHAR2(65 BYTE),
  ADDR_L3           VARCHAR2(32 BYTE),
  ADDR_L4           VARCHAR2(32 BYTE),
  POST_CODE         VARCHAR2(8 BYTE),
  ACCOUNT_NO        VARCHAR2(10 BYTE)           NOT NULL,
  SORT_CODE         VARCHAR2(6 BYTE)            NOT NULL,
  BANK_VALIDATE     VARCHAR2(1 BYTE),
  SQLCODE           VARCHAR2(25 BYTE),
  SQLERRM           VARCHAR2(100 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE SGAS.EMAIL_MPHONE_CHANGE_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.EMAIL_MPHONE_CHANGE_EXC
(
  STUD_REF_NO  NUMBER(10)                       NOT NULL,
  CHANGE_DATE  DATE                             NOT NULL,
  NEW_EMAIL    VARCHAR2(80 BYTE),
  NEW_PHONE    VARCHAR2(14 BYTE),
  SQLCODE      VARCHAR2(25 BYTE),
  SQLERRM      VARCHAR2(100 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16K
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


DROP TABLE SGAS.HOME_ADDR_CHANGE_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.HOME_ADDR_CHANGE_EXC
(
  STUD_REF_NO     NUMBER(10)                    NOT NULL,
  CHANGE_DATE     DATE                          NOT NULL,
  HOUSE_NO_NAME   VARCHAR2(32 BYTE)             NOT NULL,
  ADDR_L1         VARCHAR2(65 BYTE)             NOT NULL,
  ADDR_L2         VARCHAR2(65 BYTE),
  ADDR_L3         VARCHAR2(32 BYTE),
  ADDR_L4         VARCHAR2(32 BYTE),
  POST_CODE       VARCHAR2(8 BYTE),
  APPLY_TO_BEN_1  VARCHAR2(1 BYTE),
  APPLY_TO_BEN_2  VARCHAR2(1 BYTE),
  MAILSORT_CODE   VARCHAR2(5 BYTE),
  SQLCODE         VARCHAR2(25 BYTE),
  SQLERRM         VARCHAR2(100 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE SGAS.LOAN_CONTACTS_CHANGE_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.LOAN_CONTACTS_CHANGE_EXC
(
  STUD_REF_NO      NUMBER(10)                   NOT NULL,
  CHANGE_DATE      DATE                         NOT NULL,
  NAME_1           VARCHAR2(60 BYTE)            NOT NULL,
  HOUSE_NO_NAME_1  VARCHAR2(32 BYTE)            NOT NULL,
  ADDR_L1_1        VARCHAR2(65 BYTE)            NOT NULL,
  ADDR_L2_1        VARCHAR2(65 BYTE),
  ADDR_L3_1        VARCHAR2(32 BYTE),
  ADDR_L4_1        VARCHAR2(32 BYTE),
  POST_CODE_1      VARCHAR2(8 BYTE),
  TEL_NO_1         VARCHAR2(14 BYTE),
  REL_CODE_1       VARCHAR2(1 BYTE)             NOT NULL,
  NAME_2           VARCHAR2(60 BYTE)            NOT NULL,
  HOUSE_NO_NAME_2  VARCHAR2(32 BYTE)            NOT NULL,
  ADDR_L1_2        VARCHAR2(65 BYTE)            NOT NULL,
  ADDR_L2_2        VARCHAR2(65 BYTE),
  ADDR_L3_2        VARCHAR2(32 BYTE),
  ADDR_L4_2        VARCHAR2(32 BYTE),
  POST_CODE_2      VARCHAR2(8 BYTE),
  TEL_NO_2         VARCHAR2(14 BYTE),
  SQLCODE          VARCHAR2(25 BYTE),
  SQLERRM          VARCHAR2(100 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE SGAS.OTHER_CHANGE_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.OTHER_CHANGE_EXC
(
  STUD_REF_NO  NUMBER(10)                       NOT NULL,
  CHANGE_DATE  DATE                             NOT NULL,
  CHANGE       VARCHAR2(1000 BYTE)              NOT NULL,
  SQLCODE      VARCHAR2(25 BYTE),
  SQLERRM      VARCHAR2(100 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE SGAS.PULL_WEB_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.PULL_WEB_EXC
(
  CHANGE_DATE  DATE,
  SQLCODE      VARCHAR2(25 BYTE),
  SQLERRM      VARCHAR2(100 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE SGAS.TERM_ADDR_CHANGE_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.TERM_ADDR_CHANGE_EXC
(
  STUD_REF_NO         NUMBER(10)                NOT NULL,
  CHANGE_DATE         DATE                      NOT NULL,
  HOUSE_NO_NAME       VARCHAR2(32 BYTE)         NOT NULL,
  ADDR_L1             VARCHAR2(65 BYTE)         NOT NULL,
  ADDR_L2             VARCHAR2(65 BYTE),
  ADDR_L3             VARCHAR2(32 BYTE),
  ADDR_L4             VARCHAR2(32 BYTE),
  POST_CODE           VARCHAR2(8 BYTE),
  RESIDENCE_IND       VARCHAR2(1 BYTE)          NOT NULL,
  TO_FROM_PARENTS_FG  VARCHAR2(1 BYTE)          NOT NULL,
  SQLCODE             VARCHAR2(25 BYTE),
  SQLERRM             VARCHAR2(100 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE SGAS.TITLE_NAME_CHANGE_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.TITLE_NAME_CHANGE_EXC
(
  STUD_REF_NO      NUMBER(10)                   NOT NULL,
  CHANGE_DATE      DATE                         NOT NULL,
  TITLE            VARCHAR2(8 BYTE)             NOT NULL,
  FORENAMES        VARCHAR2(25 BYTE)            NOT NULL,
  SURNAME          VARCHAR2(25 BYTE)            NOT NULL,
  BIRTH_FORENAMES  VARCHAR2(30 BYTE),
  BIRTH_SURNAME    VARCHAR2(30 BYTE),
  SQLCODE          VARCHAR2(25 BYTE),
  SQLERRM          VARCHAR2(100 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE INDEX SGAS.EMAIL_MPHONE_CHANGE_EXC_IDX1 ON SGAS.EMAIL_MPHONE_CHANGE_EXC
(STUD_REF_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          16K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


DROP PUBLIC SYNONYM EMAIL_MPHONE_CHANGE_EXC;

CREATE PUBLIC SYNONYM EMAIL_MPHONE_CHANGE_EXC FOR SGAS.EMAIL_MPHONE_CHANGE_EXC;


DROP PUBLIC SYNONYM HOME_ADDR_CHANGE_EXC;

CREATE PUBLIC SYNONYM HOME_ADDR_CHANGE_EXC FOR SGAS.HOME_ADDR_CHANGE_EXC;


DROP PUBLIC SYNONYM BANK_CHANGE_EXC;

CREATE PUBLIC SYNONYM BANK_CHANGE_EXC FOR SGAS.BANK_CHANGE_EXC;


DROP PUBLIC SYNONYM LOAN_CONTACTS_CHANGE_EXC;

CREATE PUBLIC SYNONYM LOAN_CONTACTS_CHANGE_EXC FOR SGAS.LOAN_CONTACTS_CHANGE_EXC;


DROP PUBLIC SYNONYM OTHER_CHANGE_EXC;

CREATE PUBLIC SYNONYM OTHER_CHANGE_EXC FOR SGAS.OTHER_CHANGE_EXC;


DROP PUBLIC SYNONYM PULL_WEB_EXC;

CREATE PUBLIC SYNONYM PULL_WEB_EXC FOR SGAS.PULL_WEB_EXC;


DROP PUBLIC SYNONYM TERM_ADDR_CHANGE_EXC;

CREATE PUBLIC SYNONYM TERM_ADDR_CHANGE_EXC FOR SGAS.TERM_ADDR_CHANGE_EXC;


DROP PUBLIC SYNONYM TITLE_NAME_CHANGE_EXC;

CREATE PUBLIC SYNONYM TITLE_NAME_CHANGE_EXC FOR SGAS.TITLE_NAME_CHANGE_EXC;















