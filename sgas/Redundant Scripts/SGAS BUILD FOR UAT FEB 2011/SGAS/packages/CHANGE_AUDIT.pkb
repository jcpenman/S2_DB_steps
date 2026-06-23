CREATE OR REPLACE PACKAGE BODY SGAS.change_audit IS
    PROCEDURE set_auditing_on IS
    BEGIN
        auditing_on := 'TRUE';
    END set_auditing_on;
    PROCEDURE set_auditing_off IS
    BEGIN
        auditing_on := 'FALSE';
    END set_auditing_off;
END change_audit; 
/

GRANT EXECUTE ON  SGAS.CHANGE_AUDIT TO PUBLIC;

CREATE PUBLIC SYNONYM CHANGE_AUDIT FOR SGAS.CHANGE_AUDIT;
