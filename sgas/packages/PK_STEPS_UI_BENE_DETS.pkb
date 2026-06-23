CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_bene_dets
AS
/******************************************************************************
   NAME:       pk_steps_ui_BENE_DETS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        05/02/2009      ABIRAMI CHIDAMBARAM   Code Population
   1.2        13/07/2010      Paddy Grace           Code amendment
   2.0        10/01/2017      Ranj Benning          CR-OLS115 Updates for Consent to Share
   3.0        14/11/2018      Clark Bolan           GDPR Phase 2 Changes
******************************************************************************/
   TYPE t_benefactor IS RECORD (
      nino            benefactor.ben_ni_no%TYPE,
      title           benefactor.title%TYPE,
      initials        benefactor.initials%TYPE,
      forenames       benefactor.forenames%TYPE,
      surname         benefactor.surname%TYPE,
      house_no_name   benefactor.house_no_name%TYPE,
      addr_l1         benefactor.addr_l1%TYPE,
      addr_l2         benefactor.addr_l2%TYPE,
      addr_l3         benefactor.addr_l3%TYPE,
      addr_l4         benefactor.addr_l4%TYPE,
      post_code       benefactor.post_code%TYPE,
      mailsort        benefactor.mailsort%TYPE,
      tele_no         benefactor.tele_no%TYPE,
      consent_to_share_student benefactor.consent_to_share_student%TYPE, 
      email_addr      benefactor.email_addr%TYPE
   );

   TYPE t_stud_ben_dets IS RECORD (
      ben1_id        stud_session.ben1_id%TYPE,
      ben1_rel_id    stud_session.ben1_rel_id%TYPE,
      ben2_id        stud_session.ben2_id%TYPE,
      ben2_rel_id    stud_session.ben2_rel_id%TYPE,
      session_code   stud_session.session_code%TYPE
   );

   FUNCTION getstudentsbenefactors (stud_session_id_in IN VARCHAR2)
      RETURN t_stud_ben_dets
   IS
      v_stud_ben_dets   t_stud_ben_dets;
   BEGIN
      SELECT ss.ben1_id, ss.ben1_rel_id,
             ss.ben2_id, ss.ben2_rel_id,
             ss.session_code
        INTO v_stud_ben_dets.ben1_id, v_stud_ben_dets.ben1_rel_id,
             v_stud_ben_dets.ben2_id, v_stud_ben_dets.ben2_rel_id,
             v_stud_ben_dets.session_code
        FROM stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in;

      RETURN v_stud_ben_dets;
   END getstudentsbenefactors;

   FUNCTION new_benefactor (newbenefactor IN t_benefactor, user_in IN VARCHAR2)
      RETURN NUMBER
   IS
      temp_ben_id   NUMBER;
   BEGIN
      SELECT be_ben_id_seq.NEXTVAL
        INTO temp_ben_id
        FROM DUAL;

      INSERT INTO benefactor b
                  (b.ben_id, b.ben_ni_no,
                   b.title,
                   b.initials,
                   b.forenames,
                   b.surname, b.overseas,
                   b.house_no_name,
                   b.addr_l1,
                   b.addr_l2,
                   b.addr_l3,
                   b.addr_l4,
                   b.post_code, b.mailsort,
                   b.tele_no,
                   b.consent_to_share_student,
                   b.email_addr, 
                   b.last_updated_by, b.last_updated_on
                  )
           VALUES (temp_ben_id, UPPER (newbenefactor.nino),
                   UPPER (newbenefactor.title),
                   UPPER (newbenefactor.initials),
                   UPPER (newbenefactor.forenames),
                   UPPER (newbenefactor.surname), 'N',
                   UPPER (newbenefactor.house_no_name),
                   UPPER (newbenefactor.addr_l1),
                   UPPER (newbenefactor.addr_l2),
                   UPPER (newbenefactor.addr_l3),
                   UPPER (newbenefactor.addr_l4),
                   UPPER (newbenefactor.post_code), newbenefactor.mailsort,
                   newbenefactor.tele_no,
                   newbenefactor.consent_to_share_student,
                   UPPER (newbenefactor.email_addr), 
                   UPPER (user_in), SYSDATE
                  );

      RETURN temp_ben_id;
   END new_benefactor;

   PROCEDURE getbendetails (
      stud_session_id_in   IN              VARCHAR2,
      ben1_id              OUT NOCOPY      VARCHAR2,
      ben1_rel_id          OUT NOCOPY      VARCHAR2,
      ben2_id              OUT NOCOPY      VARCHAR2,
      ben2_rel_id          OUT NOCOPY      VARCHAR2,
      session_code         OUT NOCOPY      VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
      v_stud_ben_dets   t_stud_ben_dets;
   BEGIN
      v_stud_ben_dets := getstudentsbenefactors (stud_session_id_in);
      ben1_id := v_stud_ben_dets.ben1_id;
      ben1_rel_id := v_stud_ben_dets.ben1_rel_id;
      ben2_id := v_stud_ben_dets.ben2_id;
      ben2_rel_id := v_stud_ben_dets.ben2_rel_id;
      session_code := v_stud_ben_dets.session_code;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getbendetails;

   PROCEDURE setbendetails (
      stud_session_id_in   IN              VARCHAR2,
      ben1_id_in           IN              VARCHAR2,
      ben1_rel_id_in       IN              VARCHAR2,
      ben2_id_in           IN              VARCHAR2,
      ben2_rel_id_in       IN              VARCHAR2,
      user_in              IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
      v_stud_ben_dets   t_stud_ben_dets;
   BEGIN
      UPDATE stud_session ss
         SET ben1_id = ben1_id_in,
             ben1_rel_id = ben1_rel_id_in,
             ben2_id = ben2_id_in,
             ben2_rel_id = ben2_rel_id_in,
             ss.last_updated_by = UPPER (user_in),
             ss.last_updated_on = SYSDATE
       WHERE ss.stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setbendetails;

   PROCEDURE getgrassbenefactor (
      ben_id_in       IN              VARCHAR2,
      title           OUT NOCOPY      VARCHAR2,
      nino            OUT NOCOPY      VARCHAR2,
      initials        OUT NOCOPY      VARCHAR2,
      forenames       OUT NOCOPY      VARCHAR2,
      surname         OUT NOCOPY      VARCHAR2,
      house_no_name   OUT NOCOPY      VARCHAR2,
      addr_l1         OUT NOCOPY      VARCHAR2,
      addr_l2         OUT NOCOPY      VARCHAR2,
      addr_l3         OUT NOCOPY      VARCHAR2,
      addr_l4         OUT NOCOPY      VARCHAR2,
      post_code       OUT NOCOPY      VARCHAR2,
      mailsort        OUT NOCOPY      VARCHAR2,
      tele_no         OUT NOCOPY      VARCHAR2,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT b.title, b.ben_ni_no, b.initials, b.forenames, b.surname,
             b.house_no_name, b.addr_l1, b.addr_l2, b.addr_l3, b.addr_l4,
             b.post_code, b.mailsort, b.tele_no
        INTO title, nino, initials, forenames, surname,
             house_no_name, addr_l1, addr_l2, addr_l3, addr_l4,
             post_code, mailsort, tele_no
        FROM benefactor@grass b
       WHERE b.ben_id = ben_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getgrassbenefactor;

  /* Formatted on 13/11/2018 15:45:29 (QP5 v5.215.12089.38647) */
PROCEDURE getbenefactor (ben_id_in                  IN            VARCHAR2,
                         title                         OUT NOCOPY VARCHAR2,
                         nino                          OUT NOCOPY VARCHAR2,
                         initials                      OUT NOCOPY VARCHAR2,
                         forenames                     OUT NOCOPY VARCHAR2,
                         surname                       OUT NOCOPY VARCHAR2,
                         house_no_name                 OUT NOCOPY VARCHAR2,
                         addr_l1                       OUT NOCOPY VARCHAR2,
                         addr_l2                       OUT NOCOPY VARCHAR2,
                         addr_l3                       OUT NOCOPY VARCHAR2,
                         addr_l4                       OUT NOCOPY VARCHAR2,
                         post_code                     OUT NOCOPY VARCHAR2,
                         mailsort                      OUT NOCOPY VARCHAR2,
                         tele_no                       OUT NOCOPY VARCHAR2,
                         consent_to_share_student      OUT NOCOPY VARCHAR2,
                         email_addr                    OUT NOCOPY VARCHAR2,
                         error_boolean                 OUT NOCOPY VARCHAR2,
                         ERROR_TEXT                    OUT NOCOPY VARCHAR2)
IS
BEGIN
   SELECT b.title,
          b.ben_ni_no,
          b.initials,
          b.forenames,
          b.surname,
          b.house_no_name,
          b.addr_l1,
          b.addr_l2,
          b.addr_l3,
          b.addr_l4,
          b.post_code,
          b.mailsort,
          b.tele_no,
          b.consent_to_share_student,
          b.email_addr
     INTO title,
          nino,
          initials,
          forenames,
          surname,
          house_no_name,
          addr_l1,
          addr_l2,
          addr_l3,
          addr_l4,
          post_code,
          mailsort,
          tele_no,
          consent_to_share_student,
          email_addr
     FROM benefactor b
    WHERE b.ben_id = ben_id_in;

   error_boolean := 'false';
   ERROR_TEXT := 'none';
EXCEPTION
   WHEN OTHERS
   THEN
      error_boolean := 'true';
      ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
END getbenefactor;

   PROCEDURE setbenefactor (
      ben_id_in          IN              VARCHAR2,
      title_in           IN              VARCHAR2,
      nino_in            IN              VARCHAR2,
      initials_in        IN              VARCHAR2,
      forenames_in       IN              VARCHAR2,
      surname_in         IN              VARCHAR2,
      house_no_name_in   IN              VARCHAR2,
      addr_l1_in         IN              VARCHAR2,
      addr_l2_in         IN              VARCHAR2,
      addr_l3_in         IN              VARCHAR2,
      addr_l4_in         IN              VARCHAR2,
      post_code_in       IN              VARCHAR2,
      mailsort_in        IN              VARCHAR2,
      tele_no_in         IN              VARCHAR2,
      consent_to_share_student_in IN     VARCHAR2,
      user_in            IN              VARCHAR2,
      email_addr_in      IN              VARCHAR2,
      error_boolean      OUT NOCOPY      VARCHAR2,
      ERROR_TEXT         OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      UPDATE benefactor b
         SET b.ben_ni_no = UPPER (nino_in),
             b.title = UPPER (title_in),
             b.initials = UPPER (initials_in),
             b.forenames = UPPER (forenames_in),
             b.surname = UPPER (surname_in),
             b.house_no_name = UPPER (house_no_name_in),
             b.addr_l1 = UPPER (addr_l1_in),
             b.addr_l2 = UPPER (addr_l2_in),
             b.addr_l3 = UPPER (addr_l3_in),
             b.addr_l4 = UPPER (addr_l4_in),
             b.post_code = UPPER (post_code_in),
             b.mailsort = mailsort_in,
             b.tele_no = tele_no_in,
             b.consent_to_share_student = consent_to_share_student_in,
             B.email_addr = UPPER (email_addr_in),
             b.last_updated_by = UPPER (user_in),
             b.last_updated_on = SYSDATE
       WHERE b.ben_id = ben_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setbenefactor;

   PROCEDURE insertbenefactor (
      stud_session_id_in     IN              VARCHAR2,
      benefactor_number_in   IN              VARCHAR2,
      relationship_in        IN              VARCHAR2,
      title_in               IN              VARCHAR2,
      nino_in                IN              VARCHAR2,
      initials_in            IN              VARCHAR2,
      forenames_in           IN              VARCHAR2,
      surname_in             IN              VARCHAR2,
      house_no_name_in       IN              VARCHAR2,
      addr_l1_in             IN              VARCHAR2,
      addr_l2_in             IN              VARCHAR2,
      addr_l3_in             IN              VARCHAR2,
      addr_l4_in             IN              VARCHAR2,
      post_code_in           IN              VARCHAR2,
      mailsort_in            IN              VARCHAR2,
      tele_no_in             IN              VARCHAR2,
      consent_to_share_student_in IN         VARCHAR2,
      email_addr_in          IN              VARCHAR2,
      user_in                IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      v_benefactor      t_benefactor;
      v_stud_ben_dets   t_stud_ben_dets;
      v_ben1_id         stud_session.ben1_id%TYPE;
      v_ben2_id         stud_session.ben2_id%TYPE;
   BEGIN
      v_stud_ben_dets := getstudentsbenefactors (stud_session_id_in);
      v_benefactor.title := title_in;
      v_benefactor.nino := nino_in;
      v_benefactor.initials := initials_in;
      v_benefactor.forenames := forenames_in;
      v_benefactor.surname := surname_in;
      v_benefactor.house_no_name := house_no_name_in;
      v_benefactor.addr_l1 := addr_l1_in;
      v_benefactor.addr_l2 := addr_l2_in;
      v_benefactor.addr_l3 := addr_l3_in;
      v_benefactor.addr_l4 := addr_l4_in;
      v_benefactor.post_code := post_code_in;
      v_benefactor.mailsort := mailsort_in;
      v_benefactor.tele_no := tele_no_in;
      v_benefactor.consent_to_share_student := consent_to_share_student_in;
      v_benefactor.email_addr := email_addr_in;

      IF benefactor_number_in = '1'
      THEN
         IF v_stud_ben_dets.ben1_id IS NOT NULL
         THEN
            error_boolean := 'true';
            ERROR_TEXT :=
                  'PK_STEPS_UI_BENE_DETS.INSERTBENEFACTOR : You are trying to add another benefactor '
               || benefactor_number_in
               || ' where one already exists for this student. Please remove the current benefactor '
               || benefactor_number_in
               || ' before continuing';
         ELSE
            v_ben1_id := new_benefactor (v_benefactor, user_in);

            UPDATE stud_session ss
               SET ss.ben1_id = v_ben1_id,
                   ss.ben1_rel_id = relationship_in,
                   ss.last_updated_by = UPPER (user_in),
                   ss.last_updated_on = SYSDATE
             WHERE ss.stud_session_id = stud_session_id_in;

            error_boolean := 'false';
            ERROR_TEXT := 'none';
         END IF;
      ELSIF benefactor_number_in = '2'
      THEN
         IF v_stud_ben_dets.ben2_id IS NOT NULL
         THEN
            error_boolean := 'true';
            ERROR_TEXT :=
                  'PK_STEPS_UI_BENE_DETS.INSERTBENEFACTOR : You are trying to add another benefactor '
               || benefactor_number_in
               || ' where one already exists for this student. Please remove the current benefactor '
               || benefactor_number_in
               || ' before continuing';
         ELSE
            v_ben2_id := new_benefactor (v_benefactor, user_in);

            UPDATE stud_session ss
               SET ss.ben2_id = v_ben2_id,
                   ss.ben2_rel_id = relationship_in,
                   ss.last_updated_by = UPPER (user_in),
                   ss.last_updated_on = SYSDATE
             WHERE ss.stud_session_id = stud_session_id_in;

            error_boolean := 'false';
            ERROR_TEXT := 'none';
         END IF;
      ELSE
         error_boolean := 'true';
         ERROR_TEXT :=
            'PK_STEPS_UI_BENE_DETS.INSERTBENEFACTOR : An invalid benefactor number has been passed. Please contact BSU';
      END IF;
      COMMIT;
   EXCEPTION
      WHEN VALUE_ERROR THEN 
         error_boolean := 'true';
         ERROR_TEXT := 'PK_STEPS_UI_BENE_DETS.INSERTBENEFACTOR : Invalid benefactor details entered: ' || SQLERRM ||  '.  Please contact BSU';   
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'PK_STEPS_UI_BENE_DETS.INSERTBENEFACTOR : SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
   END insertbenefactor;

   PROCEDURE removebenefactor (
      stud_session_id_in   IN              VARCHAR2,
      benefactor_number    IN              VARCHAR2,
      user_in              IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
      v_stud_ben_dets   t_stud_ben_dets;
   BEGIN
      v_stud_ben_dets := getstudentsbenefactors (stud_session_id_in);

      IF benefactor_number = 1
      THEN
         IF v_stud_ben_dets.ben2_id IS NOT NULL
         THEN
            UPDATE stud_session ss
               SET ss.ben1_id = ss.ben2_id,
                   ss.ben1_rel_id = ss.ben2_rel_id,
                   ss.ben2_id = NULL,
                   ss.ben2_rel_id = NULL,
                   ss.last_updated_by = UPPER (user_in),
                   ss.last_updated_on = SYSDATE
             WHERE ss.stud_session_id = stud_session_id_in;
         ELSE
            UPDATE stud_session ss
               SET ss.ben1_id = NULL,
                   ss.ben1_rel_id = NULL,
                   ss.last_updated_by = UPPER (user_in),
                   ss.last_updated_on = SYSDATE
             WHERE ss.stud_session_id = stud_session_id_in;
         END IF;
      ELSIF benefactor_number = 2
      THEN
         UPDATE stud_session ss
            SET ss.ben2_id = NULL,
                ss.ben2_rel_id = NULL,
                ss.last_updated_by = UPPER (user_in),
                ss.last_updated_on = SYSDATE
          WHERE ss.stud_session_id = stud_session_id_in;
      ELSE
         error_boolean := 'true';
         ERROR_TEXT :=
            'PK_STEPS_UI_BENE_DETS.REMOVEBENEFACTOR : An invalid benefactor number has been passed. Please contact BSU';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END removebenefactor;

   PROCEDURE checkduplicatebenefactor (
      forename_in     IN       VARCHAR2,
      surname_in      IN       VARCHAR2,
      io_cursor       IN OUT   checkdup_cursor,
      row_count       OUT      VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      cd_cursor   checkdup_cursor;
   BEGIN
      /*
       * RETREIVE DUPLICATE BENEFACTOR RECORD COUNT WITH SAME FORENAME AND SURNAME GIVEN, IF ANY
       */
      SELECT COUNT (*)
        INTO row_count
        FROM benefactor
       WHERE UPPER (forenames) = UPPER (forename_in)
         AND UPPER (surname) = UPPER (surname_in);

      IF row_count > 0
      THEN
         OPEN cd_cursor FOR
            SELECT b.ben_id AS ben_id
              FROM benefactor b
             WHERE UPPER (forenames) = UPPER (forename_in)
               AND UPPER (surname) = UPPER (surname_in);
      ELSE
         OPEN cd_cursor FOR
            SELECT '' AS ben_id
              FROM DUAL;
      END IF;

      io_cursor := cd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END checkduplicatebenefactor;

   PROCEDURE getbenefactordependants (
      stud_session_id_in   IN              NUMBER,
      io_cursor            IN OUT          bendep_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
      bd_cursor         bendep_cursor;
      v_stud_ben_dets   t_stud_ben_dets;
   BEGIN
      v_stud_ben_dets := getstudentsbenefactors (stud_session_id_in);

      OPEN bd_cursor FOR
         SELECT   bd.bed_id AS bed_id, bd.relation_type_id AS relationship,
                  TO_CHAR (bd.dob, 'dd-MM-YYYY') AS dob
             FROM benefactor_dependant bd, stud_session ss
            WHERE bd.ben_id IN
                          (v_stud_ben_dets.ben1_id, v_stud_ben_dets.ben2_id)
              AND ss.stud_session_id = stud_session_id_in
              AND bd.session_code = ss.session_code
         ORDER BY bd.relation_type_id;

      io_cursor := bd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getbenefactordependants;

   PROCEDURE insertbenefactordependants (
      stud_session_id_in   IN       VARCHAR2,
      dob_in               IN       DATE,
      rel_type_in          IN       VARCHAR2,
      user_in              IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   )
   AS
      v_stud_ben_dets   t_stud_ben_dets;
   BEGIN
      v_stud_ben_dets := getstudentsbenefactors (stud_session_id_in);

      /*
       * INSERT NEW BENEFACTOR DEPENDANT RECORD
       */
      INSERT INTO benefactor_dependant bd
                  (bd.bed_id, bd.ben_id,
                   bd.session_code, bd.dob, bd.income, bd.dependant_type,
                   bd.relation_type_id, bd.assistance_amount, bd.deduction,
                   bd.last_updated_by, bd.last_updated_on
                  )
           VALUES (bed_bed_id_seq.NEXTVAL, v_stud_ben_dets.ben1_id,
                   v_stud_ben_dets.session_code, dob_in, '0', 'C',
                   rel_type_in, '0', NULL,
                   user_in, SYSDATE
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
   END insertbenefactordependants;

   PROCEDURE removebenefactordependants (
      bed_id_in       IN       VARCHAR2,
      user_in         IN       VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
   BEGIN
      /*
       * REMOVE BENEFACTOR DEPENDANT DETAILS
       */
      UPDATE benefactor_dependant bd
         SET bd.last_updated_by = UPPER (user_in),
             bd.last_updated_on = SYSDATE
       WHERE bd.bed_id = bed_id_in;

      DELETE FROM benefactor_dependant bd
            WHERE bd.bed_id = bed_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END removebenefactordependants;
END pk_steps_ui_bene_dets;
/