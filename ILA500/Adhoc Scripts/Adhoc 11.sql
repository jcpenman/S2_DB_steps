-- Name:Adhoc 11
-- Description: This script has been created to update the PROVIDER table in SIT so that it holds genuine data,
--              this is required to test discoverer reports  
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      25.11.2009    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

Update provider
set prov_type_id = 2
where provider_id in (5,15,22);

Update provider
set prov_type_id = 3
where provider_id = 62;

INSERT INTO PROVIDER ( PROVIDER_ID, PROVIDER_NAME, PROVIDER_HOUSE_NO_OR_NAME, PROVIDER_ADDR_L1,
PROVIDER_ADDR_L2, PROVIDER_ADDR_L3, PROVIDER_ADDR_L4, PROVIDER_POST_CODE, PROVIDER_TEL_NO,
PROVIDER_FAX_NO, BANK_SORT_CODE, BANK_ACCOUNT_NO, MAIN_CONTACT_NAME, MAIN_CONTACT_POSITION,
MAIN_CONTACT_HOUSE_NO_OR_NAME, MAIN_CONTACT_ADDR_L1, MAIN_CONTACT_ADDR_L2, MAIN_CONTACT_ADDR_L3,
MAIN_CONTACT_ADDR_L4, MAIN_CONTACT_POST_CODE, MAIN_CONTACT_TEL_NO, MAIN_CONTACT_FAX_NO,
MAIN_CONTACT_EMAIL, FIN_CONTACT_NAME, FIN_CONTACT_POSITION, FIN_CONTACT_HOUSE_NO_OR_NAME,
FIN_CONTACT_ADDR_L1, FIN_CONTACT_ADDR_L2, FIN_CONTACT_ADDR_L3, FIN_CONTACT_ADDR_L4,
FIN_CONTACT_POST_CODE, FIN_CONTACT_TEL_NO, FIN_CONTACT_FAX_NO, FIN_CONTACT_EMAIL, SUSPEND_PAYMENTS,
SUSPEND_LETTERS, PROV_TYPE_ID, PROV_STATUS_ID, OUTSTANDING_AMOUNT, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
64, 'Royal Botanic Garden Edinburgh', '20A', 'Inverleith Row', NULL, NULL, 'Edinburgh'
, 'EH3 5LR', '01312482841', NULL, '831910', '00146013', 'Mrs Emily Wood', 'Short Course Co-ordinator'
, '20A', 'Inverleith Row', NULL, NULL, 'Edinburgh', 'EH3 5LR', '01312482841', NULL
, 'e.wood@rbge.org.uk', 'Mr Todd Law', NULL, '20A', 'Inverleith Row', NULL, NULL, 'Edinburgh'
, 'EH3 5LR', '01312482834', NULL, 't.law@rgbe.org.uk', 'N', 'N', 3, 1, 0, 'U200603'
,  TO_Date( '10/20/2009 11:37:34 AM', 'MM/DD/YYYY HH:MI:SS AM')); 

commit;