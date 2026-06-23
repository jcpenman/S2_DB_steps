/* Formatted on 2008/11/10 11:57 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY ila500.paddy_test
AS
   PROCEDURE getlearnercheckdets (
      learner_application_id_in   IN              VARCHAR2,
      learner_id_out              OUT NOCOPY      VARCHAR2,
      forenames_out               OUT NOCOPY      VARCHAR2,
      surname_out                 OUT NOCOPY      VARCHAR2,
      dob_out                     OUT NOCOPY      VARCHAR2,
      session_out                 OUT NOCOPY      VARCHAR2,
      error_boolean               OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT l.learner_id, l.forename, l.surname, to_char(l.dob), la.session_year
        INTO learner_id_out, forenames_out, surname_out, dob_out, session_out
        FROM learner l, learner_application la
       WHERE la.learner_application_id = learner_application_id_in
         AND l.learner_id = la.learner_id;

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getlearnercheckdets;
END paddy_test;
/