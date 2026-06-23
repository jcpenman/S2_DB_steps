/* Formatted on 2011/03/04 13:16 (Formatter Plus v4.8.8) */
/* CONFIG_DATA_DATA.sql
 *
 * Modification history: 
 * 08.11.10	Added	Paddy Grace
 * Configuration Management: 
 * $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/Environmental Data Scripts\SIT\CONFIG_DATA_DATA.sql $ 
 * $Author: $ 
 * $Date: 2010-11-08 17:52:50 +0000 (Wed, 08 Nov 2010) $ 
 * $Revision: 5932 $ 
 */
DELETE FROM config_data
      WHERE item_name = 'EDM_LOCAL_DIR';
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('EDM_LOCAL_DIR', '/export/home/test_share/edm_documents/', NULL
            );
DELETE FROM config_data
      WHERE item_name = 'EDM_REMOTE_DIR';
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('EDM_REMOTE_DIR', 'Z:/edm_documents/', NULL
            );
DELETE FROM config_data
      WHERE item_name = 'SHELL_PATH';
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_PATH', 'Z:/DUMMY_Shell_Letters_STEPS', NULL
            );
DELETE FROM config_data
      WHERE item_name = 'SHELL_FILETYPE';
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_FILETYPE', 'doc', NULL
            );
DELETE FROM config_data
      WHERE item_name = 'SHELL_TARGET_DIR';
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_TARGET_DIR', 'Z:/edm_documents/', NULL
            );

COMMIT;

/* NOT REQUIRED

DELETE FROM config_data
      WHERE item_name = 'AWARD_NOTICE_ROOT_PATH';
INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('AWARD_NOTICE_ROOT_PATH',
             '/projects/app/webmethods/letters/awardnotice', NULL
            );
DELETE FROM config_data
      WHERE item_name = 'AN_LOGO_FULL_PATH';
INSERT INTO config_data
            (item_name, cval,
             nval
            )
     VALUES ('AN_LOGO_FULL_PATH', '/projects/app/webmethods/SAASlogo.png',
             NULL
            );
DELETE FROM config_data
      WHERE item_name = 'AN_UK_BATCH_SERVER_PATH';
INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('AN_UK_BATCH_SERVER_PATH',
             '/projects/app/webmethods/letters/awardnotice/uk', NULL
            );
DELETE FROM config_data
      WHERE item_name = 'AN_NUK_BATCH_SERVER_PATH';
INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('AN_NUK_BATCH_SERVER_PATH',
             '/projects/app/webmethods/letters/awardnotice/nuk', NULL
            );
DELETE FROM config_data
      WHERE item_name = 'AN_UK_BATCH_CLIENT_PATH';
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('AN_UK_BATCH_CLIENT_PATH', 'L:\letters\awardnotice\uk', NULL
            );
DELETE FROM config_data
      WHERE item_name = 'AN_NUK_BATCH_CLIENT_PATH';
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('AN_NUK_BATCH_CLIENT_PATH', 'L:\letters\awardnotice\nuk', NULL
            );
DELETE FROM config_data
      WHERE item_name = 'DSA_REMINDER_LETTERS_PATH';
INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('DSA_REMINDER_LETTERS_PATH',
             '/projects/app/webmethods/letters/DSAReminderLetters', NULL
            );
DELETE FROM config_data
      WHERE item_name = 'STEPS_BACS_SAVE_LOCATION';
INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('STEPS_BACS_SAVE_LOCATION',
             '/projects/app/webmethods/reports/StEPSPayments/BACS_Files', NULL
            );
DELETE FROM config_data
      WHERE item_name = 'ADI_JOURNAL_SAVE_LOCATION';
INSERT INTO config_data
            (item_name,
             cval,
             nval
            )
     VALUES ('ADI_JOURNAL_SAVE_LOCATION',
             '/projects/app/webmethods/reports/StEPSPayments/ADI_Journals',
             NULL
            );


COMMIT ;