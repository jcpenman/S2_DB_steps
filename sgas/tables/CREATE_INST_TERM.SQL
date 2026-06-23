--ALTER TABLE INST_TERM
-- DROP PRIMARY KEY CASCADE;

--DROP TABLE INST_TERM CASCADE CONSTRAINTS;

CREATE TABLE INST_TERM
(
  INST_CODE     VARCHAR2(5 BYTE) CONSTRAINT NN_INT_INST_CODE NOT NULL,
  SESSION_CODE  NUMBER(4) CONSTRAINT NN_INT_SESSION_CODE NOT NULL,
  TERM_NO       NUMBER(2) CONSTRAINT NN_INT_TERM_NO NOT NULL,
  START_DATE    DATE CONSTRAINT NN_INT_START_DATE NOT NULL,
  END_DATE      DATE CONSTRAINT NN_INT_END_DATE NOT NULL,
  DAYS          NUMBER(3) CONSTRAINT NN_INT_DAYS NOT NULL
)
TABLESPACE STEPS_DATA
LOGGING ;

INSERT INTO INST_TERM (INST_CODE, SESSION_CODE, TERM_NO, START_DATE, END_DATE, DAYS)
SELECT INST_CODE, SESSION_CODE, TERM_NO, START_DATE, END_DATE, DAYS
FROM INST_TERM@GRASS;

BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'INST_TERM'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE AUTO'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;

CREATE UNIQUE INDEX P_INT ON INST_TERM
(INST_CODE, SESSION_CODE, TERM_NO)
LOGGING
TABLESPACE STEPS_INDEX
COMPUTE STATISTICS;


CREATE OR REPLACE TRIGGER INSTM_UD
   AFTER INSERT OR DELETE OR UPDATE OF inst_code,
                                       session_code,
                                       term_no,
                                       days,
                                       start_date,
                                       end_date
   ON INST_TERM    FOR EACH ROW
DECLARE
   p_inst_code        inst_term_change.inst_code%TYPE        := NULL;
   p_session_code     inst_term_change.session_code%TYPE     := TO_CHAR (:OLD.session_code);
BEGIN
   IF INSERTING
   THEN
      p_inst_code := TO_CHAR (:NEW.inst_code);
      p_session_code := TO_CHAR (:NEW.session_code);
   ELSIF UPDATING
   THEN
      p_inst_code := TO_CHAR (:OLD.inst_code);
      p_session_code := TO_CHAR (:OLD.session_code);
   ELSIF DELETING
   THEN
      p_inst_code := TO_CHAR (:OLD.inst_code);
      p_session_code := TO_CHAR (:OLD.session_code);
   END IF;

   INSERT INTO inst_term_change
               (inst_code, session_code, change_date
               )
        VALUES (p_inst_code, p_session_code, SYSDATE
               );
   INSERT INTO SLCADMIN.RESET_INST_TERM RIT (RIT.INST_CODE, RIT.SESSION_CODE, RIT.TERM_NO  )
      SELECT DISTINCT NVL(:NEW.INST_CODE, :OLD.INST_CODE), NVL(:NEW.SESSION_CODE, :OLD.SESSION_CODE), NVL(:NEW.TERM_NO, :OLD.TERM_NO)
        FROM DUAL
       WHERE  NOT EXISTS
                        (SELECT 1
                           FROM SLCADMIN.RESET_INST_TERM RIT1
                          WHERE     RIT1.INST_CODE = NVL(:NEW.INST_CODE, :OLD.INST_CODE)
                                AND RIT1.SESSION_CODE = NVL(:NEW.SESSION_CODE, :OLD.SESSION_CODE)
                                AND RIT1.TERM_NO =  NVL(:NEW.TERM_NO, :OLD.TERM_NO) );

END instm_ud;


ALTER TABLE INST_TERM ADD (
  CONSTRAINT P_INT
  PRIMARY KEY
  (INST_CODE, SESSION_CODE, TERM_NO)
  USING INDEX P_INT
  ENABLE VALIDATE);

GRANT SELECT ON INST_TERM TO SGAS_EUL;
GRANT SELECT ON INST_TERM TO SLCADMIN;

GRANT DELETE, INSERT, SELECT, UPDATE ON INST_TERM TO STEPS_SGAS_ROLE;

--DROP MATERIALIZED VIEW LOG ON INST_TERM;
CREATE MATERIALIZED VIEW LOG ON INST_TERM
TABLESPACE STEPS_DATA
LOGGING
WITH ROWID
EXCLUDING NEW VALUES;