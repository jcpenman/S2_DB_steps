/******************************************************************************
TABLE NAME: STUD_INCOME_AUD        
DESCRIPTION: Table holding audit data for the STUD_INCOME table

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        19.11.2012  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
ALTER TABLE SGAS.STUD_INCOME_AUD
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STUD_INCOME_AUD CASCADE CONSTRAINTS
/
--
-- STUD_INCOME_AUD  (Table) 
--
CREATE TABLE SGAS.STUD_INCOME_AUD
( AUD_ID            NUMBER(10),
  AUD_DATE          DATE,
  COLUMN_NAME       VARCHAR2(32 BYTE),
  TABLE_PKEY1       VARCHAR2(32 BYTE),
  TABLE_PKEY2       VARCHAR2(32 BYTE),
  TABLE_PKEY3       VARCHAR2(32 BYTE),
  TABLE_PKEY4       VARCHAR2(32 BYTE),
  TABLE_PKEY5       VARCHAR2(32 BYTE),
  USERNAME          VARCHAR2(15 BYTE),
  OLD               VARCHAR2(400 BYTE),
  NEW               VARCHAR2(400 BYTE),
  ACTION            VARCHAR2(1 BYTE)
)
TABLESPACE STEPS_DATA
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

COMMENT ON TABLE SGAS.STUD_INCOME_AUD IS 'Table holding audit data for the TITLE table';

COMMENT ON COLUMN SGAS.STUD_INCOME_AUD.AUD_ID IS 'Unique identifier for each row on the table';

COMMENT ON COLUMN SGAS.STUD_INCOME_AUD.AUD_DATE IS 'Date the row on the audit table is created';

COMMENT ON COLUMN SGAS.STUD_INCOME_AUD.COLUMN_NAME IS 'Name of the column that is being audited';

COMMENT ON COLUMN SGAS.STUD_INCOME_AUD.TABLE_PKEY1 IS 'The unique identifier of the row on the table that is being audited';

COMMENT ON COLUMN SGAS.STUD_INCOME_AUD.OLD IS 'The old value';

COMMENT ON COLUMN SGAS.STUD_INCOME_AUD.NEW IS 'The new value';

COMMENT ON COLUMN SGAS.STUD_INCOME_AUD.ACTION IS 'The action carried out by the user, ie update, insert or delete';

COMMENT ON COLUMN SGAS.STUD_INCOME_AUD.USERNAME IS 'The unique identifier of the user making the change';


CREATE UNIQUE INDEX STUD_INCOME_AUD_PK ON SGAS.STUD_INCOME_AUD
(AUD_ID)
LOGGING
TABLESPACE STEPS_DATA
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


ALTER TABLE SGAS.STUD_INCOME_AUD ADD (
  CONSTRAINT STUD_INCOME_AUD_PK
 PRIMARY KEY
 (AUD_ID)
    USING INDEX 
    TABLESPACE STEPS_DATA
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
DROP PUBLIC SYNONYM STUD_INCOME_AUD
/

CREATE PUBLIC SYNONYM STUD_INCOME_AUD FOR SGAS.STUD_INCOME_AUD
/

--#TITLE_AUD.STUD_INCOME_AUD_ID SEQUENCE###############################
DROP SEQUENCE SGAS.STUD_INC_AUD_ID_SEQ;

CREATE SEQUENCE SGAS.STUD_INC_AUD_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


GRANT SELECT ON  SGAS.STUD_INC_AUD_ID_SEQ TO PUBLIC;