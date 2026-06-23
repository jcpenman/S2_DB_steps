/* Formatted on 2009/12/04 11:02 (Formatter Plus v4.8.8) */
/* CONFIG_DATA_DATA.sql
 *
 * Modification history: 
 * 08.11.10	Added	Paddy Grace
 * Configuration Management: 
 * $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/Environmental Data Scripts\Live\CONFIG_DATA_DATA.sql $ 
 * $Author: $ 
 * $Date: 2011-02-01 12:00:00 +0000 ($ 
 * $Revision:  $ 
 */
DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'EISTREAM_DOMAIN_NAME';

INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('EISTREAM_DOMAIN_NAME', 'SAASEDMT', NULL
            );
			
DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'EDM_LOCAL_DIR';

INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('EDM_LOCAL_DIR',
             '/export/home/test_share/edm_documents/', NULL
            );
			
DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'EDM_REMOTE_DIR';

INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('EDM_REMOTE_DIR', 'P:/edm_documents/', NULL
            );
			
DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'SHELL_PATH';

INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_PATH', 'P:/DUMMY_Shell_Letters_STEPS/', NULL
            );
			
DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'SHELL_FILETYPE';

INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_FILETYPE', 'doc', NULL
            );
			
DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'SHELL_TARGET_DIR';

INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_TARGET_DIR', 'P:/edm_documents/', NULL
            );
COMMIT;

