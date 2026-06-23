CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_supp_grants
AS
/******************************************************************************
   NAME:       pk_steps_ui_SUPP_GRANTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        01/12/2008     ABIRAMI CHIDAMBARAM   Code Population
   1.2        16/06/2009      Paddy Grace           Amended code for reference data changes
   2.0        16/11/2018    Clark Bolan            GDPR SFD3 changes
******************************************************************************/
   PROCEDURE getdependants (
      stud_session_id_in   IN              NUMBER,
      io_cursor            IN OUT          dep_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
      d_cursor   dep_cursor;
   BEGIN
      OPEN d_cursor FOR
         SELECT sd.std_id AS std_id, sd.first_name AS forename,
                sd.surname AS surname, sd.relation_id AS relationship,
                sd.dob AS date_of_birth, sd.start_date AS start_date,
                sd.end_date AS end_date, sd.income AS income,
                SD.EMAIL_ADDR, SD.HOUSE_NO_NAME, SD.ADDR_L1,
                SD.ADDR_L2, SD.ADDR_L3, SD.ADDR_L4, SD.POST_CODE
           FROM stud_dependant sd
          WHERE sd.std_id IN (SELECT std_id
                                FROM stud_dependant
                               WHERE stud_session_id = stud_session_id_in);

      io_cursor := d_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getdependants;

   PROCEDURE setdependants (
      stud_session_id_in   IN       NUMBER,
      std_id_in            IN       NUMBER,
      first_name_in        IN       VARCHAR2,
      surname_in           IN       VARCHAR2,
      relation_id_in       IN       NUMBER,
      dob_in               IN       DATE,
      start_date_in        IN       DATE,
      end_date_in          IN       DATE,
      income_in            IN       NUMBER,
      user_in              IN       VARCHAR2,
      email_addr_in        IN       VARCHAR2,
      postcode_in          IN       VARCHAR2,
      house_no_name_in     IN       VARCHAR2,
      addr_l1_in           IN       VARCHAR2,
      addr_l2_in           IN       VARCHAR2,
      addr_l3_in           IN       VARCHAR2,
      addr_l4_in           IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE stud_dependant
         SET first_name = UPPER (first_name_in),
             surname = UPPER (surname_in),
             relation_id = relation_id_in,
             dob = dob_in,
             start_date = start_date_in,
             end_date = end_date_in,
             income = NVL (income_in, '0'),
             last_updated_by = UPPER (user_in),
             last_updated_on = SYSDATE,
             email_addr = UPPER (email_addr_in),
             post_code = UPPER (postcode_in),
             house_no_name = UPPER (house_no_name_in),
             addr_l1 = UPPER (addr_l1_in),
             addr_l2 = UPPER (addr_l2_in),
             addr_l3 = UPPER (addr_l3_in),
             addr_l4 = UPPER (addr_l4_in)
       WHERE stud_session_id = stud_session_id_in AND std_id = std_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setdependants;

   PROCEDURE insertdependants (
      stud_session_id_in   IN       NUMBER,
      first_name_in        IN       VARCHAR2,
      surname_in           IN       VARCHAR2,
      relation_id_in       IN       NUMBER,
      dob_in               IN       DATE,
      start_date_in        IN       DATE,
      end_date_in          IN       DATE,
      income_in            IN       NUMBER,
      user_in              IN       VARCHAR2,
      email_addr_in        IN       VARCHAR2,
      post_code_in         IN       VARCHAR2,
      house_no_name_in     IN       VARCHAR2,
      addr_l1_in           IN       VARCHAR2,
      addr_l2_in           IN       VARCHAR2,
      addr_l3_in           IN       VARCHAR2, 
      addr_l4_in           IN       VARCHAR2,   
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   )
   AS
      temp_stud_ref_no    VARCHAR (9);
      temp_session_code   VARCHAR (4);
   BEGIN
      SELECT DISTINCT stud_ref_no, session_code
                 INTO temp_stud_ref_no, temp_session_code
                 FROM stud_session
                WHERE stud_session_id = stud_session_id_in;

      INSERT INTO stud_dependant
                  (std_id, stud_session_id,
                   session_code, stud_ref_no,
                   first_name, surname, relation_id,
                   dob, income, assist, super_ann, retire_ann,
                   life_assurance, interest, tax_deduct, include, age_rate,
                   smg, start_date, end_date, FINAL, last_updated_by,
                   last_updated_on, email_addr, post_code, house_no_name,
                   addr_l1, addr_L2, addr_l3, addr_l4  
                  )
           VALUES (std_std_id_seq.NEXTVAL, stud_session_id_in,
                   temp_session_code, temp_stud_ref_no,
                   UPPER (first_name_in), UPPER (surname_in), relation_id_in,
                   dob_in, NVL (income_in, '0'), '0', '0', '0',
                   '0', '0', '0', 'Y', 'N',
                   'N', start_date_in, end_date_in, 'N', UPPER (user_in),
                   SYSDATE, email_addr_in, post_code_in, house_no_name_in,
                   addr_l1_in, addr_l2_in, addr_l3_in, addr_l4_in
                  );

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertdependants;

   PROCEDURE deletedependants (
      stud_session_id_in   IN       NUMBER,
      std_id_in            IN       NUMBER,
      user_in              IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE stud_dependant sd
         SET sd.last_updated_by = UPPER (user_in)
       WHERE stud_session_id = stud_session_id_in AND std_id = std_id_in;

      DELETE FROM stud_dependant
            WHERE stud_session_id = stud_session_id_in AND std_id = std_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deletedependants;

   PROCEDURE getlpcg (
      stud_session_id_in    IN              VARCHAR2,
      max_lpcg_paid_out     OUT NOCOPY      VARCHAR2,
      lpcg_paid_amt_out     OUT NOCOPY      VARCHAR2,
      child_care_no_out     OUT NOCOPY      VARCHAR2,
      child_care_name_out   OUT NOCOPY      VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT max_lpcg_paid, lpcg_paid_amount, child_care_no,
             child_care_name
        INTO max_lpcg_paid_out, lpcg_paid_amt_out, child_care_no_out,
             child_care_name_out
        FROM stud_session
       WHERE stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         ROLLBACK;
   END getlpcg;
   
    

   PROCEDURE setlpcg (
      stud_session_id_in   IN              VARCHAR2,
      max_lpcg_paid_in     IN              VARCHAR2,
      lpcg_paid_amt_in     IN              NUMBER,
      child_care_no_in     IN              VARCHAR2,
      child_care_name_in   IN              VARCHAR2,
      employee_in          IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      UPDATE stud_session ss
         SET ss.max_lpcg_paid = max_lpcg_paid_in,
             ss.lpcg_paid_amount = lpcg_paid_amt_in,
             ss.child_care_no = child_care_no_in,
             ss.child_care_name = UPPER (child_care_name_in),
             ss.last_updated_by = UPPER (employee_in),
             ss.last_updated_on = SYSDATE
       WHERE ss.stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         ROLLBACK;
   END setlpcg;
   
    PROCEDURE getsag (stud_session_id_in          IN         VARCHAR2,
                      accommodation_informal_out  OUT NOCOPY VARCHAR2,
                      accommodation_formal_out    OUT NOCOPY VARCHAR2,
                      session_code_out            OUT NOCOPY VARCHAR2,
                      care_exp_evidence_out       OUT NOCOPY VARCHAR2,
                      error_boolean               OUT NOCOPY VARCHAR2,
                      ERROR_TEXT                  OUT NOCOPY VARCHAR2)
    IS
    
    l_stud_ref_no NUMBER;
    BEGIN
    
       SELECT accommodation_informal, accommodation_formal, session_code, stud_ref_no
         INTO accommodation_informal_out, accommodation_formal_out, session_code_out, l_stud_ref_no
         FROM STUD_SESSION ss
        WHERE stud_session_id = stud_session_id_in;
        
        SELECT S.CARE_EXP_EVIDENCE_RECVD
        INTO care_exp_evidence_out
        FROM stud s
        WHERE s.stud_ref_no = l_stud_ref_no;

       error_boolean := 'false';
       ERROR_TEXT := 'none';
       COMMIT;
    EXCEPTION
       WHEN OTHERS
       THEN
          error_boolean := 'true';
          ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
          ROLLBACK;
    END getsag;

    PROCEDURE setsag (stud_session_id_in         IN         VARCHAR2,
                      accommodation_informal_in  IN         VARCHAR2,
                      accommodation_formal_in    IN         VARCHAR2,
                      employee_in                IN         VARCHAR2,
                      error_boolean              OUT NOCOPY VARCHAR2,
                      ERROR_TEXT                 OUT NOCOPY VARCHAR2)
    IS
    BEGIN
       UPDATE stud_session ss
          SET SS.accommodation_informal = accommodation_informal_in,
              ss.accommodation_formal = accommodation_formal_in,
              ss.last_updated_by = UPPER (employee_in),
              ss.last_updated_on = SYSDATE
        WHERE ss.stud_session_id = stud_session_id_in;

       error_boolean := 'false';
       ERROR_TEXT := 'none';
       COMMIT;
    EXCEPTION
       WHEN OTHERS
       THEN
          error_boolean := 'true';
          ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
          ROLLBACK;
    END setsag;
       
        

   PROCEDURE checkdupdep (
      stud_session_id_in   IN       VARCHAR2,
      forename_in          IN       VARCHAR2,
      surname_in           IN       VARCHAR2,
      stud_dep_id_in       IN       VARCHAR2,
      dup_count            OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   )
   AS
   BEGIN
      SELECT COUNT (*)
        INTO dup_count
        FROM stud_dependant
       WHERE stud_session_id = stud_session_id_in
         AND UPPER (first_name) = UPPER (forename_in)
         AND UPPER (surname) = UPPER (surname_in)
         AND std_id <> stud_dep_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         dup_count := '0';
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END checkdupdep;

   PROCEDURE checkdupspouse (
      stud_session_id_in   IN       VARCHAR2,
      countdupspouse       OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   )
   AS
   BEGIN
      SELECT COUNT (*)
        INTO countdupspouse
        FROM stud_dependant
       WHERE stud_session_id = stud_session_id_in AND relation_id = 48;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         countdupspouse := '0';
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END checkdupspouse;

   PROCEDURE getstudcrseyearid (
      stud_session_id_in      IN       VARCHAR2,
      stud_crse_year_id_out   OUT      VARCHAR2,
      session_code_out        OUT      VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2
   )
   AS
   BEGIN
      SELECT stud_crse_year.stud_crse_year_id, stud_session.session_code
        INTO stud_crse_year_id_out, session_code_out
        FROM stud_crse_year, stud_session
       WHERE stud_crse_year.stud_session_id = stud_session_id_in
         AND stud_crse_year.latest_crse_ind = 'Y'
         AND stud_crse_year.stud_session_id = stud_session.stud_session_id;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudcrseyearid;

   PROCEDURE getrelativedate (
      stud_session_id_in   IN       VARCHAR2,
      relativedate         OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   )
   AS
   BEGIN
      SELECT sgas.rules_proc_recalc.fee_cut_off_date (stud_session_id_in)
        INTO relativedate
        FROM DUAL;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'false';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getrelativedate;
END pk_steps_ui_supp_grants;
/