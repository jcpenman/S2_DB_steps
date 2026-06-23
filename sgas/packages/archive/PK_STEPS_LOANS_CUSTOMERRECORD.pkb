CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_LOANS_CUSTOMERRECORD
AS
   /******************************************************************************
      NAME:       PK_STEPS_LOANS_CUSTOMERRECORD
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        23/09/2013  Paddy Grace      Created this package.
      1.1        07/10/2013  John Wynne       Updated
      1.2        21/11/2013   John Wynne      Completed changes      
   ******************************************************************************/

   /*
   Type representing the header line in a customer record file
   */
   TYPE t_header IS RECORD
   (
      record_type       VARCHAR2 (2),
      file_type         VARCHAR2 (6),
      sequence_number   NUMBER (2),
      processing_date   NUMBER (8)
   );

   /*
   Type representing the trailer line in a customer record file
   */
   TYPE t_trailer IS RECORD
   (
      record_type       VARCHAR2 (2),
      file_type         VARCHAR2 (6),
      sequence_number   NUMBER (2),
      processing_date   NUMBER (8),
      record_count      NUMBER (8)
   );

   /*
   Holds meta data for each field in a record. Used for validating a record
   */
   TYPE t_customer_record_fields IS RECORD
   (
      key          VARCHAR2 (30),
      VALUE        VARCHAR2 (60),
      TYPE         VARCHAR2 (20),
      mandatory    VARCHAR2 (1),
      field_size   VARCHAR2 (4)
   );

   /*
   Creates an array of t_customer_record_fields for performing validation
   */
   TYPE t_customer_record_table IS TABLE OF t_customer_record_fields
      INDEX BY BINARY_INTEGER;

   /*
   Type representing benefactor details
   */
   TYPE t_benefactors IS RECORD
   (
      ben1_consent       benefactor_income.ben_hei_bursary_consent%TYPE,
      ben2_consent       benefactor_income.ben_hei_bursary_consent%TYPE,
      no_of_benfactors   NUMBER (1)
   );

   /*
   Type that holds the address fields for a student.
   Can be used for any address home or term.
   */
   TYPE t_customer_addr IS RECORD
   (
      addr1      stud_home_addr.addr_l1%TYPE,
      addr2      stud_home_addr.addr_l2%TYPE,
      addr3      stud_home_addr.addr_l3%TYPE,
      addr4      stud_home_addr.addr_l4%TYPE,
      house_no   stud_home_addr.house_no_name%TYPE,
      postcode   stud_home_addr.post_code%TYPE,
      tel_no     stud_home_addr.tele_no%TYPE
   );
  
   TYPE stud_crse_year_ids IS TABLE OF stud_crse_year.stud_crse_year_id%type INDEX BY PLS_INTEGER;

   /*
   This function is responsible for querying CONFIG_DATA to return the value of
   the maximum number of records that a customer record file can hold
   */
   FUNCTION get_max_cr_file_size
      RETURN NUMBER
   IS
      v_max_cr_file_size   NUMBER;
   BEGIN      

      SELECT nval
        INTO v_max_cr_file_size
        FROM CONFIG_DATA cd
       WHERE cd.ITEM_NAME = 'SLC_MAX_CR_FILE_SIZE';

      RETURN v_max_cr_file_size;
   END get_max_cr_file_size;

   /*
   This function is responsible for querying CONFIG_DATA to return the value of
   the file path that the CR file should be written to
   */
   FUNCTION get_cr_file_path
      RETURN VARCHAR2
   IS
      v_cr_file_path   VARCHAR2 (100);
   BEGIN

      SELECT cval
        INTO v_cr_file_path
        FROM CONFIG_DATA cd
       WHERE cd.ITEM_NAME = 'SLC_CR_FILE_PATH';

      RETURN v_cr_file_path;
   END get_cr_file_path;

   /*
   This function is responsible for building the filename from a prefix, sequence
   number and suffix. The prefix and suffix come from CONFIG _DATA and the sequence
   number from a db sequence
   */
   FUNCTION get_cr_file_name
      RETURN VARCHAR2
   IS
      v_cr_file_prefix        VARCHAR2 (6);
      v_cr_file_sequence_no   VARCHAR2 (7);
      v_cr_file_suffix        VARCHAR2 (4);
      v_cr_file_name          VARCHAR2 (17);
   BEGIN
      SELECT cval
        INTO v_cr_file_prefix
        FROM CONFIG_DATA cd
       WHERE cd.ITEM_NAME = 'SLC_CR_FILE_PREFIX';

      SELECT SGAS.slc_file_seq_num.NEXTVAL
        INTO v_cr_file_sequence_no
        FROM DUAL;

      SELECT cval
        INTO v_cr_file_suffix
        FROM CONFIG_DATA cd
       WHERE cd.ITEM_NAME = 'SLC_CR_FILE_SUFFIX';

      v_cr_file_name :=
            v_cr_file_prefix
         || LPAD (v_cr_file_sequence_no, 7, '0')
         || v_cr_file_suffix;
      RETURN v_cr_file_name;
   END get_cr_file_name;

   /*
   This function is responsible for building the header line for a CR file
   */
   FUNCTION get_cr_header_line
      RETURN VARCHAR2
   IS
      v_record_type       VARCHAR2 (2);
      v_file_type         VARCHAR2 (6);
      v_sequence_number   VARCHAR2 (7);
      v_processing_date   VARCHAR2 (8);
   BEGIN

      v_record_type := 'HH';
      v_file_type := 'SAASCR';    

       SELECT SGAS.slc_file_seq_num.CURRVAL
        INTO v_sequence_number
        FROM DUAL;

      SELECT TO_CHAR (SYSDATE, 'DDMMYYYY') INTO v_processing_date FROM DUAL;

      RETURN    v_record_type
             || v_file_type
             || LPAD (v_sequence_number, 7, '0')
             || v_processing_date;
   END get_cr_header_line;

  /*
   Function gets the slc_file_date from slc_cr_batches table
   */
   FUNCTION get_batch_date ( p_file_name VARCHAR2)
        RETURN DATE                     
   IS
     v_batch_date  date;
   BEGIN
   
          SELECT  slc_file_date
          INTO v_batch_date
          FROM slc_cr_batches scb
          WHERE scb.slc_filename = p_file_name;   
   
          RETURN v_batch_date;
          

   END get_batch_date;  

   /*
   regular_expression_checker
   Checks a value against a regular expresion.
   Returns 1 if valid and 0 if not
   */
   FUNCTION regular_expression_checker (val VARCHAR2, regExp VARCHAR2)
      RETURN NUMBER
   IS
      v_result   NUMBER (1);
   BEGIN
      SELECT COUNT (*)
        INTO v_result
        FROM DUAL
       WHERE REGEXP_LIKE (val, regExp, 'i');

      RETURN v_result;
   END regular_expression_checker;

   /*
   This function is responsible for building the header line for a CR file
   */
   FUNCTION get_cr_trailer_line (p_record_count IN NUMBER)
      RETURN VARCHAR2
   IS
      v_record_type       VARCHAR2 (2);
      v_file_type         VARCHAR2 (6);
      v_sequence_number   VARCHAR2 (7);
      v_processing_date   VARCHAR2 (8);
   BEGIN

      v_record_type := 'TT';
      v_file_type := 'SAASCR';

       SELECT SGAS.slc_file_seq_num.CURRVAL
        INTO v_sequence_number
        FROM DUAL;

      SELECT TO_CHAR (SYSDATE, 'DDMMYYYY') INTO v_processing_date FROM DUAL;

      RETURN    v_record_type
             || v_file_type
             || LPAD (v_sequence_number, 7, '0') 
             || v_processing_date
             || LPAD(p_record_count, 8, '0');
   END get_cr_trailer_line;

   /*
  This function truncates address lines to the correct size for the customer records file
   */
   FUNCTION format_address (full_address t_customer_addr)
      RETURN t_customer_addr
   IS
      v_customer_addr   T_CUSTOMER_ADDR;
      v_tel_no_valid    NUMBER (1);
   BEGIN
      v_customer_addr.addr1 := TRIM (full_address.addr1);
      v_customer_addr.addr2 := TRIM (full_address.addr2);
      v_customer_addr.addr3 := TRIM (full_address.addr3);
      v_customer_addr.addr4 := TRIM (full_address.addr4);
      v_customer_addr.postcode := TRIM (full_address.postcode);
      v_customer_addr.house_no := TRIM (full_address.house_no);
      v_customer_addr.tel_no := REPLACE (REPLACE (full_address.tel_no, ' ', ''), '-', '');

      IF v_customer_addr.addr4 IS NULL OR v_customer_addr.addr4 = '.'
      THEN
         v_customer_addr.addr4 := ' ';
      END IF;

      IF v_customer_addr.addr3 IS NULL OR v_customer_addr.addr3 = '.'
      THEN
         v_customer_addr.addr3 := v_customer_addr.addr3;
         v_customer_addr.addr4 := ' ';
      END IF;

      IF v_customer_addr.addr2 IS NULL OR v_customer_addr.addr2 = '.'
      THEN
         v_customer_addr.addr2 := v_customer_addr.addr3;
         v_customer_addr.addr3 := v_customer_addr.addr4;
         v_customer_addr.addr4 := ' ';
      END IF;

      IF v_customer_addr.addr1 IS NULL OR v_customer_addr.addr1 = '.'
      THEN
         v_customer_addr.addr1 := v_customer_addr.addr2;
         v_customer_addr.addr2 := v_customer_addr.addr3;
         v_customer_addr.addr3 := v_customer_addr.addr4;
         v_customer_addr.addr4 := ' ';
      END IF;

      IF v_customer_addr.house_no = ''
      THEN
         v_customer_addr.addr1 := SUBSTR (v_customer_addr.addr1, 0, 60);
         v_customer_addr.addr2 := SUBSTR (v_customer_addr.addr2, 0, 60);
         v_customer_addr.addr3 := SUBSTR (v_customer_addr.addr3, 0, 60);
         v_customer_addr.addr4 := SUBSTR (v_customer_addr.addr4, 0, 60);
      ELSE
         IF LENGTH (v_customer_addr.house_no || ' ' || v_customer_addr.addr1) > 60 
         THEN
            v_customer_addr.addr1 := v_customer_addr.house_no;
            v_customer_addr.addr2 := SUBSTR (v_customer_addr.addr1, 0, 60);
            v_customer_addr.addr3 := SUBSTR (v_customer_addr.addr2, 0, 60);
            v_customer_addr.addr4 := SUBSTR (v_customer_addr.addr3 || ' ' || v_customer_addr.addr4, 0, 60);
         ELSE
            v_customer_addr.addr1 := v_customer_addr.house_no || ' ' || v_customer_addr.addr1;
            v_customer_addr.addr2 := SUBSTR (v_customer_addr.addr2, 0, 60);
            v_customer_addr.addr3 := SUBSTR (v_customer_addr.addr3, 0, 60);
            v_customer_addr.addr4 := SUBSTR (v_customer_addr.addr4, 0, 60);
         END IF;
      END IF;

      v_tel_no_valid := regular_expression_checker (v_customer_addr.tel_no, '^[0][1-2 | 7][0-9]{9}$');

      IF v_tel_no_valid != 1
      THEN
         v_customer_addr.tel_no := NULL;
      END IF;

      RETURN v_customer_addr;
   END format_address;

   /*
   This function converts a title from a SAAS title to an SLC one
   */
   FUNCTION convert_to_slc_title (title VARCHAR2, gender VARCHAR2)
      RETURN VARCHAR2
   IS
      v_title   VARCHAR2 (10) := NULL;
   BEGIN
      CASE UPPER (title)
         WHEN 'MR'
         THEN
            v_title := 'MR';
         WHEN 'MISTER'
         THEN
            v_title := 'MR';
         WHEN 'MUSTER'
         THEN
            v_title := 'MR';
         WHEN '..MR'
         THEN
            v_title := 'MR';
         WHEN 'MRS'
         THEN
            v_title := 'MRS';
         WHEN '..MRS'
         THEN
            v_title := 'MRS';
         WHEN 'MISSUS'
         THEN
            v_title := 'MRS';
         WHEN 'MISSIS'
         THEN
            v_title := 'MRS';
         WHEN 'MISS'
         THEN
            v_title := 'MISS';
         WHEN 'MS'
         THEN
            v_title := 'MS';
         WHEN 'MSS'
         THEN
            v_title := 'MS';
         WHEN 'DR'
         THEN
            v_title := 'DOCTOR';
         WHEN 'DOC'
         THEN
            v_title := 'DOCTOR';
         WHEN 'REV DR'
         THEN
            v_title := 'DOCTOR';
         WHEN 'DOCTOR'
         THEN
            v_title := 'DOCTOR';
         WHEN 'PROF.'
         THEN
            v_title := 'PROFESSOR';
         WHEN 'PRF.'
         THEN
            v_title := 'PROFESSOR';
         WHEN 'PRF'
         THEN
            v_title := 'PROFESSOR';
         WHEN 'PR'
         THEN
            v_title := 'PROFESSOR';
         WHEN 'PROF'
         THEN
            v_title := 'PROFESSOR';
         WHEN 'PROFESSO'
         THEN
            v_title := 'PROFESSOR';
         ELSE
            IF gender = 'M'
            THEN
               v_title := 'MR';
            ELSE
               v_title := 'MS';
            END IF;
      END CASE;

      RETURN v_title;
   END convert_to_slc_title;


   /*
   This function converts a title from an SLC title to a SAAS one
   */
   FUNCTION convert_to_saas_title (title VARCHAR2)
      RETURN VARCHAR2
   IS
      v_title   VARCHAR2 (8) := NULL;
   BEGIN
      CASE UPPER (title)
         WHEN 'MR'
         THEN
            v_title := 'MR';
         WHEN 'MRS'
         THEN
            v_title := 'MRS';
         WHEN 'MISS'
         THEN
            v_title := 'MISS';
         WHEN 'MS'
         THEN
            v_title := 'MS';
         WHEN 'DOCTOR'
         THEN
            v_title := 'DR';
         WHEN 'PROFESSOR'
         THEN
            v_title := 'PROF.';
         ELSE
            v_title := 'OTHER';
      END CASE;

      RETURN v_title;
   END convert_to_saas_title;

   /*
   This function is responsible for populating an array with the customer record
   details used to validate all fields in the customer record
   */
   FUNCTION populate_validation_array (
      p_customer_record SGAS.PK_STEPS_LOANS_CUSTOMERRECORD.t_customer_record)
      RETURN t_customer_record_table
   IS
      v_cust_rec_tab   t_customer_record_table;
   BEGIN
      v_cust_rec_tab (1).key := 'form_type';
      v_cust_rec_tab (1).VALUE := p_customer_record.form_type;
      v_cust_rec_tab (1).TYPE := 'varchar2';
      v_cust_rec_tab (1).mandatory := 'Y';
      v_cust_rec_tab (1).field_size := '2';
      v_cust_rec_tab (2).key := 'record_no';
      v_cust_rec_tab (2).VALUE := p_customer_record.record_no;
      v_cust_rec_tab (2).TYPE := 'number';
      v_cust_rec_tab (2).mandatory := 'Y';
      v_cust_rec_tab (2).field_size := '6';
      v_cust_rec_tab (3).key := 'academic_year';
      v_cust_rec_tab (3).VALUE := p_customer_record.academic_year;
      v_cust_rec_tab (3).TYPE := 'number';
      v_cust_rec_tab (3).mandatory := 'Y';
      v_cust_rec_tab (3).field_size := '4';
      v_cust_rec_tab (4).key := 'attendance_status';
      v_cust_rec_tab (4).VALUE := p_customer_record.attendance_status;
      v_cust_rec_tab (4).TYPE := 'varchar2';
      v_cust_rec_tab (4).mandatory := 'Y';
      v_cust_rec_tab (4).field_size := '1';
      v_cust_rec_tab (5).key := 'deceased';
      v_cust_rec_tab (5).VALUE := p_customer_record.deceased;
      v_cust_rec_tab (5).TYPE := 'varchar2';
      v_cust_rec_tab (5).mandatory := 'N';
      v_cust_rec_tab (5).field_size := '1';
      v_cust_rec_tab (6).key := 'status_type';
      v_cust_rec_tab (6).VALUE := p_customer_record.status_type;
      v_cust_rec_tab (6).TYPE := 'varchar2';
      v_cust_rec_tab (6).mandatory := 'Y';
      v_cust_rec_tab (6).field_size := '1';
      v_cust_rec_tab (7).key := 'non_hei_pay_route';
      v_cust_rec_tab (7).VALUE := p_customer_record.non_hei_pay_route;
      v_cust_rec_tab (7).TYPE := 'varchar2';
      v_cust_rec_tab (7).mandatory := 'N';
      v_cust_rec_tab (7).field_size := '1';
      v_cust_rec_tab (8).key := 'slcssn';
      v_cust_rec_tab (8).VALUE := p_customer_record.slcssn;
      v_cust_rec_tab (8).TYPE := 'varchar2';
      v_cust_rec_tab (8).mandatory := 'Y';
      v_cust_rec_tab (8).field_size := '13';
      v_cust_rec_tab (9).key := 'ucas_no';
      v_cust_rec_tab (9).VALUE := p_customer_record.ucas_no;
      v_cust_rec_tab (9).TYPE := 'number';
      v_cust_rec_tab (9).mandatory := 'N';
      v_cust_rec_tab (9).field_size := '9';
      v_cust_rec_tab (10).key := 'hei_code';
      v_cust_rec_tab (10).VALUE := p_customer_record.hei_code;
      v_cust_rec_tab (10).TYPE := 'varchar2';
      v_cust_rec_tab (10).mandatory := 'Y';
      v_cust_rec_tab (10).field_size := '12';
      v_cust_rec_tab (11).key := 'course_code';
      v_cust_rec_tab (11).VALUE := p_customer_record.course_code;
      v_cust_rec_tab (11).TYPE := 'number';
      v_cust_rec_tab (11).mandatory := 'Y';
      v_cust_rec_tab (11).field_size := '6';
      v_cust_rec_tab (12).key := 'year_of_course';
      v_cust_rec_tab (12).VALUE := p_customer_record.year_of_course;
      v_cust_rec_tab (12).TYPE := 'number';
      v_cust_rec_tab (12).mandatory := 'Y';
      v_cust_rec_tab (12).field_size := '2';
      v_cust_rec_tab (13).key := 'title';
      v_cust_rec_tab (13).VALUE := p_customer_record.title;
      v_cust_rec_tab (13).TYPE := 'varchar2';
      v_cust_rec_tab (13).mandatory := 'Y';
      v_cust_rec_tab (13).field_size := '10';
      v_cust_rec_tab (14).key := 'surname';
      v_cust_rec_tab (14).VALUE := p_customer_record.surname;
      v_cust_rec_tab (14).TYPE := 'varchar2';
      v_cust_rec_tab (14).mandatory := 'Y';
      v_cust_rec_tab (14).field_size := '30';
      v_cust_rec_tab (15).key := 'forenames';
      v_cust_rec_tab (15).VALUE := p_customer_record.forenames;
      v_cust_rec_tab (15).TYPE := 'varchar2';
      v_cust_rec_tab (15).mandatory := 'Y';
      v_cust_rec_tab (15).field_size := '30';
      v_cust_rec_tab (16).key := 'home_addr_l1';
      v_cust_rec_tab (16).VALUE := p_customer_record.home_addr_l1;
      v_cust_rec_tab (16).TYPE := 'varchar2';
      v_cust_rec_tab (16).mandatory := 'Y';
      v_cust_rec_tab (16).field_size := '60';
      v_cust_rec_tab (17).key := 'home_addr_l2';
      v_cust_rec_tab (17).VALUE := p_customer_record.home_addr_l2;
      v_cust_rec_tab (17).TYPE := 'varchar2';
      v_cust_rec_tab (17).mandatory := 'Y';
      v_cust_rec_tab (17).field_size := '60';
      v_cust_rec_tab (18).key := 'home_addr_l3';
      v_cust_rec_tab (18).VALUE := p_customer_record.home_addr_l3;
      v_cust_rec_tab (18).TYPE := 'varchar2';
      v_cust_rec_tab (18).mandatory := 'N';
      v_cust_rec_tab (18).field_size := '60';
      v_cust_rec_tab (19).key := 'home_addr_l4';
      v_cust_rec_tab (19).VALUE := p_customer_record.home_addr_l4;
      v_cust_rec_tab (19).TYPE := 'varchar2';
      v_cust_rec_tab (19).mandatory := 'N';
      v_cust_rec_tab (19).field_size := '60';
      v_cust_rec_tab (20).key := 'home_post_code';
      v_cust_rec_tab (20).VALUE := p_customer_record.home_post_code;
      v_cust_rec_tab (20).TYPE := 'varchar2';
      v_cust_rec_tab (20).mandatory := 'N';
      v_cust_rec_tab (20).field_size := '8';
      v_cust_rec_tab (21).key := 'gender';
      v_cust_rec_tab (21).VALUE := p_customer_record.gender;
      v_cust_rec_tab (21).TYPE := 'varchar2';
      v_cust_rec_tab (21).mandatory := 'Y';
      v_cust_rec_tab (21).field_size := '1';
      v_cust_rec_tab (22).key := 'dob';
      v_cust_rec_tab (22).VALUE := p_customer_record.dob;
      v_cust_rec_tab (22).TYPE := 'date';
      v_cust_rec_tab (22).mandatory := 'Y';
      v_cust_rec_tab (22).field_size := '8';
      v_cust_rec_tab (23).key := 'study_end_date';
      v_cust_rec_tab (23).VALUE := p_customer_record.study_end_date;
      v_cust_rec_tab (23).TYPE := 'date';
      v_cust_rec_tab (23).mandatory := 'Y';
      v_cust_rec_tab (23).field_size := '8';
      v_cust_rec_tab (24).key := 'home_tel_no';
      v_cust_rec_tab (24).VALUE := p_customer_record.home_tel_no;
      v_cust_rec_tab (24).TYPE := 'number';
      v_cust_rec_tab (24).mandatory := 'N';
      v_cust_rec_tab (24).field_size := '14';
      v_cust_rec_tab (25).key := 'birth_district';
      v_cust_rec_tab (25).VALUE := p_customer_record.birth_district;
      v_cust_rec_tab (25).TYPE := 'varchar2';
      v_cust_rec_tab (25).mandatory := 'Y';
      v_cust_rec_tab (25).field_size := '25';
      v_cust_rec_tab (26).key := 'birth_country';
      v_cust_rec_tab (26).VALUE := p_customer_record.birth_country;
      v_cust_rec_tab (26).TYPE := 'varchar2';
      v_cust_rec_tab (26).mandatory := 'Y';
      v_cust_rec_tab (26).field_size := '25';
      v_cust_rec_tab (27).key := 'stud_consent';
      v_cust_rec_tab (27).VALUE := p_customer_record.stud_consent;
      v_cust_rec_tab (27).TYPE := 'varchar2';
      v_cust_rec_tab (27).mandatory := 'N';
      v_cust_rec_tab (27).field_size := '1';
      v_cust_rec_tab (28).key := 'ben1_consent';
      v_cust_rec_tab (28).VALUE := p_customer_record.ben1_consent;
      v_cust_rec_tab (28).TYPE := 'varchar2';
      v_cust_rec_tab (28).mandatory := 'N';
      v_cust_rec_tab (28).field_size := '1';
      v_cust_rec_tab (29).key := 'ben2_consent';
      v_cust_rec_tab (29).VALUE := p_customer_record.ben2_consent;
      v_cust_rec_tab (29).TYPE := 'varchar2';
      v_cust_rec_tab (29).mandatory := 'N';
      v_cust_rec_tab (29).field_size := '1';
      v_cust_rec_tab (30).key := 'repeat_year';
      v_cust_rec_tab (30).VALUE := p_customer_record.repeat_year;
      v_cust_rec_tab (30).TYPE := 'varchar2';
      v_cust_rec_tab (30).mandatory := 'N';
      v_cust_rec_tab (30).field_size := '1';
      v_cust_rec_tab (31).key := 'no_of_benefactors';
      v_cust_rec_tab (31).VALUE := p_customer_record.no_of_benefactors;
      v_cust_rec_tab (31).TYPE := 'number';
      v_cust_rec_tab (31).mandatory := 'N';
      v_cust_rec_tab (31).field_size := '1';
      v_cust_rec_tab (32).key := 'non_means_tested';
      v_cust_rec_tab (32).VALUE := p_customer_record.non_means_tested;
      v_cust_rec_tab (32).TYPE := 'varchar2';
      v_cust_rec_tab (32).mandatory := 'N';
      v_cust_rec_tab (32).field_size := '1';
      v_cust_rec_tab (33).key := 'no_of_dependants';
      v_cust_rec_tab (33).VALUE := p_customer_record.no_of_dependants;
      v_cust_rec_tab (33).TYPE := 'number';
      v_cust_rec_tab (33).mandatory := 'N';
      v_cust_rec_tab (33).field_size := '1';
      v_cust_rec_tab (34).key := 'resid_house_income';
      v_cust_rec_tab (34).VALUE := p_customer_record.resid_house_income;
      v_cust_rec_tab (34).TYPE := 'number';
      v_cust_rec_tab (34).mandatory := 'N';
      v_cust_rec_tab (34).field_size := '9,2';
      v_cust_rec_tab (35).key := 'ben1_total_income';
      v_cust_rec_tab (35).VALUE := p_customer_record.ben1_total_income;
      v_cust_rec_tab (35).TYPE := 'number';
      v_cust_rec_tab (35).mandatory := 'N';
      v_cust_rec_tab (35).field_size := '9,2';
      v_cust_rec_tab (36).key := 'ben2_total_income';
      v_cust_rec_tab (36).VALUE := p_customer_record.ben2_total_income;
      v_cust_rec_tab (36).TYPE := 'number';
      v_cust_rec_tab (36).mandatory := 'N';
      v_cust_rec_tab (36).field_size := '9,2';
      v_cust_rec_tab (37).key := 'total_fee_loan_available';
      v_cust_rec_tab (37).VALUE := p_customer_record.total_fee_loan_available;
      v_cust_rec_tab (37).TYPE := 'number';
      v_cust_rec_tab (37).mandatory := 'N';
      v_cust_rec_tab (37).field_size := '9,2';
      v_cust_rec_tab (38).key := 'bursary_entitlement';
      v_cust_rec_tab (38).VALUE := p_customer_record.bursary_entitlement;
      v_cust_rec_tab (38).TYPE := 'number';
      v_cust_rec_tab (38).mandatory := 'N';
      v_cust_rec_tab (38).field_size := '9,2';
      v_cust_rec_tab (39).key := 'total_fee_loan_available';
      v_cust_rec_tab (39).VALUE := p_customer_record.total_fee_loan_available;
      v_cust_rec_tab (39).TYPE := 'number';
      v_cust_rec_tab (39).mandatory := 'N';
      v_cust_rec_tab (39).field_size := '9,2';
      v_cust_rec_tab (40).key := 'bursary_entitlement';
      v_cust_rec_tab (40).VALUE := p_customer_record.bursary_entitlement;
      v_cust_rec_tab (40).TYPE := 'number';
      v_cust_rec_tab (40).mandatory := 'N';
      v_cust_rec_tab (40).field_size := '9,2';
      v_cust_rec_tab (41).key := 'stud_sort_code';
      v_cust_rec_tab (41).VALUE := p_customer_record.stud_sort_code;
      v_cust_rec_tab (41).TYPE := 'number';
      v_cust_rec_tab (41).mandatory := 'N';
      v_cust_rec_tab (41).field_size := '6';
      v_cust_rec_tab (42).key := 'stud_acc_number';
      v_cust_rec_tab (42).VALUE := p_customer_record.stud_acc_number;
      v_cust_rec_tab (42).TYPE := 'number';
      v_cust_rec_tab (42).mandatory := 'N';
      v_cust_rec_tab (42).field_size := '8';
      v_cust_rec_tab (43).key := 'nino';
      v_cust_rec_tab (43).VALUE := p_customer_record.nino;
      v_cust_rec_tab (43).TYPE := 'varchar2';
      v_cust_rec_tab (43).mandatory := 'N';
      v_cust_rec_tab (43).field_size := '9';
      v_cust_rec_tab (44).key := 'nino_action';
      v_cust_rec_tab (44).VALUE := p_customer_record.nino_action;
      v_cust_rec_tab (44).TYPE := 'varchar2';
      v_cust_rec_tab (44).mandatory := 'Y';
      v_cust_rec_tab (44).field_size := '1';
      v_cust_rec_tab (45).key := 'term_addr_l1';
      v_cust_rec_tab (45).VALUE := p_customer_record.term_addr_l1;
      v_cust_rec_tab (45).TYPE := 'varchar2';
      v_cust_rec_tab (45).mandatory := 'Y';
      v_cust_rec_tab (45).field_size := '60';
      v_cust_rec_tab (46).key := 'term_addr_l2';
      v_cust_rec_tab (46).VALUE := p_customer_record.term_addr_l2;
      v_cust_rec_tab (46).TYPE := 'varchar2';
      v_cust_rec_tab (46).mandatory := 'Y';
      v_cust_rec_tab (46).field_size := '60';
      v_cust_rec_tab (47).key := 'term_addr_l3';
      v_cust_rec_tab (47).VALUE := p_customer_record.term_addr_l3;
      v_cust_rec_tab (47).TYPE := 'varchar2';
      v_cust_rec_tab (47).mandatory := 'N';
      v_cust_rec_tab (47).field_size := '60';
      v_cust_rec_tab (48).key := 'term_addr_l4';
      v_cust_rec_tab (48).VALUE := p_customer_record.term_addr_l4;
      v_cust_rec_tab (48).TYPE := 'varchar2';
      v_cust_rec_tab (48).mandatory := 'N';
      v_cust_rec_tab (48).field_size := '60';
      v_cust_rec_tab (49).key := 'term_post_code';
      v_cust_rec_tab (49).VALUE := p_customer_record.term_post_code;
      v_cust_rec_tab (49).TYPE := 'varchar2';
      v_cust_rec_tab (49).mandatory := 'N';
      v_cust_rec_tab (49).field_size := '8';
      v_cust_rec_tab (50).key := 'email_address';
      v_cust_rec_tab (50).VALUE := p_customer_record.email_address;
      v_cust_rec_tab (50).TYPE := 'varchar2';
      v_cust_rec_tab (50).mandatory := 'N';
      v_cust_rec_tab (50).field_size := '80';
      v_cust_rec_tab (51).key := 'mobile_phone_number';
      v_cust_rec_tab (51).VALUE := p_customer_record.mobile_phone_number;
      v_cust_rec_tab (51).TYPE := 'number';
      v_cust_rec_tab (51).mandatory := 'N';
      v_cust_rec_tab (51).field_size := '14';
      v_cust_rec_tab (52).key := 'correspondence_indicator';
      v_cust_rec_tab (52).VALUE := p_customer_record.correspondence_indicator;
      v_cust_rec_tab (52).TYPE := 'varchar2';
      v_cust_rec_tab (52).mandatory := 'Y';
      v_cust_rec_tab (52).field_size := '1';
      v_cust_rec_tab (53).key := 'lct1_name';
      v_cust_rec_tab (53).VALUE := p_customer_record.lct1_name;
      v_cust_rec_tab (53).TYPE := 'varchar2';
      v_cust_rec_tab (53).mandatory := 'N';
      v_cust_rec_tab (53).field_size := '60';
      v_cust_rec_tab (54).key := 'lct1_relationship';
      v_cust_rec_tab (54).VALUE := p_customer_record.lct1_relationship;
      v_cust_rec_tab (54).TYPE := 'varchar2';
      v_cust_rec_tab (54).mandatory := 'N';
      v_cust_rec_tab (54).field_size := '1';
      v_cust_rec_tab (55).key := 'lct1_addr_l1';
      v_cust_rec_tab (55).VALUE := p_customer_record.lct1_addr_l1;
      v_cust_rec_tab (55).TYPE := 'varchar2';
      v_cust_rec_tab (55).mandatory := 'N';
      v_cust_rec_tab (55).field_size := '60';
      v_cust_rec_tab (56).key := 'lct1_addr_l2';
      v_cust_rec_tab (56).VALUE := p_customer_record.lct1_addr_l2;
      v_cust_rec_tab (56).TYPE := 'varchar2';
      v_cust_rec_tab (56).mandatory := 'N';
      v_cust_rec_tab (56).field_size := '60';
      v_cust_rec_tab (57).key := 'lct1_addr_l3';
      v_cust_rec_tab (57).VALUE := p_customer_record.lct1_addr_l3;
      v_cust_rec_tab (57).TYPE := 'varchar2';
      v_cust_rec_tab (57).mandatory := 'N';
      v_cust_rec_tab (57).field_size := '60';
      v_cust_rec_tab (58).key := 'lct1_addr_l4';
      v_cust_rec_tab (58).VALUE := p_customer_record.lct1_addr_l4;
      v_cust_rec_tab (58).TYPE := 'varchar2';
      v_cust_rec_tab (58).mandatory := 'N';
      v_cust_rec_tab (58).field_size := '60';
      v_cust_rec_tab (59).key := 'lct1_post_code';
      v_cust_rec_tab (59).VALUE := p_customer_record.lct1_post_code;
      v_cust_rec_tab (59).TYPE := 'varchar2';
      v_cust_rec_tab (59).mandatory := 'N';
      v_cust_rec_tab (59).field_size := '8';
      v_cust_rec_tab (60).key := 'lct1_phone_number';
      v_cust_rec_tab (60).VALUE := p_customer_record.lct1_phone_number;
      v_cust_rec_tab (60).TYPE := 'number';
      v_cust_rec_tab (60).mandatory := 'N';
      v_cust_rec_tab (60).field_size := '14';
      v_cust_rec_tab (61).key := 'lct2_name';
      v_cust_rec_tab (61).VALUE := p_customer_record.lct2_name;
      v_cust_rec_tab (61).TYPE := 'varchar2';
      v_cust_rec_tab (61).mandatory := 'N';
      v_cust_rec_tab (61).field_size := '60';
      v_cust_rec_tab (62).key := 'lct2_addr_l1';
      v_cust_rec_tab (62).VALUE := p_customer_record.lct2_addr_l1;
      v_cust_rec_tab (62).TYPE := 'varchar2';
      v_cust_rec_tab (62).mandatory := 'N';
      v_cust_rec_tab (62).field_size := '60';
      v_cust_rec_tab (63).key := 'lct2_addr_l2';
      v_cust_rec_tab (63).VALUE := p_customer_record.lct2_addr_l2;
      v_cust_rec_tab (63).TYPE := 'varchar2';
      v_cust_rec_tab (63).mandatory := 'N';
      v_cust_rec_tab (63).field_size := '60';
      v_cust_rec_tab (64).key := 'lct2_addr_l3';
      v_cust_rec_tab (64).VALUE := p_customer_record.lct2_addr_l3;
      v_cust_rec_tab (64).TYPE := 'varchar2';
      v_cust_rec_tab (64).mandatory := 'N';
      v_cust_rec_tab (64).field_size := '60';
      v_cust_rec_tab (65).key := 'lct2_addr_l4';
      v_cust_rec_tab (65).VALUE := p_customer_record.lct2_addr_l4;
      v_cust_rec_tab (65).TYPE := 'varchar2';
      v_cust_rec_tab (65).mandatory := 'N';
      v_cust_rec_tab (65).field_size := '60';
      v_cust_rec_tab (66).key := 'lct2_post_code';
      v_cust_rec_tab (66).VALUE := p_customer_record.lct2_post_code;
      v_cust_rec_tab (66).TYPE := 'varchar2';
      v_cust_rec_tab (66).mandatory := 'N';
      v_cust_rec_tab (66).field_size := '8';
      v_cust_rec_tab (67).key := 'lct2_phone_number';
      v_cust_rec_tab (67).VALUE := p_customer_record.lct2_phone_number;
      v_cust_rec_tab (67).TYPE := 'number';
      v_cust_rec_tab (67).mandatory := 'N';
      v_cust_rec_tab (67).field_size := '14';
      v_cust_rec_tab (68).key := 'lcl_ind';
      v_cust_rec_tab (68).VALUE := p_customer_record.lcl_ind;
      v_cust_rec_tab (68).TYPE := 'varchar2';
      v_cust_rec_tab (68).mandatory := 'Y';
      v_cust_rec_tab (68).field_size := '1';
      v_cust_rec_tab (69).key := 'ruktfl_ind';
      v_cust_rec_tab (69).VALUE := p_customer_record.ruktfl_ind;
      v_cust_rec_tab (69).TYPE := 'varchar2';
      v_cust_rec_tab (69).mandatory := 'Y';
      v_cust_rec_tab (69).field_size := '1';
      v_cust_rec_tab (70).key := 'psastfl_ind';
      v_cust_rec_tab (70).VALUE := p_customer_record.psastfl_ind;
      v_cust_rec_tab (70).TYPE := 'varchar2';
      v_cust_rec_tab (70).mandatory := 'Y';
      v_cust_rec_tab (70).field_size := '1';
      v_cust_rec_tab (71).key := 'hebss_ind';
      v_cust_rec_tab (71).VALUE := p_customer_record.hebss_ind;
      v_cust_rec_tab (71).TYPE := 'varchar2';
      v_cust_rec_tab (71).mandatory := 'Y';
      v_cust_rec_tab (71).field_size := '1';
      v_cust_rec_tab (72).key := 'arrears_status_req';
      v_cust_rec_tab (72).VALUE := p_customer_record.arrears_status_req;
      v_cust_rec_tab (72).TYPE := 'varchar2';
      v_cust_rec_tab (72).mandatory := 'Y';
      v_cust_rec_tab (72).field_size := '1';

      RETURN v_cust_rec_tab;
   END populate_validation_array;


    
   FUNCTION is_hebss_student (p_customer_keys t_customer_keys)
      RETURN VARCHAR2
   IS
      is_hebss    VARCHAR2 (1) := 'N';
      v_dearing   stud_crse_year.dearing%TYPE;
      v_consent   stud_session.stud_hei_bursary_consent%TYPE;
   BEGIN
      BEGIN
         SELECT dearing
           INTO v_dearing
           FROM stud_crse_year
          WHERE stud_crse_year_id = p_customer_keys.stud_crse_year_id;

         SELECT stud_hei_bursary_consent
           INTO v_consent
           FROM stud_session
          WHERE stud_session_id = p_customer_keys.stud_session_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            is_hebss := 'N';
      END;

      IF v_dearing = 'G'
      THEN
         IF v_consent = 'Y'
         THEN
            is_hebss := 'Y';
         END IF;
      END IF;

      RETURN is_hebss;
   END is_hebss_student;

   FUNCTION get_benefactor_details (stud_session_id NUMBER)
      RETURN t_benefactors
   IS
      v_benefactors   t_benefactors;
   BEGIN
   
      v_benefactors.no_of_benfactors := 0; 
      
      BEGIN
         SELECT NVL (bi.ben_hei_bursary_consent, 'N')
           INTO v_benefactors.ben1_consent
           FROM benefactor_income bi, stud_session ss
          WHERE     bi.ben_id = ss.ben1_id
                AND ss.stud_session_id = stud_session_id;

         v_benefactors.no_of_benfactors := 1;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_benefactors.ben1_consent := 'N';
            v_benefactors.ben2_consent := 'N';            
            RETURN v_benefactors;
      END;

      BEGIN
         SELECT NVL (bi.ben_hei_bursary_consent, 'N')
           INTO v_benefactors.ben2_consent
           FROM benefactor_income bi, stud_session ss
          WHERE     bi.ben_id = ss.ben2_id
                AND ss.stud_session_id = stud_session_id;

         v_benefactors.no_of_benfactors := 2;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_benefactors.ben2_consent := 'N';
      END;

      RETURN v_benefactors;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN v_benefactors;
   END get_benefactor_details;
 
   /*
    This procedure is responsible for executing the queries necessary to populate
    a single record in the customer record file
    */
   PROCEDURE get_customer_record_detail ( p_customer_keys    IN   t_customer_keys,
                                          p_file_record_no     IN   NUMBER, 
                                          p_customer_record  OUT  t_customer_record, 
                                          p_boolean_error    OUT  VARCHAR2,
                                          p_error_text       OUT  VARCHAR2 )
   IS
      v_home_addr_record     T_CUSTOMER_ADDR;
      v_term_addr_record     T_CUSTOMER_ADDR;
      v_lct1_addr_record     T_CUSTOMER_ADDR;
      v_lct2_addr_record     T_CUSTOMER_ADDR;
      v_benefactors          T_BENEFACTORS; 

      v_application_status   stud_crse_year.application_status%TYPE;
      v_default_term         crse_year.default_terms%TYPE;
      v_withdraw_date        VARCHAR2 (8);
      v_grad_session         stud_crse_year.grad_session%TYPE;
      v_award                stud_crse_year.award%TYPE;
      v_no_of_dependants     NUMBER (1) := 0;
      v_household_income     stud_crse_year.household_resid_income%TYPE;
      v_ben1_total_income    stud_crse_year.ben1_total_income%TYPE;
      v_ben2_total_income    stud_crse_year.ben2_total_income%TYPE;
      v_scheme_type          stud_crse_year.scheme_type%TYPE;
      v_stud_consent         stud_session.stud_hei_bursary_consent%TYPE := 'N';
      v_arrears_request      slc_customer_record.request_arrears%TYPE;
      v_fee_loan_given       stud_crse_year.fee_loan_given%TYPE;
      v_loan_given           stud_crse_year.loan_given%TYPE;
      v_title                stud.title%TYPE;
      v_deceased             stud.deceased%TYPE;
      v_repeat_year          stud_crse_year.repeat_year%TYPE;
      v_hebss                VARCHAR2 (1) := 'N';
      v_tel_no_valid         stud_home_addr.tele_no%TYPE;
      v_account_no           stud.account_no%TYPE;
      v_sort_code            stud.sort_code%TYPE;
      v_dearing              stud_crse_year.dearing%type;
      v_tfel_award           NUMBER(2) := 0;
      
   BEGIN
   
      p_boolean_error := 'false';
      p_error_text := 'Getting customer record details. ';
      
      p_customer_record.form_type := 'CR';                                 -- Customer Record
      p_customer_record.record_no := TO_NUMBER (p_file_record_no, '999999'); -- Needs to be checked
      
      BEGIN       
         -- Record status should be H for handover or S foe standard
         SELECT NVL ( scr.slc_cr_type, 'S'), NVL (scr.request_arrears, 'N')
           INTO p_customer_record.status_type, v_arrears_request
           FROM slc_customer_record scr, stud_crse_year scy
          WHERE     scy.stud_crse_year_id = p_customer_keys.stud_crse_year_id
                AND scr.stud_crse_year_id = scy.stud_crse_year_id(+);
                
      EXCEPTION
         WHEN OTHERS
         THEN   
            p_boolean_error := 'true';            
            p_error_text :=  p_error_text || 'Failed status type and request arrears. ' ;            
            RETURN; 
      END;

      BEGIN
         -- Get home address
         SELECT NVL (sha.addr_l1, ' '),
                NVL (sha.addr_l2, ' '),
                NVL (sha.addr_l3, ' '),
                NVL (sha.addr_l4, ' '),
                NVL (sha.house_no_name, ' '),
                NVL (sha.post_code, ' '),
                sha.tele_no
           INTO v_home_addr_record.addr1,
                v_home_addr_record.addr2,
                v_home_addr_record.addr3,
                v_home_addr_record.addr4,
                v_home_addr_record.house_no,
                v_home_addr_record.postcode,
                v_home_addr_record.tel_no
           FROM stud_home_addr sha, stud s
          WHERE     s.stud_ref_no = p_customer_keys.stud_ref_no
                AND sha.stud_ref_no = s.stud_ref_no(+)
                AND sha.end_date IS NULL;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_boolean_error := 'true';
            p_error_text := p_error_text || 'Failed to get home address. ';                
            RETURN;
      END;

      v_home_addr_record := format_address (v_home_addr_record);
      p_customer_record.home_addr_l1 := v_home_addr_record.addr1;
      p_customer_record.home_addr_l2 := v_home_addr_record.addr2;
      p_customer_record.home_addr_l3 := v_home_addr_record.addr3;
      p_customer_record.home_addr_l4 := v_home_addr_record.addr4;
      p_customer_record.home_post_code := v_home_addr_record.postcode;
      p_customer_record.home_tel_no := v_home_addr_record.tel_no;

      BEGIN
         -- Get term address
         SELECT NVL (sta.addr_l1, ' '),
                NVL (sta.addr_l2, ' '),
                NVL (sta.addr_l3, ' '),
                NVL (sta.addr_l4, ' '),
                NVL (sta.house_no_name, ' '),
                NVL (sta.post_code, ' '),
                NVL (sta.tele_no, ' ')
           INTO v_term_addr_record.addr1,
                v_term_addr_record.addr2,
                v_term_addr_record.addr3,
                v_term_addr_record.addr4,
                v_term_addr_record.house_no,
                v_term_addr_record.postcode,
                v_term_addr_record.tel_no
           FROM stud_term_addr sta, stud s
          WHERE     s.stud_ref_no = p_customer_keys.stud_ref_no
                AND sta.stud_ref_no = s.stud_ref_no(+)
                AND sta.end_date IS NULL;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_boolean_error := 'true';
            p_error_text := p_error_text || 'Failed to get term address: ';                
            RETURN;
      END;

      v_term_addr_record := format_address (v_term_addr_record);

      p_customer_record.term_addr_l1 := v_term_addr_record.addr1;
      p_customer_record.term_addr_l2 := v_term_addr_record.addr2;
      p_customer_record.term_addr_l3 := v_term_addr_record.addr3;
      p_customer_record.term_addr_l4 := v_term_addr_record.addr4;
      p_customer_record.term_post_code := v_term_addr_record.postcode;

      BEGIN
         -- Get values from stud table
         SELECT NVL (s.title, ' '),
                NVL (s.surname, ' '),
                NVL (s.forenames, ' '),
                NVL (s.sex, ' '),
                TO_CHAR (s.dob, 'ddMMyyyy'),
                S.EMAIL_ADDR,
                NVL (S.DISTRICT_BIRTH_CERT_ISSUED, ' '),
                'SAAS' || S.SCOTTISH_CAND,
                S.UCAS_NO,
                S.SORT_CODE,
                S.ACCOUNT_NO,
                S.MOBILE_TEL_NO,
                S.NI_NO,
                s.deceased
           INTO v_title,
                p_customer_record.surname,
                p_customer_record.forenames,
                p_customer_record.gender,
                p_customer_record.dob,
                p_customer_record.email_address,
                p_customer_record.birth_district,
                p_customer_record.slcssn,
                p_customer_record.ucas_no,
                v_sort_code,
                v_account_no,
                p_customer_record.mobile_phone_number,
                p_customer_record.nino,
                v_deceased
           FROM stud s
          WHERE s.stud_ref_no = p_customer_keys.stud_ref_no;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_boolean_error := 'true';
            p_error_text := p_error_text || 'Failed to get student details: ';                
            RETURN;
      END;

      v_tel_no_valid := regular_expression_checker ( REPLACE ( REPLACE (p_customer_record.mobile_phone_number, ' ', ''), '-', ''),'^[0][1-2 | 7][0-9]{9}$');

      IF v_tel_no_valid != 1
      THEN
         p_customer_record.mobile_phone_number := NULL;
      END IF;

      p_customer_record.deceased :=
         CASE v_deceased
            WHEN ' ' THEN ' '
            WHEN '1' THEN 'N'
            WHEN '2' THEN 'C'
            ELSE ' '
         END;

      p_customer_record.title := convert_to_slc_title (v_title, p_customer_record.gender);

      BEGIN
         -- Get stud_crse_year and stud_session stuff
         SELECT scy.session_code,
                SCY.HEI_PAYMENT_ROUTE,
                scy.crse_year_no,
                NVL (SCY.APPLICATION_STATUS, ' '),
                NVL (I.HEI_INST_CODE, ' '),
                NVL (SCY.CORRES_DEST, 'H'),
                NVL (cy.default_terms, ' '),
                CASE
                   WHEN SCY.WITHDRAW_DATE IS NOT NULL
                   THEN
                      TO_CHAR (SCY.WITHDRAW_DATE, 'ddMMyyyy')
                   ELSE
                      NULL
                END,
                SCY.GRAD_SESSION,
                NVL (ss.stud_hei_bursary_consent, 'N'),
                scy.award,
                scy.household_resid_income,
                scy.ben1_total_income,
                scy.ben2_total_income,
                scy.loan_given,
                scy.fee_loan_given,
                scy.repeat_year,
                scy.dearing
           INTO p_customer_record.academic_year,
                p_customer_record.non_hei_pay_route,
                p_customer_record.year_of_course,
                v_application_status,             -- required for other things
                p_customer_record.hei_code,
                p_customer_record.correspondence_indicator,
                v_default_term,
                v_withdraw_date,
                v_grad_session,
                v_stud_consent,
                v_award,
                v_household_income,
                v_ben1_total_income,
                v_ben2_total_income,
                v_loan_given,
                v_fee_loan_given,
                v_repeat_year,
                v_dearing
           FROM stud_crse_year scy,
                inst i,
                stud_session ss,
                crse_year cy
          WHERE     I.INST_CODE = SCY.INST_CODE
                AND SS.STUD_REF_NO = scy.stud_ref_no
                AND cy.crse_year_id = SCY.CRSE_YEAR_ID
                AND SCY.STUD_CRSE_YEAR_ID = p_customer_keys.stud_crse_year_id;
                
      EXCEPTION
         WHEN OTHERS
         THEN
            p_boolean_error := 'true';
            p_error_text := p_error_text || 'Failed to get student course year records. ';                
            RETURN;
      END;

      BEGIN
         -- TODO: Query should work although may return multiple results
         -- TODO: remove the outer query once data has been confirmed as correct.
         SELECT slc_course_code
           INTO p_customer_record.course_code
           FROM (SELECT hc.slc_course_code
                   FROM crse_year cy,
                        hei_crse hc,
                        inst i,
                        crse c,
                        stud_crse_year scy
                  WHERE     hc.hei_crse_code = c.hei_crse_code
                        AND hc.hei_inst_code = i.hei_inst_code
                        AND i.inst_code = cy.inst_code
                        AND cy.crse_id = c.crse_id
                        AND cy.crse_year_id = scy.crse_year_id(+)
                        AND scy.stud_crse_year_id =
                               p_customer_keys.stud_crse_year_id)
          WHERE ROWNUM < 2;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_boolean_error := 'true';
            p_error_text := p_error_text || 'Failed to get course code. ';                
            RETURN;
      END;

      IF v_loan_given IN ('E', 'F')
      THEN
         p_customer_record.lcl_ind := 'Y';

         BEGIN
            -- Get loan contact one name
            SELECT NVL (scd.cont_name, ' '),
                   NVL (scd.cont_rel_code, ' '),
                   NVL (scd.cont_addr1, ' '),
                   NVL (scd.cont_addr2, ' '),
                   NVL (scd.cont_addr3, ' '),
                   ' ',
                   ' ',
                   NVL (scd.cont_postcode, ' '),
                   NVL (scd.cont_tel_no, ' ')
              INTO p_customer_record.lct1_name,
                   p_customer_record.lct1_relationship,
                   v_lct1_addr_record.addr1,
                   v_lct1_addr_record.addr2,
                   v_lct1_addr_record.addr3,
                   v_lct1_addr_record.addr4,
                   v_lct1_addr_record.house_no,
                   v_lct1_addr_record.postcode,
                   v_lct1_addr_record.tel_no
              FROM stud_cont_details scd
             WHERE     SCD.STUD_REF_NO = p_customer_keys.stud_ref_no
                   AND SCD.CONTACT_IND = '1';
         EXCEPTION
            WHEN OTHERS
            THEN
                p_boolean_error := 'true';
                p_error_text := p_error_text || 'Failed to get loan contact 1 details. ';                
                RETURN;
         END;

         v_lct1_addr_record := format_address (v_lct1_addr_record);

         p_customer_record.lct1_addr_l1 := v_lct1_addr_record.addr1;
         p_customer_record.lct1_addr_l2 := v_lct1_addr_record.addr2;
         p_customer_record.lct1_addr_l3 := v_lct1_addr_record.addr3;
         p_customer_record.lct1_addr_l4 := v_lct1_addr_record.addr4;
         p_customer_record.lct1_post_code := v_lct1_addr_record.postcode;
         p_customer_record.lct1_phone_number := v_lct1_addr_record.tel_no;

         BEGIN
            -- Get loan contact two name
            SELECT NVL (scd.cont_name, ' '),
                   NVL (scd.cont_addr1, ' '),
                   NVL (scd.cont_addr2, ' '),
                   NVL (scd.cont_addr3, ' '),
                   '',
                   '',
                   NVL (scd.cont_postcode, ' '),
                   NVL (scd.cont_tel_no, ' ')
              INTO p_customer_record.lct2_name,
                   v_lct2_addr_record.addr1,
                   v_lct2_addr_record.addr2,
                   v_lct2_addr_record.addr3,
                   v_lct2_addr_record.addr4,
                   v_lct2_addr_record.house_no,
                   v_lct2_addr_record.postcode,
                   v_lct2_addr_record.tel_no
              FROM stud_cont_details scd
             WHERE     SCD.STUD_REF_NO = p_customer_keys.stud_ref_no
                   AND SCD.CONTACT_IND = '2';
         EXCEPTION
            WHEN OTHERS
            THEN
                p_boolean_error := 'true';
                p_error_text := p_error_text || 'Failed to get loan contact 2 details. ';                
                RETURN;
         END;

         v_lct2_addr_record := format_address (v_lct2_addr_record);

         p_customer_record.lct2_addr_l1 := v_lct2_addr_record.addr1;
         p_customer_record.lct2_addr_l2 := v_lct2_addr_record.addr2;
         p_customer_record.lct2_addr_l3 := v_lct2_addr_record.addr3;
         p_customer_record.lct2_addr_l4 := v_lct2_addr_record.addr4;
         p_customer_record.lct2_post_code := v_lct2_addr_record.postcode;
         p_customer_record.lct2_phone_number := v_lct2_addr_record.tel_no;
      ELSE
         p_customer_record.lcl_ind := 'N';
         p_customer_record.lct1_addr_l1 := NULL;
         p_customer_record.lct1_addr_l2 := NULL;
         p_customer_record.lct1_addr_l3 := NULL;
         p_customer_record.lct1_addr_l4 := NULL;
         p_customer_record.lct1_post_code := NULL;
         p_customer_record.lct1_phone_number := NULL;
         p_customer_record.lct2_addr_l1 := NULL;
         p_customer_record.lct2_addr_l2 := NULL;
         p_customer_record.lct2_addr_l3 := NULL;
         p_customer_record.lct2_addr_l4 := NULL;
         p_customer_record.lct2_post_code := NULL;
         p_customer_record.lct2_phone_number := NULL;
      END IF;

      BEGIN
         -- Get birth country name
         SELECT NVL (c.long_name, 'unknown')
           INTO p_customer_record.birth_country
           FROM country c, stud s
          WHERE     C.COUNTRY_CODE = S.BIRTH_COUNTRY_CODE
                AND S.STUD_REF_NO = p_customer_keys.stud_ref_no;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_boolean_error := 'true';
            p_error_text := p_error_text || 'Failed to get birth country. ';                
            RETURN;
      END;

      -- Sets the study end date
      CASE
         WHEN v_application_status IN ('N', 'T', 'C') THEN
            IF p_customer_record.deceased = ' ' THEN
               p_customer_record.attendance_status := 'A';
            ELSE
               p_customer_record.attendance_status := 'D';
            END IF;

            BEGIN
               IF v_default_term = 'Y'
               THEN
                  SELECT end_date || v_grad_session
                    INTO p_customer_record.study_end_date
                    FROM (SELECT TO_CHAR (MAX (IT.END_DATE), 'ddMM')
                                    AS end_date
                            FROM inst_term it, stud_crse_year scy
                           WHERE     IT.INST_CODE = SCY.INST_CODE
                                 AND SCY.STUD_CRSE_YEAR_ID =
                                        p_customer_keys.stud_crse_year_id
                                 AND it.session_code =
                                        p_customer_record.academic_year),
                         stud_crse_year scy
                   WHERE scy.stud_crse_year_id =
                            p_customer_keys.stud_crse_year_id;
               ELSE
                  SELECT end_date || v_grad_session
                    INTO p_customer_record.study_end_date
                    FROM (SELECT TO_CHAR (MAX (CT.END_DATE), 'ddMM')
                                    AS end_date
                            FROM crse_term ct, stud_crse_year scy
                           WHERE     CT.CRSE_YEAR_ID = SCY.CRSE_YEAR_ID
                                 AND SCY.STUD_CRSE_YEAR_ID =
                                        p_customer_keys.stud_crse_year_id),
                         stud_crse_year scy
                   WHERE scy.stud_crse_year_id =
                            p_customer_keys.stud_crse_year_id;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  p_boolean_error := 'true';
                  p_error_text := p_error_text || 'Failed to get study end date.';  
                  RETURN;
            END;
         WHEN v_application_status IN ('A', 'R') THEN
            IF p_customer_record.deceased = ' ' THEN
               p_customer_record.attendance_status := 'N';
            ELSE
               p_customer_record.attendance_status := 'D';
            END IF;

            BEGIN
               IF v_default_term = 'Y' THEN
                  SELECT TO_CHAR (IT.START_DATE, 'ddMMyyyy')
                    INTO p_customer_record.study_end_date
                    FROM inst_term it, stud_crse_year scy
                   WHERE     IT.INST_CODE = SCY.INST_CODE
                         AND SCY.STUD_CRSE_YEAR_ID =
                                p_customer_keys.stud_crse_year_id
                         AND it.session_code =
                                p_customer_record.academic_year
                         AND it.term_no = '1';
               ELSE
                  SELECT TO_CHAR (CT.START_DATE, 'ddMMyyyy')
                    INTO p_customer_record.study_end_date
                    FROM crse_term ct, stud_crse_year scy
                   WHERE     CT.CRSE_YEAR_ID = SCY.CRSE_YEAR_ID
                         AND SCY.STUD_CRSE_YEAR_ID =
                                p_customer_keys.stud_crse_year_id
                         AND ct.term_no = '1';
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                    p_boolean_error := 'true';
                    p_error_text := p_error_text || 'Failed to get study end date. ';                
                    RETURN;
            END;
         WHEN v_application_status = 'W'
         THEN
            IF p_customer_record.deceased = ' ' THEN
               p_customer_record.attendance_status := 'W';
            ELSE
               p_customer_record.attendance_status := 'D';
            END IF;

            IF v_withdraw_date IS NOT NULL THEN
               p_customer_record.study_end_date := v_withdraw_date;
            END IF;
         ELSE
            p_customer_record.study_end_date := NULL;    
      END CASE;

      -- If not HEBSS these values should be null or 'N'
      p_customer_record.stud_consent := 'N';
      p_customer_record.ben1_consent := NULL;
      p_customer_record.ben2_consent := NULL;
      p_customer_record.repeat_year := NULL;
      p_customer_record.no_of_benefactors := NULL;
      p_customer_record.non_means_tested := NULL;
      p_customer_record.resid_house_income := NULL;
      p_customer_record.no_of_dependants := NULL;
      p_customer_record.ben1_total_income := NULL;
      p_customer_record.ben2_total_income := NULL;
      p_customer_record.total_fee_loan_available := NULL;
      p_customer_record.bursary_entitlement := NULL;
      p_customer_record.stud_sort_code := NULL;
      p_customer_record.stud_acc_number := NULL; 
      p_customer_record.nino_action := 'R'; -- TODO: Need more info for nino_action

      /*
     -- TODO: Nino_action. Table still to confirmed and created
     SELECT nsd.nino_action_id
     INTO p_customer_record.nino_action
     FROM nino_status_data nsd
     WHERE nsd.stud_ref_no = p_customer_keys.stud_ref_no;
     */

      -- Get data for identifying if HEBSS
      v_hebss := is_hebss_student (p_customer_keys);

      IF v_hebss = 'Y'
      THEN
         p_customer_record.stud_sort_code := v_sort_code;
         p_customer_record.stud_acc_number := v_account_no;

         -- TODO: Set to H if HEBBS. Need more info for nino_action
         p_customer_record.nino_action := 'H';

         p_customer_record.stud_consent := v_stud_consent;

         v_benefactors :=
            get_benefactor_details (p_customer_keys.stud_session_id);
         p_customer_record.ben1_consent := v_benefactors.ben1_consent;
         p_customer_record.ben2_consent := v_benefactors.ben2_consent;

         IF v_stud_consent = 'Y' THEN
            p_customer_record.repeat_year := v_repeat_year;
            p_customer_record.no_of_benefactors := v_benefactors.no_of_benfactors;

            IF v_award = 'E' THEN
               p_customer_record.non_means_tested := 'N';
            ELSE
               p_customer_record.non_means_tested := 'Y';
            END IF;

            BEGIN
               SELECT a.amount
                 INTO p_customer_record.total_fee_loan_available
                 FROM award a
                WHERE     a.stud_crse_year_id =
                             p_customer_keys.stud_crse_year_id
                      AND a.stud_award_type = 'TFEL';
            EXCEPTION
               WHEN OTHERS
               THEN
                    p_boolean_error := 'true';
                    p_error_text := p_error_text || 'Failed to get award details. ';
                    RETURN;
            END;

            BEGIN 
                SELECT SUM(a.amount)
                INTO p_customer_record.bursary_entitlement
                FROM award a
                WHERE a.stud_crse_year_id =  p_customer_keys.stud_crse_year_id
                AND (a.stud_award_type = 'ISB' OR a.stud_award_type = 'YSB');                     
            EXCEPTION
                WHEN OTHERS
                THEN
                    p_boolean_error := 'true';
                    p_error_text := p_error_text || 'Failed to get bursary entitlement. ';
                    RETURN;
            END;
            
            BEGIN
               -- Set number of dependants
               SELECT COUNT (*)
                 INTO v_no_of_dependants
                 FROM stud_dependant sd
                WHERE SD.STUD_SESSION_ID = p_customer_keys.stud_session_id;
            EXCEPTION
               WHEN OTHERS
               THEN
                    p_boolean_error := 'true';
                    p_error_text := p_error_text || 'Failed to get number of dependants. ';  
                    RETURN;                
            END;

            IF v_no_of_dependants > 9 THEN
               p_customer_record.no_of_dependants := 9;
            ELSE
               p_customer_record.no_of_dependants := v_no_of_dependants;
            END IF;
         END IF;

         IF p_customer_record.ben1_consent = 'Y' THEN
            IF p_customer_record.ben2_consent = 'Y' THEN
               p_customer_record.resid_house_income := v_household_income;
               p_customer_record.ben1_total_income := v_ben1_total_income;
               p_customer_record.ben2_total_income := v_ben2_total_income;
            ELSE
               p_customer_record.resid_house_income := v_household_income;
               p_customer_record.ben1_total_income := v_ben1_total_income;
            END IF;
         END IF;
      END IF;    
       
      p_customer_record.hebss_ind := 'N'; 
      p_customer_record.ruktfl_ind := 'N';
      p_customer_record.psastfl_ind := 'N';
      p_customer_record.lcl_ind := 'N';
      p_customer_record.arrears_status_req := 'N';

      SELECT count(*)
      INTO v_tfel_award
      FROM award a, stud_crse_year scy
      WHERE  a.stud_crse_year_id = scy.stud_crse_year_id
      AND scy.stud_crse_year_id = p_customer_keys.stud_crse_year_id
      AND a.stud_award_type = 'TFEL';

      IF v_dearing = 'G' THEN                     
          IF v_tfel_award > 0 THEN 
            p_customer_record.ruktfl_ind := 'Y';
          END IF;
                       
          p_customer_record.hebss_ind := v_hebss;                          
      END IF; 
      
      IF v_scheme_type = 'P'  THEN
        IF v_tfel_award > 0  THEN 
            p_customer_record.psastfl_ind := 'Y';
        END IF;      
      END IF;  

      IF v_arrears_request IS NOT NULL THEN 
         p_customer_record.arrears_status_req := v_arrears_request;
      END IF;

      IF v_loan_given IN ('E', 'F') THEN
         p_customer_record.lcl_ind := 'Y'; 
      END IF;
     
   EXCEPTION

      WHEN OTHERS THEN
            p_boolean_error := 'true';
            p_error_text := p_error_text || 'Failed. ';       
                          
   END get_customer_record_detail;

   /*
   This procedure is responsible for orchestrating the activities for generating
   a customer record file. The procedure owns the cursor for defining the eligible
   students to be included in the file(s).
   */
   PROCEDURE generate_customer_record_file
   IS
      v_file_name               VARCHAR2 (20);
      v_handle                  UTL_FILE.file_type;      -- report file handle
      v_max_file_size           NUMBER;
      v_current_record_number   NUMBER := 0;
      v_cr_record_valid         VARCHAR2 (1);
      v_cr_record_error         VARCHAR2 (200);
      v_current_customer_keys   t_customer_keys;
      v_customer_record         t_customer_record;
      v_boolean_error           VARCHAR2(10) := 'false';
      v_error_text              VARCHAR2(200) := 'No errors';      

      CURSOR c_customer_keys
      IS
           SELECT scy.stud_crse_year_id, scy.stud_session_id, scy.stud_ref_no
             FROM stud_crse_year scy, slc_customer_record scr
            WHERE     SCR.STUD_CRSE_YEAR_ID = SCY.STUD_CRSE_YEAR_ID
                  AND SCR.SLC_CR_SENT = 'N'
                  AND SCY.LOAN_GIVEN NOT IN ('A', 'B')
                  AND SCY.LATEST_CRSE_IND = 'Y'
                  AND SCY.SESSION_CODE =
                         (SELECT cval
                            FROM config_data
                           WHERE UPPER (item_name) = 'CURRENT_SESSION')
                  AND SCR.SLC_CR_STATUS NOT IN
                         (SELECT ls.loan_status_id
                            FROM loan_status ls
                           WHERE ls.legacy_code = 'E' OR ls.legacy_code = 'S')
           ORDER BY scy.stud_ref_no;
   BEGIN
   
      v_max_file_size := get_max_cr_file_size;
      delete_corrected_records;
      update_handover_statuses;
      update_arrears_requests;
      start_cr_file (v_file_name, v_handle);            

      FOR v_customer_keys IN c_customer_keys
      LOOP
             
         IF v_current_record_number > v_max_file_size THEN          
            end_cr_file (v_file_name, v_handle, v_max_file_size);
            v_current_record_number := 0;
            start_cr_file (v_file_name, v_handle);                 
         END IF;

         v_current_customer_keys.stud_crse_year_id := v_customer_keys.stud_crse_year_id;
         v_current_customer_keys.stud_ref_no := v_customer_keys.stud_ref_no;
         v_current_customer_keys.stud_session_id := v_customer_keys.stud_session_id;         
        
         get_customer_record_detail (v_current_customer_keys,
                                     v_current_record_number, 
                                     v_customer_record, 
                                     v_boolean_error,
                                     v_error_text );                          
       
         IF v_boolean_error = 'false' THEN 
         
             validate_customer_record (v_current_customer_keys,
                                       v_customer_record,
                                       v_cr_record_valid,
                                       v_cr_record_error);                
                               
             IF v_cr_record_valid = 'Y' THEN 

                 v_current_record_number := v_current_record_number + 1; 
                 v_customer_record.record_no := v_current_record_number;
                      
                 process_customer_record (v_current_customer_keys,
                                          v_customer_record, 
                                          v_file_name,
                                          v_handle);                                                                                                                             
             ELSE              
                 insert_cr_error (v_current_customer_keys,
                                  v_customer_record,
                                  v_file_name,
                                  v_cr_record_error);                                                                                                                                                                                                                      
             END IF;                                   

         ELSE          
            insert_cr_error (v_current_customer_keys,
                             v_customer_record,
                             v_file_name,
                             v_error_text);                                                                                               
         END IF;
           
      END LOOP;
     
      end_cr_file (v_file_name, v_handle, v_current_record_number);
      
   EXCEPTION
        
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ( 'Generate customer file - exception '|| SQLCODE || ' SQL ERROR = ' || SQLERRM);     
          
   END generate_customer_record_file;

   /*
   This procedure is responsible for the removal of records from the SLC_CR_ERROR
   table where the corresponding SLC_CUST_RECORD has been corrected. This is to
   avoid a build up of identical errors for the same student
   */
   PROCEDURE delete_corrected_records
   IS
        v_stud_crse_year_ids stud_crse_year_ids;     
   BEGIN    
          -- Bulk update         
          SELECT scr.stud_crse_year_id
          BULK COLLECT INTO v_stud_crse_year_ids
          FROM slc_customer_record scr
          WHERE scr.slc_cr_status = 4;
             
          FORALL indx IN 1.. v_stud_crse_year_ids.COUNT      
               DELETE FROM  slc_cr_errors
               WHERE slc_cr_errors.stud_crse_year_id = v_stud_crse_year_ids(indx);
               
          COMMIT;                                                                                                   
      
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END delete_corrected_records;

   /*
   This procedure is responsible for identifying and updating cases which should
   be sent as handover records in the customer record file
   */
   PROCEDURE update_handover_statuses
   IS
        v_stud_crse_year_ids stud_crse_year_ids;       
   BEGIN

      -- Bulk update        
      SELECT scr.stud_crse_year_id
      BULK COLLECT INTO v_stud_crse_year_ids
      FROM slc_customer_record scr
      WHERE handover_date <= sysdate
      AND slc_cr_sent IS NOT NULL;  
   
      FORALL indx IN 1.. v_stud_crse_year_ids.COUNT      
         UPDATE slc_customer_record
         SET slc_cr_sent = 'N',
             slc_cr_type = 'H'          
         WHERE stud_crse_year_id = v_stud_crse_year_ids(indx); 
        
      COMMIT; 
   
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END update_handover_statuses;

   /*
   This procedure is responsible setting cases to be selected where arrears requests
   have been made by a caseworker
   */
   PROCEDURE update_arrears_requests
   IS
        v_stud_crse_year_ids stud_crse_year_ids;    
   BEGIN
        
        -- Bulk update        
          SELECT scr.stud_crse_year_id
          BULK COLLECT INTO v_stud_crse_year_ids
          FROM slc_customer_record scr
          WHERE request_arrears = 'Y'
          AND arrears_req_sent = 'N'
          AND  arrears_req_date <= sysdate
          AND slc_cr_sent IS NOT NULL;   
             
          FORALL indx IN 1.. v_stud_crse_year_ids.COUNT      
             UPDATE slc_customer_record
             SET slc_cr_sent = 'N'           
             WHERE stud_crse_year_id = v_stud_crse_year_ids(indx);       
        
          COMMIT;                      
   
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('update_arrears_requests - exception');
         ROLLBACK;
   END update_arrears_requests;

   /*
   This procedure is responsible for the validation of customer record data before
   it is included in the customer record file
   */
   PROCEDURE validate_customer_record (
      p_customer_keys     IN     t_customer_keys,
      p_customer_record   IN     t_customer_record,
      p_cr_record_valid   OUT VARCHAR2,
      p_cr_record_error   OUT VARCHAR2 )      
   IS   
      v_i                       NUMBER := 1;
      v_num_fields              NUMBER := 72;
      v_cust_rec_table          t_customer_record_table;
      v_reg_expr                VARCHAR2 (100);
      v_valid_field             NUMBER := 0;
      v_key                     VARCHAR2 (30);
      v_value                   VARCHAR2 (60);
      v_type                    VARCHAR2 (20);
      v_mandatory               VARCHAR2 (1);
      v_field_size              VARCHAR2 (4);
      v_date                    DATE;
      v_todays_date             DATE:= TO_DATE (TO_CHAR (SYSDATE, 'ddMMyyyy'), 'ddMMyyyy');
      v_ten_years_from_now      DATE := ADD_MONTHS (v_todays_date, 12 * 10);
      v_ben_consent             VARCHAR2 (1) := 'N';
      v_ben1_consent            VARCHAR2 (1) := 'N';
      v_ben2_consent            VARCHAR2 (1) := 'N';
      v_stud_consent            VARCHAR2 (1) := 'N';
      v_account                 NUMBER := 0;
      v_hebss                   VARCHAR2 (1) := 'N';
      v_contact_one_mandatory   VARCHAR2 (1) := 'N';
      v_contact_two_mandatory   VARCHAR2 (1) := 'N';
      v_lcl_ind                 VARCHAR2 (1);
   BEGIN  
      v_hebss := is_hebss_student (p_customer_keys); 
      v_cust_rec_table := populate_validation_array (P_CUSTOMER_RECORD);

      WHILE v_i <= v_num_fields
      LOOP
         v_key := v_cust_rec_table (v_i).key;
         v_value := v_cust_rec_table (v_i).VALUE;
         v_type := v_cust_rec_table (v_i).TYPE;
         v_mandatory := v_cust_rec_table (v_i).mandatory;
         v_field_size := v_cust_rec_table (v_i).field_size;
         
         IF v_value IS NULL
         THEN  
            IF v_mandatory = 'Y'
            THEN
               p_cr_record_valid := 'N';
            ELSE
               IF v_contact_one_mandatory = 'Y'
               THEN
                  CASE v_key
                     WHEN 'lct1_relationship'
                     THEN
                        p_cr_record_valid := 'N';
                     WHEN 'lct1_addr_l1'
                     THEN
                        p_cr_record_valid := 'N';
                     WHEN 'lct1_addr_l2'
                     THEN
                        p_cr_record_valid := 'N';
                     ELSE
                        p_cr_record_valid := 'Y';
                  END CASE;
               END IF;

               IF v_contact_two_mandatory = 'Y'
               THEN
                  CASE v_key
                     WHEN 'lct2_relationship'
                     THEN
                        p_cr_record_valid := 'N';
                     WHEN 'lct2_addr_l1'
                     THEN
                        p_cr_record_valid := 'N';
                     WHEN 'lct2_addr_l2'
                     THEN
                        p_cr_record_valid := 'N';
                     ELSE
                        p_cr_record_valid := 'Y';
                  END CASE;
               END IF;

               IF v_hebss = 'Y'
               THEN
                  CASE v_key
                     WHEN 'stud_sort_code'
                     THEN
                        p_cr_record_valid := 'N';
                     WHEN 'stud_acc_number'
                     THEN
                        p_cr_record_valid := 'N';
                     WHEN 'ben1_consent'
                     THEN
                        p_cr_record_valid := 'N';
                     WHEN 'ben2_consent'
                     THEN
                        p_cr_record_valid := 'N';
                     WHEN 'repeat_year'
                     THEN
                        IF v_stud_consent = 'Y'
                        THEN
                           p_cr_record_valid := 'N';
                        END IF;
                     WHEN 'no_of_benefactors'
                     THEN
                        IF v_stud_consent = 'Y'
                        THEN
                           p_cr_record_valid := 'N';
                        END IF;
                     WHEN 'non_means_tested'
                     THEN
                        IF v_stud_consent = 'Y'
                        THEN
                           p_cr_record_valid := 'N';
                        END IF;
                     WHEN 'no_of_dependants'
                     THEN
                        IF v_stud_consent = 'Y'
                        THEN
                           p_cr_record_valid := 'N';
                        END IF;
                     WHEN 'resid_house_income'
                     THEN
                        IF v_ben_consent = 'Y'
                        THEN
                           p_cr_record_valid := 'N';
                        END IF;
                     WHEN 'ben1_total_income'
                     THEN
                        IF v_ben_consent = 'Y'
                        THEN
                           p_cr_record_valid := 'N';
                        END IF;
                     WHEN 'ben2_total_income'
                     THEN
                        IF v_ben2_consent = 'Y'
                        THEN
                           p_cr_record_valid := 'N';
                        END IF;
                     WHEN 'total_fee_loan_available'
                     THEN
                        IF v_stud_consent = 'Y'
                        THEN
                           p_cr_record_valid := 'N';
                        END IF;
                     WHEN 'bursary_entitlement'
                     THEN
                        IF v_stud_consent = 'Y'
                        THEN
                           p_cr_record_valid := 'N';
                        END IF;
                     ELSE
                        p_cr_record_valid := 'Y';
                  END CASE;
               END IF;
            END IF;

            IF p_cr_record_valid = 'N'
            THEN
               p_cr_record_error := ' Mandatory field missing at ' || v_key;
               EXIT;
            END IF;
         ELSE

            BEGIN
               CASE v_type
                  WHEN 'number'
                  THEN
                     IF v_field_size != '9,2'
                     THEN
                        v_reg_expr := '^([0-9]{1,' || v_field_size || '})$';
                     ELSE
                        v_reg_expr :='^([1-9][0-9]{0,6}\.{1}[0-9]{1,2})$|^([1-9][0-9]{0,6})$|^([0-9])$';
                     END IF;
                  WHEN 'date'
                  THEN
                     v_reg_expr := '^([0-9]{8})$';
                  ELSE
                     v_reg_expr := '^([a-zA-Z0-9 @.()_/\-]{1,' || v_field_size || '})$'; -- Matches most strings used                       
               END CASE;

               v_valid_field := regular_expression_checker (v_value, v_reg_expr);

               IF v_valid_field = 0
               THEN
                  p_cr_record_valid := 'N';
                  p_cr_record_error := ' Has invalid characters in field ' || v_key;
                  EXIT;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  p_cr_record_valid := 'N';
                  p_cr_record_error :=    'Validation error: ' || SQLCODE || ' SQL ERROR = '|| SQLERRM;
                  EXIT;
            END;

            BEGIN
               IF v_hebss = 'Y'
               THEN
                  CASE v_key
                     WHEN 'stud_consent'
                     THEN
                        IF v_value NOT IN ('Y', 'N')
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Stud consent field not valid';
                           EXIT;
                        ELSE
                           v_stud_consent := v_value;
                        END IF;
                     WHEN 'ben1_consent'
                     THEN
                        IF v_value NOT IN ('Y', 'N')
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Ben1 consent field not valid';
                           EXIT;
                        ELSE
                           v_ben1_consent := v_value;

                           IF v_ben_consent = 'N'
                           THEN
                              v_ben_consent := v_value;
                           END IF;
                        END IF;
                     WHEN 'ben2_consent'
                     THEN
                        IF v_value NOT IN ('Y', 'N')
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Ben2 consent field not valid';
                           EXIT;
                        ELSE
                           v_ben2_consent := v_value;

                           IF v_ben_consent = 'Y'
                           THEN
                              v_ben_consent := v_value;
                           END IF;
                        END IF;
                     WHEN 'repeat_year'
                     THEN
                        IF v_value NOT IN ('Y', 'N')
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Repeat year field not valid';
                           EXIT;
                        END IF;
                     WHEN 'no_of_benefactors'
                     THEN
                        IF v_value NOT IN ('0', '1', '2')
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' No of benefactors field not valid';
                           EXIT;
                        END IF;
                     WHEN 'non_means_tested'
                     THEN
                        IF v_value NOT IN ('Y', 'N')
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Non means tested field not valid';
                           EXIT;
                        END IF;
                     WHEN 'resid_house_income'
                     THEN
                        IF v_ben_consent = 'N'
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Resid house income field must be null';
                           EXIT;
                        END IF;
                     WHEN 'ben1_total_income'
                     THEN
                        IF v_ben1_consent = 'N'
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Ben1 total incomefield must be null';
                           EXIT;
                        END IF;
                     WHEN 'ben2_total_income'
                     THEN
                        IF v_ben2_consent = 'N'
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Ben2 total income field must be null';
                           EXIT;
                        END IF;
                     WHEN 'total_fee_loan_available'
                     THEN
                        IF v_stud_consent = 'N'
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Total fee loan available field must be null';
                           EXIT;
                        END IF;
                     WHEN 'bursary_entitlement'
                     THEN
                        IF v_stud_consent = 'N'
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Total fee loan available field must be null';
                           EXIT;
                        END IF;
                     WHEN 'stud_sort_code'
                     THEN
                        v_valid_field := regular_expression_checker (v_value, '^([0-9]{6})$');

                        IF v_valid_field = 0
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error :=' Has invalid characters in field ' || v_key;
                           EXIT;
                        ELSE
                           v_account := v_account + 1;
                        END IF;
                     WHEN 'stud_acc_number'
                     THEN
                        v_valid_field := regular_expression_checker (v_value, '^([0-9]{8})$');

                        IF v_valid_field = 0
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Has invalid characters in field ' || v_key;
                           EXIT;
                        ELSE
                           v_account := v_account + 1;
                        END IF;
                     ELSE
                        p_cr_record_valid := 'Y';
                  END CASE;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  p_cr_record_valid := 'N';    
                  p_cr_record_error :=    'Validation error: ' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
                  EXIT;                       
            END;

            BEGIN
               CASE v_key
                  WHEN 'form_type'
                  THEN
                     IF v_value != 'CR'
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Form type field has invalid characters';
                        EXIT;
                     END IF;
                  WHEN 'attendance_status'
                  THEN
                     IF v_value NOT IN ('A', 'W', 'N', 'D')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Attendance status field has an invalid character';
                        EXIT;
                     END IF;
                  WHEN 'deceased'
                  THEN
                     IF v_value NOT IN (' ', 'C', 'N')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Deceased field has an invalid character';
                        EXIT;
                     END IF;
                  WHEN 'status_type'
                  THEN
                     IF v_value NOT IN ('S', 'H')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Status type field has an invalid character';
                        EXIT;
                     END IF;
                  WHEN 'non_hei_pay_route'
                  THEN
                     IF v_value NOT IN ('D', 'G', 'M', 'O', 'P', 'U')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' No hei pay route field has an invalid character';
                        EXIT;
                     END IF;
                  WHEN 'slcssn'
                  THEN
                     v_valid_field := regular_expression_checker ( v_value, '^[SAAS | saas]{4}[0-9]{8}[a-zA-Z]{1}$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' SLC ssn field has incorrect format';
                        EXIT;
                     END IF;
                  WHEN 'hei_code'
                  THEN
                     v_valid_field := regular_expression_checker (v_value, '^[a-zA-Z]{4}$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' HEI code field has incorrect format';
                        EXIT;
                     END IF;
                  WHEN 'year_of_course'
                  THEN
                     v_valid_field := regular_expression_checker (v_value, '^[1-9]{1}$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Year of course field has incorrect format';
                        EXIT;
                     END IF;
                  WHEN 'home_post_code'
                  THEN
                     v_valid_field :=
                        regular_expression_checker ( v_value, '^[a-zA-Z]{1,2}[1-9]{1,2}[a-zA-Z]{0,1}[ ][1-9][a-zA-Z]{2}$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Home post code field is in wrong format';
                        EXIT;
                     END IF;
                  WHEN 'term_post_code'
                  THEN
                     v_valid_field := regular_expression_checker ( v_value, '^[a-zA-Z]{1,2}[1-9]{1,2}[a-zA-Z]{0,1}[ ][1-9][a-zA-Z]{2}$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Term post code field is in wrong format';
                        EXIT;
                     END IF;
                  WHEN 'gender'
                  THEN
                     IF v_value NOT IN ('M', 'F')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Gender field has an incorrect value. Must be M or F.';
                        EXIT;
                     END IF;
                  WHEN 'dob'
                  THEN
                     v_date := TO_DATE (v_value, 'ddMMyyyy');

                     IF v_date >= v_todays_date
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' DOB cannot be equal to days date or in the future';
                        EXIT;
                     END IF;
                  WHEN 'study_end_date'
                  THEN
                     v_date := TO_DATE (v_value, 'ddMMyyyy');

                     IF v_date > v_ten_years_from_now
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Study end date cannot be greater that 10 years in the future';
                        EXIT;
                     END IF;

                     IF p_customer_record.attendance_status = 'W'
                     THEN
                        IF v_date > v_todays_date
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' For a withdrawn student the study end date cannot be in the future';
                           EXIT;
                        END IF;
                     -- TODO: check if this is correct

                     -- For withdrawn study end date must be after the study start date. However, if the applications attendance staus is withdrawn then
                     -- then the study start date is used as the end date. therefore, no point in doing the validation?
                     END IF;
                  WHEN 'home_tel_no'
                  THEN
                     -- TODO: currently we don't perform a full area code check. Need BA to confirm this is okay
                     v_valid_field := regular_expression_checker (v_value, '^[0][1-2 | 7][0-9]{9}$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Home telephone number not valid';
                        EXIT;
                     END IF;
                  WHEN 'resid_house_income'
                  THEN
                     IF v_ben_consent = 'N' OR v_hebss = 'N'
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Resid house income field must be null';
                        EXIT;
                     END IF;
                  WHEN 'ben1_total_income'
                  THEN
                     IF v_ben1_consent = 'N' OR v_hebss = 'N'
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Ben1 total incomefield must be null';
                        EXIT;
                     END IF;
                  WHEN 'ben2_total_income'
                  THEN
                     IF v_ben2_consent = 'N' OR v_hebss = 'N'
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Ben2 total income field must be null';
                        EXIT;
                     END IF;
                  WHEN 'total_fee_loan_available'
                  THEN
                     IF v_stud_consent = 'N' OR v_hebss = 'N'
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Total fee loan available field must be null';
                        EXIT;
                     END IF;
                  WHEN 'nino'
                  THEN
                     v_valid_field := regular_expression_checker ( v_value, '^([A-CEGHJ-PR-TW-Z]{1}[A-CEGHJ-NPR-TW-Z]{1}[0-9]{6}[A-D]{1})$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Nino is not valid';
                        EXIT;
                     END IF;
                  WHEN 'nino_action'
                  THEN
                     -- TODO: needs further clarificationfor 'R' and 'H' value. Email BA.
                     IF v_value NOT IN ('R', 'V', 'H', 'E', 'M')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Nino action field is not valid';
                        EXIT;
                     END IF;
                  WHEN 'email_address'
                  THEN
                     v_valid_field := regular_expression_checker ( v_value, '^([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4})$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Email address is not valid';
                        EXIT;
                     END IF;
                  WHEN 'mobile_phone_number'
                  THEN
                     v_valid_field := regular_expression_checker (v_value, '^[0][1-2 | 7][0-9]{9}$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Mobile phone number not valid';
                        EXIT;
                     END IF;
                  WHEN 'correspondence_indicator'
                  THEN
                     IF v_value NOT IN ('H', 'T')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Correspondence indicator field is not valid';
                        EXIT;
                     END IF;
                  WHEN 'lct1_name'
                  THEN
                     v_contact_one_mandatory := 'Y';
                  WHEN 'lct2_name'
                  THEN
                     v_contact_two_mandatory := 'Y';
                  WHEN 'lct1_relationship'
                  THEN
                     IF v_value NOT IN
                           ('F',
                            'M',
                            'P',
                            'G',
                            'H',
                            'W',
                            'O',
                            'K',
                            'T',
                            'E',
                            'R',
                            'B',
                            'S',
                            'U',
                            'A',
                            'N',
                            'D')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Lct1 relationship field not valid';
                        EXIT;
                     END IF;
                  WHEN 'lct1_post_code'
                  THEN
                     IF v_contact_one_mandatory = 'N'
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Lct1 post code field must be null';
                        EXIT;
                     END IF;

                     v_valid_field := regular_expression_checker (v_value,'^[a-zA-Z]{1,2}[1-9]{1,2}[a-zA-Z]{0,1}[ ][1-9][a-zA-Z]{2}$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Lct1 post code field is in wrong format';
                        EXIT;
                     END IF;
                  WHEN 'lct2_post_code'
                  THEN
                     IF v_contact_two_mandatory = 'N'
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Lct2 post code field must be null';
                        EXIT;
                     END IF;

                     v_valid_field := regular_expression_checker ( v_value, '^[a-zA-Z]{1,2}[1-9]{1,2}[a-zA-Z]{0,1}[ ][1-9][a-zA-Z]{2}$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Lct2 post code field is in wrong format';
                        EXIT;
                     END IF;
                  WHEN 'lct1_phone_number'
                  THEN
                     IF v_contact_one_mandatory = 'N'
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Lct1 phone number field must be null';
                        EXIT;
                     END IF;

                     v_valid_field := regular_expression_checker (v_value, '^[0][1-2 | 7][0-9]{9}$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Loan contact one phone number not valid';
                        EXIT;
                     END IF;
                  WHEN 'lct2_phone_number'
                  THEN
                     IF v_contact_two_mandatory = 'N'
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Lct2 phone number field must be null';
                        EXIT;
                     END IF;

                     v_valid_field := regular_expression_checker (v_value, '^[0][1-2 | 7][0-9]{9}$');

                     IF v_valid_field != 1
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Loan contact two phone number not valid';
                        EXIT;
                     END IF;
                  WHEN 'lcl_ind'
                  THEN
                     IF v_value NOT IN ('Y', 'N')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Lcl ind field not valid';
                        EXIT;
                     ELSE
                        v_lcl_ind := v_value;
                     END IF;
                  WHEN 'ruktfl_ind'
                  THEN
                     IF v_value NOT IN ('Y', 'N')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Ruktfl ind field not valid';
                        EXIT;
                     END IF;
                  WHEN 'psastfl_ind'
                  THEN
                     IF v_value NOT IN ('Y', 'N')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Psaatfl ind field not valid';
                        EXIT;
                     END IF;
                  WHEN 'hebss_ind'
                  THEN
                     IF v_value NOT IN ('Y', 'N')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Hebss ind field not valid';
                        EXIT;
                     ELSE
                        IF v_value = 'N' AND v_lcl_ind = 'N'
                        THEN
                           p_cr_record_valid := 'N';
                           p_cr_record_error := ' Flags lcl inf and hebss ind cannot both be N';
                           EXIT;
                        END IF;
                     END IF;
                  WHEN 'arrears_status_req'
                  THEN
                     IF v_value NOT IN ('Y', 'N')
                     THEN
                        p_cr_record_valid := 'N';
                        p_cr_record_error := ' Arrears status req field not valid';
                        EXIT;
                     END IF;
                  ELSE
                     p_cr_record_valid := 'Y';
               END CASE;
            EXCEPTION
               WHEN OTHERS
               THEN
                  p_cr_record_valid := 'N';
                  p_cr_record_error :=    'Validation error: '|| SQLCODE || ' SQL ERROR = ' || SQLERRM;
                  EXIT;
            END;
         END IF;
           
         v_date := NULL;
         v_valid_field := 0;
         v_reg_expr := ' ';
         v_i := v_i + 1;
      END LOOP;

      IF p_cr_record_valid = 'Y'
      THEN
         IF v_hebss = 'Y'
         THEN
            IF v_account != 2
            THEN
               p_cr_record_valid := 'N';
               p_cr_record_error :=
                     'Students record : '
                  || p_customer_keys.stud_ref_no
                  || ' Bank sort code and account details are missing';
                                    
            END IF;
         END IF;
      END IF;

      v_account := 0;

   EXCEPTION   
      WHEN OTHERS
      THEN 
         p_cr_record_valid := 'N';
         p_cr_record_error := 'Validation error - Students record: ' ||  p_customer_keys.stud_ref_no  || ' SQL Code ' ||  SQLCODE || ' SQL ERROR = ' ||  SQLERRM;
          
   END validate_customer_record;

   /*
   This procedure is responsible for processing the passed customer record, either
   by invoking the procedure that includes it in the customer record file if it
   is valid, or by invoking the procedure that inserts details into the
   SLC_CR_ERRORS table if it is not
   */
   PROCEDURE process_customer_record (
      p_customer_keys     IN t_customer_keys,
      p_customer_record   IN t_customer_record,     
      p_file_name         IN VARCHAR2,
      p_file_handle       IN UTL_FILE.file_type)
   IS
      v_handle   UTL_FILE.file_type;
      r_customer_record t_customer_record;
   BEGIN      
         
         v_handle := p_file_handle;         
         format_customer_record (p_customer_record, r_customer_record);                   
         add_cr_line (r_customer_record, v_handle);                   
         insert_cr_record (p_customer_keys,
                           p_customer_record,
                           p_file_name);     

         update_student_record ('Y', p_customer_keys);
                           
                           
                                                                                                                                              
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('Process_customer_record - exception ' ||  p_customer_keys.stud_ref_no  || ' SQL Code ' ||  SQLCODE || ' SQL ERROR = ' ||  SQLERRM );
   END process_customer_record;

   /*
    This procedure is responsible for padding the data within the customer record type in
    order for the content to conform to the format requirements of the flat file
    */
   PROCEDURE format_customer_record (p_customer_record IN t_customer_record,
                                     r_customer_record  OUT t_customer_record )
   IS
   BEGIN
           r_customer_record := p_customer_record;

           r_customer_record.form_type := LPAD(p_customer_record.form_type,2);    
           r_customer_record.record_no := LPAD(p_customer_record.record_no,6,'0');
           r_customer_record.academic_year := LPAD(p_customer_record.academic_year,4);
           r_customer_record.attendance_status := LPAD(p_customer_record.attendance_status,1);
           r_customer_record.deceased := NVL(p_customer_record.deceased,' ');    
           r_customer_record.status_type := LPAD(p_customer_record.status_type,1);
           r_customer_record.non_hei_pay_route := NVL(p_customer_record.non_hei_pay_route,' ');
           r_customer_record.slcssn := LPAD(p_customer_record.slcssn,13);
           r_customer_record.ucas_no := NVL(LPAD(p_customer_record.ucas_no, 9, '0'), LPAD(' ', 9));
           r_customer_record.hei_code := RPAD(p_customer_record.hei_code, 4);
           r_customer_record.course_code := LPAD(p_customer_record.course_code, 6, '0');
           r_customer_record.year_of_course := p_customer_record.year_of_course;                      
           r_customer_record.title := RPAD(p_customer_record.title, 10);
           r_customer_record.surname := NVL(RPAD(p_customer_record.surname, 30), RPAD(' ', 30));             
           r_customer_record.forenames := NVL(RPAD(p_customer_record.forenames, 30), RPAD(' ', 30));     
           r_customer_record.home_addr_l1 := NVL(RPAD(p_customer_record.home_addr_l1, 60), RPAD(' ', 60)); 
           r_customer_record.home_addr_l2 := NVL(RPAD(p_customer_record.home_addr_l2, 60), RPAD(' ', 60)); 
           r_customer_record.home_addr_l3 := NVL(RPAD(p_customer_record.home_addr_l3, 60), RPAD(' ', 60)); 
           r_customer_record.home_addr_l4 := NVL(RPAD(p_customer_record.home_addr_l4, 60), RPAD(' ', 60)); 
           r_customer_record.home_post_code := NVL(RPAD(p_customer_record.home_post_code, 8), RPAD(' ', 8)); 
           r_customer_record.gender := p_customer_record.gender;           
           r_customer_record.dob := LPAD(p_customer_record.dob, 8);
           r_customer_record.study_end_date := LPAD(p_customer_record.study_end_date, 8);                      
           r_customer_record.home_tel_no := NVL(RPAD(p_customer_record.home_tel_no, 14), RPAD(' ', 14) );
           r_customer_record.birth_district := RPAD(p_customer_record.birth_district, 25);           
           r_customer_record.birth_country := RPAD(p_customer_record.birth_country, 25);           
           r_customer_record.stud_consent := NVL(p_customer_record.stud_consent, ' ' );           
           r_customer_record.ben1_consent := NVL(p_customer_record.ben1_consent, ' ' );
           r_customer_record.ben2_consent := NVL(p_customer_record.ben2_consent, ' ' );
           r_customer_record.repeat_year := NVL(p_customer_record.repeat_year, ' ' );           
           r_customer_record.no_of_benefactors := NVL(p_customer_record.no_of_benefactors,'0');
           r_customer_record.non_means_tested := NVL(p_customer_record.non_means_tested, ' ' );
           r_customer_record.no_of_dependants := NVL(p_customer_record.no_of_dependants, '0');                                 
           r_customer_record.resid_house_income := NVL(LPAD(p_customer_record.resid_house_income, 10, '0'), LPAD('0.00', 10, '0') );           
           r_customer_record.ben1_total_income := NVL(LPAD(p_customer_record.ben1_total_income, 10, '0'), LPAD('0.00', 10, '0') );
           r_customer_record.ben2_total_income := NVL(LPAD(p_customer_record.ben2_total_income, 10, '0'), LPAD('0.00', 10, '0') );
           r_customer_record.total_fee_loan_available:= NVL(LPAD(p_customer_record.total_fee_loan_available, 9, '0'), LPAD('0.00', 9, '0') );
           r_customer_record.bursary_entitlement := NVL(LPAD(p_customer_record.bursary_entitlement, 9, '0'), LPAD('0.00', 9, '0') );
           r_customer_record.stud_sort_code:=  NVL(LPAD(p_customer_record.stud_sort_code, 6, '0'), LPAD(' ', 6) );
           r_customer_record.stud_acc_number := NVL(LPAD(p_customer_record.stud_acc_number, 8, '0'), LPAD(' ', 8) );                                 
           r_customer_record.nino := NVL(LPAD(p_customer_record.nino, 9), LPAD(' ', 9) );           
           r_customer_record.nino_action := p_customer_record.nino_action;           
           r_customer_record.term_addr_l1 := RPAD(p_customer_record.term_addr_l1, 60);
           r_customer_record.term_addr_l2 := RPAD(p_customer_record.term_addr_l2, 60);
           r_customer_record.term_addr_l3 := NVL(RPAD(p_customer_record.term_addr_l3, 60), RPAD(' ', 60) );
           r_customer_record.term_addr_l4 := NVL(RPAD(p_customer_record.term_addr_l4, 60), RPAD(' ', 60) );
           r_customer_record.term_post_code := NVL(RPAD(p_customer_record.term_post_code, 8), RPAD(' ', 8) );                    
           r_customer_record.email_address := NVL(RPAD(p_customer_record.email_address, 80), RPAD(' ', 80) ); 
           r_customer_record.mobile_phone_number := NVL(RPAD(p_customer_record.mobile_phone_number, 20), RPAD(' ', 20));  
           r_customer_record.correspondence_indicator := p_customer_record.correspondence_indicator;
           r_customer_record.lct1_name := NVL(RPAD(TRIM(p_customer_record.lct1_name), 60), RPAD(' ', 60));                
           r_customer_record.lct1_relationship := NVL(RPAD(p_customer_record.lct1_relationship, 1), ' ');    
           r_customer_record.lct1_addr_l1 := NVL(RPAD(TRIM(p_customer_record.lct1_addr_l1), 60), RPAD(' ', 60));
           r_customer_record.lct1_addr_l2 := NVL(RPAD(TRIM(p_customer_record.lct1_addr_l2), 60), RPAD(' ', 60));          
           r_customer_record.lct1_addr_l3 := NVL(RPAD(TRIM(p_customer_record.lct1_addr_l3), 60), RPAD(' ', 60));
           r_customer_record.lct1_addr_l4 := NVL(RPAD(TRIM(p_customer_record.lct1_addr_l4), 60), RPAD(' ', 60));
           r_customer_record.lct1_post_code := NVL(RPAD(p_customer_record.lct1_post_code, 8), RPAD(' ', 8));
           r_customer_record.lct1_phone_number := NVL(RPAD(p_customer_record.lct1_phone_number, 14), RPAD(' ', 14));            
           r_customer_record.lct2_name := NVL(RPAD(TRIM(p_customer_record.lct2_name), 60), RPAD(' ', 60));
           r_customer_record.lct2_addr_l1 := NVL(RPAD(TRIM(p_customer_record.lct2_addr_l1), 60), RPAD(' ', 60));
           r_customer_record.lct2_addr_l2 := NVL(RPAD(TRIM(p_customer_record.lct2_addr_l2), 60), RPAD(' ', 60));
           r_customer_record.lct2_addr_l3 := NVL(RPAD(TRIM(p_customer_record.lct2_addr_l3), 60), RPAD(' ', 60));
           r_customer_record.lct2_addr_l4 := NVL(RPAD(TRIM(p_customer_record.lct2_addr_l4), 60), RPAD(' ', 60));
           r_customer_record.lct2_post_code := NVL(RPAD(p_customer_record.lct2_post_code, 8), RPAD(' ', 8)); 
           r_customer_record.lct2_phone_number := NVL(RPAD(p_customer_record.lct2_phone_number, 14), RPAD(' ', 14));            
           r_customer_record.lcl_ind := p_customer_record.lcl_ind;
           r_customer_record.ruktfl_ind := p_customer_record.ruktfl_ind;             
           r_customer_record.psastfl_ind := p_customer_record.psastfl_ind;
           r_customer_record.hebss_ind := p_customer_record.hebss_ind;
           r_customer_record.arrears_status_req := p_customer_record.arrears_status_req;
             
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('format_customer_record - exception ' ||  SQLCODE || ' SQL ERROR = ' ||  SQLERRM );
   END format_customer_record;

   /*
    This procedure is responsible for inserting details of validation failures
    into the SLC_CR_ERRORS table
    */
   PROCEDURE insert_cr_error (p_customer_keys       IN t_customer_keys,
                              p_customer_record     IN t_customer_record,
                              p_file_name           IN VARCHAR2,
                              p_error_description   IN VARCHAR2)
   IS
      v_inst_code     VARCHAR2 (5);
      v_crse_code     VARCHAR2 (4);
      v_scheme_type   VARCHAR2 (1);
      v_dearing       VARCHAR2 (1);
      v_team_name     VARCHAR2 (25);
      v_batch_date    DATE;
      v_slc_ssn       VARCHAR2 (9);
   BEGIN

      SELECT scy.inst_code,
             scy.crse_code,
             scy.scheme_type,
             scy.dearing
        INTO v_inst_code,
             v_crse_code,
             v_scheme_type,
             v_dearing
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = p_customer_keys.stud_crse_year_id;

      CASE v_scheme_type
         WHEN 'P'
         THEN
            v_team_name := 'TEAM 4';
         WHEN 'U'
         THEN
            CASE
               WHEN v_dearing IN ('C', 'D', 'F')
               THEN
                  v_team_name := 'TEAM 1';
               WHEN v_dearing IN ('E', 'G')
               THEN
                  v_team_name := 'TEAM 3';
               ELSE   
                  v_team_name  := 'TEAM 1';
            END CASE;
         ELSE  
                v_team_name  := 'TEAM 1'; 
      END CASE;  

      v_slc_ssn := SUBSTR(p_customer_record.slcssn,5); 

      BEGIN
      
          v_batch_date := get_batch_date ( p_file_name );
 
          INSERT INTO slc_cr_errors (slc_filename,
                                     slc_file_date,
                                     stud_crse_year_id,
                                     stud_ref_no,
                                     inst_code,
                                     crse_code,
                                     session_code,
                                     slc_ssn,
                                     error_description,
                                     team_name,
                                     record_error_type)
               VALUES (p_file_name,
                       v_batch_date,
                       p_customer_keys.stud_crse_year_id,
                       p_customer_keys.stud_ref_no,
                       v_inst_code,                          -- inst_code
                       v_crse_code,                          -- crse_code
                       p_customer_record.academic_year,      -- session_code
                       v_slc_ssn,                            -- slc_ssn
                       p_error_description,
                       v_team_name,                          -- team_name
                       '02');                      
                                                      
          COMMIT;      
          
          update_student_record ('N', p_customer_keys);          
          
      EXCEPTION 

        WHEN OTHERS
        THEN
             DBMS_OUTPUT.put_line ('Failed to insert into slc_cr_errors'|| SQLCODE|| ' SQL ERROR = '|| SQLERRM);
             ROLLBACK;      
      END;    
                          
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('insert_cr_error - exception'|| SQLCODE|| ' SQL ERROR = '|| SQLERRM);   
         ROLLBACK;
   END insert_cr_error;

   /*
      This procedure is responsible for adding a passed, valid customer record into
      the customer record file
      */
   PROCEDURE add_cr_line (p_customer_record   IN     t_customer_record,
                          p_file_handle       IN OUT UTL_FILE.file_type)
   IS
      v_handle    UTL_FILE.FILE_TYPE;
      v_cr_line   VARCHAR2 (1527);
   BEGIN

      v_handle := p_file_handle;
      
      UTL_FILE.new_line (v_handle);             -- move to next line of report
      
      v_cr_line :=
           p_customer_record.form_type 
         || p_customer_record.record_no            
         || p_customer_record.academic_year  
         || p_customer_record.attendance_status 
         || p_customer_record.deceased 
         || p_customer_record.status_type 
         || p_customer_record.non_hei_pay_route 
         || p_customer_record.slcssn 
         || p_customer_record.ucas_no 
         || p_customer_record.hei_code 
         || p_customer_record.course_code 
         || p_customer_record.year_of_course 
         || p_customer_record.title 
         || p_customer_record.surname 
         || p_customer_record.forenames 
         || p_customer_record.home_addr_l1 
         || p_customer_record.home_addr_l2 
         || p_customer_record.home_addr_l3 
         || p_customer_record.home_addr_l4 
         || p_customer_record.home_post_code 
         || p_customer_record.gender 
         || p_customer_record.dob 
         || p_customer_record.study_end_date 
         || p_customer_record.home_tel_no 
         || p_customer_record.birth_district 
         || p_customer_record.birth_country 
         || p_customer_record.stud_consent 
         || p_customer_record.ben1_consent 
         || p_customer_record.ben2_consent 
         || p_customer_record.repeat_year 
         || p_customer_record.no_of_benefactors 
         || p_customer_record.non_means_tested 
         || p_customer_record.no_of_dependants 
         || p_customer_record.resid_house_income 
         || p_customer_record.ben1_total_income 
         || p_customer_record.ben2_total_income 
         || p_customer_record.total_fee_loan_available 
         || p_customer_record.bursary_entitlement 
         || p_customer_record.stud_sort_code 
         || p_customer_record.stud_acc_number 
         || p_customer_record.nino 
         || p_customer_record.nino_action 
         || p_customer_record.term_addr_l1 
         || p_customer_record.term_addr_l2 
         || p_customer_record.term_addr_l3 
         || p_customer_record.term_addr_l4 
         || p_customer_record.term_post_code 
         || p_customer_record.email_address 
         || p_customer_record.mobile_phone_number 
         || p_customer_record.correspondence_indicator 
         || p_customer_record.lct1_name 
         || p_customer_record.lct1_relationship 
         || p_customer_record.lct1_addr_l1 
         || p_customer_record.lct1_addr_l2 
         || p_customer_record.lct1_addr_l3 
         || p_customer_record.lct1_addr_l4 
         || p_customer_record.lct1_post_code 
         || p_customer_record.lct1_phone_number 
         || p_customer_record.lct2_name 
         || p_customer_record.lct2_addr_l1 
         || p_customer_record.lct2_addr_l2 
         || p_customer_record.lct2_addr_l3 
         || p_customer_record.lct2_addr_l4 
         || p_customer_record.lct2_post_code 
         || p_customer_record.lct2_phone_number 
         || p_customer_record.lcl_ind 
         || p_customer_record.ruktfl_ind 
         || p_customer_record.psastfl_ind 
         || p_customer_record.hebss_ind 
         || p_customer_record.arrears_status_req;

      UTL_FILE.put (v_handle, v_cr_line);

   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('add_cr_line - exception' || SQLCODE|| ' SQL ERROR = '|| SQLERRM);
   END add_cr_line;

   /*
      This procedure is responsible for inserting the passed valid customer record
      into the SLC_CR_DATA table
      */
   PROCEDURE insert_cr_record (p_customer_keys     IN t_customer_keys,
                               p_customer_record   IN t_customer_record,
                               p_file_name         IN VARCHAR2)
   IS
      v_saas_title   VARCHAR2 (8);
      v_batch_date DATE;
   BEGIN
      v_saas_title := convert_to_saas_title (p_customer_record.title);                         
      v_batch_date := get_batch_date ( p_file_name );
   
      INSERT INTO slc_cr_data scd (scd.slc_filename,
                                   scd.slc_file_date,
                                   scd.record_no,
                                   scd.stud_crse_year_id,
                                   scd.academic_year,
                                   scd.attendance_status,
                                   scd.deceased,
                                   scd.status_type,
                                   scd.non_hei_payment_route,
                                   scd.slc_ssn,
                                   scd.ucas_no,
                                   scd.hei_code,
                                   scd.course_code,
                                   scd.year_of_course,
                                   scd.title,
                                   scd.surname,
                                   scd.forenames,
                                   scd.home_addr_l1,
                                   scd.home_addr_l2,
                                   scd.home_addr_l3,
                                   scd.home_addr_l4,
                                   scd.home_post_code,
                                   scd.gender,
                                   scd.dob,
                                   scd.study_end_date,
                                   scd.home_tel_no,
                                   scd.birth_district,
                                   scd.birth_country,
                                   scd.student_consent,
                                   scd.benefactor1_consent,
                                   scd.benefactor2_consent,
                                   scd.repeat_year,
                                   scd.number_of_benefactors,
                                   scd.non_means_tested,
                                   scd.number_of_dependants,
                                   scd.household_resid_income,
                                   scd.ben1_total_income,
                                   scd.ben2_total_income,
                                   scd.total_fee_loan_available,
                                   scd.bursary_entitlement,
                                   scd.stud_sort_code,
                                   scd.stud_acc_number,
                                   scd.nino,
                                   scd.nino_action,
                                   scd.term_addr_l1,
                                   scd.term_addr_l2,
                                   scd.term_addr_l3,
                                   scd.term_addr_l4,
                                   scd.term_post_code,
                                   scd.email_address,
                                   scd.mobile_phone_no,
                                   scd.corres_ind,
                                   scd.lct1_name,
                                   scd.lct1_relationship,
                                   scd.lct1_addr_l1,
                                   scd.lct1_addr_l2,
                                   scd.lct1_addr_l3,
                                   scd.lct1_addr_l4,
                                   scd.lct1_postcode,
                                   scd.lct1_phone,
                                   scd.lct2_name,
                                   scd.lct2_addr_l1,
                                   scd.lct2_addr_l2,
                                   scd.lct2_addr_l3,
                                   scd.lct2_addr_l4,
                                   scd.lct2_postcode,
                                   scd.lct2_phone,
                                   scd.lcl_ind,
                                   scd.ruk_tfl_ind,
                                   scd.psas_tfl_ind,
                                   scd.hebss_ind,
                                   scd.arrears_status_req)
           VALUES (p_file_name,
                   v_batch_date,
                   p_customer_record.record_no,
                   p_customer_keys.stud_crse_year_id,
                   p_customer_record.academic_year,
                   p_customer_record.attendance_status,
                   p_customer_record.deceased,
                   p_customer_record.status_type,
                   p_customer_record.non_hei_pay_route,
                   p_customer_record.slcssn,
                   p_customer_record.ucas_no,
                   p_customer_record.hei_code,
                   p_customer_record.course_code,
                   p_customer_record.year_of_course,
                   v_saas_title,
                   p_customer_record.surname,
                   p_customer_record.forenames,
                   p_customer_record.home_addr_l1,
                   p_customer_record.home_addr_l2,
                   p_customer_record.home_addr_l3,
                   p_customer_record.home_addr_l4,
                   p_customer_record.home_post_code,
                   p_customer_record.gender,
                   TO_DATE (p_customer_record.dob, 'dd/MM/yyyy'),
                   TO_DATE (p_customer_record.study_end_date, 'dd/MM/yyyy'),
                   p_customer_record.home_tel_no,
                   p_customer_record.birth_district,
                   p_customer_record.birth_country,
                   p_customer_record.stud_consent,
                   p_customer_record.ben1_consent,
                   p_customer_record.ben2_consent,
                   p_customer_record.repeat_year,
                   p_customer_record.no_of_benefactors,
                   p_customer_record.non_means_tested,
                   p_customer_record.no_of_dependants,
                   p_customer_record.resid_house_income,
                   p_customer_record.ben1_total_income,
                   p_customer_record.ben2_total_income,
                   p_customer_record.total_fee_loan_available,
                   p_customer_record.bursary_entitlement,
                   p_customer_record.stud_sort_code,
                   p_customer_record.stud_acc_number,
                   p_customer_record.nino,
                   p_customer_record.nino_action,
                   p_customer_record.term_addr_l1,
                   p_customer_record.term_addr_l2,
                   p_customer_record.term_addr_l3,
                   p_customer_record.term_addr_l4,
                   p_customer_record.term_post_code,
                   p_customer_record.email_address,
                   p_customer_record.mobile_phone_number,
                   p_customer_record.correspondence_indicator,
                   p_customer_record.lct1_name,
                   p_customer_record.lct1_relationship,
                   p_customer_record.lct1_addr_l1,
                   p_customer_record.lct1_addr_l2,
                   p_customer_record.lct1_addr_l3,
                   p_customer_record.lct1_addr_l4,
                   p_customer_record.lct1_post_code,
                   p_customer_record.lct1_phone_number,
                   p_customer_record.lct2_name,
                   p_customer_record.lct2_addr_l1,
                   p_customer_record.lct2_addr_l2,
                   p_customer_record.lct2_addr_l3,
                   p_customer_record.lct2_addr_l4,
                   p_customer_record.lct2_post_code,
                   p_customer_record.lct2_phone_number,
                   p_customer_record.lcl_ind,
                   p_customer_record.ruktfl_ind,
                   p_customer_record.psastfl_ind,
                   p_customer_record.hebss_ind,
                   p_customer_record.arrears_status_req);

      COMMIT;  
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('insert_cr_record - exception SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM);
   END insert_cr_record;

   /*
      This procedure is responsible for updating the students record to indicate if
      their details were successfully included in the customer record file
   */
   PROCEDURE update_student_record (p_cr_record_valid   IN VARCHAR2,
                                    p_customer_keys     IN t_customer_keys)
   IS   
        v_request_arrears slc_customer_record.request_arrears%type;
        v_arrears_req_sent slc_customer_record.arrears_req_sent%type;
        v_arrears_req_sent_date slc_customer_record.arrears_req_sent_date%type;        
   BEGIN
     
      IF p_cr_record_valid = 'Y' THEN 

          SELECT scr.request_arrears 
          INTO v_request_arrears 
          FROM slc_customer_record scr
          WHERE scr.stud_crse_year_id = p_customer_keys.stud_crse_year_id;
          
          IF v_request_arrears = 'Y' THEN 
            v_request_arrears := 'N';
            v_arrears_req_sent := 'Y';        
          END IF;          
          
          UPDATE slc_customer_record
          SET slc_cr_sent = 'Y',
              slc_cr_status = 0,
              slc_cr_sent_date = sysdate, 
              arrears_req_sent = v_arrears_req_sent,
              arrears_req_sent_date = v_arrears_req_sent_date,
              request_arrears = v_request_arrears
          WHERE stud_crse_year_id = p_customer_keys.stud_crse_year_id;  
          
          /*
          TODO: We need clarification on the nino tables here. 
                    
          UPDATE nino_status_data
          SET locked_flag = 'Y',
              last_updated_by = system, -- TODO: need to check that this works
              last_update_ts = sysdate
          WHERE stud_ref_no = p_customer_keys.stud_ref_no;
          */
              
      ELSE
             
         UPDATE slc_customer_record
          SET slc_cr_sent = 'N',
              slc_cr_status = 2
          WHERE stud_crse_year_id = p_customer_keys.stud_crse_year_id;                  
      END IF;
          
      COMMIT;                         
                
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('update_student_record - exception');
         ROLLBACK;
   END update_student_record;

   /*
      This procedure is responsible for create a new file handle for use in other
      procedures so that records can be added to the file
   */
   PROCEDURE start_cr_file (p_file_name     OUT VARCHAR2,
                            p_file_handle   OUT UTL_FILE.file_type)
   IS
      v_handle           UTL_FILE.file_type;      -- report file handle
      v_path_name        VARCHAR2 (100);          -- holds file path for output
      v_file_name        VARCHAR2 (17);           -- Filename
      v_max_line_chars   NUMBER := 4096;          -- Max number of characters per line
      v_header_line      VARCHAR2 (23);
   BEGIN
      --  DBMS_OUTPUT.put_line ('start_cr_file');
      v_path_name := get_cr_file_path;
      v_file_name := get_cr_file_name;
      v_handle :=
         UTL_FILE.fopen (v_path_name,
                         v_file_name,
                         'w',
                         v_max_line_chars);
      v_header_line := get_cr_header_line;
      
      UTL_FILE.put (v_handle, v_header_line);

      insert_batch_record (v_file_name);

      p_file_name := v_file_name;
      p_file_handle := v_handle;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('start_cr_file - exception');
   END start_cr_file;

   /*
      This procedure is responsible for closing a file handle so no further records
      can be added to the file
      */
   PROCEDURE end_cr_file (p_file_name      IN VARCHAR2,
                          p_file_handle    IN UTL_FILE.file_type,
                          p_record_count   IN NUMBER)
   IS
      v_handle         UTL_FILE.file_type;               -- report file handle
      v_trailer_line   VARCHAR2 (31);
   BEGIN
   
      v_handle := p_file_handle;
      v_trailer_line := get_cr_trailer_line (p_record_count);
      
      UTL_FILE.new_line (v_handle);             -- move to next line of report

      UTL_FILE.put (v_handle, v_trailer_line);
      UTL_FILE.fclose (v_handle);                         -- close report file

      update_batch_record (p_file_name, p_record_count);   

   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('end_cr_file - exception' 
            || 'SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM); 
   END end_cr_file;
   
   /*
   Procedure inserts new data into 
   slc_cr_batches
   */
    PROCEDURE insert_batch_record (p_file_name IN VARCHAR2 )
    IS
    BEGIN
    
         INSERT INTO slc_cr_batches (slc_filename, 
                                     slc_file_date)
                            VALUES (p_file_name, 
                                    SYSDATE); 
                                
         COMMIT;
        
    EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('Insert batch record - exception SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM);      
         ROLLBACK;
    END insert_batch_record;   
    
    /*
    Procedure updates slc_cr_batches table
    */
    PROCEDURE update_batch_record (p_file_name         IN VARCHAR2,
                                   p_record_count      IN NUMBER  )    
    IS
    BEGIN
          UPDATE slc_cr_batches scrb
          SET scrb.record_count = p_record_count
          WHERE scrb.slc_filename = p_file_name;
            
          COMMIT;    
    EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('Update batch record - exception');
         ROLLBACK;    
   END update_batch_record;                                       
   
PROCEDURE make_eligible_s (p_stud_ref_no IN VARCHAR2)
IS
   v_stud_crse_year_id   STUD_CRSE_YEAR.stud_crse_year_id%TYPE;
   v_count               NUMBER (1);
BEGIN
   SELECT COUNT (*)
     INTO v_count 
     FROM stud_crse_year scy
    WHERE scy.stud_ref_no = p_stud_ref_no;

   IF v_count > 0
   THEN
      SELECT scy.stud_crse_year_id
        INTO v_stud_crse_year_id
        FROM stud_crse_year scy
       WHERE     scy.stud_ref_no = p_stud_ref_no
             AND SCY.SESSION_CODE = (SELECT MAX (ss.session_code)
                                       FROM stud_session ss
                                      WHERE ss.stud_ref_no = p_stud_ref_no)
             AND SCY.LATEST_CRSE_IND = 'Y';

      SGAS.PK_STEPS_LOANS_CUSTOMERRECORD.MAKE_ELIGIBLE_SCY (
         v_stud_crse_year_id);
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Make Eleigible For Selection - exception');
END make_eligible_s;

PROCEDURE make_eligible_ss (p_stud_session_id IN VARCHAR2)
IS
   v_stud_crse_year_id   STUD_CRSE_YEAR.stud_crse_year_id%TYPE;
   v_count               NUMBER (1);
BEGIN
   SELECT COUNT (*)
     INTO v_count
     FROM stud_crse_year scy
    WHERE scy.stud_session_id = p_stud_session_id;

   IF v_count > 0
   THEN
      SELECT scy.stud_crse_year_id
        INTO v_stud_crse_year_id
        FROM stud_crse_year scy
       WHERE     SCY.stud_session_id = p_stud_session_id
             AND SCY.LATEST_CRSE_IND = 'Y';

      SGAS.PK_STEPS_LOANS_CUSTOMERRECORD.MAKE_ELIGIBLE_SCY (
         v_stud_crse_year_id);
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Make Eleigible For Selection - exception');
END make_eligible_ss;

PROCEDURE make_eligible_scy (p_stud_crse_year_id IN VARCHAR2)
IS
   v_slc_cr_sent   VARCHAR2 (1);
BEGIN
   SELECT SCR.SLC_CR_SENT
     INTO v_slc_cr_sent
     FROM slc_customer_record scr
    WHERE scr.stud_crse_year_id = p_stud_crse_year_id;

   IF v_slc_cr_sent = 'Y'
   THEN
      UPDATE slc_customer_record scr
         SET SCR.SLC_CR_SENT = 'N'
       WHERE scr.stud_crse_year_id = p_stud_crse_year_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Make Eleigible For Selection - exception');
END make_eligible_scy;                              
END PK_STEPS_LOANS_CUSTOMERRECORD;
/