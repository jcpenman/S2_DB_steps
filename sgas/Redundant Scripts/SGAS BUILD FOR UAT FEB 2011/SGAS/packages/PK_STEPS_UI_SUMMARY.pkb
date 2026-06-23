/* Formatted on 2010/11/04 14:27 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_ui_summary
AS
/******************************************************************************
   NAME:       pk_steps_ui_SUMMARY
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008  PADDY GRACE      Created this package.
   1.1        28/05/2009  M.TOLMIE         Initial Coding
   1.2        02/10/2009  Paddy Grace       Added problem case field
   1.3        19/11/2009  ABIRAMI CHIDAMBARAM   Split the coding into differnt stored procedures.
******************************************************************************/
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
   )
   IS
   BEGIN
      SELECT st.ni_no, st.scottish_cand, st.title, st.forenames, st.surname,
             st.dob, st.email_addr, st.mobile_tel_no, st.account_no,
             st.sort_code, st.problem_case, sha.tele_no
        INTO ni_no, slc_ref_no, title, forenames, surname,
             dob, email_addr, mobile_tel_no, account_no,
             sort_code, problem_case, tel_no
        FROM stud st, stud_home_addr sha
       WHERE st.stud_ref_no = stud_ref_no_in
         AND sha.stud_ref_no = stud_ref_no_in
         AND sha.end_date IS NULL;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getPersonalInfo : @ '
            || SYSDATE
            || ' '
            || 'SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
   END getpersonalinfo;

   PROCEDURE getteleno (
      stud_ref_no_in   IN       VARCHAR2,
      tel_no           OUT      VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT sha.tele_no
        INTO tel_no
        FROM stud_home_addr sha
       WHERE sha.stud_ref_no = stud_ref_no_in AND sha.end_date IS NULL;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getTeleNo : @ '
            || SYSDATE
            || ' '
            || 'SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
   END getteleno;

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
   )
   IS
   BEGIN
      SELECT (scy.inst_code || ' ' || scy.inst_name),
             (scy.crse_code || ' ' || scy.crse_name
             ), scy.crse_year_no,
             scy.auto_calc_date, scy.sal_sent_date, scy.application_status,
             scy.award
        INTO institution,
             course, course_year,
             last_calc_date, last_letter_date, app_status,
             award_given
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getCourse : @ '
            || SYSDATE
            || ' '
            || 'SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
   END getcourse;

   PROCEDURE getjacase (
      stud_session_id_in   IN       VARCHAR2,
      ja_case              OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT ss.ja_case
        INTO ja_case
        FROM stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getJACase : @ '
            || SYSDATE
            || ' '
            || 'SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
   END getjacase;

   PROCEDURE getsuspendstatuses (
      stud_ref_no_in   IN       VARCHAR2,
      ssuspend         OUT      VARCHAR2,
      ss_cursor        IN OUT   sssuspend_cursor,
      scy_cursor       IN OUT   scysuspend_cursor,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   )
   IS
      cursor_ss    sssuspend_cursor;
      cursor_scy   scysuspend_cursor;
   BEGIN
      SELECT s.stud_suspend
        INTO ssuspend
        FROM stud s
       WHERE s.stud_ref_no = stud_ref_no_in;

      OPEN ss_cursor FOR
         SELECT   ss.session_code AS suspendedsessions
             FROM stud_session ss
            WHERE ss.stud_ref_no = stud_ref_no_in AND ss.session_suspend = 'Y'
         ORDER BY ss.session_code DESC;

      cursor_ss := ss_cursor;

      OPEN scy_cursor FOR
         SELECT      scy.session_code
                  || ' '
                  || scy.inst_code
                  || ' '
                  || scy.crse_code AS suspendedcrseyears
             FROM stud_crse_year scy
            WHERE scy.stud_ref_no = stud_ref_no_in AND scy.crse_suspend = 'Y'
         ORDER BY scy.stud_crse_year_id;

      cursor_scy := scy_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getJACase : @ '
            || SYSDATE
            || ' '
            || 'SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
   END getsuspendstatuses;
END pk_steps_ui_summary;
/