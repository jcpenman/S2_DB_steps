/* Formatted on 2010/10/20 16:44 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_nmsb_placement_exp
AS
/******************************************************************************
   NAME:       PK_STEPS_UI_NMSB_PLACEMENT_EXP
   PURPOSE:

   REVISIONS:
   Ver        Date          Author                  Description
   ---------  ----------    ---------------         ------------------------------------
   1.0        28/01/2010    Abirami Chidambaram     1. Created and populated this package body.
******************************************************************************/
   TYPE placementexp_cursor IS REF CURSOR;

/*
 * Retreive NMSB Placement Expenses records
 */
   PROCEDURE getnmsbplacementexp (
      stud_crse_year_id_in   IN              NUMBER,
      io_cursor              IN OUT          placementexp_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   /*
    * Create NMSB Placement Expenses records
    */
   PROCEDURE addnmsbplacementexp (
      stud_ref_no_in        IN       NUMBER,
      stud_session_id_in    IN       NUMBER,
      payment_due_date_in   IN       DATE,
      amount_in             IN       NUMBER,
      debt_recovered_in     IN       NUMBER,
      payee_ref_in          IN       VARCHAR2,
      user_in               IN       VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2,
      row_count             OUT      VARCHAR2
   );

   PROCEDURE removeplacementexpense (
      award_instalment_id_in   IN              VARCHAR2,
      error_boolean            OUT NOCOPY      VARCHAR2,
      ERROR_TEXT               OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_nmsb_placement_exp;
/