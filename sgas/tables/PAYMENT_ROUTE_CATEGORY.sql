-- PAYMENT_ROUTE_CATEGORY.sql
-- Description: This table is used to hold payment routes for StEPS
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      23.08.11    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.PAYMENT_ROUTE_CATEGORY
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.PAYMENT_ROUTE_CATEGORY CASCADE CONSTRAINTS PURGE
/
--
-- PAYMENT_ROUTE_CATEGORY  (Table) 
--
CREATE TABLE sgas.PAYMENT_ROUTE_CATEGORY
(
  PAYMENT_ROUTE_ID                  VARCHAR2(1 BYTE) NOT NULL,
  DESCRIPTION                       VARCHAR2(20 BYTE) NOT NULL,
  last_updated_by                  VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on                  DATE                     DEFAULT SYSDATE               NOT NULL
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


CREATE UNIQUE INDEX PAYMENT_ROUTE_CATEGORY_PK ON sgas.PAYMENT_ROUTE_CATEGORY
(PAYMENT_ROUTE_ID)
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

ALTER TABLE sgas.PAYMENT_ROUTE_CATEGORY ADD (
  CONSTRAINT PAYMENT_ROUTE_CATEGORY_PK
 PRIMARY KEY
 (PAYMENT_ROUTE_ID)
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



-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PAYMENT_ROUTE_CATEGORY
/
CREATE PUBLIC SYNONYM PAYMENT_ROUTE_CATEGORY FOR sgas.PAYMENT_ROUTE_CATEGORY
/
                                                                        
--
-- INSERT DATA
--

INSERT INTO PAYMENT_ROUTE_CATEGORY
            (payment_route_id, description 
            )
     VALUES ('O', 'OVERSEAS'  
            );

INSERT INTO PAYMENT_ROUTE_CATEGORY
            (payment_route_id, description 
            )
     VALUES ('M', 'MEDICAL PLACEMENT'  
            );

INSERT INTO PAYMENT_ROUTE_CATEGORY
            (payment_route_id, description 
            )
     VALUES ('G', 'OTHER PGCE'  
            );

INSERT INTO PAYMENT_ROUTE_CATEGORY
            (payment_route_id, description 
            )
     VALUES ('P', 'WORK PLACEMENT'  
            );

INSERT INTO PAYMENT_ROUTE_CATEGORY
            (payment_route_id, description 
            )
     VALUES ('U', 'NORMAL'  
            );


COMMIT ;