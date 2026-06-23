-- INST_LOCATION.sql
-- Description: Table holding all INST_LOCATIONs for SGAS
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.02.11    A.Bowman  (SAAS)        Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $


DROP TABLE SGAS.INST_LOCATION CASCADE CONSTRAINTS PURGE
/
--
-- INST_LOCATION  (Table) 
--
CREATE TABLE SGAS.INST_LOCATION
(
  inst_location_id            NUMBER(10)       NOT NULL,
  descript                    VARCHAR2(100 BYTE) NOT NULL,
  last_updated_by             VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on             DATE                     DEFAULT SYSDATE               NOT NULL
)
TABLESPACE users
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
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

COMMENT ON COLUMN SGAS.INST_LOCATION.INST_LOCATION_id IS 'Unique INST_LOCATION reference number';

COMMENT ON COLUMN SGAS.INST_LOCATION.descript IS 'Description of data item';

COMMENT ON COLUMN SGAS.INST_LOCATION.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN SGAS.INST_LOCATION.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX INST_LOCATION_pk ON SGAS.INST_LOCATION
(INST_LOCATION_ID)
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






-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM INST_LOCATION
/
CREATE PUBLIC SYNONYM INST_LOCATION FOR sgas.INST_LOCATION
/
DROP SEQUENCE SGAS.INST_LOCATION_id_seq
/

--
-- INST_LOCATION_ID_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.INST_LOCATION_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
                                                                        

--
-- INSERT DATA
--

INSERT INTO INST_LOCATION
            (inst_location_id, descript
            )
     VALUES (inst_location_id_seq.nextval, 'SCOTLAND'  
            );
INSERT INTO INST_LOCATION
            (inst_location_id, descript
            )
     VALUES (inst_location_id_seq.nextval, 'ENGLAND - LONDON'  
            );
INSERT INTO INST_LOCATION
            (inst_location_id, descript
            )
     VALUES (inst_location_id_seq.nextval, 'ENGLAND - NON LONDON'  
            );
INSERT INTO INST_LOCATION
            (inst_location_id, descript
            )
     VALUES (inst_location_id_seq.nextval, 'WALES'  
            );
INSERT INTO INST_LOCATION
            (inst_location_id, descript
            )
     VALUES (inst_location_id_seq.nextval, 'NORTHERN IRELAND'  
            );
INSERT INTO INST_LOCATION
            (inst_location_id, descript
            )
     VALUES (inst_location_id_seq.nextval, 'REPUBLIC OF IRELAND'  
            );
INSERT INTO INST_LOCATION
            (inst_location_id, descript
            )
     VALUES (inst_location_id_seq.nextval, 'OTHER EU'  
            );     
 
COMMIT ;