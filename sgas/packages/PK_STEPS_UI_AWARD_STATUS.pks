CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_UI_AWARD_STATUS AS
/******************************************************************************
   NAME:       PK_STEPS_UI_AWARD_STATUS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/10/2015  Suresh Sharada   1. Created this package.
******************************************************************************/

  TYPE award_status_cursor IS REF CURSOR;

PROCEDURE insertawardstatus (
      stud_crse_year_id_in         IN       NUMBER,
      award_type_in                IN       VARCHAR2,
      award_status_message_id_in   IN       NUMBER,
      cancelled_ind_in              IN       VARCHAR2,
      user_id_in                    IN      VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2
   );

   PROCEDURE getawardstatus (
      stud_crse_year_id_in   IN              NUMBER,
      io_cursor           IN OUT          award_status_cursor,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

PROCEDURE updateawardstatus (           
      stud_crse_year_id_in        		IN       VARCHAR2,
      fees_in                     		IN       VARCHAR2,
      loan_in                     		IN       VARCHAR2,
      lp_grant_in                 		IN       VARCHAR2,
      bursary_in                  		IN       VARCHAR2,
      dep_grant_in                		IN       VARCHAR2,
      care_exp_bursary_in         		IN       VARCHAR2,
      pg_ed_psych_fees_in         		IN       VARCHAR2,
      pg_ed_psych_qeps_in         		IN       VARCHAR2,
      pg_ed_psych_grant_in        		IN       VARCHAR2,	  
      pg_ed_psych_fees_phd_in       	IN       VARCHAR2,
      pg_ed_psych_grant_phd_in        	IN       VARCHAR2,
      user_id_in                  		IN       VARCHAR2,
      error_boolean               		OUT      VARCHAR2,
      ERROR_TEXT                  		OUT      VARCHAR2
   );

PROCEDURE updateawardstatusNMSB (      
      stud_crse_year_id_in        IN       VARCHAR2,
      nmsb_fees_in                IN       VARCHAR2,
      nmsbbursary_in              IN       VARCHAR2,
      nmsb_dep_allow_in           IN       VARCHAR2,
      nmsb_sp_allow_in            IN       VARCHAR2,
      nmsb_childcare_allow_in     IN       VARCHAR2,
      user_id_in                  IN       VARCHAR2,
      error_boolean               OUT      VARCHAR2,
      ERROR_TEXT                  OUT      VARCHAR2
   );
   
   PROCEDURE updateawardstatuswithID (
      
      stud_crse_year_id_in        IN       NUMBER,
      award_type_in               IN       VARCHAR2,
      award_status_message_id_in  IN       NUMBER,
      user_id_in                  IN       VARCHAR2,
      error_boolean               OUT      VARCHAR2,
      ERROR_TEXT                  OUT      VARCHAR2
   );
   
   PROCEDURE getawardstatusmessages (
      io_cursor           IN OUT          award_status_cursor,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

END PK_STEPS_UI_AWARD_STATUS;
/
