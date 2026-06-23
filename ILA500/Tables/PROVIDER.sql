-- TABLE: PROVIDER
-- Description: Table holding each learning provider providing ILA500
--              eligible courses
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                 Desc.
-- 1.0      27.05.08    A.Bowman (SAAS)        Initial Version.
-- 1.1      19.06.08	A.Bowman (SAAS)        Amend data type of tele and fax no's to varchar2, was number in f.spec
-- 1.2      20.06.08    A.Bowman (SAAS)        Main and Finance position fields can now be null was mandatory in f.spec
-- 1.3      23.06.08    A.Bowman (SAAS)        Amend data type of provider_id to number, was varchar2 in f.spec
-- 1.4      08.08.08    R.Hunter (SAAS)        Add column outstanding_amount
-- 1.5      21.08.08    A.Bowman (SAAS)        Amended outstanding_amount data type to number(15,2)
-- 1.6      09.03.09    A.Bowman (SAAS)        Amended prov_type_id data type to number(10)
-- 1.7      20.04.09    A.Bowman (SAAS)        Amended prov_status_id data type to number (10)
-- 1.8      15.02.10    A.Bowman (SAAS)        Amended audit triggers
-- 1.9      13.04.10	A.Bowman (SAAS)        Added new column securezip_password
-- 2.0      05.05.10    A.Bowman (SAAS)        Added new reference data from LIVE database	
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER.sql $
-- $Author: $
-- $Date: 2010-10-21 09:56:31 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5795 $
 
ALTER TABLE PROVIDER
 DROP PRIMARY KEY CASCADE
/
DROP TABLE PROVIDER CASCADE CONSTRAINTS PURGE
/

--
-- PROVIDER (Table) 
--

