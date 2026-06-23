delete from sgas.std_letters;
/
insert into sgas.std_letters (doc_name, doc_desc) values ('DUMMY1', 'A dummy shell letter');
/
update sgas.config_data
set cval = 'P:\DUMMY_Shell_Letters_STEPS'
where item_name = 'SHELL_PATH'
/
update sgas.config_data
set cval = '/export/home/test_share/edm_documents/'
where item_name = 'SHELL_SERVER_TARGET_DIR'
/
update sgas.config_data
set cval = 'P:\edm_documents\'
where item_name = 'SHELL_CLIENT_TARGET_DIR'
/
update sgas.config_data
set cval = 'P:/edm_documents/'
where item_name = 'EDM_REMOTE_DIR'
/
update sgas.config_data
set cval = '/export/home/test_share/edm_documents/'
where item_name = 'EDM_LOCAL_DIR'
/
update sgas.config_data
set cval = 'P:/edm_documents/'
where item_name = 'EDM_SHARED_DRIVE_PATH'
/
COMMIT;
