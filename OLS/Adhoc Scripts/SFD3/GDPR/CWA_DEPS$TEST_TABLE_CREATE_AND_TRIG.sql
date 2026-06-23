CREATE TABLE COMPLETE_WEB_APP_DEP$TEST
(
    AUD_TIMESTAMP DATE,
    AUD_USER VARCHAR2(30),
    APPLICATION_ID NUMBER(10,0) NOT NULL ENABLE,
    STUD_REF_NO NUMBER(10,0),
    STUD_DEP_ID NUMBER,
    FORENAMES VARCHAR2(25),
    SURNAME VARCHAR2(25),
    DOB DATE,
    DEPENDENT_RELATIONSHIP_ID NUMBER(4,0),
    TOTAL_INCOME NUMBER(9,2),
    EMAIL_ADDR VARCHAR2(80),
    POST_CODE VARCHAR2(8),
    HOUSE_NO_NAME VARCHAR(32),
    ADDR_L1 VARCHAR2(65),
    ADDR_L2 VARCHAR2(65),
    ADDR_L3 VARCHAR2(32),
    ADDR_L4 VARCHAR2(32),
    LPG VARCHAR2(1)
);

CREATE OR REPLACE TRIGGER SGAS.COMPLETE_WEB_APP_DEP$TRIG
   /*
         Trigger added 05/12/2018 to support WEB to StEPS
         data transfer validation.

         Created by C.Bolan

         */
   AFTER INSERT OR UPDATE
   ON sgas.complete_web_app_dep
   FOR EACH ROW
BEGIN
   IF INSERTING
   THEN
      INSERT INTO sgas.complete_web_app_dep$test 
      (aud_timestamp, 
       aud_user,
         APPLICATION_ID,
         STUD_REF_NO, 
         STUD_DEP_ID,
         FORENAMES,
         SURNAME,
         DOB,
         DEPENDENT_RELATIONSHIP_ID,
         TOTAL_INCOME,
         EMAIL_ADDR, 
         POST_CODE,
         HOUSE_NO_NAME,
         ADDR_L1,
         ADDR_L2, 
         ADDR_L3, 
         ADDR_L4, 
         LPG)
       VALUES (SYSDATE,
               USER,
               :NEW.APPLICATION_ID,
               :NEW.STUD_REF_NO, 
               :NEW.STUD_DEP_ID,
               :NEW.FORENAMES,
               :NEW.SURNAME,
               :NEW.DOB,
               :NEW.DEPENDENT_RELATIONSHIP_ID,
               :NEW.TOTAL_INCOME,
               :NEW.EMAIL_ADDR, 
               :NEW.POST_CODE,
               :NEW.HOUSE_NO_NAME,
               :NEW.ADDR_L1,
               :NEW.ADDR_L2, 
               :NEW.ADDR_L3, 
               :NEW.ADDR_L4, 
               :NEW.LPG);
    END IF;

 END;