/* Formatted on 2008/11/10 11:43 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE ila500.paddy_test
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
   );
   
   PROCEDURE getlearnerwarnings (
      learner_id_in              IN      VARCHAR2,
      error_boolean               OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY      VARCHAR2
   );
END paddy_test;
/