CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_dsa
AS
/******************************************************************************
   NAME:       pk_steps_ui_DSA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        13/10/2009     ABIRAMI CHIDAMBARAM   Code Population
******************************************************************************/
   PROCEDURE insertdefaultdsaapplication (
      stud_ref_no_in          IN              VARCHAR2,
      session_code_in         IN              VARCHAR2,
      last_updated_by_in      IN              VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2,
      row_count               OUT             NUMBER,
      dsaapplication_id_out   OUT             VARCHAR2
   )
   IS
      temp_pkey   NUMBER (10);
   BEGIN
      INSERT INTO dsa_application
                  (ID, stud_ref_no,
                   session_code, last_updated_by, last_updated_on
                  )
           VALUES (dsa_application_id_seq.NEXTVAL, stud_ref_no_in,
                   session_code_in, UPPER (last_updated_by_in), SYSDATE
                  );

      SELECT dsa_application.ID
        INTO temp_pkey
        FROM dsa_application
       WHERE stud_ref_no = stud_ref_no_in AND session_code = session_code_in;

      row_count := SQL%ROWCOUNT;
      dsaapplication_id_out := temp_pkey;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         row_count := 0;
   END insertdefaultdsaapplication;

   PROCEDURE getpersonaldetails (
      stud_ref_no_in    IN              NUMBER,
      session_code_in   IN              NUMBER,
      io_cursor         IN OUT          personaldetails_cursor,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   )
   IS
      pd_cursor   personaldetails_cursor;
   BEGIN
      OPEN pd_cursor FOR
         SELECT da.ID AS id_out,
                da.disability_type_id AS disability_type_id_out,
                da.date_application_received
                                            AS date_application_received_out,
                da.priority_app AS priortiy_app_out,
                da.referred_flag AS referred_flag_out,
                da.date_referred_access_centre AS date_ref_access_centre_out,
                da.dsa_referral_reason_id AS dsa_referral_reason_id_out,
                da.assessment_centre_id AS assessment_centre_id_out,
                da.rejected AS rejected_out,
                da.dsa_rejection_reason_id AS dsa_rejection_reason_id_out,
                da.consent_ticked AS consent_ticked_out,
                da.other_information AS other_information_out,
                da.dsa_student_type_id AS dsa_student_type_id_out,
                da.part_time_course AS part_time_course_out,
                da.needs_assessor AS needs_assessor_out,
                da.date_assess_rep_received AS date_assess_rep_received_out,
                da.date_assess_rep_processed
                                            AS date_assess_rep_processed_out,
                da.assessor_hourly_rate AS assessor_hourly_rate_out,
                da.processing_days AS processing_days_out,
                da.assess_fee_amount AS assess_fee_amount_out,
                da.more_info_req AS more_info_req_out,
                da.exceptional_case AS exceptional_case_out
           FROM dsa_application da
          WHERE da.stud_ref_no = stud_ref_no_in
            AND da.session_code = session_code_in;

      io_cursor := pd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getpersonaldetails;

   PROCEDURE setpersonaldetails (
      dsa_app_id_in                  IN       VARCHAR2,
      disability_type_id_in          IN       VARCHAR2,
      date_application_received_in   IN       DATE,
      priortiy_app_in                IN       VARCHAR2,
      referred_flag_in               IN       VARCHAR2,
      date_ref_access_centre_in      IN       DATE,
      dsa_referral_reason_id_in      IN       VARCHAR2,
      assessment_centre_id_in        IN       VARCHAR2,
      rejected_in                    IN       VARCHAR2,
      dsa_rejection_reason_id_in     IN       VARCHAR2,
      consent_ticked_in              IN       VARCHAR2,
      other_information_in           IN       VARCHAR2,
      dsa_student_type_id_in         IN       VARCHAR2,
      part_time_course_in            IN       VARCHAR2,
      needs_assessor_in              IN       VARCHAR2,
      date_assess_rep_received_in    IN       DATE,
      date_assess_rep_processed_in   IN       DATE,
      assessor_hourly_rate_in        IN       VARCHAR2,
      processing_days_in             IN       VARCHAR2,
      assess_fee_amount_in           IN       VARCHAR2,
      more_info_req_in               IN       VARCHAR2,
      exceptional_case_in            IN       VARCHAR2,
      user_in                        IN       VARCHAR2,
      error_boolean                  OUT      VARCHAR2,
      ERROR_TEXT                     OUT      VARCHAR2,
      row_count_da                   OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE dsa_application
         SET disability_type_id = disability_type_id_in,
             date_application_received = date_application_received_in,
             priority_app = UPPER (priortiy_app_in),
             referred_flag = UPPER (referred_flag_in),
             date_referred_access_centre = date_ref_access_centre_in,
             dsa_referral_reason_id = dsa_referral_reason_id_in,
             assessment_centre_id = assessment_centre_id_in,
             rejected = UPPER (rejected_in),
             dsa_rejection_reason_id = dsa_rejection_reason_id_in,
             consent_ticked = UPPER (consent_ticked_in),
             other_information = UPPER (other_information_in),
             dsa_student_type_id = dsa_student_type_id_in,
             part_time_course = part_time_course_in,
             needs_assessor = UPPER (needs_assessor_in),
             date_assess_rep_received = date_assess_rep_received_in,
             date_assess_rep_processed = date_assess_rep_processed_in,
             assessor_hourly_rate = assessor_hourly_rate_in,
             processing_days = processing_days_in,
             assess_fee_amount = assess_fee_amount_in,
             more_info_req = UPPER (more_info_req_in),
             exceptional_case = UPPER (exceptional_case_in),
             last_updated_by = UPPER (user_in),
             last_updated_on = SYSDATE
       WHERE ID = dsa_app_id_in;

      row_count_da := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_da := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setpersonaldetails;

   PROCEDURE getallowancesummary (
      stud_crse_year_id_in   IN              NUMBER,
      io_cursor              IN OUT          allowancesummary_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      as_cursor   allowancesummary_cursor;
   BEGIN
      OPEN as_cursor FOR
         SELECT 1 TYPE,
                NVL ((SUM (DECODE (dc.type_id, 1, da.max_amount, 0))),
                     0
                    ) AS max_amount,
                NVL ((SUM (DECODE (dc.type_id, 1, da.paid_amount, 0))),
                     0
                    ) AS paid_amount,
                NVL ((SUM (DECODE (dc.type_id, 1, da.available_amount, 0))),
                     0
                    ) AS available_amount
           FROM dsa_allowance da, dsa_category dc
          WHERE da.stud_session_id IN (
                   SELECT ss.stud_session_id
                     FROM stud_session ss
                    WHERE ss.stud_ref_no =
                             (SELECT scy.stud_ref_no
                                FROM stud_crse_year scy
                               WHERE scy.stud_crse_year_id =
                                                         stud_crse_year_id_in))
            AND da.dsa_category_id = dc.dsa_category_id(+)
         UNION
         SELECT 2,
                NVL ((SUM (DECODE (dc.type_id, 2, da.max_amount, 0))),
                     0
                    ) AS max_amount,
                NVL ((SUM (DECODE (dc.type_id, 2, da.paid_amount, 0))),
                     0
                    ) AS paid_amount,
                NVL ((SUM (DECODE (dc.type_id, 2, da.available_amount, 0))),
                     0
                    ) AS available_amount
           FROM dsa_allowance da, dsa_category dc
          WHERE da.stud_crse_year_id = stud_crse_year_id_in
            AND da.dsa_category_id = dc.dsa_category_id(+)
         UNION
         SELECT 3,
                NVL ((SUM (DECODE (dc.type_id, 3, da.max_amount, 0))),
                     0
                    ) AS max_amount,
                NVL ((SUM (DECODE (dc.type_id, 3, da.paid_amount, 0))),
                     0
                    ) AS paid_amount,
                NVL ((SUM (DECODE (dc.type_id, 3, da.available_amount, 0))),
                     0
                    ) AS available_amount
           FROM dsa_allowance da, dsa_category dc
          WHERE da.stud_crse_year_id = stud_crse_year_id_in
            AND da.dsa_category_id = dc.dsa_category_id(+)
         UNION
         SELECT 4,
                NVL ((SUM (DECODE (dc.type_id, 4, da.max_amount, 0))),
                     0
                    ) AS max_amount,
                NVL ((SUM (DECODE (dc.type_id, 4, da.paid_amount, 0))),
                     0
                    ) AS paid_amount,
                NVL ((SUM (DECODE (dc.type_id, 4, da.available_amount, 0))),
                     0
                    ) AS available_amount
           FROM dsa_allowance da, dsa_category dc
          WHERE da.stud_crse_year_id = stud_crse_year_id_in
            AND da.dsa_category_id = dc.dsa_category_id(+);

      io_cursor := as_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getallowancesummary;

   PROCEDURE getallowancedetails (
      stud_crse_year_id_in   IN              NUMBER,
      io_cursor              IN OUT          allowancedetails_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      ad_cursor   allowancedetails_cursor;
   BEGIN
      OPEN ad_cursor FOR
         SELECT   da.ID AS allowance_id_out,
                  da.dsa_category_id AS category_id_out,
                  da.max_amount AS max_amt_out,
                  da.paid_amount AS paid_amt_out,
                  da.available_amount AS available_amt_out
             FROM dsa_allowance da
            WHERE da.stud_crse_year_id = stud_crse_year_id_in
               OR (    da.dsa_category_id IN (
                          SELECT dc.dsa_category_id
                            FROM dsa_category dc, dsa_type dt
                           WHERE dc.type_id = dt.dsa_type_id
                             AND dt.code = 'LRG')
                   AND da.stud_session_id IN (
                          SELECT ss.stud_session_id
                            FROM stud_session ss
                           WHERE ss.stud_ref_no =
                                    (SELECT scy.stud_ref_no
                                       FROM stud_crse_year scy
                                      WHERE scy.stud_crse_year_id =
                                                          stud_crse_year_id_in))
                  )
         ORDER BY da.dsa_category_id;

      io_cursor := ad_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getallowancedetails;

   PROCEDURE insertallowancedetails (
      application_id_in      IN       NUMBER,
      stud_session_id_in     IN       NUMBER,
      stud_crse_year_id_in   IN       NUMBER,
      category_id_in         IN       NUMBER,
      max_amt_in             IN       NUMBER,
      overridetype_in        IN       VARCHAR2,
      overridedsa_in         IN       VARCHAR2,
      user_in                IN       VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2,
      row_count              OUT      VARCHAR2
   )
   AS
   BEGIN
      INSERT INTO dsa_allowance dsaa
                  (dsaa.ID, dsaa.dsa_application_id,
                   dsaa.stud_session_id, dsaa.stud_crse_year_id,
                   dsaa.dsa_category_id, dsaa.max_amount, dsaa.paid_amount,
                   dsaa.available_amount, dsaa.last_updated_by,
                   dsaa.last_updated_on
                  )
           VALUES (dsa_allowance_id_seq.NEXTVAL, application_id_in,
                   stud_session_id_in, stud_crse_year_id_in,
                   category_id_in, max_amt_in, '0',
                   max_amt_in, UPPER (user_in),
                   SYSDATE
                  );

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertallowancedetails;

   PROCEDURE countduplicatecategories (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   countduplicates_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   AS
      cd_cursor   countduplicates_cursor;
   BEGIN
      OPEN cd_cursor FOR
         SELECT   da.dsa_category_id AS category_id,
                  COUNT (da.dsa_category_id) AS countcat
             FROM dsa_allowance da
            WHERE da.stud_crse_year_id = stud_crse_year_id_in
               OR (    da.dsa_category_id IN (
                          SELECT dc.dsa_category_id
                            FROM dsa_category dc, dsa_type dt
                           WHERE dc.type_id = dt.dsa_type_id
                             AND dt.code = 'LRG')
                   AND da.stud_session_id IN (
                          SELECT ss.stud_session_id
                            FROM stud_session ss
                           WHERE ss.stud_ref_no =
                                    (SELECT scy.stud_ref_no
                                       FROM stud_crse_year scy
                                      WHERE scy.stud_crse_year_id =
                                                          stud_crse_year_id_in))
                  )
         GROUP BY da.dsa_category_id;

      io_cursor := cd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END countduplicatecategories;

   PROCEDURE showallowancerecord (
      stud_crse_year_id_in   IN              NUMBER,
      type_id_in             IN              VARCHAR2,
      io_cursor              IN OUT          allowancerecord_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      ar_cursor      allowancerecord_cursor;
      temp_type_id   NUMBER;
   BEGIN
      SELECT dt.dsa_type_id
        INTO temp_type_id
        FROM dsa_type dt
       WHERE UPPER (dt.TYPE) = UPPER (type_id_in);

      IF temp_type_id = 1
      THEN
         OPEN ar_cursor FOR
            SELECT da.ID AS id_out, da.dsa_category_id AS category_id_out,
                   da.max_amount AS max_amount_out
              FROM dsa_allowance da, dsa_category dc
             WHERE (    da.dsa_category_id IN (
                           SELECT dc.dsa_category_id
                             FROM dsa_category dc, dsa_type dt
                            WHERE dc.type_id = dt.dsa_type_id
                              AND dt.code = 'LRG')
                    AND da.stud_session_id IN (
                           SELECT ss.stud_session_id
                             FROM stud_session ss
                            WHERE ss.stud_ref_no =
                                     (SELECT scy.stud_ref_no
                                        FROM stud_crse_year scy
                                       WHERE scy.stud_crse_year_id =
                                                          stud_crse_year_id_in))
                   )
               AND da.dsa_category_id = dc.dsa_category_id;
      ELSE
         OPEN ar_cursor FOR
            SELECT da.ID AS id_out, da.dsa_category_id AS category_id_out,
                   da.max_amount AS max_amount_out
              FROM dsa_allowance da, dsa_category dc
             WHERE da.dsa_category_id = dc.dsa_category_id
               AND da.stud_crse_year_id = stud_crse_year_id_in
               AND dc.type_id = temp_type_id;
      END IF;

      io_cursor := ar_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END showallowancerecord;

   PROCEDURE setallowancedetails (
      dsa_all_id_in   IN       NUMBER,
      category_in     IN       VARCHAR2,
      max_amt_in      IN       NUMBER,
      user_in         IN       VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2,
      row_count_da    OUT      VARCHAR2
   )
   IS
      temp_cat_id   NUMBER;
   BEGIN
      SELECT dc.dsa_category_id
        INTO temp_cat_id
        FROM dsa_category dc
       WHERE UPPER (dc.description) = UPPER (category_in);

      UPDATE dsa_allowance
         SET dsa_category_id = temp_cat_id,
             max_amount = max_amt_in,
             paid_amount = '0',
             available_amount = max_amt_in,
             last_updated_by = UPPER (user_in),
             last_updated_on = SYSDATE
       WHERE ID = dsa_all_id_in;

      row_count_da := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_da := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setallowancedetails;

   PROCEDURE deleteallowancedetails (
      id_in           IN              NUMBER,
      employee_in     IN              VARCHAR2,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2,
      row_count       OUT             VARCHAR2
   )
   IS
   BEGIN
      UPDATE dsa_allowance da
         SET da.last_updated_by = UPPER (employee_in)
         WHERE da.ID = id_in;

      DELETE FROM dsa_allowance da
            WHERE da.ID = id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deleteallowancedetails;

   PROCEDURE getstudnominees (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          nomineesselected_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      nom_cursor   nomineesselected_cursor;
   BEGIN
      OPEN nom_cursor FOR
         SELECT   nom.nominee_id, nom.forename, nom.surname,
                  nom.company_name, nom.house_no_name, nom.addr_l1,
                  nom.addr_l2, nom.addr_l3, nom.addr_l4, nom.post_code,
                  nom.telephone_no, nom.account_no, nom.sort_code,
                  nom.payment_method, nom.last_updated_by,
                  TO_CHAR
                         (TO_DATE (nom.last_updated_on,
                                   'DD-MM-YYYY HH12:MI:SS'
                                  )
                         ) AS last_updated_on
             FROM nominee nom, stud_nominee s
            WHERE s.stud_ref_no = stud_ref_no_in
              AND s.nominee_id = nom.nominee_id
         ORDER BY nom.nominee_id DESC;

      error_boolean := 'false';
      io_cursor := nom_cursor;
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudnominees;

   PROCEDURE insertstudnominee (
      stud_ref_no_in       IN              VARCHAR2,
      nominee_id_in        IN              VARCHAR2,
      last_updated_by_in   IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      row_count            OUT             NUMBER
   )
   IS
   BEGIN
      INSERT INTO stud_nominee
                  (stud_ref_no, nominee_id,
                   last_updated_by, last_updated_on
                  )
           VALUES (stud_ref_no_in, nominee_id_in,
                   UPPER (last_updated_by_in), SYSDATE
                  );

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         row_count := 0;
   END insertstudnominee;

   PROCEDURE getpaymentdetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          paymentdetails_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      pd_cursor         paymentdetails_cursor;
      temp_payee_type   VARCHAR2 (10);
   BEGIN
      OPEN pd_cursor FOR
         SELECT dsap.ID AS ID, dsap.award_instalment_id,
                dsap.dsa_allowance_id,
                DECODE (dsap.payee_type,
                        'S', 'Student',
                        'N', 'Nominee'
                       ) AS payee_type,
                dsap.payee_id, dsap.amount, dsap.payment_method_id,
                dsap.batch_date, dsap.process_date,
                dsap.dsa_payment_status_id, dsap.payment_type,
                dsap.batch_ref, dsap.re_issue_flag, dsap.amount_rate,
                dsap.REFERENCE, dsap.period_start_date, dsap.period_end_date,
                dsap.receipt_required, dsap.receipt_received,
                dsap.receipt_amount, dsap.invoice_ref, dsap.notes,
                dsap.last_updated_by, dsap.last_updated_on
           FROM dsa_payment dsap, dsa_allowance dsaa
          WHERE dsap.dsa_allowance_id = dsaa.ID
            AND dsaa.stud_crse_year_id = stud_crse_year_id_in;

      io_cursor := pd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getpaymentdetails;

   PROCEDURE getallowancepayments (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   allowancepayment_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   AS
      ap_cursor   allowancepayment_cursor;
   BEGIN
      OPEN ap_cursor FOR
         SELECT da.ID AS id_out, dt.TYPE AS type_out,
                dt.dsa_type_id AS type_id_out,
                da.dsa_category_id AS category_id_out,
                dc.description AS category_desc_out,
                da.payment_due_date AS payment_due_date_out,
                da.travel_amount AS travel_amount_out
           FROM dsa_allowance da, dsa_category dc, dsa_type dt
          WHERE dc.dsa_category_id = da.dsa_category_id
            AND dt.dsa_type_id = dc.type_id
            AND da.stud_crse_year_id = stud_crse_year_id_in;

      io_cursor := ap_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getallowancepayments;

   PROCEDURE processreceipt (
      stud_award_type_in               IN       VARCHAR2,
      stud_award_type_description_in   IN       VARCHAR2,
      stud_crse_year_id_in             IN       VARCHAR2,
      dsa_allowance_id_in              IN       VARCHAR2,
      nominee_id_in                    IN       VARCHAR2,
      payee_type_in                    IN       VARCHAR2,
      payee_id_in                      IN       VARCHAR2,
      amount_in                        IN       VARCHAR2,
      reference_in                     IN       VARCHAR2,
      amount_rate_in                   IN       VARCHAR2,
      period_in                        IN       VARCHAR2,
      travel_element_in                IN       VARCHAR2,
      due_date_in                      IN       DATE,
      invoice_ref_in                   IN       VARCHAR2,
      notes_in                         IN       VARCHAR2,
      receipt_required_in              IN       VARCHAR2,
      receipt_received_in              IN       VARCHAR2,
      receipt_amount_in                IN       VARCHAR2,
      period_start_date_in             IN       DATE,
      period_end_date_in               IN       DATE,
      payment_type_in                  IN       VARCHAR2,
      employee_in                      IN       VARCHAR2,
      error_boolean                    OUT      VARCHAR2,
      ERROR_TEXT                       OUT      VARCHAR2
   )
   AS
      temp_stud_ref_no           VARCHAR2 (20);
      temp_stud_session          VARCHAR2 (20);
      temp_inst_code             VARCHAR2 (20);
      temp_crse_id               VARCHAR2 (20);
      temp_crse_year_no          VARCHAR2 (20);
      temp_current_session       VARCHAR2 (5);
      temp_payment_method        VARCHAR2 (1);
      temp_dsa_payment_method    NUMBER (10);
      temp_payment_addr          VARCHAR2 (1);
      temp_campus_id             VARCHAR2 (1);
      temp_fees_campus           VARCHAR2 (10);
      temp_award_id              NUMBER (10);
      temp_award_instalment_id   NUMBER (10);
   BEGIN
      ERROR_TEXT := 'Getting current session ';

      SELECT cval
        INTO temp_current_session
        FROM config_data
       WHERE item_name = 'CURRENT_SESSION';

      ERROR_TEXT := 'Getting stud session and stud ref no ';

      /*
      *    Get supporting information for inserts
      */
      SELECT scy.stud_session_id, scy.stud_ref_no
        INTO temp_stud_session, temp_stud_ref_no
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      ERROR_TEXT := 'Getting course details ';

      SELECT scy.inst_code, scy.crse_id, scy.crse_year_no
        INTO temp_inst_code, temp_crse_id, temp_crse_year_no
        FROM stud_crse_year scy
       WHERE scy.stud_session_id = temp_stud_session
         AND scy.latest_crse_ind = 'Y';

      IF payee_type_in = 'S'
      THEN
         ERROR_TEXT := 'Getting payment method for student ';

         SELECT s.payment_method
           INTO temp_payment_method
           FROM stud s
          WHERE s.stud_ref_no = temp_stud_ref_no;

         IF temp_payment_method = 'B'
         THEN
            temp_payment_addr := 'B';
         ELSE
            temp_payment_addr := 'H';
         END IF;
      ELSE
         ERROR_TEXT := 'Getting payment method for nominee ';

         SELECT pm.legacy_code
           INTO temp_payment_method
           FROM nominee n, payment_method pm
          WHERE n.nominee_id = nominee_id_in
            AND n.payment_method = pm.payment_method_id;

         IF temp_payment_method = 'B'
         THEN
            temp_payment_addr := 'B';
         ELSE
            temp_payment_addr := 'N';
         END IF;
      END IF;

      ERROR_TEXT := 'Determining if fees campus relevant ';

      IF temp_payment_method = 'C'
      THEN
         temp_campus_id := temp_fees_campus;
      ELSE
         temp_campus_id := NULL;
      END IF;

      ERROR_TEXT := ' Getting payment method ';

      SELECT pm.payment_method_id
        INTO temp_dsa_payment_method
        FROM payment_method pm
       WHERE pm.legacy_code = temp_payment_method;

      ERROR_TEXT := 'Getting next award id from sequence ';

      SELECT sgas.aw_award_id_seq.NEXTVAL,
             sgas.award_instalment_id_seq.NEXTVAL
        INTO temp_award_id,
             temp_award_instalment_id
        FROM DUAL;

      /*
       *    Depending on receipt being money coming in or going out, branch and update
       *     dsa_allowance records accordingly
       */
      IF payment_type_in = 'PAYMENT'
      THEN
         ERROR_TEXT := 'Inserting award record ';

         SELECT sgas.aw_award_id_seq.NEXTVAL
           INTO temp_award_id
           FROM DUAL;

         /*
          *    Insert Award record
          */
         INSERT INTO award a
                     (a.award_id, a.stud_crse_year_id, a.inst_code,
                      a.crse_id, a.award_src, a.dsa_allowance_id,
                      a.non_tuition_fee_id, a.tuition_fee_type_code,
                      a.stud_award_type, a.award_type_descript,
                      a.stud_ref_no, a.session_code,
                      a.crse_year_no, a.assessment_date,
                      a.assess_reason_code, a.amount, a.net_amount,
                      a.contrib_amount, a.recovered_amount,
                      a.overpayment_amount, a.auto_travel_amount,
                      a.trav_amount, a.hold, a.overpaid_contrib, a.zero_da,
                      a.unclaimed_loan, a.online_award_payment_hold_flag,
                      a.paid_as_claimed_fg, a.travel_award_type,
                      a.unclaimed_fee_loan
                     )
              VALUES (temp_award_id, stud_crse_year_id_in, temp_inst_code,
                      temp_crse_id, 'A', dsa_allowance_id_in,
                      NULL, NULL,
                      stud_award_type_in, stud_award_type_description_in,
                      temp_stud_ref_no, temp_current_session,
                      temp_crse_year_no, SYSDATE,
                      'M', amount_in, amount_in,
                      0, 0,
                      0, NULL,
                      NULL, 'N', NULL, NULL,
                      NULL, NULL,
                      NULL, NULL,
                      NULL
                     );

         ERROR_TEXT := 'Inserting award instalment record ';

         /*
          *    Insert Award Instalment record
          */
         INSERT INTO award_instalment ai
                     (ai.award_id, ai.payment_due_date, ai.install_type,
                      ai.assessment_date, ai.amount, ai.recovered_amount,
                      ai.contrib_amount, ai.net_amount, ai.method, ai.payee,
                      ai.payment_addr, ai.campus_id, ai.payment_status,
                      ai.batch_ref, ai.trav_amount, ai.net_paid_contrib,
                      ai.payment_id, ai.returned, ai.recalc, ai.reissue,
                      ai.debt_returned, ai.prev_returned, ai.prev_reissue,
                      ai.payee_reference
                     )
              VALUES (temp_award_id, due_date_in, 'MN',
                      SYSDATE, amount_in, 0,
                      0, amount_in, temp_payment_method, payee_type_in,
                      temp_payment_addr, NULL, 'U',
                      NULL, NULL, NULL,
                      NULL, 'N', 'N', 'N',
                      'N', NULL, NULL,
                      UPPER (reference_in)
                     );

         SELECT sgas.award_instalment_id_seq.CURRVAL
           INTO temp_award_instalment_id
           FROM DUAL;

         ERROR_TEXT := 'Updating dsa allowance ';

         /*
          *    Update Allowance record to reflect new payment made
          */
         UPDATE dsa_allowance da
            SET da.paid_amount = da.paid_amount + amount_in,
                da.available_amount = da.available_amount - amount_in,
                da.last_updated_by = UPPER (employee_in),
                da.last_updated_on = SYSDATE
          WHERE da.ID = dsa_allowance_id_in;
      ELSE
         ERROR_TEXT := 'Updating dsa allowance ';

         /*
          *    Update Allowance record to reflect new payment received
          */
         UPDATE dsa_allowance da
            SET da.paid_amount = da.paid_amount - amount_in,
                da.available_amount = da.available_amount + amount_in,
                da.last_updated_by = UPPER (employee_in),
                da.last_updated_on = SYSDATE
          WHERE da.ID = dsa_allowance_id_in;
      END IF;

      ERROR_TEXT := 'Inserting DSA payment ';

      /*
       *    Insert DSA Payment record
       */
      INSERT INTO dsa_payment dp
                  (dp.award_instalment_id, dp.dsa_allowance_id,
                   dp.payee_id, dp.payment_method_id,
                   dp.dsa_payment_status_id, dp.amount, dp.amount_rate,
                   dp.batch_date, dp.invoice_ref, dp.notes,
                   dp.payee_type, dp.payment_type, dp.period_start_date,
                   dp.period_end_date, dp.process_date, dp.re_issue_flag,
                   dp.receipt_amount, dp.receipt_required,
                   dp.receipt_received, dp.REFERENCE,
                   dp.last_updated_by, dp.last_updated_on
                  )
           VALUES (temp_award_instalment_id, dsa_allowance_id_in,
                   payee_id_in, temp_dsa_payment_method,
                   1, amount_in, amount_rate_in,
                   NULL, UPPER (invoice_ref_in), UPPER (notes_in),
                   payee_type_in, payment_type_in, period_start_date_in,
                   period_end_date_in, due_date_in, 'N',
                   receipt_amount_in, receipt_required_in,
                   receipt_received_in, UPPER (reference_in),
                   UPPER (employee_in), SYSDATE
                  );

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         ROLLBACK;
   END processreceipt;

   PROCEDURE getstuddsaotherlimits (
      stud_award_type_scheme_in   IN              VARCHAR2,
      session_code_in             IN              VARCHAR2,
      disab_basic_max_out         OUT NOCOPY      VARCHAR2,
      disab_equip_max_out         OUT NOCOPY      VARCHAR2,
      disab_non_med_max_out       OUT NOCOPY      VARCHAR2,
      disab_trav_max_out          OUT NOCOPY      VARCHAR2,
      error_boolean               OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT a.disab_basic_max, a.disab_equip_max,
             a.disab_non_med_max, b.disab_trav_max
        INTO disab_basic_max_out, disab_equip_max_out,
             disab_non_med_max_out, disab_trav_max_out
        FROM (SELECT sr.disab_basic_max, sr.disab_equip_max,
                     sr.disab_non_med_max
                FROM stud_award_type sat, stud_rate sr
               WHERE sat.stud_award_type_id = sr.stud_award_type_id
                 AND sat.scheme = stud_award_type_scheme_in
                 AND sr.session_code = session_code_in
                 AND sr.disab_trav_max = 0) a,
             (SELECT sr.disab_trav_max
                FROM stud_award_type sat, stud_rate sr
               WHERE sat.stud_award_type_id = sr.stud_award_type_id
                 AND sat.scheme = stud_award_type_scheme_in
                 AND sr.session_code = session_code_in
                 AND sr.disab_trav_max != 0) b;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstuddsaotherlimits;

   PROCEDURE removeallocatednominee (
      nom_id_in       IN       NUMBER,
      user_in         IN       VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
   BEGIN
      /*
       * REMOVE ALLOCATED NOMINEE DETAILS
       */
      UPDATE stud_nominee sn
         SET sn.last_updated_by = UPPER (user_in)
         WHERE sn.nominee_id = nom_id_in;

      DELETE FROM stud_nominee sn
            WHERE sn.nominee_id = nom_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END removeallocatednominee;

   PROCEDURE getparttimedetails (
      stud_crse_year_id_in   IN       VARCHAR2,
      dsa_stud_type_id_out   OUT      VARCHAR2,
      part_time_course_out   OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT da.dsa_student_type_id, da.part_time_course
        INTO dsa_stud_type_id_out, part_time_course_out
        FROM dsa_application da, stud_crse_year scy, stud_session ss
       WHERE da.stud_ref_no = ss.stud_ref_no
         AND da.session_code = ss.session_code
         AND scy.stud_session_id = ss.stud_session_id
         AND scy.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getparttimedetails;

   PROCEDURE isneedsassessreportrequired (
      stud_crse_year_id_in   IN       VARCHAR2,
      is_required_out        OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
      temp_count_dsa_app   NUMBER;
   BEGIN
      SELECT COUNT (da.ID)
        INTO temp_count_dsa_app
        FROM dsa_application da, stud_crse_year scy, stud_session ss
       WHERE da.stud_ref_no = ss.stud_ref_no
         AND da.session_code = ss.session_code
         AND da.date_assess_rep_received IS NOT NULL
         AND scy.stud_session_id = ss.stud_session_id
         AND scy.stud_crse_year_id = stud_crse_year_id_in;

      IF temp_count_dsa_app < 1
      THEN
         is_required_out := 'true';
      ELSE
         is_required_out := 'false';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END isneedsassessreportrequired;

 PROCEDURE haspaymentbeenmade(
      id_in                  IN       VARCHAR2,
      payment_made           OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
      paid_amount_value   NUMBER;
      payment_exists      NUMBER;
   BEGIN      
      
      SELECT dsa.paid_amount 
        INTO paid_amount_value
        FROM DSA_ALLOWANCE dsa
        WHERE dsa.id = id_in;
      
      SELECT count(*) 
        INTO payment_exists
        FROM DSA_PAYMENT dsp
        WHERE dsp.DSA_ALLOWANCE_ID = id_in;
      
      IF (paid_amount_value > 0 OR payment_exists > 0)
      THEN 
        payment_made := 'true';
      ELSE
        payment_made := 'false';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END haspaymentbeenmade;   
   
END pk_steps_ui_dsa;
/
