-- VU_BACS_PAYMENT_DATES.sql
-- Description: dbView tying bacs run ID (in bacs run table) to bacs payment date (in course type table) for ILA500 BACS interface
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      26.08.08    R Hunter (SAAS)         Initial Version.
-- 1.1      17.06.2009  A Anchev                Added batch run date so the BACS file can pickup the correct payments to be included
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Views/VU_BACS_PAYMENT_DATES.sql $
-- $Author: $
-- $Date: 2009-06-17 13:35:39 +0100 (Wed, 17 Jun 2009) $
-- $Revision: 3202 $
DROP VIEW VU_BACS_PAYMENT_DATES
/

/* Formatted on 2008/08/26 17:58 (Formatter Plus v4.8.8) */
--
-- VU_BACS_PAYMENT_DATES  (View) 
--
CREATE OR REPLACE FORCE VIEW vu_bacs_payment_dates (bacs_run_id,
                                                    bacs_payment_date,
                                                    batch_run_date
                                                   )
AS
   (SELECT DISTINCT iv_paymt.bacs_run_id, ctp.bacs_payment_date, ctp.batch_run_date
               FROM course_type ctp,
                    (SELECT c.learner_application_id learner_application_id,
                            a.bacs_run_id bacs_run_id
                       FROM bacs_run a, provider_payment b, learner_payment c
                      WHERE a.bacs_run_id = b.bacs_run_id
                        AND b.provider_payment_id = c.provider_payment_id) iv_paymt
              WHERE EXISTS (
                       SELECT NULL
                         FROM learner_application app
                        WHERE app.learner_application_id =
                                               iv_paymt.learner_application_id
                          AND app.course_type_id = ctp.course_type_id))
/

