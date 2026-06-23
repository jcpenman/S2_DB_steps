CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_award
AS
/******************************************************************************
   NAME:       PK_STEPS_UI_AWARD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008  PADDY GRACE      Created this package.
   1.1        21/02/2013  Paddy Grace      Added new field to getawardgeneralinfo
   1.2        30/01/2020  Clark Bolan      added new setdmstask procedure
   1.3        06/07/2021  Clark Bolan      new debt only feature    
   1.4          09/12/2021  Ranj Benning       Timing of Payments
******************************************************************************/
   PROCEDURE getawarded (
      stud_crse_year_id_in   	IN              VARCHAR2,
      calc_fee               	OUT NOCOPY      VARCHAR2,
      assess_loan            	OUT NOCOPY      VARCHAR2,
      calc_loan              	OUT NOCOPY      VARCHAR2,
      calc_bursary           	OUT NOCOPY      VARCHAR2,
      calc_sma               	OUT NOCOPY      VARCHAR2,
      calc_dep_grant         	OUT NOCOPY      VARCHAR2,
      calc_lpg               	OUT NOCOPY      VARCHAR2,
      calc_lpcg              	OUT NOCOPY      VARCHAR2,
      nmsb_init_expenses     	OUT NOCOPY      VARCHAR2,
      calc_nmsb              	OUT NOCOPY      VARCHAR2,
      calc_spa               	OUT NOCOPY      VARCHAR2,
      calc_cesb              	OUT NOCOPY      VARCHAR2,
      calc_pgedpsych_grant   	OUT NOCOPY      VARCHAR2,
      calc_pgedpsych_fees    	OUT NOCOPY      VARCHAR2,
      calc_pgedpsych_qeps    	OUT NOCOPY      VARCHAR2,
      calc_sag               	OUT NOCOPY      VARCHAR2,
      calc_pgedpsych_grant_phd  OUT NOCOPY      VARCHAR2,
      calc_pgedpsych_fees_phd	OUT NOCOPY      VARCHAR2,	  
      error_boolean          	OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             	OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setawarded (
      stud_crse_year_id_in    		IN              VARCHAR2,
      calc_fee_in             		IN              VARCHAR2,
      assess_loan_in          		IN              VARCHAR2,
      calc_loan_in            		IN              VARCHAR2,
      calc_bursary_in         		IN              VARCHAR2,
      calc_sma_in             		IN              VARCHAR2,
      calc_dep_grant_in       		IN              VARCHAR2,
      calc_lpg_in             		IN              VARCHAR2,
      calc_lpcg_in            		IN              VARCHAR2,
      nmsb_init_expenses_in   		IN              VARCHAR2,
      calc_nmsb_in            		IN              VARCHAR2,
      calc_spa_in             		IN              VARCHAR2,
      calc_cesb_in            		IN              VARCHAR2,
      calc_pgedpsych_grant_in 		IN              VARCHAR2,
      calc_pgedpsych_fees_in  		IN              VARCHAR2,
      calc_pgedpsych_qeps_in  		IN              VARCHAR2, 
      calc_sag_in             		IN              VARCHAR2,   
      calc_pgedpsych_grant_phd_in 	IN              VARCHAR2,
      calc_pgedpsych_fees_phd_in	IN              VARCHAR2,	  
      error_boolean           		OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              		OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getdebtinformation (
      stud_ref_no_in    IN       VARCHAR2,
      debt_amount       OUT      VARCHAR2,
      deferred_amount   OUT      VARCHAR2,
      debt_status       OUT      VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   );

   PROCEDURE setdebtinformation (
      stud_ref_no_in    IN       VARCHAR2,
      deferred_amount   IN       VARCHAR2,
      debt_status       IN       VARCHAR2,
      debt_amount       IN       VARCHAR2,
      row_count         OUT      VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   );

   PROCEDURE getawardgeneralinfo (
      stud_crse_year_id_in   IN       VARCHAR2,
      stud_session_id_in     IN       VARCHAR2,
      date_app_rcvd          OUT      VARCHAR2,
      date_web_app_sub       OUT      VARCHAR2,
      orig_proc_date         OUT      VARCHAR2,
      last_employee          OUT      VARCHAR2,
      original_employee      OUT      VARCHAR2,
      last_calc_date         OUT      DATE,
      last_letter_date       OUT      VARCHAR2,
      no_award_ltrs_issued   OUT      VARCHAR2,
      award_given            OUT      VARCHAR2,
      sal_destination        OUT      VARCHAR2,
      remark                 OUT      VARCHAR2,
      session_code_out       OUT      VARCHAR2,
      student_status_out     OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE setawardgeneralinfo (
      stud_crse_year_id_in   IN       VARCHAR2,
      sal_destination        IN       VARCHAR2,
      remark_in              IN       VARCHAR2,
      employee_in            IN       VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE checkprevincomeprov (
      stud_ref_no_in    IN       VARCHAR2,
      session_code_in   IN       VARCHAR2,
      prov_flag         OUT      VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   );

   PROCEDURE validateawardnotice (
      stud_crse_year_id_in   IN       VARCHAR2,
      is_valid               OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE settotaldebt (
      stud_ref_no_in       IN       VARCHAR2,
      def_overpayment_in   IN       VARCHAR2,
      overpayment_in       IN       VARCHAR2,
      debt_status          IN       VARCHAR2,
      system_user          IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   );

   PROCEDURE settotalnmsbdebt (
      stud_ref_no_in           IN       VARCHAR2,
      snb_def_overpayment_in   IN       VARCHAR2,
      snb_overpayment_in       IN       VARCHAR2,
      debt_status              IN       VARCHAR2,
      system_user              IN       VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   );

   PROCEDURE getnmsbdebtinformation (
      stud_ref_no_in        IN       VARCHAR2,
      snb_debt_amount       OUT      VARCHAR2,
      snb_deferred_amount   OUT      VARCHAR2,
      debt_status           OUT      VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2
   );

   PROCEDURE getpaymenttypecount (
      stud_ref_no_in        IN       VARCHAR2,
      session_code_in       IN       VARCHAR2,
      installment_type_in   IN       VARCHAR2,
      payment_count_out     OUT      VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2
   );
/*   
    PROCEDURE setdmstask (  
    stud_ref_no_in        IN       NUMBER,
    created_by_in         IN       VARCHAR2,
    details_in            IN       VARCHAR2,  
    error_boolean         OUT      VARCHAR2,
    ERROR_TEXT            OUT      VARCHAR2
    );
*/    
    PROCEDURE getDebtOnly(
    stud_crse_year_id_in  IN       NUMBER,
    debt_only_out         OUT      VARCHAR2,
    error_boolean         OUT      VARCHAR2,
    ERROR_TEXT            OUT      VARCHAR2
    );
    
    PROCEDURE setDebtOnly(
    stud_crse_year_id_in  IN       NUMBER,
    debt_only_in          IN       VARCHAR2,
    system_user_in        IN       VARCHAR2,
    error_boolean         OUT      VARCHAR2,
    ERROR_TEXT            OUT      VARCHAR2
    );

   PROCEDURE gettimingofpayments (
      stud_session_id_in     IN       VARCHAR2,
      top_option_out         OUT      VARCHAR2,
      top_changed_out         OUT      VARCHAR2,      
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );    

   PROCEDURE settimingofpayments (
      stud_session_id_in     IN       VARCHAR2,
      top_option_in          IN       VARCHAR2,
      top_changed_out         OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );    
   
END pk_steps_ui_award;
/
