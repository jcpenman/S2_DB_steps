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
         SELECT sd.std_id as std_id, sd.first_name as forename, sd.surname as surname, rd.label as relationship, sd.dob as date_of_birth,
         sd.START_DATE as start_date, sd.END_DATE as end_date, sd.income as income
           FROM stud_dependant sd,
                (SELECT BR.LEGACY_ID AS KEY, BR.DESCRIPT AS label
           FROM benefactor_relation br
           UNION
           SELECT SGR.LEGACY_ID AS KEY, SGR.DESCRIPT AS label
           FROM supp_grant_relation sgr) rd
          WHERE sd.relation_id = rd.KEY
            AND sd.std_id IN (SELECT std_id
                                FROM stud_dependant
                               WHERE stud_session_id = stud_session_id_in);

      io_cursor := d_cursor;
      error_boolean := 'false';
      error_text := 'none';
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
             last_updated_on = SYSDATE
       WHERE stud_session_id = stud_session_id_in AND std_id = std_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
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
                   dob, income, assist,
                   super_ann, retire_ann, life_assurance, interest, tax_deduct, include, age_rate, smg,
                   start_date, end_date, FINAL, 
                   last_updated_by, last_updated_on
                  )
           VALUES (std_std_id_seq.NEXTVAL, stud_session_id_in,
                   temp_session_code, temp_stud_ref_no,
                   UPPER (first_name_in), UPPER (surname_in), relation_id_in,
                   dob_in, NVL (income_in, '0'), '0',
                   '0', '0', '0', '0', '0', 'Y', 'N', 'N',
                   start_date_in, end_date_in, 'N', 
                   UPPER (user_in), SYSDATE
                  );
                  
      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
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
      
      UPDATE STUD_DEPENDANT sd
         SET sd.last_updated_by = UPPER (user_in);
         
      DELETE FROM STUD_DEPENDANT
            WHERE stud_session_id = stud_session_id_in AND std_id = std_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deletedependants;

PROCEDURE checkdupdep (
      stud_session_id_in        IN       NUMBER,
      forename_in               IN       VARCHAR2,
      surname_in                IN       VARCHAR2,
      dup_count                 OUT      VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2
   )
   AS
           
      BEGIN
      
      SELECT COUNT(*)
      INTO dup_count
      FROM STUD_DEPENDANT
      WHERE stud_session_id = stud_session_id_in
      AND UPPER (first_name) = UPPER (forename_in)
      AND UPPER (surname) = UPPER (surname_in);
   
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         dup_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
            
   END checkdupdep;
   
   PROCEDURE spousedepchck (
      stud_session_id_in        IN       NUMBER,
      spouse_dep_cnt            OUT      VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2
   )
   AS
           
      BEGIN
      
      SELECT COUNT(*)
      INTO spouse_dep_cnt
      FROM STUD_DEPENDANT
      WHERE stud_session_id = stud_session_id_in
      AND relation_id = 48;
   
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         spouse_dep_cnt := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
            
   END spousedepchck;
   
     PROCEDURE getmaxlpcg (
      stud_session_id_in   IN              NUMBER,
      max_lpcg_paid_out    OUT NOCOPY      VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT max_lpcg_paid
        INTO max_lpcg_paid_out
        FROM stud_session
       WHERE stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getmaxlpcg;

   PROCEDURE setmaxlpcg (
      stud_session_id_in   IN              NUMBER,
      max_lpcg_paid_in     IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_session
         SET max_lpcg_paid = UPPER (max_lpcg_paid_in)
       WHERE stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setmaxlpcg;

   PROCEDURE getamtlpcg (
      stud_session_id_in   IN              NUMBER,
      lpcg_paid_amt_out    OUT NOCOPY      NUMBER,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT lpcg_paid_amount
        INTO lpcg_paid_amt_out
        FROM stud_session
       WHERE stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getamtlpcg;

   PROCEDURE setamtlpcg (
      stud_session_id_in   IN              NUMBER,
      lpcg_paid_amt_in     IN              NUMBER,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_session
         SET lpcg_paid_amount = lpcg_paid_amt_in
       WHERE stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setamtlpcg;

   PROCEDURE getccnumlpcg (
      stud_session_id_in   IN              NUMBER,
      child_care_no_out    OUT NOCOPY      VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT child_care_no
        INTO child_care_no_out
        FROM stud_session
       WHERE stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getccnumlpcg;

   PROCEDURE setccnumlpcg (
      stud_session_id_in   IN              NUMBER,
      child_care_no_in     IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_session
         SET child_care_no = child_care_no_in
       WHERE stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setccnumlpcg;

   PROCEDURE getccnamelpcg (
      stud_session_id_in    IN              NUMBER,
      child_care_name_out   OUT NOCOPY      VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT child_care_name
        INTO child_care_name_out
        FROM stud_session
       WHERE stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getccnamelpcg;

   PROCEDURE setccnamelpcg (
      stud_session_id_in   IN              NUMBER,
      child_care_name_in   IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_session
         SET child_care_name = UPPER (child_care_name_in)
       WHERE stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setccnamelpcg;
END pk_steps_ui_supp_grants;
/
