/* Formatted on 2009/07/15 14:37 (Formatter Plus v4.8.8) */
-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- Modification History
-- Date          Author       Ref   Desc
-- 15.07.2009   J.Penman     001   Created this job

-- 
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $

SET serveroutput on

DECLARE
   v_change_dets_job   NUMBER;
BEGIN
   SYS.DBMS_JOB.submit
      (job            => v_change_dets_job,
       what           => 'pk_change_details.pull_web_changes;',
       next_date      => SYSDATE,                                /* default */
       INTERVAL       => 'sysdate + 1/48'
                   /* 1/48 for 30 mins, 1/144 for 10 mins, 1/288 for 5 mins */
                                          ,
       no_parse       => TRUE
      );
   SYS.DBMS_OUTPUT.put_line (TO_CHAR (v_change_dets_job) );
END;
/

COMMIT ;