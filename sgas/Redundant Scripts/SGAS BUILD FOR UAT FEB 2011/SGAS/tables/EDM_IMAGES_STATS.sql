/* EDM_IMAGES_STATS.sql
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
 
ALTER TABLE SGAS.EDM_IMAGES_STATS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.EDM_IMAGES_STATS CASCADE CONSTRAINTS
/

--
-- EDM_IMAGES_STATS  (Table) 
--
CREATE TABLE SGAS.EDM_IMAGES_STATS
(
  OBJECT_ID        VARCHAR2(44 BYTE),
  STUD_REF_NO      NUMBER(10),
  BATCH_TYPE_CODE  NUMBER(2),
  BATCH_ID         VARCHAR2(40 BYTE),
  SESSION_CODE     NUMBER(4)
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
-- EDM_IS_PK1  (Index) 
--
CREATE UNIQUE INDEX EDM_IS_PK1 ON SGAS.EDM_IMAGES_STATS
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

-- 
-- Non Foreign Key Constraints for Table EDM_IMAGES_STATS 
-- 
ALTER TABLE SGAS.EDM_IMAGES_STATS ADD (
  CONSTRAINT EDM_IS_PK1
 PRIMARY KEY
 (OBJECT_ID)
    USING INDEX 
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
               ))
/


