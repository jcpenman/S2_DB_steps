CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_shared
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
      2.0.1      21/07/2014  RANJ BENNING     Fix to checkprovisionalincome (StEPS Defect 138)
      2.0.2      30/07/2014  EWAN WATSON      Fix for checkstudmatchescrseyear(STEPS Defect 147)
      2.1        29/10/2019  James Baird     Removed the @GRASS for course and institution tables.
      2.2        01/10/2020  MIKE TOLMIE      Addition for EU Settled Statuses EU Brexit COS 2021
      2.3        28/01/2021  RANJ BENNING     Addition for EU Residence Types EU Exceptions COS 2021 
      2.4        30/05/2022  Clark Bolan     Addition for Overpayments dd_cursor_award_end_reason  
      2.5        13/11/2023  John Penman     Added IS_ACTIVE togetdd_residencecategory as a new where clause (COS 24/25 Residency Updates)    
   ******************************************************************************/

   PROCEDURE getdd_paymentreturn_status (
      io_cursor       IN OUT dd_cursor_paymentreturn_status,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_paymentreturn_status;
   BEGIN
      OPEN dd_cursor FOR
           SELECT prs.code AS key, prs.descript AS label
             FROM payment_return_status prs
         ORDER BY prs.descript DESC;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_paymentreturn_status;


   PROCEDURE getdd_awardtype_non_loan (
      io_cursor       IN OUT dd_cursor_awardtype_non_loan,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_awardtype_non_loan;
   BEGIN
      OPEN dd_cursor FOR
           SELECT sat.stud_award_type AS KEY,
                  sat.award_type_descript || ' ' || sat.scheme AS label
             FROM stud_award_type sat
            WHERE     sat.TYPE NOT IN ('LOAN', 'TRAV', 'FEE', 'PAY')
                  AND sat.stud_award_type IS NOT NULL
         ORDER BY sat.scheme DESC, sat.award_type_descript ASC;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_awardtype_non_loan;

   PROCEDURE getdd_award (io_cursor       IN OUT dd_cursor_award,
                          error_boolean      OUT VARCHAR2,
                          ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_award;
   BEGIN
      OPEN dd_cursor FOR
         SELECT ard.legacy_code AS KEY, ard.descript AS label
           FROM award_ref_data ard;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_award;

   PROCEDURE getdd_dearing (io_cursor       IN OUT dd_cursor_dearing,
                            error_boolean      OUT VARCHAR2,
                            ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_dearing;
   BEGIN
      OPEN dd_cursor FOR
         SELECT ds.legacy_code AS KEY, ds.descript AS label
           FROM dearing_status ds;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_dearing;

   PROCEDURE getdd_contactrel (io_cursor       IN OUT dd_cursor_contactrel,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_contactrel;
   BEGIN
      OPEN dd_cursor FOR
         SELECT cr.reltype AS KEY, cr.descript AS label
           FROM contact_relationship cr;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_contactrel;

   PROCEDURE getdd_course (
      inst_code_in      IN       VARCHAR2,
      scheme_type_in    IN       VARCHAR2,
      session_code_in   IN       VARCHAR2,
      io_cursor         IN OUT   dd_cursor_course,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   AS
      dd_cursor          dd_cursor_course;
      temp_scheme_type   VARCHAR (1);
   BEGIN
      IF scheme_type_in IS NULL OR scheme_type_in = ''
      THEN
         OPEN dd_cursor FOR
            SELECT   c.crse_code AS KEY, c.crse_name AS label
                FROM crse c
               WHERE c.inst_code = inst_code_in
                 AND c.crse_id IN (SELECT cs.crse_id
                                     FROM crse_session cs
                                    WHERE cs.session_code = session_code_in)
            ORDER BY c.crse_name;
      ELSIF scheme_type_in = 'B'
      THEN
         OPEN dd_cursor FOR
            SELECT   c.crse_code AS KEY, c.crse_name AS label
                FROM crse c, inst i
               WHERE c.scheme_type = scheme_type_in
                 AND c.inst_code = i.inst_code
                 AND i.inst_type_id = 3
                 AND c.inst_code = inst_code_in
                 AND c.crse_id IN (SELECT cs.crse_id
                                     FROM crse_session cs
                                    WHERE cs.session_code = session_code_in)
            ORDER BY c.crse_name;
      ELSE
         OPEN dd_cursor FOR
            SELECT   c.crse_code AS KEY, c.crse_name AS label
                FROM crse c
               WHERE c.scheme_type IN (scheme_type_in, 'G')
                 AND c.inst_code = inst_code_in
                 AND c.crse_id IN (SELECT cs.crse_id
                                     FROM crse_session cs
                                    WHERE cs.session_code = session_code_in)
            ORDER BY c.crse_name;
      END IF;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_course;
   
   PROCEDURE getdd_bankdup (io_cursor       IN OUT dd_cursor_bankdup,
                            error_boolean      OUT VARCHAR2,
                            ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_bankdup;
   BEGIN
      OPEN dd_cursor FOR
         SELECT dbr.legacy_code AS KEY, dbr.descript AS label
           FROM dup_bank_reason dbr;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_bankdup;

   PROCEDURE getdd_feeloan (io_cursor       IN OUT dd_cursor_feeloan,
                            error_boolean      OUT VARCHAR2,
                            ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_feeloan;
   BEGIN
      OPEN dd_cursor FOR
         SELECT flt.legacy_code AS KEY, flt.descript AS label
           FROM fee_loan_type flt;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_feeloan;

   PROCEDURE getdd_noninoreason (io_cursor       IN OUT dd_cursor_nonino,
                                 error_boolean      OUT VARCHAR2,
                                 ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_nonino;
   BEGIN
      OPEN dd_cursor FOR
         SELECT nnr.legacy_code AS KEY, nnr.descript AS label
           FROM no_nino_reason nnr;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_noninoreason;

   PROCEDURE getdd_debtstatus (io_cursor       IN OUT dd_cursor_debtstatus,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_debtstatus;
   BEGIN
      OPEN dd_cursor FOR
         SELECT ds.legacy_code AS KEY, ds.descript AS label
           FROM debt_status ds;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_debtstatus;

   PROCEDURE getdd_depempstatus (io_cursor       IN OUT dd_cursor_depempstatus,
                                 error_boolean      OUT VARCHAR2,
                                 ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_depempstatus;
   BEGIN
      OPEN dd_cursor FOR
         SELECT es.legacy_code AS KEY, es.descript AS label
           FROM employment_status es;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_depempstatus;

   PROCEDURE getdd_benincomestatus (
      io_cursor       IN OUT dd_cursor_benincomestatus,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_benincomestatus;
   BEGIN
      OPEN dd_cursor FOR
         SELECT bis.legacy_code AS KEY, bis.descript AS label
           FROM ben_income_status bis;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_benincomestatus;

   PROCEDURE getdd_benincometype (io_cursor       IN OUT dd_cursor_benincometype,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_benincometype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT bit.legacy_code AS KEY, bit.descript AS label
           FROM ben_income_type bit;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_benincometype;

   PROCEDURE getdd_benreltype (io_cursor       IN OUT dd_cursor_benreltype,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_benreltype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT br.legacy_id AS KEY, br.descript AS label
           FROM benefactor_relation br
          WHERE br.is_active = 'Y';

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_benreltype;

   PROCEDURE getdd_jacasetype (io_cursor       IN OUT dd_cursor_jacasetype,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_jacasetype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT jct.legacy_code AS KEY, jct.descript AS label
           FROM ja_case_type jct;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_jacasetype;

   PROCEDURE getdd_jastudtype (io_cursor       IN OUT dd_cursor_jastudtype,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_jastudtype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT jst.legacy_code AS KEY, jst.descript AS label
           FROM ja_stud_type jst;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_jastudtype;

   PROCEDURE getdd_deprel (io_cursor       IN OUT dd_cursor_deprel,
                           error_boolean      OUT VARCHAR2,
                           ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_deprel;
   BEGIN
      OPEN dd_cursor FOR
         SELECT sgr.legacy_id AS KEY, sgr.descript AS label
           FROM supp_grant_relation sgr;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_deprel;

   PROCEDURE getdd_deprelchild (io_cursor       IN OUT dd_cursor_deprelchild,
                                error_boolean      OUT VARCHAR2,
                                ERROR_TEXT         OUT VARCHAR2)
   AS
      ddc_cursor   dd_cursor_deprelchild;
   BEGIN
      OPEN ddc_cursor FOR
         SELECT sgr.legacy_id AS KEY, sgr.descript AS label
           FROM supp_grant_relation sgr
          WHERE sgr.legacy_code = 'H';

      io_cursor := ddc_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_deprelchild;

   PROCEDURE getdd_depreladult (io_cursor       IN OUT dd_cursor_depreladult,
                                error_boolean      OUT VARCHAR2,
                                ERROR_TEXT         OUT VARCHAR2)
   AS
      dda_cursor   dd_cursor_depreladult;
   BEGIN
      OPEN dda_cursor FOR
         SELECT sgr.legacy_id AS KEY, sgr.descript AS label
           FROM supp_grant_relation sgr
          WHERE sgr.legacy_code = 'U';

      io_cursor := dda_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_depreladult;

   PROCEDURE getdd_documenttype (
      io_cursor       IN OUT        dd_cursor_doctype_cursor,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      dt_cursor   dd_cursor_doctype_cursor;
   BEGIN
      OPEN dt_cursor FOR
           SELECT dt.document_type_id AS document_type_id,
                  dt.descript AS description
             FROM document_type dt
         ORDER BY dt.descript ASC;

      error_boolean := 'false';
      io_cursor := dt_cursor;
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_documenttype;

   PROCEDURE getdd_dsaassessmentcentre (
      io_cursor       IN OUT dd_cursor_dsaassesscentre,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_dsaassesscentre;
   BEGIN
      OPEN dd_cursor FOR
           SELECT dac.dsa_assessment_centre_id AS KEY, dac.NAME AS label
             FROM dsa_assessment_centre dac
         ORDER BY dac.NAME;

      error_boolean := 'false';
      io_cursor := dd_cursor;
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_dsaassessmentcentre;

   PROCEDURE getdd_dsatype (io_cursor       IN OUT dd_cursor_dsatype,
                            error_boolean      OUT VARCHAR2,
                            ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_dsatype;
   BEGIN
      OPEN dd_cursor FOR
           SELECT dt.dsa_type_id AS KEY, dt.TYPE AS label
             FROM dsa_type dt
         ORDER BY dt.TYPE;

      error_boolean := 'false';
      io_cursor := dd_cursor;
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_dsatype;

   PROCEDURE getdd_dsacategory (io_cursor       IN OUT dd_cursor_dsacategory,
                                error_boolean      OUT VARCHAR2,
                                ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_dsacategory;
   BEGIN
      OPEN dd_cursor FOR
           SELECT dc.dsa_category_id AS KEY, dc.description AS label
             FROM dsa_category dc
         ORDER BY dc.description;

      error_boolean := 'false';
      io_cursor := dd_cursor;
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_dsacategory;

   PROCEDURE getdd_disabilitytype (
      io_cursor       IN OUT dd_cursor_disabilitytype,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_disabilitytype;
   BEGIN
      OPEN dd_cursor FOR
           SELECT dt.disability_type_id AS KEY, dt.descript AS label
             FROM disability_type dt
	WHERE dt.is_active = 'Y'
         ORDER BY dt.descript;

      error_boolean := 'false';
      io_cursor := dd_cursor;
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_disabilitytype;

   PROCEDURE getdd_dsaallowancecat (
      dsa_category_type_in   IN     VARCHAR2,
      io_cursor              IN OUT dd_cursor_dsaallowancecat,
      error_boolean             OUT VARCHAR2,
      ERROR_TEXT                OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_dsaallowancecat;
   BEGIN
      OPEN dd_cursor FOR
           SELECT dc.code AS KEY, dc.description AS label
             FROM dsa_category dc
            WHERE dc.type_id = dsa_category_type_in
         ORDER BY dc.description;

      error_boolean := 'false';
      io_cursor := dd_cursor;
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_dsaallowancecat;

   PROCEDURE getdd_dsarejectionreason (
      io_cursor       IN OUT dd_cursor_dsarejectionreason,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_dsarejectionreason;
   BEGIN
      OPEN dd_cursor FOR
           SELECT drr.dsa_rejection_reason_id AS KEY, drr.reason AS label
             FROM dsa_rejection_reason drr
         ORDER BY drr.dsa_rejection_reason_id;

      error_boolean := 'false';
      io_cursor := dd_cursor;
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_dsarejectionreason;

   PROCEDURE getdd_dsareferralreason (
      io_cursor       IN OUT dd_cursor_dsareferralreason,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_dsareferralreason;
   BEGIN
      OPEN dd_cursor FOR
           SELECT drr.dsa_referral_reason_id AS KEY, drr.reason AS label
             FROM dsa_referral_reason drr
         ORDER BY drr.dsa_referral_reason_id;

      error_boolean := 'false';
      io_cursor := dd_cursor;
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_dsareferralreason;

   PROCEDURE getdd_dsastudenttype (
      io_cursor       IN OUT dd_cursor_dsastudenttype,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_dsastudenttype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT dst.dsa_student_type_id AS KEY, dst.TYPE AS label
           FROM dsa_student_type dst;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_dsastudenttype;

   PROCEDURE getdd_dsacategoryfortype (
      io_cursor       IN OUT dd_cursor_dsacategoryfortype,
      type_id_in      IN     VARCHAR2,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_dsacategoryfortype;
   BEGIN
      OPEN dd_cursor FOR
           SELECT dc.dsa_category_id AS KEY, dc.description AS label
             FROM dsa_category dc
            WHERE dc.type_id = type_id_in
         ORDER BY dc.description;

      error_boolean := 'false';
      io_cursor := dd_cursor;
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_dsacategoryfortype;

   PROCEDURE getdd_dsapaymentstatus (
      io_cursor       IN OUT dd_cursor_dsapaymentstatus,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_dsapaymentstatus;
   BEGIN
      OPEN dd_cursor FOR
         SELECT dps.dsa_payment_status_id AS KEY, dps.status AS label
           FROM dsa_payment_status dps;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_dsapaymentstatus;

   PROCEDURE getdd_institution (
      scheme_type_in    IN     VARCHAR2,
      session_code_in   IN     VARCHAR2,
      io_cursor         IN OUT dd_cursor_institution,
      error_boolean        OUT VARCHAR2,
      ERROR_TEXT           OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_institution;
      temp_scheme_type_2 VARCHAR (1);

   BEGIN
   
      IF scheme_type_in = '' OR scheme_type_in IS NULL
      THEN
         OPEN dd_cursor FOR
              SELECT DISTINCT i.inst_code AS KEY, i.inst_name AS label
                FROM crse c, inst i
               WHERE     c.inst_code = i.inst_code
                     AND c.crse_id IN (SELECT crse_id
                                         FROM crse_session
                                        WHERE session_code = session_code_in)
            ORDER BY i.inst_name;
      ELSE
         OPEN dd_cursor FOR
              SELECT DISTINCT i.inst_code AS KEY, i.inst_name AS label
                FROM crse c, inst i
               WHERE     c.inst_code = i.inst_code
                     AND c.scheme_type IN (scheme_type_in, 'G')
                     AND c.crse_id IN (SELECT crse_id
                                         FROM crse_session
                                        WHERE session_code = session_code_in)
            ORDER BY i.inst_name;
      END IF;

   
    
    

    
      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_institution;

   PROCEDURE getdd_loanstatus (io_cursor       IN OUT dd_cursor_loanstatus,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_loanstatus;
   BEGIN
      OPEN dd_cursor FOR
         SELECT ls.legacy_code AS KEY, ls.descript AS label
           FROM loan_status ls;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_loanstatus;

   PROCEDURE getdd_location (io_cursor       IN OUT dd_cursor_location,
                             error_boolean      OUT VARCHAR2,
                             ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_location;
   BEGIN
      OPEN dd_cursor FOR
         SELECT l.legacy_code AS KEY, l.descript AS label
           FROM LOCATION l;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_location;

   PROCEDURE getdd_maritalstatus (io_cursor       IN OUT dd_cursor_maritalstatus,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_maritalstatus;
   BEGIN
      OPEN dd_cursor FOR
         SELECT ms.legacy_code AS KEY, ms.descript AS label
           FROM marital_status ms;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_maritalstatus;

   PROCEDURE getdd_nationality (io_cursor       IN OUT dd_cursor_nationality,
                                error_boolean      OUT VARCHAR2,
                                ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_nationality;
   BEGIN
      OPEN dd_cursor FOR
           SELECT c.country_code AS KEY,
                  c.nationality_name || ' - ' || c.long_name AS label
             FROM country c
         ORDER BY c.nationality_name;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_nationality;

   PROCEDURE getdd_nmsbcontinuation (
      io_cursor       IN OUT dd_cursor_nmsbcontinuation,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_nmsbcontinuation;
   BEGIN
      OPEN dd_cursor FOR
           SELECT ncr.nmsb_cont_id AS KEY, ncr.descript AS label
             FROM sgas.nmsb_continuation_reason ncr
         ORDER BY ncr.nmsb_cont_id;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_nmsbcontinuation;

   PROCEDURE getdd_otherloan (io_cursor       IN OUT dd_cursor_otherloan,
                              error_boolean      OUT VARCHAR2,
                              ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_otherloan;
   BEGIN
      OPEN dd_cursor FOR
         SELECT olt.legacy_code AS KEY, olt.descript AS label
           FROM other_loan_type olt;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_otherloan;

   PROCEDURE getdd_residence (io_cursor       IN OUT dd_cursor_residence,
                              error_boolean      OUT VARCHAR2,
                              ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_residence;
   BEGIN
      OPEN dd_cursor FOR
           SELECT c.country_code AS KEY, c.long_name AS label
             FROM country c
         ORDER BY c.long_name;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_residence;

   PROCEDURE getdd_residencecategory (
      io_cursor       IN OUT        dd_cursor_rescat,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      rcat_cursor   dd_cursor_rescat;
   BEGIN
      OPEN rcat_cursor FOR
           SELECT residence_category.residence_category_id AS KEY,
                  residence_category.residence_status AS label
             FROM residence_category
             WHERE IS_ACTIVE = 'Y'
         ORDER BY residence_category.residence_category_id;

      io_cursor := rcat_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getdd_residencecategory;
   
   
      PROCEDURE getdd_residencecategory_all (
      io_cursor       IN OUT        dd_cursor_rescat,
      p_residence_category_id IN VARCHAR2, 
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      rcat_cursor   dd_cursor_rescat;
   BEGIN
      OPEN rcat_cursor FOR
           SELECT residence_category.residence_category_id AS KEY,
                  residence_category.residence_status AS label
             FROM residence_category
             WHERE residence_category_id = p_residence_category_id
         ORDER BY residence_category.residence_category_id;

      io_cursor := rcat_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getdd_residencecategory_all;

   PROCEDURE getdd_residencetype (io_cursor       IN OUT dd_cursor_residencetype,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_residencetype;
   BEGIN
      OPEN dd_cursor FOR
           SELECT rt.legacy_code AS KEY, rt.descript AS label
             FROM residence_type rt
         ORDER BY rt.descript;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_residencetype;

   PROCEDURE getdd_scheme (io_cursor       IN OUT dd_cursor_scheme,
                           error_boolean      OUT VARCHAR2,
                           ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_scheme;
   BEGIN
      OPEN dd_cursor FOR
         SELECT st.legacy_code AS KEY, st.descript AS label
           FROM scheme_type st;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_scheme;

   PROCEDURE getdd_title (io_cursor       IN OUT dd_cursor_title,
                          error_boolean      OUT VARCHAR2,
                          ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_title;
   BEGIN
      OPEN dd_cursor FOR
         SELECT t.legacy_code AS KEY, t.descript AS label
           FROM title t;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_title;

   PROCEDURE getdd_casestatus (io_cursor       IN OUT dd_cursor_casestatus,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_casestatus;
   BEGIN
      OPEN dd_cursor FOR
           SELECT cs.legacy_code AS KEY, cs.descript AS label
             FROM case_status cs
         ORDER BY case_status_id;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_casestatus;

   PROCEDURE getdd_zrefusal (io_cursor       IN OUT dd_cursor_zrefusal,
                             error_boolean      OUT VARCHAR2,
                             ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_zrefusal;
   BEGIN
      OPEN dd_cursor FOR
         SELECT zrs.legacy_code AS KEY, zrs.descript AS label
           FROM z_refusal_status zrs;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_zrefusal;

   PROCEDURE getdd_paymentmethod (io_cursor       IN OUT dd_cursor_paymentmethod,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_paymentmethod;
   BEGIN
      OPEN dd_cursor FOR
         SELECT pm.payment_method_id AS KEY, pm.descript AS label
           FROM payment_method pm;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_paymentmethod;

   PROCEDURE getdd_paymentstatus (io_cursor       IN OUT dd_cursor_paymentstatus,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_paymentstatus;
   BEGIN
      OPEN dd_cursor FOR
         SELECT ps.TYPE AS KEY, ps.description AS label
           FROM payment_status ps;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_paymentstatus;

   PROCEDURE getdd_paymentmethod_legacy (
      io_cursor       IN OUT dd_cursor_paymentmethod_l,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_paymentmethod;
   BEGIN
      OPEN dd_cursor FOR
         SELECT pm.legacy_code AS KEY, pm.descript AS label
           FROM payment_method pm;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_paymentmethod_legacy;

   PROCEDURE getdd_paymentreturn_method (
      io_cursor       IN OUT dd_cursor_paymentreturn,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_paymentreturn;
   BEGIN
      OPEN dd_cursor FOR
         SELECT prm.method_code AS KEY, prm.descript AS label
           FROM payment_returns_method prm;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_paymentreturn_method;

   PROCEDURE getdd_paymentroute (io_cursor       IN OUT dd_cursor_paymentroute,
                                 error_boolean      OUT VARCHAR2,
                                 ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_paymentroute;
   BEGIN
      OPEN dd_cursor FOR
         SELECT prc.payment_route_id AS KEY, prc.description AS label
           FROM payment_route_category prc;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_paymentroute;

   PROCEDURE getdd_payeetype (io_cursor       IN OUT dd_cursor_payeetype,
                              error_boolean      OUT VARCHAR2,
                              ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_payeetype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT pt.TYPE AS KEY, pt.description AS label
           FROM payee_type pt;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_payeetype;

   PROCEDURE getdd_paymentreturntype (
      io_cursor       IN OUT dd_cursor_paymentreturntype,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_paymentreturntype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT prt.payment_return_type_id AS KEY, prt.description AS label
           FROM payment_return_type prt;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_paymentreturntype;

   PROCEDURE getdd_studincometype (
      io_cursor       IN OUT dd_cursor_studincometype,
      error_boolean      OUT VARCHAR2,
      ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_studincometype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT sit.income_type_id AS KEY, sit.description AS label
           FROM stud_income_type sit;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_studincometype;

   PROCEDURE getdd_studentstatus (io_cursor       IN OUT dd_cursor_studentstatus,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_studentstatus;
   BEGIN
      OPEN dd_cursor FOR
         SELECT ss.legacy_code AS KEY, ss.descript AS label
           FROM student_status ss;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_studentstatus;

   PROCEDURE getdd_adhoc_type (io_cursor       IN OUT dd_cursor_adhoc_type,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_adhoc_type;
   BEGIN
      OPEN dd_cursor FOR
         SELECT AT.legacy_code AS KEY,
                AT.descript AS label,
                AT.IS_ACTIVE AS is_active
           FROM adhoc_type AT;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_adhoc_type;


   PROCEDURE getdd_award_end_reason (io_cursor       IN OUT dd_cursor_award_end_reason,
                               error_boolean      OUT VARCHAR2,
                               ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_award_end_reason;
   BEGIN
      OPEN dd_cursor FOR
         SELECT AER.REASON_ID AS KEY,
                AER.REASON AS label
           FROM AWARD_END_REASON aer
           WHERE AER.IS_ACTIVE = 'Y';

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_award_end_reason;
   
   PROCEDURE getstudentsessions (
      stud_ref_no_in   IN            VARCHAR2,
      io_cursor        IN OUT        student_sessions_cursor,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2)
   IS
      ss_cursor   student_sessions_cursor;
   BEGIN
      OPEN ss_cursor FOR
         SELECT ss.stud_session_id, ss.session_code, 'S' AS db
           FROM stud s, stud_session ss
          WHERE     s.stud_ref_no = stud_ref_no_in
                AND s.stud_ref_no = ss.stud_ref_no
         UNION
         SELECT ss.stud_session_id, ss.session_code, 'G' AS db
           FROM stud@grass s, stud_session@grass ss
          WHERE     s.stud_ref_no = stud_ref_no_in
                AND s.stud_ref_no = ss.stud_ref_no;

      io_cursor := ss_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudentsessions;

   PROCEDURE getlatestsession (stud_ref_no_in        IN            VARCHAR2,
                               stud_session_id_out      OUT        VARCHAR2,
                               error_boolean            OUT NOCOPY VARCHAR2,
                               ERROR_TEXT               OUT NOCOPY VARCHAR2)
   IS
      steps_ss           VARCHAR2 (10);
      grass_ss           VARCHAR2 (10);
      v_session_code     VARCHAR2 (4);
      no_stud_sessions   EXCEPTION;
   BEGIN
      steps_ss := NULL;
      grass_ss := NULL;

      SELECT MAX (ss.stud_session_id)
        INTO steps_ss
        FROM stud_session ss
       WHERE ss.stud_ref_no = stud_ref_no_in;

      SELECT MAX (ss.stud_session_id)
        INTO grass_ss
        FROM stud_session@grass ss
       WHERE ss.stud_ref_no = stud_ref_no_in;

      IF steps_ss IS NOT NULL
      THEN
         SELECT ss.session_code
           INTO v_session_code
           FROM stud_session ss
          WHERE ss.stud_session_id = steps_ss;

         stud_session_id_out := steps_ss || '-S' || '-' || v_session_code;
      ELSIF grass_ss IS NOT NULL
      THEN
         SELECT ss.session_code
           INTO v_session_code
           FROM stud_session@grass ss
          WHERE ss.stud_session_id = grass_ss;

         stud_session_id_out := grass_ss || '-G' || '-' || v_session_code;
      ELSE
         RAISE no_stud_sessions;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN no_stud_sessions
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'No Student Sessions found in GRASS or STEPS';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getlatestsession;

   PROCEDURE getstudentcrseyears (
      stud_session_id_in   IN            VARCHAR2,
      db_in                IN            VARCHAR2,
      io_cursor            IN OUT        student_crse_year_cursor,
      error_boolean           OUT NOCOPY VARCHAR2,
      ERROR_TEXT              OUT NOCOPY VARCHAR2)
   IS
      scy_cursor   student_crse_year_cursor;
   BEGIN
      IF db_in = 'S'
      THEN
         OPEN scy_cursor FOR
              SELECT scy.stud_crse_year_id,
                     scy.inst_code,
                     scy.crse_code,
                     scy.crse_year_no,
                     'STEPS' AS db
                FROM stud_crse_year scy
               WHERE scy.stud_session_id = stud_session_id_in
            ORDER BY scy.stud_crse_year_id ASC;
      ELSIF db_in = 'G'
      THEN
         OPEN scy_cursor FOR
              SELECT scy.stud_crse_year_id,
                     scy.inst_code,
                     scy.crse_code,
                     scy.crse_year_no,
                     'GRASS' AS db
                FROM stud_crse_year@grass scy
               WHERE scy.stud_session_id = stud_session_id_in
            ORDER BY scy.stud_crse_year_id ASC;
      ELSE
         OPEN scy_cursor FOR
            SELECT '',
                   '',
                   '',
                   '',
                   'NONE' AS db
              FROM stud_crse_year@grass scy
             WHERE scy.stud_session_id = stud_session_id_in;
      END IF;

      io_cursor := scy_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudentcrseyears;

   PROCEDURE getlatestcrseyear (
      stud_session_id_in      IN            VARCHAR2,
      db_in                   IN            VARCHAR2,
      stud_crse_year_id_out      OUT        VARCHAR2,
      error_boolean              OUT NOCOPY VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      IF db_in = 'S'
      THEN
         SELECT MAX (scy.stud_crse_year_id)
           INTO stud_crse_year_id_out
           FROM stud_crse_year scy
          WHERE scy.stud_session_id = stud_session_id_in;
      END IF;

      IF db_in = 'G'
      THEN
         SELECT MAX (scy.stud_crse_year_id)
           INTO stud_crse_year_id_out
           FROM stud_crse_year@grass scy
          WHERE scy.stud_session_id = stud_session_id_in;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getlatestcrseyear;

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
      ERROR_TEXT               OUT NOCOPY VARCHAR2)
   IS
      temp_inst_code      VARCHAR (10);
      temp_crse_code      VARCHAR (10);
      temp_inst_name      VARCHAR2 (50);
      temp_course_name    VARCHAR2 (50);
      temp_crse_id        NUMBER (9);
      temp_crse_year_id   NUMBER (9);
      temp_grad_session   NUMBER (4);
      temp_scheme_type    VARCHAR2 (1);
   BEGIN
      ERROR_TEXT := 'Institution input check - ';

      /*
      * Check if the institution code is Null, and if not
      * clear the course information on the students
      * course year record
      */
      IF institution_code_in IS NULL OR institution_code_in = ''
      THEN
         temp_inst_code := 'INV';
         temp_crse_code := NULL;
      ELSE
         temp_inst_code := institution_code_in;
         temp_crse_code := course_code_in;
      END IF;

      SELECT i.inst_name
        INTO temp_inst_name
        FROM inst i
       WHERE i.inst_code = temp_inst_code;

      ERROR_TEXT := 'Course input check - ';

      /*
      * Check if the course code is Null, and if so
      * clear the remaining course information on the students
      * course year record
      */
      IF temp_crse_code IS NULL OR temp_crse_code = ''
      THEN
         temp_crse_code := NULL;
         temp_course_name := NULL;
         temp_crse_id := NULL;
         temp_crse_year_id := NULL;
         temp_grad_session := NULL;
         temp_scheme_type := NULL;
      ELSE
         SELECT cy.crse_id,
                cy.crse_year_id,
                c.crse_name,
                (cs.max_duration + cs.session_code - course_year_no_in),
                c.scheme_type
           INTO temp_crse_id,
                temp_crse_year_id,
                temp_course_name,
                temp_grad_session,
                temp_scheme_type
           FROM crse c, crse_session cs, crse_year cy
          WHERE     c.crse_code = temp_crse_code
                AND c.crse_id = cs.crse_id
                AND cs.crse_session_id = cy.crse_session_id
                AND cs.session_code = session_code_in
                AND cy.inst_code = temp_inst_code
                AND cy.crse_year_no = course_year_no_in;
      END IF;

      inst_code_out := temp_inst_code;
      crse_code_out := temp_crse_code;
      inst_name_out := temp_inst_name;
      crse_name_out := temp_course_name;
      crse_id_out := temp_crse_id;
      crse_year_id_out := temp_crse_year_id;
      grad_session_out := temp_grad_session;
      scheme_type_out := temp_scheme_type;
      ERROR_TEXT := 'none';
      error_boolean := 'false';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            'The Course Data entered is invalid. Please check your details.';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getinstandcrsedets;

   PROCEDURE getloancontactone (
      stud_ref_no_in   IN            VARCHAR2,
      io_cursor        IN OUT        loanconatctone_cursor,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2)
   IS
      lco_cursor   loanconatctone_cursor;
   BEGIN
      OPEN lco_cursor FOR
         SELECT sc.cont_name AS NAME,
                sc.cont_rel_code AS relationship,
                sc.cont_addr1 AS addr_l1,
                sc.cont_addr2 AS addr_l2,
                sc.cont_addr3 AS addr_l3,
                sc.cont_postcode AS postcode,
                sc.cont_tel_no AS tele_no,
                (SELECT COUNT (*)
                   FROM stud_cont_details sc
                  WHERE     sc.stud_ref_no = stud_ref_no_in
                        AND sc.contact_ind = '1')
                   AS record_count
           FROM stud_cont_details sc
          WHERE sc.stud_ref_no = stud_ref_no_in AND sc.contact_ind = '1';

      io_cursor := lco_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getloancontactone;

   PROCEDURE getloancontacttwo (
      stud_ref_no_in   IN            VARCHAR2,
      io_cursor        IN OUT        loanconatcttwo_cursor,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2)
   IS
      lct_cursor   loanconatcttwo_cursor;
   BEGIN
      OPEN lct_cursor FOR
         SELECT sc.cont_name AS NAME,
                sc.cont_addr1 AS addr_l1,
                sc.cont_addr2 AS addr_l2,
                sc.cont_addr3 AS addr_l3,
                sc.cont_postcode AS postcode,
                sc.cont_tel_no AS tele_no,
                (SELECT COUNT (*)
                   FROM stud_cont_details sc
                  WHERE     sc.stud_ref_no = stud_ref_no_in
                        AND sc.contact_ind = '2')
                   AS record_count
           FROM stud_cont_details sc
          WHERE sc.stud_ref_no = stud_ref_no_in AND sc.contact_ind = '2';

      io_cursor := lct_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getloancontacttwo;

   PROCEDURE getloandetails (
      stud_crse_year_id_in   IN            VARCHAR2,
      io_cursor              IN OUT        loandetails_cursor,
      error_boolean             OUT NOCOPY VARCHAR2,
      ERROR_TEXT                OUT NOCOPY VARCHAR2)
   IS
      ld_cursor   loandetails_cursor;
   BEGIN
      OPEN ld_cursor FOR
         SELECT ss.max_loan_requested AS maximum_loan,
                sc.loan_given AS loan_given,
                ss.loan_request AS loan_amount,
                ss.loan_declaration_date AS loan_sign_date,
                ss.reason_no_nino AS no_nino_reason,
                s.bankrupt_flag AS bankrupt,
                s.ni_no AS nino
           FROM stud_crse_year sc, stud s, stud_session ss
          WHERE     ss.stud_session_id = sc.stud_session_id
                AND s.stud_ref_no = sc.stud_ref_no
                AND sc.stud_crse_year_id = stud_crse_year_id_in;

      io_cursor := ld_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getloandetails;

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
                             ERROR_TEXT                 OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      SELECT s.ni_no,
             s.title,
             s.initials,
             s.forenames,
             s.surname,
             s.birth_forenames,
             s.birth_surname,
             s.dob,
             s.sex,
             s.marital_status,
             s.marriage_date,
             s.birth_country_code,
             s.residence_country_code,
             s.nation_country_code,
             s.district_birth_cert_issued,
             s.addr_corr_flag,
             s.email_addr,
             sha.tele_no,
             s.mobile_tel_no,
             sha.out_uk,
             s.sort_code,
             s.account_no,
             s.valid_duplicate_acc,
             s.dup_bank_reason,
             s.stud_suspend,
             s.residence_status,
             s.commence_session,
             s.suspend_payment
        INTO nino_out,
             title_out,
             initial_out,
             forename_out,
             surname_out,
             birth_forename_out,
             birth_surname_out,
             date_of_birth_out,
             sex_out,
             marital_status_out,
             marriage_date_out,
             birth_country_out,
             residence_country_out,
             nation_country_out,
             birth_district_out,
             addr_corres_flag_out,
             email_addr_out,
             tel_no_out,
             mobile_tel_no_out,
             abroad_out,
             sort_code_out,
             account_num_out,
             valid_dup_acc_out,
             dup_bank_reason_out,
             stud_suspend_out,
             res_status_out,
             commence_session_out,
             suspend_payments_out
        FROM stud s, stud_home_addr sha
       WHERE     s.stud_ref_no = stud_ref_no_in
             AND s.stud_ref_no = sha.stud_ref_no
             AND sha.end_date IS NULL;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstuddetails;

   PROCEDURE checkprovisionalincome (
      stud_session_id_in   IN            VARCHAR2,
      error_boolean           OUT NOCOPY VARCHAR2,
      ERROR_TEXT              OUT NOCOPY VARCHAR2)
   IS
      tmp_ben1_id             NUMBER (9);
      tmp_ben2_id             NUMBER (9);
      tmp_income_status_one   VARCHAR (1);
      tmp_income_status_two   VARCHAR (1);
      tmp_session_code        NUMBER (4);

      CURSOR cpc
      IS
         SELECT scy.provisional_case,
                scy.stud_crse_year_id,
                scy.parent_contrib_exempt,
                scy.latest_crse_ind
           FROM stud_crse_year scy
          WHERE scy.stud_session_id = stud_session_id_in;

      cpc_rec                 cpc%ROWTYPE;
   BEGIN
      ERROR_TEXT :=
            'Getting student session data. '
         || stud_session_id_in
         || ' session id';

      SELECT ss.ben1_id, ss.ben2_id, ss.session_code
        INTO tmp_ben1_id, tmp_ben2_id, tmp_session_code
        FROM stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in;

      IF tmp_ben1_id IS NOT NULL
      THEN                                               -- Benefactor exists?
         BEGIN
            ERROR_TEXT := 'Getting ben1 income status. ';

            SELECT bi.income_status          -- Get income status benefactor 1
              INTO tmp_income_status_one
              FROM benefactor_income bi
             WHERE     bi.ben_id = tmp_ben1_id
                   AND bi.session_code = tmp_session_code;
         EXCEPTION                -- If no income record exists default to 'P'
            WHEN OTHERS
            THEN
               tmp_income_status_one := 'P';
         END;

         IF tmp_ben2_id IS NOT NULL
         THEN
            BEGIN
               ERROR_TEXT := 'Getting ben2 income status. ';

               SELECT bi.income_status       -- Get income status benefactor 2
                 INTO tmp_income_status_two
                 FROM benefactor_income bi
                WHERE     bi.ben_id = tmp_ben2_id
                      AND bi.session_code = tmp_session_code;
            EXCEPTION             -- If no income record exists default to 'P'
               WHEN OTHERS
               THEN
                  tmp_income_status_two := 'P';
            END;
         ELSE
            tmp_income_status_two := 'F';
         END IF;

         IF (tmp_income_status_one = 'F' AND tmp_income_status_two = 'F')
         THEN                                        -- Income status is final
            OPEN cpc;

            LOOP
               FETCH cpc INTO cpc_rec;

               EXIT WHEN cpc%NOTFOUND;

               IF cpc_rec.provisional_case = 'Y'
               THEN
                  ERROR_TEXT := 'Updating provisional case. ';

                  -- Provisional case should be 'N' if income status is final
                  UPDATE stud_crse_year
                     SET provisional_case = 'N'
                   WHERE stud_crse_year_id = cpc_rec.stud_crse_year_id;
               END IF;
            END LOOP;

            CLOSE cpc;
         ELSE
            OPEN cpc;

            LOOP
               FETCH cpc INTO cpc_rec;

               EXIT WHEN cpc%NOTFOUND;

               IF cpc_rec.provisional_case = 'N'
               THEN
                  ERROR_TEXT := 'Updating provisional case. ';

                  -- Provisional case should be 'Y' if income status is not final
                  UPDATE stud_crse_year
                     SET provisional_case = 'Y'
                   WHERE stud_crse_year_id = cpc_rec.stud_crse_year_id;
               END IF;
            END LOOP;

            CLOSE cpc;
         END IF;
      ELSE
         OPEN cpc;

         LOOP
            FETCH cpc INTO cpc_rec;

            EXIT WHEN cpc%NOTFOUND;

            IF cpc_rec.provisional_case = 'Y'
            THEN     -- Provisional case should be 'N' if no benefactor exists
               ERROR_TEXT := 'Updating provisional case. ';

               UPDATE stud_crse_year
                  SET provisional_case = 'N'
                WHERE stud_crse_year_id = cpc_rec.stud_crse_year_id;
            END IF;
         END LOOP;

         CLOSE cpc;
      END IF;

      OPEN cpc;

      -- Provisional case should be 'N' if students circumstances are parent contribution exempt and is the latest course
      LOOP
         FETCH cpc INTO cpc_rec;

         EXIT WHEN cpc%NOTFOUND;

         IF     cpc_rec.provisional_case = 'Y'
            AND cpc_rec.latest_crse_ind = 'Y'
            AND cpc_rec.parent_contrib_exempt = 'Y'
         THEN
            UPDATE stud_crse_year
               SET provisional_case = 'N'
             WHERE stud_crse_year_id = cpc_rec.stud_crse_year_id;
         END IF;
      END LOOP;

      CLOSE cpc;

      COMMIT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
   END checkprovisionalincome;

   PROCEDURE checkstudmatchescrseyear (
      stud_crse_year_id_in   IN            VARCHAR2,
      stud_ref_no_in         IN            VARCHAR2,
      stud_correct_out          OUT        VARCHAR2,
      error_boolean             OUT NOCOPY VARCHAR2,
      ERROR_TEXT                OUT NOCOPY VARCHAR2)
   IS
      countstud_ref_no   NUMBER;
      stud_ref_id        VARCHAR2 (8);
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      stud_correct_out := 'false';

      SELECT COUNT (*)
        INTO countstud_ref_no
        FROM stud_crse_year scy
       WHERE SCY.STUD_CRSE_YEAR_ID = stud_crse_year_id_in;



      IF countstud_ref_no = 0          --Could be grass session so check there
      THEN
         SELECT COUNT (*)
           INTO countstud_ref_no
           FROM stud_crse_year@grass scy
          WHERE SCY.STUD_CRSE_YEAR_ID = stud_crse_year_id_in;

         SELECT scy.stud_ref_no
           INTO stud_ref_id
           FROM stud_crse_year@grass scy
          WHERE SCY.STUD_CRSE_YEAR_ID = stud_crse_year_id_in;
      ELSE
         SELECT scy.stud_ref_no
           INTO stud_ref_id
           FROM stud_crse_year scy
          WHERE SCY.STUD_CRSE_YEAR_ID = stud_crse_year_id_in;
      END IF;

      IF stud_ref_id = stud_ref_no_in
      THEN
         stud_correct_out := 'true';
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
         stud_correct_out := 'false';
   END checkstudmatchescrseyear;

   PROCEDURE getdd_reason_no_ben_income (
      io_cursor       OUT dd_cursor_no_benincome,
      error_boolean   OUT VARCHAR2,
      ERROR_TEXT      OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_no_benincome;
   BEGIN
      OPEN dd_cursor FOR
         SELECT rbi.reason_no_ben_income_id AS KEY, rbi.description AS label
           FROM reason_no_ben_income rbi
          WHERE is_active = 'Y';

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_reason_no_ben_income;

   PROCEDURE getdd_stud_message_subject (
      io_cursor       OUT dd_cursor_stud_message_subject,
      error_boolean   OUT VARCHAR2,
      ERROR_TEXT      OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_stud_message_subject;
   BEGIN
      OPEN dd_cursor FOR
         SELECT sms.student_message_subject_id AS KEY,
                sms.description AS label
           FROM STUDENT_MESSAGE_SUBJECT sms
          WHERE is_active = 'Y';

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_stud_message_subject;
   
   
    PROCEDURE getdd_eu_settled_statuses (
      io_cursor       OUT dd_cursor_eu_settled_statuses,
      error_boolean   OUT VARCHAR2,
      ERROR_TEXT      OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_eu_settled_statuses;
   BEGIN
      OPEN dd_cursor FOR
         SELECT euss.STATUS_ID AS KEY,
                euss.STATUS AS label
           FROM EU_SETTLED_STATUSES euss
          WHERE euss.IS_ACTIVE = 'Y';

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_eu_settled_statuses;
   
 
   
    PROCEDURE getdd_eu_residence_types (
      io_cursor       OUT dd_cursor_eu_residence_types,
      error_boolean   OUT VARCHAR2,
      ERROR_TEXT      OUT VARCHAR2)
   AS
      dd_cursor   dd_cursor_eu_residence_types;
   BEGIN
      OPEN dd_cursor FOR
         SELECT eurt.STATUS_ID AS KEY,
                eurt.STATUS AS label
           FROM EU_RESIDENCE_TYPE eurt
          WHERE eurt.IS_ACTIVE = 'Y';

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_eu_residence_types; 
   
END pk_steps_ui_shared;
/
