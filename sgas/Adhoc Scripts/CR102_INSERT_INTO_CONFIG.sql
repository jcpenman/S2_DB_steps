SET DEFINE OFF;

INSERT INTO SGAS.CONFIG_DATA (ITEM_NAME, CVAL)
VALUES ('CASS_UPDATER_FILES_TO_BE_PROCESSED_DIR', '/projects/app/webmethods/share/reports/StEPSPayments/CASS_Updater/awacs_xml/');

INSERT INTO SGAS.CONFIG_DATA (ITEM_NAME, CVAL)
VALUES ('CASS_UPDATER_PROCESSED_FILES_DIR', '/projects/app/webmethods/share/reports/StEPSPayments/CASS_Updater/archive/');

INSERT INTO SGAS.CONFIG_DATA (ITEM_NAME, CVAL)
VALUES ('CASS_UPDATER_LOG_FILES_DIR', '/projects/app/webmethods/share/reports/StEPSPayments/CASS_Updater/logs/');

COMMIT;