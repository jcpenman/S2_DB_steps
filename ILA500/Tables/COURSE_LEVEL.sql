-- TABLE: COURSE_LEVEL
-- Description: Table containing ILA500 Course Level Info. 
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      26.06.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      11.07.08   A.Bowman (SAAS)         Typo on last_updated_by column fixed    
-- 1.2      01.10.08   A.Bowman (SAAS)         A course_level_desc change required an increase in size of the column
-- 1.3      14.07.09   A.Bowman (SAAS)         Added course_level data and triggers to script 
-- 1.4      19.10.09   A.Bowman (SAAS)         Added sequence
-- 1.5      03.11.09   A.Bowman (SAAS)         Added new course_level data
-- 1.6      23.11.09   A.Bowman (SAAS)         Removed course_level added at 1.5, namely NVQ/SVQ
-- 1.7      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/COURSE_LEVEL.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
 
ALTER TABLE COURSE_LEVEL
 DROP PRIMARY KEY CASCADE
/
DROP TABLE COURSE_LEVEL CASCADE CONSTRAINTS PURGE
/

--
-- COURSE_LEVEL (Table) 
--

CREATE TABLE COURSE_LEVEL
(
  COURSE_ID           NUMBER(10)                   NOT NULL,
  COURSE_LEVEL_DESC   VARCHAR2(80 BYTE)            NOT NULL,
  LAST_UPDATED_BY     VARCHAR2(15 BYTE)            DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON     DATE                         DEFAULT SYSDATE               NOT NULL
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

COMMENT ON TABLE COURSE_LEVEL IS 'Table containing ILA500 Course Level Info. ';

COMMENT ON COLUMN COURSE_LEVEL.COURSE_ID IS 'Unique identifier for each course level';

COMMENT ON COLUMN COURSE_LEVEL.COURSE_LEVEL_DESC IS 'The level of the course eg HNC, HND, Degree etc';

COMMENT ON COLUMN COURSE_LEVEL.LAST_UPDATED_BY IS 'The user to last update or insert a row on the course_level table';

COMMENT ON COLUMN COURSE_LEVEL.LAST_UPDATED_ON IS 'The date of the latest update or insert on the course_level table';


CREATE UNIQUE INDEX COURSE_LEVEL_PK ON COURSE_LEVEL
(COURSE_ID)
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


ALTER TABLE COURSE_LEVEL ADD (
  CONSTRAINT COURSE_LEVEL_PK
 PRIMARY KEY
 (COURSE_ID)
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

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM COURSE_LEVEL
/

CREATE PUBLIC SYNONYM COURSE_LEVEL FOR ILA500.COURSE_LEVEL
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON COURSE_LEVEL
TO EDM_USER
/

--
-- Course_Level Standing data
--

DELETE FROM COURSE_LEVEL; 

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(1,'ADVANCED DIPLOMA (ADVDIP)');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(2,'CERTIFICATE IN HIGHER EDUCATION (CERTHE)');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(3,'DEGREE');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(4,'DIPLOMA IN HIGHER EDUCATION (DIPHE)');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(5,'GRADUATE CERTIFICATE (GRADCERT)');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(6,'GRADUATE DIPLOMA (GRADDIP)');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(7,'HIGHER NATIONAL CERTIFICATE (HNC)');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(8,'HIGHER NATIONAL DIPLOMA (HND)');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(9,'PROFESSIONAL GRADUATE CERTIFICATE/DIPLOMA IN EDUCATION (PGCE/PGDE)');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(10,'SCQF LEVEL 7');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(11,'SCQF LEVEL 8');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(12,'SCQF LEVEL 9');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(13,'SCQF LEVEL 10');

--- 1.4

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(14,'PROFESSIONAL DEVELOPMENT AWARDS (PDAS) SCQF LEVEL 7');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(15,'PROFESSIONAL DEVELOPMENT AWARDS (PDAS) SCQF LEVEL 8');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(16,'PROFESSIONAL DEVELOPMENT AWARDS (PDAS) SCQF LEVEL 9');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(17,'PROFESSIONAL DEVELOPMENT AWARDS (PDAS) SCQF LEVEL 10');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(18,'CONTINUING PROFESSIONAL DEVELOPMENT (CPD) SCQF LEVEL 7');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(19,'CONTINUING PROFESSIONAL DEVELOPMENT (CPD) SCQF LEVEL 8');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(20,'CONTINUING PROFESSIONAL DEVELOPMENT (CPD) SCQF LEVEL 9');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(21,'CONTINUING PROFESSIONAL DEVELOPMENT (CPD) SCQF LEVEL 10');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(22,'PROFESSIONAL DEVELOPMENT AWARDS (PDAS) SCQF LEVEL 11');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(23,'CONTINUING PROFESSIONAL DEVELOPMENT (CPD) SCQF LEVEL 11');

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(24,'POSTGRADUATE SCQF LEVEL 11');

--- 1.5

INSERT INTO COURSE_LEVEL (COURSE_ID,COURSE_LEVEL_DESC) 
VALUES 
(99,'Course ID Not Supplied/Unknown');

COMMIT;


DROP SEQUENCE course_id_seq
/

--
-- course_id_seq  (Sequence) 
--
CREATE SEQUENCE course_id_seq
  START WITH 100
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_course_level_seq BEFORE INSERT ON COURSE_LEVEL
FOR EACH ROW
BEGIN
SELECT course_id_seq.NEXTVAL into :new.course_id FROM dual;
END;

/* Formatted on 2008/07/08 16:57 (Formatter Plus v4.8.8) */
-- TRIGGER: COU_LEV_IUD
-- TABLE: COURSE_LEVEL
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/COURSE_LEVEL.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.cou_lev_iud
   AFTER DELETE OR INSERT OR UPDATE OF course_id, course_level_desc, last_updated_by
   ON ila500.course_level
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   course_level_aud.column_name%TYPE   := NULL;
   p_primary_key   course_level_aud.primary_key%TYPE   := :OLD.course_id;
   p_old           course_level_aud.OLD%TYPE           := NULL;
   p_new           course_level_aud.NEW%TYPE           := NULL;
   p_action        course_level_aud.action%TYPE        := NULL;
   p_username      course_level_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.course_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'COURSE_ID';
   p_old := :OLD.course_id;
   p_new := :NEW.course_id;
   pk_pop_aud.ins_cou_lev_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_LEVEL_DESC';
   p_old := :OLD.course_level_desc;
   p_new := :NEW.course_level_desc;
   pk_pop_aud.ins_cou_lev_aud (p_aud_date,
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
   pk_pop_aud.ins_cou_lev_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END cou_lev_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:40 (Formatter Plus v4.8.8) */
-- TRIGGER: COU_LEV_LUB
-- TABLE: COURSE_LEVEL
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/COURSE_LEVEL.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.cou_lev_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.course_level
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   course_level_aud.column_name%TYPE   := NULL;
   p_primary_key   course_level_aud.primary_key%TYPE   := :OLD.course_id;
   p_old           course_level_aud.OLD%TYPE           := NULL;
   p_new           course_level_aud.NEW%TYPE           := NULL;
   p_action        course_level_aud.action%TYPE        := NULL;
   p_username      course_level_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.course_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_cou_lev_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END cou_lev_lub;
/
SHOW ERRORS;*/