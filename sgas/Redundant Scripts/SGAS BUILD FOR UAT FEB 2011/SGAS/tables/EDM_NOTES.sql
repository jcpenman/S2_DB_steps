/* EDM_NOTES.sql
 *
 * Generated from SGAS schema in gv36eda.test2 database using TOAD.
 *
 * All objects into USERS tablespace.
 * Init storage now 100K
 *
 * Modification history: 
 * 30.11.2007 Initial Version   Robert Hunter
 *
 */
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/EDM_NOTES.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $
--

DROP TABLE SGAS.EDM_NOTES CASCADE CONSTRAINTS
/

--
-- EDM_NOTES  (Table) 
--
CREATE TABLE SGAS.EDM_NOTES
(
  STUD_REF_NO  NUMBER(10)                       NOT NULL,
  EDM_NOTES    VARCHAR2(200 BYTE)               NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
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
-- EDM_NOTES_IDX01  (Index) 
--
CREATE INDEX EDM_NOTES_IDX01 ON SGAS.EDM_NOTES
(STUD_REF_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             500K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

