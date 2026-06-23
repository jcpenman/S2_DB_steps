/******************************************************************************
TABLE NAME: COMPLETED_TEC        
DESCRIPTION: Table holding travel expenses claim data

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        09.10.2009  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
DROP TABLE SGAS.COMPLETED_TEC CASCADE CONSTRAINTS PURGE
/
--
-- COMPLETED_TEC  (Table) 
--
CREATE TABLE SGAS.COMPLETED_TEC
(CLAIM_ID            NUMBER(10)                NOT NULL,
 USERNAME            VARCHAR2(25 BYTE)         NOT NULL,
 STUD_REF_NO         NUMBER(10)                NOT NULL,
 SESSION_CODE        NUMBER(4)                 NOT NULL,
 FORENAMES           VARCHAR2(25 BYTE)         NOT NULL,
 SURNAME             VARCHAR2(25 BYTE)         NOT NULL,
 HOME_HOUSE_NO_NAME  VARCHAR2(32 BYTE)         NOT NULL,
 HOME_ADDR_L1        VARCHAR2(65 BYTE)         NOT NULL,
 HOME_ADDR_L2        VARCHAR2(65 BYTE),
 HOME_ADDR_L3        VARCHAR2(32 BYTE),
 HOME_ADDR_L4        VARCHAR2(32 BYTE),
 HOME_POSTCODE       VARCHAR2(8 BYTE),
 INST_NAME           VARCHAR2(50 BYTE)         NOT NULL,
 INST_CODE           VARCHAR2(5 BYTE),
 COURSE_TITLE        VARCHAR2(50 BYTE)         NOT NULL,
 COURSE_CODE         VARCHAR2(4 BYTE),
 TOTAL_AMOUNT        NUMBER(9,2)               NOT NULL,
 STATUS              VARCHAR2(25 BYTE),
 WEB_SUBMITTED_DATE  DATE                      NOT NULL,
 OBJECT_ID           VARCHAR2(44 BYTE),
 AUTHENTICATED       VARCHAR2(1 BYTE),
 ERROR_TEXT          VARCHAR2(1000 BYTE)
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


CREATE UNIQUE INDEX CTEC_IND1 ON SGAS.COMPLETED_TEC
(CLAIM_ID)
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

CREATE OR REPLACE TRIGGER SGAS.trav_auth
   AFTER INSERT
   ON SGAS.COMPLETED_TEC    REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   p_web_user_id    completed_tec.username%TYPE        := :NEW.username;
   p_stud_ref_no    completed_tec.stud_ref_no%TYPE     := :NEW.stud_ref_no;
   p_authenticate   completed_tec.AUTHENTICATED%TYPE   := :NEW.AUTHENTICATED;
   error_message    VARCHAR2 (512);
/******************************************************************************
NAME: TRAV_AUTH
PURPOSE: After Insert trigger on SGAS.COMPLETED_TEC to authenticate student

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        09.10.2009  A.Bowman         Initial Version
1.1        03.11.2009  A.Bowman         Amended trigger in line with function spec changes

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $
$Author:  $
$Date:  $
$Revision:  $

*******************************************************************************/
BEGIN
   --DBMS_OUTPUT.put_line ('*******TRIGGER1 HAS FIRED*******');

   IF     (p_authenticate = 'N' OR p_authenticate IS NULL)
      AND p_stud_ref_no IS NOT NULL
      AND p_web_user_id IS NOT NULL
   THEN
      sgas.pk_steps_web.authenticate_student (:NEW.stud_ref_no,
                                              :NEW.username,
                                              error_message
                                             );
      --DBMS_OUTPUT.put_line ('*******TRIGGER2 HAS FIRED*******');

      IF (error_message IS NOT NULL)
      THEN
         raise_application_error
                              (-20000,
                                  'pk_steps_web.authenticate_student error: '
                               || error_message
                              );
      UPDATE COMPLETED_TEC
      SET AUTHENTICATED = 'E',
          ERROR_TEXT = 'Student could not be authenticated - please investigate'
      WHERE STUD_REF_NO = P_STUD_REF_NO;
      
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20000,
                               'TRAV_AUTH error: ' || SQLERRM || SQLCODE
                              );
      --DBMS_OUTPUT.put_line ('*******TRIGGER3 HAS FIRED*******');
END trav_auth;
/

SHOW ERRORS;

ALTER TABLE COMPLETED_TEC ADD (
  CONSTRAINT AUTHENTICATED_CC01
 CHECK (authenticated  in ('Y','N')));

ALTER TABLE COMPLETED_TEC ADD (
  CONSTRAINT CTEC_FK3 
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES STUD (STUD_REF_NO));

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM COMPLETED_TEC
/

CREATE PUBLIC SYNONYM COMPLETED_TEC FOR SGAS.COMPLETED_TEC
/


GRANT SELECT ON  SGAS.COMPLETED_TEC TO PUBLIC;