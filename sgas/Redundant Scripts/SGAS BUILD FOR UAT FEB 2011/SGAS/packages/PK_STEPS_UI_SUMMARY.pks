/* Formatted on 2010/11/04 13:55 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_summary
AS
/******************************************************************************
   NAME:       pk_steps_ui_SUMMARY
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008  PADDY GRACE      Created this package.
   1.1        28/05/2009  M.TOLMIE         Initial Coding
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

   PROCEDURE getjacase (
      stud_session_id_in   IN       VARCHAR2,
      ja_case              OUT      VARCHAR2,
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