update config_data
set cval = '/export/home/test_share/edm_documents/' where item_name = 'EDM_LOCAL_DIR';

update config_data
set cval = 'Z:/edm_documents/' where item_name = 'EDM_REMOTE_DIR';

update config_data
set cval = 'Z:\DUMMY_Shell_Letters_STEPS' where item_name = 'SHELL_PATH';

update config_data
set cval = 'Z:\edm_documents' where item_name = 'SHELL_TARGET_DIR';

COMMIT;
