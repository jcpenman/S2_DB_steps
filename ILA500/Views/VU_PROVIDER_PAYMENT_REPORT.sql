-- VU_PROVIDER_PAYMENT_REPORT.sql
-- Description: dbView holding provider payment data for ILA500 BACS interface
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      05.08.08    R Hunter (SAAS)         Initial Version.
-- 1.1      16.03.09    A.Anchev (external)     Added the possibility to externally 
--                                              filter the results from the viewon BACS_RUN_ID 
--                                              and PROV_PAYMENT_DATE by selectind additional
--                                              information from PROVIDER_PAYMENT table
-- 1.2      27.05.09    A.Bowman (SAAS)         Added Grants to allow this view to be added to the ILA500 Oracle Discoverer Business Area 
-- 1.3      13.10.09    P Hughes (SAAS)         Changed ct.submitted_date to ct.bacs_payment_date for the AS paymentdate
-- 1.4	    16.12.09    P Hughes (SAAS)		Changed fees awarded to look at new payment function 
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Views/VU_PROVIDER_PAYMENT_REPORT.sql $
-- $Author: $
-- $Date: 2010-10-21 10:32:51 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5797 $
CREATE OR REPLACE FORCE VIEW vu_provider_payment_report
AS
   (
/*
The data source for the payment reports data will be a database view V_PROVIDER_PAYMENT_REPORT. This view will encapsulate the logic that produces the data set for the report in a plain format, i.e. one row of the view will correspond to one row in the report without any manipulation.
The database view should be producing data that as per the following select statement:
*/
    SELECT   la.provider_id, la.session_year, l.learner_id AS ilarefnum,
             l.forename, l.surname, l.dob, cl.course_level_desc AS courselevel,
             ct.course_type_desc AS coursetype, la.current_course_year,
             pk_payments.get_app_paymentPaymentReports
                                        (la.learner_application_id)
                                                                   AS feesawarded,
             ct.bacs_payment_date AS paymentdate, st.status AS applstatus,         
             la.session_year AS current_session,         
             pp.bacs_run_id AS bacs_run_id,
             pp.last_updated_on AS prov_payment_date
        FROM learner l,
             learner_application la,
             course_level cl,
             course_type ct,
             application_status st,
             learner_payment lp,         
             provider_payment pp,             
             payment_status ps
       WHERE la.learner_id = l.learner_id
         AND la.course_id = cl.course_id
         AND la.course_type_id = ct.course_type_id
         AND la.application_status_id = st.application_status_id
         AND lp.learner_application_id = la.learner_application_id
         AND pp.provider_payment_id = lp.provider_payment_id
         AND pp.payment_status_id = ps.payment_status_id
         AND ps.payment_desc = 'PAID'
)
/

GRANT DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  VU_PROVIDER_PAYMENT_REPORT TO EDM_USER;
