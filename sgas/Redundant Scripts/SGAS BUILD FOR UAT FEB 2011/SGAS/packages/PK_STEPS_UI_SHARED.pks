CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_shared
AS
/******************************************************************************
   NAME:       pk_steps_ui_SHARED
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
******************************************************************************/
   TYPE dd_cursor_award IS REF CURSOR;

   TYPE dd_cursor_dearing IS REF CURSOR;

   TYPE dd_cursor_contactrel IS REF CURSOR;

   TYPE dd_cursor_course IS REF CURSOR;

   TYPE dd_cursor_bankdup IS REF CURSOR;

   TYPE dd_cursor_feeloan IS REF CURSOR;

   TYPE dd_cursor_nonino IS REF CURSOR;

   TYPE dd_cursor_debtstatus IS REF CURSOR;

   TYPE dd_cursor_depempstatus IS REF CURSOR;

   TYPE dd_cursor_benincomestatus IS REF CURSOR;

   TYPE dd_cursor_benincometype IS REF CURSOR;

   TYPE dd_cursor_benreltype IS REF CURSOR;

   TYPE dd_cursor_jatype IS REF CURSOR;

   TYPE dd_cursor_deprel IS REF CURSOR;

   TYPE dd_cursor_deprelchild IS REF CURSOR;

   TYPE dd_cursor_depreladult IS REF CURSOR;

   TYPE dd_cursor_dsaassesscentre IS REF CURSOR;

   TYPE dd_cursor_dsatype IS REF CURSOR;

   TYPE dd_cursor_dsacategory IS REF CURSOR;

   TYPE dd_cursor_disabilitytype IS REF CURSOR;

   TYPE dd_cursor_doctype_cursor IS REF CURSOR;

   TYPE dd_cursor_dsaallowancecat IS REF CURSOR;

   TYPE dd_cursor_dsarejectionreason IS REF CURSOR;

   TYPE dd_cursor_dsareferralreason IS REF CURSOR;

   TYPE dd_cursor_dsastudenttype IS REF CURSOR;

   TYPE dd_cursor_paymentmethod IS REF CURSOR;

   TYPE dd_cursor_dsapaymentstatus IS REF CURSOR;

   TYPE dd_cursor_session IS REF CURSOR;

   TYPE dd_cursor_institution IS REF CURSOR;

   TYPE dd_cursor_loanstatus IS REF CURSOR;

   TYPE dd_cursor_location IS REF CURSOR;

   TYPE dd_cursor_maritalstatus IS REF CURSOR;

   TYPE dd_cursor_nationality IS REF CURSOR;

   TYPE dd_cursor_nmsbcontinuation IS REF CURSOR;

   TYPE dd_cursor_otherloan IS REF CURSOR;

   TYPE dd_cursor_residence IS REF CURSOR;

   TYPE dd_cursor_residencetype IS REF CURSOR;

   TYPE dd_cursor_scheme IS REF CURSOR;

   TYPE dd_cursor_title IS REF CURSOR;

   TYPE dd_cursor_casestatus IS REF CURSOR;

   TYPE dd_cursor_zrefusal IS REF CURSOR;

   TYPE student_sessions_cursor IS REF CURSOR;

   TYPE student_crse_year_cursor IS REF CURSOR;

   PROCEDURE getdd_award (
      io_cursor       IN OUT   dd_cursor_award,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_dearing (
      io_cursor       IN OUT   dd_cursor_dearing,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_contactrel (
      io_cursor       IN OUT   dd_cursor_contactrel,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_course (
      inst_code_in      IN       VARCHAR2,
      scheme_type_in    IN       VARCHAR2,
      session_code_in   IN       VARCHAR2,
      io_cursor         IN OUT   dd_cursor_course,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   );

   PROCEDURE getdd_bankdup (
      io_cursor       IN OUT   dd_cursor_bankdup,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_feeloan (
      io_cursor       IN OUT   dd_cursor_feeloan,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_noninoreason (
      io_cursor       IN OUT   dd_cursor_nonino,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_debtstatus (
      io_cursor       IN OUT   dd_cursor_debtstatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_depempstatus (
      io_cursor       IN OUT   dd_cursor_depempstatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_benincomestatus (
      io_cursor       IN OUT   dd_cursor_benincomestatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_benincometype (
      io_cursor       IN OUT   dd_cursor_benincometype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_benreltype (
      io_cursor       IN OUT   dd_cursor_benreltype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_jatype (
      io_cursor       IN OUT   dd_cursor_jatype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_deprel (
      io_cursor       IN OUT   dd_cursor_deprel,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_deprelchild (
      io_cursor       IN OUT   dd_cursor_deprelchild,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_depreladult (
      io_cursor       IN OUT   dd_cursor_depreladult,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_documenttype (
      io_cursor       IN OUT          dd_cursor_doctype_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getdd_dsaassessmentcentre (
      io_cursor       IN OUT   dd_cursor_dsaassesscentre,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_dsatype (
      io_cursor       IN OUT   dd_cursor_dsatype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_dsacategory (
      io_cursor       IN OUT   dd_cursor_dsacategory,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_disabilitytype (
      io_cursor       IN OUT   dd_cursor_disabilitytype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_dsaallowancecat (
      dsa_category_type_in   IN       VARCHAR2,
      io_cursor              IN OUT   dd_cursor_dsaallowancecat,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE getdd_dsarejectionreason (
      io_cursor       IN OUT   dd_cursor_dsarejectionreason,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_dsareferralreason (
      io_cursor       IN OUT   dd_cursor_dsareferralreason,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_dsastudenttype (
      io_cursor       IN OUT   dd_cursor_dsastudenttype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_dsapaymentstatus (
      io_cursor       IN OUT   dd_cursor_dsapaymentstatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_institution (
      scheme_type_in    IN       VARCHAR2,
      session_code_in   IN       VARCHAR2,
      io_cursor         IN OUT   dd_cursor_institution,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   );

   PROCEDURE getdd_loanstatus (
      io_cursor       IN OUT   dd_cursor_loanstatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_location (
      io_cursor       IN OUT   dd_cursor_location,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_maritalstatus (
      io_cursor       IN OUT   dd_cursor_maritalstatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_nationality (
      io_cursor       IN OUT   dd_cursor_nationality,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_nmsbcontinuation (
      io_cursor       IN OUT   dd_cursor_nmsbcontinuation,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_otherloan (
      io_cursor       IN OUT   dd_cursor_otherloan,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_residence (
      io_cursor       IN OUT   dd_cursor_residence,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_residencetype (
      io_cursor       IN OUT   dd_cursor_residencetype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_scheme (
      io_cursor       IN OUT   dd_cursor_scheme,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_title (
      io_cursor       IN OUT   dd_cursor_title,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_casestatus (
      io_cursor       IN OUT   dd_cursor_casestatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_zrefusal (
      io_cursor       IN OUT   dd_cursor_zrefusal,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdd_paymentmethod (
      io_cursor       IN OUT   dd_cursor_paymentmethod,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getstudentsessions (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          student_sessions_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getlatestsession (
      stud_ref_no_in        IN              VARCHAR2,
      stud_session_id_out   OUT             VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getstudentcrseyears (
      stud_session_id_in   IN              VARCHAR2,
      db_in                IN              VARCHAR2,
      io_cursor            IN OUT          student_crse_year_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getlatestcrseyear (
      stud_session_id_in      IN              VARCHAR2,
      db_in                   IN              VARCHAR2,
      stud_crse_year_id_out   OUT             VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getinstandcrsedets (
      session_code_in       IN              VARCHAR2,
      institution_code_in   IN              VARCHAR2,
      course_code_in        IN              VARCHAR2,
      course_year_no_in     IN              VARCHAR2,
      inst_code_out         OUT NOCOPY      VARCHAR2,
      crse_code_out         OUT NOCOPY      VARCHAR2,
      inst_name_out         OUT NOCOPY      VARCHAR2,
      crse_name_out         OUT NOCOPY      VARCHAR2,
      crse_id_out           OUT NOCOPY      VARCHAR2,
      crse_year_id_out      OUT NOCOPY      VARCHAR2,
      grad_session_out      OUT NOCOPY      VARCHAR2,
      scheme_type_out       OUT NOCOPY      VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_shared;
/
