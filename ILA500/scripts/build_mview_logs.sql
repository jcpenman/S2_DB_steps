---------------------------------------------------------------------
-- build_steps_mview_logs.sql
--
-- REQUIREMENTS: 
-- Based on the requirements outlined in the BT design. See
-- RFC 228 STEPS Integration and RFC 232 Session 2008-2009 - Phase 3 Web Changes - I3.doc section 5.4.3
-- 
-- DESCRIPTION:
-- This script controls the build of LOGS for materialized views on steps tables containing data that must be replicated to the web database.
-- In the development environment the web database is on 192.168.186.4,
-- STEPS is on 192.168.186.2
--
-- PARAMETERS:
-- None
--
-- DEPENDENCIES:
-- This script may be called from build_mview_logs.sh
--
-- AUTHOR: Steve Durkin (Sopra UK).
-- 
--  MODIFICATION HISTORY:
--  REF     Author                      Date                Desc
--  000     S Durkin (Sopra)    10/01/2008  Initial version.
--
--  CONFIGURATION MANAGEMENT:
--  $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/scripts/build_mview_logs.sql $ 
--  $Author: $ 
--  $Date: 2008-10-01 14:26:02 +0100 (Wed, 01 Oct 2008) $ 
--  $Revision: 1236 $ 
---------------------------------------------------------------------

set heading off
set feedback on

DROP MATERIALIZED VIEW LOG ON benefactor;       
DROP MATERIALIZED VIEW LOG ON complete_web_applications;
DROP MATERIALIZED VIEW LOG ON stud;
DROP MATERIALIZED VIEW LOG ON stud_app_prog;
DROP MATERIALIZED VIEW LOG ON stud_cont_details;
DROP MATERIALIZED VIEW LOG ON stud_crse_year;
DROP MATERIALIZED VIEW LOG ON stud_home_addr;
DROP MATERIALIZED VIEW LOG ON stud_session;
DROP MATERIALIZED VIEW LOG ON stud_term_addr;
DROP MATERIALIZED VIEW LOG ON stud_trav_prog;

CREATE MATERIALIZED VIEW LOG ON benefactor
    WITH SEQUENCE, ROWID INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW LOG ON complete_web_applications
    WITH SEQUENCE, ROWID INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW LOG ON stud
    WITH SEQUENCE, ROWID INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW LOG ON stud_app_prog
    WITH SEQUENCE, ROWID INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW LOG ON stud_cont_details
    WITH SEQUENCE, ROWID INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW LOG ON stud_crse_year
    WITH SEQUENCE, ROWID INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW LOG ON stud_home_addr
    WITH SEQUENCE, ROWID INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW LOG ON stud_session
    WITH SEQUENCE, ROWID INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW LOG ON stud_term_addr
    WITH SEQUENCE, ROWID INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW LOG ON stud_trav_prog
    WITH SEQUENCE, ROWID INCLUDING NEW VALUES;
