CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_award_report
IS
/******************************************************************************
   NAME:       pk_poc_award_report
   PURPOSE:

   REVISIONS:
   Ver        Date        Author            Description
   ---------  ----------  ---------------   ------------------------------------
   1.0        27/10/2011  A.Bowman          Created this package.
*********************************************************************************/
   PROCEDURE get_header_info (
      stud_crse_year_id_in          IN              VARCHAR2,
      date_out                      OUT NOCOPY      VARCHAR2,
      session_out                   OUT NOCOPY      VARCHAR2,
      student_out                   OUT NOCOPY      VARCHAR2,
      name_out                      OUT NOCOPY      VARCHAR2,
      inst_code_out                 OUT NOCOPY      VARCHAR2,
      inst_name_out                 OUT NOCOPY      VARCHAR2,
      course_code_out               OUT NOCOPY      VARCHAR2,
      course_name_out               OUT NOCOPY      VARCHAR2,
      course_year_out               OUT NOCOPY      VARCHAR2,
      scheme_out                    OUT NOCOPY      VARCHAR2,
      student_type_out              OUT NOCOPY      VARCHAR2,
      loan_given_out                OUT NOCOPY      VARCHAR2,
      fee_loan_given_out            OUT NOCOPY      VARCHAR2,
      max_loan_requested_out        OUT NOCOPY      VARCHAR2,
      loan_request_out              OUT NOCOPY      VARCHAR2,
      max_fee_loan_requested_out    OUT NOCOPY      VARCHAR2,
      fee_loan_request_amount_out   OUT NOCOPY      VARCHAR2,
      student_contribution_out      OUT NOCOPY      VARCHAR2,
      parental_contribution_out     OUT NOCOPY      VARCHAR2,
      spouse_contribution_out       OUT NOCOPY      VARCHAR2,
      total_used_contribution_out   OUT NOCOPY      VARCHAR2,
      residual_contribution_out     OUT NOCOPY      VARCHAR2,
      fee_entitlement_out           OUT NOCOPY      VARCHAR2,
      fee_type_out                  OUT NOCOPY      VARCHAR2,
      total_student_debt_out        OUT NOCOPY      VARCHAR2,
      active_student_debt_out       OUT NOCOPY      VARCHAR2,
      deferred_student_debt_out     OUT NOCOPY      VARCHAR2,
      total_nmsb_debt_out           OUT NOCOPY      VARCHAR2,
      active_nmsb_debt_out          OUT NOCOPY      VARCHAR2,
      deferred_nmsb_debt_out        OUT NOCOPY      VARCHAR2,
      error_boolean                 OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                    OUT NOCOPY      VARCHAR2
   )
   IS
      tutition_fee   NUMBER (3);
   BEGIN
      SELECT SYSDATE "Date",
             stcy.session_code || '/' || (stcy.session_code + 1) "Session",
             stcy.stud_ref_no "Student",
             st.forenames || ' ' || st.initials || ' ' || st.surname "Name",
             stcy.inst_code "Inst Code", stcy.inst_name "Inst Name",
             stcy.crse_code "Course Code", stcy.crse_name "Course Name",
             stcy.crse_year_no "Course Year", stcy.scheme_type "Scheme",
             stcy.dearing "Student Type", stcy.loan_given "Loan Given",
             stcy.fee_loan_given "Fee Loan Given",
             ss.max_loan_requested "Max Loan Requested",
             NVL (ss.loan_request, 0) "Loan Request",
             ss.max_fee_loan_requested "Max Fee Loan Requested",
             NVL (ss.fee_loan_request_amount, 0) "Fee Loan Requested",
             stcy.stud_cont "Student Contribution",
             stcy.parent_cont "Parental Contribution",
             stcy.spouse_cont "Spouse Contribution",
               NVL (stcy.stud_cont, 0)
             + NVL (stcy.parent_cont, 0)
             + NVL (stcy.spouse_cont, 0)
             - NVL (stcy.resid_par_cont, 0) "Total Used Contribution",
             NVL (stcy.resid_par_cont, 0) "Residual Contribution"
        INTO date_out,
             session_out,
             student_out,
             name_out,
             inst_code_out, inst_name_out,
             course_code_out, course_name_out,
             course_year_out, scheme_out,
             student_type_out, loan_given_out,
             fee_loan_given_out,
             max_loan_requested_out,
             loan_request_out,
             max_fee_loan_requested_out,
             fee_loan_request_amount_out,
             student_contribution_out,
             parental_contribution_out,
             spouse_contribution_out,
             total_used_contribution_out,
             residual_contribution_out
        FROM stud_crse_year stcy, stud st, stud_session ss
       WHERE stcy.stud_crse_year_id = stud_crse_year_id_in
         AND stcy.stud_ref_no = st.stud_ref_no
         AND stcy.stud_session_id = ss.stud_session_id;

      SELECT COUNT (*)
        INTO tutition_fee
        FROM award aw
       WHERE aw.stud_crse_year_id = stud_crse_year_id_in
             AND aw.award_src = 'T';

      IF tutition_fee > 0
      THEN
         SELECT aw.amount "Fee Entitlement",
                CASE
                   WHEN aw.stud_award_type = 'TFEL'
                      THEN 'Fee Loan'
                   ELSE 'Tuition Fee'
                END "Fee Type"
           INTO fee_entitlement_out,
                fee_type_out
           FROM award aw
          WHERE aw.stud_crse_year_id = stud_crse_year_id_in
            AND aw.award_src = 'T';
      ELSE
         fee_entitlement_out := 0;
         fee_type_out := 'None';
      END IF;

      SELECT NVL (st.overpayment + st.def_overpayment, 0)
                                                         "Total Student Debt",
             NVL (st.overpayment, 0) "Active Student Debt",
             NVL (st.def_overpayment, 0) "Deferred Student Debt",
             NVL (st.snb_overpayment + st.snb_def_overpayment, 0)
                                                            "Total NMSB Debt",
             NVL (st.snb_overpayment, 0) "Active NMSB Debt",
             NVL (st.snb_def_overpayment, 0) "Deferred NMSB Debt"
        INTO total_student_debt_out,
             active_student_debt_out,
             deferred_student_debt_out,
             total_nmsb_debt_out,
             active_nmsb_debt_out,
             deferred_nmsb_debt_out
        FROM stud st, stud_crse_year stcy
       WHERE st.stud_ref_no = stcy.stud_ref_no
         AND stcy.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_header_info;

   PROCEDURE get_assessed_awards (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          assessed_awards_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      aw_cursor   assessed_awards_cursor;
   BEGIN
      OPEN aw_cursor FOR
         SELECT aw.award_id, aw.stud_award_type, stat.award_type_descript,
                aw.net_amount, aw.amount, aw.contrib_amount,
                aw.recovered_amount, aw.overpaid_contrib
           FROM award aw, stud_award_type stat
          WHERE aw.stud_crse_year_id = stud_crse_year_id_in
            AND aw.stud_award_type = stat.stud_award_type;

      io_cursor := aw_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_assessed_awards;

   PROCEDURE get_assessed_instalments (
      award_id_in                IN              VARCHAR2,
      io_cursor                  IN OUT          assessed_instalments_cursor,
      error_boolean              OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY      VARCHAR2
   )
   IS
      awi_cursor           assessed_instalments_cursor;
   BEGIN
      OPEN awi_cursor FOR
         SELECT   distinct(awi.award_instalment_id), awi.payment_due_date, awi.amount, 
                  awi.contrib_amount, awi.recovered_amount, awi.adhoc_type,
                  CASE
                     WHEN aw.award_src = 'T'
                        THEN awi.unclaimed_fee_loan
                     ELSE awi.unclaimed_loan
                  END "UNCLAIMED",
                  awi.net_amount, awi.payment_addr, awi.payment_status,
                  pi.payment_date,' ' overpayment_amount, awi.returned
             FROM award_instalment awi, payment_instalment pi, award aw
            WHERE awi.award_id = award_id_in
              AND awi.award_instalment_id = pi.award_instalment_id(+)
              AND awi.award_id = aw.award_id
         ORDER BY awi.payment_due_date;

      io_cursor := awi_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_assessed_instalments;

   PROCEDURE get_assessed_instalment_totals (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          assessed_instls_tots_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      totals_cursor   assessed_instls_tots_cursor;
   BEGIN
   
      OPEN totals_cursor FOR
        SELECT DISTINCT  aw.award_id award_id,
                         aw.award_src award_source,
                         aw.overpayment_amount overpayment,
                         aw.amount amountTotal,
                         '' as adhoc_type,
                         aw.net_amount netAmountTotal,
                         aw.contrib_amount contribTotal,
                         aw.recovered_amount recTotal,    
                         CASE
                             WHEN aw.award_src = 'T'
                             THEN  aw.unclaimed_fee_loan
                             ELSE  aw.unclaimed_loan 
                         END "UNCLAIMED"                      
                    FROM award aw, award_instalment awi
                   WHERE aw.stud_crse_year_id = stud_crse_year_id_in                     
                     AND aw.award_id = awi.award_id
                     ORDER BY award_id;                                      
         
      io_cursor := totals_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_assessed_instalment_totals;
END pk_steps_award_report;
/