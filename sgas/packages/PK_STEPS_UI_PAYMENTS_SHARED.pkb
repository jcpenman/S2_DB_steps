CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_payments_shared
AS
/******************************************************************************
   NAME:       pk_steps_ui_MANUAL_PAYMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        04/10/2010      PADDY GRACE           Created this package.
******************************************************************************/
   PROCEDURE getstudentsawardtypes (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   sat_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   AS
      studsawardtypes_cursor   sat_cursor;
   BEGIN
      OPEN studsawardtypes_cursor FOR
         SELECT a.award_id, a.stud_award_type, a.award_type_descript,
                a.amount, a.overpayment_amount, a.contrib_amount,
                a.net_amount, a.recovered_amount
           FROM award a, stud_award_type sat
          WHERE a.stud_award_type = sat.stud_award_type
            AND a.stud_crse_year_id = stud_crse_year_id_in
            AND a.award_src = 'A'
            AND sat.saas_make_payment = 'Y';

      io_cursor := studsawardtypes_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' - '
            || 'ERROR : PL SQL Procedure : getstudentsawardtypes : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getstudentsawardtypes;

   PROCEDURE getpaymentdates (
      session_code_in   IN       VARCHAR2,
      io_cursor         IN OUT   pd_cursor,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   AS
      paydate_cursor   pd_cursor;
      v_start_date     DATE;
      v_end_date       DATE;
   BEGIN
      v_start_date := TO_DATE ('01-08-' || session_code_in, 'dd-MM-YYYY');

      OPEN paydate_cursor FOR
         SELECT TO_CHAR (pd.payment_date, 'dd-MM-YYYY') AS payment_date
           FROM payment_dates@grass pd
          WHERE pd.payment_date BETWEEN TO_DATE ('01-08-' || session_code_in,
                                                 'dd-MM-YYYY'
                                                )
                                    AND TO_DATE (   '31-12-' 
                                                 || (session_code_in + 2),
                                                 'dd-MM-YYYY'
                                                );

      io_cursor := paydate_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' - '
            || 'ERROR : PL SQL Procedure : getpaymentdates : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getpaymentdates;
END pk_steps_ui_payments_shared;
/