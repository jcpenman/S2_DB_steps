-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--          25/01/11    A.Bowman (SAAS)              Amended size of doc_name in line with what is on DEV and SIT
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
--	      06/08/09	 D Crease 	
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STD_LETTERS.sql $
-- $Author: $
-- $Date: 2011-01-25 10:21:50 +0000 (Tue, 25 Jan 2011) $
-- $Revision: 6330 $
--
DROP TABLE SGAS.std_letters CASCADE CONSTRAINTS
/

--
-- STD_LETTERS  (Table) 
--
--   Row count:178 
CREATE TABLE SGAS.std_letters
(
    doc_name  VARCHAR2(20 BYTE)    NOT NULL,
    doc_desc  VARCHAR2(50 BYTE)    NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
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
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON COLUMN SGAS.std_letters.doc_name IS 'File name of original document.'
/
COMMENT ON COLUMN SGAS.std_letters.doc_desc IS 'Free text information on the file.'
/

DROP PUBLIC SYNONYM STD_LETTERS
/

--
-- STD_LETTERS  (Synonym) 
--
--  Dependencies: 
--   STD_LETTERS (Table)
--
CREATE PUBLIC SYNONYM STD_LETTERS FOR SGAS.STD_LETTERS
/

-- GRANT SELECT ON  SGAS.STD_LETTERS TO SGAS_QUERY
-- /
