CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_stud_loan
AS
/******************************************************************************
   NAME:       pk_steps_ui_LOAN
   PURPOSE:

   REVISIONS:
   Ver        Date              Author                  Description
   ---------  ----------        ---------------         ------------------------------------
   1.0        06/10/2011        PADDY GRACE            Created this package.
   1.1        10/06/2015        EWAN WATSON            Added MAX(Date) line in getslcfeeloan
******************************************************************************/
   FUNCTION loan_contact_exists (
      stud_ref_no_in      IN   VARCHAR2,
      contact_number_in   IN   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_loan_contact_count   NUMBER (1);
   BEGIN
      SELECT COUNT (*)
        INTO v_loan_contact_count
        FROM stud_cont_details sc
       WHERE sc.stud_ref_no = stud_ref_no_in
         AND sc.contact_ind = contact_number_in;

      RETURN v_loan_contact_count;
   END loan_contact_exists;

   PROCEDURE checkloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      contact_exists      OUT NOCOPY      VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   IS
      v_contact_count   NUMBER (1);
   BEGIN
      v_contact_count :=
         sgas.pk_steps_ui_stud_loan.loan_contact_exists (stud_ref_no_in,
                                                         contact_number_in
                                                        );

      IF v_contact_count >= 1
      THEN
         contact_exists := 'Y';
      ELSE
         contact_exists := 'N';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END checkloancontact;

   PROCEDURE getloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      contact_name        OUT NOCOPY      VARCHAR2,
      relationship        OUT NOCOPY      VARCHAR2,
      addrl1              OUT NOCOPY      VARCHAR2,
      addrl2              OUT NOCOPY      VARCHAR2,
      addrl3              OUT NOCOPY      VARCHAR2,
      postcode            OUT NOCOPY      VARCHAR2,
      tele_no             OUT NOCOPY      VARCHAR2,
      record_count        OUT NOCOPY      VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      record_count :=
         sgas.pk_steps_ui_stud_loan.loan_contact_exists (stud_ref_no_in,
                                                         contact_number_in
                                                        );

      IF record_count > 0
      THEN
         SELECT sc.cont_name AS contact_name,
                sc.cont_rel_code AS relationship, sc.cont_addr1 AS addr_l1,
                sc.cont_addr2 AS addr_l2, sc.cont_addr3 AS addr_l3,
                sc.cont_postcode AS postcode, sc.cont_tel_no AS tele_no
           INTO contact_name,
                relationship, addrl1,
                addrl2, addrl3,
                postcode, tele_no
           FROM stud_cont_details sc
          WHERE sc.stud_ref_no = stud_ref_no_in
            AND sc.contact_ind = contact_number_in;
      ELSE
         contact_name := '';
         relationship := '';
         addrl1 := '';
         addrl2 := '';
         addrl3 := '';
         postcode := '';
         tele_no := '';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getloancontact;

   PROCEDURE setloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      contact_name_in     IN              VARCHAR2,
      relationship_in     IN              VARCHAR2,
      addr_l1_in          IN              VARCHAR2,
      addr_l2_in          IN              VARCHAR2,
      addr_l3_in          IN              VARCHAR2,
      postcode_in         IN              VARCHAR2,
      tele_no_in          IN              VARCHAR2,
      employee_in         IN              VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_cont_details sc
         SET sc.cont_name = UPPER (contact_name_in),
             sc.cont_rel_code = UPPER (relationship_in),
             sc.cont_addr1 = UPPER (addr_l1_in),
             sc.cont_addr2 = UPPER (addr_l2_in),
             sc.cont_addr3 = UPPER (addr_l3_in),
             sc.cont_postcode = UPPER (postcode_in),
             sc.cont_tel_no = tele_no_in,
             sc.last_updated_by = UPPER (employee_in),
             sc.last_updated_on = SYSDATE
       WHERE sc.stud_ref_no = stud_ref_no_in
         AND sc.contact_ind = contact_number_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setloancontact;

   PROCEDURE insertloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      contact_name_in     IN              VARCHAR2,
      relationship_in     IN              VARCHAR2,
      addrl1_in           IN              VARCHAR2,
      addrl2_in           IN              VARCHAR2,
      addrl3_in           IN              VARCHAR2,
      postcode_in         IN              VARCHAR2,
      tele_no_in          IN              VARCHAR2,
      employee_in         IN              VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      INSERT INTO stud_cont_details sc
                  (sc.stud_ref_no, sc.cont_name,
                   sc.cont_rel_code, sc.cont_addr1,
                   sc.cont_addr2, sc.cont_addr3,
                   sc.cont_postcode, sc.cont_tel_no, sc.contact_ind,
                   sc.last_updated_by, sc.last_updated_on
                  )
           VALUES (stud_ref_no_in, UPPER (contact_name_in),
                   UPPER (relationship_in), UPPER (addrl1_in),
                   UPPER (addrl2_in), UPPER (addrl3_in),
                   UPPER (postcode_in), tele_no_in, contact_number_in,
                   UPPER (employee_in), SYSDATE
                  );

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertloancontact;

   PROCEDURE deleteloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      employee_in         IN              VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_cont_details scd
         SET scd.last_updated_by = UPPER (employee_in)
       WHERE scd.stud_ref_no = stud_ref_no_in
         AND scd.contact_ind = contact_number_in;

      DELETE FROM stud_cont_details scd
            WHERE scd.stud_ref_no = stud_ref_no_in
              AND scd.contact_ind = contact_number_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deleteloancontact;

   PROCEDURE getloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      maximum_loan           OUT NOCOPY      VARCHAR2,
      loan_given             OUT NOCOPY      VARCHAR2,
      loan_amount            OUT NOCOPY      VARCHAR2,
      loan_sign_date         OUT NOCOPY      VARCHAR2,
      no_nino_reason         OUT NOCOPY      VARCHAR2,
      bankrupt               OUT NOCOPY      VARCHAR2,
      nino                   OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT ss.max_loan_requested AS maximum_loan,
             sc.loan_given AS loan_given, ss.loan_request AS loan_amount,
             TO_CHAR (ss.loan_declaration_date, 'DD/MM/yyyy')
                                                            AS loan_sign_date,
             ss.reason_no_nino AS no_nino_reason,
             s.bankrupt_flag AS bankrupt, s.ni_no AS nino
        INTO maximum_loan,
             loan_given, loan_amount,
             loan_sign_date,
             no_nino_reason,
             bankrupt, nino
        FROM stud_crse_year sc, stud s, stud_session ss
       WHERE ss.stud_session_id = sc.stud_session_id
         AND s.stud_ref_no = sc.stud_ref_no
         AND sc.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getloandetails;

   PROCEDURE setloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      max_loan_in            IN              VARCHAR2,
      loan_given_in          IN              VARCHAR2,
      loan_request_in        IN              VARCHAR2,
      loan_dec_date_in       IN              VARCHAR2,
      reason_no_nino_in      IN              VARCHAR2,
      bankrupt_in            IN              VARCHAR2,
      employee_in            IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   AS
      v_stud_ref_no       NUMBER (9);
      v_stud_session_id   NUMBER (9);
   BEGIN
      SELECT scy.stud_session_id, scy.stud_ref_no
        INTO v_stud_session_id, v_stud_ref_no
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      UPDATE stud s
         SET s.bankrupt_flag = UPPER (bankrupt_in),
             s.last_updated_by = UPPER (employee_in),
             s.last_updated_on = SYSDATE
       WHERE s.stud_ref_no = v_stud_ref_no;

      UPDATE stud_session ss
         SET ss.max_loan_requested = UPPER (max_loan_in),
             ss.loan_request = UPPER (loan_request_in),
             ss.loan_declaration_date =
                                      TO_DATE (loan_dec_date_in, 'DD/MM/yyyy'),
             ss.reason_no_nino = UPPER (reason_no_nino_in),
             ss.last_updated_by = UPPER (employee_in),
             ss.last_updated_on = SYSDATE
       WHERE ss.stud_session_id = v_stud_session_id;

      UPDATE stud_crse_year sc
         SET sc.loan_given = UPPER (loan_given_in),
             sc.last_updated_by = UPPER (employee_in),
             sc.last_updated_on = SYSDATE
       WHERE sc.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setloandetails;

   PROCEDURE getfeeloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      max_fee_loan           OUT NOCOPY      VARCHAR2,
      fee_loan_amt           OUT NOCOPY      VARCHAR2,
      fee_loan_charged       OUT NOCOPY      VARCHAR2,
      fee_loan_given         OUT NOCOPY      VARCHAR2,
      fee_loan_sign_date     OUT NOCOPY      VARCHAR2,
      record_count           OUT NOCOPY      VARCHAR2,
      commence_session       OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      v_stud_ref_no    NUMBER (9);
      v_dearing        VARCHAR2 (1);
      v_session_code        NUMBER (4);
      v_scheme_type         VARCHAR2 (1);
      v_eu_residence_type   NUMBER (9);
      v_eu_flag             VARCHAR(1);
   BEGIN
      SELECT scy.stud_ref_no, scy.dearing, scy.scheme_type, scy.session_code
        INTO v_stud_ref_no, v_dearing, v_scheme_type, v_session_code
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;
       
        SELECT SS.EU_RESIDENCE_TYPE, SS.EU_FLAG
        INTO v_eu_residence_type, v_eu_flag
        FROM stud_session ss, stud_crse_year scy
       WHERE SS.STUD_SESSION_ID = SCY.STUD_SESSION_ID
         AND scy.stud_crse_year_id = stud_crse_year_id_in;

      IF v_dearing = 'G' OR (v_scheme_type = 'P' AND v_session_code > 2011)
      THEN
         SELECT ss.max_fee_loan_requested AS max_fee_loan,
                ss.fee_loan_request_amount AS fee_loan_amt,
                ss.fee_loan_charged AS fee_loan_charged,
                sc.fee_loan_given AS fee_loan_given,
                TO_CHAR (ss.fee_loan_declaration_date, 'DD/MM/yyyy')
                                                        AS fee_loan_sign_date,
                (SELECT COUNT (*)
                   FROM stud_crse_year sc
                  WHERE sc.stud_ref_no = v_stud_ref_no
                    AND sc.session_code =
                           (SELECT sc.session_code
                              FROM stud_crse_year sc
                             WHERE sc.stud_crse_year_id = stud_crse_year_id_in)
                    AND (   sc.dearing = 'G'
                         OR (sc.scheme_type = 'P' AND sc.session_code > 2011
                            )
                        )) AS record_count,
                s.commence_session AS commence_session
           INTO max_fee_loan,
                fee_loan_amt,
                fee_loan_charged,
                fee_loan_given,
                fee_loan_sign_date,
                record_count,
                commence_session
           FROM stud_crse_year sc, stud_session ss, stud s
          WHERE ss.stud_session_id = sc.stud_session_id
            AND s.stud_ref_no = sc.stud_ref_no
            AND (   sc.dearing = 'G'
                 OR (sc.scheme_type = 'P' AND sc.session_code > 2011)
                )
            AND sc.stud_crse_year_id = stud_crse_year_id_in;
       ELSIF 
                v_eu_flag = 'Y' AND v_eu_residence_type != 1
           THEN
         SELECT ss.max_fee_loan_requested AS max_fee_loan,
                ss.fee_loan_request_amount AS fee_loan_amt,
                ss.fee_loan_charged AS fee_loan_charged,
                sc.fee_loan_given AS fee_loan_given,
                TO_CHAR (ss.fee_loan_declaration_date, 'DD/MM/yyyy')
                                                        AS fee_loan_sign_date,
                  (SELECT COUNT (*) 
                    FROM (       
                   SELECT SS.EU_RESIDENCE_TYPE, SS.EU_FLAG
                    FROM stud_session ss, stud_crse_year scy
                    WHERE SS.STUD_SESSION_ID = SCY.STUD_SESSION_ID
                      AND sc.session_code =
                           (SELECT scy.session_code
                              FROM stud_crse_year scy
                             WHERE scy.stud_crse_year_id = stud_crse_year_id_in)
                    AND scy.stud_ref_no =  v_stud_ref_no 
                    AND SS.EU_FLAG ='Y'
                    AND SS.EU_RESIDENCE_TYPE IN (2,3,4)
                    AND sc.stud_crse_year_id = stud_crse_year_id_in)) AS record_count,                                                                                                         
                s.commence_session AS commence_session
          INTO max_fee_loan,
                fee_loan_amt,
                fee_loan_charged,
                fee_loan_given,
                fee_loan_sign_date,
                record_count,
                commence_session
           FROM stud_crse_year sc, stud_session ss, stud s
          WHERE ss.stud_session_id = sc.stud_session_id
            AND s.stud_ref_no = sc.stud_ref_no
            AND SS.EU_FLAG ='Y'
            AND SS.EU_RESIDENCE_TYPE IN (2,3,4)
            AND sc.stud_crse_year_id = stud_crse_year_id_in;
      ELSE      
                
           fee_loan_given := 'A'; --Defect20 EJW
        
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getfeeloandetails;

   PROCEDURE setfeeloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      max_fee_loan_in        IN              VARCHAR2,
      fee_loan_given_in      IN              VARCHAR2,
      fee_loan_request_in    IN              VARCHAR2,
      fee_loan_charged_in    IN              VARCHAR2,
      fee_loan_dec_date_in   IN              VARCHAR2,
      employee_in            IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   AS
      v_stud_session_id   NUMBER (9);
   BEGIN
      SELECT scy.stud_session_id
        INTO v_stud_session_id
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      UPDATE stud_session ss
         SET ss.max_fee_loan_requested = max_fee_loan_in,
             ss.fee_loan_request_amount = fee_loan_request_in,
             ss.fee_loan_charged = fee_loan_charged_in,
             ss.fee_loan_declaration_date =
                                  TO_DATE (fee_loan_dec_date_in, 'DD/MM/yyyy'),
             ss.last_updated_by = UPPER (employee_in),
             ss.last_updated_on = SYSDATE
       WHERE ss.stud_session_id = v_stud_session_id;

      UPDATE stud_crse_year sc
         SET sc.fee_loan_given = fee_loan_given_in,
             sc.last_updated_by = UPPER (employee_in),
             sc.last_updated_on = SYSDATE
       WHERE sc.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setfeeloandetails;

   PROCEDURE getslc (
      stud_crse_year_id_in   IN              VARCHAR2,
      slc_ref_num            OUT NOCOPY      VARCHAR2,
      loan_ass_last_sent     OUT NOCOPY      VARCHAR2,
      loan_ass_status        OUT NOCOPY      VARCHAR2,
      loan_ass_first_sent    OUT NOCOPY      VARCHAR2,
      loan_app_last_sent     OUT NOCOPY      VARCHAR2,
      loan_app_status        OUT NOCOPY      VARCHAR2,
      loan_app_first_sent    OUT NOCOPY      VARCHAR2,
      loan_slc1_sent         OUT NOCOPY      VARCHAR2,
      loan_slc2_sent         OUT NOCOPY      VARCHAR2,      
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT s.scottish_cand AS slc_ref_num,
             TO_CHAR (sc.slc1_sent_date, 'dd/MM/yyyy') AS loan_ass_last_sent,
             sc.slc1_status AS loan_ass_status,
             TO_CHAR (sc.first_slc1_sent_date, 'dd/MM/yyyy')
                                                       AS loan_ass_first_sent,
             TO_CHAR (sc.slc2_sent_date, 'dd/MM/yyyy') AS loan_app_last_sent,
             sc.slc2_status AS loan_app_status,
             TO_CHAR (sc.first_slc2_sent_date, 'dd/MM/yyyy')
                                                       AS loan_app_first_sent,
             sc.slc1_sent AS loan_slc1_sent,
             sc.slc2_sent AS loan_slc2_sent                                                      
        INTO slc_ref_num,
             loan_ass_last_sent,
             loan_ass_status,
             loan_ass_first_sent,
             loan_app_last_sent,
             loan_app_status,
             loan_app_first_sent,
             loan_slc1_sent,
             loan_slc2_sent
        FROM stud_crse_year sc, stud s
       WHERE sc.stud_ref_no = s.stud_ref_no
         AND sc.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getslc;

   PROCEDURE setslc (
      stud_crse_year_id_in   IN              VARCHAR2,
      loan_ass_status_in     IN              VARCHAR2,
      loan_app_status_in     IN              VARCHAR2,
      employee_in            IN              VARCHAR2,
      slc1_sent_in           IN              VARCHAR2,
      slc2_sent_in           IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS 
   BEGIN        
   
      UPDATE stud_crse_year sc
         SET sc.slc1_status = UPPER (loan_ass_status_in),
             sc.slc2_status = UPPER (loan_app_status_in),
             sc.slc1_sent = UPPER (slc1_sent_in),
             sc.slc2_sent = UPPER (slc2_sent_in),            
             sc.last_updated_by = UPPER (employee_in),
             sc.last_updated_on = SYSDATE
       WHERE sc.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setslc;

   PROCEDURE getslcfeeloan (
      stud_crse_year_id_in   IN              VARCHAR2,
      stud_session_id_in     IN              VARCHAR2,
      slc_ref_num            OUT NOCOPY      VARCHAR2,
      fee_loan_ass_sent_date OUT NOCOPY      VARCHAR2,
      fee_loan_ass_sent      OUT NOCOPY      VARCHAR2,
      fee_loan_status        OUT NOCOPY      VARCHAR2,
      fee_loan_app_sent_date OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT s.scottish_cand AS slc_ref_num,
             TO_CHAR (ss.slc1_fl_sent_date, 'dd/MM/yyyy') AS fee_loan_ass_sent_date,
             ss.slc1_fl_sent AS fee_loan_ass_sent,
             f.status AS fee_loan_status,
             TO_CHAR (MAX(f.slc2_file_date), 'dd/MM/yyyy') AS fee_loan_app_sent_date
             
        INTO slc_ref_num,
             fee_loan_ass_sent_date,
             fee_loan_ass_sent,
             fee_loan_status,
             fee_loan_app_sent_date
        FROM stud_session ss, stud s, fee_loan_transaction f
       WHERE ss.stud_ref_no = s.stud_ref_no
        AND f.stud_crse_year_id = stud_crse_year_id_in
        AND ss.stud_session_id = stud_session_id_in
        AND f.slc2_file_date = (SELECT MAX(ft.slc2_file_date) FROM fee_loan_transaction ft 
                                WHERE ft.stud_crse_year_id = stud_crse_year_id_in)
                                
        GROUP BY s.scottish_cand,ss.slc1_fl_sent_date,ss.slc1_fl_sent,f.status;
        
        IF fee_loan_status <> 'S'
        THEN
            SELECT TO_CHAR( MAX(ft.slc2_file_date), 'dd/MM/yyyy')  INTO fee_loan_app_sent_date
              FROM fee_loan_transaction ft 
             WHERE ft.stud_crse_year_id = stud_crse_year_id_in
               AND ft.status = 'S';
        END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getslcfeeloan;
   
      PROCEDURE setslcfeeloan (
      stud_crse_year_id_in   IN              VARCHAR2,
      fee_loan_status_in     IN              VARCHAR2,
      employee_in            IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN        
      
      UPDATE fee_loan_transaction f
         SET f.status = UPPER (fee_loan_status_in),
             f.status_changed_date = SYSDATE,
             f.last_updated_by = UPPER (employee_in),
             f.last_updated_on = SYSDATE

       WHERE f.stud_crse_year_id = stud_crse_year_id_in
         AND f.status = 'E';
       
   

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setslcfeeloan;

END pk_steps_ui_stud_loan;
/