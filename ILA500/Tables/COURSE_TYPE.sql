-- TABLE: COURSE_TYPE
-- Description: Table containing ILA500 Course Type Info. 
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      26.06.08   A.Bowman (SAAS)         Initial Version.
-- 2.0      30.06.08   R.Hunter (SAAS)         Added FEE_CUT_OFF_DATE, FEE_PERIOD_START, FEE_PERIOD_END, SUBMITTED_DATE
-- 2.1      19.10.09   A.Bowman (SAAS)         Added triggers and data
-- 2.2      15.02.10   A.Bowman (SAAS)         Amended audit triggers  
-- 2.3      07.04.10   P.Hughes (SAAS)         Added new column SESSION_YEAR
--
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/COURSE_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
 
ALTER TABLE COURSE_TYPE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE COURSE_TYPE CASCADE CONSTRAINTS PURGE
/

--
-- COURSE_TYPE (Table) 
--

CREATE TABLE COURSE_TYPE
(
  COURSE_TYPE_ID     NUMBER(10)                 NOT NULL,
  BACS_PAYMENT_DATE  DATE                       NOT NULL,
  COURSE_TYPE_DESC   VARCHAR2(20 BYTE)          NOT NULL,
  FEE_CUT_OFF_DATE   DATE                       NOT NULL,
  FEE_PERIOD_START   DATE                       NOT NULL,
  FEE_PERIOD_END     DATE                       NOT NULL,
  SUBMITTED_DATE     DATE                       NOT NULL,
  BATCH_RUN_DATE     DATE                       ,
  SESSION_YEAR       NUMBER(4)                  NOT NULL,
  LAST_UPDATED_BY    VARCHAR2(15 BYTE)          DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON    DATE                       DEFAULT SYSDATE               NOT NULL
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

COMMENT ON TABLE COURSE_TYPE IS 'Table containing ILA500 Course Type Info';

COMMENT ON COLUMN COURSE_TYPE.COURSE_TYPE_ID IS 'Unique identifier for each course type';

COMMENT ON COLUMN COURSE_TYPE.BACS_PAYMENT_DATE IS 'The date the course fees will be paid';

COMMENT ON COLUMN COURSE_TYPE.COURSE_TYPE_DESC IS 'The course types is defined by when the fees will be paid ie January, April, July or October';

COMMENT ON COLUMN COURSE_TYPE.FEE_CUT_OFF_DATE IS 'Cut off date for courses to get into the fees run';
COMMENT ON COLUMN COURSE_TYPE.FEE_PERIOD_START IS 'There is a fee cut off date for courses starting between this date and the fee period end date';
COMMENT ON COLUMN COURSE_TYPE.FEE_PERIOD_END IS 'There is a fee cut off date for courses starting between the fee period start date and this date';
COMMENT ON COLUMN COURSE_TYPE.SUBMITTED_DATE IS 'Date fee payments submitted';
COMMENT ON COLUMN COURSE_TYPE.SESSION_YEAR IS 'This field is used to store the SESSION_YEAR each course type relates to';

COMMENT ON COLUMN COURSE_TYPE.LAST_UPDATED_BY IS 'The user to last update or insert a row on the course_type table';

COMMENT ON COLUMN COURSE_TYPE.LAST_UPDATED_ON IS 'The date of the latest update or insert on the course_type table';


CREATE UNIQUE INDEX COURSE_TYPE_PK ON COURSE_TYPE
(COURSE_TYPE_ID)
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


ALTER TABLE COURSE_TYPE ADD (
  CONSTRAINT COURSE_TYPE_PK
 PRIMARY KEY
 (COURSE_TYPE_ID)
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

/* Formatted on 2008/07/09 15:24 (Formatter Plus v4.8.8) */
-- TRIGGER: COU_TYPE_IUD
-- TABLE: COURSE_TYPE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/COURSE_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.cou_type_iud
   AFTER DELETE OR INSERT OR UPDATE OF course_type_id,
                                       bacs_payment_date,
                                       course_type_desc,
                                       fee_cut_off_date,
                                       fee_period_start,
                                       fee_period_end,
                                       submitted_date,
                                       batch_run_date,
                                       SESSION_YEAR,
                                       last_updated_by
   ON ila500.course_type
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   course_type_aud.column_name%TYPE   := NULL;
   p_primary_key   course_type_aud.primary_key%TYPE   := :OLD.course_type_id;
   p_old           course_type_aud.OLD%TYPE           := NULL;
   p_new           course_type_aud.NEW%TYPE           := NULL;
   p_action        course_type_aud.action%TYPE        := NULL;
   p_username      course_type_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.course_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'COURSE_TYPE_ID';
   p_old := :OLD.course_type_id;
   p_new := :NEW.course_type_id;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BACS_PAYMENT_DATE';
   p_old := :OLD.bacs_payment_date;
   p_new := :NEW.bacs_payment_date;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'COURSE_TYPE_DESC';
   p_old := :OLD.course_type_desc;
   p_new := :NEW.course_type_desc;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'FEE_CUT_OFF_DATE';
   p_old := :OLD.fee_cut_off_date;
   p_new := :NEW.fee_cut_off_date;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'FEE_PERIOD_START';
   p_old := :OLD.fee_period_start;
   p_new := :NEW.fee_period_start;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'FEE_PERIOD_END';
   p_old := :OLD.fee_period_end;
   p_new := :NEW.fee_period_end;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'SUBMITTED_DATE';
   p_old := :OLD.submitted_date;
   p_new := :NEW.submitted_date;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BATCH_RUN_DATE';
   p_old := :OLD.batch_run_date;
   p_new := :NEW.batch_run_date;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'SESSION_YEAR';
   p_old := :OLD.batch_run_date;
   p_new := :NEW.batch_run_date;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
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
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END cou_type_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:42 (Formatter Plus v4.8.8) */
-- TRIGGER: COU_TYPE_LUB
-- TABLE: COURSE_TYPE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/COURSE_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.cou_type_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.course_type
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   course_type_aud.column_name%TYPE   := NULL;
   p_primary_key   course_type_aud.primary_key%TYPE   := :OLD.course_type_id;
   p_old           course_type_aud.OLD%TYPE           := NULL;
   p_new           course_type_aud.NEW%TYPE           := NULL;
   p_action        course_type_aud.action%TYPE        := NULL;
   p_username      course_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.course_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END cou_type_lub;
/
SHOW ERRORS;*/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM COURSE_TYPE
/

CREATE PUBLIC SYNONYM COURSE_TYPE FOR ILA500.COURSE_TYPE
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON COURSE_TYPE
TO EDM_USER
/


DROP SEQUENCE course_type_id_seq
/

--
-- course_type_id_seq  (Sequence) 
--
CREATE SEQUENCE course_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_COURSE_TYPE_seq BEFORE INSERT ON COURSE_TYPE
FOR EACH ROW
BEGIN
SELECT course_type_id_seq.NEXTVAL into :new.course_type_id FROM dual;
END;
/

/* Formatted on 2009/02/09 17:15 (Formatter Plus v4.8.8) */
-- Reference data
-- Table: COURSE_TYPE 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      26.06.08    A.Bowman (SAAS)         Initial Version.    
-- 2.0      30.06.08    R.Hunter (SAAS)         Added 4 new columns FEE_CUT_OFF_DATE, FEE_PERIOD_START, FEE_PERIOD_END, SUBMITTED_DATE
-- 3.0      09.10.08    A.Bowman (SAAS)         Amended bacs_payment_date for October Payment
-- 4.0      09.02.09    A.Bowman (SAAS)         Added new data for SESSION_YEAR 2009/2010
-- 5.0      21.04.09    A.Bowman (SAAS)         Updated to reflect live dates provided by Ruth Ralph
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/COURSE_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 

delete from course_type;

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('01/20/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'JANUARY PAYMENT',
             TO_DATE ('12/01/2008 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('08/01/2008 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('12/31/2008 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/06/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/02/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2008,
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('04/07/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'APRIL PAYMENT',
             TO_DATE ('03/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/31/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/24/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/20/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2008,
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('07/07/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'JULY PAYMENT',
             TO_DATE ('06/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('04/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/30/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/23/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/19/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2008,
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('10/07/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'OCTOBER PAYMENT',
             TO_DATE ('07/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('07/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('07/31/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('09/23/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('09/19/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2008,
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('01/20/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'JANUARY PAYMENT',
             TO_DATE ('12/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('08/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('12/31/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/06/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/02/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2009,
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('04/06/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'APRIL PAYMENT',
             TO_DATE ('03/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/31/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/23/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/19/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2009,
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('07/06/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'JULY PAYMENT',
             TO_DATE ('06/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('04/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/30/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/22/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/18/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2009,
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('10/07/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'OCTOBER PAYMENT',
             TO_DATE ('07/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('07/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('07/31/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('09/23/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('09/19/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2009,
             'ILA500',
             TO_DATE ('04/21/2010 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('01/20/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'JANUARY PAYMENT',
             TO_DATE ('12/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('08/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('12/31/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/06/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/02/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2010,
             'ILA500',
             TO_DATE ('04/21/2010 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('04/06/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'APRIL PAYMENT',
             TO_DATE ('03/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/31/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/23/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/19/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2010,
             'ILA500',
             TO_DATE ('04/21/2010 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('07/06/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'JULY PAYMENT',
             TO_DATE ('06/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('04/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/30/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/22/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/18/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2010,
             'ILA500',
             TO_DATE ('04/21/2010 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
            
INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             SESSION_YEAR,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('10/07/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'OCTOBER PAYMENT',
             TO_DATE ('07/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('07/01/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('07/31/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('09/23/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('09/19/2011 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             2010,
             'ILA500',
             TO_DATE ('04/21/2011 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );
COMMIT;