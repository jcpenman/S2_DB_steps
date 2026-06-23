/* Formatted on 2010/12/08 12:08 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_ui_study_abroad
AS
/******************************************************************************
   NAME:       pk_steps_ui_STUDY_ABROAD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                     Description
   ---------  ----------  ---------------            ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        24/11/2008     ABIRAMI CHIDAMBARAM   Code Population
******************************************************************************/
   PROCEDURE getstudyabroad (
      stud_crse_year_id_in   IN              VARCHAR2,
      study_abroad_out       OUT NOCOPY      VARCHAR2,
      erasmus_out            OUT NOCOPY      VARCHAR2,
      stud_country_out       OUT NOCOPY      VARCHAR2,
      startdate_out          OUT NOCOPY      VARCHAR2,
      enddate_out            OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT study_abroad, erasmus, study_country, start_date_abroad,
             end_date_abroad
        INTO study_abroad_out, erasmus_out, stud_country_out, startdate_out,
             enddate_out
        FROM stud_crse_year
       WHERE stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudyabroad;

   PROCEDURE setstudyabroad (
      stud_crse_year_id_in   IN              VARCHAR2,
      study_abroad_in        IN              VARCHAR2,
      erasmus_in             IN              VARCHAR2,
      stud_country_in        IN              VARCHAR2,
      startdate_in           IN              VARCHAR2,
      enddate_in             IN              VARCHAR2,
      user_in                IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_crse_year
         SET study_abroad = UPPER (study_abroad_in),
             erasmus = UPPER (erasmus_in),
             study_country = stud_country_in,
             start_date_abroad = startdate_in,
             end_date_abroad = enddate_in,
             last_updated_by = UPPER (user_in),
             last_updated_on = SYSDATE
       WHERE stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setstudyabroad;

   PROCEDURE getstudycountry (
      io_cursor       IN OUT          studycountry_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
      sc_cursor   studycountry_cursor;
   BEGIN
      OPEN sc_cursor FOR
         SELECT   c.country_code AS country_code, c.long_name AS long_name
             FROM country c
         ORDER BY c.long_name ASC;

      io_cursor := sc_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudycountry;

   PROCEDURE checkcourseabroadeligible (
      stud_crse_year_id_in   IN       VARCHAR2,
      study_abroad_out       OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
      v_crse_year_id   NUMBER;
   BEGIN
      ERROR_TEXT := 'Getting students course.';

      SELECT scy.crse_year_id
        INTO v_crse_year_id
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      ERROR_TEXT := 'Checking course eligibility.';

      SELECT cy.study_abroad
        INTO study_abroad_out
        FROM crse_year@grass cy
       WHERE cy.crse_year_id = v_crse_year_id;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || ' SQLCODE=' || SQLCODE || ' SQL ERROR = '
            || SQLERRM;
   END checkcourseabroadeligible;
END pk_steps_ui_study_abroad;
/