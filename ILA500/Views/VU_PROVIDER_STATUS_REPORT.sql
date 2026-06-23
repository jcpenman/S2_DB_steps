-- VU_PROVIDER_STATUS_REPORT.sql
-- Description: dbView holding all provider status data for ILA500 BACS interface
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      05.08.08    R Hunter (SAAS)         Initial Version.
-- 2.0      09.06.2009  A Anchev                Changed to pick up applications from current session plus unpaid applications from previous session 
-- 3.0      17.07.2009  P Hughes		Changed SELECTION of paymentdate to return 'bacs_payment_date' instead of 'submitted_date
-- 4.0	    22.07.2009	P Hughes		Added ILA500 schema prefix
-- 5.0	    18.11.2009  P Hughes		Amended view to include 2 outer joins so that applications with RETURNED status's will be --						displayed.  An additional condition was also added so that only records with provider_id's --						are displayed
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Views/VU_PROVIDER_STATUS_REPORT.sql $
-- $Author: $
-- $Date: 2009-11-18 15:07:35 +0000 (Wed, 18 Nov 2009) $
-- $Revision: 4247 $
CREATE OR REPLACE FORCE VIEW ILA500.vu_provider_status_report
AS
   (
/*
The data source for the status reports data will be a database view V_PROVIDER_STATUS_REPORT.
This view will encapsulate the logic that produces the data set for the report in a plain format, i.e. one row of the view will correspond to one row in the report without any manipulation.
The database view should be producing data that as per the following select statement:*/
    SELECT la.learner_application_id,
           la.session_year, l.learner_id AS ilarefnum, l.forename, l.surname,
           l.dob, cl.course_level_desc AS courselevel,
           ct.course_type_desc AS coursetype, la.current_course_year,
           pk_payments.get_app_payment (la.learner_application_id) AS feesawarded,
           ct.bacs_payment_date AS paymentdate,
           pk_payments.get_payment_status (la.learner_application_id) AS feestatus,
           st.status AS applstatus,
           pk_payments.get_updated_status
                            (la.learner_application_id)
                                                       AS updatedsincelastrun,
           la.provider_id AS current_provider,
           la.session_year AS current_session
      FROM ILA500.learner l,
           ILA500.learner_application la,
           ILA500.course_level cl,
           ILA500.course_type ct,
           ILA500.application_status st
     WHERE la.learner_id = l.learner_id
       AND la.course_id = cl.course_id(+)
       AND la.course_type_id = ct.course_type_id(+)
       AND la.provider_id IS NOT NULL
       AND la.application_status_id = st.application_status_id
       AND (la.session_year = pk_payments.get_current_session                             -- Apps from current session
           OR (la.session_year = pk_payments.get_current_session - 1                      -- Or Apps from previous session that
               AND pk_payments.has_pending_payments (la.learner_application_id) = 'true'  -- should have been paid but are still not
               AND la.application_status_id = 2))
   )
/