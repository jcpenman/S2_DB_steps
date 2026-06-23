CREATE OR REPLACE PACKAGE SGAS.ERROR IS
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) error_s.sql 09/23/96 16:22:57 1.4@(#)
--
-- DESCRIPTION
-- ===========
--
-- Error reporting package.
--
  FUNCTION usererror ( ecode IN NUMBER, str1 IN VARCHAR2, str2 IN VARCHAR2 )
       RETURN VARCHAR2;
END error;
/