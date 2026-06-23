CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_summary
AS
/******************************************************************************
   NAME:       pk_steps_ui_SUMMARY
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008  PADDY GRACE      Created this package.
   1.1        28/05/2009  M.TOLMIE         Initial Coding
   1.2        08/03/2013  Paddy Grace      Added getstudsessioninfo, removed getjacase
   1.3        01/05/2014  RANJ BENNING     Update for CR263 - added plus_one_used to getpersonalinfo  
******************************************************************************/
   TYPE sssuspend_cursor IS REF CURSOR;

   TYPE scysuspend_cursor IS REF CURSOR;

   PROCEDURE getpersonalinfo (
      stud_ref_no_in   IN       VARCHAR2,
      ni_no            OUT      VARCHAR2,
      slc_ref_no       OUT      VARCHAR2,
      title            OUT      VARCHAR2,
      forenames        OUT      VARCHAR2,
      surname          OUT      VARCHAR2,
      dob              OUT      DATE,
      email_addr       OUT      VARCHAR2,
      mobile_tel_no    OUT      VARCHAR2,
      sort_code        OUT      VARCHAR2,
      account_no       OUT      VARCHAR2,
      problem_case     OUT      VARCHAR2,
      tel_no           OUT      VARCHAR2,
      plus_one_used    OUT      VARCHAR2,      
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   PROCEDURE getteleno (
      stud_ref_no_in   IN       VARCHAR2,
      tel_no           OUT      VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   PROCEDURE getcourse (
      stud_crse_year_id_in   IN       VARCHAR2,
      institution            OUT      VARCHAR2,
      course                 OUT      VARCHAR2,
      course_year            OUT      VARCHAR2,
      last_calc_date         OUT      DATE,
      last_letter_date       OUT      DATE,
      app_status             OUT      VARCHAR2,
      award_given            OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE getstudsessioninfo (
      stud_session_id_in   IN       VARCHAR2,
      ja_case_out          OUT      VARCHAR2,
      eu_flag_out          OUT      VARCHAR2,
      session_code_out     OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   );

   PROCEDURE getsuspendstatuses (
      stud_ref_no_in   IN       VARCHAR2,
      ssuspend         OUT      VARCHAR2,
      ss_cursor        IN OUT   sssuspend_cursor,
      scy_cursor       IN OUT   scysuspend_cursor,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );
END pk_steps_ui_summary;
/