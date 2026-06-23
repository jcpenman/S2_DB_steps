/******************************************************************************
TABLE NAME: NOMINEE_AUD        
DESCRIPTION: Table holding audit data for the NOMINEE table

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        01.09.2009  J.Penman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
ALTER TABLE SGAS.NOMINEE_AUD
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.NOMINEE_AUD CASCADE CONSTRAINTS
/
--
-- NOMINEE_AUD  (Table) 
--
CREATE TABLE SGAS.NOMINEE_AUD
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
  ACTION            VARCHAR2(1 BYTE),
  STUD_REF_NO       NUMBER(10),
  INST_CODE         VARCHAR2(5 BYTE),
  SESSION_CODE      NUMBER(4)
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

COMMENT ON TABLE SGAS.NOMINEE_AUD IS 'Table holding audit data for the NOMINEE table';

COMMENT ON COLUMN SGAS.NOMINEE_AUD.AUD_ID IS 'Unique identifier for each row on the table';

COMMENT ON COLUMN SGAS.NOMINEE_AUD.AUD_DATE IS 'Date the row on the audit table is created';

COMMENT ON COLUMN SGAS.NOMINEE_AUD.COLUMN_NAME IS 'Name of the column that is being audited';

COMMENT ON COLUMN SGAS.NOMINEE_AUD.TABLE_PKEY1 IS 'The unique identifier of the row on the table that is being audited';

COMMENT ON COLUMN SGAS.NOMINEE_AUD.OLD IS 'The old value';

COMMENT ON COLUMN SGAS.NOMINEE_AUD.NEW IS 'The new value';

COMMENT ON COLUMN SGAS.NOMINEE_AUD.ACTION IS 'The action carried out by the user, ie update, insert or delete';

COMMENT ON COLUMN SGAS.NOMINEE_AUD.USERNAME IS 'The unique identifier of the user making the change';


CREATE UNIQUE INDEX NOMINEE_AUD_PK ON SGAS.NOMINEE_AUD
(AUD_ID)
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


ALTER TABLE SGAS.NOMINEE_AUD ADD (
  CONSTRAINT NOMINEE_AUD_PK
 PRIMARY KEY
 (AUD_ID)
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
DROP PUBLIC SYNONYM NOMINEE_AUD
/

CREATE PUBLIC SYNONYM NOMINEE_AUD FOR SGAS.NOMINEE_AUD
/

--#NOMINEE_AUD_ID SEQUENCE###############################
DROP SEQUENCE SGAS.NOMINEE_AUD_ID_SEQ;

CREATE SEQUENCE SGAS.NOMINEE_AUD_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


GRANT SELECT ON  SGAS.NOMINEE_AUD_ID_SEQ TO PUBLIC;