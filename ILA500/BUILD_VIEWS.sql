-- Build script to control creation of ILA500 views
--
-- MODIFICATION HISTORY 
-- Ref.     Date            Author                          Desc.
-- 001      07/10/2008      S Durkin (Sopra UK)     Initial Version
-- 002      14/10/2008      A.Bowman (SAAS)         Added new views for Audit
-- 003      20/10/2010      A.Bowman (SAAS)         Added new views
--
-- Configuration Management: 
-- $HeadURL:  $ 
-- $Author: $ 
-- $Date:  $ 
-- $Revision:  $ 

PROMPT
PROMPT *** Creating view/VU_BACS_PAYMENT_DATES.sql
@Views/VU_BACS_PAYMENT_DATES.sql
PROMPT ******************************************************************************
PROMPT
PROMPT *** Creating view/VU_PROVIDER_PAYMENT_REPORT.sql
@Views/VU_PROVIDER_PAYMENT_REPORT.sql
PROMPT ******************************************************************************
PROMPT
PROMPT *** Creating view/VU_PROVIDER_STATUS_REPORT.sql
@Views/VU_PROVIDER_STATUS_REPORT.sql
PROMPT ******************************************************************************
PROMPT
PROMPT *** Creating view/VU_SDS.sql
@Views/VU_SDS.sql
PROMPT ******************************************************************************
PROMPT
PROMPT *** Creating view/VU_LEARNER_AUDIT.sql
@Views/VU_LEARNER_AUDIT.sql
PROMPT ******************************************************************************
PROMPT
PROMPT *** Creating view/VU_PROVIDER_AUDIT.sql
@Views/VU_PROVIDER_AUDIT.sql
PROMPT ******************************************************************************
PROMPT
PROMPT *** Creating view/VU_PROVIDER_BALANCES.sql
@views/VU_PROVIDER_BALANCES.sql
PROMPT ******************************************************************************
PROMPT
PROMPT *** Creating view/VU_SDS2009.sql
@views/VU_SDS2009.sql
PROMPT ******************************************************************************
PROMPT
PROMPT *** Creating view/VU_SDS2010.sql
@views/VU_SDS2010.sql
PROMPT ******************************************************************************

PROMPT *** VU_LEARNER_DUPLICATES WILL NEED TO BE CREATED ONCE SGAS HAS BEEN CREATED
--- @Views/VU_LEARNER_DUPLICATES.sql   

PROMPT ******************************************************************************