INSERT INTO sgas.config_edm
            (document_type_code, document_type_name, TYPE, multipage,
             rescan_allowed, req_original_allowed, file_ext, last_updated_by,
             last_updated_on
            )
     VALUES ('INC_TIFF', 'Incoming Tiff', 'E', 'N',
             'N', 'N', 'TIFF', 'SGAS',
             SYSDATE
            );
INSERT INTO sgas.config_edm
            (document_type_code, document_type_name, TYPE, multipage,
             rescan_allowed, req_original_allowed, file_ext, last_updated_by,
             last_updated_on
            )
     VALUES ('OUT_TIFF', 'Outgoing Tiff', 'E', 'N',
             'N', 'N', 'TIFF', 'SGAS',
             SYSDATE
            );
INSERT INTO sgas.config_edm
            (document_type_code, document_type_name, TYPE, multipage,
             rescan_allowed, req_original_allowed, file_ext, last_updated_by,
             last_updated_on
            )
     VALUES ('INC_PDF', 'Incoming Pdf', 'O', NULL,
             NULL, NULL, 'PDF', 'SGAS',
             SYSDATE
            );
INSERT INTO sgas.config_edm
            (document_type_code, document_type_name, TYPE, multipage,
             rescan_allowed, req_original_allowed, file_ext, last_updated_by,
             last_updated_on
            )
     VALUES ('OUT_PDF', 'Outgoing Pdf', 'O', NULL,
             NULL, NULL, 'PDF', 'SGAS',
             SYSDATE
            ); 
COMMIT;

DROP SNAPSHOT LOG ON BENEFACTOR;

DROP SNAPSHOT LOG ON COMPLETE_WEB_APPLICATIONS;

DROP SNAPSHOT LOG ON STUD;

DROP SNAPSHOT LOG ON STUD_APP_PROG;

DROP SNAPSHOT LOG ON STUD_CONT_DETAILS;

DROP SNAPSHOT LOG ON STUD_CRSE_YEAR;

DROP SNAPSHOT LOG ON STUD_HOME_ADDR;

DROP SNAPSHOT LOG ON STUD_SESSION;

DROP SNAPSHOT LOG ON STUD_TERM_ADDR;

DROP SNAPSHOT LOG ON STUD_TRAV_PROG;

COMMIT;