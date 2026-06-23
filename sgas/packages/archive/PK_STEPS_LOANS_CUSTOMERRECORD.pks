CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_LOANS_CUSTOMERRECORD
AS
   /******************************************************************************
      NAME:       PK_STEPS_LOANS_CUSTOMERRECORD
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        23/09/2013  Paddy Grace      Created this package.
      1.1       07/10/2013   John Wynne       Implemeted CR creation
      1.2       21/11/2013   John Wynne       Completed changes 
   ******************************************************************************/

   /*
   Type that holds the main primary keys of a student. This is used to store the
   primary keys of the student currently being populated in the customer record
   file.
   */
   TYPE t_customer_keys IS RECORD
   (
      stud_ref_no         stud_crse_year.stud_ref_no%TYPE,
      stud_session_id     stud_crse_year.stud_session_id%TYPE,
      stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE
   );

   /*
   Type that holds a record that is to be added to the customer record file
   */
   TYPE t_customer_record IS RECORD
   (
      form_type                  VARCHAR2 (2),
      record_no                  VARCHAR2 (6),
      academic_year              VARCHAR2 (4),
      attendance_status          VARCHAR2 (1),
      deceased                   VARCHAR2 (1),
      status_type                VARCHAR2 (1),
      non_hei_pay_route          VARCHAR2 (1),
      slcssn                     VARCHAR2 (13),
      ucas_no                    VARCHAR2 (9),
      hei_code                   VARCHAR2 (12),
      course_code                VARCHAR2 (6),
      year_of_course             VARCHAR2 (2),
      title                      VARCHAR2 (10),
      surname                    VARCHAR2 (30),
      forenames                  VARCHAR2 (30),
      home_addr_l1               VARCHAR2 (60),
      home_addr_l2               VARCHAR2 (60),
      home_addr_l3               VARCHAR2 (60),
      home_addr_l4               VARCHAR2 (60),
      home_post_code             VARCHAR2 (8),
      gender                     VARCHAR2 (1),
      dob                        VARCHAR2 (8),
      study_end_date             VARCHAR2 (8),
      home_tel_no                VARCHAR2 (14),
      birth_district             VARCHAR2 (25),
      birth_country              VARCHAR2 (25),
      stud_consent               VARCHAR2 (1),
      ben1_consent               VARCHAR2 (1),
      ben2_consent               VARCHAR2 (1),
      repeat_year                VARCHAR2 (1),
      no_of_benefactors          VARCHAR2 (1),
      non_means_tested           VARCHAR2 (1),
      no_of_dependants           VARCHAR2 (1),
      resid_house_income         VARCHAR2 (10),
      ben1_total_income          VARCHAR2 (10),
      ben2_total_income          VARCHAR2 (10),
      total_fee_loan_available   VARCHAR2 (10),
      bursary_entitlement        VARCHAR2 (10),
      stud_sort_code             VARCHAR2 (10),
      stud_acc_number            VARCHAR2 (10),
      nino                       VARCHAR2 (9),
      nino_action                VARCHAR2 (1),
      term_addr_l1               VARCHAR2 (60),
      term_addr_l2               VARCHAR2 (60),
      term_addr_l3               VARCHAR2 (60),
      term_addr_l4               VARCHAR2 (60),
      term_post_code             VARCHAR2 (8),
      email_address              VARCHAR2 (80),
      mobile_phone_number        VARCHAR2 (20),
      correspondence_indicator   VARCHAR2 (1),
      lct1_name                  VARCHAR2 (60),
      lct1_relationship          VARCHAR2 (1),
      lct1_addr_l1               VARCHAR2 (60),
      lct1_addr_l2               VARCHAR2 (60),
      lct1_addr_l3               VARCHAR2 (60),
      lct1_addr_l4               VARCHAR2 (60),
      lct1_post_code             VARCHAR2 (8),
      lct1_phone_number          VARCHAR2 (14),
      lct2_name                  VARCHAR2 (60),
      lct2_addr_l1               VARCHAR2 (60),
      lct2_addr_l2               VARCHAR2 (60),
      lct2_addr_l3               VARCHAR2 (60),
      lct2_addr_l4               VARCHAR2 (60),
      lct2_post_code             VARCHAR2 (8),
      lct2_phone_number          VARCHAR2 (14),
      lcl_ind                    VARCHAR2 (1),
      ruktfl_ind                 VARCHAR2 (1),
      psastfl_ind                VARCHAR2 (1),
      hebss_ind                  VARCHAR2 (1),
      arrears_status_req         VARCHAR2 (1)
   );

   FUNCTION get_cr_file_name
          RETURN VARCHAR2;

   PROCEDURE get_customer_record_detail (p_customer_keys    IN   t_customer_keys,
                                         p_file_record_no   IN   NUMBER, 
                                         p_customer_record  OUT  t_customer_record, 
                                         p_boolean_error    OUT  VARCHAR2,
                                         p_error_text       OUT  VARCHAR2 );                 
                        
   PROCEDURE generate_customer_record_file;

   PROCEDURE delete_corrected_records;

   PROCEDURE update_handover_statuses;

   PROCEDURE update_arrears_requests;

    PROCEDURE validate_customer_record (p_customer_keys     IN     t_customer_keys,
                                        p_customer_record   IN     t_customer_record,
                                        p_cr_record_valid   OUT VARCHAR2,
                                        p_cr_record_error   OUT VARCHAR2 );

   PROCEDURE process_customer_record (p_customer_keys     IN t_customer_keys,
                                      p_customer_record   IN t_customer_record,     
                                      p_file_name         IN VARCHAR2,
                                      p_file_handle       IN UTL_FILE.file_type);

   PROCEDURE insert_cr_error ( p_customer_keys     IN t_customer_keys,
                               p_customer_record   IN t_customer_record,
                               p_file_name         IN VARCHAR2,
                               p_error_description IN VARCHAR2);

   PROCEDURE add_cr_line (p_customer_record   IN     t_customer_record,
                          p_file_handle       IN OUT UTL_FILE.file_type);

   PROCEDURE insert_cr_record (p_customer_keys     IN t_customer_keys,
                               p_customer_record   IN t_customer_record,
                               p_file_name         IN VARCHAR2);

   PROCEDURE update_student_record (p_cr_record_valid   IN VARCHAR2,
                                    p_customer_keys     IN t_customer_keys);

   PROCEDURE start_cr_file (p_file_name     OUT VARCHAR2,
                            p_file_handle   OUT UTL_FILE.file_type);

    PROCEDURE end_cr_file (p_file_name      IN VARCHAR2,
                           p_file_handle    IN UTL_FILE.file_type,
                           p_record_count   IN NUMBER);
    PROCEDURE format_customer_record (p_customer_record IN t_customer_record,
                                      r_customer_record  OUT t_customer_record ); 
    PROCEDURE insert_batch_record (p_file_name         IN VARCHAR2 );
    
    PROCEDURE update_batch_record (p_file_name         IN VARCHAR2,
                                   p_record_count      IN NUMBER  );  
    PROCEDURE make_eligible_s(p_stud_ref_no IN VARCHAR2);

    PROCEDURE make_eligible_ss(p_stud_session_id IN VARCHAR2);

    PROCEDURE make_eligible_scy(p_stud_crse_year_id IN VARCHAR2);
                                                                                               
END PK_STEPS_LOANS_CUSTOMERRECORD;
/