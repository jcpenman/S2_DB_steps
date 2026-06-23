CREATE OR REPLACE PACKAGE SGAS.pk_short_appsNMSB AS

type shortappNMSB_cursor IS ref CURSOR;

PROCEDURE shortappNMSB(p_stud_ref_no IN NUMBER,p_session_code IN NUMBER, io_cursor IN OUT shortappNMSB_cursor);

END pk_short_appsNMSB;
/
