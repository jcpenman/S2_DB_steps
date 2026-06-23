CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_shared
AS
   /******************************************************************************
      NAME:       pk_steps_ui_shared
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        17/11/2008  PADDY GRACE      Created this package.
      1.1        31/07/2009  PADDY GRACE      getdd_institution changed to accomodate NMSB
      1.2        05/01/2010  PADDY GRACE      getdd_course changed to allow null scheme type
      1.3        05/02/2010  PADDY GRACE      getdd_nmsbcontinuation added
      1.4        16/10/2012  JOHN WYNNE       checkProvisionalIncome added
      1.5        21/11/2012  JOHN WYNNE       getdd_awardType_non_loan added
      1.51       18/12/2012  JOHN WYNNE       updated getdd_awardTyle_non_loan
      1.6        21/11/2012  PADDY GRACE      getdd_studincometype added
      1.81       17/01/2013  JOHN WYNNE       corrected getdd_awardtype_non_loan
      1.90       15/02/2013  JOHN WYNNE       Changed getdd_awardtype_non_loan
      1.9.1      19/02/2013  Paddy Grace      Added getdd_studentstatus
      1.9.2      25/02/2013  Paddy Grace      Added getdd_adhoc_type
      1.9.3      11/03/2013  JOHN WYNNE       Added getdd_paymentreturn_status
      2.0        01/05/2014  JOHN WYNNE       Added new procedure checkstudmatchescrseyear
      2.2        01/10/2020  MIKE TOLMIE      Addition for EU Settled Statuses EU Brexit COS 2021
      2.3        28/01/2021  RANJ BENNING     Addition for EU Residence Types EU Exceptions COS 2021
	  2.6        18/06/2024  RANJ BENNING     Addition for DSA Online - Application Statuses - getdd_dsa_app_statuses
   ******************************************************************************/

   TYPE dd_cursor_paymentreturn_status IS REF CURSOR;

   TYPE dd_cursor_awardtype_non_loan IS REF CURSOR;

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

   TYPE dd_cursor_jacasetype IS REF CURSOR;

   TYPE dd_cursor_jastudtype IS REF CURSOR;

   TYPE dd_cursor_deprel IS REF CURSOR;

   TYPE dd_cursor_deprelchild IS REF CURSOR;

   TYPE dd_cursor_depreladult IS REF CURSOR;

   TYPE dd_cursor_dsaassesscentre IS REF CURSOR;

   TYPE dd_cursor_dsatype IS REF CURSOR;
   
   TYPE dd_cursor_dsa_app_statuses IS REF CURSOR;

   TYPE dd_cursor_dsacategory IS REF CURSOR;

   TYPE dd_cursor_disabilitytype IS REF CURSOR;

   TYPE dd_cursor_doctype_cursor IS REF CURSOR;

   TYPE dd_cursor_dsaallowancecat IS REF CURSOR;

   TYPE dd_cursor_dsarejectionreason IS REF CURSOR;

   TYPE dd_cursor_dsareferralreason IS REF CURSOR;

   TYPE dd_cursor_dsastudenttype IS REF CURSOR;

   TYPE dd_cursor_dsacategoryfortype IS REF CURSOR;

   TYPE dd_cursor_paymentmethod IS REF CURSOR;

   TYPE dd_cursor_paymentstatus IS REF CURSOR;

   TYPE dd_cursor_paymentmethod_l IS REF CURSOR;

   TYPE dd_cursor_paymentroute IS REF CURSOR;

   TYPE dd_cursor_payeetype IS REF CURSOR;

   TYPE dd_cursor_paymentreturntype IS REF CURSOR;

   TYPE dd_cursor_studincometype IS REF CURSOR;

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

   TYPE dd_cursor_rescat IS REF CURSOR;

   TYPE dd_cursor_residencetype IS REF CURSOR;

   TYPE dd_cursor_scheme IS REF CURSOR;

   TYPE dd_cursor_title IS REF CURSOR;

   TYPE dd_cursor_casestatus IS REF CURSOR;

   TYPE dd_cursor_zrefusal IS REF CURSOR;

   TYPE dd_cursor_studentstatus IS REF CURSOR;

   TYPE student_sessions_cursor IS REF CURSOR;

   TYPE student_crse_year_cursor IS REF CURSOR;

   TYPE loandetails_cursor IS REF CURSOR;

   TYPE loanconatctone_cursor IS REF CURSOR;

   TYPE loanconatcttwo_cursor IS REF CURSOR;

   TYPE dd_cursor_paymentreturn IS REF CURSOR;

   TYPE dd_cursor_adhoc_type IS REF CURSOR;

   TYPE dd_cursor_no_benincome IS REF CURSOR;

   TYPE dd_cursor_stud_message_subject IS REF CURSOR;
   
   TYPE dd_cursor_eu_settled_statuses IS REF CURSOR;
   
   TYPE dd_cursor_eu_residence_types IS REF CURSOR;
   
   TYPE dd_cursor_award_end_reason IS REF CURSOR;
    

   PROCEDURE getdd_paymentreturn_status (
      io_cursor       IN OUT dd_cursor_paymentreturn_status,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_awardtype_non_loan (
      io_cursor       IN OUT dd_cursor_awardtype_non_loan,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_award (io_cursor       IN OUT dd_cursor_award,
                          error_boolean      OUT VARCHAR2,
                          ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_dearing (io_cursor       IN OUT dd_cursor_dearing,
                            error_boolean      OUT VARCHAR2,
                            ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_contactrel (io_cursor       IN OUT dd_cursor_contactrel,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_course (inst_code_in      IN     VARCHAR2,
                           scheme_type_in    IN     VARCHAR2,
                           session_code_in   IN     VARCHAR2,
                           io_cursor         IN OUT dd_cursor_course,
                           error_boolean        OUT VARCHAR2,
                           ERROR_TEXT           OUT VARCHAR2);

   PROCEDURE getdd_bankdup (io_cursor       IN OUT dd_cursor_bankdup,
                            error_boolean      OUT VARCHAR2,
                            ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_feeloan (io_cursor       IN OUT dd_cursor_feeloan,
                            error_boolean      OUT VARCHAR2,
                            ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_noninoreason (io_cursor       IN OUT dd_cursor_nonino,
                                 error_boolean      OUT VARCHAR2,
                                 ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_debtstatus (io_cursor       IN OUT dd_cursor_debtstatus,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_depempstatus (io_cursor       IN OUT dd_cursor_depempstatus,
                                 error_boolean      OUT VARCHAR2,
                                 ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_benincomestatus (
      io_cursor       IN OUT dd_cursor_benincomestatus,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_benincometype (io_cursor       IN OUT dd_cursor_benincometype,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_benreltype (io_cursor       IN OUT dd_cursor_benreltype,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_jacasetype (io_cursor       IN OUT dd_cursor_jacasetype,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_jastudtype (io_cursor       IN OUT dd_cursor_jastudtype,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_deprel (io_cursor       IN OUT dd_cursor_deprel,
                           error_boolean      OUT VARCHAR2,
                           ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_deprelchild (io_cursor       IN OUT dd_cursor_deprelchild,
                                error_boolean      OUT VARCHAR2,
                                ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_depreladult (io_cursor       IN OUT dd_cursor_depreladult,
                                error_boolean      OUT VARCHAR2,
                                ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_documenttype (
      io_cursor       IN OUT        dd_cursor_doctype_cursor,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);

   PROCEDURE getdd_dsaassessmentcentre (
      io_cursor       IN OUT dd_cursor_dsaassesscentre,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_dsatype (io_cursor       IN OUT dd_cursor_dsatype,
                            error_boolean      OUT VARCHAR2,
                            ERROR_TEXT         OUT VARCHAR2);
							
   PROCEDURE getdd_dsa_app_statuses (io_cursor       IN OUT dd_cursor_dsa_app_statuses,
									 error_boolean      OUT VARCHAR2,
									 ERROR_TEXT         OUT VARCHAR2);							

   PROCEDURE getdd_dsacategory (io_cursor       IN OUT dd_cursor_dsacategory,
                                error_boolean      OUT VARCHAR2,
                                ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_disabilitytype (
      io_cursor       IN OUT dd_cursor_disabilitytype,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_dsaallowancecat (
      dsa_category_type_in   IN     VARCHAR2,
      io_cursor              IN OUT dd_cursor_dsaallowancecat,
      error_boolean             OUT VARCHAR2,
      ERROR_TEXT                OUT VARCHAR2);

   PROCEDURE getdd_dsarejectionreason (
      io_cursor       IN OUT dd_cursor_dsarejectionreason,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_dsareferralreason (
      io_cursor       IN OUT dd_cursor_dsareferralreason,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_dsastudenttype (
      io_cursor       IN OUT dd_cursor_dsastudenttype,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_dsacategoryfortype (
      io_cursor       IN OUT dd_cursor_dsacategoryfortype,
      type_id_in      IN     VARCHAR2,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_dsapaymentstatus (
      io_cursor       IN OUT dd_cursor_dsapaymentstatus,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_institution (
      scheme_type_in    IN     VARCHAR2,
      session_code_in   IN     VARCHAR2,
      io_cursor         IN OUT dd_cursor_institution,
      error_boolean        OUT VARCHAR2,
      ERROR_TEXT           OUT VARCHAR2);

   PROCEDURE getdd_loanstatus (io_cursor       IN OUT dd_cursor_loanstatus,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_location (io_cursor       IN OUT dd_cursor_location,
                             error_boolean      OUT VARCHAR2,
                             ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_maritalstatus (io_cursor       IN OUT dd_cursor_maritalstatus,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_nationality (io_cursor       IN OUT dd_cursor_nationality,
                                error_boolean      OUT VARCHAR2,
                                ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_nmsbcontinuation (
      io_cursor       IN OUT dd_cursor_nmsbcontinuation,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_otherloan (io_cursor       IN OUT dd_cursor_otherloan,
                              error_boolean      OUT VARCHAR2,
                              ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_residence (io_cursor       IN OUT dd_cursor_residence,
                              error_boolean      OUT VARCHAR2,
                              ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_residencecategory (
      io_cursor       IN OUT        dd_cursor_rescat,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);
      
  PROCEDURE getdd_residencecategory_all (
      io_cursor       IN OUT        dd_cursor_rescat,
      p_residence_category_id IN VARCHAR2, 
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);    

   PROCEDURE getdd_residencetype (io_cursor       IN OUT dd_cursor_residencetype,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_scheme (io_cursor       IN OUT dd_cursor_scheme,
                           error_boolean      OUT VARCHAR2,
                           ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_title (io_cursor       IN OUT dd_cursor_title,
                          error_boolean      OUT VARCHAR2,
                          ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_casestatus (io_cursor       IN OUT dd_cursor_casestatus,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_zrefusal (io_cursor       IN OUT dd_cursor_zrefusal,
                             error_boolean      OUT VARCHAR2,
                             ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_studentstatus (io_cursor       IN OUT dd_cursor_studentstatus,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_paymentmethod (io_cursor       IN OUT dd_cursor_paymentmethod,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_paymentstatus (io_cursor       IN OUT dd_cursor_paymentstatus,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_paymentmethod_legacy (
      io_cursor       IN OUT dd_cursor_paymentmethod_l,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_paymentreturn_method (
      io_cursor       IN OUT dd_cursor_paymentreturn,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_paymentroute (io_cursor       IN OUT dd_cursor_paymentroute,
                                 error_boolean      OUT VARCHAR2,
                                 ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_payeetype (io_cursor       IN OUT dd_cursor_payeetype,
                              error_boolean      OUT VARCHAR2,
                              ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_paymentreturntype (
      io_cursor       IN OUT dd_cursor_paymentreturntype,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_studincometype (
      io_cursor       IN OUT dd_cursor_studincometype,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);
      
    PROCEDURE getdd_award_end_reason (
      io_cursor       IN OUT dd_cursor_award_end_reason,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getdd_adhoc_type (io_cursor       IN OUT dd_cursor_adhoc_type,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2);

   PROCEDURE getstudentsessions (
      stud_ref_no_in   IN            VARCHAR2,
      io_cursor        IN OUT        student_sessions_cursor,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2);

   PROCEDURE getlatestsession (stud_ref_no_in        IN            VARCHAR2,
                               stud_session_id_out      OUT        VARCHAR2,
                               error_boolean            OUT NOCOPY VARCHAR2,
                               ERROR_TEXT               OUT NOCOPY VARCHAR2);

   PROCEDURE getstudentcrseyears (
      stud_session_id_in   IN            VARCHAR2,
      db_in                IN            VARCHAR2,
      io_cursor            IN OUT        student_crse_year_cursor,
      error_boolean           OUT NOCOPY VARCHAR2,
      ERROR_TEXT              OUT NOCOPY VARCHAR2);

   PROCEDURE getlatestcrseyear (
      stud_session_id_in      IN            VARCHAR2,
      db_in                   IN            VARCHAR2,
      stud_crse_year_id_out      OUT        VARCHAR2,
      error_boolean              OUT NOCOPY VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY VARCHAR2);

   PROCEDURE getinstandcrsedets (
      session_code_in       IN            VARCHAR2,
      institution_code_in   IN            VARCHAR2,
      course_code_in        IN            VARCHAR2,
      course_year_no_in     IN            VARCHAR2,
      inst_code_out            OUT NOCOPY VARCHAR2,
      crse_code_out            OUT NOCOPY VARCHAR2,
      inst_name_out            OUT NOCOPY VARCHAR2,
      crse_name_out            OUT NOCOPY VARCHAR2,
      crse_id_out              OUT NOCOPY VARCHAR2,
      crse_year_id_out         OUT NOCOPY VARCHAR2,
      grad_session_out         OUT NOCOPY VARCHAR2,
      scheme_type_out          OUT NOCOPY VARCHAR2,
      error_boolean            OUT NOCOPY VARCHAR2,
      ERROR_TEXT               OUT NOCOPY VARCHAR2);

   PROCEDURE getloancontactone (
      stud_ref_no_in   IN            VARCHAR2,
      io_cursor        IN OUT        loanconatctone_cursor,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2);

   PROCEDURE getloancontacttwo (
      stud_ref_no_in   IN            VARCHAR2,
      io_cursor        IN OUT        loanconatcttwo_cursor,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2);

   PROCEDURE getloandetails (
      stud_crse_year_id_in   IN            VARCHAR2,
      io_cursor              IN OUT        loandetails_cursor,
      error_boolean             OUT NOCOPY VARCHAR2,
      ERROR_TEXT                OUT NOCOPY VARCHAR2);

   PROCEDURE getstuddetails (stud_ref_no_in          IN            NUMBER,
                             nino_out                   OUT NOCOPY VARCHAR2,
                             title_out                  OUT NOCOPY VARCHAR2,
                             initial_out                OUT NOCOPY VARCHAR2,
                             forename_out               OUT NOCOPY VARCHAR2,
                             surname_out                OUT NOCOPY VARCHAR2,
                             birth_forename_out         OUT NOCOPY VARCHAR2,
                             birth_surname_out          OUT NOCOPY VARCHAR2,
                             date_of_birth_out          OUT NOCOPY DATE,
                             sex_out                    OUT NOCOPY VARCHAR2,
                             marital_status_out         OUT NOCOPY VARCHAR2,
                             marriage_date_out          OUT NOCOPY DATE,
                             birth_country_out          OUT NOCOPY VARCHAR2,
                             residence_country_out      OUT NOCOPY VARCHAR2,
                             nation_country_out         OUT NOCOPY VARCHAR2,
                             birth_district_out         OUT NOCOPY VARCHAR2,
                             addr_corres_flag_out       OUT NOCOPY VARCHAR2,
                             email_addr_out             OUT NOCOPY VARCHAR2,
                             tel_no_out                 OUT NOCOPY VARCHAR2,
                             mobile_tel_no_out          OUT NOCOPY VARCHAR2,
                             abroad_out                 OUT NOCOPY VARCHAR2,
                             sort_code_out              OUT NOCOPY VARCHAR2,
                             account_num_out            OUT NOCOPY VARCHAR2,
                             valid_dup_acc_out          OUT NOCOPY VARCHAR2,
                             dup_bank_reason_out        OUT NOCOPY VARCHAR2,
                             stud_suspend_out           OUT NOCOPY VARCHAR2,
                             res_status_out             OUT NOCOPY VARCHAR2,
                             commence_session_out       OUT NOCOPY VARCHAR2,
                             suspend_payments_out       OUT NOCOPY VARCHAR2,
                             error_boolean              OUT NOCOPY VARCHAR2,
                             ERROR_TEXT                 OUT NOCOPY VARCHAR2);

   PROCEDURE checkprovisionalincome (
      stud_session_id_in   IN            VARCHAR2,
      error_boolean           OUT NOCOPY VARCHAR2,
      ERROR_TEXT              OUT NOCOPY VARCHAR2);

   PROCEDURE checkstudmatchescrseyear (
      stud_crse_year_id_in   IN            VARCHAR2,
      stud_ref_no_in         IN            VARCHAR2,
      stud_correct_out          OUT        VARCHAR2,
      error_boolean             OUT NOCOPY VARCHAR2,
      ERROR_TEXT                OUT NOCOPY VARCHAR2);

   PROCEDURE getdd_reason_no_ben_income (
      io_cursor       OUT dd_cursor_no_benincome,
      error_boolean   OUT VARCHAR2,
      ERROR_TEXT      OUT VARCHAR2);

   PROCEDURE getdd_stud_message_subject (
      io_cursor       OUT dd_cursor_stud_message_subject,
      error_boolean   OUT VARCHAR2,
      ERROR_TEXT      OUT VARCHAR2);
      
   PROCEDURE getdd_eu_settled_statuses (
      io_cursor       OUT dd_cursor_eu_settled_statuses,
      error_boolean   OUT VARCHAR2,
      ERROR_TEXT      OUT VARCHAR2);

   PROCEDURE getdd_eu_residence_types (
      io_cursor       OUT dd_cursor_eu_residence_types,
      error_boolean   OUT VARCHAR2,
      ERROR_TEXT      OUT VARCHAR2);      
      
END pk_steps_ui_shared;
/
