CREATE OR REPLACE PACKAGE SGAS.change_audit IS
    auditing_on VARCHAR2(5) := 'TRUE';
    PROCEDURE set_auditing_on;
    PROCEDURE set_auditing_off;
END change_audit; 
/

