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
******************************************************************************/
   PROCEDURE getdd_award (
      io_cursor       IN OUT   dd_cursor_award,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_dearing (
      io_cursor       IN OUT   dd_cursor_dearing,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_contactrel (
      io_cursor       IN OUT   dd_cursor_contactrel,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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
                FROM crse@grass c
               WHERE c.inst_code = inst_code_in
                 AND c.crse_id IN (SELECT cs.crse_id
                                     FROM crse_session@grass cs
                                    WHERE cs.session_code = session_code_in)
            ORDER BY c.crse_name;
      ELSE
         OPEN dd_cursor FOR
            SELECT   c.crse_code AS KEY, c.crse_name AS label
                FROM crse@grass c
               WHERE c.scheme_type = scheme_type_in
                 AND c.inst_code = inst_code_in
                 AND c.crse_id IN (SELECT cs.crse_id
                                     FROM crse_session@grass cs
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

   PROCEDURE getdd_bankdup (
      io_cursor       IN OUT   dd_cursor_bankdup,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_feeloan (
      io_cursor       IN OUT   dd_cursor_feeloan,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_noninoreason (
      io_cursor       IN OUT   dd_cursor_nonino,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_debtstatus (
      io_cursor       IN OUT   dd_cursor_debtstatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_depempstatus (
      io_cursor       IN OUT   dd_cursor_depempstatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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
      io_cursor       IN OUT   dd_cursor_benincomestatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_benincometype (
      io_cursor       IN OUT   dd_cursor_benincometype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_benreltype (
      io_cursor       IN OUT   dd_cursor_benreltype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_benreltype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT br.legacy_id AS KEY, br.descript AS label
           FROM benefactor_relation br;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_benreltype;

   PROCEDURE getdd_jatype (
      io_cursor       IN OUT   dd_cursor_jatype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_jatype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT jar.legacy_code AS KEY, jar.descript AS label
           FROM joint_app_relation jar;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_jatype;

   PROCEDURE getdd_deprel (
      io_cursor       IN OUT   dd_cursor_deprel,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_deprelchild (
      io_cursor       IN OUT   dd_cursor_deprelchild,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_depreladult (
      io_cursor       IN OUT   dd_cursor_depreladult,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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
      io_cursor       IN OUT          dd_cursor_doctype_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
      dt_cursor   dd_cursor_doctype_cursor;
   BEGIN
      OPEN dt_cursor FOR
         SELECT   dt.document_type_id AS document_type_id,
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
      io_cursor       IN OUT   dd_cursor_dsaassesscentre,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_dsaassesscentre;
   BEGIN
      OPEN dd_cursor FOR
         SELECT   dac.dsa_assessment_centre_id AS KEY, dac.NAME AS label
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

   PROCEDURE getdd_dsatype (
      io_cursor       IN OUT   dd_cursor_dsatype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_dsatype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT   dt.dsa_type_id AS KEY, dt.TYPE AS label
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

   PROCEDURE getdd_dsacategory (
      io_cursor       IN OUT   dd_cursor_dsacategory,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_dsacategory;
   BEGIN
      OPEN dd_cursor FOR
         SELECT   dc.dsa_category_id AS KEY, dc.description AS label
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
      io_cursor       IN OUT   dd_cursor_disabilitytype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_disabilitytype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT   dt.disability_type_id AS KEY, dt.descript AS label
             FROM disability_type dt
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
      dsa_category_type_in   IN       VARCHAR2,
      io_cursor              IN OUT   dd_cursor_dsaallowancecat,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_dsaallowancecat;
   BEGIN
      OPEN dd_cursor FOR
         SELECT   dc.code AS KEY, dc.description AS label
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
      io_cursor       IN OUT   dd_cursor_dsarejectionreason,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_dsarejectionreason;
   BEGIN
      OPEN dd_cursor FOR
         SELECT   drr.dsa_rejection_reason_id AS KEY, drr.reason AS label
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
      io_cursor       IN OUT   dd_cursor_dsareferralreason,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_dsareferralreason;
   BEGIN
      OPEN dd_cursor FOR
         SELECT   drr.dsa_referral_reason_id AS KEY, drr.reason AS label
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
      io_cursor       IN OUT   dd_cursor_dsastudenttype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_dsapaymentstatus (
      io_cursor       IN OUT   dd_cursor_dsapaymentstatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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
      scheme_type_in    IN       VARCHAR2,
      session_code_in   IN       VARCHAR2,
      io_cursor         IN OUT   dd_cursor_institution,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_institution;
   BEGIN
      IF scheme_type_in = '' OR scheme_type_in IS NULL
      THEN
         OPEN dd_cursor FOR
            SELECT DISTINCT i.inst_code AS KEY, i.inst_name AS label
                       FROM crse c, inst i
                      WHERE c.inst_code = i.inst_code
                        AND c.crse_id IN (
                                          SELECT crse_id
                                            FROM crse_session
                                           WHERE session_code =
                                                               session_code_in)
                   ORDER BY i.inst_name;
      ELSE
         OPEN dd_cursor FOR
            SELECT DISTINCT i.inst_code AS KEY, i.inst_name AS label
                       FROM crse c, inst i
                      WHERE c.inst_code = i.inst_code
                        AND c.scheme_type = scheme_type_in
                        AND c.crse_id IN (
                                          SELECT crse_id
                                            FROM crse_session
                                           WHERE session_code =
                                                               session_code_in)
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

   PROCEDURE getdd_loanstatus (
      io_cursor       IN OUT   dd_cursor_loanstatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_location (
      io_cursor       IN OUT   dd_cursor_location,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_maritalstatus (
      io_cursor       IN OUT   dd_cursor_maritalstatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_nationality (
      io_cursor       IN OUT   dd_cursor_nationality,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_nationality;
   BEGIN
      OPEN dd_cursor FOR
         SELECT   c.country_code AS KEY, c.nationality_name||' - '||c.long_name AS label
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
      io_cursor       IN OUT   dd_cursor_nmsbcontinuation,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_nmsbcontinuation;
   BEGIN
      OPEN dd_cursor FOR
         SELECT   ncr.nmsb_cont_id AS KEY, ncr.descript AS label
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

   PROCEDURE getdd_otherloan (
      io_cursor       IN OUT   dd_cursor_otherloan,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_residence (
      io_cursor       IN OUT   dd_cursor_residence,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_residence;
   BEGIN
      OPEN dd_cursor FOR
         SELECT   c.country_code AS KEY, c.long_name AS label
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

   PROCEDURE getdd_residencetype (
      io_cursor       IN OUT   dd_cursor_residencetype,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_residencetype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT   rt.legacy_code AS KEY, rt.descript AS label
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

   PROCEDURE getdd_scheme (
      io_cursor       IN OUT   dd_cursor_scheme,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_title (
      io_cursor       IN OUT   dd_cursor_title,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_casestatus (
      io_cursor       IN OUT   dd_cursor_casestatus,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_casestatus;
   BEGIN
      OPEN dd_cursor FOR
         SELECT cs.legacy_code AS KEY, cs.descript AS label
           FROM case_status cs;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_casestatus;

   PROCEDURE getdd_zrefusal (
      io_cursor       IN OUT   dd_cursor_zrefusal,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getdd_paymentmethod (
      io_cursor       IN OUT   dd_cursor_paymentmethod,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
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

   PROCEDURE getstudentsessions (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          student_sessions_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      ss_cursor   student_sessions_cursor;
   BEGIN
      OPEN ss_cursor FOR
         SELECT   ss.stud_session_id, ss.session_code, 'S' AS db
             FROM stud s, stud_session ss
            WHERE s.stud_ref_no = stud_ref_no_in
              AND s.stud_ref_no = ss.stud_ref_no
         UNION
         SELECT   ss.stud_session_id, ss.session_code, 'G' AS db
             FROM stud@grass s, stud_session@grass ss
            WHERE s.stud_ref_no = stud_ref_no_in
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

   PROCEDURE getlatestsession (
      stud_ref_no_in        IN              VARCHAR2,
      stud_session_id_out   OUT             VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
      steps_ss           VARCHAR2 (10);
      grass_ss           VARCHAR2 (10);
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
         stud_session_id_out := steps_ss || '-S';
      ELSIF grass_ss IS NOT NULL
      THEN
         stud_session_id_out := grass_ss || '-G';
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
      stud_session_id_in   IN              VARCHAR2,
      db_in                IN              VARCHAR2,
      io_cursor            IN OUT          student_crse_year_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
      scy_cursor   student_crse_year_cursor;
   BEGIN
      IF db_in = 'S'
      THEN
         OPEN scy_cursor FOR
            SELECT   scy.stud_crse_year_id, scy.inst_code, scy.crse_code,
                     scy.crse_year_no, 'STEPS' AS db
                FROM stud_crse_year scy
               WHERE scy.stud_session_id = stud_session_id_in
            ORDER BY scy.stud_crse_year_id ASC;
      ELSIF db_in = 'G'
      THEN
         OPEN scy_cursor FOR
            SELECT   scy.stud_crse_year_id, scy.inst_code, scy.crse_code,
                     scy.crse_year_no, 'GRASS' AS db
                FROM stud_crse_year@grass scy
               WHERE scy.stud_session_id = stud_session_id_in
            ORDER BY scy.stud_crse_year_id ASC;
      ELSE
         OPEN scy_cursor FOR
            SELECT '', '', '', '', 'NONE' AS db
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
      stud_session_id_in      IN              VARCHAR2,
      db_in                   IN              VARCHAR2,
      stud_crse_year_id_out   OUT             VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   )
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
   )
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
        FROM inst@grass i
       WHERE i.inst_code = temp_inst_code;

      ERROR_TEXT := 'Course input check - ';

      /*
      * Check if the course code is Null, and if so
      * clear the remaining course information on the students
      * course year record
      */
      IF temp_crse_code IS NULL OR temp_crse_code = ''
      THEN
         temp_course_name := NULL;
         temp_crse_id := NULL;
         temp_crse_year_id := NULL;
         temp_grad_session := NULL;
         temp_scheme_type := NULL;
      ELSE
         SELECT cy.crse_id, cy.crse_year_id, c.crse_name,
                (cs.max_duration + cs.session_code - course_year_no_in
                ),
                c.scheme_type
           INTO temp_crse_id, temp_crse_year_id, temp_course_name,
                temp_grad_session,
                temp_scheme_type
           FROM crse c, crse_session cs, crse_year cy
          WHERE c.crse_code = temp_crse_code
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
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getinstandcrsedets;
END pk_steps_ui_shared;
/
