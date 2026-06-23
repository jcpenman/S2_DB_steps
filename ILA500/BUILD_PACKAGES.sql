-- Build script to control creation of ILA500 packages
--
-- MODIFICATION HISTORY 
-- Ref.     Date            Author                          Desc.
--          07/10/2008      S Durkin (Sopra UK)             Initial Version
-- 001      20/10/2010      A.Bowman (SAAS)                 Removed redundant packages   
--
-- Configuration Management: 
-- $HeadURL:  $ 
-- $Author: $ 
-- $Date:  $ 
-- $Revision:  $ 

PROMPT
PROMPT *** Creating package spec/ILA500_RECORDLOCKING.pks
@Packages/ILA500_RECORDLOCKING.pks
PROMPT ******************************************************************************

PROMPT
PROMPT *** Creating package body/ILA500_RECORDLOCKING.pkb
@Packages/ILA500_RECORDLOCKING.pkb
PROMPT ******************************************************************************

PROMPT
PROMPT *** Creating package spec/PK_PAYMENTS.pks
@Packages/PK_PAYMENTS.pks
PROMPT ******************************************************************************

PROMPT
PROMPT *** Creating package body/PK_PAYMENTS.pkb
@Packages/PK_PAYMENTS.pkb
PROMPT ******************************************************************************

PROMPT
PROMPT *** Creating package spec/PK_POP_AUD.pks
@Packages/PK_POP_AUD.pks
PROMPT ******************************************************************************

PROMPT
PROMPT *** Creating package body/PK_POP_AUD.pkb
@Packages/PK_POP_AUD.pkb
PROMPT ******************************************************************************

PROMPT
PROMPT *** Creating package spec/PK_STEPS_PT_UI.pks
@Packages/PK_STEPS_PT_UI.pks
PROMPT ******************************************************************************

PROMPT
PROMPT *** Creating package body/ILA500_RECORDLOCKING.pkb
@Packages/PK_STEPS_PT_UI.pkb
PROMPT ******************************************************************************


