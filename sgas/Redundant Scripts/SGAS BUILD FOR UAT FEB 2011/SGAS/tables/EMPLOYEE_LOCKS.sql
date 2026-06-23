/******************************************************************************
TABLE NAME: EMPLOYEE_LOCKS        
DESCRIPTION: Table holding locked steps cases for a particular user 

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        26.10.2010  A.Bowman         Initial Version 


CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
ALTER TABLE SGAS.EMPLOYEE_LOCKS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.EMPLOYEE_LOCKS CASCADE CONSTRAINTS PURGE
/
--
-- EMPLOYEE_LOCKS  (Table) 
--

CREATE TABLE SGAS.EMPLOYEE_LOCKS

( USERNAME           VARCHAR2(15 BYTE) NOT NULL,
  REFERENCE_ID       VARCHAR2(20 BYTE) NOT NULL,
  REFERENCE_TYPE_ID  VARCHAR2(20 BYTE) NOT NULL,
  TTL                DATE  NOT NULL
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

CREATE UNIQUE INDEX employee_locks_pk ON sgas.employee_locks
(username)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE sgas.employee_locks ADD (
  CONSTRAINT employee_locks_pk
 PRIMARY KEY
 (username)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64 k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));
               
ALTER TABLE SGAS.EMPLOYEE_LOCKS ADD (
  CONSTRAINT F1_EL 
 FOREIGN KEY (USERNAME) 
 REFERENCES SGAS.EMPLOYEE (USERNAME));

/* Formatted on 2010/10/28 14:25 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER sgas.trig_emp_lock_iud
   AFTER INSERT
   ON sgas.employee_locks
   FOR EACH ROW
DECLARE
   p_ref_type_id    employee_locks.reference_type_id%TYPE
                                                    := :NEW.reference_type_id;
   p_username       employee_locks.username%TYPE            := :NEW.username;
   p_reference_id   employee_locks.reference_id%TYPE     := :NEW.reference_id;
   v_case_number    employee_cases.case_number%TYPE;
   v_ref_id         employee_cases.reference_id%TYPE;
BEGIN

   IF p_ref_type_id = 'STUDENT'
   THEN
      
      SELECT count (ec.reference_id)
        INTO v_ref_id
        FROM employee_cases ec
       WHERE ec.reference_id = p_reference_id;

      IF v_ref_id = 0
      THEN
         SELECT MAX (ec.case_number)
           INTO v_case_number
           FROM employee_cases ec
          WHERE ec.username = p_username;

         IF v_case_number IS NULL
         THEN
            INSERT INTO employee_cases
                        (username, reference_id, case_number, date_entered
                        )
                 VALUES (p_username, p_reference_id, 1, SYSDATE
                        );
         ELSIF v_case_number < 10
         THEN
            UPDATE employee_cases ec
               SET ec.case_number = ec.case_number + 1
             WHERE ec.username = p_username;

            INSERT INTO employee_cases
                        (username, reference_id, case_number, date_entered
                        )
                 VALUES (p_username, p_reference_id, 1, SYSDATE
                        );
         ELSIF v_case_number = 10
         THEN
            DELETE      employee_cases ec
                  WHERE ec.case_number = 10 AND ec.username = p_username;

            UPDATE employee_cases ec
               SET ec.case_number = ec.case_number + 1
             WHERE ec.username = p_username;

            INSERT INTO employee_cases
                        (username, reference_id, case_number, date_entered
                        )
                 VALUES (p_username, p_reference_id, 1, SYSDATE
                        );
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      v_ref_id := 0;
      v_case_number := 0;
END trig_emp_lock_iud;
/

