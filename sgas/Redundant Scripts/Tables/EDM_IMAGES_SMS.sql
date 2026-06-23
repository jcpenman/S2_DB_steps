/* EDM_IMAGES_SMS.sql
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
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/EDM_IMAGES_SMS.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $
--

DROP TABLE SGAS.EDM_IMAGES_SMS CASCADE CONSTRAINTS
/

--
-- EDM_IMAGES_SMS  (Table) 
--
CREATE TABLE SGAS.EDM_IMAGES_SMS
(
  OBJECT_ID        VARCHAR2(44 BYTE),
  STUD_REF_NO      NUMBER(10),
  BATCH_TYPE_CODE  NUMBER(2),
  BATCH_ID         VARCHAR2(40 BYTE),
  SESSION_CODE     NUMBER(4),
  SCAN_DATE        DATE
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
-- EDM_SMS_PK1  (Index) 
--
CREATE UNIQUE INDEX EDM_SMS_PK1 ON SGAS.EDM_IMAGES_SMS
(OBJECT_ID)
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