CREATE TABLE PROVIDER
(
  PROVIDER_ID                    NUMBER(10) NOT NULL,
  PROVIDER_NAME                  VARCHAR2(50 BYTE) NOT NULL,
  PROVIDER_HOUSE_NO_OR_NAME      VARCHAR2(32 BYTE),
  PROVIDER_ADDR_L1               VARCHAR2(65 BYTE),
  PROVIDER_ADDR_L2               VARCHAR2(65 BYTE),
  PROVIDER_ADDR_L3               VARCHAR2(32 BYTE),
  PROVIDER_ADDR_L4               VARCHAR2(32 BYTE),
  PROVIDER_POST_CODE             VARCHAR2(8 BYTE),
  PROVIDER_TEL_NO                VARCHAR2(15 BYTE),
  PROVIDER_FAX_NO                VARCHAR2(15 BYTE),
  BANK_SORT_CODE                 VARCHAR2(6 BYTE),
  BANK_ACCOUNT_NO                VARCHAR2(10 BYTE),
  MAIN_CONTACT_NAME              VARCHAR2(50 BYTE) NOT NULL,
  MAIN_CONTACT_POSITION          VARCHAR2(30 BYTE),
  MAIN_CONTACT_HOUSE_NO_OR_NAME  VARCHAR2(32 BYTE),
  MAIN_CONTACT_ADDR_L1           VARCHAR2(65 BYTE),
  MAIN_CONTACT_ADDR_L2           VARCHAR2(65 BYTE),
  MAIN_CONTACT_ADDR_L3           VARCHAR2(32 BYTE),
  MAIN_CONTACT_ADDR_L4           VARCHAR2(32 BYTE),
  MAIN_CONTACT_POST_CODE         VARCHAR2(8 BYTE),
  MAIN_CONTACT_TEL_NO            VARCHAR2(15 BYTE),
  MAIN_CONTACT_FAX_NO            VARCHAR2(15 BYTE),
  MAIN_CONTACT_EMAIL             VARCHAR2(80 BYTE),
  FIN_CONTACT_NAME               VARCHAR2(50 BYTE) NOT NULL,
  FIN_CONTACT_POSITION           VARCHAR2(30 BYTE),
  FIN_CONTACT_HOUSE_NO_OR_NAME   VARCHAR2(32 BYTE),
  FIN_CONTACT_ADDR_L1            VARCHAR2(65 BYTE),
  FIN_CONTACT_ADDR_L2            VARCHAR2(65 BYTE),
  FIN_CONTACT_ADDR_L3            VARCHAR2(32 BYTE),
  FIN_CONTACT_ADDR_L4            VARCHAR2(32 BYTE),
  FIN_CONTACT_POST_CODE          VARCHAR2(8 BYTE),
  FIN_CONTACT_TEL_NO             VARCHAR2(15 BYTE),
  FIN_CONTACT_FAX_NO             VARCHAR2(15 BYTE),
  FIN_CONTACT_EMAIL              VARCHAR2(80 BYTE) NOT NULL,
  SECUREZIP_PASSWORD             VARCHAR2(12 BYTE),
  SUSPEND_PAYMENTS               VARCHAR2(1 BYTE) DEFAULT 'N',
  SUSPEND_LETTERS                VARCHAR2(1 BYTE) DEFAULT 'N',
  PROV_TYPE_ID                   NUMBER(10) NOT NULL,
  PROV_STATUS_ID                 NUMBER(10) NOT NULL,
  OUTSTANDING_AMOUNT             NUMBER(15,2) DEFAULT 0 NOT NULL,
  LAST_UPDATED_BY                VARCHAR2(15 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON                DATE           DEFAULT SYSDATE               NOT NULL
  
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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

COMMENT ON TABLE PROVIDER IS 'Table holding each learning provider providing ILA500 eligible courses';

COMMENT ON COLUMN PROVIDER.PROVIDER_ID IS 'Unique identifier for each learning provider';

COMMENT ON COLUMN PROVIDER.PROVIDER_NAME IS 'Name of learning provider';

COMMENT ON COLUMN PROVIDER.PROVIDER_HOUSE_NO_OR_NAME IS 'Learning provider house number or name';

COMMENT ON COLUMN PROVIDER.PROVIDER_ADDR_L1 IS 'Line 1 of learning providers address';

COMMENT ON COLUMN PROVIDER.PROVIDER_ADDR_L2 IS 'Line 2 of learning providers address';

COMMENT ON COLUMN PROVIDER.PROVIDER_ADDR_L3 IS 'Line 3 of learning providers address';

COMMENT ON COLUMN PROVIDER.PROVIDER_ADDR_L4 IS 'Line 4 of learning providers address';

COMMENT ON COLUMN PROVIDER.PROVIDER_POST_CODE IS 'learning providers post code';

COMMENT ON COLUMN PROVIDER.PROVIDER_TEL_NO IS 'learning providers telephone number';

COMMENT ON COLUMN PROVIDER.PROVIDER_FAX_NO IS 'learning providers fax number';

COMMENT ON COLUMN PROVIDER.BANK_SORT_CODE IS 'learning providers bank sort code';

COMMENT ON COLUMN PROVIDER.BANK_ACCOUNT_NO IS 'learning providers bank account number';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_NAME IS 'learning providers - main point of contact';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_POSITION IS 'learning providers - main point of contact''s job title';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_HOUSE_NO_OR_NAME IS 'learning providers - main point of contact''s house number or name';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_ADDR_L1 IS 'learning providers - main point of contact''s 1st line of address';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_ADDR_L2 IS 'learning providers - main point of contact''s 2nd line of address';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_ADDR_L3 IS 'learning providers - main point of contact''s 3rd line of address';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_ADDR_L4 IS 'learning providers - main point of contact''s 4th line of address';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_POST_CODE IS 'learning providers - main point of contact''s post code';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_TEL_NO IS 'learning providers -  main point of contact''s telephone number';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_FAX_NO IS 'learning providers -  main point of contact''s fax number';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_EMAIL IS 'learning providers - main point of contact''s email address';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_NAME IS 'learning providers - finance dept point of contact';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_POSITION IS 'learning providers - finance dept point of contact''s job title';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_HOUSE_NO_OR_NAME IS 'learning providers - finance dept point of contact''s house number or name';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_ADDR_L1 IS 'learning providers - finance dept point of contact''s 1st line of address';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_ADDR_L2 IS 'learning providers - finance dept point of contact''s 2nd line of address';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_ADDR_L3 IS 'learning providers - finance dept point of contact''s 3rd line of address';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_ADDR_L4 IS 'learning providers - finance dept point of contact''s 4th line of address';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_POST_CODE IS 'learning providers - finance dept point of contact''s post code';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_TEL_NO IS 'learning providers - finance dept point of contact''s telephone number';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_FAX_NO IS 'learning providers - finance dept point of contact''s fax number';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_EMAIL IS 'learning providers - finance dept point of contact''s email address';

COMMENT ON COLUMN PROVIDER.SUSPEND_PAYMENTS IS 'Hold payments to learning provider indicator Y or N';

COMMENT ON COLUMN PROVIDER.SUSPEND_LETTERS IS 'Hold letters to learning provider indicator Y or N';

COMMENT ON COLUMN PROVIDER.PROV_TYPE_ID IS 'The type of learning provider. This should be Higher Education, Further Education or Private';

COMMENT ON COLUMN PROVIDER.PROV_STATUS_ID IS 'This should be active or inactive';

COMMENT ON COLUMN PROVIDER.LAST_UPDATED_BY IS 'The user to last update or insert a row on the provider table';

COMMENT ON COLUMN PROVIDER.LAST_UPDATED_ON IS 'The date of the latest update or insert on the provider table';


CREATE UNIQUE INDEX PROVIDER_PK ON PROVIDER
(PROVIDER_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE PROVIDER ADD (
  CONSTRAINT PROVIDER_PK
 PRIMARY KEY
 (PROVIDER_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

/* Formatted on 2008/07/09 17:39 (Formatter Plus v4.8.8) */
-- TRIGGER: PROV_IUD
-- TABLE: PROVIDER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
-- 002      18.08.2008    A.Bowman (SAAS)         Added outstanding_amount column
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER.sql $
-- $Author: $
-- $Date: 2010-10-21 09:56:31 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5795 $ 
--
CREATE OR REPLACE TRIGGER ila500.prov_iud
   AFTER DELETE OR INSERT OR UPDATE OF provider_id,
                                       provider_name,
                                       provider_house_no_or_name,
                                       provider_addr_l1,
                                       provider_addr_l2,
                                       provider_addr_l3,
                                       provider_addr_l4,
                                       provider_post_code,
                                       provider_tel_no,
                                       provider_fax_no,
                                       bank_sort_code,
                                       bank_account_no,
                                       main_contact_name,
                                       main_contact_position,
                                       main_contact_house_no_or_name,
                                       main_contact_addr_l1,
                                       main_contact_addr_l2,
                                       main_contact_addr_l3,
                                       main_contact_addr_l4,
                                       main_contact_post_code,
                                       main_contact_tel_no,
                                       main_contact_fax_no,
                                       main_contact_email,
                                       fin_contact_name,
                                       fin_contact_position,
                                       fin_contact_house_no_or_name,
                                       fin_contact_addr_l1,
                                       fin_contact_addr_l2,
                                       fin_contact_addr_l3,
                                       fin_contact_addr_l4,
                                       fin_contact_post_code,
                                       fin_contact_tel_no,
                                       fin_contact_fax_no,
                                       fin_contact_email,
                                       securezip_password,
                                       suspend_payments,
                                       suspend_letters,
                                       prov_type_id,
                                       prov_status_id,
                                       outstanding_amount,
                                       last_updated_by
   ON ila500.provider
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                            := SYSDATE;
   p_column_name   provider_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_aud.primary_key%TYPE   := :OLD.provider_id;
   p_old           provider_aud.OLD%TYPE           := NULL;
   p_new           provider_aud.NEW%TYPE           := NULL;
   p_action        provider_aud.action%TYPE        := NULL;
   p_username      provider_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.provider_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PROVIDER_ID';
   p_old := :OLD.provider_id;
   p_new := :NEW.provider_id;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_NAME';
   p_old := :OLD.provider_name;
   p_new := :NEW.provider_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_HOUSE_NO_OR_NAME';
   p_old := :OLD.provider_house_no_or_name;
   p_new := :NEW.provider_house_no_or_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L1';
   p_old := :OLD.provider_addr_l1;
   p_new := :NEW.provider_addr_l1;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L2';
   p_old := :OLD.provider_addr_l2;
   p_new := :NEW.provider_addr_l2;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L3';
   p_old := :OLD.provider_addr_l3;
   p_new := :NEW.provider_addr_l3;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L4';
   p_old := :OLD.provider_addr_l4;
   p_new := :NEW.provider_addr_l4;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_POST_CODE';
   p_old := :OLD.provider_post_code;
   p_new := :NEW.provider_post_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_TEL_NO';
   p_old := :OLD.provider_tel_no;
   p_new := :NEW.provider_tel_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_FAX_NO';
   p_old := :OLD.provider_fax_no;
   p_new := :NEW.provider_fax_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'BANK_SORT_CODE';
   p_old := :OLD.bank_sort_code;
   p_new := :NEW.bank_sort_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'BANK_ACCOUNT_NO';
   p_old := :OLD.bank_account_no;
   p_new := :NEW.bank_account_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_NAME';
   p_old := :OLD.main_contact_name;
   p_new := :NEW.main_contact_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_POSITION';
   p_old := :OLD.main_contact_position;
   p_new := :NEW.main_contact_position;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_HOUSE_NO_OR_NAME';
   p_old := :OLD.main_contact_house_no_or_name;
   p_new := :NEW.main_contact_house_no_or_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L1';
   p_old := :OLD.main_contact_addr_l1;
   p_new := :NEW.main_contact_addr_l1;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L2';
   p_old := :OLD.main_contact_addr_l2;
   p_new := :NEW.main_contact_addr_l2;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L3';
   p_old := :OLD.main_contact_addr_l3;
   p_new := :NEW.main_contact_addr_l3;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L4';
   p_old := :OLD.main_contact_addr_l4;
   p_new := :NEW.main_contact_addr_l4;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_POST_CODE';
   p_old := :OLD.main_contact_post_code;
   p_new := :NEW.main_contact_post_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_TEL_NO';
   p_old := :OLD.main_contact_tel_no;
   p_new := :NEW.main_contact_tel_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_FAX_NO';
   p_old := :OLD.main_contact_fax_no;
   p_new := :NEW.main_contact_fax_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_EMAIL';
   p_old := :OLD.main_contact_email;
   p_new := :NEW.main_contact_email;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_NAME';
   p_old := :OLD.fin_contact_name;
   p_new := :NEW.fin_contact_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_POSITION';
   p_old := :OLD.fin_contact_position;
   p_new := :NEW.fin_contact_position;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_HOUSE_NO_OR_NAME';
   p_old := :OLD.fin_contact_house_no_or_name;
   p_new := :NEW.fin_contact_house_no_or_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L1';
   p_old := :OLD.fin_contact_addr_l1;
   p_new := :NEW.fin_contact_addr_l1;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L2';
   p_old := :OLD.fin_contact_addr_l2;
   p_new := :NEW.fin_contact_addr_l2;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L3';
   p_old := :OLD.fin_contact_addr_l3;
   p_new := :NEW.fin_contact_addr_l3;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L4';
   p_old := :OLD.fin_contact_addr_l4;
   p_new := :NEW.fin_contact_addr_l4;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_POST_CODE';
   p_old := :OLD.fin_contact_post_code;
   p_new := :NEW.fin_contact_post_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_TEL_NO';
   p_old := :OLD.fin_contact_tel_no;
   p_new := :NEW.fin_contact_tel_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_FAX_NO';
   p_old := :OLD.fin_contact_fax_no;
   p_new := :NEW.fin_contact_fax_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_EMAIL';
   p_old := :OLD.fin_contact_email;
   p_new := :NEW.fin_contact_email;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'SECUREZIP_PASSWORD';
   p_old := :OLD.securezip_password;
   p_new := :NEW.securezip_password;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'SUSPEND_PAYMENTS';
   p_old := :OLD.suspend_payments;
   p_new := :NEW.suspend_payments;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'SUSPEND_LETTERS';
   p_old := :OLD.suspend_letters;
   p_new := :NEW.suspend_letters;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROV_TYPE_ID';
   p_old := :OLD.prov_type_id;
   p_new := :NEW.prov_type_id;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROV_STATUS_ID';
   p_old := :OLD.prov_status_id;
   p_new := :NEW.prov_status_id;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'OUTSTANDING_AMOUNT';
   p_old := :OLD.outstanding_amount;
   p_new := :NEW.outstanding_amount;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
END prov_iud;
SHOW ERRORS;

/* Formatted on 2008/07/07 16:01 (Formatter Plus v4.8.8) */
-- TRIGGER: PROV_LUB
-- TABLE: PROVIDER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER.sql $
-- $Author: $
-- $Date: 2010-10-21 09:56:31 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5795 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.prov_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.provider
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                            := SYSDATE;
   p_column_name   provider_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_aud.primary_key%TYPE   := :OLD.provider_id;
   p_old           provider_aud.OLD%TYPE           := NULL;
   p_new           provider_aud.NEW%TYPE           := NULL;
   p_action        provider_aud.action%TYPE        := NULL;
   p_username      provider_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.provider_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
END prov_lub;
/

SHOW ERRORS;*/


GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  PROVIDER TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PROVIDER
/

CREATE PUBLIC SYNONYM PROVIDER FOR ILA500.PROVIDER
/

/* Formatted on 2009/07/14 15:44 (Formatter Plus v4.8.8) */
-- Reference data
-- Table: PROVIDER 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 001      20.06.08    A.Bowman (SAAS)         Initial Version.
-- 002      04.09.08    A.Bowman (SAAS)         Added further providers 57-61
-- 003      30.03.09    A.Bowman (SAAS)         Amended prov_type_id for provider_id 61 Cumbernauld College
-- 004      21.04.09    A.Bowman (SAAS)         Replaced the ampersand in provider_id 15 with 'AND'
-- 005      14.07.09    A.Bowman (SAAS)         Added default provider_id of 99, a default value is a business requirement.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER.sql $
-- $Author: $
-- $Date: 2010-10-21 09:56:31 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5795 $ 

DELETE FROM provider;

/* Formatted on 2010/05/05 14:06 (Formatter Plus v4.8.8) */
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (1, 'ABERDEEN COLLEGE', NULL,
             'GALLOWGATE CENTRE', 'GALLOWGATE', 'ABERDEEN',
             NULL, 'AB25 1BN', '01224 612330',
             '01224 612001', '800514', '00401158',
             'MR RODDY SCOTT', NULL,
             NULL, 'GALLOWGATE CENTRE',
             'GALLOWGATE', 'ABERDEEN',
             NULL, 'AB25 1BN',
             '01224 612122', NULL, 'R.SCOTT@ABCOL.AC.UK',
             'MR RODDY SCOTT', NULL,
             NULL, 'GALLOWGATE CENTRE',
             'GALLOWGATE', 'ABERDEEN', NULL,
             'AB25 1BN', '01224 612122', NULL,
             'R.SCOTT@ABCOL.AC.UK', 'w1ndowlIcker', 'N',
             'N', 2, 1,
             0, 'SPTFinCW1',
             TO_DATE ('04/13/2010 11:59:39 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (2, 'ADAM SMITH COLLEGE FIFE', NULL,
             'ST BRYCEDALE AVENUE', 'KIRKCALDY', NULL,
             NULL, 'KY1 1EX', '01592 268 591',
             NULL, '801684', '06970225',
             'MR JOHN THOMSON', 'FINANCE MANAGER',
             NULL, 'ST BRYCEDALE AVENUE',
             'KIRKCALDY', NULL,
             NULL, 'KY1 1EX',
             '01592 223476', '01592 223404', 'JOHNTHOMSON@ADAMSMITH.AC.UK',
             'MR JOHN THOMSON', 'FINANCE MANAGER',
             NULL, 'ST. BRYCEDALE AVENEUE',
             'KIRKCALDY', NULL, NULL,
             'KY1 1EX', '01592 223476', NULL,
             'JOHNTHOMSON@ADAMSMITH.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (3, 'ANGUS COLLEGE', NULL,
             'KEPTIE ROAD', 'ARBROATH', NULL,
             NULL, 'DD11 3EA', '01241 432600',
             '01241 876169', '801235', '00109770',
             'MRS MARLENE ANDERSON', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MRS MARLENE ANDERSON', NULL,
             NULL, 'KEPTIE ROAD',
             'ARBROATH', NULL, NULL,
             'DD11 3EA', '01241 432 699', NULL,
             'MARLENE.ANDERSON@ANGUS.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (4, 'ANNIESLAND COLLEGE', '19',
             'HATFIELD DRIVE', 'GLASGOW', NULL,
             NULL, 'G12 0YE', '0141 357 3969',
             '0141 357 6557', '832133', '00103344',
             'MR STEPHEN HUME', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MR STEPHEN HUME', NULL,
             NULL, 'HATFIELD DRIVE',
             'GLASGOW', NULL, NULL,
             'G12 0YE', '0141 357 6087', NULL,
             'STEPHEN_HUME@ANNIESLAND.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (5, 'ARGYLL COLLEGE', NULL,
             'WEST BAY', 'DUNOON', NULL,
             NULL, 'PA23 7HP', '01369 707 182',
             NULL, '801346', '00130524',
             'MRS ELAINE MUNRO', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MRS ELAINE MUNRO', NULL,
             NULL, 'DUNBEG',
             'OBAN', NULL, NULL,
             'PA37 1PZ', '01631 559505', NULL,
             'ELAINE.MUNRO@ARGYLLCOLLEGE.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (6, 'AYR COLLEGE', NULL,
             'DAM PARK', 'AYR', NULL,
             NULL, 'KA8 0EU', '01292 265184',
             '01292 263889', '826030', '80255336',
             'MS MARY ROBERTSON', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MS MARY ROBERTSON', NULL,
             NULL, 'DAM PARK',
             'AYR', NULL, NULL,
             'KA8 0EU', '01292 293435', NULL,
             'M.ROBERTSON@AYRCOLL.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (7, 'BANFF AND BUCHAN COLLEGE OF FURTHER EDUCATION', NULL,
             'HENDERSON ROAD', 'FRASERBURGH', NULL,
             NULL, 'AB43 9GA', '01346 586100',
             '01346 515370', '302589', '00664159',
             'MR JOHN ANDERSON', NULL,
             NULL, 'HENDERSON ROAD',
             'FRASERBURGH', NULL,
             NULL, 'AB43 9GA',
             '01346 586174', NULL, 'ANDERSONJ@BANKFF-BUCHAN.AC.UK',
             'MR JOHN ANDERSON', NULL,
             NULL, 'HENDERSON ROAD',
             'FRASERBURGH', NULL, NULL,
             'AB43 9GA', '01346 586174', NULL,
             'ANDERSONJ@BANFF-BUCHAN.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (8, 'BARONY COLLEGE', NULL,
             'PARKGATE', 'DUMFRIES', NULL,
             NULL, 'DG1 3NE', '01387 860251',
             '01387 860395', '826213', '70116729',
             'MRS JUNE SCOTT', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MRS JUNE SCOTT', NULL,
             NULL, 'PARKGATE',
             'DUMFRIES', NULL, NULL,
             'DG1 3NE', '01387 860251', NULL,
             'JSCOTT@BARONY.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (9, 'BORDERS COLLEGE', NULL,
             'THORNIEDEAN HOUSE', 'MELROSE ROAD', 'GALASHIELS',
             NULL, 'TD1 2AF', '08700 50 51 52',
             '01896 758179', '832019', '00116460',
             'MS WEN YU TANG', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MS WEN YU TANG', NULL,
             NULL, 'THORNIEDEAN HOUSE',
             'MELROSE ROAD', 'GALASHIELS', NULL,
             'TD1 2AF', '01896 662 534', NULL,
             'WTANG@BORDERSCOLLEGE.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (10, 'CARDONALD COLLEGE', '690',
             'MOSSPARK DRIVE', 'GLASGOW', NULL,
             NULL, 'G52 3AY', '0141 272 3332',
             '0141 272 3444', '801426', '00119700',
             'MR NORMAN RUNCIMAN', 'ASST FINANCE MANAGER',
             '690', 'MOSSPARK DRIVE',
             'GLASGOW', NULL,
             NULL, 'G52 3AY',
             '0141 272 3111', '0141 272 3444', 'NRUNCIMAN@CARDONALD.AC.UK',
             'MRS ELAINE RITCHIE', 'FINANCE OFFICER',
             '690', 'MOSSPARK DRIVE',
             'GLASGOW', NULL, NULL,
             'G52 3AY', '0141 272 3114', NULL,
             'ERITCHIE@CARDONALD.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (11, 'CARNEGIE COLLEGE', NULL,
             'HALBEATH', 'DUNFERMLINE', NULL,
             NULL, 'KY11 8DY', '01383 845 000',
             '01383 845 001', '800655', '00525952',
             'MRS JILL GRAHAM', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MRS JILL GRAHAM', NULL,
             NULL, 'HALBEATH',
             'DUNFERMLINE', NULL, NULL,
             'KY11 8DY', '01383 845 054', NULL,
             'JGRAHAM@LAUDER.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (12, 'CENTRAL COLLEGE', '300',
             'CATHEDRAL STREET', 'GLASGOW', NULL,
             NULL, 'G1 2TA', '0141 552 3941',
             '0141 552 7179', '801180', '00199126',
             'MR ALEX STEWART', NULL,
             '300', 'CATHEDRAL STREET',
             'GLASGOW', NULL,
             NULL, 'G1 2TA',
             '0141 271 2126', NULL, 'ALEX.STEWART@CENTRAL-GLASGOW.AC.UK',
             'MR ALEX STEWART', NULL,
             '300', 'CATHEDRAL STREET',
             'GLASGOW', NULL, NULL,
             'G1 2TA', '0141 271 2126', NULL,
             'ALEX.STEWART@CENTRAL-GLASGOW.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (13, 'CLYDEBANK COLLEGE', NULL,
             'QUEEN''S QUAY', 'CLYDEBANK', NULL,
             NULL, 'G81 1BF', '0141 951 7416',
             '0141 751 7400', '203370', '30954020',
             'MR ALAN RITCHIE', 'DIRECTOR OF FINANCE AND ESTATE',
             NULL, 'QUEEN''S QUAY',
             'CLYDEBANK', NULL,
             NULL, 'G81 1BF',
             '0141 951 7416', '0141 951 7400', 'ALRITCHIE@CLYDEBANK.AC.UK',
             'MR JAMES RENNIE', 'FINANCIAL CONTROLLER',
             NULL, 'QUEEN''S QUAY',
             'CLYDEBANK', NULL, NULL,
             'G81 1BF', '0141 951 7797', NULL,
             'JRENNIE@CLYDEBANK.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (14, 'COATBRIDGE COLLEGE', NULL,
             'KILDONAN STREET', 'COATBRIDGE', NULL,
             NULL, 'ML5 3LS', '01236 436 000',
             '01236 440 266', '826127', '00003018',
             'MR DEREK BANKS', 'DIRECTOR OF FINANCE',
             NULL, 'KILDONAN STREET',
             'COATBRIDGE', NULL,
             NULL, 'ML5 3LS',
             '01236 422 316', NULL, 'DBANKS@COATBRIDGE.AC.UK',
             'MR DEREK BANKS', 'DIRECTOR OF FINANCE',
             NULL, 'KILDONAN STREET',
             'COATBRIDGE', NULL, NULL,
             'ML5 3LS', '01236 422 316', NULL,
             'DBANKS@COATBRIDGE.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (15, 'DUMFRIES AND GALLOWAY COLLEGE', NULL,
             'HERRIES AVENUE', 'HEATHHALL', 'DUMFRIES',
             NULL, 'DG1 3QZ', '01387 243818',
             '01387 250006', '801160', '00266880',
             'MS KAREN HUNTER', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MS KAREN HUNTER', NULL,
             NULL, 'HERRIES AVENUE',
             'HEATHHALL', 'DUMFRIES', NULL,
             'DG1 3QZ', '01387 243891', NULL,
             'HUNTERK@DUMGAL.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no,
             main_contact_email, fin_contact_name,
             fin_contact_position, fin_contact_house_no_or_name,
             fin_contact_addr_l1, fin_contact_addr_l2, fin_contact_addr_l3,
             fin_contact_addr_l4, fin_contact_post_code, fin_contact_tel_no,
             fin_contact_fax_no, fin_contact_email, securezip_password,
             suspend_payments, suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (16, 'DUNDEE COLLEGE', NULL,
             'KINGSWAY CAMPUS', 'OLD GLAMIS ROAD', 'DUNDEE',
             NULL, 'DD3 8LE', '01382 834834',
             '01382 838117', '831812', '00139440',
             'MS LIANA BARTHOLOMEW', 'FINANCE TEAM LEADER',
             NULL, 'KINGSWAY CAMPUS',
             'OLD GLAMIS ROAD', 'DUNDEE',
             NULL, 'DD3 8LE',
             '01382 834834', '01382 858117',
             'L.BARTHOLOMEW@DUNDEECOLL.AC.UK', 'MS LIANA BARTHOLOMEW',
             'FINANCE TEAM LEADER', NULL,
             'KINGSWAY CAMPUS', 'OLD GLAMIS ROAD', 'DUNDEE',
             NULL, 'DD3 8LE', '01382 834834',
             NULL, 'L.BARTHOLOMEW@DUNDEECOLL.AC.UK', NULL,
             'N', 'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (17, 'EDINBURGH''S TELFORD COLLEGE', '350',
             'WEST GRANTON ROAD', 'EDINBURGH', NULL,
             NULL, 'EH5 1QE', '0131 559 4000',
             '0131 559 4111', '831910', '00271551',
             'MR KEITH PURNELL', 'FINANCE MANAGER',
             '350', 'WEST GRANTON ROAD',
             'EDINBURGH', NULL,
             NULL, 'EH5 1QE',
             '0131 559 4022', '0131 559 4111', 'FINANCE@ED_COLL.AC.UK',
             'MR KEITH PURNELL', 'FINANCE MANAGER',
             '350', 'WEST GRANTON ROAD',
             'EDINBURGH', NULL, NULL,
             'EH5 1QE', '0131 559 4022', NULL,
             'FINANCE@ED-COLL_AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (18, 'ELMWOOD COLLEGE', NULL,
             'CARSLOGIE ROAD', 'CUPAR', NULL,
             NULL, 'KY15 4JB', '01334 658 856',
             '01334 658 888', '831723', '00150643',
             'MS VIVIEN NELSON', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MS VIVIEN NELSON', NULL,
             NULL, 'CARSLOGIE ROAD',
             'CUPAR', NULL, NULL,
             'KY15 4JB', '01334 658 808', NULL,
             'VNELSON@ELMWOOD.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (19, 'FORTH VALLEY COLLEGE', NULL,
             'STUDENT SERVICES CENTRE', 'GRANGEMOUTH ROAD', 'FALKIRK',
             NULL, 'FK2 9AD', '01324 403020',
             '01324 403222', '832032', '00788702',
             'MRS JANET MCNEE', NULL,
             NULL, 'GRANGEMOUTH ROAD',
             'FALKIRK', NULL,
             NULL, 'FK2 9AD',
             '01324 403011', NULL, 'JANET.MCNEE@FORTHVALLEY.AC.UK',
             'MRS JANET MCNEE', NULL,
             NULL, 'GRANGEMOUTH ROAD',
             'FALKIRK', NULL, NULL,
             'FK2 9AD', '01324  403011', NULL,
             'JANET.MCNEE@FORTHVALLEY.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (20, 'GLASGOW COLLEGE OF NAUTICAL STUDIES', '21',
             'THISTLE STREET', 'GLASGOW', NULL,
             NULL, 'G5 9XB', '0141 565 2500',
             '0141 565 2599', '826413', '30266042',
             'MS EILEEN MARSHALL', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MS EILEEN MARSHALL', NULL,
             '21', 'THISTLE STREET',
             'GLASGOW', NULL, NULL,
             'G5 9XB', '0141 565 2565', NULL,
             'E.MARCHALL@GCNS.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (21, 'GLASGOW METROPOLITAN COLLEGE', '60',
             'NORTH HANOVER STREET', 'GLASGOW', NULL,
             NULL, 'G1 2BP', '0141 566 6222',
             '0141 566 6226', '826412', '10102903',
             'MS LOUISE ANDERSON', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MS LOUISE ANDERSON', NULL,
             NULL, 'GLASGOW METROPOLITAN COLLEGE',
             '60 NORTH HANOVER STREET', 'GLASGOW', NULL,
             'G1 2BP', '0141 566 6222', NULL,
             'LOUISE.ANDERSON@GLASGOWMET.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (22, 'HIGHLAND THEOLOGICAL COLLEGE', '16',
             'HIGH STREET', 'DINGWALL', NULL,
             NULL, 'IV15 9HA', '01349 780000',
             '01349 780001', '800635', '00112023',
             'MRS MARIE EWAN', 'FINANCE OFFICER',
             '16', 'HIGH STREET',
             'DINGWALL', NULL,
             NULL, 'IV15 9HA',
             '01349 780204', '01349 780001', 'MARIE.EWAN@HTC.UHI.AC.UK',
             'MRS MARIE EWAN', 'FINANCE OFFICER',
             '16', 'HIGH STREET',
             'DINGWALL', NULL, NULL,
             'IV15 9HA', '01349 780204', NULL,
             'MARIE.EWAN@HTC.UHI.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no,
             main_contact_email, fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (23, 'INVERNESS COLLEGE', '3',
             'LONGMAN ROAD', 'INVERNESS', NULL,
             NULL, 'IV1 1SA', '01463 273000',
             '01463 711977', '832310', '00180230',
             'MRS MARY BUTLER', NULL,
             '3', 'LONGMAN ROAD',
             'INVERNESS', NULL,
             NULL, 'IV1 1SA',
             '01463 273402', '01463 273012',
             'MARY.BUTLER@INVERNESS.UHI.AC.UK', 'MRS FIONA MUSTARDE', NULL,
             '3', 'LONGMAN ROAD',
             'INVERNESS', NULL, NULL,
             'IV1 1SA', '01463 273260', NULL,
             'FIONA.MUSTARDE@INVERNESS.UHI.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (24, 'JAMES WATT COLLEGE', NULL,
             'FINNART STREET', 'GREENOCK', NULL,
             NULL, 'PA16 8HF', '01475 553014',
             '01475 554085', '800748', '00519673',
             'MS VIVIENNE RUDDELL', 'PRINCIPAL ACCOUNTANT',
             NULL, 'FINNART STREET',
             'GREENOCK', NULL,
             NULL, 'PA16 8HF',
             '01475 553014', '01475 554085', 'VRUDDELL@JAMESWATT.AC.UK',
             'MS VIVIENNE RUDDELL', 'PRINCIPAL ACCOUNTANT',
             NULL, 'FINNART STREET',
             'GREENOCK', NULL, NULL,
             'PA16 8HF', '01475 553014', NULL,
             'VRUDDELL@JAMESWHATT.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (25, 'JEWEL AND ESK VALLEY COLLEGE', NULL,
             'ESKBANK CENTRE', 'NEWBATTLE ROAD', 'ESKBANK',
             'DALKEITH', 'EH22 3AE', '0845 850 0060',
             '0131 663 0271', '302581', '01037407',
             'MR DAVID SWEENEY', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MR DAVID SWEENEY', NULL,
             NULL, 'ESKBANK CAMPUS',
             'NEWBATTLE ROAD', 'DALKEITH', NULL,
             'EH22 3AE', '0131 654 5330', NULL,
             'DSWEENEY@JEVC.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (26, 'JOHN WHEATLEY COLLEGE', NULL,
             'EAST END CAMPUS', '2 HASHELL ROAD', 'GLASGOW',
             NULL, 'G31 3SR', '0141 588 1571',
             '0141 588 1503', '826428', '60042308',
             'MS YVONNE MCCAIG', NULL,
             NULL, 'EAST END CAMPUS',
             '2 HASHELL ROAD', 'GLASGOW',
             NULL, 'G31 3SR',
             '0141 588 1571', '0141 588 1503', 'YMCCAIG@JWHEATLEY.AC.UK',
             'MS YVONNE MCCAIG', NULL,
             NULL, 'EAST END CAMPUS',
             '2 HASHELL ROAD', 'GLASGOW', NULL,
             'G31 3SR', '0141 588 1571', NULL,
             'YMCCAIG@JWHEATLEY.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (27, 'KILMARNOCK COLLEGE', NULL,
             'HOLEHOUSE ROAD', 'KILMARNOCK', NULL,
             NULL, 'KA3 7AT', '0800 389 6817',
             '01563 538182', '800853', '06005432',
             'MRS ELIZABETH WALKER', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MRS ELIZABETH WALKER', NULL,
             NULL, 'HOLEHOUSE ROAD',
             'KILMARNOCK', NULL, NULL,
             'KA3 7AT', '0800 389 6817', NULL,
             'ENQUIRIES@KILMARNOCK.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (28, 'LANGSIDE COLLEGE', '50',
             'PROSPECTHILL ROAD', 'GLASGOW', NULL,
             NULL, 'G42 9LB', '0141 636 6066',
             '0141 632 5252', '800717', '00500068',
             'MR JOSEPH MCMAHON', 'FINANCE MANAGER',
             '50', 'PROSPECTHILL ROAD',
             'GLASGOW', NULL,
             NULL, 'G42 9LB',
             '0141 272 3650', NULL, 'JMCMAHON@LANGSIDE.AC.UK',
             'MR JOSEPH MCMAHON', 'FINANCE MANAGER',
             '50', 'PROSPECTHILL ROAD',
             'GLASGOW', NULL, NULL,
             'G42 9LB', '0141 272 3650', NULL,
             'JMCMAHON@LANGSIDE.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (29, 'LEWS CASTLE COLLEGE', NULL,
             'LADY LEVER PARK', 'STORNOWAY', NULL,
             NULL, 'HS2 0XR', '01851 770000',
             '01851 770001', '832712', '00164770',
             'MR IAIN MACMILLAN', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MR IAIN MACMILLAN', NULL,
             NULL, 'STORNOWAY',
             'ISLE OF LEWIS', NULL, NULL,
             'HS2 0XR', '01851 770 000', NULL,
             'IAIN.MACMILLAN@LEWS.UHI.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (30, 'MORAY COLLEGE', NULL,
             'MORAY STREET', 'ELGIN', NULL,
             NULL, 'IV30 1JJ', '01343 576000',
             '01343 576001', '800666', '00156260',
             'MR STUART CRUICKSHANK', NULL,
             NULL, 'MORAY STREET',
             'ELGIN', NULL,
             NULL, 'IV30 1JJ',
             '01343 576418', NULL, 'STUART.CRUICKSHANK@MORAY.UHI.AC.UK',
             'MR STUART CRUICKSHANK', NULL,
             NULL, 'MORAY STREET',
             'ELGIN', NULL, NULL,
             'IV30 1JJ', '01343 576418', NULL,
             'STUART.CRUICKSHANK@MORAY.UHI.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (31, 'MOTHERWELL COLLEGE', NULL,
             'DALZELL DRIVE', 'MOTHERWELL', NULL,
             NULL, 'ML1 2DD', '01698 232 425',
             '01698 232 527', '826626', '60390624',
             'MR IAIN CLARK', 'FINANCIAL CONTROLLER',
             NULL, 'DALZELL DRIVE',
             'MOTHERWELL', NULL,
             NULL, 'ML1 2DD',
             '01698 232323', NULL, 'ICLARK@MOTHERWELL.CO.UK',
             'MR IAIN CLARK', NULL,
             NULL, 'DALZELL DRIVE',
             'MOTHERWELL', NULL, NULL,
             'ML1 2DD', '01698 232323', NULL,
             'ICLARK@MOTHERWELL.CO.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (32, 'NORTH GLASGOW COLLEGE', '110',
             'FLEMINGTON STREET', 'SPRINGBURN', 'GLASGOW',
             NULL, 'G21 4BX', '0141 558 9001',
             '0141 558 9905', '826429', '50064238',
             'MISS LESLEY RENSHAW', 'FINANCE ASSISTANT',
             '110', 'FLEMINGTON STREET',
             'GLASGOW', NULL,
             NULL, 'G21 4BX',
             '0141 558 9001', NULL, 'LRENSHAW@NORTH-GLA.AC.UK',
             'MISS LESLEY RENSHAW', 'FINANCE ASSISTANT',
             '110', 'FLEMINGTON ROAD',
             'GLASGOW', NULL, NULL,
             'G21 4BX', '0141 558 9001', NULL,
             'LRENSHAW@NORTH-GLA.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no,
             main_contact_email, fin_contact_name,
             fin_contact_position, fin_contact_house_no_or_name,
             fin_contact_addr_l1, fin_contact_addr_l2, fin_contact_addr_l3,
             fin_contact_addr_l4, fin_contact_post_code, fin_contact_tel_no,
             fin_contact_fax_no, fin_contact_email, securezip_password,
             suspend_payments, suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (33, 'NORTH HIGHLAND COLLEGE', NULL,
             'ORMLIE ROAD', 'THURSO', NULL,
             NULL, 'KW14 7EE', '01847 889 000',
             '01847 889 001', '826816', '90540743',
             'MRS MOIRA CONWAY', 'ACCOUNTS ASSISTANT',
             NULL, 'ORMLIE ROAD',
             'THURSO', NULL,
             NULL, 'KW14 7EE',
             '01847 889 229', '01847 889 001',
             'MOIRA.CONWAY@THURSO.UHI.AC.UK', 'MRS MOIRA CONWAY',
             'ACCOUNTS ASSISTANT', NULL,
             'ORMLIE ROAD', 'THURSO', NULL,
             NULL, 'KW14 7EE', '01847 889229',
             NULL, 'MOIRA.CONWAY@THURSO.UHI.AC.UK', NULL,
             'N', 'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (34, 'OATRIDGE COLLEGE', NULL,
             'ECCLESMACHAN', 'BROXBURN', NULL,
             NULL, 'EH52 6NH', '01506 864800',
             '01506 853373', '832425', '00234792',
             'MRS GILLIAN A HAMILTON', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MRS GILLIAN A HAMILTON', NULL,
             NULL, 'ECCLESMACHAN',
             'BROXBURN', NULL, NULL,
             'EH52 6NH', '01506 864 800', NULL,
             'GHAMILTON@OATRIDGE.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (35, 'ORKNEY COLLEGE', NULL,
             'EAST ROAD', 'KIRKWALL', NULL,
             NULL, 'KW15 1LX', '01856 569 000',
             '01856 569 001', '832407', '00233886',
             'MR PETER KITNEY', NULL,
             NULL, 'EAST ROAD',
             'KIRKWALL', NULL,
             NULL, 'KW15 1LX',
             '01856 569 000', NULL, NULL,
             'MS CHRISTINE SCOTT', NULL,
             NULL, 'EAST ROAD',
             'KIRKWALL', NULL, NULL,
             'KW15 1LX', '01856 569 000', NULL,
             'CHRISTINE.SCOTT@ORKNEY.UHI.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (36, 'PERTH COLLEGE', NULL,
             'CRIEFF ROAD', 'PERTH', NULL,
             NULL, 'PH1 2NX', '0845 270 1177',
             '01738 877001', '809128', '00710997',
             'MR IAIN NEILSON', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MR IAIN NEILSON', NULL,
             NULL, 'CRIEFF ROAD',
             'PERTH', NULL, NULL,
             'PH1 2NX', '01738 877 233', NULL,
             'IAIN.NEILSON@PERTH.UHI.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (37, 'REID KERR COLLEGE', NULL,
             'RENFREW ROAD', 'PAISLEY', NULL,
             NULL, 'PA3 4DR', '0800 052 7343',
             '0141 581 2204', '809127', '00786356',
             'MRS LAURA MCLEAN', NULL,
             NULL, 'RENFREW ROAD',
             'PAISLEY', NULL,
             NULL, 'PA3 4DR',
             '0141 581 2263', NULL, 'LAURA.MCLEAN@REIDKERR.AC.UK',
             'MRS LAURA MCLEAN', NULL,
             NULL, 'RENFREW ROAD',
             'PAISLEY', NULL, NULL,
             'PA3 4DR', '0141 581 2263', NULL,
             'LAURA.MCLEAN@REIDKERR.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (38, 'SABHAL MOR OSTAIG', NULL,
             'TEANGUE', 'ISLE OF SKYE', NULL,
             NULL, 'IV44 8RQ', '01471 888000',
             '01471 888002', '800583', '00857661',
             'MS MARGARET FOWLER', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MS MARGARET FOWLER', NULL,
             NULL, 'TEANGUE',
             'ISLE OF SKYE', NULL, NULL,
             'IV44 8RD', '01471 888 213', NULL,
             'SM00MF@GROUPWISE.UHI.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (39, 'SHETLAND COLLEGE', NULL,
             'GREMISTA', 'LERWICK', NULL,
             NULL, 'ZE1 0PX', '01595 771000',
             '01595 771001', '800882', '00729160',
             'MS ELSE SMAASKJAER', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MS ELSE SMAASKJAER', NULL,
             NULL, 'GREMISTA',
             'LERWICK', NULL, NULL,
             'ZE1 0PX', '0159 577 1268', NULL,
             'ELSE.SMAASKJAER@SHETLAND.UHI.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (40, 'SOUTH LANARKSHIRE COLLEGE', NULL,
             'MAIN CENTRE', '85 HAMILTON ROAD', 'CAMBUSLANG',
             NULL, 'G72 7NY', '01355 270750',
             '01355 231044', '826118', '60172142',
             'MR KEITH MCALLISTER', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MR KEITH MCALLISTER', NULL,
             NULL, 'MAIN CENTRE',
             'HAMILTON ROAD', 'CAMBUSLANG', 'GLASGOW',
             'G72 7NY', '0141 641 6600', NULL,
             'KEITH.MCALLISTER@SLC.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (41, 'STEVENSON COLLEGE EDINBURGH', NULL,
             'BANKHEAD AVENUE', 'SIGHTHILL', 'EDINBURGH',
             NULL, 'EH11 4DE', '0131 535 4700',
             '0131 535 4708', '800227', '06002132',
             'MS JAN BRECHIN', NULL,
             NULL, 'BANKHEAD AVENUE',
             'SIGHTHILL', 'EDINBURGH',
             NULL, 'EH11 4DE',
             '0131 535 4660', NULL, 'JBRECHIN@STEVENSON.AC.UK',
             'MS JAN BRECHIN', NULL,
             NULL, 'BANKHEAD AVENUE',
             'EDINBURGH', NULL, NULL,
             'EH11 4DE', '0131 535 4660', NULL,
             'JBRECHIN@STEVENSON.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (42, 'STOW COLLEGE', '43',
             'SHAMROCK STREET', 'GLASGOW', NULL,
             NULL, 'G4 9LD', '0141 332 1786',
             '0141 332 5207', '835200', '00149876',
             'MR DAVID ALEXANDER', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MR DAVID ALEXANDER', NULL,
             '43', 'SHAMROCK STREET',
             'GLASGOW', NULL, NULL,
             'G4 9LD', '0141 332 1786', NULL,
             'DALEXANDER@STOW.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (43, 'WEST LOTHIAN COLLEGE', NULL,
             'ALMONDVALE CRESCENT', 'LIVINGSTON', NULL,
             NULL, 'EH54 7EP', '01506 418181',
             '01506 409980', '800880', '00897932',
             'MR ANDREW PHILIP', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MR ANDREW PHILIP', NULL,
             NULL, 'ALMONDAVALE CRESCENT',
             'LIVINGSTON', NULL, NULL,
             'EH54 7EP', '01506 427532', NULL,
             'APHILIP@WEST-LOTHIAN.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (44, 'EDINBURGH COLLEGE OF ART', NULL,
             'LAURISTON PLACE', 'EDINBURGH', NULL,
             NULL, 'EH3 9DF', '0131 221 6027',
             '0131 221 6001', '801194', '00204068',
             'MS ALISON HEGARTY', NULL,
             NULL, 'LAURISTON PLACE',
             'EDINBURGH', NULL,
             NULL, 'EH3 9DF',
             '0131 221 6211', NULL, 'A.HEGARTY@ECA.AC.UK',
             'MS ALISON HEGARTY', NULL,
             NULL, 'LAURISTON PLACE',
             'EDINBURGH', NULL, NULL,
             'EH3 9DF', '0131 221 6211', NULL,
             'A.HEGARTY@ECA.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (45, 'GLASGOW CALEDONIAN UNIVERSITY', NULL,
             'COWCADDENS ROAD', 'GLASGOW', NULL,
             NULL, 'G4 0BA', '0141 331 3818',
             '0141 331 3396', '835200', '00716754',
             'MR ROBERT MCKAIN', 'HEAD OF ACCOUNTS RECEIVABLE',
             NULL, 'COWCADDENS ROAD',
             'GLASGOW', NULL,
             NULL, 'G4 0BA',
             '0141 331 3818', '0141 331 3396', 'AR@GCAL.AC.UK',
             'MR ROBERT MCKAIN', 'HEAD OF ACCOUNTS RECEIVABLE',
             NULL, 'COWCADDENS ROAD',
             'GLASGOW', NULL, NULL,
             'G4 0BA', '0141 331 3818', NULL,
             'AR@GCAL.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (46, 'HERIOT WATT UNIVERSITY', NULL,
             'RICCARTON', 'EDINBURGH', NULL,
             NULL, 'EH14 4AS', '0131 449 5111',
             '0131 449 5153', '302581', '00353976',
             'MR KEVIN MALLETT', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MR KEVIN MALLETT', NULL,
             NULL, 'RICCARTON',
             'EDINBURGH', NULL, NULL,
             'EH14 4AS', '0131 451 4001', NULL,
             'K.MALLETT@HW.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (47, 'NAPIER UNIVERSITY', NULL,
             'CRAIGHOUSE CAMPUS', 'CRAIGHOUSE ROAD', 'EDINBURGH',
             NULL, 'EH10 5LG', '0500 35 35 70',
             '0131 455 6261', '831825', '00230250',
             'MS DEIRDRE ROBERTSON', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MS DEIRDRE ROBERTSON', NULL,
             NULL, 'EAST CRAIG',
             'CRAIGHOUSE CAMPUS', 'EDINBURGH', NULL,
             'EH10 5LG', '0131 455 6003', NULL,
             'DC.ROBERTSON@NAPIER.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (48, 'QUEEN MARGARET UNIVERSITY', NULL,
             'QUEEN MARGARET UNIVERSITY DRIVE', 'MUSSELBURGH', NULL,
             NULL, 'EH21 6UU', '0131 474 0000',
             '0131 474 0001', '835100', '00244979',
             'MS KAREN INGLIS', 'FINANCE OFFICE MANAGER',
             NULL, 'QUEEN MARGARET DRIVE',
             'MUSSELBURGH', NULL,
             NULL, 'EH21 6UU',
             '0131 474 0000', '0131 474 0001', 'KINGLIS@QMU.AC.UK',
             'MS KAREN INGLIS', 'FINANCE OFFICE MANAGER',
             NULL, 'QUEEN MARGARET UNIVERSITY DRIVE',
             'MUSSELBURGH', NULL, NULL,
             'EH21 6UU', '0131 474 0000', NULL,
             'KINGLIS@QMU.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:49 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (49, 'ROBERT GORDON UNIVERSITY', NULL,
             'SCHOOLHILL', 'ABERDEEN', NULL,
             NULL, 'AB10 1FR', '01224 262180',
             '01224 262038', '800514', '06003836',
             'MR JOHN MIDDLETON', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MR JOHN MIDDLETON', NULL,
             NULL, 'STUDENT FINANCE - SCHOOLHILL',
             'ABERDEEN', NULL, NULL,
             'AB10 1FR', '1224262055', NULL,
             'J.MIDDLETON@RGU.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:50 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (50, 'SCOTTISH AGRICULTURAL COLLEGE (SAC)', NULL,
             'AYR CAMPUS', 'AUCHINCRUIVE', 'AYR',
             NULL, 'KA6 5HW', '0800 269453',
             NULL, '800224', '00336447',
             'MR RICHARD FINLAYSON', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MR RICHARD FINLAYSON', NULL,
             NULL, 'WEST MAINS ROAD',
             'EDINBURGH', NULL, NULL,
             'EH9 3JE', '0131 535 4286', NULL,
             'WWW.SAC.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:50 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (51, 'THE OPEN UNIVERSITY', '10',
             'DRUMSHEGH GARDENS', 'EDINBURGH', NULL,
             NULL, 'EH3 7QJ', '0131 226 3851',
             '0131 220 6730', '601455', '01920294',
             'DR SUSAN COOPER', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'DR SUSAN COOPER', NULL,
             '10', 'DRUMSHEGH GARDENS',
             'EDINBURGH', NULL, NULL,
             'EH3 7QJ', '0131 226 3851', NULL,
             'S.D.COOPER@OPEN.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:50 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (52, 'UNIVERSITY OF ABERTAY DUNDEE', NULL,
             'BELL STREET', 'DUNDEE', NULL,
             NULL, 'DD1 1HG', '01382 308000',
             '01382 308081', '807331', '00306492',
             'MS CATRIONA BLAKE', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MS CATRIONA BLAKE', NULL,
             NULL, 'KYDD BUILDING',
             '40 BELL STREET', 'DUNDEE', NULL,
             'DD1 1HG', '01382 308023', NULL,
             'C.BLAKE@ABERTAY.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:50 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (53, 'UNIVERSITY OF DUNDEE', NULL,
             'NETHERGATE', 'DUNDEE', NULL,
             NULL, 'DD1 4HN', '01382 383000',
             NULL, '835000', '00279759',
             'MS NORMA STEWART', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MS NORMA STEWART', NULL,
             NULL, 'REGISTRY',
             '1 AIRLIE PLACE', 'DUNDEE', NULL,
             'DD1 4HN', '01382 385392', NULL,
             'N.STEWART@DUNDEE.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:50 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (54, 'UNIVERSITY OF EDINBURGH', NULL,
             'OLD COLLEGE', 'SOUTH BRIDGE', 'EDINBURGH',
             NULL, 'EH8 9YL', '0131 650 1000 ',
             '0131 650 2147', '800224', '00919680',
             'MRS GERALDINE BEATTIE', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MRS GERALDINE BEATTIE', NULL,
             NULL, 'OLD COLLEGE',
             'SOUTH BRIDGE', 'EDINBURGH', NULL,
             'EH8 9YL', '0131 650 9184', NULL,
             'GERALDINE.BEATTIE@ED.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:50 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (55, 'UNIVERSITY OF STIRLING', NULL,
             'MAIN CAMPUS', 'STIRLING', NULL,
             NULL, 'FK9 4LA', '01786 473171',
             NULL, '809129', '00891500',
             'MS CHRISTINE MACINNES', NULL,
             NULL, 'MAIN CAMPUS',
             'STIRLING', NULL,
             NULL, 'FK9 4LA',
             '01786 466198', NULL, 'CHRISTINE.MACINNES@STIR.AC.UK',
             'MS CHRISTINE MACINNES', NULL,
             NULL, 'MAIN CAMPUS',
             'STIRLING', NULL, NULL,
             'FK9 4LA', '01786 466198', NULL,
             'CHRISTINE.MACINNES@STIR.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:50 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (56, 'UNIVERSITY OF THE WEST OF SCOTLAND', NULL,
             'HIGH STREET', 'PAISLEY', NULL,
             NULL, 'PA1 2BE', '0141 848 3000',
             '0141 849 4100', '809127', '00738290',
             'MRS PAULA FRANCIS', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             'MRS PAULA FRANCIS', NULL,
             NULL, NULL,
             'HIGH STREET', 'PAISLEY', NULL,
             'PA1 2BE', '0141 848 3721', NULL,
             'PAULA.FRANCIS@UWS.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('06/20/2008 09:28:50 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (57, 'UNIVERSITY OF ABERDEEN', NULL,
             'REGENT WALK', NULL, 'ABERDEEN',
             NULL, 'AB9 1 FX', '01224 272000',
             NULL, '800514', '00841624',
             'MR DM JONES', NULL,
             NULL, 'REGENT WALK',
             'ABERDEEN', NULL,
             NULL, 'AB9 1FX',
             '01224 272044', NULL, 'D.JONES@ABDN.AC.UK',
             'MRS JENNY MITCHELL', 'SENIOR SECRETARY',
             NULL, 'CENTRE FOR LIFELONG LEARNING',
             'REGENT BUILDING', 'REGENT WALK', 'ABERDEEN',
             'AB24 3FX', '01224 272478', NULL,
             'J.MITCHELL@ABDN.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('09/04/2008 11:59:34 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (58, 'UNIVERSITY OF STRATHCLYDE', '16',
             'RICHMOND STREET', NULL, 'GLASGOW',
             NULL, 'G1 1XQ', '0141 552 4400',
             '0141 552 0775', '801180', '00605248',
             'MRS KAREN FYFE', NULL,
             '16', 'RICHMOND STREET',
             'GLASGOW', NULL,
             NULL, 'G1 1XQ',
             '0141 548 4766', NULL, 'K.FYFE@STRATH.AC.UK',
             'MRS KAREN FYFE', NULL,
             '16', 'RICHMOND STREET',
             'GLASGOW', NULL, NULL,
             'G1 1XQ', '0141 548 4766', NULL,
             'K.FYFE@STRATH.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('09/04/2008 11:59:35 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (59, 'UNIVERSITY OF ST ANDREWS', NULL,
             'COLLEGE GATE', 'NORTH STREET', 'ST ANDREWS',
             NULL, 'KT16 9AJ', '01334 476161',
             '01334 487432', '832628', '00279295',
             'MR ERIC GILLESPIE', NULL,
             NULL, 'COLLEGE GATE',
             'NORTH STREET', 'ST ANDREWS',
             NULL, 'KY16 9AJ',
             '01334 462455', NULL, 'ERG@ST-ANDREWS.AC.UK',
             'MR ERIC GILLESPIE', NULL,
             NULL, 'COLLEGE GATE',
             'NORTH STREET', 'ST ANDREWS', NULL,
             'KY16 9AJ', '01334 462455', NULL,
             'ERG@ST-ANDREWS.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('09/04/2008 11:59:35 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (60, 'THE UNIVERSITY OF GLASGOW', NULL,
             'UNIVERSITY AVENUE', NULL, 'GLASGOW',
             NULL, 'G12 8QQ', '0141 330 2000',
             '0141 330 3542', '822000', '70006363',
             'MS JACQUELINE NELSON', NULL,
             NULL, 'UNIVERSITY AVENUE',
             'GLASGOW', NULL,
             NULL, 'G12 8QQ',
             '0141 330 5503', NULL, 'J.NELSON@ADMIN.GLA.AC.UK',
             'MS JACQUELINE NEILSON', NULL,
             NULL, 'UNIVERSITY AVENUE',
             'GLASGOW', NULL, NULL,
             'G12 8QQ', '0141 330 5503', NULL,
             'J.NELSON@ADMIN.GLA.AC.UK', NULL, 'N',
             'N', 1, 1,
             0, 'ILA500',
             TO_DATE ('09/04/2008 11:59:35 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (61, 'CUMBERNAULD COLLEGE', NULL,
             'TRYST ROAD', NULL, 'CUMBERNAULD',
             NULL, 'G67 1HU', '01236 731811',
             '01236 723416', '801313', '00242860',
             'MR HUGH CAMPBELL', NULL,
             NULL, 'TRYST ROAD',
             'CUMBERNAULD', NULL,
             NULL, 'G67 1HU',
             '01236 784555', NULL, 'HCAMPBELL@CUMBERNAULD.AC.UK',
             'MR HUGH CAMPBELL', NULL,
             NULL, 'TRYST ROAD',
             'CUMBERNAULD', NULL, NULL,
             'G67 1HU', '01236 784555', NULL,
             'HCAMPBELL@CUMBERNAULD.AC.UK', NULL, 'N',
             'N', 2, 1,
             0, 'ILA500',
             TO_DATE ('09/04/2008 11:59:35 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (62, 'Training Matters', NULL,
             NULL, NULL, NULL,
             NULL, NULL, NULL,
             NULL, '801180', '00694586',
             'Ms Roberta Brown', NULL,
             'Innovation Centre', 'Hillington Park Innovation Centre',
             '1 Ainslie Road', 'Hillington Industrial Estate',
             'Glasgow', 'G52 4RU',
             '01415856341', '01415856301', 'roberta@trainingmatters.com',
             'Ms Roberta Brown', NULL,
             'Innovation Centre', 'Hillington Park Innovation Centre',
             '1 Ainslie Road', 'Hillington Industrial Estate', 'Glasgow',
             'G52 4RU', '01415856341', '01415856301',
             'roberta@trainingmatters.com', NULL, 'N',
             'N', 3, 1,
             0, 'U205625',
             TO_DATE ('03/23/2010 10:18:57 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no,
             main_contact_email, fin_contact_name,
             fin_contact_position, fin_contact_house_no_or_name,
             fin_contact_addr_l1, fin_contact_addr_l2, fin_contact_addr_l3,
             fin_contact_addr_l4, fin_contact_post_code, fin_contact_tel_no,
             fin_contact_fax_no, fin_contact_email, securezip_password,
             suspend_payments, suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (63, 'Newbattle Abbey College', NULL,
             NULL, NULL, NULL,
             NULL, NULL, NULL,
             NULL, '800629', '06001789',
             'Jackie Kane', 'Web Admin User',
             NULL, 'Newbattle Road',
             'Dalkeith', NULL,
             NULL, 'EH22 3LL',
             '01316631921', '01316540598',
             'jackiekane@newbattleabbeycollege.ac.uk', 'Jackie Robertson',
             NULL, NULL,
             'Newbattle Road', 'Dalkeith', NULL,
             NULL, 'EH22 3LL', '01316631921',
             NULL, 'jackierobertson@newbattleabbeycollege.ac.uk', NULL,
             'N', 'N', 2, 1,
             0, 'U200603',
             TO_DATE ('09/25/2009 02:58:59 PM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (64, 'Royal Botanic Garden Edinburgh', '20A',
             'Inverleith Row', NULL, NULL,
             'Edinburgh', 'EH3 5LR', '01312482841',
             NULL, '831910', '00146013',
             'Mrs Emily Wood', 'Short Course Co-ordinator',
             '20A', 'Inverleith Row',
             NULL, NULL,
             'Edinburgh', 'EH3 5LR',
             '01312482841', NULL, 'e.wood@rbge.org.uk',
             'Mr Todd Law', NULL,
             '20A', 'Inverleith Row',
             NULL, NULL, 'Edinburgh',
             'EH3 5LR', '01312482834', NULL,
             't.law@rgbe.org.uk', NULL, 'N',
             'N', 3, 1,
             0, 'U200603',
             TO_DATE ('10/20/2009 11:37:34 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1,
             provider_addr_l2, provider_addr_l3, provider_addr_l4,
             provider_post_code, provider_tel_no, provider_fax_no,
             bank_sort_code, bank_account_no, main_contact_name,
             main_contact_position, main_contact_house_no_or_name,
             main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (65, 'Stirling Council Childrens services', '64',
             'The Playwork and Childcare Training Service',
             'Baker Street Nursery', 'Baker Street', 'Stirling',
             'FK8 1DB', '01786473453', NULL,
             '832709', '00135220', 'Ms Anne Emerson-Smith',
             'Web Admin User', '64',
             'The Playwork and Childcare Training Service',
             'Baker Street Nursery', 'Baker Street',
             'Stirling', 'FK8 1DB',
             '01786473453', NULL, 'emersonsmitha34s@stirling.gov.uk',
             'Ms Lisa Macauley', NULL,
             NULL, 'Stirling Council Childrens Services',
             'Viewforth', NULL, 'Stirling',
             'FK8 2ET', '01786442789', NULL,
             'macaulayl@stirling.gov.uk', NULL, 'N',
             'N', 2, 1,
             0, 'U200603',
             TO_DATE ('10/20/2009 11:37:34 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (66, 'Training Initiatives Ltd (Tigers)', '69-71',
             'Aberdalgie Road', 'Westwood Business Centre', NULL,
             'Glasgow', 'G34 9HJ', '01417715200',
             '01417715215', '826428', '90105521',
             'Miss Laura Devennie', 'ILA Web Admin User',
             '69-71', 'Aberdalgie Road',
             'Westwood Business Centre', NULL,
             'Glasgow', 'G34 9HJ',
             '01417715200', '01417715215', 'office@tigersltd.co.uk',
             'Mr John Gibson', NULL,
             '69-71', 'Aberdalgie Road',
             'Westwood Business Centre', NULL, 'Glasgow',
             'G34 9HJ', '01417814707', NULL,
             'johngibson@tigersltd.co.uk', NULL, 'N',
             'N', 3, 1,
             0, 'U200603',
             TO_DATE ('11/26/2009 01:18:09 PM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (67, 'Glasgow School of Art', '167',
             'Renfrew Street', NULL, NULL,
             'Glasgow', 'G3 6RQ', '01413534517',
             '01413534408', '835460', '00161578',
             'Ms Julie Nouillan', 'Head of Registry',
             '167', 'Renfrew Street',
             NULL, NULL,
             'Glasgow', 'G3 6RQ',
             '01413534517', '01413534408', 'j.nouillan@gsa.ac.uk',
             'Mr Alistair Storey', NULL,
             '167', 'Renfrew Street',
             NULL, NULL, 'Glasgow',
             'G3 6RQ', '01413534512', NULL,
             'a.storey@gsa.ac.uk', NULL, 'N',
             'N', 1, 1,
             0, 'U207222',
             TO_DATE ('12/11/2009 02:45:52 PM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no,
             main_contact_email, fin_contact_name,
             fin_contact_position, fin_contact_house_no_or_name,
             fin_contact_addr_l1, fin_contact_addr_l2, fin_contact_addr_l3,
             fin_contact_addr_l4, fin_contact_post_code, fin_contact_tel_no,
             fin_contact_fax_no, fin_contact_email, securezip_password,
             suspend_payments, suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (68, 'Success Training Scotland Ltd', 'Merchants House',
             '7 West George Street', NULL, NULL,
             'Glasgow', 'G1 2BA', '01412482850',
             '01307463044', '801595', '06000925',
             'Mrs Lynne Hunter', 'Web Admin User',
             'Merchants House', '7 West George Street',
             NULL, NULL,
             'Glasgow', 'G1 2BA',
             '01412482850', '01307463044',
             'lynnehunter@successtrainingscotland.com', 'Mrs Lynne Hunter',
             NULL, 'Merchants House',
             '7 West George Street', NULL, NULL,
             'Glasgow', 'G1 2BA', '01412482850',
             NULL, 'lynnehunter@successtrainingscotland.com', NULL,
             'N', 'N', 3, 1,
             0, 'U207222',
             TO_DATE ('12/11/2009 02:52:11 PM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (69, 'Quest (Scotland) Ltd', '8',
             'Riverside Court', 'Mayo Avenue', NULL,
             'Dundee', 'DD2 1XD', '01382668760',
             '01382645682', '834700', '10111443',
             'Ms Laura Mason', 'ILA Web Administrator',
             '8', 'Riverside Court',
             'Mayo Avenue', NULL,
             'Dundee', 'DD2 1XD',
             '01382668760', '01382645682', 'laura@questscotland.co.uk',
             'Ms Laura Mason', 'managing director',
             '8', 'Riverside Court',
             'Mayo Avenue', NULL, 'Dundee',
             'DD2 1XD', '01382668760', '01382645682',
             'laura@questscotland.co.uk', NULL, 'N',
             'N', 3, 1,
             0, 'U200603',
             TO_DATE ('01/15/2010 09:59:08 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (70, 'Angus Council Training Services', '31',
             'Dens Road', 'Unit 18', 'Arbroath Business Centre',
             'Arbroath', 'DD11 1RS', '01241433850',
             NULL, '826318', '60114506',
             'Mr Kevin Teviotdale', 'ILA Web Admin User',
             '31', 'Dens Road',
             'Unit 18', 'Arbroath Business Centre',
             'Arbroath', 'DD11 1RS',
             '01241433850', NULL, 'teviotdalek@angus.gsx.gov.uk',
             'Mrs Lorraine Phin', 'Training Services Manager',
             '31', 'Dens Road',
             'Unit 18', 'Arbroath Business Centre', 'Arbroath',
             'DD11 1RS', '01241433863', NULL,
             'phinl@angus.gsx.gov.uk', NULL, 'N',
             'N', 3, 1,
             0, 'U200603',
             TO_DATE ('02/11/2010 12:10:54 PM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (71, 'Linked Work and Training Trust', 'Suite 14',
             'Willow House', 'Newhouse Business Park', 'Grangemouth',
             NULL, 'FK3 8LL', '01324489666',
             '01324483444', '800674', '00561891',
             'Mrs Pauline Mercer', 'ILA Web Admin User',
             'Suite 14', 'Willow House',
             'Newhouse Business Park', 'Grangemouth',
             NULL, 'FK3 8LL',
             '01324489666', '01324483444', 'pmercer@lwtt.org.uk',
             'Mrs Pauline Mercer', 'Office Manager',
             'Suite 14', 'Willow House',
             'Newhouse Business Park', 'Grangemouth', NULL,
             'FK3 8LL', '01324489666', '01324483444',
             'pmercer@lwtt.org.uk', NULL, 'N',
             'N', 3, 1,
             0, 'U200603',
             TO_DATE ('02/23/2010 03:38:35 PM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (72, 'Concentric Early Years & Playwork Training', '47',
             'Garnqueen Crescent', NULL, NULL,
             'GLENBOIG', 'ML5 2SY', '07595218992',
             NULL, '090666', '43086224',
             'Mr Tomas Renton', NULL,
             '47', 'Garnqueen Crescent',
             NULL, NULL,
             'GLENBOIG', 'ML5 2SY',
             '07595218992', NULL, 'tomrenton@btinternet.com',
             'Mr Thomas Renton', NULL,
             '47', 'Garnqueen Crescent',
             NULL, NULL, 'GLENBOIG',
             'ML5 2SY', '07595218992', NULL,
             'tomrenton@btinternet.com', NULL, 'N',
             'N', 3, 1,
             0, 'U200603',
             TO_DATE ('03/12/2010 09:43:27 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name,
             provider_house_no_or_name, provider_addr_l1, provider_addr_l2,
             provider_addr_l3, provider_addr_l4, provider_post_code,
             provider_tel_no, provider_fax_no, bank_sort_code,
             bank_account_no, main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no,
             main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (73, 'Health and Social Care Training Consortium',
             'Ladykirk House', 'Skye Road', NULL,
             NULL, 'Prestwick', 'KA9 2TA',
             '01292471368', '01292478564', '832643',
             '00241814', 'Mrs Dawn Andrews', 'Administrator',
             'Ladykirk House', 'Skye Road',
             NULL, NULL,
             'Prestwick', 'KA9 2TA',
             '01292471368', '01292478564',
             'dawn.andrews@healthsocialcaretraining.co.uk',
             'Ms Jackie McCulloch', 'Finance Officer',
             'Ladykirk House', 'Skye Road',
             NULL, NULL, 'Prestwick',
             'KA9 2TA', '01292476778', NULL,
             'jackie.mcculloch@healthsocialcaretraining.co.uk', NULL, 'N',
             'N', 3, 1,
             0, 'U200603',
             TO_DATE ('04/13/2010 08:55:11 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
INSERT INTO provider
            (provider_id, provider_name, provider_house_no_or_name,
             provider_addr_l1, provider_addr_l2, provider_addr_l3,
             provider_addr_l4, provider_post_code, provider_tel_no,
             provider_fax_no, bank_sort_code, bank_account_no,
             main_contact_name, main_contact_position,
             main_contact_house_no_or_name, main_contact_addr_l1,
             main_contact_addr_l2, main_contact_addr_l3,
             main_contact_addr_l4, main_contact_post_code,
             main_contact_tel_no, main_contact_fax_no, main_contact_email,
             fin_contact_name, fin_contact_position,
             fin_contact_house_no_or_name, fin_contact_addr_l1,
             fin_contact_addr_l2, fin_contact_addr_l3, fin_contact_addr_l4,
             fin_contact_post_code, fin_contact_tel_no, fin_contact_fax_no,
             fin_contact_email, securezip_password, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             outstanding_amount, last_updated_by,
             last_updated_on
            )
     VALUES (99, 'Provider ID Not Supplied/Unknown', NULL,
             NULL, NULL, NULL,
             NULL, NULL, NULL,
             NULL, NULL, NULL,
             'Unknown', NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL,
             NULL, NULL, '@',
             'Unknown', NULL,
             NULL, NULL,
             NULL, NULL, NULL,
             NULL, NULL, NULL,
             '@', NULL, 'N',
             'N', 0, 0,
             0, 'ILA500',
             TO_DATE ('07/28/2009 10:48:52 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
COMMIT ;


