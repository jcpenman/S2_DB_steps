-- Name:Adhoc 6
-- Description: Insert done as an adhoc to avoid overwriting config_data in BUILD and SIT environments which maybe slightly different from that in DEV. 
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      18.05.2009    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'EDM_ORIGINAL_RETAIN_PERIOD', '30'
, NULL, 'ILA500', Sysdate);

commit;


