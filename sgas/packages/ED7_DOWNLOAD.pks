CREATE OR REPLACE PACKAGE SGAS.ed7_download IS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) ed7_download_s.sql 04/22/03 10:30:00 1.2@(#)
--
-- DESCRIPTION
-- ===========
--
-- creates c.s.v file holding session specific statistical information
--
--
  PROCEDURE create_csv_file      (param_file_name    IN  VARCHAR2,
                                  param_session_code IN  STUD_SESSION.SESSION_CODE%TYPE,
                                  param_scheme_type  IN  VARCHAR2,
                                  success_fail      OUT VARCHAR2,
                              start_finish      OUT VARCHAR2,
                              error_msg         OUT VARCHAR2,
                                  number_of_records OUT VARCHAR2);

  PROCEDURE benefactor_details   (param_utl_file     IN  Utl_File.File_Type,
                                  param_ben_id       IN  BENEFACTOR.BEN_ID%TYPE,
                                  param_ben_rel_id   IN  STUD_SESSION.BEN1_REL_ID%TYPE,
                                  param_session_code IN  STUD_SESSION.SESSION_CODE%TYPE,
                                  param_scheme_type  IN  VARCHAR2);
--
END ed7_download;
/
