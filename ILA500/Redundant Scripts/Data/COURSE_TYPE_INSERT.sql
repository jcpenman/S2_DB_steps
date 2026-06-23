/* Formatted on 2009/02/09 17:15 (Formatter Plus v4.8.8) */
-- Reference data
-- Table: COURSE_TYPE 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      26.06.08    A.Bowman (SAAS)         Initial Version.    
-- 2.0      30.06.08    R.Hunter (SAAS)         Added 4 new columns FEE_CUT_OFF_DATE, FEE_PERIOD_START, FEE_PERIOD_END, SUBMITTED_DATE
-- 3.0      09.10.08    A.Bowman (SAAS)         Amended bacs_payment_date for October Payment
-- 4.0      09.02.09    A.Bowman (SAAS)         Added new data for session 2009/2010
-- 5.0      21.04.09    A.Bowman (SAAS)         Updated to reflect live dates provided by Ruth Ralph
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Data/COURSE_TYPE_INSERT.sql $
-- $Author: $
-- $Date: 2009-04-21 14:56:53 +0100 (Tue, 21 Apr 2009) $
-- $Revision: 2843 $ 

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('01/20/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'JANUARY PAYMENT',
             TO_DATE ('12/01/2008 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('08/01/2008 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('12/31/2008 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/06/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/02/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('04/07/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'APRIL PAYMENT',
             TO_DATE ('03/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/31/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/24/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/20/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('07/07/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'JULY PAYMENT',
             TO_DATE ('06/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('04/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/30/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/23/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/19/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('10/07/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'OCTOBER PAYMENT',
             TO_DATE ('07/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('07/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('07/31/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('09/23/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('09/19/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('01/20/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'JANUARY PAYMENT',
             TO_DATE ('12/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('08/01/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('12/31/2009 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/06/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/02/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('04/06/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'APRIL PAYMENT',
             TO_DATE ('03/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('01/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/31/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/23/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('03/19/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

INSERT INTO course_type
            (bacs_payment_date,
             course_type_desc,
             fee_cut_off_date,
             fee_period_start,
             fee_period_end,
             submitted_date,
             batch_run_date,
             last_updated_by,
             last_updated_on
            )
     VALUES (TO_DATE ('07/06/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'JULY PAYMENT',
             TO_DATE ('06/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('04/01/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/30/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/22/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             TO_DATE ('06/18/2010 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'),
             'ILA500',
             TO_DATE ('04/21/2009 11:10:17 AM', 'MM/DD/YYYY HH:MI:SS AM')
            );

COMMIT ;