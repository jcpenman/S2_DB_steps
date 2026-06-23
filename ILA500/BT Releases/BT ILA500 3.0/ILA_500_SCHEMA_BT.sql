/* ILA_500_SCHEMA_BT.sql
 *
 * ILA 500 Schema Creation script for STEPS database 
 *
 * Author: R Hunter (SAAS) 09/04/2008
 * 
 * VERSION HISTORY:
 * ----------------
 *  MODIFIED BY             REASON              DATE
 * -------------            ------              ----
 *
 *
 */
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/BT%20Releases/BT%20ILA500%203.0/ILA_500_SCHEMA_BT.sql $
-- $Author: $
-- $Date: 2008-10-07 13:29:55 +0100 (Tue, 07 Oct 2008) $
-- $Revision: 1293 $

CREATE PROFILE ila500_user LIMIT
   SESSIONS_PER_USER          UNLIMITED
   CPU_PER_SESSION            UNLIMITED
   CPU_PER_CALL               UNLIMITED
   CONNECT_TIME               UNLIMITED
   LOGICAL_READS_PER_SESSION  DEFAULT
   LOGICAL_READS_PER_CALL     UNLIMITED
   PRIVATE_SGA                UNLIMITED
   COMPOSITE_LIMIT            UNLIMITED
/


--
-- ILA500  (User) 
--
CREATE USER ila500
  IDENTIFIED BY ila501
  DEFAULT TABLESPACE users
  TEMPORARY TABLESPACE temp
  PROFILE ila500_user
  ACCOUNT UNLOCK
/
-- 2 Roles for ILA500 
GRANT   olap_user TO ila500
/
GRANT   edm_user TO ila500
/
ALTER   USER ila500 DEFAULT ROLE ALL
/
-- 12 System Privileges for ILA500 
GRANT   CREATE VIEW TO ila500
/
GRANT   CREATE SESSION TO ila500
/
GRANT   CREATE TRIGGER TO ila500
/
GRANT   CREATE PROCEDURE TO ila500
/
GRANT   CREATE SEQUENCE TO ila500
/
GRANT   DROP PUBLIC SYNONYM TO ila500
/
GRANT   UNLIMITED TABLESPACE TO ila500
/
GRANT   CREATE SYNONYM TO ila500
/
GRANT   CREATE TABLE TO ila500
/
GRANT   ALTER SESSION TO ila500
/
GRANT   DROP ANY SEQUENCE TO ila500
/
GRANT   CREATE PUBLIC SYNONYM TO ila500
/
-- 1 Tablespace Quota for ILA500 
ALTER   USER ila500 QUOTA UNLIMITED ON users
/