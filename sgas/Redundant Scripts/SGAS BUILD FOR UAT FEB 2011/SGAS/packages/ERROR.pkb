CREATE OR REPLACE PACKAGE BODY SGAS.ERROR IS
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) error_b.sql 09/23/96 16:22:56 1.4@(#)
--
-- DESCRIPTION
-- ===========
--
-- Error reporting package.
--
  FUNCTION USERERROR(    ECode    NUMBER ,
            Str1    VARCHAR2 ,
            Str2    VARCHAR2 ) RETURN VARCHAR2 IS
--
    v_mess    VARCHAR2(200);
--
BEGIN
--
    /* Retrieve the error message text */
    SELECT    err_text
    INTO    v_mess
    FROM    err_mess
    WHERE    err_id = ecode;
    v_mess := 'STEPS'||to_char(ecode)||' - '||v_mess;
    /* Replace the blanks with the supplied text strings */
    if str1 is not null then
        v_mess := REPLACE(v_mess, '#1', str1);
    end if;
    if str2 is not null then
        v_mess := REPLACE(v_mess, '#2', str2);
    end if;
    /* Return the formatted message to the application */
    RETURN v_mess;
--
EXCEPTION
--
    WHEN no_data_found THEN
        v_mess := 'Cannot find error message '||to_char(ecode);
        RETURN v_mess;
--
    WHEN too_many_rows THEN
        v_mess := 'Too many error messages numbered '||to_char(ecode);
        RETURN v_mess;
--
    WHEN others THEN
        v_mess := 'Failed to retrieve error message '||to_char(ecode);
        RETURN v_mess;
--
END usererror;
--
END error; 
/

