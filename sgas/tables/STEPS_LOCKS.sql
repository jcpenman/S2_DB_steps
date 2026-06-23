-- 
-- steps_locks.sql - create table script.
-- Support locks on student data for specific change types, e.g. address details, bank details and so on.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author          Desc.
--            29.09.08   S Durkin       Initial Version.
--  
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE SGAS.STEPS_LOCKS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STEPS_LOCKS CASCADE CONSTRAINTS
/

--
-- STEPS_LOCKS  (Table) 
--
CREATE TABLE SGAS.STEPS_LOCKS
(
  OBJECT_ID    VARCHAR2(44 BYTE)                    NULL,
  BATCH_TYPE   VARCHAR2(10 BYTE)                    NULL,
  LOCK_TYPE    VARCHAR2(25 BYTE)                    NULL,
  COMBINATION  VARCHAR2(250 BYTE)                   NULL,
  DATETIME     DATE                                 NULL,
  CONSTRAINT STEPS_LOCKS_PK
 PRIMARY KEY
 (BATCH_TYPE, LOCK_TYPE, COMBINATION)
)
/
